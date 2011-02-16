Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1BPWXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:23:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48325 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753762Ab1BPWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:23:10 -0500
Date: Wed, 16 Feb 2011 17:23:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 2/2] PM: Make system-wide PM and runtime PM handle
 subsystems consistently
In-Reply-To: <201102162247.49924.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1102161710090.1626-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011, Rafael J. Wysocki wrote:

> On Wednesday, February 16, 2011, Alan Stern wrote:
> > On Wed, 16 Feb 2011, Rafael J. Wysocki wrote:
> > 
> > > Unfortunately, it doesn't work on my Acer Ferrari One.  The problem is that
> > > hcd_pci_suspend() fails for the EHCI controller, apparently because the root
> > > hub is not suspended.  Do root hubs need both class suspend and bus type
> > > suspend to work at the same time?
> > 
> > No, only the bus type suspend method is needed.
> 
> Bus type or device type?  It appears to be the latter from reading the code
> (although admittedly not too thorough).

You're right.  I forgot about how the PM methods were split up.  :-(

> > Can you provide the dmesg log using a kernel built with CONFIG_USB_DEBUG?
> 
> Well, I know what the problem is.
> 
> USB defines usb_device_type pointing to usb_device_pm_ops that provides
> system-wide PM callbacks only and usb_bus_type pointing to
> usb_bus_pm_ops that provides runtime PM callbacks only.  So it looks like
> we should move either the system-wide PM callbacks to usb_bus_pm_ops,
> or the runtime PM callbacks to usb_device_pm_ops.

Yes.  IIRC, I did it that way so that the runtime PM routines could be 
static.  Making them non-static isn't a big deal, though.

> FWIW, the appended patch helps on my test machine, but I'm not sure if it
> is the right thing to do.

It is.  Except that the inline stubs aren't needed for anything; they 
don't have to be added to usb.h.

> Apart from this I think the order of checks introduced by the $subject patch
> should be:
> (1) If dev->class != NULL and dev->class->pm != NULL, use dev->class,
>     or otherwise
> (2) if dev->type != NULL and dev->type->pm != NULL, use dev->type,
>     or otherwise
> (3) use dev->bus (if present).
> as that would allow classes and device types to override bus type PM
> callbacks if they wish to.

I haven't heard of any device types being present on more than one kind
of bus, so it makes sense for device types to override bus types.  But
I'm not so sure about the priority we should give to classes.  On the
other hand, if no classes define a dev_pm_ops then of course it doesn't
matter.

Alan Stern

