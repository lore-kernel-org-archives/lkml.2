Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab2GEMjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:39:37 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:42043
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566Ab2GEMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPM-02-6NT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 22/28] iommu/amd: Implement MSI routines for interrupt remapping
Date: Thu, 5 Jul 2012 14:36:42 +0200
Message-ID: <1341491808-23083-23-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
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
index dc2e699..ee10f30 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4054,4 +4054,78 @@ static int free_irq(int irq)
 	return 0;
 }
 
+static void compose_msi_msg(struct pci_dev *pdev,
+			    unsigned int irq, unsigned int dest,
+			    struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_2_irte *irte_info;
+	struct irq_cfg *cfg;
+	union irte irte;
+
+	cfg = irq_get_chip_data(irq);
+	if (!cfg)
+		return;
+
+	irte_info = &cfg->irq_remap_info.irq_2_irte;
+
+	irte.val		= 0;
+	irte.fields.vector	= cfg->vector;
+	irte.fields.int_type    = apic->irq_delivery_mode;
+	irte.fields.destination	= dest;
+	irte.fields.dm		= apic->irq_dest_mode;
+	irte.fields.valid	= 1;
+
+	modify_irte(irte_info->devid, irte_info->index, irte);
+
+	msg->address_hi = MSI_ADDR_BASE_HI;
+	msg->address_lo = MSI_ADDR_BASE_LO;
+	msg->data       = irte_info->index;
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
+	struct irq_2_irte *irte_info;
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
+	irte_info	= &cfg->irq_remap_info.irq_2_irte;
+
+	irte_info->devid = devid;
+	irte_info->index = index + offset;
+	cfg->remapped    = true;
+
+	return 0;
+}
+
 #endif
-- 
1.7.9.5


