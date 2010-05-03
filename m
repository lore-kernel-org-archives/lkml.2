Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab0ECU5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:57:51 -0400
Received: from legolas.restena.lu ([158.64.1.34]:58203 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab0ECU5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:57:50 -0400
Date: Mon, 3 May 2010 22:57:35 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
Message-ID: <20100503225735.6b5e2687@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.1005031557080.1502-100000@iolanthe.rowland.org>
References: <20100503214642.67577f91@neptune.home>
	<Pine.LNX.4.44L0.1005031557080.1502-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 May 2010 Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 3 May 2010, Bruno [UTF-8] PrÃ©mont wrote:
> 
> > On Mon, 03 May 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> > > You might also want to #define VERBOSE_DEBUG at the start of 
> > > drivers/usb/core/driver.c, before the first #include.
> > 
> > Still no difference... (will retry with own printk's in ohci's suspend
> > code as suggested in other mail)
> 
> First of all, have you tried disabling async suspend?  Look at 
> /sys/power/pm_async.
> 
> > Suspend output as it goes:
> 
> Let's just look at the USB entries:
> 
> > [  241.358651] usb usb1: preparing type suspend, may wakeup
> > [  241.364247] usb usb2: preparing type suspend, may wakeup
> > [  241.369847] usb usb3: preparing type suspend, may wakeup
> > [  241.375443] usb usb4: preparing type suspend, may wakeup
> > [  241.381044] usb usb5: preparing type suspend, may wakeup
> > [  241.386643] usb usb6: preparing type suspend, may wakeup
> > [  241.392244] usb 1-2: preparing type suspend, may wakeup
> > [  241.397762] usb 1-2.1: preparing type suspend, may wakeup
> 
> Those are normal.
> 
> > [  241.407504] usbhid 1-2.1:1.1: suspend
> > [  241.407511] usbhid 1-2.1:1.0: suspend
> 
> These are HID suspends for the keyboard and mouse interfaces.
> 
> > [  241.407516] usb 1-2.1: type suspend, may wakeup
> 
> This is a USB suspend for the KB/mouse device.
> 
> > [  241.443340] hub 1-2:1.0: suspend
> 
> Suspend for the embedded hub interface.  Next we should see
> 
> 	[....] usb 1-2: type suspend, may wakeup
> 
> for the embedded hub device, but we don't.  That's the problem.  It 
> must be waiting for something -- goodness knows what.

Could have to do with the node that hid can't initialize?

> > [  241.911502] hub 6-0:1.0: suspend
> > [  241.914928] usb usb6: type suspend, may wakeup
> > [  241.919583] usb usb6: usb_suspend_both: status 0
> > [  241.924448] usb usb6: suspend, may wakeup
> > [  241.928663] hub 5-0:1.0: suspend
> > [  241.932082] usb usb5: type suspend, may wakeup
> > [  241.936794] usb usb5: usb_suspend_both: status 0
> > [  241.941669] usb usb5: suspend, may wakeup
> > [  241.945888] hub 4-0:1.0: suspend
> > [  241.949294] usb usb4: type suspend, may wakeup
> > [  241.953966] usb usb4: usb_suspend_both: status 0
> > [  241.958814] usb usb4: suspend, may wakeup
> > [  241.963069] hub 3-0:1.0: suspend
> > [  241.966452] usb usb3: type suspend, may wakeup
> > [  241.971126] usb usb3: usb_suspend_both: status 0
> > [  241.976015] usb usb3: suspend, may wakeup
> > [  241.980232] hub 2-0:1.0: suspend
> > [  241.983662] usb usb2: type suspend, may wakeup
> > [  241.988316] usb usb2: usb_suspend_both: status 0
> > [  241.993192] usb usb2: suspend, may wakeup
> > [  241.997418] hub 1-0:1.0: suspend
> 
> And here we should see
> 
> 	[....] usb usb1: type suspend, may wakeup
> 	etc.
> 
> but we don't, because it's waiting for the 1-2 device.
> 
> > [  242.125768] ehci_hcd 0000:00:13.5: suspend
> > [  242.130076] ehci_hcd 0000:00:13.5: PCI INT D disabled
> > [  242.135410] ohci_hcd 0000:00:13.4: suspend
> > [  242.139696] ohci_hcd 0000:00:13.4: PCI INT C disabled
> > [  242.145035] ohci_hcd 0000:00:13.3: suspend
> > [  242.149348] ohci_hcd 0000:00:13.3: PCI INT B disabled
> > [  242.154705] ohci_hcd 0000:00:13.2: suspend
> > [  242.159012] ohci_hcd 0000:00:13.2: PCI INT C disabled
> > [  242.164342] ohci_hcd 0000:00:13.1: suspend
> > [  242.168676] ohci_hcd 0000:00:13.1: PCI INT B disabled
> 
> > I guess here PM is waiting for ohci_hcd 0000:00:13.0 to suspend
> > and disable its interrupt.
> > (and that last ohci device would match the usbhid_resume thread that's
> > frozen...)
> 
> The 0000:00:13.0 device can't suspend until usb1 does, and usb1 can't
> suspend until 1-2 does.
> 
> Can you boot the dmesg log for bootup and device detection?  It may 
> indicate what we're missing.  Also include the contents of 
> /sys/kernel/debug/usb/devices.


T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.34-rc6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.4
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.34-rc6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.3
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.34-rc6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.34-rc6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  2/900 us ( 0%), #Int=  2, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.34-rc6 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=12  MxCh= 3
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=058f ProdID=9462 Rev= 1.58
S:  Manufacturer=Multimedia USB Keyboard
S:  Product=Multimedia USB Keyboard
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr= 50mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=255ms

T:  Bus=02 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=058f ProdID=9462 Rev= 4.10
S:  Manufacturer=Multimedia USB Keyboard
S:  Product=Multimedia USB Keyboard
S:  SerialNumber=Multimedia USB Keyboard
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr= 50mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=82(I) Atr=03(Int.) MxPS=   4 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh=10
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 2.06
S:  Manufacturer=Linux 2.6.34-rc6 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:13.5
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms



Loading ubs support, ehci, then ohci:
[  500.990545] usbcore: registered new interface driver usbfs
[  500.996467] usbcore: registered new interface driver hub
[  501.002309] usbcore: registered new device driver usb
[  501.013910] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[  501.021013] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[  501.028714] ehci_hcd 0000:00:13.5: EHCI Host Controller
[  501.034360] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[  501.042385] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
[  501.050441] ehci_hcd 0000:00:13.5: debug port 1
[  501.055359] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfdbff000
[  501.072526] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[  501.078619] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[  501.085805] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  501.093407] usb usb1: Product: EHCI Host Controller
[  501.093411] usb usb1: Manufacturer: Linux 2.6.34-rc6 ehci_hcd
[  501.093413] usb usb1: SerialNumber: 0000:00:13.5
[  501.093550] hub 1-0:1.0: USB hub found
[  501.093554] hub 1-0:1.0: 10 ports detected
[  505.900903] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[  505.907619] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  505.915332] ohci_hcd 0000:00:13.0: OHCI Host Controller
[  505.920972] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[  505.928986] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfdbfe000
[  505.994238] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[  506.001566] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  506.009324] usb usb2: Product: OHCI Host Controller
[  506.014570] usb usb2: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[  506.020765] usb usb2: SerialNumber: 0000:00:13.0
[  506.026022] hub 2-0:1.0: USB hub found
[  506.030071] hub 2-0:1.0: 2 ports detected
[  506.034578] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  506.042275] ohci_hcd 0000:00:13.1: OHCI Host Controller
[  506.047902] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[  506.055896] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfdbfd000
[  506.134192] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[  506.141497] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  506.149235] usb usb3: Product: OHCI Host Controller
[  506.154478] usb usb3: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[  506.160678] usb usb3: SerialNumber: 0000:00:13.1
[  506.165828] hub 3-0:1.0: USB hub found
[  506.169878] hub 3-0:1.0: 2 ports detected
[  506.174395] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  506.182086] ohci_hcd 0000:00:13.2: OHCI Host Controller
[  506.187720] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[  506.195708] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfdbfc000
[  506.254208] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[  506.261519] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  506.269280] usb usb4: Product: OHCI Host Controller
[  506.274528] usb usb4: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[  506.280724] usb usb4: SerialNumber: 0000:00:13.2
[  506.285923] hub 4-0:1.0: USB hub found
[  506.289957] hub 4-0:1.0: 2 ports detected
[  506.294479] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  506.302171] ohci_hcd 0000:00:13.3: OHCI Host Controller
[  506.307804] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[  506.315770] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfdbfb000
[  506.384187] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[  506.391508] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  506.399278] usb usb5: Product: OHCI Host Controller
[  506.404518] usb usb5: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[  506.410704] usb usb5: SerialNumber: 0000:00:13.3
[  506.415903] hub 5-0:1.0: USB hub found
[  506.419919] hub 5-0:1.0: 2 ports detected
[  506.424444] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  506.432135] ohci_hcd 0000:00:13.4: OHCI Host Controller
[  506.437771] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[  506.445745] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfdbfa000
[  506.462564] usb 2-2: new full speed USB device using ohci_hcd and address 2
[  506.514186] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[  506.521527] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  506.529289] usb usb6: Product: OHCI Host Controller
[  506.534519] usb usb6: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[  506.540740] usb usb6: SerialNumber: 0000:00:13.4
[  506.545966] hub 6-0:1.0: USB hub found
[  506.550025] hub 6-0:1.0: 2 ports detected
[  506.679090] usb 2-2: New USB device found, idVendor=058f, idProduct=9462
[  506.686284] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  506.693954] usb 2-2: Product: Multimedia USB Keyboard
[  506.699410] usb 2-2: Manufacturer: Multimedia USB Keyboard
[  506.700520] hub 2-2:1.0: USB hub found
[  506.704102] hub 2-2:1.0: 3 ports detected
[  506.991083] usb 2-2.1: new full speed USB device using ohci_hcd and address 3
[  507.159086] usb 2-2.1: New USB device found, idVendor=058f, idProduct=9462
[  507.166464] usb 2-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  507.174345] usb 2-2.1: Product: Multimedia USB Keyboard
[  507.179965] usb 2-2.1: Manufacturer: Multimedia USB Keyboard
[  507.186051] usb 2-2.1: SerialNumber: Multimedia USB Keyboard
[  507.230896] input: Multimedia USB Keyboard Multimedia USB Keyboard as /devices/pci0000:00/0000:00:13.0/u4
[  507.244547] generic-usb 0003:058F:9462.0001: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Mult0
[  507.288737] generic-usb: probe of 0003:058F:9462.0002 failed with error -22
                   ^^^^^ this one was causing resume trouble in .33-rc
                         but has been fix since then.
                         c.f. thread http://lkml.org/lkml/2010/2/8/179
[  507.296280] usbcore: registered new interface driver usbhid
[  507.302242] usbhid: USB HID core driver


New suspend attempt, with a few printks added and async disabled:
...
[ 1280.630812] usb usb1: preparing type suspend, may wakeup
[ 1280.636435] usb usb2: preparing type suspend, may wakeup
[ 1280.642016] usb usb3: preparing type suspend, may wakeup
[ 1280.647631] usb usb4: preparing type suspend, may wakeup
[ 1280.653229] usb usb5: preparing type suspend, may wakeup
[ 1280.658813] usb usb6: preparing type suspend, may wakeup
[ 1280.664408] usb 2-2: preparing type suspend, may wakeup
[ 1280.669886] usb 2-2.1: preparing type suspend, may wakeup
[ 1280.675577] input input4: type suspend
[ 1280.679538] usbhid 2-2.1:1.1: suspend
[ 1280.683415] usbhid 2-2.1:1.0: suspend
[ 1280.687266] usb 2-2.1: type suspend, may wakeup
[ 1280.692044] hid 0003:058F:9462.0002: Suspending HID device...

So yeah, for some reason hid fails to suspend this device.

It's blocking somewhere in hid_suspend() of usbhid/hid-core.c
between function start and including call to hid_cease_io().

Going to add more printks in there in the hope to get more precise
location, also adding debug param to hid.ko ...

Bruno
