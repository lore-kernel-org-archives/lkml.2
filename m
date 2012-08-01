Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2HAP5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:57:40 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56250 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2HAP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:57:37 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 15/32] PCI/r8169: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:20 +0800
Message-Id: <1343836477-7287-16-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify r8169 driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/net/ethernet/realtek/r8169.c |   44 +++++++---------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 9757ce3..d575fbf 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -807,15 +807,8 @@ static void rtl_unlock_work(struct rtl8169_private *tp)
 
 static void rtl_tx_performance_tweak(struct pci_dev *pdev, u16 force)
 {
-	int cap = pci_pcie_cap(pdev);
-
-	if (cap) {
-		u16 ctl;
-
-		pci_read_config_word(pdev, cap + PCI_EXP_DEVCTL, &ctl);
-		ctl = (ctl & ~PCI_EXP_DEVCTL_READRQ) | force;
-		pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, ctl);
-	}
+	pci_pcie_capability_change_word(pdev, PCI_EXP_DEVCTL,
+		force, PCI_EXP_DEVCTL_READRQ);
 }
 
 static u32 ocp_read(struct rtl8169_private *tp, u8 mask, u16 reg)
@@ -4504,28 +4497,14 @@ static void rtl_ephy_init(void __iomem *ioaddr, const struct ephy_info *e, int l
 
 static void rtl_disable_clock_request(struct pci_dev *pdev)
 {
-	int cap = pci_pcie_cap(pdev);
-
-	if (cap) {
-		u16 ctl;
-
-		pci_read_config_word(pdev, cap + PCI_EXP_LNKCTL, &ctl);
-		ctl &= ~PCI_EXP_LNKCTL_CLKREQ_EN;
-		pci_write_config_word(pdev, cap + PCI_EXP_LNKCTL, ctl);
-	}
+	pci_pcie_capability_change_word(pdev, PCI_EXP_LNKCTL,
+					0, PCI_EXP_LNKCTL_CLKREQ_EN);
 }
 
 static void rtl_enable_clock_request(struct pci_dev *pdev)
 {
-	int cap = pci_pcie_cap(pdev);
-
-	if (cap) {
-		u16 ctl;
-
-		pci_read_config_word(pdev, cap + PCI_EXP_LNKCTL, &ctl);
-		ctl |= PCI_EXP_LNKCTL_CLKREQ_EN;
-		pci_write_config_word(pdev, cap + PCI_EXP_LNKCTL, ctl);
-	}
+	pci_pcie_capability_change_word(pdev, PCI_EXP_LNKCTL,
+					PCI_EXP_LNKCTL_CLKREQ_EN, 0);
 }
 
 #define R8168_CPCMD_QUIRK_MASK (\
@@ -5132,14 +5111,9 @@ static void rtl_hw_start_8101(struct net_device *dev)
 		tp->event_slow &= ~RxFIFOOver;
 
 	if (tp->mac_version == RTL_GIGA_MAC_VER_13 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_16) {
-		int cap = pci_pcie_cap(pdev);
-
-		if (cap) {
-			pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL,
-					      PCI_EXP_DEVCTL_NOSNOOP_EN);
-		}
-	}
+	    tp->mac_version == RTL_GIGA_MAC_VER_16)
+		pci_pcie_capability_write_word(pdev, PCI_EXP_DEVCTL,
+					       PCI_EXP_DEVCTL_NOSNOOP_EN);
 
 	RTL_W8(Cfg9346, Cfg9346_Unlock);
 
-- 
1.7.9.5

