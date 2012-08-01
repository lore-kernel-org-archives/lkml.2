Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2HAP6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:58:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2HAP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:58:01 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 17/32] PCI/igb: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:22 +0800
Message-Id: <1343836477-7287-18-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify Intel ethernet drivers'
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   27 ++++++++-------------------
 drivers/net/ethernet/intel/igb/igb_main.c  |   12 ++----------
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a4b0435..30b647f 100644
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
@@ -5605,25 +5604,15 @@ static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
 #else
 static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
 {
-	int pos;
-	u16 reg16;
-
 	/*
 	 * Both device and parent should have the same ASPM setting.
 	 * Disable ASPM in downstream component first and then upstream.
 	 */
-	pos = pci_pcie_cap(pdev);
-	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
-	reg16 &= ~state;
-	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
-
-	if (!pdev->bus->self)
-		return;
+	pci_pcie_capability_change_word(pdev, PCI_EXP_LNKCTL, 0, state);
 
-	pos = pci_pcie_cap(pdev->bus->self);
-	pci_read_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, &reg16);
-	reg16 &= ~state;
-	pci_write_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, reg16);
+	if (pdev->bus->self)
+		pci_pcie_capability_change_word(pdev->bus->self, PCI_EXP_LNKCTL,
+						0, state);
 }
 #endif
 static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index dd3bfe8..3d46830 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6446,28 +6446,20 @@ static int igb_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 s32 igb_read_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value)
 {
 	struct igb_adapter *adapter = hw->back;
-	u16 cap_offset;
 
-	cap_offset = adapter->pdev->pcie_cap;
-	if (!cap_offset)
+	if (pci_pcie_capability_read_word(adapter->pdev, reg, value))
 		return -E1000_ERR_CONFIG;
 
-	pci_read_config_word(adapter->pdev, cap_offset + reg, value);
-
 	return 0;
 }
 
 s32 igb_write_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value)
 {
 	struct igb_adapter *adapter = hw->back;
-	u16 cap_offset;
 
-	cap_offset = adapter->pdev->pcie_cap;
-	if (!cap_offset)
+	if (pci_pcie_capability_write_word(adapter->pdev, reg, *value))
 		return -E1000_ERR_CONFIG;
 
-	pci_write_config_word(adapter->pdev, cap_offset + reg, *value);
-
 	return 0;
 }
 
-- 
1.7.9.5

