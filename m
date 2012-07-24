Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2GXQgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:36:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2GXQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:36:35 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 20/32] PCI/niu: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:32 +0800
Message-Id: <1343147504-25891-21-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify niu driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/net/ethernet/sun/niu.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 703c8cc..3f914c1 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9768,7 +9768,7 @@ static int __devinit niu_pci_init_one(struct pci_dev *pdev,
 	union niu_parent_id parent_id;
 	struct net_device *dev;
 	struct niu *np;
-	int err, pos;
+	int err;
 	u64 dma_mask;
 	u16 val16;
 
@@ -9793,8 +9793,7 @@ static int __devinit niu_pci_init_one(struct pci_dev *pdev,
 		goto err_out_disable_pdev;
 	}
 
-	pos = pci_pcie_cap(pdev);
-	if (pos <= 0) {
+	if (!pci_is_pcie(pdev)) {
 		dev_err(&pdev->dev, "Cannot find PCI Express capability, aborting\n");
 		goto err_out_free_res;
 	}
@@ -9819,14 +9818,14 @@ static int __devinit niu_pci_init_one(struct pci_dev *pdev,
 		goto err_out_free_dev;
 	}
 
-	pci_read_config_word(pdev, pos + PCI_EXP_DEVCTL, &val16);
+	pci_pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &val16);
 	val16 &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
 	val16 |= (PCI_EXP_DEVCTL_CERE |
 		  PCI_EXP_DEVCTL_NFERE |
 		  PCI_EXP_DEVCTL_FERE |
 		  PCI_EXP_DEVCTL_URRE |
 		  PCI_EXP_DEVCTL_RELAX_EN);
-	pci_write_config_word(pdev, pos + PCI_EXP_DEVCTL, val16);
+	pci_pcie_capability_write_word(pdev, PCI_EXP_DEVCTL, val16);
 
 	dma_mask = DMA_BIT_MASK(44);
 	err = pci_set_dma_mask(pdev, dma_mask);
-- 
1.7.9.5

