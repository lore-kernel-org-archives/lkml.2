Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2HAP4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:56:34 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57673 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2HAP42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:56:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 08/32] PCI/pciehp: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:13 +0800
Message-Id: <1343836477-7287-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify pciehp implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/pciehp_acpi.c |    6 +-----
 drivers/pci/hotplug/pciehp_hpc.c  |   12 ++++--------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_acpi.c b/drivers/pci/hotplug/pciehp_acpi.c
index 376d70d..751b41c 100644
--- a/drivers/pci/hotplug/pciehp_acpi.c
+++ b/drivers/pci/hotplug/pciehp_acpi.c
@@ -81,16 +81,12 @@ static struct list_head __initdata dummy_slots = LIST_HEAD_INIT(dummy_slots);
 /* Dummy driver for dumplicate name detection */
 static int __init dummy_probe(struct pcie_device *dev)
 {
-	int pos;
 	u32 slot_cap;
 	acpi_handle handle;
 	struct dummy_slot *slot, *tmp;
 	struct pci_dev *pdev = dev->port;
 
-	pos = pci_pcie_cap(pdev);
-	if (!pos)
-		return -ENODEV;
-	pci_read_config_dword(pdev, pos + PCI_EXP_SLTCAP, &slot_cap);
+	pci_pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP, &slot_cap);
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot)
 		return -ENOMEM;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 302451e..cf0daf1 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -44,25 +44,25 @@
 static inline int pciehp_readw(struct controller *ctrl, int reg, u16 *value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
-	return pci_read_config_word(dev, pci_pcie_cap(dev) + reg, value);
+	return pci_pcie_capability_read_word(dev, reg, value);
 }
 
 static inline int pciehp_readl(struct controller *ctrl, int reg, u32 *value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
-	return pci_read_config_dword(dev, pci_pcie_cap(dev) + reg, value);
+	return pci_pcie_capability_read_dword(dev, reg, value);
 }
 
 static inline int pciehp_writew(struct controller *ctrl, int reg, u16 value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
-	return pci_write_config_word(dev, pci_pcie_cap(dev) + reg, value);
+	return pci_pcie_capability_write_word(dev, reg, value);
 }
 
 static inline int pciehp_writel(struct controller *ctrl, int reg, u32 value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
-	return pci_write_config_dword(dev, pci_pcie_cap(dev) + reg, value);
+	return pci_pcie_capability_write_dword(dev, reg, value);
 }
 
 /* Power Control Command */
@@ -855,10 +855,6 @@ struct controller *pcie_init(struct pcie_device *dev)
 		goto abort;
 	}
 	ctrl->pcie = dev;
-	if (!pci_pcie_cap(pdev)) {
-		ctrl_err(ctrl, "Cannot find PCI Express capability\n");
-		goto abort_ctrl;
-	}
 	if (pciehp_readl(ctrl, PCI_EXP_SLTCAP, &slot_cap)) {
 		ctrl_err(ctrl, "Cannot read SLOTCAP register\n");
 		goto abort_ctrl;
-- 
1.7.9.5

