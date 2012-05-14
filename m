Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2ENRMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:12:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab2ENRMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:12:12 -0400
Message-ID: <1337015502.6954.68.camel@bling.home>
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
Date: Mon, 14 May 2012 11:11:42 -0600
In-Reply-To: <20120514011627.GB30229@truffala.fritz.box>
References: <20120511222148.30496.68571.stgit@bling.home>
	 <20120511225541.30496.34751.stgit@bling.home>
	 <20120514011627.GB30229@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 11:16 +1000, David Gibson wrote:
> On Fri, May 11, 2012 at 04:55:41PM -0600, Alex Williamson wrote:
> > IOMMU device groups are currently a rather vague associative notion
> > with assembly required by the user or user level driver provider to
> > do anything useful.  This patch intends to grow the IOMMU group concept
> > into something a bit more consumable.
> > 
> > To do this, we first create an object representing the group, struct
> > iommu_group.  This structure is allocated (iommu_group_alloc) and
> > filled (iommu_group_add_device) by the iommu driver.  The iommu driver
> > is free to add devices to the group using it's own set of policies.
> > This allows inclusion of devices based on physical hardware or topology
> > limitations of the platform, as well as soft requirements, such as
> > multi-function trust levels or peer-to-peer protection of the
> > interconnects.  Each device may only belong to a single iommu group,
> > which is linked from struct device.iommu_group.  IOMMU groups are
> > maintained using kobject reference counting, allowing for automatic
> > removal of empty, unreferenced groups.  It is the responsibility of
> > the iommu driver to remove devices from the group
> > (iommu_group_remove_device).
> > 
> > IOMMU groups also include a userspace representation in sysfs under
> > /sys/kernel/iommu_groups.  When allocated, each group is given a
> > dynamically assign ID (int).  The ID is managed by the core IOMMU group
> > code to support multiple heterogeneous iommu drivers, which could
> > potentially collide in group naming/numbering.  This also keeps group
> > IDs to small, easily managed values.  A directory is created under
> > /sys/kernel/iommu_groups for each group.  A further subdirectory named
> > "devices" contains links to each device within the group.  The iommu_group
> > file in the device's sysfs directory, which formerly contained a group
> > number when read, is now a link to the iommu group.  Example:
> > 
> > $ ls -l /sys/kernel/iommu_groups/26/devices/
> > total 0
> > lrwxrwxrwx. 1 root root 0 Apr 17 12:57 0000:00:1e.0 ->
> > 		../../../../devices/pci0000:00/0000:00:1e.0
> > lrwxrwxrwx. 1 root root 0 Apr 17 12:57 0000:06:0d.0 ->
> > 		../../../../devices/pci0000:00/0000:00:1e.0/0000:06:0d.0
> > lrwxrwxrwx. 1 root root 0 Apr 17 12:57 0000:06:0d.1 ->
> > 		../../../../devices/pci0000:00/0000:00:1e.0/0000:06:0d.1
> > 
> > $ ls -l  /sys/kernel/iommu_groups/26/devices/*/iommu_group
> > [truncating perms/owner/timestamp]
> > /sys/kernel/iommu_groups/26/devices/0000:00:1e.0/iommu_group ->
> > 					../../../kernel/iommu_groups/26
> > /sys/kernel/iommu_groups/26/devices/0000:06:0d.0/iommu_group ->
> > 					../../../../kernel/iommu_groups/26
> > /sys/kernel/iommu_groups/26/devices/0000:06:0d.1/iommu_group ->
> > 					../../../../kernel/iommu_groups/26
> > 
> > Groups also include several exported functions for use by user level
> > driver providers, for example VFIO.  These include:
> > 
> > iommu_group_get(): Acquires a reference to a group from a device
> > iommu_group_put(): Releases reference
> > iommu_group_for_each_dev(): Iterates over group devices using callback
> > iommu_group_[un]register_notifier(): Allows notification of device add
> >         and remove operations relevant to the group
> > iommu_group_id(): Return the group number
> > 
> > This patch also extends the IOMMU API to allow attaching groups to
> > domains.  This is currently a simple wrapper for iterating through
> > devices within a group, but it's expected that the IOMMU API may
> > eventually make groups a more integral part of domains.
> > 
> > Groups intentionally do not try to manage group ownership.  A user
> > level driver provider must independently acquire ownership for each
> > device within a group before making use of the group as a whole.
> > This may change in the future if group usage becomes more pervasive
> > across both DMA and IOMMU ops.
> > 
> > Groups intentionally do not provide a mechanism for driver locking
> > or otherwise manipulating driver matching/probing of devices within
> > the group.  Such interfaces are generic to devices and beyond the
> > scope of IOMMU groups.  If implemented, user level providers have
> > ready access via iommu_group_for_each_dev and group notifiers.
> > 
> > Groups currently provide no storage for iommu context, but some kind
> > of iommu_group_get/set_iommudata() interface is likely if groups
> > become more pervasive in the dma layers.
> > 
> > iommu_device_group() is removed here as it has no users.  The
> > replacement is:
> > 
> > 	group = iommu_group_get(dev);
> > 	id = iommu_group_id(group);
> > 	iommu_group_put(group);
> 
> Looks reasonable to me, with a few nits, noted below.
> 
> [snip]
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index 2198b2d..f75004e 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -26,60 +26,404 @@
> >  #include <linux/slab.h>
> >  #include <linux/errno.h>
> >  #include <linux/iommu.h>
> > +#include <linux/idr.h>
> > +#include <linux/notifier.h>
> > +
> > +static struct kset *iommu_group_kset;
> > +static struct ida iommu_group_ida;
> > +static struct mutex iommu_group_mutex;
> > +
> > +struct iommu_group {
> > +	struct kobject kobj;
> > +	struct kobject *devices_kobj;
> > +	struct list_head devices;
> > +	struct mutex mutex;
> > +	struct blocking_notifier_head notifier;
> > +	int id;
> 
> I think you should add some sort of name string to the group as well
> (supplied by the iommu driver creating the group).  That would make it
> easier to connect the arbitrary assigned IDs to any platform-standard
> naming convention for these things.

When would the name be used and how is it exposed?

> [snip]
> > +/**
> > + * iommu_group_add_device - add a device to an iommu group
> > + * @group: the group into which to add the device (reference should be held)
> > + * @dev: the device
> > + *
> > + * This function is called by an iommu driver to add a device into a
> > + * group.  Adding a device increments the group reference count.
> > + */
> > +int iommu_group_add_device(struct iommu_group *group, struct device *dev)
> > +{
> > +	int ret;
> > +	struct iommu_device *device;
> > +
> > +	device = kzalloc(sizeof(*device), GFP_KERNEL);
> > +	if (!device)
> > +		return -ENOMEM;
> > +
> > +	device->dev = dev;
> > +
> > +	ret = sysfs_create_link(&dev->kobj, &group->kobj, "iommu_group");
> > +	if (ret) {
> > +		kfree(device);
> > +		return ret;
> > +	}
> > +
> > +	ret = sysfs_create_link(group->devices_kobj, &dev->kobj,
> > +				kobject_name(&dev->kobj));
> > +	if (ret) {
> > +		sysfs_remove_link(&dev->kobj, "iommu_group");
> > +		kfree(device);
> > +		return ret;
> > +	}
> 
> So, it's not clear that the kobject_name() here has to be unique
> across all devices in the group.  It might be better to use an
> arbitrary index here instead of a name to avoid that problem.

Hmm, that loses useful convenience when they are unique, such as on PCI.
I'll look and see if sysfs_create_link will fail on duplicate names and
see about adding some kind of instance to it.

> [snip]
> > +/**
> > + * iommu_group_remove_device - remove a device from it's current group
> > + * @dev: device to be removed
> > + *
> > + * This function is called by an iommu driver to remove the device from
> > + * it's current group.  This decrements the iommu group reference count.
> > + */
> > +void iommu_group_remove_device(struct device *dev)
> > +{
> > +	struct iommu_group *group = dev->iommu_group;
> > +	struct iommu_device *device;
> > +
> > +	/* Pre-notify listeners that a device is being removed. */
> > +	blocking_notifier_call_chain(&group->notifier,
> > +				     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);
> > +
> > +	mutex_lock(&group->mutex);
> > +	list_for_each_entry(device, &group->devices, list) {
> > +		if (device->dev == dev) {
> > +			list_del(&device->list);
> > +			kfree(device);
> > +			break;
> > +		}
> > +	}
> > +	mutex_unlock(&group->mutex);
> > +
> > +	sysfs_remove_link(group->devices_kobj, kobject_name(&dev->kobj));
> > +	sysfs_remove_link(&dev->kobj, "iommu_group");
> > +
> > +	dev->iommu_group = NULL;
> 
> I suspect the dev -> group pointer should be cleared first, under the
> group lock, but I'm not certain about that.

group->mutex is protecting the group's device list.  I think my
assumption is that when a device is being removed, there should be no
references to it for anyone to race with iommu_group_get(dev), but I'm
not sure how valid that is.

> [snip]
> > +/**
> > + * iommu_group_for_each_dev - iterate over each device in the group
> > + * @group: the group
> > + * @data: caller opaque data to be passed to callback function
> > + * @fn: caller supplied callback function
> > + *
> > + * This function is called by group users to iterate over group devices.
> > + * Callers should hold a reference count to the group during
> > callback.
> 
> Probably also worth noting in this doco that the group lock will be
> held across the callback.

Yes; calling iommu_group_remove_device through this would be a bad idea.

> [snip]
> > +static int iommu_bus_notifier(struct notifier_block *nb,
> > +			      unsigned long action, void *data)
> >  {
> >  	struct device *dev = data;
> > +	struct iommu_ops *ops = dev->bus->iommu_ops;
> > +	struct iommu_group *group;
> > +	unsigned long group_action = 0;
> > +
> > +	/*
> > +	 * ADD/DEL call into iommu driver ops if provided, which may
> > +	 * result in ADD/DEL notifiers to group->notifier
> > +	 */
> > +	if (action == BUS_NOTIFY_ADD_DEVICE) {
> > +		if (ops->add_device)
> > +			return ops->add_device(dev);
> > +	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> > +		if (ops->remove_device && dev->iommu_group) {
> > +			ops->remove_device(dev);
> > +			return 0;
> > +		}
> > +	}
> 
> So, there's still the question of how to assign grouping for devices
> on a subordinate bus behind a bridge which is iommu managed.  The
> iommu driver for the top-level bus can't know about all possible
> subordinate bus types, but the subordinate devices will (in most
> cases, anyway) be iommu translated as if originating with the bus
> bridge.

Not just any bridge, there has to be a different bus_type on the
subordinate side.  Things like PCI-to-PCI work as is, but a PCI-to-ISA
would trigger this.  In general, I don't know how to handle it and I'm
open to suggestions.  Perhaps we need to register notifiers for every
bus_type and create notifiers for new bus_types.  If we can catch the
ADD_DEVICE for it, we can walk up to the first parent bus that supports
an iommu_ops and add the device there.  But then we need some kind of
foreign bus support for the group since the iommu driver won't know what
to do with the device if we call add_device with it.  Other ideas?
Thanks,

Alex


