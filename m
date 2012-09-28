Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2I1MY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:24:27 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:44660
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757803Ab2I1MYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27SB-01-LL0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/16] iommu/amd: Implement MSI routines for interrupt remapping
Date: Fri, 28 Sep 2012 14:24:00 +0200
Message-ID: <1348835046-3262-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add routines to setup interrupt remapping for MSI
interrupts.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   74 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 3df01b2..84efecd 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4126,4 +4126,78 @@ static int free_irq(int irq)
 	return 0;
 }
 
+static void compose_msi_msg(struct pci_dev *pdev,
+			    unsigned int irq, unsigned int dest,
+			    struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_2_iommu *irte_info;
+	struct irq_cfg *cfg;
+	union irte irte;
+
+	cfg = irq_get_chip_data(irq);
+	if (!cfg)
+		return;
+
+	irte_info = &cfg->irq_2_iommu;
+
+	irte.val		= 0;
+	irte.fields.vector	= cfg->vector;
+	irte.fields.int_type    = apic->irq_delivery_mode;
+	irte.fields.destination	= dest;
+	irte.fields.dm		= apic->irq_dest_mode;
+	irte.fields.valid	= 1;
+
+	modify_irte(irte_info->sub_handle, irte_info->irte_index, irte);
+
+	msg->address_hi = MSI_ADDR_BASE_HI;
+	msg->address_lo = MSI_ADDR_BASE_LO;
+	msg->data       = irte_info->irte_index;
+}
+
+static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
+{
+	struct irq_cfg *cfg;
+	int index;
+	u16 devid;
+
+	if (!pdev)
+		return -EINVAL;
+
+	cfg = irq_get_chip_data(irq);
+	if (!cfg)
+		return -EINVAL;
+
+	devid = get_device_id(&pdev->dev);
+	index = alloc_irq_index(cfg, devid, nvec);
+
+	return index < 0 ? MAX_IRQS_PER_TABLE : index;
+}
+
+static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
+			 int index, int offset)
+{
+	struct irq_2_iommu *irte_info;
+	struct irq_cfg *cfg;
+	u16 devid;
+
+	if (!pdev)
+		return -EINVAL;
+
+	cfg = irq_get_chip_data(irq);
+	if (!cfg)
+		return -EINVAL;
+
+	if (index >= MAX_IRQS_PER_TABLE)
+		return 0;
+
+	devid		= get_device_id(&pdev->dev);
+	irte_info	= &cfg->irq_2_iommu;
+
+	irte_info->sub_handle = devid;
+	irte_info->irte_index = index + offset;
+	irte_info->iommu      = (void *)cfg;
+
+	return 0;
+}
+
 #endif
-- 
1.7.9.5


