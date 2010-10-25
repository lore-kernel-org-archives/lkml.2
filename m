Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab0JZAJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:09:21 -0400
Received: from hartman.uits.indiana.edu ([129.79.1.194]:39799 "EHLO
	internal-relay.indiana.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757108Ab0JZAJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:09:20 -0400
X-Greylist: delayed 1275 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2010 20:09:19 EDT
Message-ID: <4CC61731.1080100@indiana.edu>
Date: Mon, 25 Oct 2010 19:48:01 -0400
From: William Sherman <shermanw@indiana.edu>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.12) Gecko/20100824 Thunderbird/3.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: William Sherman <shermanw@indiana.edu>
Subject: usbhid: HP LD4200tm touchscreen ALMOST works
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm looking to dig into the usbhid driver code to get me the last
mile and get my HP LD4200tm touchscreen working on my Linux system.
[NOTE: I posted about this elsewhere, but as I think about it more,
this is more of a linux-kernel issue than anything else, so I'm
reprising that note here.]

So, in first connecting the HP touchscreen (with touchscreen hardware
from Nexio) to the Linux system (running Ubuntu 10.10 -- 2.6.35-22 generic)
things were looking up, as the unit almost worked right out of the box
as a plug-and-play device.  Unfortunately, that last mile needs to be
addressed in order for the unit to work in a useful way.  I think I've
narrowed down the problem to the usbhid driver, as I'll explain in a
moment, and while I expect I have the ability to debug and fix the issue,
this would be my first dive into Linux driver coding, so I could probably
use a pointer as to what steps are necessary to get the proper kernel
sources, compile the needed parts and restart the system (hopefully
just restart X-windows) to test my edits (especially since Ubuntu tends
to not include a not of the necessary components).

I've collected gobs of data on what udev, hidraw, evtest and X-windows
report, but before I get to any of that, here's the executive summary:

Plugging the HP LD4200tm into a Ubuntu 10.10 system will cause the
device to be recognized, create a usbhid device, create an event device,
activate the evdev driver for Xorg, and put it on the list of X's inputs.
So far, so good.

Touching the device causes the mouse pointer to jump to that location,
even better.

But when I'm touching the screen, what happens is that the system
generates a continuous stream of button presses/releases -- as if
I moved the mouse to a particular location and then went crazy
tapping on the mouse button.  This is the part that makes the system
unusable.

One more data point is that if I touch the screen with a second
finger, the button barrage stops, and it will now gracefully report
the movement of the first finger.

So all I need to do is modify the driver for this device's protocol
to not send all the unnecessary release/press events.


Here is the data that leads me to believe the issue is at the usbhid
layer:


1) Running "evtest /dev/input/event4" reveals that the button barrage
is already occurring at the HID event layer.

2) Watching the raw data on /dev/usb/hiddev2 does report a stream of
data as the touchscreen is touched (and no data when it's not touched),
looking at the output suggests that the device is only reporting touch/
release events when the screen is actually touched or released.  And of
course, even if the device were reporting things poorly, I figure the
usbhid driver could be written to overcome this.

Fortunately, the data seems to be a constant 14-byte stride, so I
wrote a simple awk script ("nexio") to reformat the data as I was
figuring out the raw protocol.  Here's a sample of the reformatted
data, followed by my estimation of the protocol:
         % sudo xxd -c 14 -g 1 /dev/hidraw2 | nexio
         0000000: 01 03 01 12d8 3357  02 02 15e1 1f71  01
         000000e: 01 03 01 12cc 332a  02 02 15e1 1f71  01
         000001c: 01 03 01 12de 3335  00 02 15e1 1f71  01
         000002a: 01 03 01 12f4 3346  00 02 15e1 1f71  01
         0000038: 01 03 01 1304 3352  00 02 15e1 1f71  01
         0000046: 01 03 01 130c 3358  00 02 15e1 1f71  01
         [... (next I stop touching the screen, and then touch it again)]
         00009a0: 01 03 01 12d8 3357  00 02 15e1 1f71  01
         00009ae: 01 03 01 12d8 3357  00 02 15e1 1f71  01
         00009bc: 01 02 01 12d8 3357  00 02 15e1 1f71  01
         00009ca: 01 03 01 10af 3681  02 02 15e1 1f71  01
         00009d8: 01 03 01 10a5 3651  02 02 15e1 1f71  01
         00009e6: 01 03 01 10b7 3654  00 02 15e1 1f71  01
         [... (next is a multi-touch event)]
         0000c78: 01 03 01 1019 3627  00 02 15e1 1f71  01
         0000c86: 01 03 01 1019 3627  00 02 15e1 1f71  01
         0000c94: 01 00 01 100b 35f8  00 02 1585 3110  00
         0000ca2: 01 00 01 100e 3604  00 02 158a 311b  00
         0000cb0: 01 00 01 1013 3615  00 02 1591 312b  00
         0000cbe: 01 00 01 1017 3622  00 02 1596 3136  00
         0000ccc: 01 00 01 1019 3628  00 02 1598 313c  00
         0000cda: 01 00 01 1019 3629  00 02 1599 313d  00
         0000ce8: 01 03 01 1019 3629  03 02 1598 313d  02
         0000cf6: 01 03 01 1019 3628  03 02 1598 313c  02
         0000d04: 01 03 01 1019 3627  03 02 1598 313b  02
         0000d12: 01 03 01 1018 3627  03 02 1597 313a  02
         [... (next I release both fingers -- not quite simultaneously)]
         0000df2: 01 03 01 1019 3627  03 02 1598 3132  02
         0000e00: 01 03 01 1019 3627  03 02 1598 3132  02
         0000e0e: 01 03 01 1019 3627  02 02 1598 3132  01
         0000e1c: 01 03 01 1019 3626  02 02 1598 3132  01
         0000e2a: 01 03 01 1019 3626  00 02 1598 3132  01
         0000e38: 01 03 01 1019 3626  00 02 1598 3132  01
         0000e46: 01 03 01 1019 3626  00 02 1598 3132  01
         0000e54: 01 03 01 1019 3626  00 02 1598 3132  01
         0000e62: 01 03 01 1019 3625  00 02 1598 3132  01
         0000e70: 01 02 01 1019 3625  00 02 1598 3132  01

Decoding the above:
- column 1: just a reprint of the xxd byte count
- column 2: always 01 -- probably a data packet sync byte
- column 3: usually 03 (which means an on-going touch event)
		- 02 seems to indicate a touch-release event
		- 00 seems to indicate a transition to a dual-touch event
- column 4: always 01 -- probably an indicator that the next two
		words are the X/Y values for touch #1
- column 5: value of X location of touch #1
- column 6: value of Y location of touch #1
- column 7: usually 00
		- 02 seems to mean initiation of a single-touch event
		- 03 seems to indicate an on-going dual-touch event
- column 8: always 02 -- probably an indicator that the next two
		words are the X/Y values for touch #2
- column 9: value of X location of touch #2
- column 10:value of Y location of touch #2
- column 11: usually 01 or 02 representing the number of contact points
		- will be 00 when transitioning from single to dual
		  contact touch event

The rest of this email is a sample of some of the data that I've
collected about what the system reports.  I think this should be
sufficient to get across all necessary information, but I have
more if warrented.

         % xinput list --short 10
         Nexio Touch Device.   HID Multi-Touch           id=10   [slave 
  pointer  (2)]
         % xinput test 10
         motion a[0]=15177 a[1]=5581 a[2]=15479 a[3]=7829 a[4]=0 a[5]=0
         motion a[6]=0 a[7]=0 a[8]=0 a[9]=0 a[10]=0
         button press   1
         button release 1
         button press   1
         button release 1
         button press   1
         button release 1
         button press   1
         button release 1
         button press   1
         button release 1
         button press   1
         button release 1
         [...]

So you can see that at first contact the location of the touch is reported,
but then there is the continual stream of button press/release.

Here is the output from "evtest" from a single finger interaction:
     % sudo evtest /dev/input/event4
     Input driver version is 1.0.1
     Input device ID: bus 0x3 vendor 0x1870 product 0x100 version 0x111
     Input device name: "Nexio Touch Device.   HID Multi-Touch"
     Supported events:
       Event type 0 (Sync)
       Event type 1 (Key)
         Event code 272 (LeftBtn)
         Event code 273 (RightBtn)
         Event code 274 (MiddleBtn)
         Event code 320 (ToolPen)
         Event code 321 (ToolRubber)
         Event code 322 (ToolBrush)
         Event code 330 (Touch)
       Event type 3 (Absolute)
         Event code 0 (X)
           Value  15129
           Min        0
           Max    16383
         Event code 1 (Y)
           Value   6425
           Min        0
           Max    16383
         Event code 2 (Z)
           Value  14859
           Min        0
           Max    16383
         Event code 3 (Rx)
           Value   7160
           Min        0
           Max    16383
         Event code 4 (Ry)
           Value      0
           Min        0
           Max    32767
         Event code 5 (Rz)
           Value      0
           Min        0
           Max    32767
         Event code 6 (Throttle)
           Value      0
           Min        0
           Max    16383
         Event code 7 (Rudder)
           Value      0
           Min        0
           Max    16383
         Event code 40 (Misc)
           Value      1
           Min        0
           Max        1
         Event code 41 (?)
           Value      2
           Min        0
           Max        1
         Event code 42 (?)
           Value      1
           Min        0
           Max        2
       Event type 4 (Misc)
         Event code 4 (ScanCode)
     Testing ... (interrupt to exit)
     Event: time 1287784276.760109, type 4 (Misc), code 4 (ScanCode), 
value d0042
     Event: time 1287784276.760112, type 1 (Key), code 330 (Touch), value 1
     Event: time 1287784276.760119, type 3 (Absolute), code 0 (X), value 
14976
     Event: time 1287784276.760122, type 3 (Absolute), code 1 (Y), value 
7291
     Event: time 1287784276.760125, type 4 (Misc), code 4 (ScanCode), 
value d0042
     Event: time 1287784276.760127, type 1 (Key), code 330 (Touch), value 0
     Event: time 1287784276.760130, type 1 (Key), code 321 (ToolRubber), 
value 1
     Event: time 1287784276.760139, -------------- Report Sync ------------
     Event: time 1287784276.773107, type 4 (Misc), code 4 (ScanCode), 
value d0042
     Event: time 1287784276.773111, type 1 (Key), code 330 (Touch), value 1
     Event: time 1287784276.773117, type 3 (Absolute), code 0 (X), value 
14925
     Event: time 1287784276.773120, type 3 (Absolute), code 1 (Y), value 
7266
     Event: time 1287784276.773123, type 4 (Misc), code 4 (ScanCode), 
value d0042
     Event: time 1287784276.773124, type 1 (Key), code 330 (Touch), value 0
     Event: time 1287784276.773135, -------------- Report Sync ------------
     Event: time 1287784276.785094, type 4 (Misc), code 4 (ScanCode), 
value d0042
     Event: time 1287784276.785099, type 1 (Key), code 330 (Touch), value 1
     Event: time 1287784276.785105, type 3 (Absolute), code 0 (X), value 
14937
     Event: time 1287784276.785108, type 3 (Absolute), code 1 (Y), value 
7269
     Event: time 1287784276.785112, type 4 (Misc), code 4 (ScanCode), 
value d0042
     Event: time 1287784276.785113, type 1 (Key), code 330 (Touch), value 0
     Event: time 1287784276.785116, type 1 (Key), code 321 (ToolRubber), 
value 0
     Event: time 1287784276.785125, -------------- Report Sync ------------
     ^C

And here is the output of "evtest" from when I touched the screen with
two fingers:
     % sudo evtest /dev/input/event4
     Input driver version is 1.0.1
     Input device ID: bus 0x3 vendor 0x1870 product 0x100 version 0x111
     Input device name: "Nexio Touch Device.   HID Multi-Touch"
     Supported events:
       Event type 0 (Sync)
       Event type 1 (Key)
         Event code 272 (LeftBtn)
         Event code 273 (RightBtn)
         Event code 274 (MiddleBtn)
         Event code 320 (ToolPen)
         Event code 321 (ToolRubber)
         Event code 322 (ToolBrush)
         Event code 330 (Touch)
       Event type 3 (Absolute)
         Event code 0 (X)
           Value  14937
           Min        0
           Max    16383
         Event code 1 (Y)
           Value   7269
           Min        0
           Max    16383
         Event code 2 (Z)
           Value  14859
           Min        0
           Max    16383
         Event code 3 (Rx)
           Value   7160
           Min        0
           Max    16383
         Event code 4 (Ry)
           Value      0
           Min        0
           Max    32767
         Event code 5 (Rz)
           Value      0
           Min        0
           Max    32767
         Event code 6 (Throttle)
           Value      0
           Min        0
           Max    16383
         Event code 7 (Rudder)
           Value      0
           Min        0
           Max    16383
         Event code 40 (Misc)
           Value      1
           Min        0
           Max        1
         Event code 41 (?)
           Value      2
           Min        0
           Max        1
         Event code 42 (?)
           Value      1
           Min        0
           Max        2
       Event type 4 (Misc)
         Event code 4 (ScanCode)
     Testing ... (interrupt to exit)
     Event: time 1287784360.966997, type 1 (Key), code 320 (ToolPen), 
value 0
     Event: time 1287784360.967004, type 3 (Absolute), code 0 (X), value 
14717
     Event: time 1287784360.967006, type 3 (Absolute), code 1 (Y), value 
6211
     Event: time 1287784360.967014, type 3 (Absolute), code 2 (Z), value 
15680
     Event: time 1287784360.967016, type 3 (Absolute), code 3 (Rx), 
value 6211
     Event: time 1287784360.967019, type 3 (Absolute), code 42 (?), value 0
     Event: time 1287784360.967020, -------------- Report Sync ------------
     Event: time 1287784360.979997, type 3 (Absolute), code 0 (X), value 
14667
     Event: time 1287784360.980001, type 3 (Absolute), code 1 (Y), value 
6189
     Event: time 1287784360.980008, type 3 (Absolute), code 2 (Z), value 
15626
     Event: time 1287784360.980011, type 3 (Absolute), code 3 (Rx), 
value 6189
     Event: time 1287784360.980014, -------------- Report Sync ------------
     Event: time 1287784360.992997, type 3 (Absolute), code 0 (X), value 
14684
     Event: time 1287784360.993000, type 3 (Absolute), code 1 (Y), value 
6195
     Event: time 1287784360.993008, type 3 (Absolute), code 2 (Z), value 
15640
     Event: time 1287784360.993011, type 3 (Absolute), code 3 (Rx), 
value 6195
     Event: time 1287784360.993014, -------------- Report Sync ------------
     Event: time 1287784361.005998, type 3 (Absolute), code 0 (X), value 
14715
     Event: time 1287784361.006001, type 3 (Absolute), code 1 (Y), value 
6220
     Event: time 1287784361.006008, type 3 (Absolute), code 2 (Z), value 
15660
     Event: time 1287784361.006011, type 3 (Absolute), code 3 (Rx), 
value 6220
     Event: time 1287784361.006014, -------------- Report Sync ------------
     Event: time 1287784361.018000, type 3 (Absolute), code 0 (X), value 
14745
     Event: time 1287784361.018004, type 3 (Absolute), code 1 (Y), value 
6278
     Event: time 1287784361.018012, type 3 (Absolute), code 2 (Z), value 
15674
     Event: time 1287784361.018014, type 3 (Absolute), code 3 (Rx), 
value 6278
     Event: time 1287784361.018017, -------------- Report Sync ------------
     Event: time 1287784361.030997, type 3 (Absolute), code 0 (X), value 
14767
     Event: time 1287784361.031000, type 3 (Absolute), code 1 (Y), value 
6358
     Event: time 1287784361.031008, type 3 (Absolute), code 2 (Z), value 
15680
     Event: time 1287784361.031010, type 3 (Absolute), code 3 (Rx), 
value 6358
     Event: time 1287784361.031013, -------------- Report Sync ------------
     Event: time 1287784361.043996, type 4 (Misc), code 4 (ScanCode), 
value d0042
     Event: time 1287784361.043999, type 1 (Key), code 330 (Touch), value 1
     Event: time 1287784361.044001, type 1 (Key), code 320 (ToolPen), 
value 1
     Event: time 1287784361.044006, type 3 (Absolute), code 0 (X), value 
14777
     Event: time 1287784361.044008, type 3 (Absolute), code 1 (Y), value 
6451
     Event: time 1287784361.044012, type 1 (Key), code 321 (ToolRubber), 
value 1
     Event: time 1287784361.044016, type 3 (Absolute), code 2 (Z), value 
15682
     Event: time 1287784361.044019, type 3 (Absolute), code 3 (Rx), 
value 6451
     Event: time 1287784361.044021, type 3 (Absolute), code 42 (?), value 2
     Event: time 1287784361.044023, -------------- Report Sync ------------
     Event: time 1287784361.057000, type 3 (Absolute), code 0 (X), value 
14779
     Event: time 1287784361.057004, type 3 (Absolute), code 1 (Y), value 
6546
     Event: time 1287784361.057012, type 3 (Absolute), code 3 (Rx), 
value 6546
     Event: time 1287784361.057016, -------------- Report Sync ------------
     Event: time 1287784361.069998, type 3 (Absolute), code 0 (X), value 
14778
     Event: time 1287784361.070001, type 3 (Absolute), code 1 (Y), value 
6640
     Event: time 1287784361.070009, type 3 (Absolute), code 2 (Z), value 
15681
     Event: time 1287784361.070011, type 3 (Absolute), code 3 (Rx), 
value 6640
     Event: time 1287784361.070014, -------------- Report Sync ------------
     Event: time 1287784361.081989, type 3 (Absolute), code 0 (X), value 
14776
     Event: time 1287784361.081992, type 3 (Absolute), code 1 (Y), value 
6733
     Event: time 1287784361.082000, type 3 (Absolute), code 2 (Z), value 
15680
     Event: time 1287784361.082002, type 3 (Absolute), code 3 (Rx), 
value 6733
     Event: time 1287784361.082005, -------------- Report Sync ------------
     Event: time 1287784361.094987, type 3 (Absolute), code 0 (X), value 
14775
     Event: time 1287784361.094990, type 3 (Absolute), code 1 (Y), value 
6832
     Event: time 1287784361.094998, type 3 (Absolute), code 2 (Z), value 
15679
     Event: time 1287784361.095000, type 3 (Absolute), code 3 (Rx), 
value 6832
     Event: time 1287784361.095004, -------------- Report Sync ------------
     Event: time 1287784361.107986, type 3 (Absolute), code 0 (X), value 
14774
     Event: time 1287784361.107990, type 3 (Absolute), code 1 (Y), value 
6939
     Event: time 1287784361.107999, type 3 (Absolute), code 3 (Rx), 
value 6939
     Event: time 1287784361.108002, -------------- Report Sync ------------
     Event: time 1287784361.121001, type 3 (Absolute), code 1 (Y), value 
7042
     Event: time 1287784361.121011, type 3 (Absolute), code 3 (Rx), 
value 7042
     Event: time 1287784361.121014, -------------- Report Sync ------------
     Event: time 1287784361.132987, type 3 (Absolute), code 0 (X), value 
14779
     Event: time 1287784361.132991, type 3 (Absolute), code 1 (Y), value 
7138
     Event: time 1287784361.132999, type 3 (Absolute), code 3 (Rx), 
value 7138
     Event: time 1287784361.133003, -------------- Report Sync ------------
     Event: time 1287784361.145998, type 3 (Absolute), code 0 (X), value 
14794
     Event: time 1287784361.146001, type 3 (Absolute), code 1 (Y), value 
7221
     Event: time 1287784361.146010, type 3 (Absolute), code 3 (Rx), 
value 7221
     Event: time 1287784361.146014, -------------- Report Sync ------------
     Event: time 1287784361.158999, type 3 (Absolute), code 0 (X), value 
14815
     Event: time 1287784361.159003, type 3 (Absolute), code 1 (Y), value 
7284
     Event: time 1287784361.159010, type 3 (Absolute), code 2 (Z), value 
15684
     Event: time 1287784361.159012, type 3 (Absolute), code 3 (Rx), 
value 7284
     Event: time 1287784361.159016, -------------- Report Sync ------------
     Event: time 1287784361.183994, type 4 (Misc), code 4 (ScanCode), 
value d0042
     Event: time 1287784361.183996, type 1 (Key), code 330 (Touch), value 0
     Event: time 1287784361.184014, -------------- Report Sync ------------
     ^C

So you can see that the location of both fingers is reported for the
multi-touch operation (with one finger reported as X & Y, and the
second finger as Z & Rx).  But with one finger, it's a bunch of button
presses and then nearly instantaneous releases.


And one final bit of information.  Here is the relevant information from
the udev.log:
     -----------------------------
     UDEV  [1287664208.316717] add 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input4/event4 
(input)
     UDEV_LOG=3
     ACTION=add
 
DEVPATH=/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input4/event4
     SUBSYSTEM=input
     DEVNAME=/dev/input/event4
     SEQNUM=1272
     ID_INPUT=1
     ID_INPUT_TABLET=1
     ID_VENDOR=Nexio_Touch_Device.
     ID_VENDOR_ENC=Nexio\x20Touch\x20Device.\x20\x20
     ID_VENDOR_ID=1870
     ID_MODEL=HID_Multi-Touch
     ID_MODEL_ENC=HID\x20Multi-Touch
     ID_MODEL_ID=0100
     ID_REVISION=0006
     ID_SERIAL=Nexio_Touch_Device._HID_Multi-Touch
     ID_TYPE=hid
     ID_BUS=usb
     ID_USB_INTERFACES=:030000:
     ID_USB_INTERFACE_NUM=00
     ID_USB_DRIVER=usbhid
     ID_PATH=pci-0000:00:1d.2-usb-0:2:1.0
     MAJOR=13
     MINOR=68
     DEVLINKS=/dev/char/13:68 
/dev/input/by-id/usb-Nexio_Touch_Device._HID_Multi-Touch-event-mouse 
/dev/input/by-path/pci-0000:00:1d.2-usb-0:2:1.0-event-mouse

     UDEV  [1287664208.316759] add 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input4/mouse1 
(input)
     UDEV_LOG=3
     ACTION=add
 
DEVPATH=/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input4/mouse1
     SUBSYSTEM=input
     DEVNAME=/dev/input/mouse1
     SEQNUM=1273
     ID_INPUT=1
     ID_INPUT_TABLET=1
     ID_VENDOR=Nexio_Touch_Device.
     ID_VENDOR_ENC=Nexio\x20Touch\x20Device.\x20\x20
     ID_VENDOR_ID=1870
     ID_MODEL=HID_Multi-Touch
     ID_MODEL_ENC=HID\x20Multi-Touch
     ID_MODEL_ID=0100
     ID_REVISION=0006
     ID_SERIAL=Nexio_Touch_Device._HID_Multi-Touch
     ID_TYPE=hid
     ID_BUS=usb
     ID_USB_INTERFACES=:030000:
     ID_USB_INTERFACE_NUM=00
     ID_USB_DRIVER=usbhid
     ID_PATH=pci-0000:00:1d.2-usb-0:2:1.0
     MAJOR=13
     MINOR=33
     DEVLINKS=/dev/char/13:33 
/dev/input/by-id/usb-Nexio_Touch_Device._HID_Multi-Touch-mouse 
/dev/input/by-path/pci-0000:00:1d.2-usb-0:2:1.0-mouse
     -----------------------------

And if that isn't enough info, I'm happy to provide more.


     Thanks for whatever suggestions you can provide,
     Bill

-- 
Bill Sherman
Sr. Technology Advisor
Advanced Visualization Lab
Pervasive Technology Inst
Indiana University
shermanw@indiana.edu
