Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2DBVPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:15:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2DBVPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:15:01 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 2/3] iommu: Create basic group infrastructure and update
 AMD-Vi & Intel VT-d
To: david@gibson.dropbear.id.au, dwmw2@infradead.org
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Apr 2012 15:14:46 -0600
Message-ID: <20120402211446.28977.62780.stgit@bling.home>
In-Reply-To: <20120402203721.28977.95285.stgit@bling.home>
References: <20120402203721.28977.95285.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU groups define the minimum granularity of the IOMMU.  We therefore
create groups using a dma_dev which is the effective requestor ID for
the entire group.  Additional devices can be added to groups based on
system topology, IOMMU limitations, or device quirks.

This implementation also includes a simple idr database for creating
a flat address space of group IDs across multiple IOMMUs.  Updates
included for Intel VT-d, using example iommu callbacks for adding and
removing devices, as well as AMD-Vi, which tracks devices on it's own.
We should be able to better integrate the iommu_group within existing
AMD-Vi structs or provide a private data location within the iommu_group
where we can eventually reduce redundancy.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c   |   50 ++++++-----
 drivers/iommu/intel-iommu.c |   76 +++++++++--------
 drivers/iommu/iommu.c       |  198 ++++++++++++++++++++++++++++++++++++++-----
 include/linux/iommu.h       |   23 +++++
 4 files changed, 267 insertions(+), 80 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f75e060..876db28 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -256,9 +256,10 @@ static bool check_device(struct device *dev)
 
 static int iommu_init_device(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
 	struct iommu_dev_data *dev_data;
 	u16 alias;
+	int ret;
 
 	if (dev->archdata.iommu)
 		return 0;
@@ -279,6 +280,26 @@ static int iommu_init_device(struct device *dev)
 			return -ENOTSUPP;
 		}
 		dev_data->alias_data = alias_data;
+
+		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
+	} else
+		dma_pdev = pdev;
+
+	/* dma_pdev = iommu_pci_quirk(dma_pdev) */
+
+	if (!dma_pdev->dev.iommu_group) {
+		struct iommu_group *group;
+
+		group = iommu_group_alloc(&dma_pdev->dev);
+		if (IS_ERR(group))
+			return PTR_ERR(group);
+	}
+
+	ret = iommu_group_add_device(dma_pdev->dev.iommu_group, dev);
+	if (ret) {
+		if (iommu_group_empty(dma_pdev->dev.iommu_group))
+			iommu_group_free(dma_pdev->dev.iommu_group);
+		return ret;
 	}
 
 	if (pci_iommuv2_capable(pdev)) {
@@ -309,6 +330,12 @@ static void iommu_ignore_device(struct device *dev)
 
 static void iommu_uninit_device(struct device *dev)
 {
+	struct iommu_group *group = dev->iommu_group;
+
+	iommu_group_remove_device(dev);
+	if (iommu_group_empty(group))
+		iommu_group_free(group);
+
 	/*
 	 * Nothing to do here - we keep dev_data around for unplugged devices
 	 * and reuse it when the device is re-plugged - not doing so would
@@ -3191,26 +3218,6 @@ static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
-static int amd_iommu_device_group(struct device *dev, unsigned int *groupid)
-{
-	struct iommu_dev_data *dev_data = dev->archdata.iommu;
-	struct pci_dev *pdev = to_pci_dev(dev);
-	u16 devid;
-
-	if (!dev_data)
-		return -ENODEV;
-
-	if (pdev->is_virtfn || !iommu_group_mf)
-		devid = dev_data->devid;
-	else
-		devid = calc_devid(pdev->bus->number,
-				   PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
-
-	*groupid = amd_iommu_alias_table[devid];
-
-	return 0;
-}
-
 static struct iommu_ops amd_iommu_ops = {
 	.domain_init = amd_iommu_domain_init,
 	.domain_destroy = amd_iommu_domain_destroy,
@@ -3220,7 +3227,6 @@ static struct iommu_ops amd_iommu_ops = {
 	.unmap = amd_iommu_unmap,
 	.iova_to_phys = amd_iommu_iova_to_phys,
 	.domain_has_cap = amd_iommu_domain_has_cap,
-	.device_group = amd_iommu_device_group,
 	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
 };
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c9c6053..41ab7d0 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4075,54 +4075,59 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
-/*
- * Group numbers are arbitrary.  Device with the same group number
- * indicate the iommu cannot differentiate between them.  To avoid
- * tracking used groups we just use the seg|bus|devfn of the lowest
- * level we're able to differentiate devices
- */
-static int intel_iommu_device_group(struct device *dev, unsigned int *groupid)
+static int intel_iommu_add_device(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pci_dev *bridge;
-	union {
-		struct {
-			u8 devfn;
-			u8 bus;
-			u16 segment;
-		} pci;
-		u32 group;
-	} id;
-
-	if (iommu_no_mapping(dev))
-		return -ENODEV;
-
-	id.pci.segment = pci_domain_nr(pdev->bus);
-	id.pci.bus = pdev->bus->number;
-	id.pci.devfn = pdev->devfn;
+	struct pci_dev *bridge, *dma_pdev = pdev;
+	int ret;
 
-	if (!device_to_iommu(id.pci.segment, id.pci.bus, id.pci.devfn))
+	if (!device_to_iommu(pci_domain_nr(pdev->bus),
+			     pdev->bus->number, pdev->devfn))
 		return -ENODEV;
 
 	bridge = pci_find_upstream_pcie_bridge(pdev);
 	if (bridge) {
-		if (pci_is_pcie(bridge)) {
-			id.pci.bus = bridge->subordinate->number;
-			id.pci.devfn = 0;
-		} else {
-			id.pci.bus = bridge->bus->number;
-			id.pci.devfn = bridge->devfn;
-		}
+		if (pci_is_pcie(bridge))
+			dma_pdev = pci_get_domain_bus_and_slot(
+						pci_domain_nr(pdev->bus),
+						bridge->subordinate->number, 0);
+		else
+			dma_pdev = bridge;
+	}
+
+	if (!bridge && !pdev->is_virtfn && iommu_group_mf)
+		dma_pdev = pci_get_slot(dma_pdev->bus, 0);
+
+	/* dma_pdev = iommu_pci_quirk(dma_pdev); */
+
+	if (!dma_pdev->dev.iommu_group) {
+		struct iommu_group *group;
+
+		group = iommu_group_alloc(&dma_pdev->dev);
+		if (IS_ERR(group))
+			return PTR_ERR(group);
 	}
 
-	if (!pdev->is_virtfn && iommu_group_mf)
-		id.pci.devfn = PCI_DEVFN(PCI_SLOT(id.pci.devfn), 0);
+	ret = iommu_group_add_device(dma_pdev->dev.iommu_group, dev);
+	if (ret) {
+		if (iommu_group_empty(dma_pdev->dev.iommu_group))
+			iommu_group_free(dma_pdev->dev.iommu_group);
 
-	*groupid = id.group;
+		return ret;
+	}
 
 	return 0;
 }
 
+static void intel_iommu_remove_device(struct device *dev)
+{
+	struct iommu_group *group = dev->iommu_group;
+
+	iommu_group_remove_device(dev);
+	if (iommu_group_empty(group))
+		iommu_group_free(group);
+}
+
 static struct iommu_ops intel_iommu_ops = {
 	.domain_init	= intel_iommu_domain_init,
 	.domain_destroy = intel_iommu_domain_destroy,
@@ -4132,7 +4137,8 @@ static struct iommu_ops intel_iommu_ops = {
 	.unmap		= intel_iommu_unmap,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
 	.domain_has_cap = intel_iommu_domain_has_cap,
-	.device_group	= intel_iommu_device_group,
+	.add_device	= intel_iommu_add_device,
+	.remove_device	= intel_iommu_remove_device,
 	.pgsize_bitmap	= INTEL_IOMMU_PGSIZES,
 };
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2198b2d..6a51ed9 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -26,48 +26,96 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
+#include <linux/idr.h>
 
-static ssize_t show_iommu_group(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static struct kset *iommu_group_kset;
+static struct idr iommu_group_idr;
+static struct mutex iommu_group_mutex;
+
+struct iommu_group_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct iommu_group *group, char *buf);
+	ssize_t (*store)(struct iommu_group *group,
+			 const char *buf, size_t count);
+};
+
+#define to_iommu_group_attr(_attr)	\
+	container_of(_attr, struct iommu_group_attribute, attr)
+#define to_iommu_group(_kobj)		\
+	container_of(_kobj, struct iommu_group, kobj)
+
+static ssize_t iommu_group_attr_show(struct kobject *kobj,
+				     struct attribute *__attr, char *buf)
 {
-	unsigned int groupid;
+	struct iommu_group_attribute *attr = to_iommu_group_attr(__attr);
+	struct iommu_group *group = to_iommu_group(kobj);
+	ssize_t ret = -EIO;
 
-	if (iommu_device_group(dev, &groupid))
-		return 0;
+	if (attr->show)
+		ret = attr->show(group, buf);
+	return ret;
+}
+
+static ssize_t iommu_group_attr_store(struct kobject *kobj,
+				      struct attribute *__attr,
+				      const char *buf, size_t count)
+{
+	struct iommu_group_attribute *attr = to_iommu_group_attr(__attr);
+	struct iommu_group *group = to_iommu_group(kobj);
+	ssize_t ret = -EIO;
 
-	return sprintf(buf, "%u", groupid);
+	if (attr->store)
+		ret = attr->store(group, buf, count);
+	return ret;
 }
-static DEVICE_ATTR(iommu_group, S_IRUGO, show_iommu_group, NULL);
 
-static int add_iommu_group(struct device *dev, void *data)
+static void iommu_group_release(struct kobject *kobj)
 {
-	unsigned int groupid;
+	struct iommu_group *group = to_iommu_group(kobj);
 
-	if (iommu_device_group(dev, &groupid) == 0)
-		return device_create_file(dev, &dev_attr_iommu_group);
+	mutex_lock(&iommu_group_mutex);
+	idr_remove(&iommu_group_idr, group->id);
+	mutex_unlock(&iommu_group_mutex);
 
-	return 0;
+	kfree(group);
 }
 
-static int remove_iommu_group(struct device *dev)
+static const struct sysfs_ops iommu_group_sysfs_ops = {
+	.show = iommu_group_attr_show,
+	.store = iommu_group_attr_store,
+};
+
+static struct kobj_type iommu_group_ktype = {
+	.sysfs_ops = &iommu_group_sysfs_ops,
+	.release = iommu_group_release,
+};
+
+static int add_iommu_group(struct device *dev, void *data)
 {
-	unsigned int groupid;
+	struct iommu_ops *ops = data;
 
-	if (iommu_device_group(dev, &groupid) == 0)
-		device_remove_file(dev, &dev_attr_iommu_group);
+	if (!ops->add_device)
+		return -ENODEV;
 
-	return 0;
+	WARN_ON(dev->iommu_group);
+
+	return ops->add_device(dev);
 }
 
 static int iommu_device_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
 {
 	struct device *dev = data;
+	struct iommu_ops *ops = dev->bus->iommu_ops;
 
 	if (action == BUS_NOTIFY_ADD_DEVICE)
-		return add_iommu_group(dev, NULL);
-	else if (action == BUS_NOTIFY_DEL_DEVICE)
-		return remove_iommu_group(dev);
+		return add_iommu_group(dev, ops);
+	else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		if (ops->remove_device && dev->iommu_group) {
+			ops->remove_device(dev);
+			return 0;
+		}
+	}
 
 	return 0;
 }
@@ -79,7 +127,97 @@ static struct notifier_block iommu_device_nb = {
 static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
 {
 	bus_register_notifier(bus, &iommu_device_nb);
-	bus_for_each_dev(bus, NULL, NULL, add_iommu_group);
+	bus_for_each_dev(bus, NULL, ops, add_iommu_group);
+}
+
+struct iommu_group *iommu_group_alloc(struct device *dma_dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+
+	group->kobj.kset = iommu_group_kset;
+	group->dma_dev = dma_dev;
+	atomic_set(&group->refcnt, 0);
+
+	mutex_lock(&iommu_group_mutex);
+
+again:
+	if (unlikely(0 == idr_pre_get(&iommu_group_idr, GFP_KERNEL))) {
+		kfree(group);
+		mutex_unlock(&iommu_group_mutex);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	if (-EAGAIN == idr_get_new(&iommu_group_idr, group, &group->id))
+		goto again;
+
+	mutex_unlock(&iommu_group_mutex);
+
+	ret = kobject_init_and_add(&group->kobj, &iommu_group_ktype,
+				   NULL, "%d", group->id);
+	if (ret) {
+		iommu_group_release(&group->kobj);
+		return ERR_PTR(ret);
+	}
+
+	group->devices_kobj = kobject_create_and_add("devices", &group->kobj);
+        if (!group->devices_kobj) {
+		kobject_put(&group->kobj);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	dma_dev->iommu_group = group;
+
+	return group;
+}
+
+void iommu_group_free(struct iommu_group *group)
+{
+	group->dma_dev->iommu_group = NULL;
+	WARN_ON(atomic_read(&group->refcnt));
+	kobject_put(group->devices_kobj);
+	kobject_put(&group->kobj);
+}
+
+bool iommu_group_empty(struct iommu_group *group)
+{
+	return (0 == atomic_read(&group->refcnt));
+}
+
+int iommu_group_add_device(struct iommu_group *group, struct device *dev)
+{
+	int ret;
+
+	atomic_inc(&group->refcnt);
+
+	ret = sysfs_create_link(&dev->kobj, &group->kobj, "iommu_group");
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_link(group->devices_kobj, &dev->kobj,
+                                kobject_name(&dev->kobj));
+	if (ret) {
+		sysfs_remove_link(&dev->kobj, "iommu_group");
+		return ret;
+	}
+
+	dev->iommu_group = group;
+
+	return 0;
+}
+
+void iommu_group_remove_device(struct device *dev)
+{
+	sysfs_remove_link(dev->iommu_group->devices_kobj,
+			  kobject_name(&dev->kobj));
+	sysfs_remove_link(&dev->kobj, "iommu_group");
+
+	atomic_dec(&dev->iommu_group->refcnt);
+	dev->iommu_group = NULL;
 }
 
 /**
@@ -335,9 +473,23 @@ EXPORT_SYMBOL_GPL(iommu_unmap);
 
 int iommu_device_group(struct device *dev, unsigned int *groupid)
 {
-	if (iommu_present(dev->bus) && dev->bus->iommu_ops->device_group)
-		return dev->bus->iommu_ops->device_group(dev, groupid);
+	if (dev->iommu_group) {
+		*groupid = dev->iommu_group->id;
+		return 0;
+	}
 
 	return -ENODEV;
 }
 EXPORT_SYMBOL_GPL(iommu_device_group);
+
+static int __init iommu_init(void)
+{
+	iommu_group_kset = kset_create_and_add("iommu_groups", NULL, NULL);
+	idr_init(&iommu_group_idr);
+	mutex_init(&iommu_group_mutex);
+
+	BUG_ON(!iommu_group_kset);
+
+	return 0;
+}
+subsys_initcall(iommu_init);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2ee375c..24004d6 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -60,6 +60,8 @@ struct iommu_domain {
  * @iova_to_phys: translate iova to physical address
  * @domain_has_cap: domain capabilities query
  * @commit: commit iommu domain
+ * @add_device: add device to iommu grouping
+ * @remove_device: remove device from iommu grouping
  * @pgsize_bitmap: bitmap of supported page sizes
  */
 struct iommu_ops {
@@ -76,10 +78,25 @@ struct iommu_ops {
 	int (*domain_has_cap)(struct iommu_domain *domain,
 			      unsigned long cap);
 	int (*device_group)(struct device *dev, unsigned int *groupid);
+	int (*add_device)(struct device *dev);
+	void (*remove_device)(struct device *dev);
 	unsigned long pgsize_bitmap;
 };
 
+/**
+ * struct iommu_group - groups of devices representing iommu visibility
+ * @dma_dev: all dma from the group appears to the iommu using this source id
+ * @kobj: iommu group node in sysfs
+ * @devices_kobj: sysfs subdir node for linking devices
+ * @refcnt: number of devices in group
+ * @id: unique id number for the group (for easy sysfs listing)
+ */
 struct iommu_group {
+	struct device *dma_dev;
+	struct kobject kobj;
+	struct kobject *devices_kobj;
+	atomic_t refcnt;
+	int id;
 };
 
 extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
@@ -101,6 +118,12 @@ extern int iommu_domain_has_cap(struct iommu_domain *domain,
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
 					iommu_fault_handler_t handler);
 extern int iommu_device_group(struct device *dev, unsigned int *groupid);
+extern struct iommu_group *iommu_group_alloc(struct device *dev);
+extern void iommu_group_free(struct iommu_group *group);
+extern bool iommu_group_empty(struct iommu_group *group);
+extern int iommu_group_add_device(struct iommu_group *group,
+				  struct device *dev);
+extern void iommu_group_remove_device(struct device *dev);
 
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework

