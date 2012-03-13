Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab2CMQuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:50:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab2CMQuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:50:10 -0400
Message-ID: <1331657387.2969.79.camel@bling.home>
Subject: Re: [PATCH 1/2] Isolation groups
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: aik@ozlabs.ru, dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2012 10:49:47 -0600
In-Reply-To: <20120313143340.GT24916@truffala.fritz.box>
References: <20120312220109.30321.83419.stgit@bling.home>
	 <20120312223254.30321.74405.stgit@bling.home>
	 <20120313143340.GT24916@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 01:33 +1100, David Gibson wrote:
> On Mon, Mar 12, 2012 at 04:32:54PM -0600, Alex Williamson wrote:
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  drivers/base/Kconfig      |   10 +
> >  drivers/base/Makefile     |    1 
> >  drivers/base/base.h       |    5 
> >  drivers/base/isolation.c  |  798 +++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/device.h    |    4 
> >  include/linux/isolation.h |  138 ++++++++
> >  6 files changed, 956 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/base/isolation.c
> >  create mode 100644 include/linux/isolation.h
> > 
> > diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> > index 7be9f79..e98a5f3 100644
> > --- a/drivers/base/Kconfig
> > +++ b/drivers/base/Kconfig
> > @@ -189,4 +189,14 @@ config DMA_SHARED_BUFFER
> >  	  APIs extension; the file's descriptor can then be passed on to other
> >  	  driver.
> >  
> > +config ISOLATION_GROUPS
> > +	bool "Enable Isolation Group API"
> > +	default n
> > +	depends on EXPERIMENTAL && IOMMU_API
> > +	help
> > +	  This option enables grouping of devices into Isolation Groups
> > +	  which may be used by other subsystems to perform quirks across
> > +	  sets of devices as well as userspace drivers for guaranteeing
> > +	  devices are isolated from the rest of the system.
> > +
> >  endmenu
> > diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> > index 610f999..047b5f9 100644
> > --- a/drivers/base/Makefile
> > +++ b/drivers/base/Makefile
> > @@ -19,6 +19,7 @@ obj-$(CONFIG_MODULES)	+= module.o
> >  endif
> >  obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
> >  obj-$(CONFIG_REGMAP)	+= regmap/
> > +obj-$(CONFIG_ISOLATION_GROUPS)	+= isolation.o
> >  
> >  ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
> >  
> > diff --git a/drivers/base/base.h b/drivers/base/base.h
> > index b858dfd..376758a 100644
> > --- a/drivers/base/base.h
> > +++ b/drivers/base/base.h
> > @@ -1,4 +1,5 @@
> >  #include <linux/notifier.h>
> > +#include <linux/isolation.h>
> >  
> >  /**
> >   * struct subsys_private - structure to hold the private to the driver core portions of the bus_type/class structure.
> > @@ -108,6 +109,10 @@ extern int driver_probe_device(struct device_driver *drv, struct device *dev);
> >  static inline int driver_match_device(struct device_driver *drv,
> >  				      struct device *dev)
> >  {
> > +	if (isolation_group_managed(to_isolation_group(dev)) &&
> > +	    !isolation_group_manager_driver(to_isolation_group(dev), drv))
> > +		return 0;
> > +
> >  	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
> >  }
> >  
> > diff --git a/drivers/base/isolation.c b/drivers/base/isolation.c
> > new file mode 100644
> > index 0000000..c01365c
> > --- /dev/null
> > +++ b/drivers/base/isolation.c
> > @@ -0,0 +1,798 @@
> > +/*
> > + * Isolation group interface
> > + *
> > + * Copyright (C) 2012 Red Hat, Inc. All rights reserved.
> > + * Author: Alex Williamson <alex.williamson@redhat.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/iommu.h>
> > +#include <linux/isolation.h>
> > +#include <linux/list.h>
> > +#include <linux/mutex.h>
> > +#include <linux/notifier.h>
> > +#include <linux/slab.h>
> > +#include <linux/uuid.h>
> > +
> > +static struct kset *isolation_kset;
> > +/* XXX add more complete locking, maybe rcu */
> > +static DEFINE_MUTEX(isolation_lock);
> > +static LIST_HEAD(isolation_groups);
> > +static LIST_HEAD(isolation_notifiers);
> > +
> > +/* Keep these private */
> > +struct isolation_manager_driver {
> > +	struct device_driver *drv;
> > +	struct list_head list;
> > +};
> > +
> > +struct isolation_manager {
> > +	struct list_head drivers;
> > +	/* Likely need managers to register some callbacks */
> > +};
> > +
> > +struct isolation_group {
> > +	struct list_head list;
> > +	struct list_head devices;
> > +	struct kobject kobj;
> > +	struct kobject *devices_kobj;
> > +	struct iommu_domain *iommu_domain;
> > +	struct iommu_ops *iommu_ops;
> > +	struct isolation_manager *manager;
> > +	uuid_le uuid;
> > +};
> > +
> > +struct isolation_device {
> > +	struct device *dev;
> > +	struct list_head list;
> > +};
> > +
> > +struct isolation_notifier {
> > +	struct bus_type *bus;
> > +	struct notifier_block nb;
> > +	struct blocking_notifier_head notifier;
> > +	struct list_head list;
> > +	int refcnt;
> > +};
> > +
> > +struct iso_attribute {
> > +	struct attribute attr;
> > +	ssize_t (*show)(struct isolation_group *group, char *buf);
> > +	ssize_t (*store)(struct isolation_group *group,
> > +			 const char *buf, size_t count);
> > +};
> > +
> > +#define to_iso_attr(_attr) container_of(_attr, struct iso_attribute, attr)
> > +#define to_iso_group(_kobj) container_of(_kobj, struct isolation_group, kobj)
> > +
> > +static ssize_t iso_attr_show(struct kobject *kobj, struct attribute *attr,
> > +			     char *buf)
> > +{
> > +	struct iso_attribute *iso_attr = to_iso_attr(attr);
> > +	struct isolation_group *group = to_iso_group(kobj);
> > +	ssize_t ret = -EIO;
> > +
> > +	if (iso_attr->show)
> > +		ret = iso_attr->show(group, buf);
> > +	return ret;
> > +}
> > +
> > +static ssize_t iso_attr_store(struct kobject *kobj, struct attribute *attr,
> > +			      const char *buf, size_t count)
> > +{
> > +	struct iso_attribute *iso_attr = to_iso_attr(attr);
> > +	struct isolation_group *group = to_iso_group(kobj);
> > +	ssize_t ret = -EIO;
> > +
> > +	if (iso_attr->store)
> > +		ret = iso_attr->store(group, buf, count);
> > +	return ret;
> > +}
> > +
> > +static void iso_release(struct kobject *kobj)
> > +{
> > +	struct isolation_group *group = to_iso_group(kobj);
> > +	kfree(group);
> > +}
> > +
> > +static const struct sysfs_ops iso_sysfs_ops = {
> > +	.show = iso_attr_show,
> > +	.store = iso_attr_store,
> > +};
> > +
> > +static struct kobj_type iso_ktype = {
> > +	.sysfs_ops = &iso_sysfs_ops,
> > +	.release = iso_release,
> > +};
> > +
> > +/*
> > + * Create an isolation group.  Isolation group "providers" register a
> > + * notifier for their bus(es) and call this to create a new isolation
> > + * group.
> > + */
> > +struct isolation_group *isolation_create_group(void)
> > +{
> > +	struct isolation_group *group, *tmp;
> > +	int ret;
> > +
> > +	if (unlikely(!isolation_kset))
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	group = kzalloc(sizeof(*group), GFP_KERNEL);
> > +	if (!group)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	/*
> > +	 * Use a UUID for group identification simply because it seems wrong
> > +	 * to expose it as a kernel pointer (%p).  Neither is user friendly.
> > +	 * Mostly only expect userspace to do anything with this.
> > +	 */
> 
> So, my plan was to require the isolation provider to give a unique
> name - it can construct something that's actually meaningful (and with
> luck, stable across boots).  For Power we'd use the PE number, for
> VT-d, I was thinking the PCI device address would do it (of the "base"
> device for the non-separable bridge and broken multifunction cases).

Naming always seems to end in "that's not unique" or "that doesn't apply
to us", so I figured I'd just avoid the problem by using random numbers.
We can allow providers to specify a name, but that still presents
challenges to uniqueness and consistency if we intend to generically
allow heterogeneous providers on a system.  In the VFIO use case I
expect userspace will get the name from readlink on the isolation_group
sysfs entry and open a vfio provided device file of the same name.  So
in the end, it doesn't matter what the name is.

> > +new_uuid:
> > +	uuid_le_gen(&group->uuid);
> > +
> > +	/* Unlikely, but nothing prevents duplicates */
> > +	list_for_each_entry(tmp, &isolation_groups, list)
> > +		if (memcmp(&group->uuid, &tmp->uuid, sizeof(group->uuid)) == 0)
> > +			goto new_uuid;
> > +
> > +	INIT_LIST_HEAD(&group->devices);
> > +	group->kobj.kset = isolation_kset;
> > +
> > +	ret = kobject_init_and_add(&group->kobj, &iso_ktype, NULL,
> > +				   "%pUl", &group->uuid);
> 
> Um.. isn't this setting the kobject name to the address of the uuid
> plus "Ul", not the content of the uuid?

We have kernel extensions for %p, %pUl is a little endian UUID.  It
prints in the right format, but I'll have to check if I'm getting the
actual UUID or a UUID-ified pointer address.

> > +	if (ret) {
> > +		kfree(group);
> > +		mutex_unlock(&isolation_lock);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	/* Add a subdirectory to save links for devices withing the group. */
> > +	group->devices_kobj = kobject_create_and_add("devices", &group->kobj);
> > +	if (!group->devices_kobj) {
> > +		kobject_put(&group->kobj);
> > +		mutex_unlock(&isolation_lock);
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	list_add(&group->list, &isolation_groups);
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return group;
> > +}
> > +
> > +/*
> > + * Free isolation group.  XXX need to cleanup/reject based on manager status.
> > + */
> > +int isolation_free_group(struct isolation_group *group)
> > +{
> > +	mutex_lock(&isolation_lock);
> > +
> > +	if (!list_empty(&group->devices)) {
> > +		mutex_unlock(&isolation_lock);
> > +		return -EBUSY;
> > +	}
> > +
> > +	list_del(&group->list);
> > +	kobject_put(group->devices_kobj);
> > +	kobject_put(&group->kobj);
> > +
> > +	mutex_unlock(&isolation_lock);
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Add a device to an isolation group.  Isolation groups start empty and
> > + * must be told about the devices they contain.  Expect this to be called
> > + * from isolation group providers via notifier.
> > + */
> 
> Doesn't necessarily have to be from a notifier, particularly if the
> provider is integrated into host bridge code.

Sure, a provider could do this on it's own if it wants.  This just
provides some infrastructure for a common path.  Also note that this
helps to eliminate all the #ifdef CONFIG_ISOLATION in the provider.  Yet
to be seen whether that can reasonably be the case once isolation groups
are added to streaming DMA paths.

> > +int isolation_group_add_dev(struct isolation_group *group, struct device *dev)
> > +{
> > +	struct isolation_device *device;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	if (dev->isolation_group) {
> > +		ret = -EBUSY;
> > +		goto out;
> 
> This should probably be a BUG_ON() - the isolation provider shouldn't
> be putting the same device into two different groups.

Yeah, probably.

> > +	}
> > +
> > +	device = kzalloc(sizeof(*device), GFP_KERNEL);
> > +	if (!device) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	device->dev = dev;
> > +
> > +	/* Cross link the device in sysfs */
> > +	ret = sysfs_create_link(&dev->kobj, &group->kobj,
> > +				"isolation_group");
> > +	if (ret) {
> > +		kfree(device);
> > +		goto out;
> > +	}
> > +	
> > +	ret = sysfs_create_link(group->devices_kobj, &dev->kobj,
> > +				kobject_name(&dev->kobj));
> 
> So, a problem both here and in my version is what to name the device
> links.  Because they could be potentially be quite widely scattered,
> I'm not sure that kobject_name() is guaranteed to be sufficiently
> unique.

Even if the name is not, we're pointing to a unique sysfs location.  I
expect the primary user of this will be when userspace translates a
device to a group (via the isolation_group link below), then tries to
walk all the devices in the group to determine effected host devices and
manager driver status.  So it would probably be traversing the link back
rather than relying solely on the name of the link.  Right?

> > +	if (ret) {
> > +		sysfs_remove_link(&dev->kobj, "isolation_group");
> > +		kfree(device);
> > +		goto out;
> > +	}
> > +
> > +	list_add(&device->list, &group->devices);
> > +
> > +	dev->isolation_group = group;
> > +
> > +	if (group->iommu_domain) {
> > +		ret = group->iommu_ops->attach_dev(group->iommu_domain, dev);
> > +		if (ret) {
> > +			/* XXX fail device? */
> > +		}
> 
> So, I presume the idea is that this is a stop-gap until iommu_ops is
> converted to be in terms of groups rather than indivdual devices?

Yes, I thought we could just back it by the iommu api for now so we can
implement managers, but eventually domain_init and attach_dev would
probably be a single callback in some kind of group aware iommu api.

> > +	}
> > +
> > +	/* XXX signal manager? */
> 
> Uh, what did you have in mind here?

Another notifier?  Maybe just a callback struct registered when a
manager is added to a group.  On one hand, maybe it's not necessary
because adding a device to a managed group already restricts driver
matching, but on the other, the manager may want to be informed about
new devices and try to actively bind a driver to it.  For instance, if
assigning an entire PE to a guest, which might include empty slots,
would the manager want to be informed about the addition of a device so
it could mirror the addition to the guest assigned the PE?

> > +out:
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Remove a device from an isolation group, likely because the device
> > + * went away.
> > + */
> > +int isolation_group_del_dev(struct device *dev)
> > +{
> > +	struct isolation_group *group = dev->isolation_group;
> > +	struct isolation_device *device;
> > +
> > +	if (!group)
> > +		return -ENODEV;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	list_for_each_entry(device, &group->devices, list) {
> > +		if (device->dev == dev) {
> > +			/* XXX signal manager? */
> > +
> > +			if (group->iommu_domain)
> > +				group->iommu_ops->detach_dev(
> > +					group->iommu_domain, dev);
> > +			list_del(&device->list);
> > +			kfree(device);
> > +			dev->isolation_group = NULL;
> > +			sysfs_remove_link(group->devices_kobj,
> > +					  kobject_name(&dev->kobj));
> > +			sysfs_remove_link(&dev->kobj, "isolation_group");
> > +			break;
> > +		}
> > +	}
> > +			
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Filter and call out to our own notifier chains
> > + */
> 
> So, I haven't quite worked out what this isolation notifier
> infrastructure gives you, as opposed to having isolation providers
> directly register bus notifiers.

For now, it nicely separates CONFIG_ISOLATION code so I don't litter
intel-iommu with #ifdefs.  It also embraces that devices are always
being added and removed and supports that with very little change to
existing code paths.

> > +static int isolation_bus_notify(struct notifier_block *nb,
> > +				unsigned long action, void *data)
> > +{
> > +	struct isolation_notifier *notifier =
> > +		container_of(nb, struct isolation_notifier, nb);
> > +	struct device *dev = data;
> > +
> > +	switch (action) {
> > +	case BUS_NOTIFY_ADD_DEVICE:
> > +		if (!dev->isolation_group)
> > +			blocking_notifier_call_chain(&notifier->notifier,
> > +					ISOLATION_NOTIFY_ADD_DEVICE, dev);
> > +		break;
> > +	case BUS_NOTIFY_DEL_DEVICE:
> > +		if (dev->isolation_group)
> > +			blocking_notifier_call_chain(&notifier->notifier,
> > +					ISOLATION_NOTIFY_DEL_DEVICE, dev);
> > +		break;
> > +	}
> > +
> > +	return NOTIFY_DONE;
> > +}
> > +
> > +/*
> > + * Wrapper for manual playback of BUS_NOTIFY_ADD_DEVICE when we add
> > + * a new notifier.
> > + */
> > +static int isolation_do_add_notify(struct device *dev, void *data)
> > +{
> > +	struct notifier_block *nb = data;
> > +
> > +	if (!dev->isolation_group)
> > +		nb->notifier_call(nb, ISOLATION_NOTIFY_ADD_DEVICE, dev);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Register a notifier.  This is for isolation group providers.  It's
> > + * possible we could have multiple isolation group providers for the same
> > + * bus type,
> 
> So the bit above doesn't seem to connect to the bit below.  We can
> indeed have multiple isolation providers for one bus type, but the
> below seems to be covering the (also possible, but different) case of
> one isolation provider covering multiple bus types.

It covers both.  If a provider covers multiple buses it will call this
function once for each bus.  Each new bus creates a new struct
isolation_notifier and does a bus_register_notifier (using
isolation_bus_notify).  The provider notifier block is added to our own
notifier call chain for that struct isolation_notifier.  This way we
only ever register a single notifier per bus, but support multiple
providers for the bus.

> > so we create a struct isolation_notifier per bus_type, each
> > + * with a notifier block.  Providers are therefore welcome to register
> > + * as many buses as they can handle.
> > + */
> > +int isolation_register_notifier(struct bus_type *bus, struct notifier_block *nb)
> > +{
> > +	struct isolation_notifier *notifier;
> > +	bool found = false;
> > +	int ret;
> > +
> > +	mutex_lock(&isolation_lock);
> > +	list_for_each_entry(notifier, &isolation_notifiers, list) {
> > +		if (notifier->bus == bus) {
> > +			found = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (!found) {
> > +		notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
> > +		if (!notifier) {
> > +			mutex_unlock(&isolation_lock);
> > +			return -ENOMEM;	
> > +		}
> > +		notifier->bus = bus;
> > +		notifier->nb.notifier_call = isolation_bus_notify;
> > +		BLOCKING_INIT_NOTIFIER_HEAD(&notifier->notifier);
> > +		bus_register_notifier(bus, &notifier->nb);
> > +		list_add(&notifier->list, &isolation_notifiers);
> > +	}
> > +
> > +	ret = blocking_notifier_chain_register(&notifier->notifier, nb);
> > +	if (ret) {
> > +		if (notifier->refcnt == 0) {
> > +			bus_unregister_notifier(bus, &notifier->nb);
> > +			list_del(&notifier->list);
> > +			kfree(notifier);
> > +		}
> > +		mutex_unlock(&isolation_lock);
> > +		return ret;
> > +	}
> > +	notifier->refcnt++;
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	bus_for_each_dev(bus, NULL, nb, isolation_do_add_notify);
> > +
> > +	return 0;
> > +}
> 
> So, somewhere, I think we need a fallback path, but I'm not sure
> exactly where.  If an isolation provider doesn't explicitly put a
> device into a group, the device should go into the group of its parent
> bridge.  This covers the case of a bus with IOMMU which has below it a
> bridge to a different type of DMA capable bus (which the IOMMU isn't
> explicitly aware of).  DMAs from devices on the subordinate bus can be
> translated by the top-level IOMMU (assuming it sees them as coming
> from the bridge), but they all need to be treated as one group.

Why would the top level IOMMU provider not set the isolation group in
this case.  I agree there's a gap here, but it's fuzzy when and how it
can occur and if it matters (devices without an isolation group can't be
used by managers, and apparently don't make use of any of the services
of a provider...).

> > +/*
> > + * Unregister...
> > + */
> > +int isolation_unregister_notifier(struct bus_type *bus,
> > +				  struct notifier_block *nb)
> > +{
> > +	struct isolation_notifier *notifier;
> > +	bool found = false;
> > +	int ret;
> > +
> > +	mutex_lock(&isolation_lock);
> > +	list_for_each_entry(notifier, &isolation_notifiers, list) {
> > +		if (notifier->bus == bus) {
> > +			found = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (!found) {
> > +		mutex_unlock(&isolation_lock);
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret = blocking_notifier_chain_unregister(&notifier->notifier, nb);
> > +	if (ret) {
> > +		mutex_unlock(&isolation_lock);
> > +		return ret;
> > +	}
> > +
> > +	/* Free at nobody left in the notifier block */
> > +	if (--notifier->refcnt == 0) {
> > +		bus_unregister_notifier(bus, &notifier->nb);
> > +		list_del(&notifier->list);
> > +		kfree(notifier);
> > +	}
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Set iommu_ops on an isolation group.  Hopefully all DMA will eventually
> > + * be done through isolation groups, for now, we just provide another
> > + * interface to the iommu api.
> > + */
> > +int isolation_group_set_iommu_ops(struct isolation_group *group,
> > +				  struct iommu_ops *iommu_ops)
> > +{
> > +	mutex_lock(&isolation_lock);
> > +
> > +	if (group->iommu_ops) {
> > +		mutex_unlock(&isolation_lock);
> > +		return -EBUSY;
> > +	}
> > +
> > +	group->iommu_ops = iommu_ops;
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Attach all the devices for a group to the specified iommu domain.
> > + */
> > +static int __isolation_group_domain_attach_devs(struct iommu_domain *domain,
> > +					        struct list_head *devices)
> > +{
> > +	struct isolation_device *device;
> > +	struct device *dev;
> > +	int ret = 0;
> > +
> > +	list_for_each_entry(device, devices, list) {
> > +		dev = device->dev;
> > +
> > +		ret = domain->ops->attach_dev(domain, dev);
> > +		if (ret) {
> > +			list_for_each_entry_continue_reverse(device,
> > +							     devices, list) {
> > +				dev = device->dev;
> > +				domain->ops->detach_dev(domain, dev);
> > +			}
> > +			break;
> > +		}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * And detach...
> > + */
> > +static void __isolation_group_domain_detach_devs(struct iommu_domain *domain,
> > +						 struct list_head *devices)
> > +{
> > +	struct isolation_device *device;
> > +	struct device *dev;
> > +
> > +	list_for_each_entry(device, devices, list) {
> > +		dev = device->dev;
> > +
> > +		domain->ops->detach_dev(domain, dev);
> > +	}
> > +}
> > +
> > +/*
> > + * Initialize the iommu domain for an isolation group.  This is to ease the
> > + * transition to using isolation groups and expected to be used by current
> > + * users of the iommu api for now.
> > + */
> > +int isolation_group_init_iommu_domain(struct isolation_group *group)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	if (!group->iommu_ops || list_empty(&group->devices)) {
> > +		mutex_unlock(&isolation_lock);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (group->iommu_domain) {
> > +		mutex_unlock(&isolation_lock);
> > +		return -EBUSY;
> > +	}
> > +
> > +	group->iommu_domain = kzalloc(sizeof(struct iommu_domain), GFP_KERNEL);
> > +	if (!group->iommu_domain) {
> > +		mutex_unlock(&isolation_lock);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	group->iommu_domain->ops = group->iommu_ops;
> > +
> > +	ret = group->iommu_ops->domain_init(group->iommu_domain);
> > +	if (ret) {
> > +		kfree(group->iommu_domain);
> > +		group->iommu_domain = NULL;
> > +		mutex_unlock(&isolation_lock);
> > +		return ret;
> > +	}
> > +
> > +	/* Automatically attach all the devices in the group. */
> > +	ret = __isolation_group_domain_attach_devs(group->iommu_domain,
> > +						   &group->devices);
> > +	if (ret) {
> > +		group->iommu_ops->domain_destroy(group->iommu_domain);
> > +		kfree(group->iommu_domain);
> > +		group->iommu_domain = NULL;
> > +		mutex_unlock(&isolation_lock);
> > +		return ret;
> > +	}
> > +		
> > +	mutex_unlock(&isolation_lock);
> > +	return 0;
> > +}
> > +
> > +/*
> > + * And free...
> > + * Note just below, we add the ability to add another group to an iommu
> > + * domain, so we don't always destroy and free the domain here.
> > + */
> > +void isolation_group_free_iommu_domain(struct isolation_group *group)
> > +{
> > +	struct isolation_group *tmp;
> > +	bool inuse = false;
> > +
> > +	if (!group->iommu_domain || !group->iommu_ops)
> > +		return;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	__isolation_group_domain_detach_devs(group->iommu_domain,
> > +					     &group->devices);
> > +
> > +	list_for_each_entry(tmp, &isolation_groups, list) {
> > +		if (tmp == group)
> > +			continue;
> > +		if (tmp->iommu_domain == group->iommu_domain) {
> > +			inuse = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (!inuse) {
> > +		group->iommu_ops->domain_destroy(group->iommu_domain);
> > +		kfree(group->iommu_domain);
> > +	}
> > +
> > +	group->iommu_domain = NULL;
> > +
> > +	mutex_unlock(&isolation_lock);
> > +}
> > +
> > +/*
> > + * This handles the VFIO "merge" interface, allowing us to manage multiple
> > + * isolation groups with a single domain.  We just rely on attach_dev to
> > + * tell us whether this is ok.
> > + */
> > +int isolation_group_iommu_domain_add_group(struct isolation_group *groupa,
> > +					   struct isolation_group *groupb)
> > +{
> > +	int ret;
> > +
> > +	if (!groupa->iommu_domain ||
> > +	    groupb->iommu_domain || list_empty(&groupb->devices))
> > +		return -EINVAL;
> > +
> > +	if (groupa->iommu_ops != groupb->iommu_ops)
> > +		return -EIO;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	ret = __isolation_group_domain_attach_devs(groupa->iommu_domain,
> > +						   &groupb->devices);
> > +	if (ret) {
> > +		mutex_unlock(&isolation_lock);
> > +		return ret;
> > +	}
> > +
> > +	groupb->iommu_domain = groupa->iommu_domain;
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * XXX page mapping/unmapping and more iommu api wrappers
> > + */
> > +
> > +/*
> > + * Do we have a group manager?  Group managers restrict what drivers are
> > + * allowed to attach to devices.  A group is "locked" when all of the devices
> > + * for a group belong to group manager drivers (or no driver at all).  At
> > + * that point, the group manager can initialize the iommu.  vfio is an example
> > + * of a group manager and vfio-pci is an exanple of a driver that a group
> > + * manager may add as a "managed" driver.  Note that we don't gate iommu
> > + * manipulation on being managed because we want to use it for regular DMA
> > + * at some point as well.
> > + */
> > +bool isolation_group_managed(struct isolation_group *group)
> > +{
> > +	return group->manager != NULL;
> > +}
> > +
> > +/*
> > + * Initialize the group manager struct.  At this point the isolation group
> > + * becomes "managed".
> > + */
> 
> This assumes a separate manager struct for each group.  I would have
> thought the VFIO merge case would be more obviously represented by
> having a single manager struct for all the groups in the VFIO instance
> (== iommu domain).

Given the objections to merging groups, I thought perhaps it would be
safer to explicitly make it pertain to the iommu domain here.  My vision
of managers and merging is still solidifying, but the manager init seems
like a first step to claiming a group while attempting to share
resources comes a while later.  I don't see much overhead on either the
grouping code or the manager code for keeping these separate.  Do you?

> > +int isolation_group_init_manager(struct isolation_group *group)
> > +{
> > +	mutex_lock(&isolation_lock);
> > +
> > +	if (group->manager) {
> > +		mutex_unlock(&isolation_lock);
> > +		return -EBUSY;
> > +	}
> > +
> > +	group->manager = kzalloc(sizeof(struct isolation_manager), GFP_KERNEL);
> > +	if (!group->manager) {
> > +		mutex_unlock(&isolation_lock);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * And free... cleanup registerd managed drivers too.
> > + */
> > +void isolation_group_free_manager(struct isolation_group *group)
> > +{
> > +	struct isolation_manager_driver *driver, *tmp;
> > +
> > +	if (!group->manager)
> > +		return;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	list_for_each_entry_safe(driver, tmp, &group->manager->drivers, list) {
> > +		list_del(&driver->list);
> > +		kfree(driver);
> > +	}
> > +		
> > +	kfree(group->manager);
> > +	group->manager = NULL;
> > +	mutex_unlock(&isolation_lock);
> > +}
> > +
> > +/*
> > + * Add a managed driver.  Drivers added here are the only ones that will
> > + * be allowed to attach to a managed isolation group.
> > + */
> > +int isolation_group_manager_add_driver(struct isolation_group *group,
> > +				       struct device_driver *drv)
> > +{
> > +	struct isolation_manager_driver *driver;
> > +
> > +	if (!group->manager)
> > +		return -EINVAL;
> > +
> > +	driver = kzalloc(sizeof(*driver), GFP_KERNEL);
> > +	if (!driver)
> > +		return -ENOMEM;
> > +
> > +	driver->drv = drv;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	list_add(&driver->list, &group->manager->drivers);
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * And remove a driver.  Don't really expect to need this much.
> > + */
> > +void isolation_group_manager_del_driver(struct isolation_group *group,
> > +				        struct device_driver *drv)
> > +{
> > +	struct isolation_manager_driver *driver;
> > +
> > +	if (!group->manager)
> > +		return;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	list_for_each_entry(driver, &group->manager->drivers, list) {
> > +		if (driver->drv == drv) {
> > +			list_del(&driver->list);
> > +			kfree(driver);
> > +			break;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&isolation_lock);
> > +}
> > +
> > +/*
> > + * Test whether a driver is a "managed" driver for the group.  This allows
> > + * is to preempt normal driver matching and only let our drivers in.
> > + */
> > +bool isolation_group_manager_driver(struct isolation_group *group,
> > +				    struct device_driver *drv)
> > +{
> > +	struct isolation_manager_driver *driver;
> > +	bool found = false;
> > +
> > +	if (!group->manager)
> > +		return found;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	list_for_each_entry(driver, &group->manager->drivers, list) {
> > +		if (driver->drv == drv) {
> > +			found = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return found;
> > +}
> > +
> > +/*
> > + * Does the group manager have control of all of the devices in the group?
> > + * We consider driver-less devices to be ok here as they don't do DMA and
> > + * don't present any interfaces to subvert the rest of the group.
> > + */
> > +bool isolation_group_manager_locked(struct isolation_group *group)
> > +{
> > +	struct isolation_device *device;
> > +	struct isolation_manager_driver *driver;
> > +	bool found, locked = true;
> > +
> > +	if (!group->manager)
> > +		return false;
> > +
> > +	mutex_lock(&isolation_lock);
> > +
> > +	list_for_each_entry(device, &group->devices, list) {
> > +		found = false;
> > +
> > +		if (!device->dev->driver)
> > +			continue;
> > +
> 
> You could simplify this using isolation_group_manager_driver(),
> couldn't you?

Yeah, probably.

> > +		list_for_each_entry(driver, &group->manager->drivers, list) {
> > +			if (device->dev->driver == driver->drv) {
> > +				found = true;
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (!found) {
> > +			locked = false;
> > +			break;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&isolation_lock);
> > +
> > +	return locked;
> > +}
> > +
> > +static int __init isolation_init(void)
> > +{
> > +	isolation_kset = kset_create_and_add("isolation", NULL, NULL);
> > +	
> > +	WARN(!isolation_kset, "Failed to initialize isolation group kset\n");
> > +
> > +	return isolation_kset ? 0 : -1;
> 
> I'd be tempted to just BUG() here if you can't add the kset - I can't
> see any reason it would fail unless you're so short of RAM that you
> have bigger problems.  Making this a fatal fail would save having to
> double check if the kset is around in the later paths.

Yep.  Thanks for the comments,

Alex


