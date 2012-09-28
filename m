Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab2I1M1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:27:04 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:48745
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721Ab2I1MYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27S9-02-8LA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/16] iommu/amd: Add call-back routine for HPET MSI
Date: Fri, 28 Sep 2012 14:24:01 +0200
Message-ID: <1348835046-3262-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a routine to setup a HPET MSI interrupt for remapping.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 84efecd..af245f4 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4200,4 +4200,30 @@ static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	return 0;
 }
 
+static int setup_hpet_msi(unsigned int irq, unsigned int id)
+{
+	struct irq_2_iommu *irte_info;
+	struct irq_cfg *cfg;
+	int index, devid;
+
+	cfg = irq_get_chip_data(irq);
+	if (!cfg)
+		return -EINVAL;
+
+	irte_info = &cfg->irq_2_iommu;
+	devid     = get_hpet_devid(id);
+	if (devid < 0)
+		return devid;
+
+	index = alloc_irq_index(cfg, devid, 1);
+	if (index < 0)
+		return index;
+
+	irte_info->sub_handle = devid;
+	irte_info->irte_index = index;
+	irte_info->iommu      = (void *)cfg;
+
+	return 0;
+}
+
 #endif
-- 
1.7.9.5


