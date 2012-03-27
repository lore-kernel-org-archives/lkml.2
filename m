Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2C0TfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:35:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab2C0TfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:35:11 -0400
Message-ID: <1332876883.29722.143.camel@bling.home>
Subject: Re: [PATCH 1/2] Isolation groups
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: aik@ozlabs.ru, dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 27 Mar 2012 13:34:43 -0600
In-Reply-To: <20120327051407.GJ9357@truffala.fritz.box>
References: <20120312220109.30321.83419.stgit@bling.home>
	 <20120312223254.30321.74405.stgit@bling.home>
	 <20120313143340.GT24916@truffala.fritz.box>
	 <1331657387.2969.79.camel@bling.home>
	 <20120314095808.GX24916@truffala.fritz.box>
	 <1331842501.22038.58.camel@ul30vt>
	 <20120316034527.GJ24916@truffala.fritz.box>
	 <1331926278.13855.57.camel@bling.home>
	 <20120317045734.GL24916@truffala.fritz.box>
	 <1332364378.13855.236.camel@bling.home>
	 <20120327051407.GJ9357@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 16:14 +1100, David Gibson wrote:
> On Wed, Mar 21, 2012 at 03:12:58PM -0600, Alex Williamson wrote:
> > On Sat, 2012-03-17 at 15:57 +1100, David Gibson wrote:
> > > On Fri, Mar 16, 2012 at 01:31:18PM -0600, Alex Williamson wrote:
> > > > On Fri, 2012-03-16 at 14:45 +1100, David Gibson wrote:
> > > > > On Thu, Mar 15, 2012 at 02:15:01PM -0600, Alex Williamson wrote:
> > > > > > On Wed, 2012-03-14 at 20:58 +1100, David Gibson wrote:
> > > > > > > On Tue, Mar 13, 2012 at 10:49:47AM -0600, Alex Williamson wrote:
> > > > > > > > On Wed, 2012-03-14 at 01:33 +1100, David Gibson wrote:
> > > > > > > > > On Mon, Mar 12, 2012 at 04:32:54PM -0600, Alex Williamson wrote:
> > > > > > > > > > +/*
> > > > > > > > > > + * Add a device to an isolation group.  Isolation groups start empty and
> > > > > > > > > > + * must be told about the devices they contain.  Expect this to be called
> > > > > > > > > > + * from isolation group providers via notifier.
> > > > > > > > > > + */
> > > > > > > > > 
> > > > > > > > > Doesn't necessarily have to be from a notifier, particularly if the
> > > > > > > > > provider is integrated into host bridge code.
> > > > > > > > 
> > > > > > > > Sure, a provider could do this on it's own if it wants.  This just
> > > > > > > > provides some infrastructure for a common path.  Also note that this
> > > > > > > > helps to eliminate all the #ifdef CONFIG_ISOLATION in the provider.  Yet
> > > > > > > > to be seen whether that can reasonably be the case once isolation groups
> > > > > > > > are added to streaming DMA paths.
> > > > > > > 
> > > > > > > Right, but other than the #ifdef safety, which could be achieved more
> > > > > > > simply, I'm not seeing what benefit the infrastructure provides over
> > > > > > > directly calling the bus notifier function.  The infrastructure groups
> > > > > > > the notifiers by bus type internally, but AFAICT exactly one bus
> > > > > > > notifier call would become exactly one isolation notifier call, and
> > > > > > > the notifier callback itself would be almost identical.
> > > > > > 
> > > > > > I guess I don't see this as a fundamental design point of the proposal,
> > > > > > it's just a convenient way to initialize groups as a side-band addition
> > > > > > until isolation groups become a more fundamental part of the iommu
> > > > > > infrastructure.  If you want to do that level of integration in your
> > > > > > provider, do it and make the callbacks w/o the notifier.  If nobody ends
> > > > > > up using them, we'll remove them.  Maybe it will just end up being a
> > > > > > bootstrap.  In the typical case, yes, one bus notifier is one isolation
> > > > > > notifier.  It does however also allow one bus notifier to become
> > > > > > multiple isolation notifiers, and includes some filtering that would
> > > > > > just be duplicated if every provider decided to implement their own bus
> > > > > > notifier.
> > > > > 
> > > > > Uh.. I didn't notice any filtering?  That's why I'm asking.
> > > > 
> > > > Not much, but a little:
> > > > 
> > > > +       switch (action) {
> > > > +       case BUS_NOTIFY_ADD_DEVICE:
> > > > +               if (!dev->isolation_group)
> > > > +                       blocking_notifier_call_chain(&notifier->notifier,
> > > > +                                       ISOLATION_NOTIFY_ADD_DEVICE, dev);
> > > > +               break;
> > > > +       case BUS_NOTIFY_DEL_DEVICE:
> > > > +               if (dev->isolation_group)
> > > > +                       blocking_notifier_call_chain(&notifier->notifier,
> > > > +                                       ISOLATION_NOTIFY_DEL_DEVICE, dev);
> > > > +               break;
> > > > +       }
> T> > 
> > > 
> > > Ah, I see, fair enough.
> > > 
> > > A couple of tangential observations.  First, I suspect using
> > > BUS_NOTIFY_DEL_DEVICE is a very roundabout way of handling hot-unplug,
> > > it might be better to have an unplug callback in the group instead.
> > 
> > There's really one already.  Assuming the device is attached to a group
> > driver, the .remove entry point on the driver will get called first.  It
> > doesn't get to return error, but it can block.
> 
> Hrm.  Assuming the isolation provider has installed a driver for the
> relevant bus type.  And as we're discussing elsewhere, I think we have
> situations where the groups will get members on (subordinate) busses
> which the isolation provider doesn't have explicit knowledge of.
> 
> > The DEL_DEVICE will only
> > happen after the group driver has relinquished the device, or at least
> > returned from remove().  For a device with no driver, the group would
> > only learn about it through the notifier, but it probably doesn't need
> > anything more direct.
> 
> DEL_DEVICE is certainly sufficient, it just seems a bit unnecessarily
> awkward.
> 
> > > Second, I don't think aborting the call chain early for hot-plug is
> > > actually a good idea.  I can't see a clear guarantee on the order, so
> > > individual providers couldn't rely on that short-cut behaviour.  Which
> > > means that if two providers would have attempted to claim the same
> > > device, something is seriously wrong and we should probably report
> > > that.
> > 
> > Yeah, that seems like a reasonable safety check.
> > 
> > > > > > > > > So, somewhere, I think we need a fallback path, but I'm not sure
> > > > > > > > > exactly where.  If an isolation provider doesn't explicitly put a
> > > > > > > > > device into a group, the device should go into the group of its parent
> > > > > > > > > bridge.  This covers the case of a bus with IOMMU which has below it a
> > > > > > > > > bridge to a different type of DMA capable bus (which the IOMMU isn't
> > > > > > > > > explicitly aware of).  DMAs from devices on the subordinate bus can be
> > > > > > > > > translated by the top-level IOMMU (assuming it sees them as coming
> > > > > > > > > from the bridge), but they all need to be treated as one group.
> > > > > > > > 
> > > > > > > > Why would the top level IOMMU provider not set the isolation group in
> > > > > > > > this case.
> > > > > > > 
> > > > > > > Because it knows nothing about the subordinate bus.  For example
> > > > > > > imagine a VT-d system, with a wacky PCI card into which you plug some
> > > > > > > other type of DMA capable device.  The PCI card is acting as a bridge
> > > > > > > from PCI to this, let's call it FooBus.  Obviously the VT-d code won't
> > > > > > > have a FooBus notifier, since it knows nothing about FooBus.  But the
> > > > > > > FooBus devices still need to end up in the group of the PCI bridge
> > > > > > > device, since their DMA operations will appear as coming from the PCI
> > > > > > > bridge card to the IOMMU, and can be isolated from the rest of the
> > > > > > > system (but not each other) on that basis.
> > > > > > 
> > > > > > I guess I was imagining that it's ok to have devices without an
> > > > > > isolation group.
> > > > > 
> > > > > It is, but having NULL isolation group has a pretty specific meaning -
> > > > > it means it's never safe to give that device to userspace, but it also
> > > > > means that normal kernel driver operation of that device must not
> > > > > interfere with anything in any iso group (otherwise we can never no
> > > > > that those iso groups _are_ safe to hand out).  Likewise userspace
> > > > > operation of any isolation group can't mess with no-group devices.
> > > > 
> > > > This is where wanting to use isolation groups as the working unit for an
> > > > iommu ops layer and also wanting to use iommu ops to replace dma ops
> > > > seem to collide a bit.  Do we want two interfaces for dma, one group
> > > > based and one for non-isolated devices?
> > > 
> > > Well, I don't know enough about what dwmw2 had planned to answer
> > > that.  I was assuming the in-kernel dma reply would remain device/bus
> > > focussed, and how it looked up and used the groups was an internal
> > > matter.  I would expect it would probably need a fallback path for "no
> > > group" for transition purposes, even if it wasn't planned to keep that
> > > forever.
> > 
> > Hmm, I think the value of a core isolation group layer starts to fall
> > apart if an iommu driver can't count on a group being present for any
> > device that might do dma.  Some ideas below.
> 
> Ah, yes, to clarify: I think anything subject to IOMMU translation
> should have a group (which might need a no-manager flag).  However,
> for devices with no IOMMU, or with an IOMMU we can switch permanently
> into bypass mode, I think it's reasonable to leave them without group.
> 
> > > >  Isolation providers like
> > > > intel-iommu would always use one, non-isolation capable dma paths, like
> > > > swiotlb or non-isolation hardware iommus, would use another.  And how do
> > > > we factor in the degree of isolation to avoid imposing policy in the
> > > > kernel?  MSI isolation is an example.  We should allow userspace to set
> > > > a policy of whether lack of MSI protection is an acceptable risk.  Does
> > > > that mean we can have isolation groups that provide no isolation and
> > > > sysfs files indicating capabilities?  Perhaps certain classes of groups
> > > > don't even allow manager binding?
> > > 
> > > Ugh.  I thought about flagging groups with some sort of bitmap of
> > > isolation strength properties, but I think that way lies madness.  We
> > > might want a global policy bitmask though which expresses which
> > > constraints are acceptable risks.  The providers would then have to
> > > provide groups which are as strong as requested, or none at all.
> > 
> > That's effectively how the current iommu_device_group() interface works;
> > identify isolate-able groups, or none at all.  I don't think we get that
> > luxury if we push isolation groups down into the device layer though.
> > If we want to use them for dma_ops and to solve various device quirks,
> > they can't only be present on some configurations.  I think you're right
> > on the global policy though, we just need to apply it differently.  I'm
> > thinking we need something like "isolation_allow=" allowing options of
> > "nomsi" and "nop2p" (just for starters).  When a provider creates a
> > group, they provide a set of flags for the group.  A manager is not
> > allowed to bind to the group if the global policy doesn't match the
> > group flags.  We'll need some support functions, maybe even a sysfs
> > file, so userspace can know in advance and vfio can avoid creating
> > entries for unusable groups.
> 
> Just banning managers for groups of insufficient strength isn't quite
> enough, because that doesn't allow for consolidation of several
> poorly-isolated groups into one strongly isolated groups which may be
> possible on some hardware configurations.

This is the part where things start to completely fall apart.

> > > > > None of these conditions is true for the hypothetical Foobus case.
> > > > > The bus as a whole could be safely given to userspace, the devices on
> > > > > it *could* mess with an existing isolation group (suppose the group
> > > > > consisted of a PCI segment with the FooBus bridge plus another PCI
> > > > > card - FooBus DMAs would be bridged onto the PCI segment and might
> > > > > target the other card's MMIO space).  And other grouped devices can
> > > > > certainly mess with the FooBus devices (if userspace grabs the bridge
> > > > > and manipulates its IOMMU mappings, that would clearly screw up any
> > > > > kernel drivers doing DMA from FooBus devices behind it).
> > > > 
> > > > ---segment-----+---------------+
> > > >                |               |
> > > >         [whackyPCIcard]   [other device]
> > > >                |
> > > >                +---FooBus---+-------+
> > > >                             |       |
> > > >                        [FooDev1] [FooDev2]
> > > > 
> > > > This is another example of the quality of the isolation group and what
> > > > factors we incorporate in judging that.  If the bridge/switch port
> > > > generating the segment does not support or enable PCI ACS then the IOMMU
> > > > may be able to differentiate whackyPCIcard from the other device but not
> > > > prevent peer-to-peer traffic between the two (or between FooDevs and the
> > > > other device - same difference).  This would suggest that we might have
> > > > an isolation group at the root of the segment for which the provider can
> > > > guarantee isolation (includes everything on and below the bus), and we
> > > > might also have isolation groups at whackyPCIcard and the other device
> > > > that have a difference quality of isolation.  /me pauses for rant about
> > > > superior hardware... ;)
> > > 
> > > Nested isolation groups? Please no.
> > > 
> > > An isolation group at the bridge encompassing that segment was exactly
> > > what I had in mind, but my point is that all the FooBus devices *also*
> > > need to be in that group, even though the isolation provider knows
> > > nothing about FooBus.
> > 
> > If we're able to strictly say "no isolation = no group" and ignore
> > FooBus for a moment, yes, the group at the bridge makes sense.  But as I
> > said, I don't think we get that luxury.  There will be different
> > "acceptable" levels of isolation and we'll need to support both the
> > model of single group encompassing the segment as well as separate
> > isolation groups for each device, whackyPCICard/other.
> 
> Well, sure.  But in that case, the FooBus devices still need to live
> in the same group as their bridge card, since they're subject to the
> same translations.
> 
> > A question then is how do we support both?  Perhaps it's a provider
> > option whether to only create fully isolated group, which makes it
> > traverse up to the segment.  The default might be to make separate
> > groups at whackyPCICard and other, each with the nop2p flag.  It gets a
> > lot more complicated, but maybe we support both so if system policy
> > prevents a manager from binding to a sub-group due to nop2p, it can walk
> > up a level.  I suspect dma_ops always wants the closer group to avoid
> > traversing levels.
> 
> Yeah.  I really wish I knew more about what dwmw2 had in mind.
> 
> > Back to FooBus, dma_ops only knows how to provide dma for certain types
> > of devices.  intel-iommu only knows about struct pci_dev.  So if FooDev
> > needed to do dma, it would need some kind of intermediary to do the
> > mapping via whackyPCICard.  So from that perspective, we could get away
> > w/o including FooBus devices in the group.
> 
> That seems very fragile  Logically the FooBus devices should be in the
> same group.  Yes, the FooBus dma hooks will need to know how to find
> the bridge PCI card and thereby manipulate it's IOMMU mappings, but
> they still belong in the same isolation group.
> 
> >  Of course if we want a
> > manager to attach to the group at whackyPCICard (ignoring nop2p), we
> > need to put requirements on the state of the FooDevs.  I think that
> > might actually give some credibility to nested groups, hierarchical
> > really, ie if we need to walk all the devices below a group, why not
> > allow groups below a group?  I don't like it either, but I'm not sure
> > it's avoidable.
> 
> Urgh.  Nested groups, a group parent must always have a strictly
> stronger set of isolation properties than subgroups.  I suppose that
> could work, it's really setting off my over-engineering alarms,
> though.

This entire thing is over engineered, I think it's time to take a step
back.  We're combining iommu visibility with device quirks with
isolation strength and hierarchical groups with manager locking and
driver autoprobing... it's all over the place.

> > > > > Oh.. and I just thought of an existing-in-the-field case with the same
> > > > > problem.  I'm pretty sure for devices that can appear on PCI but also
> > > > > have "dumb-bus" versions used on embedded systems, at least some of
> > > > > the kernel drivers are structured so that there is a separate struct
> > > > > device for the PCI "wrapper" and the device inside.  If the inner
> > > > > driver is initiating DMA, as it usually would, it has to be in the
> > > > > same iso group as it's PCI device parent.
> > > > 
> > > > I don't know that we can ever generically identify such devices, but
> > > > maybe this introduces the idea that we need to be able to blacklist
> > > > certain devices as multi-homed and tainting any isolation group that
> > > > contains them.
> > > 
> > > Sorry, I was unclear.  These are not multi-homed devices, just
> > > multiple-variant devices, any given instance will either be PCI or
> > > not.  But to handle the two variants easily, the drivers have nested
> > > struct devices.  It's essentially a pure software artifact we're
> > > dealing with here, but nonetheless we need to get the group-ownership
> > > of those struct devices correct, whether they're synthetic or not.
> > 
> > So long as the ADD_DEVICE happens with the currently running variant,
> > which seems like it has to be the case, I'm not sure how this matters.
> > I'm trying to be very careful to only use struct device for groups.
> 
> Nope, I still haven't managed to convey the situation.  The *hardware*
> comes in two varants, PCI and "dumb bus".  The core part of the driver
> software binds (only) to a dumb bus struct device (usually a platform
> device, actually).
> 
> To support the PCI variant, there is a "wrapper" driver.  This is a
> PCI driver which does any PCI specific initialization, determines the
> register addresses from config space then creates a dumb bus struct
> device as a child of the pci_dev.  The core driver then attaches to
> that dumb bus (e.g. platform) device.
> 
> My point is that in the second case, the dumb bus struct device needs
> to be in the same group as its pci_dev parent.
> 
> > > > > >  When that happens we can traverse up the bus to find a
> > > > > > higher level isolation group.
> > > > > 
> > > > > Well, that's one possible answer to my "where should the hook be
> > > > > question": rather than an initialization hook, when we look up a
> > > > > device's isolation group, if it doesn't say one explicitly, we try
> > > > > it's bridge parent and so forth up the tree.  I wonder about the
> > > > > overhead of having to walk all the way up the bus heirarchy before
> > > > > returning NULL whenever we ask about the group of a device that
> > > > > doesn't have one.
> > > > 
> > > > Yep, that could definitely be a concern for streaming dma.
> > > 
> > > Right, which is why I'm suggesting handling at init time instead.
> > > We'd need something that runs in the generic hot-add path, after bus
> > > notifiers, which would set the device's group to the same as its
> > > parent's if a provider hasn't already given it one.
> > 
> > I don't think that works.  Back to the FooBus example, if the isolation
> > group becomes a fundamental part of the dma_ops path, we may end up with
> > groups at each FooDev (or maybe one for FooBus) generated by the
> > intermediary that sets up dma using whackyPCICard.
> 
> That's why this would only do something *iff* nothing else has set a
> group (like that intermediary).
> 
> > > > > >  It would probably make sense to have some
> > > > > > kind of top-most isolation group that contains everything as it's an
> > > > > > easy proof that if you own everything, you're isolated.
> > > > > 
> > > > > Hrm, no.  Things that have no IOMMU above them will have ungated
> > > > > access to system RAM, and so can never be safely isolated for
> > > > > userspace purposes, even if userspace owned every _device_ in the
> > > > > system (not that you could do that in practice, anyway).
> > > > 
> > > > RAM is a good point, there are "non-devices" to worry about.
> > > > Potentially that top level group doesn't allow managers.
> > > 
> > > I don't really see the point of a "top-level" group.  Groups are
> > > exclusive, not heirarchical, and I don't see that there are any paths
> > > really simplified by having a (not manageable) "leftovers" group.
> > 
> > Yeah, a top level group may not make sense, but if we plan for dma_ops,
> > we need non-manageable groups, which I think is just the degenerate case
> > of isolation quality.
> 
> Yeah, I'll buy that.  Pending more details on dwmw2's plans, anyway.
> 
> > > > > >  Potentially
> > > > > > though, wackyPCIcard can also register isolation groups for each of it's
> > > > > > FooBus devices if it's able to provide that capability.  Thanks,
> > > > > 
> > > > > It could, but why should it.  It doesn't know anything about IOMMUs or
> > > > > isolation, and it doesn't need to.  Even less so for PCI devices which
> > > > > create subordinate non-PCI struct devices for internal reasons.
> > > > 
> > > > Sorry I wasn't clear.  If wackyPCIcard happens to include an onboard
> > > > IOMMU of some sort that's capable of isolation, it might be able to
> > > > register groups for each of the devices below it.  Therefore we could
> > > > end up with a scenario like above that the segment may not have ACS and
> > > > therefore not be able to isolate wackyPCIcard from otherdevice, but
> > > > wackyPCIcard can isolate FooDev1 from FooDev2 and otherdevice.  I think
> > > > that means we potentially need to check all devices downstream of an
> > > > isolation group to allow a manager to lock it, as well as checking the
> > > > path upstream to make sure it isn't used above...  Are you sure we're
> > > > ready for this kind of infrastructure?  Thanks,
> > > 
> > > Hrm, at this stage I think I'm prepared to assume that IOMMUs are
> > > either strictly independent (e.g. covering different PCI domains) or
> > > are at least vaguely aware of each other (i.e. platform conventions
> > > cover the combination).  Truly nested IOMMUs, that are entirely
> > > unaware of each other is a problem for another day (by which I mean
> > > probably never).
> > 
> > Ok, but even if there's no iommu onboard whackyPCICard, it can still be
> > possible to create groups on FooBus just to facilitate dma_ops and
> > handle quirks.
> 
> No, you can't arbitrarily go creating groups - the group boundary
> means something specific.  If dma_ops or something needs more info, it
> will need that *in addition* to the group.
> 
> > > That said, again, groups have to be exclusive, not heirarchical, so
> > > in the above case, I think we'd have a few possible ways to go:
> > 
> > Ownership absolutely has to be exclusive, but it looks like groups
> > themselves are hierarchical.
> 
> Doesn't really make sense, since a group is defined as the minimum
> isolatable parcel.  You can do something if as you walk down the tree
> isolation level decreases, but it's certainly not feeling right.
> 
> > > 	1) The FooBus isolation provider could refuse to initialize if
> > > the FooBus bridge is sharing an iso group with something else before
> > > it probes the FooBus.
> > 
> > Sharing, as in a parent group is managed?
> 
> No, just as in a group exists which contains both the FooBus bridge
> and something else.  Basically this option means that if you plugged
> the FooBus bridge into a slot that wasn't sufficiently isolated, it
> would simply refuse to work.
> 
> >  Yes, something special needs
> > to happen in that case, I'd probably investigate having it initialized
> > in a managed state versus not initialized at all.
> > 
> > > 	2) The FooBus isolation provider could be in the FooBus bridge
> > > driver - meaning that if someone tried to grab the PCI group including
> > > the FooBridge, the provider driver would be booted out, causing the
> > > FooBus groups to cease to exist (meaning the PCI group manager would
> > > never get lock while someone was already using the FooGroups).  In
> > 
> > Right, I don't know that they need to cease to exist, but if a manager
> > is attached anywhere above or below the group it wants to lock, it has
> > to be blocked.
> > 
> > > this case, it gets a bit complex.  When the FooBus isolation provider
> > > is active, the FooBus devices would be in their own groups, not the
> > > group of the FooBridge and its sibling.  When the FooBus isolation
> > > provider is removed, it would have to configure the FooBus IOMMU to a
> > > passthrough mode, and revert the FooBus devices to the parent's
> > > group.  Hm.  Complicated.
> > 
> > Yep.  I think we're arriving at the same point.  Groups are
> > hierarchical, but ownership via a manager cannot be nested.  So to
> > manage a group, we need to walk the entire tree of devices below each
> > device checking that none of the groups are managed and all the devices
> > are using the right driver, then walk up from the group to verify no
> > group of a parent device is managed.  Thanks,
> 
> Blargh.  I really, really hope we can come up with a simpler model
> than that.

Yep, I'm pretty well at the end of this experiment.  Honestly, I think
isolation groups are the wrong approach.  We're trying to wrap too many
concepts together and it's completely unmanageable.  I cannot see adding
the complexity we're talking about here to the core device model for
such a niche usage.  I think we're better off going back to the
iommu_device_group() and building that out into something more complete,
starting with group based iommu ops and a dma quirk infrastructure.
>From there we can add some basic facilities to toggle driver autoprobe,
maybe setup notifications for the group, and hopefully include a way to
share iommu mappings between groups.  Anything much beyond that we
should probably leave for something like the vfio driver.  Thanks,

Alex

