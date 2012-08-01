Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2HAP6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:58:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2HAP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:58:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 20/32] PCI/niu: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:25 +0800
Message-Id: <1343836477-7287-21-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify niu driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/net/ethernet/sun/niu.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 703c8cc..e8e2932 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9768,9 +9768,8 @@ static int __devinit niu_pci_init_one(struct pci_dev *pdev,
 	union niu_parent_id parent_id;
 	struct net_device *dev;
 	struct niu *np;
-	int err, pos;
+	int err;
 	u64 dma_mask;
-	u16 val16;
 
 	niu_driver_version();
 
@@ -9793,8 +9792,7 @@ static int __devinit niu_pci_init_one(struct pci_dev *pdev,
 		goto err_out_disable_pdev;
 	}
 
-	pos = pci_pcie_cap(pdev);
-	if (pos <= 0) {
+	if (!pci_is_pcie(pdev)) {
 		dev_err(&pdev->dev, "Cannot find PCI Express capability, aborting\n");
 		goto err_out_free_res;
 	}
@@ -9819,14 +9817,10 @@ static int __devinit niu_pci_init_one(struct pci_dev *pdev,
 		goto err_out_free_dev;
 	}
 
-	pci_read_config_word(pdev, pos + PCI_EXP_DEVCTL, &val16);
-	val16 &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
-	val16 |= (PCI_EXP_DEVCTL_CERE |
-		  PCI_EXP_DEVCTL_NFERE |
-		  PCI_EXP_DEVCTL_FERE |
-		  PCI_EXP_DEVCTL_URRE |
-		  PCI_EXP_DEVCTL_RELAX_EN);
-	pci_write_config_word(pdev, pos + PCI_EXP_DEVCTL, val16);
+	pci_pcie_capability_change_word(pdev, PCI_EXP_DEVCTL,
+		PCI_EXP_DEVCTL_CERE | PCI_EXP_DEVCTL_NFERE |
+		PCI_EXP_DEVCTL_FERE | PCI_EXP_DEVCTL_URRE |
+		PCI_EXP_DEVCTL_RELAX_EN, PCI_EXP_DEVCTL_NOSNOOP_EN);
 
 	dma_mask = DMA_BIT_MASK(44);
 	err = pci_set_dma_mask(pdev, dma_mask);
-- 
1.7.9.5

