Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768038Ab2KOP1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:27:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52941 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753758Ab2KOP1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:27:06 -0500
Date: Thu, 15 Nov 2012 10:27:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Huang Ying <ying.huang@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <5598363.tz7oK2mU1s@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1211150959370.1651-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Rafael J. Wysocki wrote:

> > So it looks like what we want to do is:
> > 
> > (1) Enable runtime PM in pci_pm_init() and set the status to RPM_ACTIVE right
> >     before, so that it is in agreement with the pm_runtime_forbid() we do in
> >     there.
> > 
> > (2) If user space switches its attribute to "off" later, but before any
> >     drivers are probed, we want the status to switch to RPM_SUSPENDED
> >     _without_ actually changing the devices power state.  For that,
> >     I think, we can make the PCI bus type's runtime PM callback ignore
> >     devices without drivers (i.e. return 0 for them).

Okay, so driverless PCI devices will always be in D0.  But you do allow 
their parents to go to low power.  Is that going to cause any problems?

> > (3) When local_pci_probe() starts, after we've resumed the parent,
> >     the device will be in D0 (it may be D0-uninitialized, though).
> >     If the user space's attribute is "on" at this point, the parent's
> >     resume doesn't change anything.  If it is "auto", the parent's
> >     resume may actually transition the device, although its status
> >     will still be RPM_SUSPENDED.  For consistency _and_ compatibility
> >     with the current code, the driver's .probe() routine needs to see
> >     the device RPM_ACTIVE and usage_count incremented, but we don't
> >     want to run its PM callbacks _before_ .probe() runs.  For that
> >     to work, I think, we can do something like pm_runtime_get_skip_callbacks(),
> >     treating the device as though it had the power.no_callbacks flag set,
> >     right before calling ddi->drv->probe().

Instead of changing the PM core, wouldn't it be simpler to test whether
or not pci_dev->driver is NULL at the start of the PCI runtime methods?  
The same test could be used for (2) above.

All that would be needed would be to move the line that sets
pci_dev->driver from where it is in __pci_device_probe() to
local_pci_probe(), just before ddi->drv->probe() is called and just 
after calling pm_runtime_get_sync().

> >     If the device has been RPM_ACTIVE at that point (i.e. user space has
> >     had its attribute set to "on") it will just bump up usage_count (which
> >     is what we want).  If the device has been RPM_SUSPENDED, it will
> >     bump up usage_count _and_ change the status to RPM_ACTIVE without
> >     executing any callbacks (the device is in D0 anyway, right?), which
> >     is what we want too.
> > 
> > (4) If ddi->drv->probe() succeeds, we don't want to change anything, so
> >     as not to confuse the driver, which is now in control of the device.
> > 
> > (5) If ddi->drv->probe() fails, we need to restore the situation from
> >     before calling local_pci_probe(), but we want the pm_runtime_put(parent)
> >     at the end of it to actually suspend the parent if user space has
> >     its attribute (for the child!) set to "auto".

If the probe fails, set pci_dev->driver back to NULL and then call
pm_runtime_put_sync() or pm_runtime_put().

> >     Assume that the driver is not buggy and the failing ddi->drv->probe()
> >     leaves the device in the same configuration as it's received it in.
> >     Then, the device is RPM_ACTIVE and in D0 (which may be uninitialized).
> >     For the parent's suspend to work, we need to transition it to
> >     RPM_SUSPENDED, but again we don't want the driver's PM callbacks to
> >     run at this point.  Moreover, we don't want the PCI bus type's
> >     callbacks to run at this point, because dev->driver is still set.
> >     So again, doing something like pm_runtime_put_skip_callbacks(),
> >     treating the device as though it had power.no_callbacks set, seems
> >     to be appropriate.
> >    
> >     Namely, if the user space's attribute is "on", it will just drop
> >     usage_count by 1, which is what we want in that case.  If the user
> >     space's attribute is "auto", on the other hand, it will drop
> >     usage_count by 1 and change the status to RPM_SUSPENDED without
> >     running callbacks, which again is what we want.
> >     
> > (6) In drv->remove() the driver is supposed to bump up usage_count by 1,
> >     so as to restore the situation from before its .probe() routine
> >     was called.  It also should leave the device as RPM_ACTIVE, because
> >     that's what it's got in .probe().  Then, after drv->remove exits,
> >     (and also if drv was NULL to start with), we want to drop usage_count
> >     by 1.  Moreover, if the user space's attribute is "on", we don't
> >     want anything more to happen, _but_ if that's "auto", we want to
> >     suspend the parent.

Shouldn't pci_device_remove() end up doing essentially the same thing 
as the failure path in local_pci_probe()?

> >     Note that dev->driver is still not NULL at this point (although
> >     pci_dev->driver is!) so again we can't run the PCI bus type's callbacks.
> >     It looks like, then, what we want to do here is
> >     pm_runtime_put_skip_callbacks() again, because if the user space's
> >     attribute is "on", it will just drop usage_count by 1, which is what
> >     we want, and if that's "auto", it will additionally change the status
> >     to RPM_SUSPENDED (without executing callbacks, which we want) _and_
> >     it will queue up the parent's suspend (which, again, is what we want).
> > 
> > Did I miss anything?
> 
> Apparently, I did.  In (6), if drv is NULL to start with, we don't want
> to do anything with runtime PM, except for checking if the parent can be
> suspended, so we only need to do pm_request_idle(parent) in that case.
> And we seem to have a bug in there right now, because we shouldn't
> do the "Undo the runtime PM settings in local_pci_probe()" stuff in that
> case I think.

How can pci_device_remove() ever get called with either dev->driver or
pci_dev->driver equal to NULL?

Alan Stern

