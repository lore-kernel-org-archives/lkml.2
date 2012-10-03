Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965455Ab2JCRwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:52:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34371 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965423Ab2JCRwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:52:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>, yuvalmin@broadcom.com,
        bhutchings@solarflare.com, gregory.v.rose@intel.com,
        davem@davemloft.net--no-chain-reply-to,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/5] PCI: Add max_vfs in sysfs per pci device where supports
Date: Wed,  3 Oct 2012 10:51:34 -0700
Message-Id: <1349286695-26713-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349286695-26713-1-git-send-email-yinghai@kernel.org>
References: <506C3B11.9010009@redhat.com>
 <1349286695-26713-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only pci device that support sriov will have max_vfs show up in /sys

when user set value in /sys, driver ops set_max_vfs will be called to enable
VF there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h     |    1 +
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fbbb97f..9b6f409 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -458,6 +458,52 @@ boot_vga_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 struct device_attribute vga_attr = __ATTR_RO(boot_vga);
 
+static ssize_t
+max_vfs_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sprintf(buf, "%u\n", pdev->max_vfs);
+}
+
+static void max_vfs_callback(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	mutex_lock(&pci_remove_rescan_mutex);
+	if (pdev->is_added && dev->driver) {
+		struct pci_driver *pdrv;
+
+		pdrv = to_pci_driver(dev->driver);
+		if (pdrv->set_max_vfs)
+			pdrv->set_max_vfs(pdev);
+
+	}
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
+static ssize_t
+max_vfs_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	unsigned long val;
+	int err;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	pdev->max_vfs = val;
+
+	err = device_schedule_callback(dev, max_vfs_callback);
+
+	if (err)
+		return err;
+
+	return count;
+}
+struct device_attribute max_vfs_attr =
+	__ATTR(max_vfs, 0644, max_vfs_show, max_vfs_store);
+
 static void
 pci_config_pm_runtime_get(struct pci_dev *pdev)
 {
@@ -1405,6 +1451,7 @@ late_initcall(pci_sysfs_init);
 
 static struct attribute *pci_dev_dev_attrs[] = {
 	&vga_attr.attr,
+	&max_vfs_attr.attr,
 	NULL,
 };
 
@@ -1418,6 +1465,10 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
 		if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
 			return 0;
 
+	if (a == &max_vfs_attr.attr)
+		if (!pdev->is_physfn)
+			return 0;
+
 	return a->mode;
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7d70a5e..f7423d4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -335,6 +335,7 @@ struct pci_dev {
 	unsigned int	broken_intx_masking:1;
 	unsigned int	io_window_1k:1;	/* Intel P2P bridge 1K I/O windows */
 	pci_dev_flags_t dev_flags;
+	unsigned int	max_vfs;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
 	u32		saved_config_space[16]; /* config space saved at suspend time */
-- 
1.7.7

