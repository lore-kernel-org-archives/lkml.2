Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2F1Jcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:32:32 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:52705 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932776Ab2F1Jc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:32:29 -0400
MIME-Version: 1.0
Date: Thu, 28 Jun 2012 15:02:26 +0530
Message-ID: <CADysL2YkZ4-TkgbzW+TgrLzfMV4nuf5kfBwk0FyP40gCG+YO_A@mail.gmail.com>
Subject: [PATCH v3 2/2] OMAP:IOMMU:flush L1 and L2 caches
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ad8097177ca6c43d98d0641ea881936fe328b4dc Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Fri, 15 Jun 2012 16:46:46 +0530
Subject: [PATCH v3 2/2] OMAP:IOMMU:flush L1 and L2 caches

OMAP IOMMU need to make sure that data in the L1 and L2
caches is visible to the MMU hardware whenever the
page tables are updated. The current code only takes
care of L1 cache using assembly code. Added code to
handle this using a new L1 cache maintenance function
and the outer cache function.

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>
---
 drivers/iommu/omap-iommu.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 6899dcd..f909019 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -469,22 +469,14 @@ EXPORT_SYMBOL_GPL(omap_foreach_iommu_device);
  */
 static void flush_iopgd_range(u32 *first, u32 *last)
 {
-	/* FIXME: L2 cache should be taken care of if it exists */
-	do {
-		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pgd"
-		    : : "r" (first));
-		first += L1_CACHE_BYTES / sizeof(*first);
-	} while (first <= last);
+	flush_iommu_mem(first, last);
+	outer_flush_range(virt_to_phys(first), virt_to_phys(last));
 }

 static void flush_iopte_range(u32 *first, u32 *last)
 {
-	/* FIXME: L2 cache should be taken care of if it exists */
-	do {
-		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pte"
-		    : : "r" (first));
-		first += L1_CACHE_BYTES / sizeof(*first);
-	} while (first <= last);
+	flush_iommu_mem(first, last);
+	outer_flush_range(virt_to_phys(first), virt_to_phys(last));
 }

 static void iopte_free(u32 *iopte)
@@ -513,7 +505,7 @@ static u32 *iopte_alloc(struct omap_iommu *obj,
u32 *iopgd, u32 da)
 			return ERR_PTR(-ENOMEM);

 		*iopgd = virt_to_phys(iopte) | IOPGD_TABLE;
-		flush_iopgd_range(iopgd, iopgd);
+		flush_iopgd_range(iopgd, iopgd + 1);

 		dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
 	} else {
@@ -542,7 +534,7 @@ static int iopgd_alloc_section(struct omap_iommu
*obj, u32 da, u32 pa, u32 prot)
 	}

 	*iopgd = (pa & IOSECTION_MASK) | prot | IOPGD_SECTION;
-	flush_iopgd_range(iopgd, iopgd);
+	flush_iopgd_range(iopgd, iopgd + 1);
 	return 0;
 }

@@ -559,7 +551,7 @@ static int iopgd_alloc_super(struct omap_iommu
*obj, u32 da, u32 pa, u32 prot)

 	for (i = 0; i < 16; i++)
 		*(iopgd + i) = (pa & IOSUPER_MASK) | prot | IOPGD_SUPER;
-	flush_iopgd_range(iopgd, iopgd + 15);
+	flush_iopgd_range(iopgd, iopgd + 16);
 	return 0;
 }

@@ -700,7 +692,7 @@ static size_t iopgtable_clear_entry_core(struct
omap_iommu *obj, u32 da)
 		}
 		bytes *= nent;
 		memset(iopte, 0, nent * sizeof(*iopte));
-		flush_iopte_range(iopte, iopte + (nent - 1) * sizeof(*iopte));
+		flush_iopte_range(iopte, iopte + nent * sizeof(*iopte));

 		/*
 		 * do table walk to check if this table is necessary or not
@@ -722,7 +714,7 @@ static size_t iopgtable_clear_entry_core(struct
omap_iommu *obj, u32 da)
 		bytes *= nent;
 	}
 	memset(iopgd, 0, nent * sizeof(*iopgd));
-	flush_iopgd_range(iopgd, iopgd + (nent - 1) * sizeof(*iopgd));
+	flush_iopgd_range(iopgd, iopgd + nent * sizeof(*iopgd));
 out:
 	return bytes;
 }
-- 
1.7.0.4


-- 
regards
Ramesh Gupta G
