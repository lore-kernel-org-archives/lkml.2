Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2KNVpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:45:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35918 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932381Ab2KNVpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:45:03 -0500
Date: Wed, 14 Nov 2012 16:45:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Huang Ying <ying.huang@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <1808040.vTl5iT6HSY@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1211141608200.1620-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Rafael J. Wysocki wrote:

> > This has the side effect that when a driver unbinds, it can't leave the 
> > device in a special low-power state.  The device will always end up in 
> > the generic low-power state supported by the PCI core.
> 
> Well, I'm not sure I'd like that.
> 
> Let's just go back even one step more and think what we'd like to have in
> general terms and then how to implement it. :-)
> 
> Suppose that pci_pm_init() calls pm_runtime_enable() for all devices (in
> addition to what it does currently).  The runtime PM status of each device is
> RPM_SUSPENDED at this point.  Then:

Wait a moment.  When the device is detected and initialized, it is in
D0, right?  Currently we don't care much because the device starts out
disabled for runtime PM.  But now you are going to enable it.  While
the device is enabled, its runtime status should match the physical
power level.

This means the initialization routine would have to call
pm_runtime_set_active() before pm_runtime_enable().  If you then wanted
to change the status to RPM_SUSPENDED, you would actually have to put
the device into D3 by calling pm_runtime_suspend() (or maybe
pm_runtime_schedule_suspend() to give drivers some time to get loaded 
and bind).

> (1) We want to keep the current semantics during probe, i.e. the device should
>     (a) be RPM_ACTIVE and (b) have usage_count == (user space usage_count + 1)
>     right before ddi->drv->probe() is executed.

In theory the usage_count could be higher and then adjusted back after
the probe is finished, if that would make anything easier.

> (2) We don't want the driver's PM callbacks to be run before ddi->drv->probe().
>     There's a question if we want the bus type's PM callbacks to be run at
>     that point, but they are not run currently and IMO we shouldn't change
>     that.

The device is supposed to be in D0 when it is probed.  Since we are
assuming that initialization is now going to leave it in D3, there's no
choice -- you _have_ to invoke pci_pm_runtime_resume(), which would
invoke the driver's callback, which we don't want.

Therefore you need to figure out a way to tell pci_pm_runtime_resume() 
(and presumably pci_pm_runtime_suspend() as well) when not to invoke 
the driver's callback.  Add a flag to the pci_device structure, maybe.

> (4) If ddi->drv->probe() fails, we want the device's status to change to
>     RPM_SUSPENDED and it's usage_count to be equal to the user space part,
>     so that the conditions are the same as before when probing is repeated.
> 
> (5) During ddi->drv->probe(), if the driver decrements the device's usage_count,
>     which it is supposed to do if it supports runtime PM, then runtime PM
>     should work for the device normally going forward (unless the .probe()
>     eventually fails, but then the driver is supposed to do the cleanup).

It would be okay if the normal runtime PM doesn't kick in until after 
the probe routine returns.  For example, if the PCI core made an extra 
call to pm_runtime_get_noresume() before ddi->drv->probe() and a 
matching call to pm_runtime_put_sync() afterward.

> (6) In pci_device_remove() we want the status to change to RPM_SUSPENDED and
>     the device's usage_count to be equal to the user space part after
>     drv->remove() has run.

Basically, pci_device_remove() should undo the actions taken by 
local_pci_probe().

> (7) We want neither the driver's nor the PCI bus type's PM callbacks
>     to be run after drv->remove() has returned (that's what happens now).

What if the driver doesn't support runtime PM?  Then you have
contradictory requirements: The device is in D0 before drv->remove()  
is called, the driver's remove routine won't do any runtime PM, and
you don't want any PM callbacks after drv->remove() returns.  So how
can the device get put back into D3?

Are you suggesting that the unbound device should remain in D0, even
though runtime PM is enabled and the status is SUSPENDED?  I don't
think that would be a good idea.

> > > Perhaps we can introduce something like
> > > 
> > > pm_runtime_get[_put]_skip_callbacks()
> > > 
> > > that would treat the device as though it had the power.no_callbacks flag
> > > set and use that around the driver's .probe() in the PCI core?
> > 
> > That would prevent the PM core from invoking the PCI subsystem's own 
> > callback, not just the driver's callback.  So I don't think that's what 
> > you want.
> 
> Actually, looking at the above, I think that's pretty much what I want. :-)

I don't agree.  In my opinion it would be better to invoke the PCI
bus-type callbacks and tell them somehow to skip calling the driver's
callbacks before drv->probe() or after drv->remove().

Alan Stern

