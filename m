Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0ECVMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:12:12 -0400
Received: from legolas.restena.lu ([158.64.1.34]:58265 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0ECVMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:12:09 -0400
Date: Mon, 3 May 2010 23:11:54 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
Message-ID: <20100503231154.486c27d6@neptune.home>
In-Reply-To: <20100503225735.6b5e2687@neptune.home>
References: <20100503214642.67577f91@neptune.home>
	<Pine.LNX.4.44L0.1005031557080.1502-100000@iolanthe.rowland.org>
	<20100503225735.6b5e2687@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 May 2010 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> New suspend attempt, with a few printks added and async disabled:
> ...
> [ 1280.630812] usb usb1: preparing type suspend, may wakeup
> [ 1280.636435] usb usb2: preparing type suspend, may wakeup
> [ 1280.642016] usb usb3: preparing type suspend, may wakeup
> [ 1280.647631] usb usb4: preparing type suspend, may wakeup
> [ 1280.653229] usb usb5: preparing type suspend, may wakeup
> [ 1280.658813] usb usb6: preparing type suspend, may wakeup
> [ 1280.664408] usb 2-2: preparing type suspend, may wakeup
> [ 1280.669886] usb 2-2.1: preparing type suspend, may wakeup
> [ 1280.675577] input input4: type suspend
> [ 1280.679538] usbhid 2-2.1:1.1: suspend
> [ 1280.683415] usbhid 2-2.1:1.0: suspend
> [ 1280.687266] usb 2-2.1: type suspend, may wakeup
> [ 1280.692044] hid 0003:058F:9462.0002: Suspending HID device...
> 
> So yeah, for some reason hid fails to suspend this device.
> 
> It's blocking somewhere in hid_suspend() of usbhid/hid-core.c
> between function start and including call to hid_cease_io().
> 
> Going to add more printks in there in the hope to get more precise
> location, also adding debug param to hid.ko ...

Loading usbhid on top of hid with debug=1:

[  473.786604] HID: hid_debug is now used solely for parser and driver debugging.
[  473.786610] HID: debugfs is now used for inspecting the device (report descriptor, reports)
[  477.455492] usbhid 1-2.1:1.0: usb_probe_interface
[  477.455502] usbhid 1-2.1:1.0: usb_probe_interface - got id
[  477.455510] usb 1-2.1: __pm_runtime_resume()!
[  477.455516] usb 1-2.1: __pm_runtime_resume() returns 1!
[  477.455522] usb 1-2.1: usb_autoresume_device: cnt 2 -> 1
[  477.455531] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 0
[  477.463038] PM: Adding info for hid:0003:058F:9462.0001
[  477.477614] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Set_Report wValue=0x0200 wIndex=0x0000 wLength=1
[  477.477829] PM: Adding info for No Bus:input4
[  477.477917] input: Multimedia USB Keyboard Multimedia USB Keyboard as /devices/pci0000:00/0000:00:13.0/usb1/1-2/1-2.1/1-2.1:1.0/input/input4
[  477.491554] usbhid 1-2.1:1.0: __pm_runtime_resume()!
[  477.491560] usbhid 1-2.1:1.0: __pm_runtime_resume() returns 1!
[  477.491566] usbhid 1-2.1:1.0: usb_autopm_get_interface: cnt 2 -> 1
[  477.491579] usbhid 1-2.1:1.0: usb_autopm_put_interface: cnt 1 -> 0
[  477.491645] PM: Adding info for No Bus:event3
[  477.491681] generic-usb 0003:058F:9462.0001: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedia USB Keyboard] on usb-0000:00:13.0-2.1/input0
[  477.506754] usb 1-2.1: usb_autosuspend_device: cnt 1 -> 0
[  477.506763] usbhid 1-2.1:1.0: __pm_runtime_suspend()!
[  477.506771] usbhid 1-2.1:1.0: __pm_runtime_suspend() returns 0!
[  477.506815] usbhid 1-2.1:1.1: usb_probe_interface
[  477.506822] usbhid 1-2.1:1.1: usb_probe_interface - got id
[  477.506827] usb 1-2.1: __pm_runtime_resume()!
[  477.506831] usb 1-2.1: __pm_runtime_resume() returns 1!
[  477.506836] usb 1-2.1: usb_autoresume_device: cnt 2 -> 1
[  477.506843] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 1
[  477.515027] PM: Adding info for hid:0003:058F:9462.0002
[  477.535614] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: usage index exceeded
[  477.535621] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: hid_add_usage failed
[  477.535627] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: item 0 2 2 2 parsing failed
[  477.535643] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: parsing report descriptor failed
[  477.535656] generic-usb: probe of 0003:058F:9462.0002 failed with error -22
[  477.543304] usb 1-2.1: usb_autosuspend_device: cnt 1 -> 0
[  477.543316] usbhid 1-2.1:1.1: __pm_runtime_suspend()!
[  477.543326] usbhid 1-2.1:1.1: __pm_runtime_suspend() returns 0!
[  477.543380] usbcore: registered new interface driver usbhid
[  477.549457] usbhid: USB HID core driver

And suspend is freezing inside of hid_cancel_delayed_stuff(usbhid) call
from hid_suspend() in drivers/hid/usbhid/hid-core.c ...

Is it worth continuing iteration and adding further printk's down there?
Jiri, what's your opinion on this?

Thanks,
Bruno
