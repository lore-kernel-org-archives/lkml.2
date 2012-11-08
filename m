Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2KHRH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:07:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55661 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751267Ab2KHRHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:07:55 -0500
Date: Thu, 8 Nov 2012 12:07:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Huang Ying <ying.huang@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <1434035.IipKXWk2Vr@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1211081125470.1280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012, Rafael J. Wysocki wrote:

> > > > is it a good idea to allow to set device state to SUSPENDED if the device
> > > > is disabled?
> > > 
> > > No, it is not.  The status should always be ACTIVE as long as usage_count > 0.

That isn't strictly true, because pm_runtime_get_noresume violates this
rule.  What the PM core actually does is prevent a transition from the
ACTIVE state to the SUSPENDING/SUSPENDED state if usage_count > 0,
_provided_ runtime PM is enabled.  There's no such restriction when it
is disabled.

BTW, do we need to think about what happens in the case where the
device _does_ have a driver and for some reason the driver has disabled
the device for runtime PM?  I would just as soon ignore the issue.

> > > However, in some cases we actually would like to change the status to
> > > SUSPENDED when usage_count becomes equal to 0, because that means we can
> > > suspend (I mean really suspend) the parents of the devices in question
> > > (and we want to notify the parents in those cases).
> > 
> > So do you think Alan Stern's suggestion about forbidden and disabled is
> > the right way to go?
> 
> I'm not really sure about that.
> 
> My original idea was that the runtime PM status and usage counter would
> only matter when runtime PM of a device was enabled.  That leads to
> problems, though, when we enable runtime PM of a device whose usage
> counter is greater from zero and status is SUSPENDED.

That doesn't seem to be a problem.  It can arise without disabling
runtime PM at all -- just call pm_runtime_get_noresume.

>  Also when the
> device's status is ACTIVE, but its parent's child count is 0.

__pm_runtime_set_status prevents this situation from arising.  When the 
device's status is set to ACTIVE, the parent's child count is 
incremented.  So this isn't a problem either.

> It's not very easy to fix this at the core level, though, because we
> depend on the current behavior in some places.  I'm thinking that
> perhaps pm_runtime_enable() should just WARN() if things are obviously
> inconsistent (although there still may be problems, for example, if the
> parent's child count is 2 when we enable runtime PM for its child, but that
> child is the only one it actually has).

I think we should continue the original strategy of ignoring the status
and usage counter when runtime PM is disabled.  This is definitely the
easiest and most straightforward approach.  Fixing the problem at hand
(VGA controllers) by changing the PCI subsystem seems like the simplest
solution.

Your revised patch does do the job, except for a few problems.  
Namely, while local_pci_probe() and pci_device_remove() are running,
the device _does_ have a driver.  This means that local_pci_probe()
should not call pm_runtime_get_sync(), for example.  Doing so would
invoke the driver's runtime_resume routine before calling the driver's
probe routine!

The USB subsystem solves this problem by carefully keeping track of the 
state of the device-driver binding:

	Originally the device is UNBOUND.

	At the start of the subsystem's probe routine, the state
	changes to BINDING.

	If the probe succeeds then it changes to BOUND; otherwise
	it goes back to UNBOUND.

	At the start of the subsystem's remove routine, the state
	changes to UNBINDING.  At the end it goes to UNBOUND.

When the state is anything other than BOUND, the subsystem's runtime PM 
routines act as though there is no driver.  This works because the 
subsystem makes sure that the device is ACTIVE with a nonzero usage 
count before calling the driver's probe or remove routine, so no 
runtime PM callbacks can occur at these awkward times.

If PCI adopted this strategy then your new patch would work okay.  I 
think -- I haven't checked it thoroughly.

Alan Stern

