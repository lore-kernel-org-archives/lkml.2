Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2GJP4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:56:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43454 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GJP4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:56:11 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 09/14] pciehp/PCI: use PCIe cap access functions to simplify implementation
Date: Tue, 10 Jul 2012 23:54:10 +0800
Message-Id: <1341935655-5381-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe cap access functions to simplify PCIe hotplug implementation

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/pciehp_acpi.c |    5 +----
 drivers/pci/hotplug/pciehp_hpc.c  |    8 ++++----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_acpi.c b/drivers/pci/hotplug/pciehp_acpi.c
index 376d70d..6b60301 100644
--- a/drivers/pci/hotplug/pciehp_acpi.c
+++ b/drivers/pci/hotplug/pciehp_acpi.c
@@ -81,16 +81,13 @@ static struct list_head __initdata dummy_slots = LIST_HEAD_INIT(dummy_slots);
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
+	if (pci_pcie_cap_read_dword(pdev, PCI_EXP_SLTCAP, &slot_cap))
 		return -ENODEV;
-	pci_read_config_dword(pdev, pos + PCI_EXP_SLTCAP, &slot_cap);
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot)
 		return -ENOMEM;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index a960fae..d184754 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -44,25 +44,25 @@
 static inline int pciehp_readw(struct controller *ctrl, int reg, u16 *value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
-	return pci_read_config_word(dev, pci_pcie_cap(dev) + reg, value);
+	return pci_pcie_cap_read_word(dev, reg, value);
 }
 
 static inline int pciehp_readl(struct controller *ctrl, int reg, u32 *value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
-	return pci_read_config_dword(dev, pci_pcie_cap(dev) + reg, value);
+	return pci_pcie_cap_read_dword(dev, reg, value);
 }
 
 static inline int pciehp_writew(struct controller *ctrl, int reg, u16 value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
-	return pci_write_config_word(dev, pci_pcie_cap(dev) + reg, value);
+	return pci_pcie_cap_write_word(dev, reg, value);
 }
 
 static inline int pciehp_writel(struct controller *ctrl, int reg, u32 value)
 {
 	struct pci_dev *dev = ctrl->pcie->port;
-	return pci_write_config_dword(dev, pci_pcie_cap(dev) + reg, value);
+	return pci_pcie_cap_write_dword(dev, reg, value);
 }
 
 /* Power Control Command */
-- 
1.7.9.5

