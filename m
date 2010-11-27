Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0K0PQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:16:50 -0500
Received: from netrider.rowland.org ([192.131.102.5]:55783 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752561Ab0K0PQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:16:49 -0500
Date: Sat, 27 Nov 2010 10:16:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Nobody cared about IRQs at shutdown
In-Reply-To: <4CF0AF5C.6010003@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1011271011230.23611-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Alexander E. Patrakov wrote:

> 26.11.2010 01:25, Alan Stern wrote:
> > On Thu, 25 Nov 2010, Alexander E. Patrakov wrote:
> >
> >> 25.11.2010 21:06, Alan Stern wrote:
> >>> On Thu, 25 Nov 2010, Alexander E. Patrakov wrote:
> >>>
> >>>> Hello.
> >>>>
> >>>> After switching my Gentoo desktop from sysvinit + openrc to systemd, I
> >>>> started getting "nobody cared" messages about IRQs 16 and 19 (common
> >>>> thing: they are assigned to the USB controllers, that's why CC:
> >>> According to your listing, they are used by uhci-hcd.  Do the messages
> >>> go away if you unload uhci-hcd before shutting down?
> >> It is not a module here, so I have to recompile the kernel in order to
> >> try this. Will do that tomorrow.
> >>
> >>> You may need to debug the uhci-hcd driver. Look into
> >>> drivers/usb/host/uhci-hcd.c; the uhci_shutdown() routine ought to be
> >>> called and it ought to call uhci_hc_died(), which in turn calls
> >>> uhci_reset_hc() in pci-quirks.c, which is supposed to prevent the
> >>> controller from generating any IRQs.
> >> OK, tomorrow I will add some printks there.
> 
> Sorry, I didn't add them due to being busy with a different (non-kernel) 
> bug. What do you want to know - just the fact that these functions are 
> called before or after reporting the bad IRQ?

They should be called before the bad IRQ is reported.  That's what I 
want to verify.

> > Even without rebuilding the kernel, you can unbind the uhci-hcd driver
> > from the hardware by going to the /sys/bus/pci/drivers/uhci_hcd
> > directory and doing:
> >
> > 	echo -n device-name>unbind
> >
> > where "device-name" is the name of one of the symlinks in that
> > directory.
> 
> Thanks for the tip. Below are the updated test results, including the 
> ones posted in my first mail, for completeness.
> 
> 1. No irqpoll, no unbind: the system reports that nobody cared for IRQs, 
> then waits, displays SATA errors, waits again, shuts down.
> 
> 2. irqpoll, no unbind: the system shuts down without any delays.
> 
> 3. No irqpoll, unbind uhci-hcd from everything it controls: the system 
> reports bad IRQ 19 (consumed by firewire-ohci), waits, displays SATA 
> errors, waits again, shuts down.

This suggests that the problem comes from the firewire controller, not 
the UHCI controller.

Are you sure that you ever got "nobody cared" reports for IRQ 16?  Your 
listing showed that uhci-hcd used both 16 and 19 whereas firewire-ohci 
used only 19.

> 4. No irqpoll, unbind both uhci-hcd and firewire-ohci from everything: 
> the system does not report any bad IRQs, waits, displays SATA errors, 
> waits again, shuts down.

And this tends to confirm it.  The SATA errors are probably a separate
issue.

What happens if you unbind firewire-ohci but not uhci-hcd?

> 5. irqpoll, unbind both uhci-hcd and firewire-ohci from everything: same 
> as (4).
> 
> I have no firewire devices.

Apparently that doesn't stop the controller from misbehaving.  But you 
need to do more tests to be sure of this.

Alan Stern

