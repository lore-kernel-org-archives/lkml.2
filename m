Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2HAP6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:58:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab2HAP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:58:49 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Divy Le Ray <divy@chelsio.com>, Dimitris Michailidis <dm@chelsio.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 22/32] PCI/chelsio: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:27 +0800
Message-Id: <1343836477-7287-23-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify chelsio ethernet drivers'
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c      |   19 +++++++------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |   11 ++---------
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      |   10 +++-------
 3 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index 44ac2f4..8fadbb3 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -3289,22 +3289,18 @@ static void config_pcie(struct adapter *adap)
 	unsigned int log2_width, pldsize;
 	unsigned int fst_trn_rx, fst_trn_tx, acklat, rpllmt;
 
-	pci_read_config_word(adap->pdev,
-			     adap->pdev->pcie_cap + PCI_EXP_DEVCTL,
-			     &val);
+	pci_pcie_capability_read_word(adap->pdev, PCI_EXP_DEVCTL, &val);
 	pldsize = (val & PCI_EXP_DEVCTL_PAYLOAD) >> 5;
 
 	pci_read_config_word(adap->pdev, 0x2, &devid);
 	if (devid == 0x37) {
-		pci_write_config_word(adap->pdev,
-				      adap->pdev->pcie_cap + PCI_EXP_DEVCTL,
+		pci_pcie_capability_write_word(adap->pdev, PCI_EXP_DEVCTL,
 				      val & ~PCI_EXP_DEVCTL_READRQ &
 				      ~PCI_EXP_DEVCTL_PAYLOAD);
 		pldsize = 0;
 	}
 
-	pci_read_config_word(adap->pdev, adap->pdev->pcie_cap + PCI_EXP_LNKCTL,
-			     &val);
+	pci_pcie_capability_read_word(adap->pdev, PCI_EXP_LNKCTL, &val);
 
 	fst_trn_tx = G_NUMFSTTRNSEQ(t3_read_reg(adap, A_PCIE_PEX_CTRL0));
 	fst_trn_rx = adap->params.rev == 0 ? fst_trn_tx :
@@ -3425,15 +3421,14 @@ out_err:
 static void get_pci_mode(struct adapter *adapter, struct pci_params *p)
 {
 	static unsigned short speed_map[] = { 33, 66, 100, 133 };
-	u32 pci_mode, pcie_cap;
+	u32 pci_mode;
 
-	pcie_cap = pci_pcie_cap(adapter->pdev);
-	if (pcie_cap) {
+	if (pci_is_pcie(adapter->pdev)) {
 		u16 val;
 
 		p->variant = PCI_VARIANT_PCIE;
-		pci_read_config_word(adapter->pdev, pcie_cap + PCI_EXP_LNKSTA,
-					&val);
+		pci_pcie_capability_read_word(adapter->pdev, PCI_EXP_LNKSTA,
+					      &val);
 		p->width = (val >> 4) & 0x3f;
 		return;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index e1f96fb..a414bac 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3694,15 +3694,8 @@ static void __devinit print_port_info(const struct net_device *dev)
 
 static void __devinit enable_pcie_relaxed_ordering(struct pci_dev *dev)
 {
-	u16 v;
-	int pos;
-
-	pos = pci_pcie_cap(dev);
-	if (pos > 0) {
-		pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &v);
-		v |= PCI_EXP_DEVCTL_RELAX_EN;
-		pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, v);
-	}
+	pci_pcie_capability_change_word(dev, PCI_EXP_DEVCTL,
+					PCI_EXP_DEVCTL_RELAX_EN, 0);
 }
 
 /*
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 32e1dd5..f0e673e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2741,14 +2741,10 @@ static void __devinit get_pci_mode(struct adapter *adapter,
 				   struct pci_params *p)
 {
 	u16 val;
-	u32 pcie_cap = pci_pcie_cap(adapter->pdev);
 
-	if (pcie_cap) {
-		pci_read_config_word(adapter->pdev, pcie_cap + PCI_EXP_LNKSTA,
-				     &val);
-		p->speed = val & PCI_EXP_LNKSTA_CLS;
-		p->width = (val & PCI_EXP_LNKSTA_NLW) >> 4;
-	}
+	pci_pcie_capability_read_word(adapter->pdev, PCI_EXP_LNKSTA, &val);
+	p->speed = val & PCI_EXP_LNKSTA_CLS;
+	p->width = (val & PCI_EXP_LNKSTA_NLW) >> 4;
 }
 
 /**
-- 
1.7.9.5

