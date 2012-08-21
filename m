Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2HUMtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:49:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab2HUMsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:48:23 -0400
From: Rafael Aquini <aquini@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>, Rafael Aquini <aquini@redhat.com>
Subject: [PATCH v8 2/5] mm: introduce compaction and migration for ballooned pages
Date: Tue, 21 Aug 2012 09:47:45 -0300
Message-Id: <0ba67e1fbb6376a517a594486faa6c48abfb1201.1345519422.git.aquini@redhat.com>
In-Reply-To: <cover.1345519422.git.aquini@redhat.com>
References: <cover.1345519422.git.aquini@redhat.com>
In-Reply-To: <cover.1345519422.git.aquini@redhat.com>
References: <cover.1345519422.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory fragmentation introduced by ballooning might reduce significantly
the number of 2MB contiguous memory blocks that can be used within a guest,
thus imposing performance penalties associated with the reduced number of
transparent huge pages that could be used by the guest workload.

This patch introduces the helper functions as well as the necessary changes
to teach compaction and migration bits how to cope with pages which are
part of a guest memory balloon, in order to make them movable by memory
compaction procedures.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
---
 mm/compaction.c | 47 ++++++++++++++++++++++++++++-------------------
 mm/migrate.c    | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 20 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index e78cb96..ce43dc2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -14,6 +14,7 @@
 #include <linux/backing-dev.h>
 #include <linux/sysctl.h>
 #include <linux/sysfs.h>
+#include <linux/balloon_compaction.h>
 #include "internal.h"
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
@@ -312,32 +313,40 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			continue;
 		}
 
-		if (!PageLRU(page))
-			continue;
-
 		/*
-		 * PageLRU is set, and lru_lock excludes isolation,
-		 * splitting and collapsing (collapsing has already
-		 * happened if PageLRU is set).
+		 * It is possible to migrate LRU pages and balloon pages.
+		 * Skip any other type of page.
 		 */
-		if (PageTransHuge(page)) {
-			low_pfn += (1 << compound_order(page)) - 1;
-			continue;
-		}
+		if (PageLRU(page)) {
+			/*
+			 * PageLRU is set, and lru_lock excludes isolation,
+			 * splitting and collapsing (collapsing has already
+			 * happened if PageLRU is set).
+			 */
+			if (PageTransHuge(page)) {
+				low_pfn += (1 << compound_order(page)) - 1;
+				continue;
+			}
 
-		if (!cc->sync)
-			mode |= ISOLATE_ASYNC_MIGRATE;
+			if (!cc->sync)
+				mode |= ISOLATE_ASYNC_MIGRATE;
 
-		lruvec = mem_cgroup_page_lruvec(page, zone);
+			lruvec = mem_cgroup_page_lruvec(page, zone);
 
-		/* Try isolate the page */
-		if (__isolate_lru_page(page, mode) != 0)
-			continue;
+			/* Try isolate the page */
+			if (__isolate_lru_page(page, mode) != 0)
+				continue;
 
-		VM_BUG_ON(PageTransCompound(page));
+			VM_BUG_ON(PageTransCompound(page));
+
+			/* Successfully isolated */
+			del_page_from_lru_list(page, lruvec, page_lru(page));
+		} else if (unlikely(movable_balloon_page(page))) {
+			if (!isolate_balloon_page(page))
+				continue;
+		} else
+			continue;
 
-		/* Successfully isolated */
-		del_page_from_lru_list(page, lruvec, page_lru(page));
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
 		nr_isolated++;
diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..6392da258 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -35,6 +35,7 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
+#include <linux/balloon_compaction.h>
 
 #include <asm/tlbflush.h>
 
@@ -79,7 +80,10 @@ void putback_lru_pages(struct list_head *l)
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		putback_lru_page(page);
+		if (unlikely(movable_balloon_page(page)))
+			putback_balloon_page(page);
+		else
+			putback_lru_page(page);
 	}
 }
 
@@ -778,6 +782,17 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 		}
 	}
 
+	if (unlikely(movable_balloon_page(page))) {
+		/*
+		 * A ballooned page does not need any special attention from
+		 * physical to virtual reverse mapping procedures.
+		 * Skip any attempt to unmap PTEs or to remap swap cache,
+		 * in order to avoid burning cycles at rmap level.
+		 */
+		remap_swapcache = 0;
+		goto skip_unmap;
+	}
+
 	/*
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
@@ -846,6 +861,20 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 			goto out;
 
 	rc = __unmap_and_move(page, newpage, force, offlining, mode);
+
+	if (unlikely(movable_balloon_page(newpage))) {
+		/*
+		 * A ballooned page has been migrated already. Now, it is the
+		 * time to wrap-up counters, handle the old page back to Buddy
+		 * and return.
+		 */
+		list_del(&page->lru);
+		dec_zone_page_state(page, NR_ISOLATED_ANON +
+				    page_is_file_cache(page));
+		put_page(page);
+		__free_page(page);
+		return rc;
+	}
 out:
 	if (rc != -EAGAIN) {
 		/*
-- 
1.7.11.4

