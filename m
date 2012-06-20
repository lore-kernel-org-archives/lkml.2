Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2FTKCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:02:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:39046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab2FTKC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:02:29 -0400
Message-ID: <1340186501.28143.158.camel@pasglop>
Subject: Re: [PATCH v2 2/7] iommu: IOMMU Groups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, bhelgaas@google.com, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com, liuj97@gmail.com
Date: Wed, 20 Jun 2012 20:01:41 +1000
In-Reply-To: <20120530201852.31527.23265.stgit@bling.home>
References: <20120530201424.31527.33142.stgit@bling.home>
	 <20120530201852.31527.23265.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 14:18 -0600, Alex Williamson wrote:

> IOMMU groups also include a userspace representation in sysfs under
> /sys/kernel/iommu_groups.  When allocated, each group is given a
> dynamically assign ID (int).  The ID is managed by the core IOMMU group
> code to support multiple heterogeneous iommu drivers, which could
> potentially collide in group naming/numbering.  This also keeps group
> IDs to small, easily managed values.  A directory is created under
> /sys/kernel/iommu_groups for each group.  A further subdirectory named
> "devices" contains links to each device within the group.  The iommu_group
> file in the device's sysfs directory, which formerly contained a group
> number when read, is now a link to the iommu group.  Example:

So first, I'm generally ok with the patch, I have a few comments mostly
for discussion and possible further improvements, but so far nothing
that can't be done via subsequent patches, so let's start with

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Now:

How easy would it be add our own files there (in sysfs) ? I'm thinking
mostly for debug/diagnostic purposes it would be handy to show some HW
state related to the group or should I just add debugfs stuff
elsewhere ?

> This patch also extends the IOMMU API to allow attaching groups to
> domains.  This is currently a simple wrapper for iterating through
> devices within a group, but it's expected that the IOMMU API may
> eventually make groups a more integral part of domains.

I assume that by domains you mean "iommu domains" ? Just to be sure
because we also have PCI domains so it can be confusing :-)

> +/**
> + * iommu_group_alloc - Allocate a new group
> + * @name: Optional name to associate with group, visible in sysfs
> + *
> + * This function is called by an iommu driver to allocate a new iommu
> + * group.  The iommu group represents the minimum granularity of the iommu.
> + * Upon successful return, the caller holds a reference to the supplied
> + * group in order to hold the group until devices are added.  Use
> + * iommu_group_put() to release this extra reference count, allowing the
> + * group to be automatically reclaimed once it has no devices or external
> + * references.
> + */
> +struct iommu_group *iommu_group_alloc(void)
>  {
> -	unsigned int groupid;
> +	struct iommu_group *group;
> +	int ret;
> +
> +	group = kzalloc(sizeof(*group), GFP_KERNEL);
> +	if (!group)
> +		return ERR_PTR(-ENOMEM);
> +
> +	group->kobj.kset = iommu_group_kset;
> +	mutex_init(&group->mutex);
> +	INIT_LIST_HEAD(&group->devices);
> +	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
> +
> +	mutex_lock(&iommu_group_mutex);
> +
> +again:
> +	if (unlikely(0 == ida_pre_get(&iommu_group_ida, GFP_KERNEL))) {
> +		kfree(group);
> +		mutex_unlock(&iommu_group_mutex);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	if (-EAGAIN == ida_get_new(&iommu_group_ida, &group->id))
> +		goto again;
> +
> +	mutex_unlock(&iommu_group_mutex);
>  
> -	if (iommu_device_group(dev, &groupid) == 0)
> -		return device_create_file(dev, &dev_attr_iommu_group);
> +	ret = kobject_init_and_add(&group->kobj, &iommu_group_ktype,
> +				   NULL, "%d", group->id);
> +	if (ret) {
> +		mutex_lock(&iommu_group_mutex);
> +		ida_remove(&iommu_group_ida, group->id);
> +		mutex_unlock(&iommu_group_mutex);
> +		kfree(group);
> +		return ERR_PTR(ret);
> +	}
> +
> +	group->devices_kobj = kobject_create_and_add("devices", &group->kobj);
> +	if (!group->devices_kobj) {
> +		kobject_put(&group->kobj); /* triggers .release & free */
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/*
> +	 * The devices_kobj holds a reference on the group kobject, so
> +	 * as long as that exists so will the group.  We can therefore
> +	 * use the devices_kobj for reference counting.
> +	 */
> +	kobject_put(&group->kobj);
> +
> +	return group;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_alloc);
> +
> +/**
> + * iommu_group_get_iommudata - retrieve iommu_data registered for a group
> + * @group: the group
> + *
> + * iommu drivers can store data in the group for use when doing iommu
> + * operations.  This function provides a way to retrieve it.  Caller
> + * should hold a group reference.
> + */
> +void *iommu_group_get_iommudata(struct iommu_group *group)
> +{
> +	return group->iommu_data;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_get_iommudata);

That probably wants to be a static inline ? No biggie, could be done in
a followup patch if we really care.

> +/**
> + * iommu_group_set_iommudata - set iommu_data for a group
> + * @group: the group
> + * @iommu_data: new data
> + * @release: release function for iommu_data
> + *
> + * iommu drivers can store data in the group for use when doing iommu
> + * operations.  This function provides a way to set the data after
> + * the group has been allocated.  Caller should hold a group reference.
> + */
> +void iommu_group_set_iommudata(struct iommu_group *group, void *iommu_data,
> +			       void (*release)(void *iommu_data))
> +{
> +	group->iommu_data = iommu_data;
> +	group->iommu_data_release = release;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_set_iommudata);
> +
> +/**
> + * iommu_group_set_name - set name for a group
> + * @group: the group
> + * @name: name
> + *
> + * Allow iommu driver to set a name for a group.  When set it will
> + * appear in a name attribute file under the group in sysfs.
> + */
> +int iommu_group_set_name(struct iommu_group *group, const char *name)
> +{
> +	int ret;
> +
> +	if (group->name) {
> +		iommu_group_remove_file(group, &iommu_group_attr_name);
> +		kfree(group->name);
> +		group->name = NULL;
> +		if (!name)
> +			return 0;
> +	}
> +
> +	group->name = kstrdup(name, GFP_KERNEL);
> +	if (!group->name)
> +		return -ENOMEM;
> +
> +	ret = iommu_group_create_file(group, &iommu_group_attr_name);
> +	if (ret) {
> +		kfree(group->name);
> +		group->name = NULL;
> +		return ret;
> +	}
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(iommu_group_set_name);
>  
> -static int remove_iommu_group(struct device *dev)
> +/**
> + * iommu_group_add_device - add a device to an iommu group
> + * @group: the group into which to add the device (reference should be held)
> + * @dev: the device
> + *
> + * This function is called by an iommu driver to add a device into a
> + * group.  Adding a device increments the group reference count.
> + */
> +int iommu_group_add_device(struct iommu_group *group, struct device *dev)
>  {
> -	unsigned int groupid;
> +	int ret, i = 0;
> +	struct iommu_device *device;
> +
> +	device = kzalloc(sizeof(*device), GFP_KERNEL);
> +	if (!device)
> +		return -ENOMEM;
> +
> +	device->dev = dev;
>  
> -	if (iommu_device_group(dev, &groupid) == 0)
> -		device_remove_file(dev, &dev_attr_iommu_group);
> +	ret = sysfs_create_link(&dev->kobj, &group->kobj, "iommu_group");
> +	if (ret) {
> +		kfree(device);
> +		return ret;
> +	}
> +
> +	device->name = kasprintf(GFP_KERNEL, "%s", kobject_name(&dev->kobj));
> +rename:
> +	if (!device->name) {
> +		sysfs_remove_link(&dev->kobj, "iommu_group");
> +		kfree(device);
> +		return -ENOMEM;
> +	}
>  
> +	ret = sysfs_create_link_nowarn(group->devices_kobj,
> +				       &dev->kobj, device->name);
> +	if (ret) {
> +		kfree(device->name);
> +		if (ret == -EEXIST && i >= 0) {
> +			/*
> +			 * Account for the slim chance of collision
> +			 * and append an instance to the name.
> +			 */
> +			device->name = kasprintf(GFP_KERNEL, "%s.%d",
> +						 kobject_name(&dev->kobj), i++);
> +			goto rename;
> +		}
> +
> +		sysfs_remove_link(&dev->kobj, "iommu_group");
> +		kfree(device);
> +		return ret;
> +	}
> +
> +	kobject_get(group->devices_kobj);
> +
> +	dev->iommu_group = group;
> +
> +	mutex_lock(&group->mutex);
> +	list_add_tail(&device->list, &group->devices);
> +	mutex_unlock(&group->mutex);
> +
> +	/* Notify any listeners about change to group. */
> +	blocking_notifier_call_chain(&group->notifier,
> +				     IOMMU_GROUP_NOTIFY_ADD_DEVICE, dev);
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(iommu_group_add_device);

There's of course a race here, not sure what we can do about it though
(if the device is removed before the notification is finalized). It
might not even be worth bothering. I suppose we assume the caller holds
a reference so the struct device itself won't go away until we have
returned anyway, however I worry that the "client" might end up getting
the remove notification before it gets the add :-)

Here too, something that we can sort out in a subsequent patch if worth
it.

Or we can just say that it's up to the callers (platform, hotplug
code, ...) to not call add and remove racily.

> -static int iommu_device_notifier(struct notifier_block *nb,
> -				 unsigned long action, void *data)
> +/**
> + * iommu_group_remove_device - remove a device from it's current group
> + * @dev: device to be removed
> + *
> + * This function is called by an iommu driver to remove the device from
> + * it's current group.  This decrements the iommu group reference count.
> + */
> +void iommu_group_remove_device(struct device *dev)
> +{
> +	struct iommu_group *group = dev->iommu_group;
> +	struct iommu_device *tmp_device, *device = NULL;
> +
> +	/* Pre-notify listeners that a device is being removed. */
> +	blocking_notifier_call_chain(&group->notifier,
> +				     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);
> +
> +	mutex_lock(&group->mutex);
> +	list_for_each_entry(tmp_device, &group->devices, list) {
> +		if (tmp_device->dev == dev) {
> +			device = tmp_device;
> +			list_del(&device->list);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&group->mutex);
> +
> +	if (!device)
> +		return;
> +
> +	sysfs_remove_link(group->devices_kobj, device->name);
> +	sysfs_remove_link(&dev->kobj, "iommu_group");
> +
> +	kfree(device->name);
> +	kfree(device);
> +	dev->iommu_group = NULL;
> +	kobject_put(group->devices_kobj);
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_remove_device);
> +
> +/**
> + * iommu_group_for_each_dev - iterate over each device in the group
> + * @group: the group
> + * @data: caller opaque data to be passed to callback function
> + * @fn: caller supplied callback function
> + *
> + * This function is called by group users to iterate over group devices.
> + * Callers should hold a reference count to the group during callback.
> + * The group->mutex is held across callbacks, which will block calls to
> + * iommu_group_add/remove_device.
> + */
> +int iommu_group_for_each_dev(struct iommu_group *group, void *data,
> +			     int (*fn)(struct device *, void *))
> +{
> +	struct iommu_device *device;
> +	int ret = 0;
> +
> +	mutex_lock(&group->mutex);
> +	list_for_each_entry(device, &group->devices, list) {
> +		ret = fn(device->dev, data);
> +		if (ret)
> +			break;
> +	}
> +	mutex_unlock(&group->mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_for_each_dev);
> +
> +/**
> + * iommu_group_get - Return the group for a device and increment reference
> + * @dev: get the group that this device belongs to
> + *
> + * This function is called by iommu drivers and users to get the group
> + * for the specified device.  If found, the group is returned and the group
> + * reference in incremented, else NULL.
> + */
> +struct iommu_group *iommu_group_get(struct device *dev)
> +{
> +	struct iommu_group *group = dev->iommu_group;
> +
> +	if (group)
> +		kobject_get(group->devices_kobj);
> +
> +	return group;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_get);
> +
> +/**
> + * iommu_group_put - Decrement group reference
> + * @group: the group to use
> + *
> + * This function is called by iommu drivers and users to release the
> + * iommu group.  Once the reference count is zero, the group is released.
> + */
> +void iommu_group_put(struct iommu_group *group)
> +{
> +	if (group)
> +		kobject_put(group->devices_kobj);
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_put);
> +
> +/**
> + * iommu_group_register_notifier - Register a notifier for group changes
> + * @group: the group to watch
> + * @nb: notifier block to signal
> + *
> + * This function allows iommu group users to track changes in a group.
> + * See include/linux/iommu.h for actions sent via this notifier.  Caller
> + * should hold a reference to the group throughout notifier registration.
> + */
> +int iommu_group_register_notifier(struct iommu_group *group,
> +				  struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&group->notifier, nb);
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_register_notifier);
> +
> +/**
> + * iommu_group_unregister_notifier - Unregister a notifier
> + * @group: the group to watch
> + * @nb: notifier block to signal
> + *
> + * Unregister a previously registered group notifier block.
> + */
> +int iommu_group_unregister_notifier(struct iommu_group *group,
> +				    struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_unregister(&group->notifier, nb);
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_unregister_notifier);
> +
> +/**
> + * iommu_group_id - Return ID for a group
> + * @group: the group to ID
> + *
> + * Return the unique ID for the group matching the sysfs group number.
> + */
> +int iommu_group_id(struct iommu_group *group)
> +{
> +	return group->id;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_id);
> +
> +static int add_iommu_group(struct device *dev, void *data)
> +{
> +	struct iommu_ops *ops = data;
> +
> +	if (!ops->add_device)
> +		return -ENODEV;
> +
> +	WARN_ON(dev->iommu_group);
> +
> +	ops->add_device(dev);
> +
> +	return 0;
> +}
> +
> +static int iommu_bus_notifier(struct notifier_block *nb,
> +			      unsigned long action, void *data)
>  {
>  	struct device *dev = data;
> +	struct iommu_ops *ops = dev->bus->iommu_ops;
> +	struct iommu_group *group;
> +	unsigned long group_action = 0;
> +
> +	/*
> +	 * ADD/DEL call into iommu driver ops if provided, which may
> +	 * result in ADD/DEL notifiers to group->notifier
> +	 */
> +	if (action == BUS_NOTIFY_ADD_DEVICE) {
> +		if (ops->add_device)
> +			return ops->add_device(dev);
> +	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> +		if (ops->remove_device && dev->iommu_group) {
> +			ops->remove_device(dev);
> +			return 0;
> +		}
> +	}
>  
> -	if (action == BUS_NOTIFY_ADD_DEVICE)
> -		return add_iommu_group(dev, NULL);
> -	else if (action == BUS_NOTIFY_DEL_DEVICE)
> -		return remove_iommu_group(dev);
> +	/*
> +	 * Remaining BUS_NOTIFYs get filtered and republished to the
> +	 * group, if anyone is listening
> +	 */
> +	group = iommu_group_get(dev);
> +	if (!group)
> +		return 0;
>  
> +	switch (action) {
> +	case BUS_NOTIFY_BIND_DRIVER:
> +		group_action = IOMMU_GROUP_NOTIFY_BIND_DRIVER;
> +		break;
> +	case BUS_NOTIFY_BOUND_DRIVER:
> +		group_action = IOMMU_GROUP_NOTIFY_BOUND_DRIVER;
> +		break;
> +	case BUS_NOTIFY_UNBIND_DRIVER:
> +		group_action = IOMMU_GROUP_NOTIFY_UNBIND_DRIVER;
> +		break;
> +	case BUS_NOTIFY_UNBOUND_DRIVER:
> +		group_action = IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER;
> +		break;
> +	}
> +
> +	if (group_action)
> +		blocking_notifier_call_chain(&group->notifier,
> +					     group_action, dev);
> +
> +	iommu_group_put(group);
>  	return 0;
>  }
>
> -static struct notifier_block iommu_device_nb = {
> -	.notifier_call = iommu_device_notifier,
> +static struct notifier_block iommu_bus_nb = {
> +	.notifier_call = iommu_bus_notifier,
>  };
>  
>  static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
>  {
> -	bus_register_notifier(bus, &iommu_device_nb);
> -	bus_for_each_dev(bus, NULL, NULL, add_iommu_group);
> +	bus_register_notifier(bus, &iommu_bus_nb);
> +	bus_for_each_dev(bus, NULL, ops, add_iommu_group);
>  }

So if I understand correctly this is a rework of a piece of
infrastructure that powerpc doesn't use today, which uses the existing
"iommu_ops" to automatically signal the iommu of added/removed devices,
right ?

Do we need to warn somewhere that the above code is racy vs. concurrent
hotplug and thus might end up adding a device twice ? (It's up to
iommu->add_device implementation to then ensure it doesn't mess up I
assume).

>  /**
> @@ -192,6 +667,45 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(iommu_detach_device);
>  
> +/*
> + * IOMMU groups are really the natrual working unit of the IOMMU, but
> + * the IOMMU API works on domains and devices.  Bridge that gap by
> + * iterating over the devices in a group.  Ideally we'd have a single
> + * device which represents the requestor ID of the group, but we also
> + * allow IOMMU drivers to create policy defined minimum sets, where
> + * the physical hardware may be able to distiguish members, but we
> + * wish to group them at a higher level (ex. untrusted multi-function
> + * PCI devices).  Thus we attach each device.
> + */
> +static int iommu_group_do_attach_device(struct device *dev, void *data)
> +{
> +	struct iommu_domain *domain = data;
> +
> +	return iommu_attach_device(domain, dev);
> +}
> +
> +int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
> +{
> +	return iommu_group_for_each_dev(group, domain,
> +					iommu_group_do_attach_device);
> +}
> +EXPORT_SYMBOL_GPL(iommu_attach_group);
> +
> +static int iommu_group_do_detach_device(struct device *dev, void *data)
> +{
> +	struct iommu_domain *domain = data;
> +
> +	iommu_detach_device(domain, dev);
> +
> +	return 0;
> +}
> +
> +void iommu_detach_group(struct iommu_domain *domain, struct iommu_group *group)
> +{
> +	iommu_group_for_each_dev(group, domain, iommu_group_do_detach_device);
> +}
> +EXPORT_SYMBOL_GPL(iommu_detach_group);
> +

So as you probably are aware by now, we have a 1:1 group/domain
relationship on power (and don't implement the iommu API today) but I
have no objection with the API, I'll have to check how Alexey hooked our
code up (I haven't had a chance to look at it just yet).

>  phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
>  			       unsigned long iova)
>  {
> @@ -336,11 +850,15 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
>  }
>  EXPORT_SYMBOL_GPL(iommu_unmap);
>  
> -int iommu_device_group(struct device *dev, unsigned int *groupid)
> +static int __init iommu_init(void)
>  {
> -	if (iommu_present(dev->bus) && dev->bus->iommu_ops->device_group)
> -		return dev->bus->iommu_ops->device_group(dev, groupid);
> +	iommu_group_kset = kset_create_and_add("iommu_groups",
> +					       NULL, kernel_kobj);
> +	ida_init(&iommu_group_ida);
> +	mutex_init(&iommu_group_mutex);
>  
> -	return -ENODEV;
> +	BUG_ON(!iommu_group_kset);
> +
> +	return 0;
>  }
> -EXPORT_SYMBOL_GPL(iommu_device_group);
> +subsys_initcall(iommu_init);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 450293f..a71df92 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -26,6 +26,7 @@
>  #define IOMMU_CACHE	(4) /* DMA cache coherency */
>  
>  struct iommu_ops;
> +struct iommu_group;
>  struct bus_type;
>  struct device;
>  struct iommu_domain;
> @@ -60,6 +61,8 @@ struct iommu_domain {
>   * @iova_to_phys: translate iova to physical address
>   * @domain_has_cap: domain capabilities query
>   * @commit: commit iommu domain
> + * @add_device: add device to iommu grouping
> + * @remove_device: remove device from iommu grouping
>   * @pgsize_bitmap: bitmap of supported page sizes
>   */
>  struct iommu_ops {
> @@ -75,10 +78,18 @@ struct iommu_ops {
>  				    unsigned long iova);
>  	int (*domain_has_cap)(struct iommu_domain *domain,
>  			      unsigned long cap);
> -	int (*device_group)(struct device *dev, unsigned int *groupid);
> +	int (*add_device)(struct device *dev);
> +	void (*remove_device)(struct device *dev);
>  	unsigned long pgsize_bitmap;
>  };
>  
> +#define IOMMU_GROUP_NOTIFY_ADD_DEVICE		1 /* Device added */
> +#define IOMMU_GROUP_NOTIFY_DEL_DEVICE		2 /* Pre Device removed */
> +#define IOMMU_GROUP_NOTIFY_BIND_DRIVER		3 /* Pre Driver bind */
> +#define IOMMU_GROUP_NOTIFY_BOUND_DRIVER		4 /* Post Driver bind */
> +#define IOMMU_GROUP_NOTIFY_UNBIND_DRIVER	5 /* Pre Driver unbind */
> +#define IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER	6 /* Post Driver unbind */
> +
>  extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
>  extern bool iommu_present(struct bus_type *bus);
>  extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
> @@ -97,7 +108,29 @@ extern int iommu_domain_has_cap(struct iommu_domain *domain,
>  				unsigned long cap);
>  extern void iommu_set_fault_handler(struct iommu_domain *domain,
>  			iommu_fault_handler_t handler, void *token);
> -extern int iommu_device_group(struct device *dev, unsigned int *groupid);
> +
> +extern int iommu_attach_group(struct iommu_domain *domain,
> +			      struct iommu_group *group);
> +extern void iommu_detach_group(struct iommu_domain *domain,
> +			       struct iommu_group *group);
> +extern struct iommu_group *iommu_group_alloc(void);
> +extern void *iommu_group_get_iommudata(struct iommu_group *group);
> +extern void iommu_group_set_iommudata(struct iommu_group *group,
> +				      void *iommu_data,
> +				      void (*release)(void *iommu_data));
> +extern int iommu_group_set_name(struct iommu_group *group, const char *name);
> +extern int iommu_group_add_device(struct iommu_group *group,
> +				  struct device *dev);
> +extern void iommu_group_remove_device(struct device *dev);
> +extern int iommu_group_for_each_dev(struct iommu_group *group, void *data,
> +				    int (*fn)(struct device *, void *));
> +extern struct iommu_group *iommu_group_get(struct device *dev);
> +extern void iommu_group_put(struct iommu_group *group);
> +extern int iommu_group_register_notifier(struct iommu_group *group,
> +					 struct notifier_block *nb);
> +extern int iommu_group_unregister_notifier(struct iommu_group *group,
> +					   struct notifier_block *nb);
> +extern int iommu_group_id(struct iommu_group *group);
>  
>  /**
>   * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
> @@ -142,6 +175,7 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
>  #else /* CONFIG_IOMMU_API */
>  
>  struct iommu_ops {};
> +struct iommu_group {};
>  
>  static inline bool iommu_present(struct bus_type *bus)
>  {
> @@ -197,11 +231,75 @@ static inline void iommu_set_fault_handler(struct iommu_domain *domain,
>  {
>  }
>  
> -static inline int iommu_device_group(struct device *dev, unsigned int *groupid)
> +int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
> +{
> +	return -ENODEV;
> +}
> +
> +void iommu_detach_group(struct iommu_domain *domain, struct iommu_group *group)
> +{
> +}
> +
> +struct iommu_group *iommu_group_alloc(void)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +void *iommu_group_get_iommudata(struct iommu_group *group)
> +{
> +	return NULL;
> +}
> +
> +void iommu_group_set_iommudata(struct iommu_group *group, void *iommu_data,
> +			       void (*release)(void *iommu_data))
> +{
> +}
> +
> +int iommu_group_set_name(struct iommu_group *group, const char *name)
> +{
> +	return -ENODEV;
> +}
> +
> +int iommu_group_add_device(struct iommu_group *group, struct device *dev)
> +{
> +	return -ENODEV;
> +}
> +
> +void iommu_group_remove_device(struct device *dev)
> +{
> +}
> +
> +int iommu_group_for_each_dev(struct iommu_group *group, void *data,
> +			     int (*fn)(struct device *, void *))
> +{
> +	return -ENODEV;
> +}
> +
> +struct iommu_group *iommu_group_get(struct device *dev)
> +{
> +	return NULL;
> +}
> +
> +void iommu_group_put(struct iommu_group *group)
> +{
> +}
> +
> +int iommu_group_register_notifier(struct iommu_group *group,
> +				  struct notifier_block *nb)
>  {
>  	return -ENODEV;
>  }
>  
> +int iommu_group_unregister_notifier(struct iommu_group *group,
> +				    struct notifier_block *nb)
> +{
> +	return 0;
> +}
> +
> +int iommu_group_id(struct iommu_group *group)
> +{
> +	return -ENODEV;
> +}
>  #endif /* CONFIG_IOMMU_API */
>  
>  #endif /* __LINUX_IOMMU_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


