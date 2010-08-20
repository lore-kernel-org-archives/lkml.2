Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0HTHBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 03:01:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52976 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab0HTHBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 03:01:22 -0400
Message-ID: <4C6E2833.6080407@canonical.com>
Date: Fri, 20 Aug 2010 15:01:07 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        David Woodhouse <dwmw2@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control rf/camera
 power
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com> <1282127719.2747.211.camel@localhost> <20100818155128.GA24363@darkside.kls.lan> <4C6CA31D.6030407@canonical.com> <20100819193146.GB32665@darkside.kls.lan>
In-Reply-To: <20100819193146.GB32665@darkside.kls.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mario,

Could you attach or upload the DSDT of S12 somewhere I can reach?
I check DSDT for S10-3 and B550, return value of _CFG is fixed.

[Ref: http://people.ubuntu.com/~ikepanhc/DSDTs]

you may use "sudo cp /sys/firmware/acpi/tables/DSDT ." and
"sudo iasl -d /sys/firmware/acpi/tables/DSDT" to decode it.

On 08/20/2010 03:31 AM, Mario 'BitKoenig' Holbe wrote:
> On Thu, Aug 19, 2010 at 11:21:01AM +0800, Ike Panhc wrote:
>> On 08/18/2010 11:51 PM, Mario 'BitKoenig' Holbe wrote:
>>> 2nd: both Bluetooth killswitches reproducibly disappear when I block
>>> ideapad_bluetooth either via Gnome bluetooth-applet or via rfkill block
>>> 1 and subsequently reboot.
> 
> All right, I did some more testing...
> 
> I was not able to reproduce this with Windows somewhere in the game -
> neither via switching BT off in Windows and rebooting to Windows nor via
> switching BT off in Linux and rebooting to Windows nor via switching BT
> off in Windows and rebooting to Linux.
> 
>> This is interesting. looks like the cfgbit will change on S12 if BIOS
>> remember it has to shutdown when booting. I will try if the same problem
>> happen on my ideapads.
> 
> Yes, the cfgbit changes. It's normally 0xd0000 and it's 0xc0000 when the
> bluetooth switch is not detected.
> 
> It's not that reproducible as it first appeared to be. Sometimes it does
> not happen, i.e. sometimes after rfkill block 1 and reboot the
> bluetooth killswitch is available again.
> 
> If the bluetooth killswitch is not available, a second reboot usually
> makes it available again.
> 
> Once the cfgbit is 0xc0000 it's stable, i.e. modprobe -r ideapad-laptop;
> modprobe ideapad-laptop doesn't change anything.
sounds like we need an exception handle for detecting camera

> 
> I tried to enforce the existence of the bluetooth killswitch (the
> attached diff is not for inclusion but to show what I did) with some
> kind of success:
> 
> [  682.260288] ideapad_acpi_add(): cfg=0xc0000
As I know the cfgbit for lower 16bit shall not be all zero.

> [  682.260293] ideapad_acpi_add(): found: ideapad_camera
> [  682.260297] ideapad_acpi_add(): found: ideapad_wlan
> [  682.260301] ideapad_acpi_add(): forced: ideapad_bluetooth
> [  682.856049] usb 4-1: new full speed USB device using uhci_hcd and address 2
> [  683.028220] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2150
> [  683.028234] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  683.028244] usb 4-1: Product: BCM2046 Bluetooth Device
> 
> So, forcing the existence of the killswitch enables the bluetooth
> device. I'm also able to switch if off again - the bluetooth device
> disappears. Trying to switch it back on then fails - the bluetooth
> device does not appear again. But this case doesn't work all that well
> anyways even with cfgbit 0xd0000:
bluetooth device shall disappear after disable from EC. But if can not be enabled
again, ahh.....

> 
> $ rfkill block 1
> [  124.648059] usb 4-1: USB disconnect, address 2
> [  124.648512] btusb_intr_complete: hci0 urb f6825700 failed to resubmit (19)
> [  124.648531] btusb_bulk_complete: hci0 urb f697ee80 failed to resubmit (19)
> [  124.649510] btusb_bulk_complete: hci0 urb f6872400 failed to resubmit (19)
> [  124.650114] btusb_send_frame: hci0 urb f67acf00 submission failed
> $ rfkill unblock 1
> [  133.148059] usb 4-1: new full speed USB device using uhci_hcd and address 3
> [  148.260042] usb 4-1: device descriptor read/64, error -110
> $ rfkill block 1
> [  151.092060] hub 4-0:1.0: unable to enumerate USB device on port 1
> $ rfkill unblock 1
> [  155.628052] usb 4-1: new full speed USB device using uhci_hcd and address 4
> [  170.740049] usb 4-1: device descriptor read/64, error -110
> [  185.956033] usb 4-1: device descriptor read/64, error -110
This looks like the device is power up, but usb host unable to recognize..

> 
> Sometimes it doesn't even come back at all on unblock. Seems like the
> bluetooth device doesn't really like to be powered off and on that way.
> Btw.: once I messed up the bluetooth device that way not even Windows
> sees it anymore when I reboot to it.
did you see any kernel message said timeout when it does not come back at all?

> 
> From all this I'm inclined to assume it has more to do with the
> bluetooth device's USB interface than with the killswitch handling
> itself. I believe the S12 BIOS just probes the device(s) on it's own and
> sets the cfgbit accordingly and sometimes it just doesn't find the
> bluetooth device - why ever.
I guess so. so I need DSDT for digging more.

> 
> This all does btw. not happen when I use the hci0 killswitch instead.
> The device doesn't disappear then, has no issues with re-initialization,
> etc. Looks way more stable that way.
when you use rfkill of hci0, it only disable PHY. The driver and MAC is still
there. The rfkill of ideapad-laptop will power down all the module. I believe
its normal.

> I'm not absolutely sure about the different implications of using the
> one or the other killswitch - maybe using the ACPI killswitches saves
> more power than using the device-specific killswitches because it powers
> the device(s) down completely, but that's just a wild guess - maybe it's
> absolutely wrong, though.
I think it shall be correct.

If the rfkill for the whole bluetooth module makes trouble, I prefer not to
do it. User will feel confused if the device does not come back and the
rfkill of hci0 offers the function user need.

> However, it would probably be worth thinking about not offering the
> additional RF killswitches at all but just doing the initialization
> stuff to make sure the devices power up and are thus able to be handled
> via their own killswitches subsequently.
> 
> Please let me know if I can provide more testing - and what kind of :)
> 
> 
> Mario

