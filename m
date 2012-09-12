Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080Ab2ILBlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:41:52 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43969 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2ILBlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:41:51 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-f6-504fe85d7d5c
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH 1/2] mm: refactor out __alloc_contig_migrate_alloc
Date: Wed, 12 Sep 2012 10:43:50 +0900
Message-Id: <1347414231-31451-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_contig_migrate_alloc can be used by memory-hotplug so
refactor out(move + rename as a common name) it into
page_isolation.c.

Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---

This patch is intended for preparing next bug fix patch.

 include/linux/page-isolation.h |    3 ++-
 mm/page_alloc.c                |   14 +-------------
 mm/page_isolation.c            |   11 +++++++++++
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
index 105077a..1c82261 100644
--- a/include/linux/page-isolation.h
+++ b/include/linux/page-isolation.h
@@ -37,6 +37,7 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
  */
 int set_migratetype_isolate(struct page *page);
 void unset_migratetype_isolate(struct page *page, unsigned migratetype);
-
+struct page *alloc_migrate_target(struct page *page, unsigned long private,
+				int **resultp);
 
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a4ff74e..6716023 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5648,18 +5648,6 @@ static unsigned long pfn_max_align_up(unsigned long pfn)
 				pageblock_nr_pages));
 }
 
-static struct page *
-__alloc_contig_migrate_alloc(struct page *page, unsigned long private,
-			     int **resultp)
-{
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
-
-	if (PageHighMem(page))
-		gfp_mask |= __GFP_HIGHMEM;
-
-	return alloc_page(gfp_mask);
-}
-
 /* [start, end) must belong to a single zone. */
 static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 {
@@ -5700,7 +5688,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 		}
 
 		ret = migrate_pages(&cc.migratepages,
-				    __alloc_contig_migrate_alloc,
+				    alloc_migrate_target,
 				    0, false, MIGRATE_SYNC);
 	}
 
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 247d1f1..6936545 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -233,3 +233,14 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
 	spin_unlock_irqrestore(&zone->lock, flags);
 	return ret ? 0 : -EBUSY;
 }
+
+struct page *alloc_migrate_target(struct page *page, unsigned long private,
+                             int **resultp)
+{
+        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+
+        if (PageHighMem(page))
+                gfp_mask |= __GFP_HIGHMEM;
+
+        return alloc_page(gfp_mask);
+}
-- 
1.7.9.5

