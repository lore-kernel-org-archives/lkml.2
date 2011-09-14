Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab1INShR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:37:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53184 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab1INShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:37:15 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] sysfs: add per pci device msi[x] irq listing
Date: Wed, 14 Sep 2011 14:36:53 -0400
Message-Id: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.7.6
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So a while back, I wanted to provide a way for irqbalance (and other apps) to
definitively map irqs to devices, which, for msi[x] irqs is currently not really
possible in user space.  My first attempt wen't not so well:
https://lkml.org/lkml/2011/4/21/308

It was plauged by the same issues that prior attempts were, namely that it
violated the one-file-one-value sysfs rule.  I wandered off but have recently
come back to this.  I've got a new implementation here that exports a new
subdirectory for every pci device,  called msi_irqs.  This subdirectory contanis
a variable number of numbered subdirectories, in which the number represents an
msi irq.  Each numbered subdirectory contains attributes for that irq, which
currently is only the mode it is operating in (msi vs. msix).  I think fits
within the constraints sysfs requires, and will allow irqbalance to properly map
msi irqs to devices without have to rely on rickety, best guess methods like
interface name matching.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 Documentation/ABI/testing/sysfs-devices-msi_irqs |   17 ++++
 drivers/pci/msi.c                                |  100 ++++++++++++++++++++++
 include/linux/msi.h                              |    3 +
 include/linux/pci.h                              |    1 +
 4 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-msi_irqs

diff --git a/Documentation/ABI/testing/sysfs-devices-msi_irqs b/Documentation/ABI/testing/sysfs-devices-msi_irqs
new file mode 100644
index 0000000..dab3a52
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-msi_irqs
@@ -0,0 +1,17 @@
+What:		/sys/devices/.../power/
+Date:		September, 2011
+Contact:	Neil Horman <nhorman@tuxdriver.com>
+Description:
+		The /sys/devices/.../msi_irqs directory contains a variable set
+		subdirectories, with each subdirectory being named after a
+		corresponding msi irq vector allocated to that device.  Each
+		numbered subdirectory N contains attributes of that irq.
+		Note that this directory is not created for device drivers which
+		do not support msi irqs
+
+What:		/sys/devices/.../msi_irqs/<N>/mode
+Date:		September 2011
+Contact:	Neil Horman <nhorman@tuxdriver.com>
+Description:
+		This attribute indicates the mode that the irq vecotor named by
+		the parent directory is in (msi vs. msix)
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 2f10328..3eaf2c0 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -322,6 +322,7 @@ static void free_msi_irqs(struct pci_dev *dev)
 			if (list_is_last(&entry->list, &dev->msi_list))
 				iounmap(entry->mask_base);
 		}
+		kobject_put(&entry->kobj);
 		list_del(&entry->list);
 		kfree(entry);
 	}
@@ -402,6 +403,88 @@ void pci_restore_msi_state(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_restore_msi_state);
 
+
+#define to_msi_attr(obj) container_of(obj, struct msi_attribute, attr)
+#define to_msi_desc(obj) container_of(obj, struct msi_desc, kobj)
+
+struct msi_attribute {
+	struct attribute        attr;
+	ssize_t (*show)(struct msi_desc *entry, struct msi_attribute *attr,
+			char *buf);
+	ssize_t (*store)(struct msi_desc *entry, struct msi_attribute *attr,
+			 const char *buf, size_t count);
+};
+
+static ssize_t show_msi_mode(struct msi_desc *entry, struct msi_attribute *atr,
+			     char *buf)
+{
+	return sprintf(buf, "%s\n", entry->msi_attrib.is_msix ? "msix" : "msi");
+}
+
+static ssize_t msi_irq_attr_show(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
+{
+	struct msi_attribute *attribute = to_msi_attr(attr);
+	struct msi_desc *entry = to_msi_desc(kobj);
+
+	if (!attribute->show)
+		return -EIO;
+
+	return attribute->show(entry, attribute, buf);
+}
+
+static const struct sysfs_ops msi_irq_sysfs_ops = {
+	.show = msi_irq_attr_show,
+};
+
+static struct msi_attribute mode_attribute =
+	__ATTR(mode, S_IRUGO, show_msi_mode, NULL);
+
+
+struct attribute *msi_irq_default_attrs[] = {
+	&mode_attribute.attr,
+	NULL
+};
+
+static struct kobj_type msi_irq_ktype = {
+	.sysfs_ops = &msi_irq_sysfs_ops,
+	.default_attrs = msi_irq_default_attrs,
+};
+
+static int populate_msi_sysfs(struct pci_dev *pdev)
+{
+	struct msi_desc *entry;
+	struct kobject *kobj;
+	int ret;
+	int count = 0;
+
+	pdev->msi_kset = kset_create_and_add("msi_irqs", NULL, &pdev->dev.kobj);
+	if (!pdev->msi_kset)
+		return -ENOMEM;
+
+	list_for_each_entry(entry, &pdev->msi_list, list) {
+		kobj = &entry->kobj;
+		kobj->kset = pdev->msi_kset;
+		ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
+				     "%u", entry->irq);
+		if (ret)
+			goto out_unroll;
+
+		count++;
+	}
+
+	return 0;
+
+out_unroll:
+	list_for_each_entry(entry, &pdev->msi_list, list) {
+		if (!count)
+			break;
+		kobject_put(&entry->kobj);
+		count--;
+	}
+	return ret;
+}
+
 /**
  * msi_capability_init - configure device's MSI capability structure
  * @dev: pointer to the pci_dev data structure of MSI device function
@@ -453,6 +536,13 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 		return ret;
 	}
 
+	ret = populate_msi_sysfs(dev);
+	if (ret) {
+		msi_mask_irq(entry, mask, ~mask);
+		free_msi_irqs(dev);
+		return ret;
+	}
+
 	/* Set MSI enabled bits	 */
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, pos, 1);
@@ -573,6 +663,12 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	msix_program_entries(dev, entries);
 
+	ret = populate_msi_sysfs(dev);
+	if (ret) {
+		ret = 0;
+		goto error;
+	}
+
 	/* Set MSI-X enabled bits and unmask the function */
 	pci_intx_for_msi(dev, 0);
 	dev->msix_enabled = 1;
@@ -731,6 +827,8 @@ void pci_disable_msi(struct pci_dev *dev)
 
 	pci_msi_shutdown(dev);
 	free_msi_irqs(dev);
+	kset_unregister(dev->msi_kset);
+	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msi);
 
@@ -829,6 +927,8 @@ void pci_disable_msix(struct pci_dev *dev)
 
 	pci_msix_shutdown(dev);
 	free_msi_irqs(dev);
+	kset_unregister(dev->msi_kset);
+	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msix);
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 05acced..ce93a34 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -1,6 +1,7 @@
 #ifndef LINUX_MSI_H
 #define LINUX_MSI_H
 
+#include <linux/kobject.h>
 #include <linux/list.h>
 
 struct msi_msg {
@@ -44,6 +45,8 @@ struct msi_desc {
 
 	/* Last set MSI message */
 	struct msi_msg msg;
+
+	struct kobject kobj;
 };
 
 /*
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f27893b..fff3961 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -332,6 +332,7 @@ struct pci_dev {
 	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
+	struct kset *msi_kset;
 #endif
 	struct pci_vpd *vpd;
 #ifdef CONFIG_PCI_IOV
-- 
1.7.6

