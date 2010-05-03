Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0ECULP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:11:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37534 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756642Ab0ECULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:11:11 -0400
Date: Mon, 3 May 2010 16:11:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100503214642.67577f91@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1005031557080.1502-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 May 2010, Bruno [UTF-8] Prémont wrote:

> On Mon, 03 May 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> > You might also want to #define VERBOSE_DEBUG at the start of 
> > drivers/usb/core/driver.c, before the first #include.
> 
> Still no difference... (will retry with own printk's in ohci's suspend
> code as suggested in other mail)

First of all, have you tried disabling async suspend?  Look at 
/sys/power/pm_async.

> Suspend output as it goes:

Let's just look at the USB entries:

> [  241.358651] usb usb1: preparing type suspend, may wakeup
> [  241.364247] usb usb2: preparing type suspend, may wakeup
> [  241.369847] usb usb3: preparing type suspend, may wakeup
> [  241.375443] usb usb4: preparing type suspend, may wakeup
> [  241.381044] usb usb5: preparing type suspend, may wakeup
> [  241.386643] usb usb6: preparing type suspend, may wakeup
> [  241.392244] usb 1-2: preparing type suspend, may wakeup
> [  241.397762] usb 1-2.1: preparing type suspend, may wakeup

Those are normal.

> [  241.407504] usbhid 1-2.1:1.1: suspend
> [  241.407511] usbhid 1-2.1:1.0: suspend

These are HID suspends for the keyboard and mouse interfaces.

> [  241.407516] usb 1-2.1: type suspend, may wakeup

This is a USB suspend for the KB/mouse device.

> [  241.443340] hub 1-2:1.0: suspend

Suspend for the embedded hub interface.  Next we should see

	[....] usb 1-2: type suspend, may wakeup

for the embedded hub device, but we don't.  That's the problem.  It 
must be waiting for something -- goodness knows what.

> [  241.911502] hub 6-0:1.0: suspend
> [  241.914928] usb usb6: type suspend, may wakeup
> [  241.919583] usb usb6: usb_suspend_both: status 0
> [  241.924448] usb usb6: suspend, may wakeup
> [  241.928663] hub 5-0:1.0: suspend
> [  241.932082] usb usb5: type suspend, may wakeup
> [  241.936794] usb usb5: usb_suspend_both: status 0
> [  241.941669] usb usb5: suspend, may wakeup
> [  241.945888] hub 4-0:1.0: suspend
> [  241.949294] usb usb4: type suspend, may wakeup
> [  241.953966] usb usb4: usb_suspend_both: status 0
> [  241.958814] usb usb4: suspend, may wakeup
> [  241.963069] hub 3-0:1.0: suspend
> [  241.966452] usb usb3: type suspend, may wakeup
> [  241.971126] usb usb3: usb_suspend_both: status 0
> [  241.976015] usb usb3: suspend, may wakeup
> [  241.980232] hub 2-0:1.0: suspend
> [  241.983662] usb usb2: type suspend, may wakeup
> [  241.988316] usb usb2: usb_suspend_both: status 0
> [  241.993192] usb usb2: suspend, may wakeup
> [  241.997418] hub 1-0:1.0: suspend

And here we should see

	[....] usb usb1: type suspend, may wakeup
	etc.

but we don't, because it's waiting for the 1-2 device.

> [  242.125768] ehci_hcd 0000:00:13.5: suspend
> [  242.130076] ehci_hcd 0000:00:13.5: PCI INT D disabled
> [  242.135410] ohci_hcd 0000:00:13.4: suspend
> [  242.139696] ohci_hcd 0000:00:13.4: PCI INT C disabled
> [  242.145035] ohci_hcd 0000:00:13.3: suspend
> [  242.149348] ohci_hcd 0000:00:13.3: PCI INT B disabled
> [  242.154705] ohci_hcd 0000:00:13.2: suspend
> [  242.159012] ohci_hcd 0000:00:13.2: PCI INT C disabled
> [  242.164342] ohci_hcd 0000:00:13.1: suspend
> [  242.168676] ohci_hcd 0000:00:13.1: PCI INT B disabled

> I guess here PM is waiting for ohci_hcd 0000:00:13.0 to suspend
> and disable its interrupt.
> (and that last ohci device would match the usbhid_resume thread that's
> frozen...)

The 0000:00:13.0 device can't suspend until usb1 does, and usb1 can't
suspend until 1-2 does.

Can you boot the dmesg log for bootup and device detection?  It may 
indicate what we're missing.  Also include the contents of 
/sys/kernel/debug/usb/devices.

Alan Stern

