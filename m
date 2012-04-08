Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2DHRPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 13:15:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2DHRPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 13:15:35 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/2] PCI, ACPI, x86: update MMCFG information when hot-plugging PCI host bridges
Date: Mon,  9 Apr 2012 01:12:09 +0800
Message-Id: <1333905129-8776-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
References: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <20120406115948.3536e6c8.izumi.taku@jp.fujitsu.com>
References: <20120406115948.3536e6c8.izumi.taku@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances pci_root driver to update MMCFG information when
hot-plugging PCI root bridges on x86 platforms.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/x86/pci/acpi.c      |   58 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/pci_root.c  |   20 ++++++++++++++++
 include/acpi/acnames.h   |    1 +
 include/linux/pci-acpi.h |    3 ++
 4 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index da0149d..9184970 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -488,6 +488,64 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	return bus;
 }
 
+int arch_acpi_pci_root_add(struct acpi_pci_root *root)
+{
+	int result = 0;
+	acpi_status status;
+	unsigned long long base_addr;
+	struct pci_mmcfg_region *cfg;
+
+	/*
+	 * Try to insert MMCFG information for host bridges with _CBA method
+	 */
+	status = acpi_evaluate_integer(root->device->handle, METHOD_NAME__CBA,
+				       NULL, &base_addr);
+	if (ACPI_SUCCESS(status)) {
+		result = pci_mmconfig_insert(root->segment,
+					     root->secondary.start,
+					     root->secondary.end,
+					     base_addr);
+		/*
+		 * MMCFG information for hot-pluggable host bridges may have
+		 * already been added by __pci_mmcfg_init();
+		 */
+		if (result == -EEXIST)
+			result = 0;
+	} else if (status == AE_NOT_FOUND) {
+		/*
+		 * Check whether MMCFG information has been added for
+		 * host bridges without _CBA method.
+		 */
+		rcu_read_lock();
+		cfg = pci_mmconfig_lookup(root->segment, root->secondary.start);
+		if (!cfg || cfg->end_bus < root->secondary.end)
+			result = -ENODEV;
+		rcu_read_unlock();
+	} else
+		result = -ENODEV;
+
+	return result;
+}
+
+int arch_acpi_pci_root_remove(struct acpi_pci_root *root)
+{
+	acpi_status status;
+	unsigned long long base_addr;
+
+	/* Remove MMCFG information for host bridges with _CBA method */
+	status = acpi_evaluate_integer(root->device->handle, METHOD_NAME__CBA,
+				       NULL, &base_addr);
+	if (ACPI_SUCCESS(status))
+		return pci_mmconfig_delete(root->segment,
+					   root->secondary.start,
+					   root->secondary.end,
+					   base_addr);
+	else if (status != AE_NOT_FOUND)
+		return -ENODEV;
+
+	return 0;
+}
+
 int __init pci_acpi_init(void)
 {
 	struct pci_dev *dev = NULL;
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 4a7d575..a62bfa8 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -448,6 +448,16 @@ out:
 }
 EXPORT_SYMBOL(acpi_pci_osc_control_set);
 
+int __weak arch_acpi_pci_root_add(struct acpi_pci_root *root)
+{
+	return 0;
+}
+
+int __weak arch_acpi_pci_root_remove(struct acpi_pci_root *root)
+{
+	return 0;
+}
+
 static int __devinit acpi_pci_root_add(struct acpi_device *device)
 {
 	unsigned long long segment, bus;
@@ -504,6 +514,14 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
 	device->driver_data = root;
 
+	if (arch_acpi_pci_root_add(root)) {
+		printk(KERN_ERR PREFIX
+			"can't add MMCFG information for Bus %04x:%02x\n",
+			root->segment, (unsigned int)root->secondary.start);
+		result = -ENODEV;
+		goto out_free;
+	}
+
 	/*
 	 * All supported architectures that use ACPI have support for
 	 * PCI domains, so we indicate this in _OSC support capabilities.
@@ -629,6 +647,7 @@ out_del_root:
 	list_del_rcu(&root->node);
 	mutex_unlock(&acpi_pci_root_lock);
 	synchronize_rcu();
+	arch_acpi_pci_root_remove(root);
 out_free:
 	kfree(root);
 	return result;
@@ -679,6 +698,7 @@ out:
 	list_del_rcu(&root->node);
 	mutex_unlock(&acpi_pci_root_lock);
 	synchronize_rcu();
+	arch_acpi_pci_root_remove(root);
 	kfree(root);
 
 	return 0;
diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index 38f5088..99bda75 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -62,6 +62,7 @@
 #define METHOD_NAME__AEI        "_AEI"
 #define METHOD_NAME__PRW        "_PRW"
 #define METHOD_NAME__SRS        "_SRS"
+#define METHOD_NAME__CBA	"_CBA"
 
 /* Method names - these methods must appear at the namespace root */
 
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index ac93634..816b971 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -38,6 +38,9 @@ static inline acpi_handle acpi_pci_get_bridge_handle(struct pci_bus *pbus)
 
 void acpi_pci_root_rescan(void);
 
+extern int arch_acpi_pci_root_add(struct acpi_pci_root *root);
+extern int arch_acpi_pci_root_remove(struct acpi_pci_root *root);
+
 #else
 
 static inline void acpi_pci_root_rescan(void) { }
-- 
1.7.5.4

