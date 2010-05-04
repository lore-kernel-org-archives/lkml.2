Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab0EDVEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 17:04:33 -0400
Received: from legolas.restena.lu ([158.64.1.34]:44959 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab0EDVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 17:04:31 -0400
Date: Tue, 4 May 2010 23:04:15 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
       USB@smtp1.linux-foundation.org, list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] s2ram slow (radeon) / failing (usb)
Message-ID: <20100504230415.6097a767@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1005041028300.9849@pobox.suse.cz>
References: <20100503214642.67577f91@neptune.home>
	<20100503225735.6b5e2687@neptune.home>
	<20100503231154.486c27d6@neptune.home>
	<201005040842.35260.oneukum@suse.de>
	<alpine.LNX.2.00.1005041028300.9849@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 May 2010 Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 4 May 2010, Oliver Neukum wrote:
> 
> > > [  477.543304] usb 1-2.1: usb_autosuspend_device: cnt 1 -> 0
> > > [  477.543316] usbhid 1-2.1:1.1: __pm_runtime_suspend()!
> > > [  477.543326] usbhid 1-2.1:1.1: __pm_runtime_suspend() returns 0!
> > > [  477.543380] usbcore: registered new interface driver usbhid
> > > [  477.549457] usbhid: USB HID core driver
> > > 
> > > And suspend is freezing inside of hid_cancel_delayed_stuff(usbhid) call
> > > from hid_suspend() in drivers/hid/usbhid/hid-core.c ...
> > > 
> > > Is it worth continuing iteration and adding further printk's down there?
> > > Jiri, what's your opinion on this?
> > 
> > Ugh. That looks like a bug in usbhid that I introduced. A fix is not trivial.
> > In short, I did not think the device could be undergoing a queued resumption
> > while suspend() is being called. I wonder why this is happening.
> 
> Hmmm ... seems to me that in this case, the problem might be that there is 
> a device hanging in the air, for which the parsing of report descriptor 
> failed (interface .0002), but it's still somehow there on the bus.
> 
> It's a bit strange that we are not seeing 
> 
> 	dev_err(&intf->dev, "can't add hid device: %d\n", ret);
> 
> message from usbhid_probe(), are we? That would mean, that we are 
> returning ENODEV from the usb_driver->probe routine properly.
> 
> Bruno, could you, for testing purposes, check, whether the patch below 
> changes the behavior you are seeing (and also check what the actual return 
> value from device_add() was, see the added printk()).

Well, it's said to return 0:

[  286.872739] generic-usb 0003:058F:9462.0003: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedia USB Keyboard] on usb-0000:00:13.0-2.1/input0
[  286.890136] HID: device_add() returned 0

[  286.919698] generic-usb: probe of 0003:058F:9462.0004 failed with error -22
[  286.929363] HID: device_add() returned 0

or with debug=1 for HID:
[  559.982958] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 1
[  560.011698] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: usage index exceeded
[  560.011704] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: hid_add_usage failed
[  560.011710] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: item 0 2 2 2 parsing failed
[  560.011732] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: parsing report descriptor failed
[  560.011747] generic-usb: probe of 0003:058F:9462.0006 failed with error -22
[  560.021718] HID: device_add() returned 0

Complete log of connecting keyboard is below (including hid debug, usb
debug and pm debug messages).

The patch does not change suspend behavior (as could be expected for a
return value of 0)

Thanks,
Bruno



[  558.585559] usb usb2: usb wakeup-resume
[  558.585569] usb usb2: __pm_runtime_resume()!
[  558.585578] usb usb2: usb auto-resume
[  558.585584] ehci_hcd 0000:00:13.5: resume root hub
[  558.730038] ehci_hcd 0000:00:13.5: port 2 full speed --> companion
[  558.730049] ehci_hcd 0000:00:13.5: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[  558.750021] usb usb2: usb_resume_device: status 0
[  558.750028] hub 2-0:1.0: hub_resume
[  558.750086] hub 2-0:1.0: usb_resume_interface: status 0
[  558.750091] usb usb2: usb_resume_both: status 0
[  558.750103] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[  558.750112] usb usb2: __pm_runtime_resume() returns 0!
[  558.750121] usb usb2: usb_autoresume_device: cnt 1 -> 0
[  558.750131] usb usb2: usb_autosuspend_device: cnt 0 -> 0
[  558.750141] usb usb1: usb wakeup-resume
[  558.750146] usb usb1: __pm_runtime_resume()!
[  558.750153] hub 2-0:1.0: __pm_runtime_resume()!
[  558.750162] usb usb2: __pm_runtime_resume()!
[  558.750169] usb usb2: __pm_runtime_resume() returns 1!
[  558.750179] usb usb1: usb auto-resume
[  558.750185] hub 2-0:1.0: __pm_runtime_resume() returns 0!
[  558.750194] hub 2-0:1.0: usb_autopm_get_interface: cnt 2 -> 0
[  558.750205] hub 2-0:1.0: __pm_runtime_suspend()!
[  558.750213] hub 2-0:1.0: __pm_runtime_suspend() returns 0!
[  558.750219] hub 2-0:1.0: usb_autopm_put_interface: cnt 0 -> 0
[  558.770024] ohci_hcd 0000:00:13.0: wakeup root hub
[  558.880021] usb usb1: usb_resume_device: status 0
[  558.880026] hub 1-0:1.0: hub_resume
[  558.880043] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
[  558.880052] hub 1-0:1.0: port 2: status 0101 change 0001
[  558.990077] hub 1-0:1.0: usb_resume_interface: status 0
[  558.990091] hub 1-0:1.0: state 7 ports 2 chg 0004 evt 0000
[  558.990104] usb usb1: usb_resume_both: status 0
[  558.990111] usb usb1: __pm_runtime_resume() returns 0!
[  558.990118] usb usb1: usb_autoresume_device: cnt 1 -> 0
[  558.990126] usb usb1: usb_autosuspend_device: cnt 0 -> 0
[  558.990144] hub 1-0:1.0: __pm_runtime_resume()!
[  558.990151] usb usb1: __pm_runtime_resume()!
[  558.990156] usb usb1: __pm_runtime_resume() returns 1!
[  558.990163] hub 1-0:1.0: __pm_runtime_resume() returns 0!
[  558.990168] hub 1-0:1.0: usb_autopm_get_interface: cnt 2 -> 0
[  558.990191] hub 1-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[  559.100039] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[  559.160035] usb 1-2: new full speed USB device using ohci_hcd and address 6
[  559.200055] ohci_hcd 0000:00:13.0: port[1] reset timeout, stat 00000113
[  559.250037] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[  559.340023] usb 1-2: ep0 maxpacket = 8
[  559.344060] usb 1-2: __pm_runtime_resume()!
[  559.344065] usb 1-2: __pm_runtime_resume() returns 1!
[  559.344071] usb 1-2: usb_autoresume_device: cnt 1 -> 1
[  559.358061] usb 1-2: default language 0x0409
[  559.376061] usb 1-2: udev 6, busnum 1, minor = 5
[  559.376067] usb 1-2: New USB device found, idVendor=058f, idProduct=9462
[  559.385547] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  559.395601] usb 1-2: Product: Multimedia USB Keyboard
[  559.403397] usb 1-2: Manufacturer: Multimedia USB Keyboard
[  559.411794] PM: Adding info for usb:1-2
[  559.411868] usb 1-2: usb_probe_device
[  559.411877] usb 1-2: configuration #1 chosen from 1 choice
[  559.411883] usb 1-2: __pm_runtime_resume()!
[  559.411887] usb 1-2: __pm_runtime_resume() returns 1!
[  559.411892] usb 1-2: usb_autoresume_device: cnt 4 -> 1
[  559.412812] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[  559.412886] PM: Adding info for usb:1-2:1.0
[  559.412951] hub 1-2:1.0: usb_probe_interface
[  559.412958] hub 1-2:1.0: usb_probe_interface - got id
[  559.412964] usb 1-2: __pm_runtime_resume()!
[  559.412969] usb 1-2: __pm_runtime_resume() returns 1!
[  559.412974] usb 1-2: usb_autoresume_device: cnt 5 -> 1
[  559.412983] usb 1-2: usb_autosuspend_device: cnt 4 -> 0
[  559.412988] hub 1-2:1.0: USB hub found
[  559.423076] hub 1-2:1.0: 3 ports detected
[  559.429733] hub 1-2:1.0: compound device; port removable status: FRR
[  559.429738] hub 1-2:1.0: individual port power switching
[  559.429743] hub 1-2:1.0: individual port over-current protection
[  559.429749] hub 1-2:1.0: power on to power good time: 44ms
[  559.430072] hub 1-2:1.0: hub controller current requirement: 50mA
[  559.430081] hub 1-2:1.0: 100mA bus power budget for each child
[  559.432056] hub 1-2:1.0: enabling power on all ports
[  559.438059] usb 1-2: usb_autosuspend_device: cnt 3 -> 0
[  559.438119] PM: Adding info for No Bus:ep_81
[  559.438126] usb 1-2: usb_autosuspend_device: cnt 2 -> 0
[  559.438164] PM: Adding info for No Bus:ep_00
[  559.438173] hub 1-0:1.0: usb_autopm_put_interface: cnt 1 -> 0
[  559.438184] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
[  559.438551] hub 1-0:1.0: __pm_runtime_resume()!
[  559.438557] hub 1-0:1.0: __pm_runtime_resume() returns 1!
[  559.438562] hub 1-0:1.0: usb_autopm_get_interface: cnt 2 -> 1
[  559.438578] hub 1-0:1.0: __pm_runtime_suspend()!
[  559.438585] hub 1-0:1.0: __pm_runtime_suspend() returns 0!
[  559.438590] hub 1-0:1.0: usb_autopm_put_interface: cnt 0 -> 0
[  559.531060] hub 1-2:1.0: port 1: status 0101 change 0001
[  559.630040] hub 1-2:1.0: usb_autopm_put_interface_async: cnt 1 -> -11
[  559.630050] hub 1-2:1.0: state 7 ports 3 chg 0002 evt 0000
[  559.630055] hub 1-2:1.0: __pm_runtime_resume()!
[  559.630059] hub 1-2:1.0: __pm_runtime_resume() returns 1!
[  559.630066] hub 1-2:1.0: usb_autopm_get_interface: cnt 2 -> 1
[  559.631055] hub 1-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[  559.711062] usb 1-2.1: new full speed USB device using ohci_hcd and address 7
[  559.830024] usb 1-2.1: ep0 maxpacket = 8
[  559.834058] usb 1-2.1: __pm_runtime_resume()!
[  559.834064] usb 1-2.1: __pm_runtime_resume() returns 1!
[  559.834070] usb 1-2.1: usb_autoresume_device: cnt 1 -> 1
[  559.849058] usb 1-2.1: skipped 1 descriptor after interface
[  559.849067] usb 1-2.1: skipped 1 descriptor after interface
[  559.852054] usb 1-2.1: default language 0x0409
[  559.879060] usb 1-2.1: udev 7, busnum 1, minor = 6
[  559.879066] usb 1-2.1: New USB device found, idVendor=058f, idProduct=9462
[  559.888854] usb 1-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  559.899132] usb 1-2.1: Product: Multimedia USB Keyboard
[  559.907166] usb 1-2.1: Manufacturer: Multimedia USB Keyboard
[  559.915691] usb 1-2.1: SerialNumber: Multimedia USB Keyboard
[  559.924362] PM: Adding info for usb:1-2.1
[  559.924430] usb 1-2.1: usb_probe_device
[  559.924438] usb 1-2.1: configuration #1 chosen from 1 choice
[  559.924446] usb 1-2.1: __pm_runtime_resume()!
[  559.924450] usb 1-2.1: __pm_runtime_resume() returns 1!
[  559.924455] usb 1-2.1: usb_autoresume_device: cnt 4 -> 1
[  559.925259] usb 1-2.1: adding 1-2.1:1.0 (config #1, interface 0)
[  559.925300] PM: Adding info for usb:1-2.1:1.0
[  559.925351] usbhid 1-2.1:1.0: usb_probe_interface
[  559.925357] usbhid 1-2.1:1.0: usb_probe_interface - got id
[  559.925361] usb 1-2.1: __pm_runtime_resume()!
[  559.925366] usb 1-2.1: __pm_runtime_resume() returns 1!
[  559.925371] usb 1-2.1: usb_autoresume_device: cnt 5 -> 1
[  559.925379] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 0
[  559.934104] PM: Adding info for hid:0003:058F:9462.0005
[  559.948668] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Set_Report wValue=0x0200 wIndex=0x0000 wLength=1
[  559.948803] PM: Adding info for No Bus:input5
[  559.948881] input: Multimedia USB Keyboard Multimedia USB Keyboard as /devices/pci0000:00/0000:00:13.0/usb1/1-2/1-2.1/1-2.1:1.0/input/input5
[  559.964996] usbhid 1-2.1:1.0: __pm_runtime_resume()!
[  559.965002] usbhid 1-2.1:1.0: __pm_runtime_resume() returns 1!
[  559.965008] usbhid 1-2.1:1.0: usb_autopm_get_interface: cnt 3 -> 1
[  559.965024] usbhid 1-2.1:1.0: usb_autopm_put_interface: cnt 2 -> 0
[  559.965089] PM: Adding info for No Bus:event3
[  559.965123] generic-usb 0003:058F:9462.0005: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedia USB Keyboard] on usb-0000:00:13.0-2.1/input0
[  559.982795] HID: device_add() returned 0
[  559.982802] usb 1-2.1: usb_autosuspend_device: cnt 4 -> 0
[  559.982810] usbhid 1-2.1:1.0: __pm_runtime_suspend()!
[  559.982817] usbhid 1-2.1:1.0: __pm_runtime_suspend() returns 0!
[  559.982847] PM: Adding info for No Bus:ep_81
[  559.982854] usb 1-2.1: adding 1-2.1:1.1 (config #1, interface 1)
[  559.982891] PM: Adding info for usb:1-2.1:1.1
[  559.982932] usbhid 1-2.1:1.1: usb_probe_interface
[  559.982938] usbhid 1-2.1:1.1: usb_probe_interface - got id
[  559.982942] usb 1-2.1: __pm_runtime_resume()!
[  559.982946] usb 1-2.1: __pm_runtime_resume() returns 1!
[  559.982951] usb 1-2.1: usb_autoresume_device: cnt 5 -> 1
[  559.982958] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 1
[  559.991096] PM: Adding info for hid:0003:058F:9462.0006
[  560.011698] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: usage index exceeded
[  560.011704] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: hid_add_usage failed
[  560.011710] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: item 0 2 2 2 parsing failed
[  560.011732] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: parsing report descriptor failed
[  560.011747] generic-usb: probe of 0003:058F:9462.0006 failed with error -22
[  560.021718] HID: device_add() returned 0
[  560.021724] usb 1-2.1: usb_autosuspend_device: cnt 4 -> 0
[  560.021735] usbhid 1-2.1:1.1: __pm_runtime_suspend()!
[  560.021745] usbhid 1-2.1:1.1: __pm_runtime_suspend() returns 0!
[  560.021781] PM: Adding info for No Bus:ep_82
[  560.021791] usb 1-2.1: usb_autosuspend_device: cnt 3 -> 0
[  560.021832] PM: Adding info for No Bus:ep_00
[  560.021840] hub 1-2:1.0: 400mA power budget left
[  560.021847] hub 1-2:1.0: usb_autopm_put_interface: cnt 1 -> 0
[  560.021855] hub 1-2:1.0: state 7 ports 3 chg 0000 evt 0002
[  560.021860] hub 1-2:1.0: __pm_runtime_resume()!
[  560.021864] hub 1-2:1.0: __pm_runtime_resume() returns 1!
[  560.021869] hub 1-2:1.0: usb_autopm_get_interface: cnt 2 -> 1
[  560.022431] hub 1-2:1.0: __pm_runtime_suspend()!
[  560.022444] hub 1-2:1.0: __pm_runtime_suspend() returns 0!
[  560.022451] hub 1-2:1.0: usb_autopm_put_interface: cnt 0 -> 0
[  561.040033] usb usb2: __pm_runtime_suspend() from workqueue!
[  561.040046] hub 2-0:1.0: hub_suspend
[  561.040060] hub 2-0:1.0: usb_suspend_interface: status 0
[  561.040066] usb usb2: bus auto-suspend
[  561.040071] ehci_hcd 0000:00:13.5: suspend root hub
[  561.040917] usb usb2: usb_suspend_device: status 0
[  561.040923] usb usb2: usb_suspend_both: status 0
[  561.040929] usb usb2: __pm_runtime_suspend() returns 0!



Sync suspend output, including my printk's in HID:
...
[  915.245813] usb usb1: preparing type suspend, may wakeup
[  915.253525] usb usb2: preparing type suspend, may wakeup
[  915.261254] usb usb3: preparing type suspend, may wakeup
[  915.268952] usb usb4: preparing type suspend, may wakeup
[  915.276646] usb usb5: preparing type suspend, may wakeup
[  915.284221] usb usb6: preparing type suspend, may wakeup
[  915.291859] usb 1-2: preparing type suspend, may wakeup
[  915.299424] usb 1-2.1: preparing type suspend, may wakeup
[  915.307146] usbhid 1-2.1:1.1: suspend
[  915.312959] input input5: type suspend
[  915.318925] usbhid 1-2.1:1.0: suspend
[  915.324719] usb 1-2.1: type suspend, may wakeup
[  915.331496] hid 0003:058F:9462.0006: Suspending HID device...
[  915.337614] hid 0003:058F:9462.0006: Waiting for pending IO...
[  915.345803] hid 0003:058F:9462.0006: done waiting for pending IO...
[  915.354477] hid 0003:058F:9462.0006: Going to cancel delayed stuff...
