Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2GXQgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:36:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50543 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2GXQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:36:08 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 17/32] PCI/igb: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:29 +0800
Message-Id: <1343147504-25891-18-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify Intel ethernet drivers'
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   20 ++++++++------------
 drivers/net/ethernet/intel/igb/igb_main.c  |   12 ++++--------
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a4b0435..180a795 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5582,16 +5582,15 @@ static void e1000_complete_shutdown(struct pci_dev *pdev, bool sleep,
 	 */
 	if (adapter->flags & FLAG_IS_QUAD_PORT) {
 		struct pci_dev *us_dev = pdev->bus->self;
-		int pos = pci_pcie_cap(us_dev);
 		u16 devctl;
 
-		pci_read_config_word(us_dev, pos + PCI_EXP_DEVCTL, &devctl);
-		pci_write_config_word(us_dev, pos + PCI_EXP_DEVCTL,
-		                      (devctl & ~PCI_EXP_DEVCTL_CERE));
+		pci_pcie_capability_read_word(us_dev, PCI_EXP_DEVCTL, &devctl);
+		pci_pcie_capability_write_word(us_dev, PCI_EXP_DEVCTL,
+					       (devctl & ~PCI_EXP_DEVCTL_CERE));
 
 		e1000_power_off(pdev, sleep, wake);
 
-		pci_write_config_word(us_dev, pos + PCI_EXP_DEVCTL, devctl);
+		pci_pcie_capability_write_word(us_dev, PCI_EXP_DEVCTL, devctl);
 	} else {
 		e1000_power_off(pdev, sleep, wake);
 	}
@@ -5605,25 +5604,22 @@ static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
 #else
 static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
 {
-	int pos;
 	u16 reg16;
 
 	/*
 	 * Both device and parent should have the same ASPM setting.
 	 * Disable ASPM in downstream component first and then upstream.
 	 */
-	pos = pci_pcie_cap(pdev);
-	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
+	pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &reg16);
 	reg16 &= ~state;
-	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
+	pci_pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, reg16);
 
 	if (!pdev->bus->self)
 		return;
 
-	pos = pci_pcie_cap(pdev->bus->self);
-	pci_read_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, &reg16);
+	pci_pcie_capability_read_word(pdev->bus->self, PCI_EXP_LNKCTL, &reg16);
 	reg16 &= ~state;
-	pci_write_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, reg16);
+	pci_pcie_capability_write_word(pdev->bus->self, PCI_EXP_LNKCTL, reg16);
 }
 #endif
 static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index dd3bfe8..ef28e32 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6446,13 +6446,11 @@ static int igb_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 s32 igb_read_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value)
 {
 	struct igb_adapter *adapter = hw->back;
-	u16 cap_offset;
 
-	cap_offset = adapter->pdev->pcie_cap;
-	if (!cap_offset)
+	if (!pci_is_pcie(adapter->pdev))
 		return -E1000_ERR_CONFIG;
 
-	pci_read_config_word(adapter->pdev, cap_offset + reg, value);
+	pci_pcie_capability_read_word(adapter->pdev, reg, value);
 
 	return 0;
 }
@@ -6460,13 +6458,11 @@ s32 igb_read_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value)
 s32 igb_write_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value)
 {
 	struct igb_adapter *adapter = hw->back;
-	u16 cap_offset;
 
-	cap_offset = adapter->pdev->pcie_cap;
-	if (!cap_offset)
+	if (!pci_is_pcie(adapter->pdev))
 		return -E1000_ERR_CONFIG;
 
-	pci_write_config_word(adapter->pdev, cap_offset + reg, *value);
+	pci_pcie_capability_write_word(adapter->pdev, reg, *value);
 
 	return 0;
 }
-- 
1.7.9.5

