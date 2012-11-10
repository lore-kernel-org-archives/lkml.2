Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2KJN7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:59:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2KJN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:59:30 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Yinghai Lu <yinghai@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: [RFC PATCH 4/6] VFIO: reject binding driver to devices belonging to active VFIO groups
Date: Sat, 10 Nov 2012 21:57:17 +0800
Message-Id: <1352555839-18961-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
References: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

VFIO driver should reject binding unsafe drivers to devices belonging to
active VFIO groups, otherwise it will break the DMA isolation property
of VFIO groups. So hook IOMMU_GROUP_NOTIFY_QUERY_BINDING event to reject
unsafe device driver binding for active VFIO groups.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/vfio/pci/vfio_pci.c |   11 ++++-
 drivers/vfio/vfio.c         |  106 ++++++++++++++++++++++++++++++++++++-------
 include/linux/vfio.h        |    3 ++
 3 files changed, 102 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6968b72..e380fc1 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -538,6 +538,7 @@ static struct pci_driver vfio_pci_driver = {
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
+	vfio_unregister_device_driver(&vfio_pci_driver.driver);
 	vfio_pci_virqfd_exit();
 	vfio_pci_uninit_perm_bits();
 }
@@ -556,6 +557,10 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_virqfd;
 
+	ret = vfio_register_device_driver(&vfio_pci_driver.driver);
+	if (ret)
+		goto out_vfio_drv;
+
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
@@ -563,9 +568,11 @@ static int __init vfio_pci_init(void)
 
 	return 0;
 
-out_virqfd:
-	vfio_pci_virqfd_exit();
 out_driver:
+	vfio_unregister_device_driver(&vfio_pci_driver.driver);
+out_vfio_drv:
+	vfio_pci_virqfd_exit();
+out_virqfd:
 	vfio_pci_uninit_perm_bits();
 	return ret;
 }
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3359ec2..02da980 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -39,6 +39,8 @@ static struct vfio {
 	struct class			*class;
 	struct list_head		iommu_drivers_list;
 	struct mutex			iommu_drivers_lock;
+	struct list_head		device_drivers_list;
+	struct mutex			device_drivers_lock;
 	struct list_head		group_list;
 	struct idr			group_idr;
 	struct mutex			group_lock;
@@ -54,6 +56,11 @@ struct vfio_iommu_driver {
 	struct list_head			vfio_next;
 };
 
+struct vfio_device_driver {
+	const struct device_driver		*drv;
+	struct list_head			vfio_next;
+};
+
 struct vfio_container {
 	struct kref			kref;
 	struct list_head		group_list;
@@ -135,6 +142,55 @@ void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
 EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
 
 /**
+ * VFIO device driver registration
+ */
+int vfio_register_device_driver(const struct device_driver *drv)
+{
+	struct vfio_device_driver *driver, *tmp;
+
+	driver = kzalloc(sizeof(*driver), GFP_KERNEL);
+	if (!driver)
+		return -ENOMEM;
+
+	driver->drv = drv;
+
+	mutex_lock(&vfio.device_drivers_lock);
+
+	/* Check for duplicates */
+	list_for_each_entry(tmp, &vfio.device_drivers_list, vfio_next) {
+		if (tmp->drv == drv) {
+			mutex_unlock(&vfio.device_drivers_lock);
+			kfree(driver);
+			return -EINVAL;
+		}
+	}
+
+	list_add(&driver->vfio_next, &vfio.device_drivers_list);
+
+	mutex_unlock(&vfio.device_drivers_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_register_device_driver);
+
+void vfio_unregister_device_driver(const struct device_driver *drv)
+{
+	struct vfio_device_driver *driver;
+
+	mutex_lock(&vfio.device_drivers_lock);
+	list_for_each_entry(driver, &vfio.device_drivers_list, vfio_next) {
+		if (driver->drv == drv) {
+			list_del(&driver->vfio_next);
+			mutex_unlock(&vfio.device_drivers_lock);
+			kfree(driver);
+			return;
+		}
+	}
+	mutex_unlock(&vfio.device_drivers_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_unregister_device_driver);
+
+/**
  * Group minor allocation/free - both called with vfio.group_lock held
  */
 static int vfio_alloc_group_minor(struct vfio_group *group)
@@ -463,17 +519,18 @@ static bool vfio_whitelisted_driver(struct device_driver *drv)
  */
 static int vfio_dev_viable(struct device *dev, void *data)
 {
-	struct vfio_group *group = data;
-	struct vfio_device *device;
+	struct vfio_device_driver *driver;
 
 	if (!dev->driver || vfio_whitelisted_driver(dev->driver))
 		return 0;
 
-	device = vfio_group_get_device(group, dev);
-	if (device) {
-		vfio_device_put(device);
-		return 0;
-	}
+	mutex_lock(&vfio.device_drivers_lock);
+	list_for_each_entry(driver, &vfio.device_drivers_list, vfio_next)
+		if (driver->drv == dev->driver) {
+			mutex_unlock(&vfio.device_drivers_lock);
+			return 0;
+		}
+	mutex_unlock(&vfio.device_drivers_lock);
 
 	return -EINVAL;
 }
@@ -496,7 +553,6 @@ static int vfio_group_nb_add_dev(struct vfio_group *group, struct device *dev)
 	if (!atomic_read(&group->container_users))
 		return 0;
 
-	/* TODO Prevent device auto probing */
 	WARN("Device %s added to live group %d!\n", dev_name(dev),
 	     iommu_group_id(group->iommu_group));
 
@@ -533,9 +589,28 @@ static int vfio_group_nb_verify(struct vfio_group *group, struct device *dev)
 	return vfio_dev_viable(dev, group);
 }
 
+static int vfio_group_nb_solicit_binding(struct vfio_group *group,
+					 struct device *dev)
+{
+	int ret;
+
+	/* Allow driver binding for idle groups */
+	if (!atomic_read(&group->container_users))
+		return 0;
+
+	ret = vfio_dev_viable(dev, group);
+	if (ret)
+		dev_info(dev,
+			 "VFIO rejects binding device in active group to unsafe driver %s!\n",
+			 dev_driver_string(dev));
+
+	return ret;
+}
+
 static int vfio_iommu_group_notifier(struct notifier_block *nb,
 				     unsigned long action, void *data)
 {
+	int ret = NOTIFY_DONE;
 	struct vfio_group *group = container_of(nb, struct vfio_group, nb);
 	struct device *dev = data;
 
@@ -556,6 +631,10 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 	case IOMMU_GROUP_NOTIFY_DEL_DEVICE:
 		vfio_group_nb_del_dev(group, dev);
 		break;
+	case IOMMU_GROUP_NOTIFY_SOLICIT_BINDING:
+		if (vfio_group_nb_solicit_binding(group, dev))
+			ret = notifier_from_errno(-EBUSY);
+		break;
 	case IOMMU_GROUP_NOTIFY_BIND_DRIVER:
 		pr_debug("%s: Device %s, group %d binding to driver\n",
 			 __func__, dev_name(dev),
@@ -576,18 +655,11 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 		pr_debug("%s: Device %s, group %d unbound from driver\n",
 			 __func__, dev_name(dev),
 			 iommu_group_id(group->iommu_group));
-		/*
-		 * XXX An unbound device in a live group is ok, but we'd
-		 * really like to avoid the above BUG_ON by preventing other
-		 * drivers from binding to it.  Once that occurs, we have to
-		 * stop the system to maintain isolation.  At a minimum, we'd
-		 * want a toggle to disable driver auto probe for this device.
-		 */
 		break;
 	}
 
 	vfio_group_put(group);
-	return NOTIFY_OK;
+	return ret;
 }
 
 /**
@@ -1334,8 +1406,10 @@ static int __init vfio_init(void)
 	idr_init(&vfio.group_idr);
 	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
+	mutex_init(&vfio.device_drivers_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
+	INIT_LIST_HEAD(&vfio.device_drivers_list);
 	init_waitqueue_head(&vfio.release_q);
 
 	vfio.class = class_create(THIS_MODULE, "vfio");
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 0a4f180..4faa9b9 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -78,6 +78,9 @@ extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 extern void vfio_unregister_iommu_driver(
 				const struct vfio_iommu_driver_ops *ops);
 
+extern int vfio_register_device_driver(const struct device_driver *drv);
+extern void vfio_unregister_device_driver(const struct device_driver *drv);
+
 /**
  * offsetofend(TYPE, MEMBER)
  *
-- 
1.7.9.5

