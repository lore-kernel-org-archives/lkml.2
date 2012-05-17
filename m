Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966019Ab2EQDuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:50:54 -0400
Received: from ozlabs.org ([203.10.76.45]:33373 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933363Ab2EQDuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:50:50 -0400
Date: Thu, 17 May 2012 13:29:04 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@sous-sol.org, agraf@suse.de,
        benve@cisco.com, aafabbri@cisco.com, B08248@freescale.com,
        B07421@freescale.com, avi@redhat.com, konrad.wilk@oracle.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Subject: Re: [PATCH 02/13] iommu: IOMMU Groups
Message-ID: <20120517032904.GC22069@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	benh@kernel.crashing.org, aik@ozlabs.ru, joerg.roedel@amd.com,
	dwmw2@infradead.org, chrisw@sous-sol.org, agraf@suse.de,
	benve@cisco.com, aafabbri@cisco.com, B08248@freescale.com,
	B07421@freescale.com, avi@redhat.com, konrad.wilk@oracle.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org,
	iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	bhelgaas@google.com
References: <20120511222148.30496.68571.stgit@bling.home>
 <20120511225541.30496.34751.stgit@bling.home>
 <20120514011627.GB30229@truffala.fritz.box>
 <1337015502.6954.68.camel@bling.home>
 <20120515020328.GG30229@truffala.fritz.box>
 <1337063643.6954.166.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337063643.6954.166.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 12:34:03AM -0600, Alex Williamson wrote:
> On Tue, 2012-05-15 at 12:03 +1000, David Gibson wrote:
> > On Mon, May 14, 2012 at 11:11:42AM -0600, Alex Williamson wrote:
> > > On Mon, 2012-05-14 at 11:16 +1000, David Gibson wrote:
> > > > On Fri, May 11, 2012 at 04:55:41PM -0600, Alex Williamson wrote:
> > [snip]
> > > > > +struct iommu_group {
> > > > > +	struct kobject kobj;
> > > > > +	struct kobject *devices_kobj;
> > > > > +	struct list_head devices;
> > > > > +	struct mutex mutex;
> > > > > +	struct blocking_notifier_head notifier;
> > > > > +	int id;
> > > > 
> > > > I think you should add some sort of name string to the group as well
> > > > (supplied by the iommu driver creating the group).  That would make it
> > > > easier to connect the arbitrary assigned IDs to any platform-standard
> > > > naming convention for these things.
> > > 
> > > When would the name be used and how is it exposed?
> > 
> > I'm thinking of this basically as a debugging aid.  So I'd expect it
> > to appear in a 'name' (or 'description') sysfs property on the group,
> > and in printk messages regarding the group.
> 
> Ok, so long as it's only descriptive/debugging I don't have a problem
> adding something like that.
> 
> > [snip]
> > > > So, it's not clear that the kobject_name() here has to be unique
> > > > across all devices in the group.  It might be better to use an
> > > > arbitrary index here instead of a name to avoid that problem.
> > > 
> > > Hmm, that loses useful convenience when they are unique, such as on PCI.
> > > I'll look and see if sysfs_create_link will fail on duplicate names and
> > > see about adding some kind of instance to it.
> > 
> > Ok.  Is the name necessarily unique even for PCI, if the group crosses
> > multiple domains?
> 
> Yes, it includes the domain in the dddd:bb:dd.f form.  I've found I can
> just use sysfs_create_link_nowarn and add a .# index when we have a name
> collision.

Ok, that sounds good.

> > [snip]
> > > > > +	mutex_lock(&group->mutex);
> > > > > +	list_for_each_entry(device, &group->devices, list) {
> > > > > +		if (device->dev == dev) {
> > > > > +			list_del(&device->list);
> > > > > +			kfree(device);
> > > > > +			break;
> > > > > +		}
> > > > > +	}
> > > > > +	mutex_unlock(&group->mutex);
> > > > > +
> > > > > +	sysfs_remove_link(group->devices_kobj, kobject_name(&dev->kobj));
> > > > > +	sysfs_remove_link(&dev->kobj, "iommu_group");
> > > > > +
> > > > > +	dev->iommu_group = NULL;
> > > > 
> > > > I suspect the dev -> group pointer should be cleared first, under the
> > > > group lock, but I'm not certain about that.
> > > 
> > > group->mutex is protecting the group's device list.  I think my
> > > assumption is that when a device is being removed, there should be no
> > > references to it for anyone to race with iommu_group_get(dev), but I'm
> > > not sure how valid that is.
> > 
> > What I'm concerned about here is someone grabbing the device by
> > non-group-related means, grabbing a pointer to its group and that
> > racing with remove_device().  It would then end up with a group
> > pointer it thinks is right for the device, when the group no longer
> > thinks it owns the device.
> > 
> > Doing it under the lock is so that on the other side, group aware code
> > doesn't traverse the group member list and grab a reference to a
> > device which no longer points back to the group.
> 
> Our for_each function does grab the lock, as you noticed below, so
> removing it from the list under lock prevents that path.  Where it gets
> fuzzy is if someone can call iommu_group_get(dev) to get a group
> reference in this gap.

Right, that's what I'm concerned about.

>  Whether we clear the iommu_group pointer under
> lock or not doesn't matter for that path since it doesn't retrieve it
> under lock.  The assumption there is that the caller is going to have a
> reference to the device and therefore the device is not being
> removed.

Hrm.  I guess that works, assuming that removing a device from the
system is the only thing that will cause a device to be removed from
the group.  How confident are we of that?

> The asynchronous locking and reference counting is by far the hardest
> part of iommu_groups and vfio core, so appreciate any hard analysis of
> that.

Well, I've given my recommendation on this small aspect.

[snip]
> > > > So, there's still the question of how to assign grouping for devices
> > > > on a subordinate bus behind a bridge which is iommu managed.  The
> > > > iommu driver for the top-level bus can't know about all possible
> > > > subordinate bus types, but the subordinate devices will (in most
> > > > cases, anyway) be iommu translated as if originating with the bus
> > > > bridge.
> > > 
> > > Not just any bridge, there has to be a different bus_type on the
> > > subordinate side.  Things like PCI-to-PCI work as is, but a PCI-to-ISA
> > > would trigger this.
> > 
> > Right, although ISA-under-PCI is a bit of a special case anyway.  I
> > think PCI to Firewire/IEEE1394 would also have this issue, as would
> > SoC-bus-to-PCI for a SoC which had an IOMMU at the SoC bus level.  And
> > virtual struct devices where the PCI driver is structured as a wrapper
> > around a "vanilla" device driver, a pattern used in a number of
> > drivers for chips with both PCI and non PCI variants.
> 
> Sorry, I jumped into reliving this issue without remembering how I
> decided to rationalize it for IOMMU groups.  Let's step through it.
> Given DeviceA that's a member of GroupA and potentially sources a
> subordinate bus (A_bus_type) exposing DeviceA', what are the issues?
> >From a VFIO perspective, GroupA isn't usable so long as DeviceA is
> claimed by a non-VFIO driver.  That same non-VFIO driver is the one
> causing DeviceA to source A_bus_type, so remove the driver and DeviceA'
> goes away and we can freely give GroupA to userspace.  I believe this is
> always true; there are no subordinate buses to devices that meet the
> "viable" driver requirements of VFIO.  I don't see any problems with the
> fact that userspace can then re-source A_bus_type and find DeviceA'.
> That's what should happen.  If we want to assign just DeviceA' to
> userspace, well, it has no IOMMU group of it's own, so clearly it's not
> assignable on it's own.

Ah, right, so the assumption is that a bridge will only expose it's
subordinate bus when it has an active kernel driver.  Yeah, I think
that works at least for the current use cases.

> For the more general IOMMU group case, I'm still struggling to figure
> out why this is an issue.  If we were to do dma_ops via IOMMU groups, I
> don't think it's unreasonable that map_page would discover there's no
> iommu_ops on dev->bus (A_bus_type) and step up to dev->bus->self to find
> both iommu_group on DeviceA and iommu_ops on DeviceA->bus.  Is there a
> practical reason why DeviceA' would need to be listed as a member of
> GroupA, or is it just an optimization?  I know we had a number of
> discussions about these type of devices for isolation groups, but I
> think that trying to strictly represent these types of devices was also
> one of the downfalls of the isolation proposal.

Yeah, walking up the tree to find a group is certainly a possibility
as well.  Ok, so I'm happy enough only to track primary group members
for now.  I think we should bear in mind the possibility we might need
to track secondary members in future though (either as an optimization
or as something we need for a use case we haven't pinned down yet).

> This did make me think of one other generic quirk we might need.
> There's some funkiness with USB that makes me think that it's
> effectively a shared bus between 1.x and 2.0 controllers.  So assigning
> the 1.x and 2.0 controllers to different groups potentially allows a
> fast and a slow path to the same set of devices.  Is this true?  If so,
> we probably need to quirk OHCI/UHCI and EHCI functions together when
> they're on the same PCI device.  I think the PCI class code is
> sufficient to do this.  Thanks,

Ah, maybe.  I don't know enough about USB conventions to say for sure.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
