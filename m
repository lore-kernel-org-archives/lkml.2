Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab2ILPTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:19:22 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:37337 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758790Ab2ILPTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:19:19 -0400
MIME-Version: 1.0
Date: Wed, 12 Sep 2012 20:49:16 +0530
Message-ID: <CADysL2bb+LC1ySgkp8Hd_VL8GaFJ_gsuMF=WkmWp+YTdJqKJ4A@mail.gmail.com>
Subject: [PATCH v5 2/2] OMAP:IOMMU:flush L1 and L2 caches
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d78ddb5b0dffed3fd77e6e010735e869ea41b02f Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Wed, 12 Sep 2012 19:05:29 +0530
Subject: [PATCH v5 2/2] OMAP:IOMMU:flush L1 and L2 caches

OMAP IOMMU need to make sure that data in the L1 and L2 caches
is visible to the MMU hardware whenever the pagetables are
updated. The current code only takes care of L1 cache using
assembly. Added code to handle this using a new L1 cache
maintenance function and the outer cache function.
Thanks to the RMK's suggestions.

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>
---
 drivers/iommu/omap-iommu.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index d0b1234..8f61ef9 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -469,24 +469,21 @@ EXPORT_SYMBOL_GPL(omap_foreach_iommu_device);
 /*
  *	H/W pagetable operations
  */
-static void flush_iopgd_range(u32 *first, u32 *last)
+static void flush_iopgd_range(u32 *first, size_t size)
 {
-	/* FIXME: L2 cache should be taken care of if it exists */
-	do {
-		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pgd"
-		    : : "r" (first));
-		first += L1_CACHE_BYTES / sizeof(*first);
-	} while (first <= last);
+	phys_addr_t phys = virt_to_phys(first);
+
+	iommu_flush_area(first, size);
+	outer_flush_range(phys, phys + size);
 }

-static void flush_iopte_range(u32 *first, u32 *last)
+static void flush_iopte_range(u32 *first, size_t size)
+
 {
-	/* FIXME: L2 cache should be taken care of if it exists */
-	do {
-		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pte"
-		    : : "r" (first));
-		first += L1_CACHE_BYTES / sizeof(*first);
-	} while (first <= last);
+	phys_addr_t phys = virt_to_phys(first);
+
+	iommu_flush_area(first, size);
+	outer_flush_range(phys, phys + size);
 }

 static void iopte_free(u32 *iopte)
@@ -515,7 +512,7 @@ static u32 *iopte_alloc(struct omap_iommu *obj,
u32 *iopgd, u32 da)
 			return ERR_PTR(-ENOMEM);

 		*iopgd = virt_to_phys(iopte) | IOPGD_TABLE;
-		flush_iopgd_range(iopgd, iopgd);
+		flush_iopgd_range(iopgd, sizeof(*iopgd));

 		dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
 	} else {
@@ -544,7 +541,7 @@ static int iopgd_alloc_section(struct omap_iommu
*obj, u32 da, u32 pa, u32 prot)
 	}

 	*iopgd = (pa & IOSECTION_MASK) | prot | IOPGD_SECTION;
-	flush_iopgd_range(iopgd, iopgd);
+	flush_iopgd_range(iopgd, sizeof(*iopgd));
 	return 0;
 }

@@ -561,7 +558,7 @@ static int iopgd_alloc_super(struct omap_iommu
*obj, u32 da, u32 pa, u32 prot)

 	for (i = 0; i < 16; i++)
 		*(iopgd + i) = (pa & IOSUPER_MASK) | prot | IOPGD_SUPER;
-	flush_iopgd_range(iopgd, iopgd + 15);
+	flush_iopgd_range(iopgd, sizeof(*iopgd) * 16);
 	return 0;
 }

@@ -574,7 +571,7 @@ static int iopte_alloc_page(struct omap_iommu
*obj, u32 da, u32 pa, u32 prot)
 		return PTR_ERR(iopte);

 	*iopte = (pa & IOPAGE_MASK) | prot | IOPTE_SMALL;
-	flush_iopte_range(iopte, iopte);
+	flush_iopte_range(iopte, sizeof(*iopte));

 	dev_vdbg(obj->dev, "%s: da:%08x pa:%08x pte:%p *pte:%08x\n",
 		 __func__, da, pa, iopte, *iopte);
@@ -599,7 +596,7 @@ static int iopte_alloc_large(struct omap_iommu
*obj, u32 da, u32 pa, u32 prot)

 	for (i = 0; i < 16; i++)
 		*(iopte + i) = (pa & IOLARGE_MASK) | prot | IOPTE_LARGE;
-	flush_iopte_range(iopte, iopte + 15);
+	flush_iopte_range(iopte, sizeof(*iopte) * 16);
 	return 0;
 }

@@ -702,7 +699,7 @@ static size_t iopgtable_clear_entry_core(struct
omap_iommu *obj, u32 da)
 		}
 		bytes *= nent;
 		memset(iopte, 0, nent * sizeof(*iopte));
-		flush_iopte_range(iopte, iopte + (nent - 1) * sizeof(*iopte));
+		flush_iopte_range(iopte, iopte + (nent) * sizeof(*iopte));

 		/*
 		 * do table walk to check if this table is necessary or not
@@ -724,7 +721,7 @@ static size_t iopgtable_clear_entry_core(struct
omap_iommu *obj, u32 da)
 		bytes *= nent;
 	}
 	memset(iopgd, 0, nent * sizeof(*iopgd));
-	flush_iopgd_range(iopgd, iopgd + (nent - 1) * sizeof(*iopgd));
+	flush_iopgd_range(iopgd, iopgd + (nent) * sizeof(*iopgd));
 out:
 	return bytes;
 }
@@ -768,7 +765,7 @@ static void iopgtable_clear_entry_all(struct
omap_iommu *obj)
 			iopte_free(iopte_offset(iopgd, 0));

 		*iopgd = 0;
-		flush_iopgd_range(iopgd, iopgd);
+		flush_iopgd_range(iopgd, sizeof(*iopgd));
 	}

 	flush_iotlb_all(obj);
-- 
1.7.0.4


-- 
regards
Ramesh Gupta G
