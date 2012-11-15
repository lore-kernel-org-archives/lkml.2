Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946045Ab2KOBDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:03:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:7857 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab2KOBDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:03:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,254,1352102400"; 
   d="scan'208";a="249302232"
Message-ID: <1352941424.7176.261.camel@yhuang-dev>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Thu, 15 Nov 2012 09:03:44 +0800
In-Reply-To: <37583314.JAxoSZqTsM@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1211141608200.1620-100000@iolanthe.rowland.org>
	 <37583314.JAxoSZqTsM@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 00:10 +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 14, 2012 04:45:01 PM Alan Stern wrote:
> > On Wed, 14 Nov 2012, Rafael J. Wysocki wrote:
> > 
> > > > This has the side effect that when a driver unbinds, it can't leave the 
> > > > device in a special low-power state.  The device will always end up in 
> > > > the generic low-power state supported by the PCI core.
> > > 
> > > Well, I'm not sure I'd like that.
> > > 
> > > Let's just go back even one step more and think what we'd like to have in
> > > general terms and then how to implement it. :-)
> > > 
> > > Suppose that pci_pm_init() calls pm_runtime_enable() for all devices (in
> > > addition to what it does currently).  The runtime PM status of each device is
> > > RPM_SUSPENDED at this point.  Then:
> > 
> > Wait a moment.  When the device is detected and initialized, it is in
> > D0, right?  Currently we don't care much because the device starts out
> > disabled for runtime PM.  But now you are going to enable it.  While
> > the device is enabled, its runtime status should match the physical
> > power level.
> 
> OK

If my memory were correct, RPM_SUSPENDED just means device stop working,
but need not be put into low-power state.  So for RPM_ACTIVE, PCI
devices should be in D0, but for RPM_SUSPENDED, PCI devices can in any
power state.

Best Regards,
Huang Ying


> > This means the initialization routine would have to call
> > pm_runtime_set_active() before pm_runtime_enable().  If you then wanted
> > to change the status to RPM_SUSPENDED, you would actually have to put
> > the device into D3 by calling pm_runtime_suspend() (or maybe
> > pm_runtime_schedule_suspend() to give drivers some time to get loaded 
> > and bind).
> 
> No, I don't want that.  It may be RPM_ACTIVE all the time as long as the
> device doesn't have a driver.  Which probably would even make things
> simpler. :-)
> 
> > > (1) We want to keep the current semantics during probe, i.e. the device should
> > >     (a) be RPM_ACTIVE and (b) have usage_count == (user space usage_count + 1)
> > >     right before ddi->drv->probe() is executed.
> > 
> > In theory the usage_count could be higher and then adjusted back after
> > the probe is finished, if that would make anything easier.
> 
> No, it wouldn't, because of (5).  Suppose that the driver wants to suspend
> the device directly from .probe() and the user space doesn't mind.  We can't
> prevent that from being doable.
> 
> > > (2) We don't want the driver's PM callbacks to be run before ddi->drv->probe().
> > >     There's a question if we want the bus type's PM callbacks to be run at
> > >     that point, but they are not run currently and IMO we shouldn't change
> > >     that.
> > 
> > The device is supposed to be in D0 when it is probed.  Since we are
> > assuming that initialization is now going to leave it in D3, there's no
> > choice -- you _have_ to invoke pci_pm_runtime_resume(), which would
> > invoke the driver's callback, which we don't want.
> 
> Let's say the device will stay in D0 after the initialization and then
> we'll require that it be in D0 if .probe() fails or after .remove().
> 
> The only thing we'll need to do before .probe() in that case is to
> bump up the usage counter and then to bump it down if .probe() fails
> (and after .remove()).
> 
> The only problem we have in that case are buggy drivers that leave
> devices in, say, D3cold after a failing .probe().  That doesn't
> seem to be avoidable, though.
> 
> Thanks,
> Rafael
> 
> 


