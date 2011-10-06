Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279Ab1JFSIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:08:38 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39673 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965181Ab1JFSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:08:35 -0400
Date: Thu, 6 Oct 2011 14:08:18 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v5)
Message-ID: <20111006180818.GD22462@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
 <20110930143211.5ab39c02@stein>
 <20110930153321.GA31760@hmsreliant.think-freely.org>
 <CAErSpo56QU78RHE0UOcvcT5iwcis1o_Ue=ZLPQ3GhdB483-L4Q@mail.gmail.com>
 <20110930165403.GB31760@hmsreliant.think-freely.org>
 <20111006083607.2c4eb9a5@jbarnes-desktop>
 <20111006171208.GB22462@hmsreliant.think-freely.org>
 <CAErSpo4bEcubO56hZ+PWZc0SdVEroyOmsxDtc_bBAJrxBKmAOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4bEcubO56hZ+PWZc0SdVEroyOmsxDtc_bBAJrxBKmAOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a per-pci-device subdirectory in sysfs called:
/sys/bus/pci/devices/<device>/msi_irqs

This sub-directory exports the set of msi vectors allocated by a given
pci device, by creating a numbered sub-directory for each vector beneath
msi_irqs.  For each vector various attributes can be exported.  Currently the
only attribute is called mode, which tracks the operational mode of that vector
(msi vs. msix)

---

Change Notes:

(v2)
Fixed up Documentation to put new sysfs interface descriptions in the right
place, as per request by Greg K-H

Fixed up oops that resulted from removing pci device.  Not 100% sure I did this
exactly right, but looking at the crash (triggered by echo 1 >
/sys/class/net/eth0/device/remove), it looked as though we were freeing the
pci_dev struct prior to all sysfs objects releasing their use of the device.  AS
such it seemed most appropriate to hold references on the pci_dev for each msi
irq sysfs object that we create, and release them on free accordingly.  With
this change in place, I can remove, and add (via rescan) msi enabled devices
ad-nauseum without a panic.  Again thanks to Greg K-H

(v3)
As per Gregs suggestion, I looked further and noted that in fact, yes, it wasn't
producing any errors on remove, but only because I had a refcounting problem,
and my new sysfs objects were left orphaned with a dangling refcount.  I've
fixed that, added a release method to the new ktype, which now drops the
reference I hold on the pci_dev for us and I've validated that all objects I've
created, along with the parent directory and pci device are cleaned up and freed
by enabling the kobject dyanic_debug set and observing the appropriate release
calls.  I can provide the logs if anyone wants to review them specifically.

(v4)
Fixed up some spelling mistakes, and added a scissors line with a good
commitlog, so that git-am drops all the version logging

(v5)
Repost for Jesse with typo corrected

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org
---
 Documentation/ABI/testing/sysfs-bus-pci |   18 +++++
 drivers/pci/msi.c                       |  111 +++++++++++++++++++++++++++++++
 include/linux/msi.h                     |    3 +
 include/linux/pci.h                     |    1 +
 4 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 349ecf2..2e445b7 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -66,6 +66,24 @@ Description:
 		re-discover previously removed devices.
 		Depends on CONFIG_HOTPLUG.
 
+What:		/sys/bus/pci/devices/.../msi_irqs/
+Date:		September, 2011
+Contact:	Neil Horman <nhorman@tuxdriver.com>
+Description:
+		The /sys/devices/.../msi_irqs directory contains a variable set
+		of sub-directories, with each sub-directory being named after a
+		corresponding msi irq vector allocated to that device.  Each
+		numbered sub-directory N contains attributes of that irq.
+		Note that this directory is not created for device drivers which
+		do not support msi irqs
+
+What:		/sys/bus/pci/devices/.../msi_irqs/<N>/mode
+Date:		September 2011
+Contact:	Neil Horman <nhorman@tuxdriver.com>
+Description:
+		This attribute indicates the mode that the irq vector named by
+		the parent directory is in (msi vs. msix)
+
 What:		/sys/bus/pci/devices/.../remove
 Date:		January 2009
 Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 2f10328..73613e2 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -322,6 +322,8 @@ static void free_msi_irqs(struct pci_dev *dev)
 			if (list_is_last(&entry->list, &dev->msi_list))
 				iounmap(entry->mask_base);
 		}
+		kobject_del(&entry->kobj);
+		kobject_put(&entry->kobj);
 		list_del(&entry->list);
 		kfree(entry);
 	}
@@ -402,6 +404,98 @@ void pci_restore_msi_state(struct pci_dev *dev)
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
+void msi_kobj_release(struct kobject *kobj)
+{
+	struct msi_desc *entry = to_msi_desc(kobj);
+
+	pci_dev_put(entry->dev);
+}
+
+static struct kobj_type msi_irq_ktype = {
+	.release = msi_kobj_release,
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
+		pci_dev_get(pdev);
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
+		kobject_del(&entry->kobj);
+		kobject_put(&entry->kobj);
+		count--;
+	}
+	return ret;
+}
+
 /**
  * msi_capability_init - configure device's MSI capability structure
  * @dev: pointer to the pci_dev data structure of MSI device function
@@ -453,6 +547,13 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
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
@@ -573,6 +674,12 @@ static int msix_capability_init(struct pci_dev *dev,
 
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
@@ -731,6 +838,8 @@ void pci_disable_msi(struct pci_dev *dev)
 
 	pci_msi_shutdown(dev);
 	free_msi_irqs(dev);
+	kset_unregister(dev->msi_kset);
+	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msi);
 
@@ -829,6 +938,8 @@ void pci_disable_msix(struct pci_dev *dev)
 
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
1.7.6.2


