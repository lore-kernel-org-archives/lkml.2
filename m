Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848Ab2EOCGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:06:34 -0400
Received: from ozlabs.org ([203.10.76.45]:51773 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717Ab2EOCGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:06:32 -0400
Date: Tue, 15 May 2012 12:03:28 +1000
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
Message-ID: <20120515020328.GG30229@truffala.fritz.box>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337015502.6954.68.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 11:11:42AM -0600, Alex Williamson wrote:
> On Mon, 2012-05-14 at 11:16 +1000, David Gibson wrote:
> > On Fri, May 11, 2012 at 04:55:41PM -0600, Alex Williamson wrote:
[snip]
> > > +struct iommu_group {
> > > +	struct kobject kobj;
> > > +	struct kobject *devices_kobj;
> > > +	struct list_head devices;
> > > +	struct mutex mutex;
> > > +	struct blocking_notifier_head notifier;
> > > +	int id;
> > 
> > I think you should add some sort of name string to the group as well
> > (supplied by the iommu driver creating the group).  That would make it
> > easier to connect the arbitrary assigned IDs to any platform-standard
> > naming convention for these things.
> 
> When would the name be used and how is it exposed?

I'm thinking of this basically as a debugging aid.  So I'd expect it
to appear in a 'name' (or 'description') sysfs property on the group,
and in printk messages regarding the group.

[snip]
> > So, it's not clear that the kobject_name() here has to be unique
> > across all devices in the group.  It might be better to use an
> > arbitrary index here instead of a name to avoid that problem.
> 
> Hmm, that loses useful convenience when they are unique, such as on PCI.
> I'll look and see if sysfs_create_link will fail on duplicate names and
> see about adding some kind of instance to it.

Ok.  Is the name necessarily unique even for PCI, if the group crosses
multiple domains?

[snip]
> > > +	mutex_lock(&group->mutex);
> > > +	list_for_each_entry(device, &group->devices, list) {
> > > +		if (device->dev == dev) {
> > > +			list_del(&device->list);
> > > +			kfree(device);
> > > +			break;
> > > +		}
> > > +	}
> > > +	mutex_unlock(&group->mutex);
> > > +
> > > +	sysfs_remove_link(group->devices_kobj, kobject_name(&dev->kobj));
> > > +	sysfs_remove_link(&dev->kobj, "iommu_group");
> > > +
> > > +	dev->iommu_group = NULL;
> > 
> > I suspect the dev -> group pointer should be cleared first, under the
> > group lock, but I'm not certain about that.
> 
> group->mutex is protecting the group's device list.  I think my
> assumption is that when a device is being removed, there should be no
> references to it for anyone to race with iommu_group_get(dev), but I'm
> not sure how valid that is.

What I'm concerned about here is someone grabbing the device by
non-group-related means, grabbing a pointer to its group and that
racing with remove_device().  It would then end up with a group
pointer it thinks is right for the device, when the group no longer
thinks it owns the device.

Doing it under the lock is so that on the other side, group aware code
doesn't traverse the group member list and grab a reference to a
device which no longer points back to the group.

> > [snip]
> > > +/**
> > > + * iommu_group_for_each_dev - iterate over each device in the group
> > > + * @group: the group
> > > + * @data: caller opaque data to be passed to callback function
> > > + * @fn: caller supplied callback function
> > > + *
> > > + * This function is called by group users to iterate over group devices.
> > > + * Callers should hold a reference count to the group during
> > > callback.
> > 
> > Probably also worth noting in this doco that the group lock will be
> > held across the callback.
> 
> Yes; calling iommu_group_remove_device through this would be a bad idea.

Or anything which blocks.

> > [snip]
> > > +static int iommu_bus_notifier(struct notifier_block *nb,
> > > +			      unsigned long action, void *data)
> > >  {
> > >  	struct device *dev = data;
> > > +	struct iommu_ops *ops = dev->bus->iommu_ops;
> > > +	struct iommu_group *group;
> > > +	unsigned long group_action = 0;
> > > +
> > > +	/*
> > > +	 * ADD/DEL call into iommu driver ops if provided, which may
> > > +	 * result in ADD/DEL notifiers to group->notifier
> > > +	 */
> > > +	if (action == BUS_NOTIFY_ADD_DEVICE) {
> > > +		if (ops->add_device)
> > > +			return ops->add_device(dev);
> > > +	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> > > +		if (ops->remove_device && dev->iommu_group) {
> > > +			ops->remove_device(dev);
> > > +			return 0;
> > > +		}
> > > +	}
> > 
> > So, there's still the question of how to assign grouping for devices
> > on a subordinate bus behind a bridge which is iommu managed.  The
> > iommu driver for the top-level bus can't know about all possible
> > subordinate bus types, but the subordinate devices will (in most
> > cases, anyway) be iommu translated as if originating with the bus
> > bridge.
> 
> Not just any bridge, there has to be a different bus_type on the
> subordinate side.  Things like PCI-to-PCI work as is, but a PCI-to-ISA
> would trigger this.

Right, although ISA-under-PCI is a bit of a special case anyway.  I
think PCI to Firewire/IEEE1394 would also have this issue, as would
SoC-bus-to-PCI for a SoC which had an IOMMU at the SoC bus level.  And
virtual struct devices where the PCI driver is structured as a wrapper
around a "vanilla" device driver, a pattern used in a number of
drivers for chips with both PCI and non PCI variants.

>  In general, I don't know how to handle it and I'm
> open to suggestions.  Perhaps we need to register notifiers for every
> bus_type and create notifiers for new bus_types.

I think we do need to do something like that and basically ensure that
if a new device is not explicitly claimed by an IOMMU driver, it
inherits its group from its parent bridge.

>  If we can catch the
> ADD_DEVICE for it, we can walk up to the first parent bus that supports
> an iommu_ops and add the device there.  But then we need some kind of
> foreign bus support for the group since the iommu driver won't know what
> to do with the device if we call add_device with it.  Other ideas?

Hrm, yeah.  We may need a distinction between primary group members
(i.e. explicitly claimed by the IOMMU driver) and subordinate group
members (devices which are descendents of a primary group member).

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
