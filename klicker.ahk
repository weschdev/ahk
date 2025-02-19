#Requires AutoHotkey v2.0
#SingleInstance Force

; AutoHotKlicker
; Modified from mikeyww's comment https://www.autohotkey.com/boards/viewtopic.php?t=115527

; CapsLock to enable, click to start.
; CapsLock again to stop.
; SHIFT + Scroll to adjust speed, must be enabled.
; CTRL + ESC to quit.

max_cps := 100   ; Max clicks per second, default is 100, shit gets pretty weird above 150
min_cps := 1     ; Min clicks per second, default is 1, must be an int so idk why you would change it from the default
cps     := 10    ; Starting clicks per second, default is 10 which is the fastest average "legit" click speed
enable  := false ; Does the clicker start enabled, default is false
do_beep := true  ; Should the program make beeps when enabling or disabling, default is true

CapsLock:: { ; Toggle enable hotkey
  global enable := !enable
  if(do_beep) {
    SoundBeep(1000 + (500 * enable))
  }
  if(enable) {
    ToolTip('Click to start @ ' cps ' cps`nCapsLock to stop`nSHIFT + scroll for speed`nCTRL + ESC to quit')
  } else {
    ToolTip('Clicker OFF`nCapsLock to enable`nCTRL + ESC to quit')
  }
  ClearToolTip(5000)
  return
}

^Esc:: { ; Quit hotkey
  ToolTip('Clicker stopping...')
  Sleep(500)
  ExitApp()
}

#HotIf enable ; Only trigger hotkeys if enabled is true
LButton:: { ; Start clicking hotkey
  start := A_TickCount, clicks := 0
  while(enable) {
    Click()
    Sleep(start - A_TickCount + 1000 * ++clicks / cps) ; Some bullshit about average millis between clicks, thank you mikeyww!
    ToolTip(A_Index ' clicks`n@ ' Round(1000 * clicks / (A_TickCount - start)) ' / ' cps ' cps') ; actual / expected cps
  }
  ClearToolTip(250)
  return
}

+WheelUp:: { ; Add 1 cps hotkey
  if(cps < max_cps) {
    global cps := cps + 1
    ToolTip('Speed = ' cps ' cps`nSHIFT + scroll to adjust')
    ClearToolTip(500)
  }
  return
}

+WheelDown:: { ; Subtract 1 cps hotkey
  if(cps > min_cps) {
    global cps := cps - 1
    ToolTip('Speed = ' cps ' cps`nSHIFT + scroll to adjust')
    ClearToolTip(500)
  }
  return
}
#HotIf

ClearToolTip(delay) { ; Removes tooltips after given millisecond delay, cannot be 0
  SetTimer(() => ToolTip(), delay * -1) ; Needs to be negative to make the timer only trigger once and delete itself
  return
}
