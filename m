Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1FPHQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:16:11 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59752 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757019Ab1FPHLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:16 -0400
X-Sasl-enc: baEJ9EbEI5yXYXLA4Z0ptSJ7qo/WcBP/xek4fDRbs3gK 1308208275
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:10 2011
Message-Id: <20110616002910.464431040@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [66/85] x86/amd-iommu: Use only per-device dma_ops
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 27c2127a15d340706c0aa84e311188a14468d841 upstream.

Unfortunatly there are systems where the AMD IOMMU does not
cover all devices. This breaks with the current driver as it
initializes the global dma_ops variable. This patch limits
the AMD IOMMU to the devices listed in the IVRS table fixing
DMA for devices not covered by the IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -28,6 +28,7 @@
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/dma.h>
 #include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
@@ -2228,6 +2229,23 @@ static struct dma_map_ops amd_iommu_dma_
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
@@ -2240,7 +2258,7 @@ void __init amd_iommu_init_api(void)
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
-	int ret;
+	int ret, unhandled;
 
 	/*
 	 * first allocate a default protection domain for every IOMMU we
@@ -2266,7 +2284,11 @@ int __init amd_iommu_init_dma_ops(void)
 	swiotlb = 0;
 
 	/* Make the driver finally visible to the drivers */
-	dma_ops = &amd_iommu_dma_ops;
+	unhandled = device_dma_ops_init();
+	if (unhandled && max_pfn > MAX_DMA32_PFN) {
+		/* There are unhandled devices - initialize swiotlb for them */
+		swiotlb = 1;
+	}
 
 	amd_iommu_stats_init();
 


