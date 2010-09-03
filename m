Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0ICDT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:19:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab0ICDTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:19:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 3 Sep 2010 12:14:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: [PATCH 2/2] Make is_mem_section_removable more conformable with
 offlining code
Message-Id: <20100903121452.2d22b3aa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100901121951.GC6663@tiehlicka.suse.cz>
	<20100901124138.GD6663@tiehlicka.suse.cz>
	<20100902144500.a0d05b08.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902082829.GA10265@tiehlicka.suse.cz>
	<20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902092454.GA17971@tiehlicka.suse.cz>
	<AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
	<20100902131855.GC10265@tiehlicka.suse.cz>
	<AANLkTikYt3Hu_XeNuwAa9KjzfWgpC8cNen6q657ZKmm-@mail.gmail.com>
	<20100902143939.GD10265@tiehlicka.suse.cz>
	<20100902150554.GE10265@tiehlicka.suse.cz>
	<20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
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
of check, too. But the migrate-type is just a "hint" and the pageblock
can contain several types of pages if fragmentation is very heavy.

To get precise information, we need to check
 - the pageblock only contains free pages or LRU pages.

This patch adds the function __count_unmovable_pages() and makes
above 2 checks to use the same logic. This will improve user experience
of memory hotplug because sysfs interface tells accurate information.

Note:
it may be better to check MIGRATE_UNMOVABLE for making failure case quick.
Note2:
I'm not sure but notifer should be called ??

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memory_hotplug.h |    1 
 mm/memory_hotplug.c            |   15 --------
 mm/page_alloc.c                |   76 ++++++++++++++++++++++++++++++-----------
 3 files changed, 59 insertions(+), 33 deletions(-)

Index: mmotm-0827/mm/page_alloc.c
===================================================================
--- mmotm-0827.orig/mm/page_alloc.c
+++ mmotm-0827/mm/page_alloc.c
@@ -5274,11 +5274,63 @@ void set_pageblock_flags_group(struct pa
  * page allocater never alloc memory from ISOLATE block.
  */
 
+static int __count_unmovable_pages(struct zone *zone, struct page *page)
+{
+	unsigned long pfn, iter, found;
+	/*
+	 * For avoiding noise data, lru_add_drain_all() should be called.
+ 	 * before this.
+ 	 */
+	if (zone_idx(zone) == ZONE_MOVABLE)
+		return 0;
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
+		 * If the page is not RAM, page_count()should be 0.
+		 * we don't need more check. This is an _used_ not-movable page.
+		 *
+		 * The problematic thing here is PG_reserved pages. But if
+		 * a PG_reserved page is _used_ (at boot), page_count > 1.
+		 * But...is there PG_reserved && page_count(page)==0 page ?
+		 */
+	}
+	return found;
+}
+
+bool is_pageblock_removable(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+	unsigned long flags;
+	int num;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	num = __count_unmovable_pages(zone, page);
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	if (num)
+		return false;
+	return true;
+}
+
 int set_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	struct page *curr_page;
-	unsigned long flags, pfn, iter;
+	unsigned long flags, pfn;
 	unsigned long immobile = 0;
 	struct memory_isolate_notify arg;
 	int notifier_ret;
@@ -5289,11 +5341,6 @@ int set_migratetype_isolate(struct page 
 	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
-	if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE ||
-	    zone_idx == ZONE_MOVABLE) {
-		ret = 0;
-		goto out;
-	}
 
 	pfn = page_to_pfn(page);
 	arg.start_pfn = pfn;
@@ -5315,19 +5362,9 @@ int set_migratetype_isolate(struct page 
 	notifier_ret = notifier_to_errno(notifier_ret);
 	if (notifier_ret || !arg.pages_found)
 		goto out;
+	immobile = __count_unmovable_pages(zone ,page);
 
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
+	if (!immobile || arg.pages_found == immobile)
 		ret = 0;
 
 out:
Index: mmotm-0827/mm/memory_hotplug.c
===================================================================
--- mmotm-0827.orig/mm/memory_hotplug.c
+++ mmotm-0827/mm/memory_hotplug.c
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
+		if (!is_pageblock_removable(page))
 			return 0;
 
-		/*
-		 * A pageblock starting with a PageReserved page is not
-		 * considered removable.
-		 */
-		if (PageReserved(page))
-			return 0;
 	}
 
 	/* All pageblocks in the memory block are likely to be hot-removable */
Index: mmotm-0827/include/linux/memory_hotplug.h
===================================================================
--- mmotm-0827.orig/include/linux/memory_hotplug.h
+++ mmotm-0827/include/linux/memory_hotplug.h
@@ -76,6 +76,7 @@ extern int __add_pages(int nid, struct z
 extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
 
+extern bool is_pageblock_removable(struct page *page);
 #ifdef CONFIG_NUMA
 extern int memory_add_physaddr_to_nid(u64 start);
 #else

