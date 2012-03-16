Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2CPTbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:31:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab2CPTbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:31:37 -0400
Message-ID: <1331926278.13855.57.camel@bling.home>
Subject: Re: [PATCH 1/2] Isolation groups
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: aik@ozlabs.ru, dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 13:31:18 -0600
In-Reply-To: <20120316034527.GJ24916@truffala.fritz.box>
References: <20120312220109.30321.83419.stgit@bling.home>
	 <20120312223254.30321.74405.stgit@bling.home>
	 <20120313143340.GT24916@truffala.fritz.box>
	 <1331657387.2969.79.camel@bling.home>
	 <20120314095808.GX24916@truffala.fritz.box>
	 <1331842501.22038.58.camel@ul30vt>
	 <20120316034527.GJ24916@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 14:45 +1100, David Gibson wrote:
> On Thu, Mar 15, 2012 at 02:15:01PM -0600, Alex Williamson wrote:
> > On Wed, 2012-03-14 at 20:58 +1100, David Gibson wrote:
> > > On Tue, Mar 13, 2012 at 10:49:47AM -0600, Alex Williamson wrote:
> > > > On Wed, 2012-03-14 at 01:33 +1100, David Gibson wrote:
> > > > > On Mon, Mar 12, 2012 at 04:32:54PM -0600, Alex Williamson wrote:
> > > > > > +/*
> > > > > > + * Add a device to an isolation group.  Isolation groups start empty and
> > > > > > + * must be told about the devices they contain.  Expect this to be called
> > > > > > + * from isolation group providers via notifier.
> > > > > > + */
> > > > > 
> > > > > Doesn't necessarily have to be from a notifier, particularly if the
> > > > > provider is integrated into host bridge code.
> > > > 
> > > > Sure, a provider could do this on it's own if it wants.  This just
> > > > provides some infrastructure for a common path.  Also note that this
> > > > helps to eliminate all the #ifdef CONFIG_ISOLATION in the provider.  Yet
> > > > to be seen whether that can reasonably be the case once isolation groups
> > > > are added to streaming DMA paths.
> > > 
> > > Right, but other than the #ifdef safety, which could be achieved more
> > > simply, I'm not seeing what benefit the infrastructure provides over
> > > directly calling the bus notifier function.  The infrastructure groups
> > > the notifiers by bus type internally, but AFAICT exactly one bus
> > > notifier call would become exactly one isolation notifier call, and
> > > the notifier callback itself would be almost identical.
> > 
> > I guess I don't see this as a fundamental design point of the proposal,
> > it's just a convenient way to initialize groups as a side-band addition
> > until isolation groups become a more fundamental part of the iommu
> > infrastructure.  If you want to do that level of integration in your
> > provider, do it and make the callbacks w/o the notifier.  If nobody ends
> > up using them, we'll remove them.  Maybe it will just end up being a
> > bootstrap.  In the typical case, yes, one bus notifier is one isolation
> > notifier.  It does however also allow one bus notifier to become
> > multiple isolation notifiers, and includes some filtering that would
> > just be duplicated if every provider decided to implement their own bus
> > notifier.
> 
> Uh.. I didn't notice any filtering?  That's why I'm asking.

Not much, but a little:

+       switch (action) {
+       case BUS_NOTIFY_ADD_DEVICE:
+               if (!dev->isolation_group)
+                       blocking_notifier_call_chain(&notifier->notifier,
+                                       ISOLATION_NOTIFY_ADD_DEVICE, dev);
+               break;
+       case BUS_NOTIFY_DEL_DEVICE:
+               if (dev->isolation_group)
+                       blocking_notifier_call_chain(&notifier->notifier,
+                                       ISOLATION_NOTIFY_DEL_DEVICE, dev);
+               break;
+       }

...
> > > > > So, somewhere, I think we need a fallback path, but I'm not sure
> > > > > exactly where.  If an isolation provider doesn't explicitly put a
> > > > > device into a group, the device should go into the group of its parent
> > > > > bridge.  This covers the case of a bus with IOMMU which has below it a
> > > > > bridge to a different type of DMA capable bus (which the IOMMU isn't
> > > > > explicitly aware of).  DMAs from devices on the subordinate bus can be
> > > > > translated by the top-level IOMMU (assuming it sees them as coming
> > > > > from the bridge), but they all need to be treated as one group.
> > > > 
> > > > Why would the top level IOMMU provider not set the isolation group in
> > > > this case.
> > > 
> > > Because it knows nothing about the subordinate bus.  For example
> > > imagine a VT-d system, with a wacky PCI card into which you plug some
> > > other type of DMA capable device.  The PCI card is acting as a bridge
> > > from PCI to this, let's call it FooBus.  Obviously the VT-d code won't
> > > have a FooBus notifier, since it knows nothing about FooBus.  But the
> > > FooBus devices still need to end up in the group of the PCI bridge
> > > device, since their DMA operations will appear as coming from the PCI
> > > bridge card to the IOMMU, and can be isolated from the rest of the
> > > system (but not each other) on that basis.
> > 
> > I guess I was imagining that it's ok to have devices without an
> > isolation group.
> 
> It is, but having NULL isolation group has a pretty specific meaning -
> it means it's never safe to give that device to userspace, but it also
> means that normal kernel driver operation of that device must not
> interfere with anything in any iso group (otherwise we can never no
> that those iso groups _are_ safe to hand out).  Likewise userspace
> operation of any isolation group can't mess with no-group devices.

This is where wanting to use isolation groups as the working unit for an
iommu ops layer and also wanting to use iommu ops to replace dma ops
seem to collide a bit.  Do we want two interfaces for dma, one group
based and one for non-isolated devices?  Isolation providers like
intel-iommu would always use one, non-isolation capable dma paths, like
swiotlb or non-isolation hardware iommus, would use another.  And how do
we factor in the degree of isolation to avoid imposing policy in the
kernel?  MSI isolation is an example.  We should allow userspace to set
a policy of whether lack of MSI protection is an acceptable risk.  Does
that mean we can have isolation groups that provide no isolation and
sysfs files indicating capabilities?  Perhaps certain classes of groups
don't even allow manager binding?

> None of these conditions is true for the hypothetical Foobus case.
> The bus as a whole could be safely given to userspace, the devices on
> it *could* mess with an existing isolation group (suppose the group
> consisted of a PCI segment with the FooBus bridge plus another PCI
> card - FooBus DMAs would be bridged onto the PCI segment and might
> target the other card's MMIO space).  And other grouped devices can
> certainly mess with the FooBus devices (if userspace grabs the bridge
> and manipulates its IOMMU mappings, that would clearly screw up any
> kernel drivers doing DMA from FooBus devices behind it).

---segment-----+---------------+
               |               |
        [whackyPCIcard]   [other device]
               |
               +---FooBus---+-------+
                            |       |
                       [FooDev1] [FooDev2]

This is another example of the quality of the isolation group and what
factors we incorporate in judging that.  If the bridge/switch port
generating the segment does not support or enable PCI ACS then the IOMMU
may be able to differentiate whackyPCIcard from the other device but not
prevent peer-to-peer traffic between the two (or between FooDevs and the
other device - same difference).  This would suggest that we might have
an isolation group at the root of the segment for which the provider can
guarantee isolation (includes everything on and below the bus), and we
might also have isolation groups at whackyPCIcard and the other device
that have a difference quality of isolation.  /me pauses for rant about
superior hardware... ;)

> Oh.. and I just thought of an existing-in-the-field case with the same
> problem.  I'm pretty sure for devices that can appear on PCI but also
> have "dumb-bus" versions used on embedded systems, at least some of
> the kernel drivers are structured so that there is a separate struct
> device for the PCI "wrapper" and the device inside.  If the inner
> driver is initiating DMA, as it usually would, it has to be in the
> same iso group as it's PCI device parent.

I don't know that we can ever generically identify such devices, but
maybe this introduces the idea that we need to be able to blacklist
certain devices as multi-homed and tainting any isolation group that
contains them.

> >  When that happens we can traverse up the bus to find a
> > higher level isolation group.
> 
> Well, that's one possible answer to my "where should the hook be
> question": rather than an initialization hook, when we look up a
> device's isolation group, if it doesn't say one explicitly, we try
> it's bridge parent and so forth up the tree.  I wonder about the
> overhead of having to walk all the way up the bus heirarchy before
> returning NULL whenever we ask about the group of a device that
> doesn't have one.

Yep, that could definitely be a concern for streaming dma.

> >  It would probably make sense to have some
> > kind of top-most isolation group that contains everything as it's an
> > easy proof that if you own everything, you're isolated.
> 
> Hrm, no.  Things that have no IOMMU above them will have ungated
> access to system RAM, and so can never be safely isolated for
> userspace purposes, even if userspace owned every _device_ in the
> system (not that you could do that in practice, anyway).

RAM is a good point, there are "non-devices" to worry about.
Potentially that top level group doesn't allow managers.

> >  Potentially
> > though, wackyPCIcard can also register isolation groups for each of it's
> > FooBus devices if it's able to provide that capability.  Thanks,
> 
> It could, but why should it.  It doesn't know anything about IOMMUs or
> isolation, and it doesn't need to.  Even less so for PCI devices which
> create subordinate non-PCI struct devices for internal reasons.

Sorry I wasn't clear.  If wackyPCIcard happens to include an onboard
IOMMU of some sort that's capable of isolation, it might be able to
register groups for each of the devices below it.  Therefore we could
end up with a scenario like above that the segment may not have ACS and
therefore not be able to isolate wackyPCIcard from otherdevice, but
wackyPCIcard can isolate FooDev1 from FooDev2 and otherdevice.  I think
that means we potentially need to check all devices downstream of an
isolation group to allow a manager to lock it, as well as checking the
path upstream to make sure it isn't used above...  Are you sure we're
ready for this kind of infrastructure?  Thanks,

Alex

