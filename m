Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1G1Xrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:47:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:24978 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab1G1Xor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="35732480"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: joerg.roedel@amd.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [42/50] iommu/amd: Don't use MSI address range for DMA addresses
Message-Id: <20110728234447.0F9F02403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

[ upstream commit 17f5b569e09cfa3488eaa663cbf9feada2e789f5 ]

Reserve the MSI address range in the address allocator so
that MSI addresses are not handed out as dma handles.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/x86/kernel/amd_iommu.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/amd_iommu.c
+++ linux-2.6.35.y/arch/x86/kernel/amd_iommu.c
@@ -25,6 +25,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu-helper.h>
 #include <linux/iommu.h>
+#include <asm/msidef.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -1048,7 +1049,7 @@ static int alloc_new_range(struct dma_op
 {
 	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
 	struct amd_iommu *iommu;
-	unsigned long i;
+	unsigned long i, old_size;
 
 #ifdef CONFIG_IOMMU_STRESS
 	populate = false;
@@ -1084,8 +1085,21 @@ static int alloc_new_range(struct dma_op
 		}
 	}
 
+	old_size                = dma_dom->aperture_size;
 	dma_dom->aperture_size += APERTURE_RANGE_SIZE;
 
+	/* Reserve address range used for MSI messages */
+	if (old_size < MSI_ADDR_BASE_LO &&
+	    dma_dom->aperture_size > MSI_ADDR_BASE_LO) {
+		unsigned long spage;
+		int pages;
+
+		pages = iommu_num_pages(MSI_ADDR_BASE_LO, 0x10000, PAGE_SIZE);
+		spage = MSI_ADDR_BASE_LO >> PAGE_SHIFT;
+
+		dma_ops_reserve_addresses(dma_dom, spage, pages);
+	}
+
 	/* Intialize the exclusion range if necessary */
 	for_each_iommu(iommu) {
 		if (iommu->exclusion_start &&
