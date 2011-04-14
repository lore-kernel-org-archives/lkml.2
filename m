Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1DNVxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:53:24 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:49138 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192Ab1DNVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:53:23 -0400
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Ramesh Gupta <grgupta@ti.com>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
Date: Thu, 14 Apr 2011 16:52:48 -0500
Message-Id: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramesh Gupta <grgupta@ti.com>

This patch is to flush the iommu page table entries from L1 and L2
caches using dma_map_single. This also simplifies the implementation
by removing the functions  flush_iopgd_range/flush_iopte_range.

Change-Id: I19c0bf437d75c79084b2fa28c7da50a4c84b91a0
Signed-off-by: Ramesh Gupta <grgupta@ti.com>
Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 arch/arm/plat-omap/iommu.c |   41 ++++++++++-------------------------------
 1 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index 8a51fd5..1fb5e41 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -18,6 +18,7 @@
 #include <linux/ioport.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/cacheflush.h>
 
@@ -466,29 +467,6 @@ EXPORT_SYMBOL_GPL(foreach_iommu_device);
 
 #endif /* CONFIG_OMAP_IOMMU_DEBUG_MODULE */
 
-/*
- *	H/W pagetable operations
- */
-static void flush_iopgd_range(u32 *first, u32 *last)
-{
-	/* FIXME: L2 cache should be taken care of if it exists */
-	do {
-		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pgd"
-		    : : "r" (first));
-		first += L1_CACHE_BYTES / sizeof(*first);
-	} while (first <= last);
-}
-
-static void flush_iopte_range(u32 *first, u32 *last)
-{
-	/* FIXME: L2 cache should be taken care of if it exists */
-	do {
-		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pte"
-		    : : "r" (first));
-		first += L1_CACHE_BYTES / sizeof(*first);
-	} while (first <= last);
-}
-
 static void iopte_free(u32 *iopte)
 {
 	/* Note: freed iopte's must be clean ready for re-use */
@@ -515,7 +493,7 @@ static u32 *iopte_alloc(struct iommu *obj, u32 *iopgd, u32 da)
 			return ERR_PTR(-ENOMEM);
 
 		*iopgd = virt_to_phys(iopte) | IOPGD_TABLE;
-		flush_iopgd_range(iopgd, iopgd);
+		dma_map_single(obj->dev, iopgd, 1, DMA_TO_DEVICE);
 
 		dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
 	} else {
@@ -544,7 +522,7 @@ static int iopgd_alloc_section(struct iommu *obj, u32 da, u32 pa, u32 prot)
 	}
 
 	*iopgd = (pa & IOSECTION_MASK) | prot | IOPGD_SECTION;
-	flush_iopgd_range(iopgd, iopgd);
+	dma_map_single(obj->dev, iopgd, 1, DMA_TO_DEVICE);
 	return 0;
 }
 
@@ -561,7 +539,7 @@ static int iopgd_alloc_super(struct iommu *obj, u32 da, u32 pa, u32 prot)
 
 	for (i = 0; i < 16; i++)
 		*(iopgd + i) = (pa & IOSUPER_MASK) | prot | IOPGD_SUPER;
-	flush_iopgd_range(iopgd, iopgd + 15);
+	dma_map_single(obj->dev, iopgd, 16, DMA_TO_DEVICE);
 	return 0;
 }
 
@@ -574,7 +552,7 @@ static int iopte_alloc_page(struct iommu *obj, u32 da, u32 pa, u32 prot)
 		return PTR_ERR(iopte);
 
 	*iopte = (pa & IOPAGE_MASK) | prot | IOPTE_SMALL;
-	flush_iopte_range(iopte, iopte);
+	dma_map_single(obj->dev, iopte, 1, DMA_TO_DEVICE);
 
 	dev_vdbg(obj->dev, "%s: da:%08x pa:%08x pte:%p *pte:%08x\n",
 		 __func__, da, pa, iopte, *iopte);
@@ -599,7 +577,7 @@ static int iopte_alloc_large(struct iommu *obj, u32 da, u32 pa, u32 prot)
 
 	for (i = 0; i < 16; i++)
 		*(iopte + i) = (pa & IOLARGE_MASK) | prot | IOPTE_LARGE;
-	flush_iopte_range(iopte, iopte + 15);
+	dma_map_single(obj->dev, iopte, 15, DMA_TO_DEVICE);
 	return 0;
 }
 
@@ -703,7 +681,8 @@ static size_t iopgtable_clear_entry_core(struct iommu *obj, u32 da)
 		}
 		bytes *= nent;
 		memset(iopte, 0, nent * sizeof(*iopte));
-		flush_iopte_range(iopte, iopte + (nent - 1) * sizeof(*iopte));
+		dma_map_single(obj->dev, iopte, nent * sizeof(*iopte),
+				 DMA_TO_DEVICE);
 
 		/*
 		 * do table walk to check if this table is necessary or not
@@ -725,7 +704,7 @@ static size_t iopgtable_clear_entry_core(struct iommu *obj, u32 da)
 		bytes *= nent;
 	}
 	memset(iopgd, 0, nent * sizeof(*iopgd));
-	flush_iopgd_range(iopgd, iopgd + (nent - 1) * sizeof(*iopgd));
+	dma_map_single(obj->dev, iopgd, nent * sizeof(*iopgd), DMA_TO_DEVICE);
 out:
 	return bytes;
 }
@@ -770,7 +749,7 @@ static void iopgtable_clear_entry_all(struct iommu *obj)
 			iopte_free(iopte_offset(iopgd, 0));
 
 		*iopgd = 0;
-		flush_iopgd_range(iopgd, iopgd);
+		dma_map_single(obj->dev, iopgd, 1, DMA_TO_DEVICE);
 	}
 
 	flush_iotlb_all(obj);
-- 
1.7.0.4

