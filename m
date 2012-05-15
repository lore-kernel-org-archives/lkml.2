Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2EOGef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:34:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab2EOGec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:34:32 -0400
Message-ID: <1337063643.6954.166.camel@bling.home>
Subject: Re: [PATCH 02/13] iommu: IOMMU Groups
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@sous-sol.org, agraf@suse.de,
        benve@cisco.com, aafabbri@cisco.com, B08248@freescale.com,
        B07421@freescale.com, avi@redhat.com, konrad.wilk@oracle.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Date: Tue, 15 May 2012 00:34:03 -0600
In-Reply-To: <20120515020328.GG30229@truffala.fritz.box>
References: <20120511222148.30496.68571.stgit@bling.home>
	 <20120511225541.30496.34751.stgit@bling.home>
	 <20120514011627.GB30229@truffala.fritz.box>
	 <1337015502.6954.68.camel@bling.home>
	 <20120515020328.GG30229@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 12:03 +1000, David Gibson wrote:
> On Mon, May 14, 2012 at 11:11:42AM -0600, Alex Williamson wrote:
> > On Mon, 2012-05-14 at 11:16 +1000, David Gibson wrote:
> > > On Fri, May 11, 2012 at 04:55:41PM -0600, Alex Williamson wrote:
> [snip]
> > > > +struct iommu_group {
> > > > +	struct kobject kobj;
> > > > +	struct kobject *devices_kobj;
> > > > +	struct list_head devices;
> > > > +	struct mutex mutex;
> > > > +	struct blocking_notifier_head notifier;
> > > > +	int id;
> > > 
> > > I think you should add some sort of name string to the group as well
> > > (supplied by the iommu driver creating the group).  That would make it
> > > easier to connect the arbitrary assigned IDs to any platform-standard
> > > naming convention for these things.
> > 
> > When would the name be used and how is it exposed?
> 
> I'm thinking of this basically as a debugging aid.  So I'd expect it
> to appear in a 'name' (or 'description') sysfs property on the group,
> and in printk messages regarding the group.

Ok, so long as it's only descriptive/debugging I don't have a problem
adding something like that.

> [snip]
> > > So, it's not clear that the kobject_name() here has to be unique
> > > across all devices in the group.  It might be better to use an
> > > arbitrary index here instead of a name to avoid that problem.
> > 
> > Hmm, that loses useful convenience when they are unique, such as on PCI.
> > I'll look and see if sysfs_create_link will fail on duplicate names and
> > see about adding some kind of instance to it.
> 
> Ok.  Is the name necessarily unique even for PCI, if the group crosses
> multiple domains?

Yes, it includes the domain in the dddd:bb:dd.f form.  I've found I can
just use sysfs_create_link_nowarn and add a .# index when we have a name
collision.

> [snip]
> > > > +	mutex_lock(&group->mutex);
> > > > +	list_for_each_entry(device, &group->devices, list) {
> > > > +		if (device->dev == dev) {
> > > > +			list_del(&device->list);
> > > > +			kfree(device);
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +	mutex_unlock(&group->mutex);
> > > > +
> > > > +	sysfs_remove_link(group->devices_kobj, kobject_name(&dev->kobj));
> > > > +	sysfs_remove_link(&dev->kobj, "iommu_group");
> > > > +
> > > > +	dev->iommu_group = NULL;
> > > 
> > > I suspect the dev -> group pointer should be cleared first, under the
> > > group lock, but I'm not certain about that.
> > 
> > group->mutex is protecting the group's device list.  I think my
> > assumption is that when a device is being removed, there should be no
> > references to it for anyone to race with iommu_group_get(dev), but I'm
> > not sure how valid that is.
> 
> What I'm concerned about here is someone grabbing the device by
> non-group-related means, grabbing a pointer to its group and that
> racing with remove_device().  It would then end up with a group
> pointer it thinks is right for the device, when the group no longer
> thinks it owns the device.
> 
> Doing it under the lock is so that on the other side, group aware code
> doesn't traverse the group member list and grab a reference to a
> device which no longer points back to the group.

Our for_each function does grab the lock, as you noticed below, so
removing it from the list under lock prevents that path.  Where it gets
fuzzy is if someone can call iommu_group_get(dev) to get a group
reference in this gap.  Whether we clear the iommu_group pointer under
lock or not doesn't matter for that path since it doesn't retrieve it
under lock.  The assumption there is that the caller is going to have a
reference to the device and therefore the device is not being removed.
The asynchronous locking and reference counting is by far the hardest
part of iommu_groups and vfio core, so appreciate any hard analysis of
that.

> > > [snip]
> > > > +/**
> > > > + * iommu_group_for_each_dev - iterate over each device in the group
> > > > + * @group: the group
> > > > + * @data: caller opaque data to be passed to callback function
> > > > + * @fn: caller supplied callback function
> > > > + *
> > > > + * This function is called by group users to iterate over group devices.
> > > > + * Callers should hold a reference count to the group during
> > > > callback.
> > > 
> > > Probably also worth noting in this doco that the group lock will be
> > > held across the callback.
> > 
> > Yes; calling iommu_group_remove_device through this would be a bad idea.
> 
> Or anything which blocks.
> 
> > > [snip]
> > > > +static int iommu_bus_notifier(struct notifier_block *nb,
> > > > +			      unsigned long action, void *data)
> > > >  {
> > > >  	struct device *dev = data;
> > > > +	struct iommu_ops *ops = dev->bus->iommu_ops;
> > > > +	struct iommu_group *group;
> > > > +	unsigned long group_action = 0;
> > > > +
> > > > +	/*
> > > > +	 * ADD/DEL call into iommu driver ops if provided, which may
> > > > +	 * result in ADD/DEL notifiers to group->notifier
> > > > +	 */
> > > > +	if (action == BUS_NOTIFY_ADD_DEVICE) {
> > > > +		if (ops->add_device)
> > > > +			return ops->add_device(dev);
> > > > +	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> > > > +		if (ops->remove_device && dev->iommu_group) {
> > > > +			ops->remove_device(dev);
> > > > +			return 0;
> > > > +		}
> > > > +	}
> > > 
> > > So, there's still the question of how to assign grouping for devices
> > > on a subordinate bus behind a bridge which is iommu managed.  The
> > > iommu driver for the top-level bus can't know about all possible
> > > subordinate bus types, but the subordinate devices will (in most
> > > cases, anyway) be iommu translated as if originating with the bus
> > > bridge.
> > 
> > Not just any bridge, there has to be a different bus_type on the
> > subordinate side.  Things like PCI-to-PCI work as is, but a PCI-to-ISA
> > would trigger this.
> 
> Right, although ISA-under-PCI is a bit of a special case anyway.  I
> think PCI to Firewire/IEEE1394 would also have this issue, as would
> SoC-bus-to-PCI for a SoC which had an IOMMU at the SoC bus level.  And
> virtual struct devices where the PCI driver is structured as a wrapper
> around a "vanilla" device driver, a pattern used in a number of
> drivers for chips with both PCI and non PCI variants.

Sorry, I jumped into reliving this issue without remembering how I
decided to rationalize it for IOMMU groups.  Let's step through it.
Given DeviceA that's a member of GroupA and potentially sources a
subordinate bus (A_bus_type) exposing DeviceA', what are the issues?
>From a VFIO perspective, GroupA isn't usable so long as DeviceA is
claimed by a non-VFIO driver.  That same non-VFIO driver is the one
causing DeviceA to source A_bus_type, so remove the driver and DeviceA'
goes away and we can freely give GroupA to userspace.  I believe this is
always true; there are no subordinate buses to devices that meet the
"viable" driver requirements of VFIO.  I don't see any problems with the
fact that userspace can then re-source A_bus_type and find DeviceA'.
That's what should happen.  If we want to assign just DeviceA' to
userspace, well, it has no IOMMU group of it's own, so clearly it's not
assignable on it's own.

For the more general IOMMU group case, I'm still struggling to figure
out why this is an issue.  If we were to do dma_ops via IOMMU groups, I
don't think it's unreasonable that map_page would discover there's no
iommu_ops on dev->bus (A_bus_type) and step up to dev->bus->self to find
both iommu_group on DeviceA and iommu_ops on DeviceA->bus.  Is there a
practical reason why DeviceA' would need to be listed as a member of
GroupA, or is it just an optimization?  I know we had a number of
discussions about these type of devices for isolation groups, but I
think that trying to strictly represent these types of devices was also
one of the downfalls of the isolation proposal.

This did make me think of one other generic quirk we might need.
There's some funkiness with USB that makes me think that it's
effectively a shared bus between 1.x and 2.0 controllers.  So assigning
the 1.x and 2.0 controllers to different groups potentially allows a
fast and a slow path to the same set of devices.  Is this true?  If so,
we probably need to quirk OHCI/UHCI and EHCI functions together when
they're on the same PCI device.  I think the PCI class code is
sufficient to do this.  Thanks,

Alex

