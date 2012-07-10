Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2GJP4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:56:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43454 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2GJP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:56:50 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 13/14] r8169/PCI: use PCIe cap access functions to simplify implementation
Date: Tue, 10 Jul 2012 23:54:14 +0800
Message-Id: <1341935655-5381-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe cap access functions to simplify r8169 driver implementation

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/net/ethernet/realtek/r8169.c |   38 +++++++++++-----------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 9757ce3..c9a7146 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -807,14 +807,11 @@ static void rtl_unlock_work(struct rtl8169_private *tp)
 
 static void rtl_tx_performance_tweak(struct pci_dev *pdev, u16 force)
 {
-	int cap = pci_pcie_cap(pdev);
+	u16 ctl;
 
-	if (cap) {
-		u16 ctl;
-
-		pci_read_config_word(pdev, cap + PCI_EXP_DEVCTL, &ctl);
+	if (!pci_pcie_cap_read_word(pdev, PCI_EXP_DEVCTL, &ctl)) {
 		ctl = (ctl & ~PCI_EXP_DEVCTL_READRQ) | force;
-		pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, ctl);
+		pci_pcie_cap_write_word(pdev, PCI_EXP_DEVCTL, ctl);
 	}
 }
 
@@ -4504,27 +4501,21 @@ static void rtl_ephy_init(void __iomem *ioaddr, const struct ephy_info *e, int l
 
 static void rtl_disable_clock_request(struct pci_dev *pdev)
 {
-	int cap = pci_pcie_cap(pdev);
-
-	if (cap) {
-		u16 ctl;
+	u16 ctl;
 
-		pci_read_config_word(pdev, cap + PCI_EXP_LNKCTL, &ctl);
+	if (!pci_pcie_cap_read_word(pdev, PCI_EXP_LNKCTL, &ctl)) {
 		ctl &= ~PCI_EXP_LNKCTL_CLKREQ_EN;
-		pci_write_config_word(pdev, cap + PCI_EXP_LNKCTL, ctl);
+		pci_pcie_cap_write_word(pdev, PCI_EXP_LNKCTL, ctl);
 	}
 }
 
 static void rtl_enable_clock_request(struct pci_dev *pdev)
 {
-	int cap = pci_pcie_cap(pdev);
-
-	if (cap) {
-		u16 ctl;
+	u16 ctl;
 
-		pci_read_config_word(pdev, cap + PCI_EXP_LNKCTL, &ctl);
+	if (!pci_pcie_cap_read_word(pdev, PCI_EXP_LNKCTL, &ctl)) {
 		ctl |= PCI_EXP_LNKCTL_CLKREQ_EN;
-		pci_write_config_word(pdev, cap + PCI_EXP_LNKCTL, ctl);
+		pci_pcie_cap_write_word(pdev, PCI_EXP_LNKCTL, ctl);
 	}
 }
 
@@ -5132,14 +5123,9 @@ static void rtl_hw_start_8101(struct net_device *dev)
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
+		pci_pcie_cap_write_word(pdev, PCI_EXP_DEVCTL,
+					PCI_EXP_DEVCTL_NOSNOOP_EN);
 
 	RTL_W8(Cfg9346, Cfg9346_Unlock);
 
-- 
1.7.9.5

