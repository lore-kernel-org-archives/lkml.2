Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1LIC6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:58:00 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45162 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab1LIC57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:57:59 -0500
Date: Fri, 9 Dec 2011 13:38:19 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Subject: Re: RFC: Device isolation infrastructure
Message-ID: <20111209023819.GE5750@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	joerg.roedel@amd.com, dwmw2@infradead.org,
	iommu@lists.linux-foundation.org, aik@au1.ibm.com,
	linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
	scottwood@freescale.com, B08248@freescale.com
References: <20111207035816.GC7631@truffala.fritz.box>
 <1323240402.2182.241.camel@bling.home>
 <20111207142201.GA5696@truffala.fritz.box>
 <1323287120.15059.63.camel@bling.home>
 <1323301293.12793.16.camel@pasglop>
 <1323323519.24340.64.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323323519.24340.64.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120816-0260-0000-0000-00000030823C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 10:51:59PM -0700, Alex Williamson wrote:
> On Thu, 2011-12-08 at 10:41 +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2011-12-07 at 12:45 -0700, Alex Williamson wrote:
> > 
> > > Ok, let's back up from the patch because I think its clouding the driver
> > > model with a detached device state that might be detracting from the
> > > useful bits.
> > > 
> > > An isolation group is a generic association of devices into a set based
> > > on, well... isolation.  Presumably something like an iommu driver does a
> > > bus_register_notifier() and bus_for_each_dev() and when a new device is
> > > added we do isolation_group_new() and isolation_group_dev_add() as
> > > necessary.  When the iommu driver needs to do a dma_ops call for a
> > > device, it can traverse up to the isolation group and find something
> > > that points it to the shared iommu context for that group.  While
> > > dma_ops can share the iommu context among the drivers attached to the
> > > various devices, iommu_ops wants a single meta-driver for the group
> > > because it's predominantly designed for use when devices are exposed
> > > directly to the user.  We trust native kernel drivers to share context
> > > between each other, we do not trust user level drivers to share context
> > > with anyone but themselves.  Ok so far?
> > > 
> > > The first question we run into is what does the iommu driver do if it
> > > does not provide isolation?  If it's a translation-only iommu, maybe it
> > > has a single context and can manage to maintain it internally and should
> > > opt-out of isolation groups.  But we also have things like MSI isolation
> > > where we have multiple contexts and the isolation strength is sufficient
> > > for dma_ops, but not iommu_ops.  I don't know if we want to make that
> > > determination via a strength bitmask at the group level or simply a bool
> > > that the iommu driver sets when it registers a group.
> > 
> >  .../...
> > 
> > I think we are trying to solve too many problems at once.
> > 
> > I don't believe we should have the normal dma ops path in the kernel be
> > rewritten on top of some new iommu isolation layer or anything like that
> > at this stage.
> 
> I headed down this path because David seems to be suggesting, well
> stating, that all this infrastructure is useful for providing simplicity
> and efficiency of groups to the core, and not just for this niche vfio
> usage.  "You don't get a choice about whether you use groups."  The only
> way I can rationalize that is to give it some purpose which is used by
> something other that just vfio.  If all of that is "some day", then why
> don't we start with the group management in vfio as I have it today and
> eventually push that down into the core?

So.. you misunderstand what I meant by that, but I just realised
that's because I misunderstood what I said that in response to.

My point was that if you're using vfio (or something like it), then
the choice of whether groups are relevant is not the user's, but
depends on the hardware setup.

But I now realise that your point was that very few people will use
vfio itself, or anything like it.  And therefore you're uncomfortable
with the extent to which my patch impinges on the core driver model.

Which is a good point.  I still think this sufficiently solidifies the
isolation model to be worth it.

> > Proceed step by step or we'll never be finished. What that means imho
> > is:
> > 
> >  - Existing dma/iommu arch layers mostly remain as-is. It has its own
> > internal representation of devices, domains and possibly grouping
> > information, and things like the buggy RICOH devices are handled there
> > (via a flag set in a generic header quirk)
> 
> But we're already being harassed to rework iommu_ops to operate based on
> groups and to take grouping into account for things like the ricoh
> device in dma_ops.  Mixed messages...

Well, ok, maybe not so far in the future, but in any case this can be
considered independently.

> >  - Isolation groups are a new high-level thing that is not used by the
> > iommu/dma code for normal in-kernel operations at this stage. The
> > platform iommu/dma code creates the isolation group objects and
> > populates them, it doesn't initially -use- them.
> 
> The iommu_device_group() interface is a tiny extension to the IOMMU API
> that basically lets vfio query the iommu driver for a group identifier
> for a device.  vfio then uses that information to create and manage
> groups itself.
> 
> This is simply reversing that, allowing the iommu driver to create
> groups and add devices, which are centrally managed.  That sounds like a
> good long term goal, especially when we start making use of the groups
> for dma/iommu ops, but it does require that we define an API both for
> group providers (iommu drivers) and the group users (vfio).  It's also
> much more intrusive to the iommu drivers (note the trivial patches to
> add iommu_device_group support to intel and amd iommu) and creates bloat
> for a niche user if we're not going to get around to making groups more
> pervasive anytime soon.
> 
> >  - We can then use that for the needs of exposing the groups to user
> > space, perform driver level isolation, and provide the grouping
> > information to vfio.
> >
> >  - In the -long- run, individual iommu/dma layers might be modified to
> > instead use the isolation layer as their own building block if that
> > makes sense, this can be looked at on a case by case basis but is not a
> > pre-req.
> > 
> > That leaves us with what I think is the main disagreement between David
> > and Alex approaches which is whether devices in a group are "detached"
> > completely (in some kind of limbo) while they are used by vfio or
> > something else vs. assigned to a different driver (vfio).
> > 
> > After much thinking, I believe that the driver ownership model is the
> > right one. However, we could still use the work David did here. IE. I
> > _do_ think that exposing groups as the individual unit of ownership to
> > user space is the right thing to do.
> 
> So far we're only exposing the group structure here (which vfio also
> does in sysfs), not providing a userspace or driver interface for taking
> ownership of the group.  I'm still not clear how this ends up satisfying
> David's complaints about the group ownership vs device access model in
> vfio.
> 
> > That means that instead of that current detached flag alone, what we
> > could do instead is have an in-kernel mechanism to request isolation
> > which works by having the isolation group kernel code perform:
> > 
> >  - Rename the detached flag to "exclusive". This flag prevents automatic
> > & user driven attachment of a driver by the generic code. Set that flag
> > on all devices in the group (need a hook for hotplug).
> 
> This is a sysfs attribute on the group?  So step #1:
> 
>         $ echo 1 > /sys/isolation/$GROUP/exclusive
> 
> >  - Detach existing drivers.
> 
> step #2:
> 
>         $ for i in $(ls /sys/isolation/$GROUP/devices/); do	\
>         	echo $(basename $i) > $i/driver/unbind; done

Right, but this version can be messed up if there's a hotplug after
this but before vfio binds to the group.

> >  - Once everything is detached, attach the requested client driver (vfio
> > being the one we initially provide, maybe uio could use that framework
> > as well). This can be done using an explicit in-kernel attach API that
> > can be used even when the exclusive flag is set.
> 
> step #3: A miracle occurs ;)
> 
> I'm not sure what this looks like.  Are we going to do a
> isolation_group_register_meta_driver() that vfio calls with some defined
> ops structure, so a user can:
> 
>         $ echo "vfio" > /sys/isolation/$GROUP/driver
> 
> That triggers some list walk of the group devices, asking vfio to find
> and force a driver attach to the bus driver for each device?  A model
> something like that is the only way I can see that removing groups from
> vfio doesn't also disassociate the group meta driver from the group
> device drivers.

That's one way we could do it.  Another option is that the user
explicitly just detaches the group, which puts it in limbo.  The
asking to add the group from the vfio interface triggers attaching the
vfio "meta-driver" to the group (via a call to something like
isolation_group_claim(group, &vfio_isolation_user)).  I'm not sure
what's best, I'll try to work something up and see how it looks in the
next spin of my code.

> If instead, we make vfio be the group manager (since nobody else uses it
> anyway), all of the above becomes:
> 
>         $ for i in $(ls /sys/devices/virtual/vfio/pci:257/devices); do	\
>         	echo $(basename $i) > $i/driver/unbind;			\
>         	echo $(basename $i) > /sys/bus/pci/drivers/vfio/bind;	\
>         	done
>         
> >  - Win
> 
> I wish, we still have to make it through how vfio then exposes the group
> to userspace and how we don't end up with the same individual device
> manipulation vs group access model that seems to be getting under
> David's skin.

I don't have a problem with individual device manipulation for things
that pertain to an individual device - getting the resources, doing
mmio, attaching irqs.  I just want thing pertaining to a group's
ownership change to be explicitly group oriented.

>  Effectively what we've done above is:
> 
>       * provide a group model that we'll "some day" make more pervasive
>       * make the binding of devices to group device drivers implicit in
>         some kind of meta driver attachment

That's not a bad summary.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

