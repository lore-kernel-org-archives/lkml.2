Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0DOK0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:26:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55702 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0DOK0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:26:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/4] vmscan: replace the pagevec in shrink_inactive_list() with list
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Chinner <david@fromorbit.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415185310.D1A1.A69D9226@jp.fujitsu.com>
References: <20100415085420.GT2493@dastard> <20100415185310.D1A1.A69D9226@jp.fujitsu.com>
Message-Id: <20100415192501.D1AD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 19:26:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64, sizeof(struct pagevec) is 8*16=128, but
sizeof(struct list_head) is 8*2=16. So, to replace pagevec with list
makes to reduce 112 bytes stack.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4de4029..fbc26d8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -93,6 +93,8 @@ struct scan_control {
 			unsigned long *scanned, int order, int mode,
 			struct zone *z, struct mem_cgroup *mem_cont,
 			int active, int file);
+
+	struct list_head free_batch_list;
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -641,13 +643,11 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 					enum pageout_io sync_writeback)
 {
 	LIST_HEAD(ret_pages);
-	struct pagevec freed_pvec;
 	int pgactivate = 0;
 	unsigned long nr_reclaimed = 0;
 
 	cond_resched();
 
-	pagevec_init(&freed_pvec, 1);
 	while (!list_empty(page_list)) {
 		enum page_references references;
 		struct address_space *mapping;
@@ -822,10 +822,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		__clear_page_locked(page);
 free_it:
 		nr_reclaimed++;
-		if (!pagevec_add(&freed_pvec, page)) {
-			__pagevec_free(&freed_pvec);
-			pagevec_reinit(&freed_pvec);
-		}
+		list_add(&page->lru, &sc->free_batch_list);
 		continue;
 
 cull_mlocked:
@@ -849,8 +846,6 @@ keep:
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
 	list_splice(&ret_pages, page_list);
-	if (pagevec_count(&freed_pvec))
-		__pagevec_free(&freed_pvec);
 	count_vm_events(PGACTIVATE, pgactivate);
 	return nr_reclaimed;
 }
@@ -1238,6 +1233,11 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 						 PAGEOUT_IO_SYNC);
 	}
 
+	/*
+	 * Free unused pages.
+	 */
+	free_pages_bulk(zone, &sc->free_batch_list);
+
 	local_irq_disable();
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
@@ -1844,6 +1844,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		.mem_cgroup = NULL,
 		.isolate_pages = isolate_pages_global,
 		.nodemask = nodemask,
+		.free_batch_list = LIST_HEAD_INIT(sc.free_batch_list),
 	};
 
 	return do_try_to_free_pages(zonelist, &sc);
@@ -1864,6 +1865,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 		.order = 0,
 		.mem_cgroup = mem,
 		.isolate_pages = mem_cgroup_isolate_pages,
+		.free_batch_list = LIST_HEAD_INIT(sc.free_batch_list),
 	};
 	nodemask_t nm  = nodemask_of_node(nid);
 
@@ -1900,6 +1902,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 		.mem_cgroup = mem_cont,
 		.isolate_pages = mem_cgroup_isolate_pages,
 		.nodemask = NULL, /* we don't care the placement */
+		.free_batch_list = LIST_HEAD_INIT(sc.free_batch_list),
 	};
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
@@ -1976,6 +1979,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 		.order = order,
 		.mem_cgroup = NULL,
 		.isolate_pages = isolate_pages_global,
+		.free_batch_list = LIST_HEAD_INIT(sc.free_batch_list),
 	};
 loop_again:
 	total_scanned = 0;
@@ -2333,6 +2337,7 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 		.swappiness = vm_swappiness,
 		.order = 0,
 		.isolate_pages = isolate_pages_global,
+		.free_batch_list = LIST_HEAD_INIT(sc.free_batch_list),
 	};
 	struct zonelist * zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
@@ -2517,6 +2522,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.swappiness = vm_swappiness,
 		.order = order,
 		.isolate_pages = isolate_pages_global,
+		.free_batch_list = LIST_HEAD_INIT(sc.free_batch_list),
 	};
 	unsigned long slab_reclaimable;
 
-- 
1.6.5.2



