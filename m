Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993011Ab2KOKFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:05:08 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:45815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423166Ab2KOKFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:05:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
Date: Thu, 15 Nov 2012 11:09:23 +0100
Message-ID: <5598363.tz7oK2mU1s@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50117675.OVEdDFPCp3@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1211141608200.1620-100000@iolanthe.rowland.org> <1352941424.7176.261.camel@yhuang-dev> <50117675.OVEdDFPCp3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 15, 2012 10:51:42 AM Rafael J. Wysocki wrote:
> On Thursday, November 15, 2012 09:03:44 AM Huang Ying wrote:
> > On Thu, 2012-11-15 at 00:10 +0100, Rafael J. Wysocki wrote:
> > > On Wednesday, November 14, 2012 04:45:01 PM Alan Stern wrote:
> > > > On Wed, 14 Nov 2012, Rafael J. Wysocki wrote:
> > > > 
> > > > > > This has the side effect that when a driver unbinds, it can't leave the 
> > > > > > device in a special low-power state.  The device will always end up in 
> > > > > > the generic low-power state supported by the PCI core.
> > > > > 
> > > > > Well, I'm not sure I'd like that.
> > > > > 
> > > > > Let's just go back even one step more and think what we'd like to have in
> > > > > general terms and then how to implement it. :-)
> > > > > 
> > > > > Suppose that pci_pm_init() calls pm_runtime_enable() for all devices (in
> > > > > addition to what it does currently).  The runtime PM status of each device is
> > > > > RPM_SUSPENDED at this point.  Then:
> > > > 
> > > > Wait a moment.  When the device is detected and initialized, it is in
> > > > D0, right?  Currently we don't care much because the device starts out
> > > > disabled for runtime PM.  But now you are going to enable it.  While
> > > > the device is enabled, its runtime status should match the physical
> > > > power level.
> > > 
> > > OK
> > 
> > If my memory were correct, RPM_SUSPENDED just means device stop working,
> > but need not be put into low-power state.  So for RPM_ACTIVE, PCI
> > devices should be in D0, but for RPM_SUSPENDED, PCI devices can in any
> > power state.
> 
> Yes, that's correct and I was wrong when I thought we could require the
> status to be RPM_ACTIVE all the time when there's no driver, because that
> would prevent parents from being suspended.  And we want them to be able to
> suspend for driverless children, _unless_ user space has its attribute set
> to "on" (i.e. the default).
> 
> So it looks like what we want to do is:
> 
> (1) Enable runtime PM in pci_pm_init() and set the status to RPM_ACTIVE right
>     before, so that it is in agreement with the pm_runtime_forbid() we do in
>     there.
> 
> (2) If user space switches its attribute to "off" later, but before any
>     drivers are probed, we want the status to switch to RPM_SUSPENDED
>     _without_ actually changing the devices power state.  For that,
>     I think, we can make the PCI bus type's runtime PM callback ignore
>     devices without drivers (i.e. return 0 for them).
> 
> (3) When local_pci_probe() starts, after we've resumed the parent,
>     the device will be in D0 (it may be D0-uninitialized, though).
>     If the user space's attribute is "on" at this point, the parent's
>     resume doesn't change anything.  If it is "auto", the parent's
>     resume may actually transition the device, although its status
>     will still be RPM_SUSPENDED.  For consistency _and_ compatibility
>     with the current code, the driver's .probe() routine needs to see
>     the device RPM_ACTIVE and usage_count incremented, but we don't
>     want to run its PM callbacks _before_ .probe() runs.  For that
>     to work, I think, we can do something like pm_runtime_get_skip_callbacks(),
>     treating the device as though it had the power.no_callbacks flag set,
>     right before calling ddi->drv->probe().
> 
>     If the device has been RPM_ACTIVE at that point (i.e. user space has
>     had its attribute set to "on") it will just bump up usage_count (which
>     is what we want).  If the device has been RPM_SUSPENDED, it will
>     bump up usage_count _and_ change the status to RPM_ACTIVE without
>     executing any callbacks (the device is in D0 anyway, right?), which
>     is what we want too.
> 
> (4) If ddi->drv->probe() succeeds, we don't want to change anything, so
>     as not to confuse the driver, which is now in control of the device.
> 
> (5) If ddi->drv->probe() fails, we need to restore the situation from
>     before calling local_pci_probe(), but we want the pm_runtime_put(parent)
>     at the end of it to actually suspend the parent if user space has
>     its attribute (for the child!) set to "auto".
> 
>     Assume that the driver is not buggy and the failing ddi->drv->probe()
>     leaves the device in the same configuration as it's received it in.
>     Then, the device is RPM_ACTIVE and in D0 (which may be uninitialized).
>     For the parent's suspend to work, we need to transition it to
>     RPM_SUSPENDED, but again we don't want the driver's PM callbacks to
>     run at this point.  Moreover, we don't want the PCI bus type's
>     callbacks to run at this point, because dev->driver is still set.
>     So again, doing something like pm_runtime_put_skip_callbacks(),
>     treating the device as though it had power.no_callbacks set, seems
>     to be appropriate.
>    
>     Namely, if the user space's attribute is "on", it will just drop
>     usage_count by 1, which is what we want in that case.  If the user
>     space's attribute is "auto", on the other hand, it will drop
>     usage_count by 1 and change the status to RPM_SUSPENDED without
>     running callbacks, which again is what we want.
>     
> (6) In drv->remove() the driver is supposed to bump up usage_count by 1,
>     so as to restore the situation from before its .probe() routine
>     was called.  It also should leave the device as RPM_ACTIVE, because
>     that's what it's got in .probe().  Then, after drv->remove exits,
>     (and also if drv was NULL to start with), we want to drop usage_count
>     by 1.  Moreover, if the user space's attribute is "on", we don't
>     want anything more to happen, _but_ if that's "auto", we want to
>     suspend the parent.
> 
>     Note that dev->driver is still not NULL at this point (although
>     pci_dev->driver is!) so again we can't run the PCI bus type's callbacks.
>     It looks like, then, what we want to do here is
>     pm_runtime_put_skip_callbacks() again, because if the user space's
>     attribute is "on", it will just drop usage_count by 1, which is what
>     we want, and if that's "auto", it will additionally change the status
>     to RPM_SUSPENDED (without executing callbacks, which we want) _and_
>     it will queue up the parent's suspend (which, again, is what we want).
> 
> Did I miss anything?

Apparently, I did.  In (6), if drv is NULL to start with, we don't want
to do anything with runtime PM, except for checking if the parent can be
suspended, so we only need to do pm_request_idle(parent) in that case.
And we seem to have a bug in there right now, because we shouldn't
do the "Undo the runtime PM settings in local_pci_probe()" stuff in that
case I think.

That seems to be the only thing I missed, though, hopefully.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
