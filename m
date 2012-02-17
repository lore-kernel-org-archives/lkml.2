Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2BQXu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:50:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58858 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab2BQXu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:50:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Sat, 18 Feb 2012 00:54:49 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org> <201202142339.59423.rjw@sisk.pl> <1329378119.28581.34.camel@rui.sh.intel.com>
In-Reply-To: <1329378119.28581.34.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202180054.49284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 16, 2012, Zhang Rui wrote:
> On 二, 2012-02-14 at 23:39 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, February 14, 2012, Zhang Rui wrote:
> > > On 一, 2012-02-13 at 20:38 +0100, Rafael J. Wysocki wrote:
> > > > On Monday, February 13, 2012, Alan Stern wrote:
> > > > > On Mon, 13 Feb 2012, Lin Ming wrote:
> > > > > 
> > > > > > From: Zhang Rui <rui.zhang@intel.com>
> > > > > > 
> > > > > > Introduce flag can_power_off in device structure to support runtime
> > > > > > power off/on.
> > > > > > 
> > > > > > Note that, for a specific device driver,
> > > > > > "support runtime power off/on" means that the driver .runtime_suspend
> > > > > > callback needs to
> > > > > > 1) save all the context so that it can restore the device back to the previous
> > > > > >    working state after powered on.
> > > > > > 2) set can_power_off flag to tell the driver model that it's ready for power off.
> > > > > > 
> > > > > > The following example shows how this works.
> > > > > > 
> > > > > > device A
> > > > > >  |---------|
> > > > > >  v         v
> > > > > > device B  device C
> > > > > > 
> > > > > > A is the parent of device B and device C, and device A/B/C shares the
> > > > > > same power logic
> > > > > > (Only device A knows how to turn on/off the power).
> > > > > > 
> > > > > > In order to power off A, B, C at runtime,
> > > > > > 1) device B and device C should support runtime power off
> > > > > >    (runtime suspended with can_power_off flag set)
> > > > > > 2) pm idle request for device A is fired by runtime PM core.
> > > > > > 3) in device A .runtime_suspend callback, it tries to set can_power_off flag.
> > > > > > 4) if succeed, it means all its children have been ready for power off
> > > > > >    and it can turn off the power at any time.
> > > > > > 5) if failed, it means at least one of its children does not support runtime
> > > > > >    power off, thus the power can not be turned off.
> > > > > 
> > > > > I'm not sure if this is really the right approach.  What you're trying 
> > > > > to do is implement two different low-power states, basically D3hot and 
> > > > > D3cold.  Currently the runtime PM core doesn't support such things; all 
> > > > > it knows about is low power and full power.
> > > > 
> > > > I'd rather say all it knows about is "suspended" and "active", which mean
> > > > "the device is not processing I/O" and "the device may be processing I/O",
> > > > respectively.  A "suspended" device may or may not be in a low-power state,
> > > > but the runtime PM core doesn't care about that.
> > > > 
> > > yes, I know that.
> > > 
> > > > > Before doing an ad-hoc implementation, it would be best to step back
> > > > > and think about other subsystems.  Other sorts of devices may well have
> > > > > multiple low-power states.  What's the best way for this to be
> > > > > supported by the PM core?
> > > > 
> > > > Well, I honestly don't think there's any way they all can be covered at the
> > > > same time and that's why we chose to support only "suspended" and "active"
> > > > as defined above.
> > > 
> > > > The handling of multiple low-power states must be
> > > > implemented outside of the runtime PM core (like in the PCI core, for example).
> > > 
> > > Surely I'd prefer to implement it in the bus code, :), but the problem
> > > is that several buses maybe involved at the same time.
> > > Let's take ZPODD for example,
> > > ZPODD is attached to a SATA port. Only SATA port knows that it can be
> > > runtime powered off, because its ACPI node has _PR3._OFF.
> > > But when ATA layer code tries to put SATA port to D3_COLD at runtime,it
> > > must make sure all the devices/drivers in the same power domain are
> > > ready for power off, and in this case, we need to get this info from
> > > SCSI layer.
> > 
> > Then you need to get it from there.  I know that this is a difficult problem,
> 
> Yeah, I have thought about this for quite a while before, there ARE
> several ways to do this, but these need a lot of changes in bus code, at
> least for the buses that support device runtime D3 (off) by ACPI.
> 
> Lets also take SATA port and ZPODD for example,
> proposal one,
> 1) introduce scsi_can_power_off and ata_can_power_off.
> 2) sr driver set scsi_can_power_off bit and scsi layer is aware of this,
> thus the scsi host can set this bit as well.
> 3) in the .runtime_suspend callback of ata port, it knows that its scsi
> host interface can be powered off, thus it invokes ata_can_power_off to
> tell the ata layer.

Hmm.  I'm not sure why you want to introduce this special "power off"
condition.  In fact, it's nothing special, it only means that the device
in question shouldn't be accessed by software, which pretty much is equivalent
to the "suspended" condition (as defined in the runtime PM docs).

> proposal two,
> introduce a platform callback for each bus.
> And it is invoked immediately after the scsi_driver->runtime_suspend
> being invoked in scsi_bus->runtime_suspend.
> The platform callback checks the scsi lower power state of the
> scsi_device and choose a compatible ACPI D-state for the device.
> The decision of whether to use ACPI D3 (off) or not is made in the
> platform callback.
> 
> what do you think?

I think you need to consider that at a more abstract level.

> > have been working on a similar one for several months now. :-)
> 
> That's why generic power domain is introduced?
> Can you tell me what's your idea please?
> It would be GREAT if you can share your experience on this.

Well, a power domain (which seems to be what you have in the ZPODD case)
is analogous to a package with multiple CPU cores.  In that case you
can put individual cores into per-core low-power ("idle") states (that
roughly corresponds to the D1-D3hot device states) or you can put the
whole package into a low-power state ("package idle") resulting in the
removal of power from all the cores (more-or-less).  Now, it has to be
decided which approach to use and if the "package idle" is used, it may
be necessary to restore the cores' "state" when they are "resumed".

Analogously, for devices in a power domain you usually can use some
programmable mechanism to put each of them into some sort of a low-power
state (e.g. D3hot or "stop clock" etc.) such that the device may be programmed
to go out of it.  Alternatively, you can use a different mechanism to
remove power from the entire domain, in which case devices, when power is
restored, may need to be re-initialized.  Of course, you need to know when
this happens, so that you know when to carry out the re-initialization.

Our approach in the generic PM domains framework is, essentially, to provide
a special set of PM callbacks ("domain callbacks") that are run (by the PM
core) instead of bus-type PM callbacks.  Those domain callbacks are added to
every device in the domain through its pm_domain pointer.  Of course, this
means that devices have to be added to the domains explicitly and we have some
helpers for that.  We also use some additional data structures allowing the
domain callbacks to track devices in the domain.

Now, when a device in a domain is "suspended" (meaning its runtime PM status
changes from "active" to "suspended"), the domain callbacks check if this is
the last device in the domain whose status is "active" at that point.  If
that is not the case, they simply call a special .stop() callback to put the
device into a "normal" per-device low-power state (the .stop() callback may be
defined per device and in principle it may be designed to call the bus-type
or driver .runtime_suspend() callback for the device).  Otherwise (i.e. if
this is the last device in the domain whose status was "active" before) and if
the PM QoS constraints allow that to happen, power is removed from the domain
as a whole.  Then, all devices in the domain are marked as "need re-init upon
resume" and the resume domain callbacks take care of re-initializing them as
appropriate when their status changes from "suspended" back to "active".  [The
domain callbacks use the subsys_data pointer in dev_pm_info to attach their own
data to device objects.]

The actual code is more complicated than that, but that's the idea.

Thanks,
Rafael
