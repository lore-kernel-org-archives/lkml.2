Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2KNTi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:38:27 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:44189 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab2KNTi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:38:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
Date: Wed, 14 Nov 2012 20:42:47 +0100
Message-ID: <1808040.vTl5iT6HSY@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1211141127440.1620-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1211141127440.1620-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 14, 2012 11:42:33 AM Alan Stern wrote:
> On Wed, 14 Nov 2012, Rafael J. Wysocki wrote:
> 
> > On Thursday, November 08, 2012 12:07:54 PM Alan Stern wrote:
> > > On Thu, 8 Nov 2012, Rafael J. Wysocki wrote:
> > 
> > [...]
> > 
> > I'd like to revisit this for a while if you don't mind.
> 
> Not at all.
> 
> > > Your revised patch does do the job, except for a few problems.  
> > > Namely, while local_pci_probe() and pci_device_remove() are running,
> > > the device _does_ have a driver.
> > 
> > Right.
> > 
> > > This means that local_pci_probe() should not call pm_runtime_get_sync(),
> > > for example.  Doing so would invoke the driver's runtime_resume routine
> > > before calling the driver's probe routine!
> > > 
> > > The USB subsystem solves this problem by carefully keeping track of the 
> > > state of the device-driver binding:
> > > 
> > > 	Originally the device is UNBOUND.
> > > 
> > > 	At the start of the subsystem's probe routine, the state
> > > 	changes to BINDING.
> > > 
> > > 	If the probe succeeds then it changes to BOUND; otherwise
> > > 	it goes back to UNBOUND.
> > > 
> > > 	At the start of the subsystem's remove routine, the state
> > > 	changes to UNBINDING.  At the end it goes to UNBOUND.
> > > 
> > > When the state is anything other than BOUND, the subsystem's runtime PM 
> > > routines act as though there is no driver.
> > 
> > Well, that wouldn't help PCI, because some drivers want to use the
> > pm_runtime_* stuff in their .probe() routines and actually expect it to
> > work. :-)
> 
> PCI could do something like this:
> 
> 	local_pci_probe() calls pm_runtime_get_sync() twice before
> 	it changes the binding state to BINDING.  It then calls 
> 	pm_runtime_put_sync() after the state is BOUND.
> 
> 	pci_device_remove() calls pm_runtime_get_sync() before it
> 	changes the binding state to UNBINDING.  It then calls
> 	pm_runtime_put_sync() twice after the state is UNBOUND.
> 
> (Obviously some of those calls could be _get_noresume() or
> _put_noidle().)
> 
> This has the side effect that when a driver unbinds, it can't leave the 
> device in a special low-power state.  The device will always end up in 
> the generic low-power state supported by the PCI core.

Well, I'm not sure I'd like that.

Let's just go back even one step more and think what we'd like to have in
general terms and then how to implement it. :-)

Suppose that pci_pm_init() calls pm_runtime_enable() for all devices (in
addition to what it does currently).  The runtime PM status of each device is
RPM_SUSPENDED at this point.  Then:

(1) We want to keep the current semantics during probe, i.e. the device should
    (a) be RPM_ACTIVE and (b) have usage_count == (user space usage_count + 1)
    right before ddi->drv->probe() is executed.

(2) We don't want the driver's PM callbacks to be run before ddi->drv->probe().
    There's a question if we want the bus type's PM callbacks to be run at
    that point, but they are not run currently and IMO we shouldn't change
    that.

(4) If ddi->drv->probe() fails, we want the device's status to change to
    RPM_SUSPENDED and it's usage_count to be equal to the user space part,
    so that the conditions are the same as before when probing is repeated.

(5) During ddi->drv->probe(), if the driver decrements the device's usage_count,
    which it is supposed to do if it supports runtime PM, then runtime PM
    should work for the device normally going forward (unless the .probe()
    eventually fails, but then the driver is supposed to do the cleanup).

(6) In pci_device_remove() we want the status to change to RPM_SUSPENDED and
    the device's usage_count to be equal to the user space part after
    drv->remove() has run.

(7) We want neither the driver's nor the PCI bus type's PM callbacks
    to be run after drv->remove() has returned (that's what happens now).

> > Perhaps we can introduce something like
> > 
> > pm_runtime_get[_put]_skip_callbacks()
> > 
> > that would treat the device as though it had the power.no_callbacks flag
> > set and use that around the driver's .probe() in the PCI core?
> 
> That would prevent the PM core from invoking the PCI subsystem's own 
> callback, not just the driver's callback.  So I don't think that's what 
> you want.

Actually, looking at the above, I think that's pretty much what I want. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
