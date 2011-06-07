Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1FGKGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:06:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:1087 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1FGKGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:06:47 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMF038-01-GZZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 2/3] x86/amd-iommu: Use only per-device dma_ops
Date: Tue, 7 Jun 2011 12:06:58 +0200
Message-ID: <1307441219-18202-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
References: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunatly there are systems where the AMD IOMMU does not
cover all devices. This breaks with the current driver as it
initializes the global dma_ops variable. This patch limits
the AMD IOMMU to the devices listed in the IVRS table fixing
DMA for devices not covered by the IOMMU.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index cd8cbeb..b2c309b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -30,6 +30,7 @@
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/dma.h>
 #include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
@@ -2383,6 +2384,23 @@ static struct dma_map_ops amd_iommu_dma_ops = {
 	.dma_supported = amd_iommu_dma_supported,
 };
 
+static unsigned device_dma_ops_init(void)
+{
+	struct pci_dev *pdev = NULL;
+	unsigned unhandled = 0;
+
+	for_each_pci_dev(pdev) {
+		if (!check_device(&pdev->dev)) {
+			unhandled += 1;
+			continue;
+		}
+
+		pdev->dev.archdata.dma_ops = &amd_iommu_dma_ops;
+	}
+
+	return unhandled;
+}
+
 /*
  * The function which clues the AMD IOMMU driver into dma_ops.
  */
@@ -2395,7 +2413,7 @@ void __init amd_iommu_init_api(void)
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
-	int ret;
+	int ret, unhandled;
 
 	/*
 	 * first allocate a default protection domain for every IOMMU we
@@ -2421,7 +2439,11 @@ int __init amd_iommu_init_dma_ops(void)
 	swiotlb = 0;
 
 	/* Make the driver finally visible to the drivers */
-	dma_ops = &amd_iommu_dma_ops;
+	unhandled = device_dma_ops_init();
+	if (unhandled && max_pfn > MAX_DMA32_PFN) {
+		/* There are unhandled devices - initialize swiotlb for them */
+		swiotlb = 1;
+	}
 
 	amd_iommu_stats_init();
 
-- 
1.7.4.1


