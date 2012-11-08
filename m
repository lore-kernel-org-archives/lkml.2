Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2KHG77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:59:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38371 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2KHG75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:59:57 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-3e-509b586b15ac
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] mm: remove watermark hacks for CMA
Date: Thu, 08 Nov 2012 07:59:45 +0100
Message-id: <1352357985-14869-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd2ciNkBBv88LC7vmsPmwOjxeZNc
	AGMUl01Kak5mWWqRvl0CV8aRq2vYClYpVvScb2dqYFwr3cXIySEhYCJx4dgcJghbTOLCvfVs
	XYxcHEICixglJr/uY4ZwVjBJrPy2gQ2kik3AUKLrbReYLSIQJvGncRsrSBGzwHEmiT8X14Il
	hAWMJQ5tbgMbyyKgKnFv0hZ2EJtXwEPi0a/jLF2MHEDrFCTmTLKZwMi9gJFhFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkawB59J7WBc2WBxiFGAg1GJh1dDcnaAEGtiWXFl7iFGCQ5mJRHe
	Zc5AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikBQgLpiSWp2ampBalFMFkmDk6pBkano96H
	zjVVbpISMk1v9nEufjb906xb2iFvPf6sDfUVdnq6PkftRX57jMJH0/1p8fIv2t/OT32am5j5
	pm85L6Ni2Nx/OcqLdp6p+mHC7cbp2CLht9J4+cuqyRxr3mZ8dph/bLGkl+ZDw/JVPnvXmbos
	6zcXfxH24N3fL7nMJmcPPxfRXly9IFyJpTgj0VCLuag4EQCAGk2b3AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 2139cbe627b89 ("cma: fix counting of isolated pages") and
d95ea5d18e69951 ("cma: fix watermark checking") introduced a reliable
method of free page accounting when memory is being allocated from CMA
regions, so the workaround introduced earlier by commit 49f223a9cd96c72
("mm: trigger page reclaim in alloc_contig_range() to stabilise
watermarks") can be finally removed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/mmzone.h |    9 --------
 mm/page_alloc.c        |   57 ------------------------------------------------
 2 files changed, 66 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c9fcd8f..f010b23 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -63,10 +63,8 @@ enum {
 
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
-#  define cma_wmark_pages(zone)	zone->min_cma_pages
 #else
 #  define is_migrate_cma(migratetype) false
-#  define cma_wmark_pages(zone) 0
 #endif
 
 #define for_each_migratetype_order(order, type) \
@@ -372,13 +370,6 @@ struct zone {
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
 #endif
-#ifdef CONFIG_CMA
-	/*
-	 * CMA needs to increase watermark levels during the allocation
-	 * process to make sure that the system is not starved.
-	 */
-	unsigned long		min_cma_pages;
-#endif
 	struct free_area	free_area[MAX_ORDER];
 
 #ifndef CONFIG_SPARSEMEM
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 43ab09f..5028a18 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5217,10 +5217,6 @@ static void __setup_per_zone_wmarks(void)
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
-		zone->watermark[WMARK_MIN] += cma_wmark_pages(zone);
-		zone->watermark[WMARK_LOW] += cma_wmark_pages(zone);
-		zone->watermark[WMARK_HIGH] += cma_wmark_pages(zone);
-
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
@@ -5765,54 +5761,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 	return ret > 0 ? 0 : ret;
 }
 
-/*
- * Update zone's cma pages counter used for watermark level calculation.
- */
-static inline void __update_cma_watermarks(struct zone *zone, int count)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&zone->lock, flags);
-	zone->min_cma_pages += count;
-	spin_unlock_irqrestore(&zone->lock, flags);
-	setup_per_zone_wmarks();
-}
-
-/*
- * Trigger memory pressure bump to reclaim some pages in order to be able to
- * allocate 'count' pages in single page units. Does similar work as
- *__alloc_pages_slowpath() function.
- */
-static int __reclaim_pages(struct zone *zone, gfp_t gfp_mask, int count)
-{
-	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
-	struct zonelist *zonelist = node_zonelist(0, gfp_mask);
-	int did_some_progress = 0;
-	int order = 1;
-
-	/*
-	 * Increase level of watermarks to force kswapd do his job
-	 * to stabilise at new watermark level.
-	 */
-	__update_cma_watermarks(zone, count);
-
-	/* Obey watermarks as if the page was being allocated */
-	while (!zone_watermark_ok(zone, 0, low_wmark_pages(zone), 0, 0)) {
-		wake_all_kswapd(order, zonelist, high_zoneidx, zone_idx(zone));
-
-		did_some_progress = __perform_reclaim(gfp_mask, order, zonelist,
-						      NULL);
-		if (!did_some_progress) {
-			/* Exhausted what can be done so it's blamo time */
-			out_of_memory(zonelist, gfp_mask, order, NULL, false);
-		}
-	}
-
-	/* Restore original watermark levels. */
-	__update_cma_watermarks(zone, -count);
-
-	return count;
-}
-
 /**
  * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
@@ -5921,11 +5869,6 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 		goto done;
 	}
 
-	/*
-	 * Reclaim enough pages to make sure that contiguous allocation
-	 * will not starve the system.
-	 */
-	__reclaim_pages(zone, GFP_HIGHUSER_MOVABLE, end-start);
 
 	/* Grab isolated pages from freelists. */
 	outer_end = isolate_freepages_range(&cc, outer_start, end);
-- 
1.7.9.5

