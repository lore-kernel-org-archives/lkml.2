Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2GEMji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:39:38 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:58058
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932562Ab2GEMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPL-02-6NQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 23/28] iommu/amd: Add call-back routine for HPET MSI
Date: Thu, 5 Jul 2012 14:36:43 +0200
Message-ID: <1341491808-23083-24-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
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
index ee10f30..fed1395 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4128,4 +4128,30 @@ static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	return 0;
 }
 
+static int setup_hpet_msi(unsigned int irq, unsigned int id)
+{
+	struct irq_2_irte *irte_info;
+	struct irq_cfg *cfg;
+	int index, devid;
+
+	cfg = irq_get_chip_data(irq);
+	if (!cfg)
+		return -EINVAL;
+
+	irte_info = &cfg->irq_remap_info.irq_2_irte;
+	devid     = get_hpet_devid(id);
+	if (devid < 0)
+		return devid;
+
+	index = alloc_irq_index(cfg, devid, 1);
+	if (index < 0)
+		return index;
+
+	irte_info->devid = devid;
+	irte_info->index = index;
+	cfg->remapped    = true;
+
+	return 0;
+}
+
 #endif
-- 
1.7.9.5


