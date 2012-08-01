Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2HAP4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:56:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57673 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2HAP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:56:20 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 07/32] PCI/portdrv: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:12 +0800
Message-Id: <1343836477-7287-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe portdrv implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/portdrv_core.c |   15 +++++----------
 drivers/pci/pcie/portdrv_pci.c  |   10 ++--------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index bf320a9..274d524 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -246,8 +246,7 @@ static void cleanup_service_irqs(struct pci_dev *dev)
  */
 static int get_port_device_capability(struct pci_dev *dev)
 {
-	int services = 0, pos;
-	u16 reg16;
+	int services = 0;
 	u32 reg32;
 	int cap_mask = 0;
 	int err;
@@ -265,11 +264,9 @@ static int get_port_device_capability(struct pci_dev *dev)
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
@@ -277,10 +274,8 @@ static int get_port_device_capability(struct pci_dev *dev)
 			 * enabled by the BIOS and the hot-plug service driver
 			 * is not loaded.
 			 */
-			pos += PCI_EXP_SLTCTL;
-			pci_read_config_word(dev, pos, &reg16);
-			reg16 &= ~(PCI_EXP_SLTCTL_CCIE | PCI_EXP_SLTCTL_HPIE);
-			pci_write_config_word(dev, pos, reg16);
+			pci_pcie_capability_change_word(dev, PCI_EXP_SLTCTL,
+				0, PCI_EXP_SLTCTL_CCIE | PCI_EXP_SLTCTL_HPIE);
 		}
 	}
 	/* AER capable */
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 24d1463..93f726c 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -64,14 +64,8 @@ __setup("pcie_ports=", pcie_port_setup);
  */
 void pcie_clear_root_pme_status(struct pci_dev *dev)
 {
-	int rtsta_pos;
-	u32 rtsta;
-
-	rtsta_pos = pci_pcie_cap(dev) + PCI_EXP_RTSTA;
-
-	pci_read_config_dword(dev, rtsta_pos, &rtsta);
-	rtsta |= PCI_EXP_RTSTA_PME;
-	pci_write_config_dword(dev, rtsta_pos, rtsta);
+	pci_pcie_capability_change_dword(dev, PCI_EXP_RTSTA,
+					 PCI_EXP_RTSTA_PME, 0);
 }
 
 static int pcie_portdrv_restore_config(struct pci_dev *dev)
-- 
1.7.9.5

