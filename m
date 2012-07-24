Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2GXQea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:34:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39041 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2GXQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:34:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 07/32] PCI/portdrv: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:19 +0800
Message-Id: <1343147504-25891-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe portdrv implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/portdrv_core.c |   20 ++++++++------------
 drivers/pci/pcie/portdrv_pci.c  |    7 ++-----
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index bf320a9..37bff83 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -76,7 +76,6 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
 	struct msix_entry *msix_entries;
 	int idx[PCIE_PORT_DEVICE_MAXSERVICES];
 	int nr_entries, status, pos, i, nvec;
-	u16 reg16;
 	u32 reg32;
 
 	nr_entries = pci_msix_table_size(dev);
@@ -120,9 +119,7 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
 		 * the value in this field indicates which MSI-X Table entry is
 		 * used to generate the interrupt message."
 		 */
-		pos = pci_pcie_cap(dev);
-		pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &reg16);
-		entry = (reg16 & PCI_EXP_FLAGS_IRQ) >> 9;
+		entry = (dev->pcie_flags_reg & PCI_EXP_FLAGS_IRQ) >> 9;
 		if (entry >= nr_entries)
 			goto Error;
 
@@ -246,7 +243,7 @@ static void cleanup_service_irqs(struct pci_dev *dev)
  */
 static int get_port_device_capability(struct pci_dev *dev)
 {
-	int services = 0, pos;
+	int services = 0;
 	u16 reg16;
 	u32 reg32;
 	int cap_mask = 0;
@@ -265,11 +262,9 @@ static int get_port_device_capability(struct pci_dev *dev)
 			return 0;
 	}
 
-	pos = pci_pcie_cap(dev);
-	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &reg16);
 	/* Hot-Plug Capable */
-	if ((cap_mask & PCIE_PORT_SERVICE_HP) && (reg16 & PCI_EXP_FLAGS_SLOT)) {
-		pci_read_config_dword(dev, pos + PCI_EXP_SLTCAP, &reg32);
+	if ((cap_mask & PCIE_PORT_SERVICE_HP)) {
+		pci_pcie_capability_read_dword(dev, PCI_EXP_SLTCAP, &reg32);
 		if (reg32 & PCI_EXP_SLTCAP_HPC) {
 			services |= PCIE_PORT_SERVICE_HP;
 			/*
@@ -277,10 +272,11 @@ static int get_port_device_capability(struct pci_dev *dev)
 			 * enabled by the BIOS and the hot-plug service driver
 			 * is not loaded.
 			 */
-			pos += PCI_EXP_SLTCTL;
-			pci_read_config_word(dev, pos, &reg16);
+			pci_pcie_capability_read_word(dev,
+						      PCI_EXP_SLTCTL, &reg16);
 			reg16 &= ~(PCI_EXP_SLTCTL_CCIE | PCI_EXP_SLTCTL_HPIE);
-			pci_write_config_word(dev, pos, reg16);
+			pci_pcie_capability_write_word(dev,
+						       PCI_EXP_SLTCTL, reg16);
 		}
 	}
 	/* AER capable */
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 24d1463..1b2b378 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -64,14 +64,11 @@ __setup("pcie_ports=", pcie_port_setup);
  */
 void pcie_clear_root_pme_status(struct pci_dev *dev)
 {
-	int rtsta_pos;
 	u32 rtsta;
 
-	rtsta_pos = pci_pcie_cap(dev) + PCI_EXP_RTSTA;
-
-	pci_read_config_dword(dev, rtsta_pos, &rtsta);
+	pci_pcie_capability_read_dword(dev, PCI_EXP_RTSTA, &rtsta);
 	rtsta |= PCI_EXP_RTSTA_PME;
-	pci_write_config_dword(dev, rtsta_pos, rtsta);
+	pci_pcie_capability_write_dword(dev, PCI_EXP_RTSTA, rtsta);
 }
 
 static int pcie_portdrv_restore_config(struct pci_dev *dev)
-- 
1.7.9.5

