Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2FSLVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:21:51 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39643 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab2FSLVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:21:49 -0400
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 16:51:46 +0530
Message-ID: <CADysL2bDxkaRTWhyVDeYTO=oLUw8pezEL3ujxYx53M7is=cG9A@mail.gmail.com>
Subject: [PATCH 4/4] OMAP:IOMMU:flush L1 and L2 caches
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eb07a74132cd9305c1b82610dd1c2a9adfc72986 Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Fri, 15 Jun 2012 16:46:46 +0530
Subject: [PATCH 4/4] OMAP:IOMMU:flush L1 and L2 caches

IOMMU need to make sure that data in L1 and L2 caches
is visible to the MMU hardware whenever the pagetables are
updated. The current code only takes care of L1 cache using
assembly.Added code to take care of both L1 and L2 caches
using a new L1 cache flush function and the outer cache function.

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>
---
 drivers/iommu/omap-iommu.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 6899dcd..6344fbc 100644
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
+	flush_mem(first, last);
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
+	flush_mem(first, last);
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
