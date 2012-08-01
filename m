Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2HAQAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:00:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59609 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2HAQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:00:12 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 30/32] PCI/tsi721: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:35 +0800
Message-Id: <1343836477-7287-31-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify tsi721 driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/rapidio/devices/tsi721.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 722246c..5970c43 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -2212,9 +2212,8 @@ static int __devinit tsi721_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *id)
 {
 	struct tsi721_device *priv;
-	int i, cap;
+	int i;
 	int err;
-	u32 regval;
 
 	priv = kzalloc(sizeof(struct tsi721_device), GFP_KERNEL);
 	if (priv == NULL) {
@@ -2320,20 +2319,16 @@ static int __devinit tsi721_probe(struct pci_dev *pdev,
 			dev_info(&pdev->dev, "Unable to set consistent DMA mask\n");
 	}
 
-	cap = pci_pcie_cap(pdev);
-	BUG_ON(cap == 0);
+	BUG_ON(!pci_is_pcie(pdev));
 
 	/* Clear "no snoop" and "relaxed ordering" bits, use default MRRS. */
-	pci_read_config_dword(pdev, cap + PCI_EXP_DEVCTL, &regval);
-	regval &= ~(PCI_EXP_DEVCTL_READRQ | PCI_EXP_DEVCTL_RELAX_EN |
-		    PCI_EXP_DEVCTL_NOSNOOP_EN);
-	regval |= 0x2 << MAX_READ_REQUEST_SZ_SHIFT;
-	pci_write_config_dword(pdev, cap + PCI_EXP_DEVCTL, regval);
+	pci_pcie_capability_change_dword(pdev, PCI_EXP_DEVCTL,
+		0x2 << MAX_READ_REQUEST_SZ_SHIFT,
+		PCI_EXP_DEVCTL_READRQ | PCI_EXP_DEVCTL_RELAX_EN |
+		PCI_EXP_DEVCTL_NOSNOOP_EN);
 
 	/* Adjust PCIe completion timeout. */
-	pci_read_config_dword(pdev, cap + PCI_EXP_DEVCTL2, &regval);
-	regval &= ~(0x0f);
-	pci_write_config_dword(pdev, cap + PCI_EXP_DEVCTL2, regval | 0x2);
+	pci_pcie_capability_change_dword(pdev, PCI_EXP_DEVCTL2, 0x2, 0xf);
 
 	/*
 	 * FIXUP: correct offsets of MSI-X tables in the MSI-X Capability Block
-- 
1.7.9.5

