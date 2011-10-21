Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1JUT4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 15:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab1JUT4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 15:56:34 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/4] iommu: Add iommu_device_group callback and iommu_group
	sysfs entry
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        dwg@au1.ibm.com, scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org, alex.williamson@redhat.com
Date: Fri, 21 Oct 2011 13:56:05 -0600
Message-ID: <20111021195605.8438.81609.stgit@s20.home>
In-Reply-To: <20111021195412.8438.9951.stgit@s20.home>
References: <20111021195412.8438.9951.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An IOMMU group is a set of devices for which the IOMMU cannot
distinguish transactions.  For PCI devices, a group often occurs
when a PCI bridge is involved.  Transactions from any device
behind the bridge appear to be sourced from the bridge itself.
We leave it to the IOMMU driver to define the grouping restraints
for their platform.

Using this new interface, the group for a device can be retrieved
using the iommu_device_group() callback.  Users will compare the
value returned against the value returned for other devices to
determine whether they are part of the same group.  Devices with
no group are not translated by the IOMMU.  There should be no
expectations about the group numbers as they may be arbitrarily
assigned by the IOMMU driver and may not be persistent across boots.

We also provide a sysfs interface to the group numbers here so
that userspace can understand IOMMU dependencies between devices
for managing safe, userspace drivers.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/iommu.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h |    7 ++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2fb2963..10615ad 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -25,8 +25,60 @@
 #include <linux/errno.h>
 #include <linux/iommu.h>
 
+static ssize_t show_iommu_group(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	unsigned int groupid;
+
+	if (iommu_device_group(dev, &groupid))
+		return 0;
+
+	return sprintf(buf, "%u", groupid);
+}
+static DEVICE_ATTR(iommu_group, S_IRUGO, show_iommu_group, NULL);
+
+static int add_remove_iommu_group(struct device *dev, void *data)
+{
+	unsigned int groupid;
+	int add = *(int *)data;
+
+	if (iommu_device_group(dev, &groupid) == 0) {
+		if (add)
+			return device_create_file(dev, &dev_attr_iommu_group);
+		else
+			device_remove_file(dev, &dev_attr_iommu_group);
+	}
+
+	return 0;
+}
+
+static int iommu_device_notifier(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	struct device *dev = data;
+	int add;
+
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		add = 1;
+		return add_remove_iommu_group(dev, &add);
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		add = 0;
+		return add_remove_iommu_group(dev, &add);
+	}
+
+	return 0;
+}
+
+static struct notifier_block iommu_device_nb = {
+	.notifier_call = iommu_device_notifier,
+};
+
 static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
 {
+	int add = 1;
+
+	bus_register_notifier(bus, &iommu_device_nb);
+	bus_for_each_dev(bus, NULL, &add, add_remove_iommu_group);
 }
 
 /**
@@ -186,3 +238,12 @@ int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 	return domain->ops->unmap(domain, iova, gfp_order);
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
+
+int iommu_device_group(struct device *dev, unsigned int *groupid)
+{
+	if (iommu_present(dev->bus) && dev->bus->iommu_ops->device_group)
+		return dev->bus->iommu_ops->device_group(dev, groupid);
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(iommu_device_group);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 432acc4..93617e7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -61,6 +61,7 @@ struct iommu_ops {
 				    unsigned long iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
 			      unsigned long cap);
+	int (*device_group)(struct device *dev, unsigned int *groupid);
 };
 
 extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
@@ -81,6 +82,7 @@ extern int iommu_domain_has_cap(struct iommu_domain *domain,
 				unsigned long cap);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
 					iommu_fault_handler_t handler);
+extern int iommu_device_group(struct device *dev, unsigned int *groupid);
 
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
@@ -179,6 +181,11 @@ static inline void iommu_set_fault_handler(struct iommu_domain *domain,
 {
 }
 
+static inline int iommu_device_group(struct device *dev, unsigned int *groupid);
+{
+	return -ENODEV;
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */

