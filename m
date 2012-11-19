Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2KSC0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:26:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40320 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2KSC0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:26:03 -0500
Date: Mon, 19 Nov 2012 03:25:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 17/19, v2] mm/migrate: Introduce migrate_misplaced_page()
Message-ID: <20121119022558.GA3186@gmail.com>
References: <1353083121-4560-1-git-send-email-mingo@kernel.org>
 <1353083121-4560-18-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353083121-4560-18-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Add migrate_misplaced_page() which deals with migrating pages from
> faults.
> 
> This includes adding a new MIGRATE_FAULT migration mode to
> deal with the extra page reference required due to having to look up
> the page.
[...]

> --- a/include/linux/migrate_mode.h
> +++ b/include/linux/migrate_mode.h
> @@ -6,11 +6,14 @@
>   *	on most operations but not ->writepage as the potential stall time
>   *	is too significant
>   * MIGRATE_SYNC will block when migrating pages
> + * MIGRATE_FAULT called from the fault path to migrate-on-fault for mempolicy
> + *	this path has an extra reference count
>   */

Note, this is still the older, open-coded version.

The newer replacement version created from Mel's patch which 
reuses migrate_pages() and is nicer on out-of-node-memory 
conditions and is cleaner all around can be found below.

I tested it today and it appears to work fine. I noticed no 
performance improvement or performance drop from it - if it 
holds up in testing it will be part of the -v17 release of 
numa/core.

Thanks,

	Ingo

-------------------------->
Subject: mm/migration: Introduce migrate_misplaced_page()
From: Mel Gorman <mgorman@suse.de>
Date: Fri, 16 Nov 2012 11:22:23 +0000

Note: This was originally based on Peter's patch "mm/migrate: Introduce
	migrate_misplaced_page()" but borrows extremely heavily from Andrea's
	"autonuma: memory follows CPU algorithm and task/mm_autonuma stats
	collection". The end result is barely recognisable so signed-offs
	had to be dropped. If original authors are ok with it, I'll
	re-add the signed-off-bys.

Add migrate_misplaced_page() which deals with migrating pages
from faults.

Based-on-work-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Based-on-work-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Based-on-work-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Link: http://lkml.kernel.org/r/1353064973-26082-14-git-send-email-mgorman@suse.de
[ Adapted to the numa/core tree. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/memory.c  |   13 ++-----
 mm/migrate.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 106 insertions(+), 10 deletions(-)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c
+++ linux/mm/memory.c
@@ -3494,28 +3494,25 @@ out_pte_upgrade_unlock:
 
 out_unlock:
 	pte_unmap_unlock(ptep, ptl);
-out:
+
 	if (page) {
 		task_numa_fault(page_nid, last_cpu, 1);
 		put_page(page);
 	}
-
+out:
 	return 0;
 
 migrate:
 	pte_unmap_unlock(ptep, ptl);
 
-	if (!migrate_misplaced_page(page, node)) {
-		page_nid = node;
+	if (migrate_misplaced_page(page, node)) {
 		goto out;
 	}
+	page = NULL;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (!pte_same(*ptep, entry)) {
-		put_page(page);
-		page = NULL;
+	if (!pte_same(*ptep, entry))
 		goto out_unlock;
-	}
 
 	goto out_pte_upgrade_unlock;
 }
Index: linux/mm/migrate.c
===================================================================
--- linux.orig/mm/migrate.c
+++ linux/mm/migrate.c
@@ -279,7 +279,7 @@ static int migrate_page_move_mapping(str
 		struct page *newpage, struct page *page,
 		struct buffer_head *head, enum migrate_mode mode)
 {
-	int expected_count;
+	int expected_count = 0;
 	void **pslot;
 
 	if (!mapping) {
@@ -1403,4 +1403,103 @@ int migrate_vmas(struct mm_struct *mm, c
  	}
  	return err;
 }
-#endif
+
+/*
+ * Returns true if this is a safe migration target node for misplaced NUMA
+ * pages. Currently it only checks the watermarks which crude
+ */
+static bool migrate_balanced_pgdat(struct pglist_data *pgdat,
+				   int nr_migrate_pages)
+{
+	int z;
+	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
+		struct zone *zone = pgdat->node_zones + z;
+
+		if (!populated_zone(zone))
+			continue;
+
+		if (zone->all_unreclaimable)
+			continue;
+
+		/* Avoid waking kswapd by allocating pages_to_migrate pages. */
+		if (!zone_watermark_ok(zone, 0,
+				       high_wmark_pages(zone) +
+				       nr_migrate_pages,
+				       0, 0))
+			continue;
+		return true;
+	}
+	return false;
+}
+
+static struct page *alloc_misplaced_dst_page(struct page *page,
+					   unsigned long data,
+					   int **result)
+{
+	int nid = (int) data;
+	struct page *newpage;
+
+	newpage = alloc_pages_exact_node(nid,
+					 (GFP_HIGHUSER_MOVABLE | GFP_THISNODE |
+					  __GFP_NOMEMALLOC | __GFP_NORETRY |
+					  __GFP_NOWARN) &
+					 ~GFP_IOFS, 0);
+	return newpage;
+}
+
+/*
+ * Attempt to migrate a misplaced page to the specified destination
+ * node. Caller is expected to have an elevated reference count on
+ * the page that will be dropped by this function before returning.
+ */
+int migrate_misplaced_page(struct page *page, int node)
+{
+	int isolated = 0;
+	LIST_HEAD(migratepages);
+
+	/*
+	 * Don't migrate pages that are mapped in multiple processes.
+	 * TODO: Handle false sharing detection instead of this hammer
+	 */
+	if (page_mapcount(page) != 1)
+		goto out;
+
+	/* Avoid migrating to a node that is nearly full */
+	if (migrate_balanced_pgdat(NODE_DATA(node), 1)) {
+		int page_lru;
+
+		if (isolate_lru_page(page)) {
+			put_page(page);
+			goto out;
+		}
+		isolated = 1;
+
+		/*
+		 * Page is isolated which takes a reference count so now the
+		 * callers reference can be safely dropped without the page
+		 * disappearing underneath us during migration
+		 */
+		put_page(page);
+
+		page_lru = page_is_file_cache(page);
+		inc_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
+		list_add(&page->lru, &migratepages);
+	}
+
+	if (isolated) {
+		int nr_remaining;
+
+		nr_remaining = migrate_pages(&migratepages,
+				alloc_misplaced_dst_page,
+				node, false, MIGRATE_ASYNC);
+		if (nr_remaining) {
+			putback_lru_pages(&migratepages);
+			isolated = 0;
+		}
+	}
+	BUG_ON(!list_empty(&migratepages));
+out:
+	return isolated;
+}
+
+#endif /* CONFIG_NUMA */
