Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0IGBl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:41:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49613 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0IGBlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:41:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 7 Sep 2010 10:36:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, fengguang.wu@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, andi.kleen@intel.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 3/3] memory hotplug: unify is_removable and offline
 detection code
Message-Id: <20100907103618.b2d499d4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100907102813.d633b8ef.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
	<20100907102813.d633b8ef.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, sysfs interface of memory hotplug shows whether the section is
removable or not. But it checks only migrateype of pages and doesn't
check details of cluster of pages.

Next, memory hotplug's set_migratetype_isolate() has the same kind
of check, too. 

This patch adds the function __count_unmovable_pages() and makes
above 2 checks to use the same logic. Then, is_removable and
hotremove code uses the same logic. No changes in the hotremove
logic itself.

TODO: need to find a way to check RECLAMABLE. But, considering bit,
      calling shrink_slab() against a range before starting memory hotremove
      sounds better. If so, this patch's logic doesn't need to be changed.

Changelog 2010.09.07:
 - modified __count_movable_pages() to get "count" as arguments.
 - renamed is_pageblock_removable_async as is_pageblock_removable_nolock.
 - added cond_resched().
 - no changes in offline logic itself.
 - added #ifdef

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memory_hotplug.h |    4 +
 mm/memory_hotplug.c            |   17 --------
 mm/page_alloc.c                |   87 +++++++++++++++++++++++++++++++----------
 3 files changed, 72 insertions(+), 36 deletions(-)

Index: kametest/mm/page_alloc.c
===================================================================
--- kametest.orig/mm/page_alloc.c
+++ kametest/mm/page_alloc.c
@@ -5274,12 +5274,65 @@ void set_pageblock_flags_group(struct pa
  * page allocater never alloc memory from ISOLATE block.
  */
 
+static int
+__count_immobile_pages(struct zone *zone, struct page *page, int count)
+{
+	unsigned long pfn, iter, found;
+	/*
+	 * For avoiding noise data, lru_add_drain_all() should be called
+ 	 * If ZONE_MOVABLE, the zone never contains immobile pages
+ 	 */
+	if (zone_idx(zone) == ZONE_MOVABLE)
+		return true;
+
+	if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE)
+		return true;
+
+	pfn = page_to_pfn(page);
+	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
+		unsigned long check = pfn + iter;
+
+		if (!pfn_valid_within(check)) {
+			iter++;
+			continue;
+		}
+		page = pfn_to_page(check);
+		if (!page_count(page)) {
+			if (PageBuddy(page))
+				iter += (1 << page_order(page)) - 1;
+			continue;
+		}
+		if (!PageLRU(page))
+			found++;
+		/*
+		 * If there are RECLAIMABLE pages, we need to check it.
+		 * But now, memory offline itself doesn't call shrink_slab()
+		 * and it still to be fixed.
+		 */
+		/*
+		 * If the page is not RAM, page_count()should be 0.
+		 * we don't need more check. This is an _used_ not-movable page.
+		 *
+		 * The problematic thing here is PG_reserved pages. PG_reserved
+		 * is set to both of a memory hole page and a _used_ kernel
+		 * page at boot.
+		 */
+		if (found > count)
+			return false;
+	}
+	return true;
+}
+
+bool is_pageblock_removable_nolock(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+	return __count_immobile_pages(zone, page, 0);
+}
+
 int set_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	struct page *curr_page;
-	unsigned long flags, pfn, iter;
-	unsigned long immobile = 0;
+	unsigned long flags, pfn;
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
@@ -5289,11 +5342,6 @@ int set_migratetype_isolate(struct page 
 	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
-	if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE ||
-	    zone_idx == ZONE_MOVABLE) {
-		ret = 0;
-		goto out;
-	}
 
 	pfn = page_to_pfn(page);
 	arg.start_pfn = pfn;
@@ -5315,21 +5363,18 @@ int set_migratetype_isolate(struct page 
 	notifier_ret = notifier_to_errno(notifier_ret);
 	if (notifier_ret)
 		goto out;
-
-	for (iter = pfn; iter < (pfn + pageblock_nr_pages); iter++) {
-		if (!pfn_valid_within(pfn))
-			continue;
-
-		curr_page = pfn_to_page(iter);
-		if (!page_count(curr_page) || PageLRU(curr_page))
-			continue;
-
-		immobile++;
-	}
-
-	if (arg.pages_found == immobile)
+	/*
+	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
+	 * We just check MOVABLE pages.
+	 */
+	if(__count_immobile_pages(zone ,page, arg.pages_found))
 		ret = 0;
 
+	/*
+	 * immobile means "not-on-lru" paes. If immobile is larger than
+	 * removable-by-driver pages reported by notifier, we'll fail.
+	 */
+
 out:
 	if (!ret) {
 		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
Index: kametest/mm/memory_hotplug.c
===================================================================
--- kametest.orig/mm/memory_hotplug.c
+++ kametest/mm/memory_hotplug.c
@@ -602,27 +602,14 @@ static struct page *next_active_pagebloc
 /* Checks if this range of memory is likely to be hot-removable. */
 int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
 {
-	int type;
 	struct page *page = pfn_to_page(start_pfn);
 	struct page *end_page = page + nr_pages;
 
 	/* Check the starting page of each pageblock within the range */
 	for (; page < end_page; page = next_active_pageblock(page)) {
-		type = get_pageblock_migratetype(page);
-
-		/*
-		 * A pageblock containing MOVABLE or free pages is considered
-		 * removable
-		 */
-		if (type != MIGRATE_MOVABLE && !pageblock_free(page))
-			return 0;
-
-		/*
-		 * A pageblock starting with a PageReserved page is not
-		 * considered removable.
-		 */
-		if (PageReserved(page))
+		if (!is_pageblock_removable_nolock(page))
 			return 0;
+		cond_resched();
 	}
 
 	/* All pageblocks in the memory block are likely to be hot-removable */
Index: kametest/include/linux/memory_hotplug.h
===================================================================
--- kametest.orig/include/linux/memory_hotplug.h
+++ kametest/include/linux/memory_hotplug.h
@@ -70,6 +70,10 @@ extern void online_page(struct page *pag
 extern int online_pages(unsigned long, unsigned long);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+extern bool is_pageblock_removable_nolock(struct page *page);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);

