Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1F3TGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:06:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47339 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753451Ab1F3TGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:06:04 -0400
Date: Thu, 30 Jun 2011 15:06:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend
In-Reply-To: <201106302025.04722.a.miskiewicz@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1106301457470.1957-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011, Arkadiusz Miskiewicz wrote:

> One new info. suspend/resume from ram is not needed. Fresh boot, I'm running 
> on battery, plug power, unplug power and these weird thing start to happen 
> with mouse unsuspend delay.
> 
> Unfortunately turns out that this behaviour is also seen on my rc3 but laptop 
> has to run on battery. So not a regression.
> 
> Example (on 3.0.0-rc3-00205-gdd34739)
> 
> [ 1155.447146] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
> [ 1165.970079] uhci_hcd 0000:00:1a.0: release dev 2 ep82-INT, period 2, phase 
> 1, 17 us
> [ 1165.971071] uhci_hcd 0000:00:1a.0: release dev 2 ep81-INT, period 8, phase 
> 4, 17 us
> 
> mouse works but I don't move it, so it suspends
> 
> [ 1165.973074] usb 3-1: usb auto-suspend
> 
> now from this moment until...
> 
> [ 1167.988114] hub 3-0:1.0: hub_suspend
> [ 1167.988132] usb usb3: bus auto-suspend
> [ 1167.988138] usb usb3: suspend_rh
> [ 1167.988169] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
> [ 1167.988191] uhci_hcd 0000:00:1a.0: PCI INT A disabled
> [ 1167.988197] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
> [ 1167.988351] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
> 
> untill this moment every my mouse move causes nothing but after some delay it 
> resumes

Okay, that's interesting.  This means it isn't a problem with the 
mouse.

> [ 1170.545790] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 1170.545801] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 1170.545946] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 1170.545954] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> [ 1170.545971] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
> 20
> [ 1170.545986] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [ 1170.545995] uhci_hcd 0000:00:1a.0: uhci_pci_resume
> [ 1170.546041] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0

The messages above show the host controller being resumed.  That may be 
your real problem.

> [ 1170.546052] usb usb3: usb wakeup-resume
> [ 1170.546061] usb usb3: usb auto-resume
> [ 1170.546066] usb usb3: wakeup_rh
> [ 1170.588078] hub 3-0:1.0: hub_resume
> [ 1170.588097] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
> [ 1170.588108] hub 3-0:1.0: port 1: status 0103 change 0004
> [ 1170.588169] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
> [ 1170.588188] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
> [ 1170.604114] usb 3-1: usb wakeup-resume
> [ 1170.604133] usb 3-1: finish resume
> [ 1170.607134] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 
> 4, 17 us
> [ 1170.607150] uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 2, phase 
> 1, 17 us
> [ 1170.607162] hub 3-0:1.0: resume on port 1, status 0
> [ 1170.607169] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
> 
> and is working fine until another suspend.

...

> it is useable again until new suspend happens. So mouse recovers quicker but 
> only after "power state changed by ACPI to D3" happens.
> 
> Summary: not a regression, unfortunately feature unusable with this mouse on 
> this laptop.

You can try disabling autosuspend for the host controller.  Write "on" 
to /sys/bus/pci/devices/0000:00:1a.0/power/control.

> > And now you know why, more or less -- we still have to figure out the
> > reason for the hang.  Probably something goes wrong when cdc-ether is
> > unbound from the wireless device.
> 
> If cdc-ether is not loaded at all then usb works fine after resume from ram on 
> rc5.

So it looks like rc5 introduced a bug into cdc-ether or somewhere else
in the networking stack.  Bisection seems like the easiest way to find
it.  You already know that rc4 works okay.

> > It's not even clear that autosuspend is a problem.  Doesn't 3.0-rc3
> > also autosuspend the mouse?
> 
> The problem with usb not working if cdc-ether is used happens when also  on 
> external power and afaik autosuspend doesn't kick-in in such case, right?

The kernel doesn't care whether you are running on external power or 
battery.  However you might have a userspace power daemon that changes 
the autosuspend settings, depending on the power source.

Alan Stern

