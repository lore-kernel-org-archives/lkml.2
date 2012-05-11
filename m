Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab2EKW5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759716Ab2EKW4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:56:49 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 07/13] vfio: VFIO core
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, alex.williamson@redhat.com
Date: Fri, 11 May 2012 16:56:16 -0600
Message-ID: <20120511225615.30496.18787.stgit@bling.home>
In-Reply-To: <20120511222148.30496.68571.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO is a secure user level driver for use with both virtual machines
and user level drivers.  VFIO makes use of IOMMU groups to ensure the
isolation of devices in use, allowing unprivileged user access.  It's
intended that VFIO will replace KVM device assignment and UIO drivers
(in cases where the target platform includes a sufficiently capable
IOMMU).

New in this version of VFIO is support for IOMMU groups managed
through the IOMMU core as well as a rework of the API, removing the
group merge interface.  We now go back to a model more similar to
original VFIO with UIOMMU support where the file descriptor obtained
from /dev/vfio/vfio allows access to the IOMMU, but only after a
group is added, avoiding the previous privilege issues with this type
of model.  IOMMU support is also now fully modular as IOMMUs have
vastly different interface requirements on different platforms.  VFIO
users are able to query and initialize the IOMMU model of their
choice.

Please see the follow-on Documentation commit for further description
and usage example.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/ioctl/ioctl-number.txt |    1 
 MAINTAINERS                          |    8 
 drivers/Kconfig                      |    2 
 drivers/Makefile                     |    1 
 drivers/vfio/Kconfig                 |    8 
 drivers/vfio/Makefile                |    1 
 drivers/vfio/vfio.c                  | 1399 ++++++++++++++++++++++++++++++++++
 include/linux/vfio.h                 |  364 +++++++++
 8 files changed, 1784 insertions(+), 0 deletions(-)
 create mode 100644 drivers/vfio/Kconfig
 create mode 100644 drivers/vfio/Makefile
 create mode 100644 drivers/vfio/vfio.c
 create mode 100644 include/linux/vfio.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index e34b531..111e30a 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -88,6 +88,7 @@ Code  Seq#(hex)	Include File		Comments
 		and kernel/power/user.c
 '8'	all				SNP8023 advanced NIC card
 					<mailto:mcr@solidum.com>
+';'	64-6F	linux/vfio.h
 '@'	00-0F	linux/radeonfb.h	conflict!
 '@'	00-0F	drivers/video/aty/aty128fb.c	conflict!
 'A'	00-1F	linux/apm_bios.h	conflict!
diff --git a/MAINTAINERS b/MAINTAINERS
index de4e280..48e7600 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7227,6 +7227,14 @@ S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
 
+VFIO DRIVER
+M:	Alex Williamson <alex.williamson@redhat.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	Documentation/vfio.txt
+F:	drivers/vfio/
+F:	include/linux/vfio.h
+
 VIDEOBUF2 FRAMEWORK
 M:	Pawel Osciak <pawel@osciak.com>
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
diff --git a/drivers/Kconfig b/drivers/Kconfig
index d236aef..46eb115 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -112,6 +112,8 @@ source "drivers/auxdisplay/Kconfig"
 
 source "drivers/uio/Kconfig"
 
+source "drivers/vfio/Kconfig"
+
 source "drivers/vlynq/Kconfig"
 
 source "drivers/virtio/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 95952c8..fe1880a 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
 obj-y				+= firewire/
 obj-$(CONFIG_UIO)		+= uio/
+obj-$(CONFIG_VFIO)		+= vfio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
new file mode 100644
index 0000000..9acb1e7
--- /dev/null
+++ b/drivers/vfio/Kconfig
@@ -0,0 +1,8 @@
+menuconfig VFIO
+	tristate "VFIO Non-Privileged userspace driver framework"
+	depends on IOMMU_API
+	help
+	  VFIO provides a framework for secure userspace device drivers.
+	  See Documentation/vfio.txt for more details.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
new file mode 100644
index 0000000..7500a67
--- /dev/null
+++ b/drivers/vfio/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VFIO) += vfio.o
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
new file mode 100644
index 0000000..af0e4f8
--- /dev/null
+++ b/drivers/vfio/vfio.c
@@ -0,0 +1,1399 @@
+/*
+ * VFIO core
+ *
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Derived from original vfio:
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ */
+
+#include <linux/cdev.h>
+#include <linux/compat.h>
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/anon_inodes.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/iommu.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/wait.h>
+
+#define DRIVER_VERSION	"0.3"
+#define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC	"VFIO - User Level meta-driver"
+
+static struct vfio {
+	struct class			*class;
+	struct list_head		iommu_drivers_list;
+	struct mutex			iommu_drivers_lock;
+	struct list_head		group_list;
+	struct idr			group_idr;
+	struct mutex			group_lock;
+	struct cdev			group_cdev;
+	struct device			*dev;
+	dev_t				devt;
+	struct cdev			cdev;
+	wait_queue_head_t		release_q;
+} vfio;
+
+struct vfio_iommu_driver {
+	const struct vfio_iommu_driver_ops	*ops;
+	struct list_head			vfio_next;
+};
+
+struct vfio_container {
+	struct kref			kref;
+	struct list_head		group_list;
+	struct mutex			group_lock;
+	struct vfio_iommu_driver	*iommu_driver;
+	void				*iommu_data;
+};
+
+struct vfio_group {
+	struct kref			kref;
+	int				minor;
+	atomic_t			container_users;
+	struct iommu_group		*iommu_group;
+	struct vfio_container		*container;
+	struct list_head		device_list;
+	struct mutex			device_lock;
+	struct device			*dev;
+	struct notifier_block		nb;
+	struct list_head		vfio_next;
+	struct list_head		container_next;
+};
+
+struct vfio_device {
+	struct kref			kref;
+	struct device			*dev;
+	const struct vfio_device_ops	*ops;
+	struct vfio_group		*group;
+	struct list_head		group_next;
+	void				*device_data;
+};
+
+/**
+ * IOMMU driver registration
+ */
+int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops)
+{
+	struct vfio_iommu_driver *driver, *tmp;
+
+	driver = kzalloc(sizeof(*driver), GFP_KERNEL);
+	if (!driver)
+		return -ENOMEM;
+
+	driver->ops = ops;
+
+	mutex_lock(&vfio.iommu_drivers_lock);
+
+	/* Check for duplicates */
+	list_for_each_entry(tmp, &vfio.iommu_drivers_list, vfio_next) {
+		if (tmp->ops == ops) {
+			mutex_unlock(&vfio.iommu_drivers_lock);
+			kfree(driver);
+			return -EINVAL;
+		}
+	}
+
+	list_add(&driver->vfio_next, &vfio.iommu_drivers_list);
+
+	mutex_unlock(&vfio.iommu_drivers_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_register_iommu_driver);
+
+void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
+{
+	struct vfio_iommu_driver *driver;
+
+	mutex_lock(&vfio.iommu_drivers_lock);
+	list_for_each_entry(driver, &vfio.iommu_drivers_list, vfio_next) {
+		if (driver->ops == ops) {
+			list_del(&driver->vfio_next);
+			mutex_unlock(&vfio.iommu_drivers_lock);
+			kfree(driver);
+			return;
+		}
+	}
+	mutex_unlock(&vfio.iommu_drivers_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
+
+/**
+ * Group minor allocation/free - both called with vfio.group_lock held
+ */
+static int vfio_alloc_group_minor(struct vfio_group *group)
+{
+	int ret, minor;
+
+again:
+	if (unlikely(idr_pre_get(&vfio.group_idr, GFP_KERNEL) == 0))
+		return -ENOMEM;
+
+	/* index 0 is used by /dev/vfio/vfio */
+	ret = idr_get_new_above(&vfio.group_idr, group, 1, &minor);
+	if (ret == -EAGAIN)
+		goto again;
+	if (ret || minor > MINORMASK) {
+		if (minor > MINORMASK)
+			idr_remove(&vfio.group_idr, minor);
+		return -ENOSPC;
+	}
+
+	return minor;
+}
+
+static void vfio_free_group_minor(int minor)
+{
+	idr_remove(&vfio.group_idr, minor);
+}
+
+static int vfio_iommu_group_notifier(struct notifier_block *nb,
+				     unsigned long action, void *data);
+static void vfio_group_get(struct vfio_group *group);
+
+/**
+ * Container objects - containers are created when /dev/vfio/vfio is
+ * opened, but their lifecycle extends until the last user is done, so
+ * it's freed via kref.  Must support container/group/device being
+ * closed in any order.
+ */
+static void vfio_container_get(struct vfio_container *container)
+{
+	kref_get(&container->kref);
+}
+
+static void vfio_container_release(struct kref *kref)
+{
+	struct vfio_container *container;
+	container = container_of(kref, struct vfio_container, kref);
+
+	kfree(container);
+}
+
+static void vfio_container_put(struct vfio_container *container)
+{
+	kref_put(&container->kref, vfio_container_release);
+}
+
+/**
+ * Group objects - create, release, get, put, search
+ */
+static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group, *tmp;
+	struct device *dev;
+	int ret, minor;
+
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&group->kref);
+	INIT_LIST_HEAD(&group->device_list);
+	mutex_init(&group->device_lock);
+	atomic_set(&group->container_users, 0);
+	group->iommu_group = iommu_group;
+
+	group->nb.notifier_call = vfio_iommu_group_notifier;
+
+	/*
+	 * blocking notifiers acquire a rwsem around registering and hold
+	 * it around callback.  Therefore, need to register outside of
+	 * vfio.group_lock to avoid A-B/B-A contention.  Our callback won't
+	 * do anything unless it can find the group in vfio.group_list, so
+	 * no harm in registering early.
+	 */
+	ret = iommu_group_register_notifier(iommu_group, &group->nb);
+	if (ret) {
+		kfree(group);
+		return ERR_PTR(ret);
+	}
+
+	mutex_lock(&vfio.group_lock);
+
+	minor = vfio_alloc_group_minor(group);
+	if (minor < 0) {
+		mutex_unlock(&vfio.group_lock);
+		kfree(group);
+		return ERR_PTR(minor);
+	}
+
+	/* Did we race creating this group? */
+	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
+		if (tmp->iommu_group == iommu_group) {
+			vfio_group_get(tmp);
+			vfio_free_group_minor(minor);
+			mutex_unlock(&vfio.group_lock);
+			kfree(group);
+			return tmp;
+		}
+	}
+
+	dev = device_create(vfio.class, NULL, MKDEV(MAJOR(vfio.devt), minor),
+			    group, "%d", iommu_group_id(iommu_group));
+	if (IS_ERR(dev)) {
+		vfio_free_group_minor(minor);
+		mutex_unlock(&vfio.group_lock);
+		kfree(group);
+		return (struct vfio_group *)dev; /* ERR_PTR */
+	}
+
+	group->minor = minor;
+	group->dev = dev;
+
+	list_add(&group->vfio_next, &vfio.group_list);
+
+	mutex_unlock(&vfio.group_lock);
+
+	return group;
+}
+
+static void vfio_group_release(struct kref *kref)
+{
+	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
+
+	WARN_ON(!list_empty(&group->device_list));
+
+	device_destroy(vfio.class, MKDEV(MAJOR(vfio.devt), group->minor));
+	list_del(&group->vfio_next);
+	vfio_free_group_minor(group->minor);
+
+	mutex_unlock(&vfio.group_lock);
+
+	/*
+	 * Unregister outside of lock.  A spurious callback is harmless now
+	 * that the group is no longer in vfio.group_list.
+	 */
+	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
+
+	kfree(group);
+}
+
+static void vfio_group_put(struct vfio_group *group)
+{
+	mutex_lock(&vfio.group_lock);
+	/*
+	 * Release needs to unlock to unregister the notifier, so only
+	 * unlock if not released.
+	 */
+	if (!kref_put(&group->kref, vfio_group_release))
+		mutex_unlock(&vfio.group_lock);
+}
+
+/* Assume group_lock or group reference is held */
+static void vfio_group_get(struct vfio_group *group)
+{
+	kref_get(&group->kref);
+}
+
+/*
+ * Not really a try as we will sleep for mutex, but we need to make
+ * sure the group pointer is valid under lock and get a reference.
+ */
+static struct vfio_group *vfio_group_try_get(struct vfio_group *group)
+{
+	struct vfio_group *target = group;
+
+	mutex_lock(&vfio.group_lock);
+	list_for_each_entry(group, &vfio.group_list, vfio_next) {
+		if (group == target) {
+			vfio_group_get(group);
+			mutex_unlock(&vfio.group_lock);
+			return group;
+		}
+	}
+	mutex_unlock(&vfio.group_lock);
+
+	return NULL;
+}
+
+static
+struct vfio_group *vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group;
+
+	mutex_lock(&vfio.group_lock);
+	list_for_each_entry(group, &vfio.group_list, vfio_next) {
+		if (group->iommu_group == iommu_group) {
+			vfio_group_get(group);
+			mutex_unlock(&vfio.group_lock);
+			return group;
+		}
+	}
+	mutex_unlock(&vfio.group_lock);
+
+	return NULL;
+}
+
+static struct vfio_group *vfio_group_get_from_minor(int minor)
+{
+	struct vfio_group *group;
+
+	mutex_lock(&vfio.group_lock);
+	group = idr_find(&vfio.group_idr, minor);
+	if (!group) {
+		mutex_unlock(&vfio.group_lock);
+		return NULL;
+	}
+	vfio_group_get(group);
+	mutex_unlock(&vfio.group_lock);
+
+	return group;
+}
+
+/**
+ * Device objects - create, release, get, put, search
+ */
+static
+struct vfio_device *vfio_group_create_device(struct vfio_group *group,
+					     struct device *dev,
+					     const struct vfio_device_ops *ops,
+					     void *device_data)
+{
+	struct vfio_device *device;
+	int ret;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&device->kref);
+	device->dev = dev;
+	device->group = group;
+	device->ops = ops;
+	device->device_data = device_data;
+
+	ret = dev_set_drvdata(dev, device);
+	if (ret) {
+		kfree(device);
+		return ERR_PTR(ret);
+	}
+
+	/* No need to get group_lock, caller has group reference */
+	vfio_group_get(group);
+
+	mutex_lock(&group->device_lock);
+	list_add(&device->group_next, &group->device_list);
+	mutex_unlock(&group->device_lock);
+
+	return device;
+}
+
+static void vfio_device_release(struct kref *kref)
+{
+	struct vfio_device *device = container_of(kref,
+						  struct vfio_device, kref);
+	struct vfio_group *group = device->group;
+
+	mutex_lock(&group->device_lock);
+	list_del(&device->group_next);
+	mutex_unlock(&group->device_lock);
+
+	dev_set_drvdata(device->dev, NULL);
+
+	kfree(device);
+
+	/* vfio_del_group_dev may be waiting for this device */
+	wake_up(&vfio.release_q);
+}
+
+/* Device reference always implies a group reference */
+static void vfio_device_put(struct vfio_device *device)
+{
+	kref_put(&device->kref, vfio_device_release);
+	vfio_group_put(device->group);
+}
+
+static void vfio_device_get(struct vfio_device *device)
+{
+	vfio_group_get(device->group);
+	kref_get(&device->kref);
+}
+
+static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
+						 struct device *dev)
+{
+	struct vfio_device *device;
+
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(device, &group->device_list, group_next) {
+		if (device->dev == dev) {
+			vfio_device_get(device);
+			mutex_unlock(&group->device_lock);
+			return device;
+		}
+	}
+	mutex_unlock(&group->device_lock);
+	return NULL;
+}
+
+/**
+ * Async device support
+ */
+static int vfio_group_nb_add_dev(struct vfio_group *group, struct device *dev)
+{
+	struct vfio_device *device;
+
+	/* Do we already know about it?  We shouldn't */
+	device = vfio_group_get_device(group, dev);
+	if (WARN_ON_ONCE(device)) {
+		vfio_device_put(device);
+		return 0;
+	}
+
+	/* Nothing to do for idle groups */
+	if (!atomic_read(&group->container_users))
+		return 0;
+
+	/* TODO Prevent device auto probing */
+	WARN("Device %s added to live group %d!\n", dev_name(dev),
+	     iommu_group_id(group->iommu_group));
+
+	return 0;
+}
+
+static int vfio_group_nb_del_dev(struct vfio_group *group, struct device *dev)
+{
+	struct vfio_device *device;
+
+	/*
+	 * Expect to fall out here.  If a device was in use, it would
+	 * have been bound to a vfio sub-driver, which would have blocked
+	 * in .remove at vfio_del_group_dev.  Sanity check that we no
+	 * longer track the device, so it's safe to remove.
+	 */
+	device = vfio_group_get_device(group, dev);
+	if (likely(!device))
+		return 0;
+
+	WARN("Device %s removed from live group %d!\n", dev_name(dev),
+	     iommu_group_id(group->iommu_group));
+
+	vfio_device_put(device);
+	return 0;
+}
+
+static int vfio_group_nb_verify(struct vfio_group *group, struct device *dev)
+{
+	struct vfio_device *device;
+
+	/* We don't care what happens when the group isn't in use */
+	if (!atomic_read(&group->container_users))
+		return 0;
+
+	device = vfio_group_get_device(group, dev);
+	if (device)
+		vfio_device_put(device);
+
+	return device ? 0 : -EINVAL;
+}
+
+static int vfio_iommu_group_notifier(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct vfio_group *group = container_of(nb, struct vfio_group, nb);
+	struct device *dev = data;
+
+	/*
+	 * Need to go through a group_lock lookup to get a reference or
+	 * we risk racing a group being removed.  Leave a WARN_ON for
+	 * debuging, but if the group no longer exists, a spurious notify
+	 * is harmless.
+	 */
+	group = vfio_group_try_get(group);
+	if (WARN_ON(!group))
+		return NOTIFY_OK;
+
+	switch (action) {
+	case IOMMU_GROUP_NOTIFY_ADD_DEVICE:
+		vfio_group_nb_add_dev(group, dev);
+		break;
+	case IOMMU_GROUP_NOTIFY_DEL_DEVICE:
+		vfio_group_nb_del_dev(group, dev);
+		break;
+	case IOMMU_GROUP_NOTIFY_BIND_DRIVER:
+		printk(KERN_DEBUG
+		       "%s: Device %s, group %d binding to driver\n", __func__,
+		      dev_name(dev), iommu_group_id(group->iommu_group));
+		break;
+	case IOMMU_GROUP_NOTIFY_BOUND_DRIVER:
+		printk(KERN_DEBUG
+		       "%s: Device %s, group %d bound to driver %s\n", __func__,
+		       dev_name(dev), iommu_group_id(group->iommu_group),
+		       dev->driver->name);
+		BUG_ON(vfio_group_nb_verify(group, dev));
+		break;
+	case IOMMU_GROUP_NOTIFY_UNBIND_DRIVER:
+		printk(KERN_DEBUG
+		       "%s: Device %s, group %d unbinding from driver %s\n",
+		       __func__, dev_name(dev),
+		       iommu_group_id(group->iommu_group), dev->driver->name);
+		break;
+	case IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER:
+		printk(KERN_DEBUG
+		       "%s: Device %s, group %d unbound from driver\n",
+		       __func__, dev_name(dev),
+		       iommu_group_id(group->iommu_group));
+		/*
+		 * XXX An unbound device in a live group is ok, but we'd
+		 * really like to avoid the above BUG_ON by preventing other
+		 * drivers from binding to it.  Once that occurs, we have to
+		 * stop the system to maintain isolation.  At a minimum, we'd
+		 * want a toggle to disable driver auto probe for this device.
+		 */
+		break;
+	}
+
+	vfio_group_put(group);
+	return NOTIFY_OK;
+}
+
+/**
+ * VFIO driver API
+ */
+int vfio_add_group_dev(struct device *dev,
+		       const struct vfio_device_ops *ops, void *device_data)
+{
+	struct iommu_group *iommu_group;
+	struct vfio_group *group;
+	struct vfio_device *device;
+
+	iommu_group = iommu_group_get(dev);
+	if (!iommu_group)
+		return -EINVAL;
+
+	group = vfio_group_get_from_iommu(iommu_group);
+	if (!group) {
+		group = vfio_create_group(iommu_group);
+		if (IS_ERR(group)) {
+			iommu_group_put(iommu_group);
+			return PTR_ERR(group);
+		}
+	}
+
+	device = vfio_group_get_device(group, dev);
+	if (device) {
+		WARN(1, "Device %s already exists on group %d\n",
+		     dev_name(dev), iommu_group_id(iommu_group));
+		vfio_device_put(device);
+		vfio_group_put(group);
+		iommu_group_put(iommu_group);
+		return -EBUSY;
+	}
+
+	device = vfio_group_create_device(group, dev, ops, device_data);
+	if (IS_ERR(device)) {
+		vfio_group_put(group);
+		iommu_group_put(iommu_group);
+		return PTR_ERR(device);
+	}
+
+	/*
+	 * Added device holds reference to iommu_group and vfio_device
+	 * (which in turn holds reference to vfio_group).  Drop extra
+	 * group reference used while acquiring device.
+	 */
+	vfio_group_put(group);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_add_group_dev);
+
+/* Test whether a struct device is present in our tracking */
+static bool vfio_dev_present(struct device *dev)
+{
+	struct iommu_group *iommu_group;
+	struct vfio_group *group;
+	struct vfio_device *device;
+
+	iommu_group = iommu_group_get(dev);
+	if (!iommu_group)
+		return false;
+
+	group = vfio_group_get_from_iommu(iommu_group);
+	if (!group) {
+		iommu_group_put(iommu_group);
+		return false;
+	}
+
+	device = vfio_group_get_device(group, dev);
+	if (!device) {
+		vfio_group_put(group);
+		iommu_group_put(iommu_group);
+		return false;
+	}
+
+	vfio_device_put(device);
+	vfio_group_put(group);
+	iommu_group_put(iommu_group);
+	return true;
+}
+
+/*
+ * Decrement the device reference count and wait for the device to be
+ * removed.  Open file descriptors for the device... */
+void *vfio_del_group_dev(struct device *dev)
+{
+	struct vfio_device *device = dev_get_drvdata(dev);
+	struct vfio_group *group = device->group;
+	struct iommu_group *iommu_group = group->iommu_group;
+	void *device_data = device->device_data;
+
+	vfio_device_put(device);
+
+	/* TODO send a signal to encourage this to be released */
+	wait_event(vfio.release_q, !vfio_dev_present(dev));
+
+	iommu_group_put(iommu_group);
+
+	return device_data;
+}
+EXPORT_SYMBOL_GPL(vfio_del_group_dev);
+
+/**
+ * VFIO base fd, /dev/vfio/vfio
+ */
+static long vfio_ioctl_check_extension(struct vfio_container *container,
+				       unsigned long arg)
+{
+	struct vfio_iommu_driver *driver = container->iommu_driver;
+	long ret = 0;
+
+	switch (arg) {
+		/* No base extensions yet */
+	default:
+		/*
+		 * If no driver is set, poll all registered drivers for
+		 * extensions and return the first positive result.  If
+		 * a driver is already set, further queries will be passed
+		 * only to that driver.
+		 */
+		if (!driver) {
+			mutex_lock(&vfio.iommu_drivers_lock);
+			list_for_each_entry(driver, &vfio.iommu_drivers_list,
+					    vfio_next) {
+				if (!try_module_get(driver->ops->owner))
+					continue;
+
+				ret = driver->ops->ioctl(NULL,
+							 VFIO_CHECK_EXTENSION,
+							 arg);
+				module_put(driver->ops->owner);
+				if (ret > 0)
+					break;
+			}
+			mutex_unlock(&vfio.iommu_drivers_lock);
+		} else
+			ret = driver->ops->ioctl(container->iommu_data,
+						 VFIO_CHECK_EXTENSION, arg);
+	}
+
+	return ret;
+}
+
+/* hold container->group_lock */
+static int __vfio_container_attach_groups(struct vfio_container *container,
+					  struct vfio_iommu_driver *driver,
+					  void *data)
+{
+	struct vfio_group *group;
+	int ret = -ENODEV;
+
+	list_for_each_entry(group, &container->group_list, container_next) {
+		ret = driver->ops->attach_group(data, group->iommu_group);
+		if (ret)
+			goto unwind;
+	}
+
+	return ret;
+
+unwind:
+	list_for_each_entry_continue_reverse(group, &container->group_list,
+					     container_next) {
+		driver->ops->detach_group(data, group->iommu_group);
+	}
+
+	return ret;
+}
+
+static long vfio_ioctl_set_iommu(struct vfio_container *container,
+				 unsigned long arg)
+{
+	struct vfio_iommu_driver *driver;
+	long ret = -ENODEV;
+
+	mutex_lock(&container->group_lock);
+
+	/*
+	 * The container is designed to be an unprivileged interface while
+	 * the group can be assigned to specific users.  Therefore, only by
+	 * adding a group to a container does the user get the privilege of
+	 * enabling the iommu, which may allocate finite resources.  There
+	 * is no unset_iommu, but by removing all the groups from a container,
+	 * the container is deprivileged and returns to an unset state.
+	 */
+	if (list_empty(&container->group_list) || container->iommu_driver) {
+		mutex_unlock(&container->group_lock);
+		return -EINVAL;
+	}
+
+	mutex_lock(&vfio.iommu_drivers_lock);
+	list_for_each_entry(driver, &vfio.iommu_drivers_list, vfio_next) {
+		void *data;
+
+		if (!try_module_get(driver->ops->owner))
+			continue;
+
+		/*
+		 * The arg magic for SET_IOMMU is the same as CHECK_EXTENSION,
+		 * so test which iommu driver reported support for this
+		 * extension and call open on them.  We also pass them the
+		 * magic, allowing a single driver to support multiple
+		 * interfaces if they'd like.
+		 */
+		if (driver->ops->ioctl(NULL, VFIO_CHECK_EXTENSION, arg) <= 0) {
+			module_put(driver->ops->owner);
+			continue;
+		}
+
+		/* module reference holds the driver we're working on */
+		mutex_unlock(&vfio.iommu_drivers_lock);
+
+		data = driver->ops->open(arg);
+		if (IS_ERR(data)) {
+			ret = PTR_ERR(data);
+			goto skip_drivers_unlock;
+		}
+
+		ret = __vfio_container_attach_groups(container, driver, data);
+		if (!ret) {
+			container->iommu_driver = driver;
+			container->iommu_data = data;
+		} else
+			driver->ops->release(data);
+
+		goto skip_drivers_unlock;
+	}
+
+	mutex_unlock(&vfio.iommu_drivers_lock);
+skip_drivers_unlock:
+	mutex_unlock(&container->group_lock);
+
+	return ret;
+}
+
+static long vfio_fops_unl_ioctl(struct file *filep,
+				unsigned int cmd, unsigned long arg)
+{
+	struct vfio_container *container = filep->private_data;
+	struct vfio_iommu_driver *driver;
+	void *data;
+	long ret = -EINVAL;
+
+	if (!container)
+		return ret;
+
+	driver = container->iommu_driver;
+	data = container->iommu_data;
+
+	switch (cmd) {
+	case VFIO_GET_API_VERSION:
+		ret = VFIO_API_VERSION;
+		break;
+	case VFIO_CHECK_EXTENSION:
+		ret = vfio_ioctl_check_extension(container, arg);
+		break;
+	case VFIO_SET_IOMMU:
+		ret = vfio_ioctl_set_iommu(container, arg);
+		break;
+	default:
+		if (driver) /* passthrough all unrecognized ioctls */
+			ret = driver->ops->ioctl(data, cmd, arg);
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long vfio_fops_compat_ioctl(struct file *filep,
+				   unsigned int cmd, unsigned long arg)
+{
+	arg = (unsigned long)compat_ptr(arg);
+	return vfio_fops_unl_ioctl(filep, cmd, arg);
+}
+#endif	/* CONFIG_COMPAT */
+
+static int vfio_fops_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_container *container;
+
+	container = kzalloc(sizeof(*container), GFP_KERNEL);
+	if (!container)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&container->group_list);
+	mutex_init(&container->group_lock);
+	kref_init(&container->kref);
+
+	filep->private_data = container;
+
+	return 0;
+}
+
+static int vfio_fops_release(struct inode *inode, struct file *filep)
+{
+	struct vfio_container *container = filep->private_data;
+
+	filep->private_data = NULL;
+
+	vfio_container_put(container);
+
+	return 0;
+}
+
+/*
+ * Once an iommu driver is set, we optionally pass read/write/mmap
+ * on to the driver, allowing management interfaces beyond ioctl.
+ */
+static ssize_t vfio_fops_read(struct file *filep, char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct vfio_container *container = filep->private_data;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
+
+	if (unlikely(!driver || !driver->ops->read))
+		return -EINVAL;
+
+	return driver->ops->read(container->iommu_data, buf, count, ppos);
+}
+
+static ssize_t vfio_fops_write(struct file *filep, const char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct vfio_container *container = filep->private_data;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
+
+	if (unlikely(!driver || !driver->ops->write))
+		return -EINVAL;
+
+	return driver->ops->write(container->iommu_data, buf, count, ppos);
+}
+
+static int vfio_fops_mmap(struct file *filep, struct vm_area_struct *vma)
+{
+	struct vfio_container *container = filep->private_data;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
+
+	if (unlikely(!driver || !driver->ops->mmap))
+		return -EINVAL;
+
+	return driver->ops->mmap(container->iommu_data, vma);
+}
+
+static const struct file_operations vfio_fops = {
+	.owner		= THIS_MODULE,
+	.open		= vfio_fops_open,
+	.release	= vfio_fops_release,
+	.read		= vfio_fops_read,
+	.write		= vfio_fops_write,
+	.unlocked_ioctl	= vfio_fops_unl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= vfio_fops_compat_ioctl,
+#endif
+	.mmap		= vfio_fops_mmap,
+};
+
+/**
+ * VFIO Group fd, /dev/vfio/$GROUP
+ */
+static void __vfio_group_unset_container(struct vfio_group *group)
+{
+	struct vfio_container *container = group->container;
+	struct vfio_iommu_driver *driver;
+
+	mutex_lock(&container->group_lock);
+
+	driver = container->iommu_driver;
+	if (driver)
+		driver->ops->detach_group(container->iommu_data,
+					  group->iommu_group);
+
+	group->container = NULL;
+	list_del(&group->container_next);
+
+	/* Detaching the last group deprivileges a container, remove iommu */
+	if (driver && list_empty(&container->group_list)) {
+		driver->ops->release(container->iommu_data);
+		module_put(driver->ops->owner);
+		container->iommu_driver = NULL;
+		container->iommu_data = NULL;
+	}
+
+	mutex_unlock(&container->group_lock);
+
+	vfio_container_put(container);
+}
+
+/*
+ * VFIO_GROUP_UNSET_CONTAINER should fail if there are other users or
+ * if there was no container to unset.  Since the ioctl is called on
+ * the group, we know that still exists, therefore the only valid
+ * transition here is 1->0.
+ */
+static int vfio_group_unset_container(struct vfio_group *group)
+{
+	int users = atomic_cmpxchg(&group->container_users, 1, 0);
+
+	if (!users)
+		return -EINVAL;
+	if (users != 1)
+		return -EBUSY;
+
+	__vfio_group_unset_container(group);
+
+	return 0;
+}
+
+/*
+ * When removing container users, anything that removes the last user
+ * implicitly removes the group from the container.  That is, if the
+ * group file descriptor is closed, as well as any device file descriptors,
+ * the group is free.
+ */
+static void vfio_group_try_dissolve_container(struct vfio_group *group)
+{
+	if (0 == atomic_dec_if_positive(&group->container_users))
+		__vfio_group_unset_container(group);
+}
+
+static int vfio_group_set_container(struct vfio_group *group, int container_fd)
+{
+	struct file *filep;
+	struct vfio_container *container;
+	struct vfio_iommu_driver *driver;
+	int ret = 0;
+
+	if (atomic_read(&group->container_users))
+		return -EINVAL;
+
+	filep = fget(container_fd);
+	if (!filep)
+		return -EBADF;
+
+	/* Sanity check, is this really our fd? */
+	if (filep->f_op != &vfio_fops) {
+		fput(filep);
+		return -EINVAL;
+	}
+
+	container = filep->private_data;
+	WARN_ON(!container); /* fget ensures we don't race vfio_release */
+
+	mutex_lock(&container->group_lock);
+
+	driver = container->iommu_driver;
+	if (driver) {
+		ret = driver->ops->attach_group(container->iommu_data,
+						group->iommu_group);
+		if (ret)
+			goto unlock_out;
+	}
+
+	group->container = container;
+	list_add(&group->container_next, &container->group_list);
+
+	/* Get a reference on the container and mark a user within the group */
+	vfio_container_get(container);
+	atomic_inc(&group->container_users);
+
+unlock_out:
+	mutex_unlock(&container->group_lock);
+	fput(filep);
+	if (ret)
+		vfio_container_put(container);
+
+	return ret;
+}
+
+/*
+ * A vfio group is viable for use by userspace if all devices are either
+ * driver-less or bound to a vfio driver.  We test the latter by the
+ * existence of a struct vfio_device matching the dev.
+ */
+static int vfio_dev_viable(struct device *dev, void *data)
+{
+	struct vfio_group *group = data;
+	struct vfio_device *device;
+
+	if (!dev->driver)
+		return 0;
+
+	device = vfio_group_get_device(group, dev);
+	vfio_device_put(device);
+
+	if (!device)
+		return -EINVAL;
+
+	return 0;
+}
+
+static bool vfio_group_viable(struct vfio_group *group)
+{
+	return (iommu_group_for_each_dev(group->iommu_group,
+					 group, vfio_dev_viable) == 0);
+}
+
+static const struct file_operations vfio_device_fops;
+
+static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
+{
+	struct vfio_device *device;
+	struct file *filep;
+	int ret = -ENODEV;
+
+	if (0 == atomic_read(&group->container_users) ||
+	    !group->container->iommu_driver || !vfio_group_viable(group))
+		return -EINVAL;
+
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(device, &group->device_list, group_next) {
+		if (strcmp(dev_name(device->dev), buf))
+			continue;
+
+		ret = device->ops->open(device->device_data);
+		if (ret)
+			break;
+		/*
+		 * We can't use anon_inode_getfd() because we need to modify
+		 * the f_mode flags directly to allow more than just ioctls
+		 */
+		ret = get_unused_fd();
+		if (ret < 0) {
+			device->ops->release(device->device_data);
+			break;
+		}
+
+		filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
+					   device, O_RDWR);
+		if (IS_ERR(filep)) {
+			put_unused_fd(ret);
+			ret = PTR_ERR(filep);
+			device->ops->release(device->device_data);
+			break;
+		}
+
+		/*
+		 * TODO: add an anon_inode interface to do this.
+		 * Appears to be missing by lack of need rather than
+		 * explicitly prevented.  Now there's need.
+		 */
+		filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
+
+		fd_install(ret, filep);
+
+		vfio_device_get(device);
+		atomic_inc(&group->container_users);
+		break;
+	}
+	mutex_unlock(&group->device_lock);
+
+	return ret;
+}
+
+static long vfio_group_fops_unl_ioctl(struct file *filep,
+				      unsigned int cmd, unsigned long arg)
+{
+	struct vfio_group *group = filep->private_data;
+	long ret = -ENOTTY;
+
+	switch (cmd) {
+	case VFIO_GROUP_GET_STATUS:
+	{
+		struct vfio_group_status status;
+		unsigned long minsz;
+
+		minsz = offsetofend(struct vfio_group_status, flags);
+
+		if (copy_from_user(&status, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (status.argsz < minsz)
+			return -EINVAL;
+
+		status.flags = 0;
+
+		if (vfio_group_viable(group))
+			status.flags |= VFIO_GROUP_FLAGS_VIABLE;
+
+		if (group->container)
+			status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET;
+
+		ret = copy_to_user((void __user *)arg, &status, minsz);
+
+		break;
+	}
+	case VFIO_GROUP_SET_CONTAINER:
+	{
+		int fd;
+
+		if (get_user(fd, (int __user *)arg))
+			return -EFAULT;
+
+		if (fd < 0)
+			return -EINVAL;
+
+		ret = vfio_group_set_container(group, fd);
+		break;
+	}
+	case VFIO_GROUP_UNSET_CONTAINER:
+		ret = vfio_group_unset_container(group);
+		break;
+	case VFIO_GROUP_GET_DEVICE_FD:
+	{
+		char *buf;
+
+		buf = strndup_user((const char __user *)arg, PAGE_SIZE);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+
+		ret = vfio_group_get_device_fd(group, buf);
+		kfree(buf);
+		break;
+	}
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long vfio_group_fops_compat_ioctl(struct file *filep,
+					 unsigned int cmd, unsigned long arg)
+{
+	arg = (unsigned long)compat_ptr(arg);
+	return vfio_group_fops_unl_ioctl(filep, cmd, arg);
+}
+#endif	/* CONFIG_COMPAT */
+
+static int vfio_group_fops_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_group *group;
+
+	group = vfio_group_get_from_minor(iminor(inode));
+	if (!group)
+		return -ENODEV;
+
+	if (group->container) {
+		vfio_group_put(group);
+		return -EBUSY;
+	}
+
+	filep->private_data = group;
+
+	return 0;
+}
+
+static int vfio_group_fops_release(struct inode *inode, struct file *filep)
+{
+	struct vfio_group *group = filep->private_data;
+
+	filep->private_data = NULL;
+
+	vfio_group_try_dissolve_container(group);
+
+	vfio_group_put(group);
+
+	return 0;
+}
+
+static const struct file_operations vfio_group_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= vfio_group_fops_unl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= vfio_group_fops_compat_ioctl,
+#endif
+	.open		= vfio_group_fops_open,
+	.release	= vfio_group_fops_release,
+};
+
+/**
+ * VFIO Device fd
+ */
+static int vfio_device_fops_release(struct inode *inode, struct file *filep)
+{
+	struct vfio_device *device = filep->private_data;
+
+	device->ops->release(device->device_data);
+
+	vfio_group_try_dissolve_container(device->group);
+
+	vfio_device_put(device);
+
+	return 0;
+}
+
+static long vfio_device_fops_unl_ioctl(struct file *filep,
+				       unsigned int cmd, unsigned long arg)
+{
+	struct vfio_device *device = filep->private_data;
+
+	if (unlikely(!device->ops->ioctl))
+		return -EINVAL;
+
+	return device->ops->ioctl(device->device_data, cmd, arg);
+}
+
+static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct vfio_device *device = filep->private_data;
+
+	if (unlikely(!device->ops->read))
+		return -EINVAL;
+
+	return device->ops->read(device->device_data, buf, count, ppos);
+}
+
+static ssize_t vfio_device_fops_write(struct file *filep,
+				      const char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct vfio_device *device = filep->private_data;
+
+	if (unlikely(!device->ops->write))
+		return -EINVAL;
+
+	return device->ops->write(device->device_data, buf, count, ppos);
+}
+
+static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
+{
+	struct vfio_device *device = filep->private_data;
+
+	if (unlikely(!device->ops->mmap))
+		return -EINVAL;
+
+	return device->ops->mmap(device->device_data, vma);
+}
+
+#ifdef CONFIG_COMPAT
+static long vfio_device_fops_compat_ioctl(struct file *filep,
+					  unsigned int cmd, unsigned long arg)
+{
+	arg = (unsigned long)compat_ptr(arg);
+	return vfio_device_fops_unl_ioctl(filep, cmd, arg);
+}
+#endif	/* CONFIG_COMPAT */
+
+static const struct file_operations vfio_device_fops = {
+	.owner		= THIS_MODULE,
+	.release	= vfio_device_fops_release,
+	.read		= vfio_device_fops_read,
+	.write		= vfio_device_fops_write,
+	.unlocked_ioctl	= vfio_device_fops_unl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= vfio_device_fops_compat_ioctl,
+#endif
+	.mmap		= vfio_device_fops_mmap,
+};
+
+/**
+ * Module/class support
+ */
+static char *vfio_devnode(struct device *dev, umode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
+}
+
+static int __init vfio_init(void)
+{
+	int ret;
+
+	idr_init(&vfio.group_idr);
+	mutex_init(&vfio.group_lock);
+	mutex_init(&vfio.iommu_drivers_lock);
+	INIT_LIST_HEAD(&vfio.group_list);
+	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
+	init_waitqueue_head(&vfio.release_q);
+
+	vfio.class = class_create(THIS_MODULE, "vfio");
+	if (IS_ERR(vfio.class)) {
+		ret = PTR_ERR(vfio.class);
+		goto err_class;
+	}
+
+	vfio.class->devnode = vfio_devnode;
+
+	ret = alloc_chrdev_region(&vfio.devt, 0, MINORMASK, "vfio");
+	if (ret)
+		goto err_base_chrdev;
+
+	cdev_init(&vfio.cdev, &vfio_fops);
+	ret = cdev_add(&vfio.cdev, vfio.devt, 1);
+	if (ret)
+		goto err_base_cdev;
+
+	vfio.dev = device_create(vfio.class, NULL, vfio.devt, NULL, "vfio");
+	if (IS_ERR(vfio.dev)) {
+		ret = PTR_ERR(vfio.dev);
+		goto err_base_dev;
+	}
+
+	/* /dev/vfio/$GROUP */
+	cdev_init(&vfio.group_cdev, &vfio_group_fops);
+	ret = cdev_add(&vfio.group_cdev,
+		       MKDEV(MAJOR(vfio.devt), 1), MINORMASK - 1);
+	if (ret)
+		goto err_groups_cdev;
+
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+
+	return 0;
+
+err_groups_cdev:
+	device_destroy(vfio.class, vfio.devt);
+err_base_dev:
+	cdev_del(&vfio.cdev);
+err_base_cdev:
+	unregister_chrdev_region(vfio.devt, MINORMASK);
+err_base_chrdev:
+	class_destroy(vfio.class);
+	vfio.class = NULL;
+err_class:
+	return ret;
+}
+
+static void __exit vfio_cleanup(void)
+{
+	WARN_ON(!list_empty(&vfio.group_list));
+
+	idr_destroy(&vfio.group_idr);
+	cdev_del(&vfio.group_cdev);
+	device_destroy(vfio.class, vfio.devt);
+	cdev_del(&vfio.cdev);
+	unregister_chrdev_region(vfio.devt, MINORMASK);
+	class_destroy(vfio.class);
+	vfio.class = NULL;
+}
+
+module_init(vfio_init);
+module_exit(vfio_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
new file mode 100644
index 0000000..a264054
--- /dev/null
+++ b/include/linux/vfio.h
@@ -0,0 +1,364 @@
+/*
+ * VFIO API definition
+ *
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef VFIO_H
+#define VFIO_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define VFIO_API_VERSION	0
+
+#ifdef __KERNEL__	/* Internal VFIO-core/bus driver API */
+
+/**
+ * struct vfio_device_ops - VFIO bus driver device callbacks
+ *
+ * @open: Called when userspace creates new file descriptor for device
+ * @release: Called when userspace releases file descriptor for device
+ * @read: Perform read(2) on device file descriptor
+ * @write: Perform write(2) on device file descriptor
+ * @ioctl: Perform ioctl(2) on device file descriptor, supporting VFIO_DEVICE_*
+ *         operations documented below
+ * @mmap: Perform mmap(2) on a region of the device file descriptor
+ */
+struct vfio_device_ops {
+	char	*name;
+	int	(*open)(void *device_data);
+	void	(*release)(void *device_data);
+	ssize_t	(*read)(void *device_data, char __user *buf,
+			size_t count, loff_t *ppos);
+	ssize_t	(*write)(void *device_data, const char __user *buf,
+			 size_t count, loff_t *size);
+	long	(*ioctl)(void *device_data, unsigned int cmd,
+			 unsigned long arg);
+	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
+};
+
+extern int vfio_add_group_dev(struct device *dev,
+			      const struct vfio_device_ops *ops,
+			      void *device_data);
+
+extern void *vfio_del_group_dev(struct device *dev);
+
+/**
+ * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
+ */
+struct vfio_iommu_driver_ops {
+	char		*name;
+	struct module	*owner;
+	void		*(*open)(unsigned long arg);
+	void		(*release)(void *iommu_data);
+	ssize_t		(*read)(void *iommu_data, char __user *buf,
+				size_t count, loff_t *ppos);
+	ssize_t		(*write)(void *iommu_data, const char __user *buf,
+				 size_t count, loff_t *size);
+	long		(*ioctl)(void *iommu_data, unsigned int cmd,
+				 unsigned long arg);
+	int		(*mmap)(void *iommu_data, struct vm_area_struct *vma);
+	int		(*attach_group)(void *iommu_data,
+					struct iommu_group *group);
+	void		(*detach_group)(void *iommu_data,
+					struct iommu_group *group);
+
+};
+
+extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
+
+extern void vfio_unregister_iommu_driver(
+				const struct vfio_iommu_driver_ops *ops);
+
+/**
+ * offsetofend(TYPE, MEMBER)
+ *
+ * @TYPE: The type of the structure
+ * @MEMBER: The member within the structure to get the end offset of
+ *
+ * Simple helper macro for dealing with variable sized structures passed
+ * from user space.  This allows us to easily determine if the provided
+ * structure is sized to include various fields.
+ */
+#define offsetofend(TYPE, MEMBER) ({				\
+	TYPE tmp;						\
+	offsetof(TYPE, MEMBER) + sizeof(tmp.MEMBER); })		\
+
+#endif /* __KERNEL__ */
+
+/* Kernel & User level defines for VFIO IOCTLs. */
+
+/* Extensions */
+
+#define VFIO_X86_IOMMU		1
+
+/*
+ * The IOCTL interface is designed for extensibility by embedding the
+ * structure length (argsz) and flags into structures passed between
+ * kernel and userspace.  We therefore use the _IO() macro for these
+ * defines to avoid implicitly embedding a size into the ioctl request.
+ * As structure fields are added, argsz will increase to match and flag
+ * bits will be defined to indicate additional fields with valid data.
+ * It's *always* the caller's responsibility to indicate the size of
+ * the structure passed by setting argsz appropriately.
+ */
+
+#define VFIO_TYPE	(';')
+#define VFIO_BASE	100
+
+/* -------- IOCTLs for VFIO file descriptor (/dev/vfio/vfio) -------- */
+
+/**
+ * VFIO_GET_API_VERSION - _IO(VFIO_TYPE, VFIO_BASE + 0)
+ *
+ * Report the version of the VFIO API.  This allows us to bump the entire
+ * API version should we later need to add or change features in incompatible
+ * ways.
+ * Return: VFIO_API_VERSION
+ * Availability: Always
+ */
+#define VFIO_GET_API_VERSION		_IO(VFIO_TYPE, VFIO_BASE + 0)
+
+/**
+ * VFIO_CHECK_EXTENSION - _IOW(VFIO_TYPE, VFIO_BASE + 1, __s32)
+ *
+ * Check whether an extension is supported.
+ * Return: 0 if not supported, 1 (or some other positive integer) if supported.
+ * Availability: Always
+ */
+#define VFIO_CHECK_EXTENSION		_IO(VFIO_TYPE, VFIO_BASE + 1)
+
+/**
+ * VFIO_SET_IOMMU - _IOW(VFIO_TYPE, VFIO_BASE + 2, __s32)
+ *
+ * Set the iommu to the given type.  The type must be supported by an
+ * iommu driver as verified by calling CHECK_EXTENSION using the same
+ * type.  A group must be set to this file descriptor before this
+ * ioctl is available.  The IOMMU interfaces enabled by this call are
+ * specific to the value set.
+ * Return: 0 on success, -errno on failure
+ * Availability: When VFIO group attached
+ */
+#define VFIO_SET_IOMMU			_IO(VFIO_TYPE, VFIO_BASE + 2)
+
+/* -------- IOCTLs for GROUP file descriptors (/dev/vfio/$GROUP) -------- */
+
+/**
+ * VFIO_GROUP_GET_STATUS - _IOR(VFIO_TYPE, VFIO_BASE + 3,
+ *						struct vfio_group_status)
+ *
+ * Retrieve information about the group.  Fills in provided
+ * struct vfio_group_info.  Caller sets argsz.
+ * Return: 0 on succes, -errno on failure.
+ * Availability: Always
+ */
+struct vfio_group_status {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_GROUP_FLAGS_VIABLE		(1 << 0)
+#define VFIO_GROUP_FLAGS_CONTAINER_SET	(1 << 1)
+};
+#define VFIO_GROUP_GET_STATUS		_IO(VFIO_TYPE, VFIO_BASE + 3)
+
+/**
+ * VFIO_GROUP_SET_CONTAINER - _IOW(VFIO_TYPE, VFIO_BASE + 4, __s32)
+ *
+ * Set the container for the VFIO group to the open VFIO file
+ * descriptor provided.  Groups may only belong to a single
+ * container.  Containers may, at their discretion, support multiple
+ * groups.  Only when a container is set are all of the interfaces
+ * of the VFIO file descriptor and the VFIO group file descriptor
+ * available to the user.
+ * Return: 0 on success, -errno on failure.
+ * Availability: Always
+ */
+#define VFIO_GROUP_SET_CONTAINER	_IO(VFIO_TYPE, VFIO_BASE + 4)
+
+/**
+ * VFIO_GROUP_UNSET_CONTAINER - _IO(VFIO_TYPE, VFIO_BASE + 5)
+ *
+ * Remove the group from the attached container.  This is the
+ * opposite of the SET_CONTAINER call and returns the group to
+ * an initial state.  All device file descriptors must be released
+ * prior to calling this interface.  When removing the last group
+ * from a container, the IOMMU will be disabled and all state lost,
+ * effectively also returning the VFIO file descriptor to an initial
+ * state.
+ * Return: 0 on success, -errno on failure.
+ * Availability: When attached to container
+ */
+#define VFIO_GROUP_UNSET_CONTAINER	_IO(VFIO_TYPE, VFIO_BASE + 5)
+
+/**
+ * VFIO_GROUP_GET_DEVICE_FD - _IOW(VFIO_TYPE, VFIO_BASE + 6, char)
+ *
+ * Return a new file descriptor for the device object described by
+ * the provided string.  The string should match a device listed in
+ * the devices subdirectory of the IOMMU group sysfs entry.  The
+ * group containing the device must already be added to this context.
+ * Return: new file descriptor on success, -errno on failure.
+ * Availability: When attached to container
+ */
+#define VFIO_GROUP_GET_DEVICE_FD	_IO(VFIO_TYPE, VFIO_BASE + 6)
+
+/* --------------- IOCTLs for DEVICE file descriptors --------------- */
+
+/**
+ * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
+ *						struct vfio_device_info)
+ *
+ * Retrieve information about the device.  Fills in provided
+ * struct vfio_device_info.  Caller sets argsz.
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_info {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
+	__u32	num_regions;	/* Max region index + 1 */
+	__u32	num_irqs;	/* Max IRQ index + 1 */
+};
+#define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
+
+/**
+ * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
+ *				       struct vfio_region_info)
+ *
+ * Retrieve information about a device region.  Caller provides
+ * struct vfio_region_info with index value set.  Caller sets argsz.
+ * Implementation of region mapping is bus driver specific.  This is
+ * intended to describe MMIO, I/O port, as well as bus specific
+ * regions (ex. PCI config space).  Zero sized regions may be used
+ * to describe unimplemented regions (ex. unimplemented PCI BARs).
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_region_info {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_REGION_INFO_FLAG_READ	(1 << 0) /* Region supports read */
+#define VFIO_REGION_INFO_FLAG_WRITE	(1 << 1) /* Region supports write */
+#define VFIO_REGION_INFO_FLAG_MMAP	(1 << 2) /* Region supports mmap */
+	__u32	index;		/* Region index */
+	__u32	resv;		/* Reserved for alignment */
+	__u64	size;		/* Region size (bytes) */
+	__u64	offset;		/* Region offset from start of device fd */
+};
+#define VFIO_DEVICE_GET_REGION_INFO	_IO(VFIO_TYPE, VFIO_BASE + 8)
+
+/**
+ * VFIO_DEVICE_GET_IRQ_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 9,
+ *				    struct vfio_irq_info)
+ *
+ * Retrieve information about a device IRQ.  Caller provides
+ * struct vfio_irq_info with index value set.  Caller sets argsz.
+ * Implementation of IRQ mapping is bus driver specific.  Indexes
+ * using multiple IRQs are primarily intended to support MSI-like
+ * interrupt blocks.  Zero count irq blocks may be used to describe
+ * unimplemented interrupt types.
+ *
+ * The EVENTFD flag indicates the interrupt index supports eventfd based
+ * signaling.
+ *
+ * The MASKABLE flags indicates the index supports MASK and UNMASK
+ * actions described below.
+ *
+ * AUTOMASKED indicates that after signaling, the interrupt line is
+ * automatically masked by VFIO and the user needs to unmask the line
+ * to receive new interrupts.  This is primarily intended to distinguish
+ * level triggered interrupts.
+ *
+ * The NORESIZE flag indicates that the interrupt lines within the index
+ * are setup as a set and new subindexes cannot be enabled without first
+ * disabling the entire index.  This is used for interrupts like PCI MSI
+ * and MSI-X where the driver may only use a subset of the available
+ * indexes, but VFIO needs to enable a specific number of vectors
+ * upfront.  In the case of MSI-X, where the user can enable MSI-X and
+ * then add and unmask vectors, it's up to userspace to make the decision
+ * whether to allocate the maximum supported number of vectors or tear
+ * down setup and incrementally increase the vectors as each is enabled.
+ */
+struct vfio_irq_info {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_IRQ_INFO_EVENTFD		(1 << 0)
+#define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
+#define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
+#define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
+	__u32	index;		/* IRQ index */
+	__s32	count;		/* Number of IRQs within this index */
+};
+#define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE + 9)
+
+/**
+ * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
+ *
+ * Set signaling, masking, and unmasking of interrupts.  Caller provides
+ * struct vfio_irq_set with all fields set.  'start' and 'count' indicate
+ * the range of subindexes being specified.
+ *
+ * The DATA flags specify the type of data provided.  If DATA_NONE, the
+ * operation performs the specified action immediately on the specified
+ * interrupt(s).  For example, to unmask AUTOMASKED interrupt [0,0]:
+ * flags = (DATA_NONE|ACTION_UNMASK), index = 0, start = 0, count = 1.
+ *
+ * DATA_BOOL allows sparse support for the same on arrays of interrupts.
+ * For example, to mask interrupts [0,1] and [0,3] (but not [0,2]):
+ * flags = (DATA_BOOL|ACTION_MASK), index = 0, start = 1, count = 3,
+ * data = {1,0,1}
+ *
+ * DATA_EVENTFD binds the specified ACTION to the provided __s32 eventfd.
+ * A value of -1 can be used to either de-assign interrupts if already
+ * assigned or skip un-assigned interrupts.  For example, to set an eventfd
+ * to be trigger for interrupts [0,0] and [0,2]:
+ * flags = (DATA_EVENTFD|ACTION_TRIGGER), index = 0, start = 0, count = 3,
+ * data = {fd1, -1, fd2}
+ * If index [0,1] is previously set, two count = 1 ioctls calls would be
+ * required to set [0,0] and [0,2] without changing [0,1].
+ *
+ * Once a signaling mechanism is set, DATA_BOOL or DATA_NONE can be used
+ * with ACTION_TRIGGER to perform kernel level interrupt loopback testing
+ * from userspace (ie. simulate hardware triggering).
+ *
+ * Setting of an event triggering mechanism to userspace for ACTION_TRIGGER
+ * enables the interrupt index for the device.  Individual subindex interrupts
+ * can be disabled using the -1 value for DATA_EVENTFD or the index can be
+ * disabled as a whole with: flags = (DATA_NONE|ACTION_TRIGGER), count = 0.
+ *
+ * Note that ACTION_[UN]MASK specify user->kernel signaling (irqfds) while
+ * ACTION_TRIGGER specifies kernel->user signaling.
+ */
+struct vfio_irq_set {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_IRQ_SET_DATA_NONE		(1 << 0) /* Data not present */
+#define VFIO_IRQ_SET_DATA_BOOL		(1 << 1) /* Data is bool (u8) */
+#define VFIO_IRQ_SET_DATA_EVENTFD	(1 << 2) /* Data is eventfd (s32) */
+#define VFIO_IRQ_SET_ACTION_MASK	(1 << 3) /* Mask interrupt */
+#define VFIO_IRQ_SET_ACTION_UNMASK	(1 << 4) /* Unmask interrupt */
+#define VFIO_IRQ_SET_ACTION_TRIGGER	(1 << 5) /* Trigger interrupt */
+	__u32	index;
+	__s32	start;
+	__s32	count;
+	__u8	data[];
+};
+#define VFIO_DEVICE_SET_IRQS		_IO(VFIO_TYPE, VFIO_BASE + 10)
+
+#define VFIO_IRQ_SET_DATA_TYPE_MASK	(VFIO_IRQ_SET_DATA_NONE | \
+					 VFIO_IRQ_SET_DATA_BOOL | \
+					 VFIO_IRQ_SET_DATA_EVENTFD)
+#define VFIO_IRQ_SET_ACTION_TYPE_MASK	(VFIO_IRQ_SET_ACTION_MASK | \
+					 VFIO_IRQ_SET_ACTION_UNMASK | \
+					 VFIO_IRQ_SET_ACTION_TRIGGER)
+/**
+ * VFIO_DEVICE_RESET - _IO(VFIO_TYPE, VFIO_BASE + 11)
+ *
+ * Reset a device.
+ */
+#define VFIO_DEVICE_RESET		_IO(VFIO_TYPE, VFIO_BASE + 11)
+
+#endif /* VFIO_H */

