Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0ICJPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:15:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:49867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0ICJPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:15:16 -0400
Date: Fri, 3 Sep 2010 11:15:09 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] Make is_mem_section_removable more conformable
 with offlining code
Message-ID: <20100903091509.GE10686@tiehlicka.suse.cz>
References: <20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
 <20100902092454.GA17971@tiehlicka.suse.cz>
 <AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
 <20100902131855.GC10265@tiehlicka.suse.cz>
 <AANLkTikYt3Hu_XeNuwAa9KjzfWgpC8cNen6q657ZKmm-@mail.gmail.com>
 <20100902143939.GD10265@tiehlicka.suse.cz>
 <20100902150554.GE10265@tiehlicka.suse.cz>
 <20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100903121452.2d22b3aa.kamezawa.hiroyu@jp.fujitsu.com>
 <20100903082558.GC10686@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903082558.GC10686@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just in case that my old (buggy) approach still matters, here is the
updated (and hopefully fixed) patch.

---

>From 5e0436a854d7103eba53f173f6839032a2f43c21 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 20 Aug 2010 15:39:16 +0200
Subject: [PATCH] Make is_mem_section_removable more conformable with offlining code

Currently is_mem_section_removable checks whether each pageblock from
the given pfn range is of MIGRATE_MOVABLE type or if it is free. If both
are false then the range is considered non removable.

On the other hand, offlining code (more specifically
set_migratetype_isolate) doesn't care whether a page is free and instead
it just checks the migrate type of the page and whether the page's zone
is movable.

This can lead into a situation when we can mark a node as not removable
just because a pageblock is MIGRATE_RESERVE and it is not free but still
movable.

Let's make a common helper is_page_removable which unifies both tests
at one place.

Do not rely on any of MIGRATE_* types as all others but MIGRATE_MOVABLE
may be tricky. MIGRATE_RESERVE can be anything that just happened to
fallback to that allocation. MIGRATE_RECLAIMABLE can be unmovable
because slab (or what ever) has this page currently in use and cannot
release it.  If we tried to remove those pages and the isolation failed
then those blocks would get into the MIRAGTE_MOVABLE list
unconditionally and we will end up having unmovable pages in the movable
list.

Let's, instead, check just whether a pageblock contains only free or LRU
pages.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memory_hotplug.h |    4 +++
 mm/memory_hotplug.c            |   42 +++++++++++++++++++++++++++++++++------
 mm/page_alloc.c                |    5 +---
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 864035f..5c448f7 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -194,12 +194,16 @@ static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
 
+bool is_page_removable(struct page *page);
+
 #else
 static inline int is_mem_section_removable(unsigned long pfn,
 					unsigned long nr_pages)
 {
 	return 0;
 }
+
+#define is_page_removable(page) 0
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int mem_online_node(int nid);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a4cfcdc..ccd927d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -581,6 +581,39 @@ static inline int pageblock_free(struct page *page)
 	return PageBuddy(page) && page_order(page) >= pageblock_order;
 }
 
+/*
+ * A free or LRU pages block are removable
+ * Do not use MIGRATE_MOVABLE because it can be insufficient and
+ * other MIGRATE types are tricky.
+ * Do not hold zone->lock as this is used from user space by the
+ * sysfs interface.
+ */
+bool is_page_removable(struct page *page)
+{
+	int page_block = 1 << pageblock_order;
+	while (page_block > 0) {
+		int order = 0;
+
+		if (pfn_valid_within(page_to_pfn(page))) {
+			if (PageBuddy(page)) {
+				order = page_order(page);
+			} else if (!PageLRU(page))
+				return false;
+		}
+
+		/* We are not holding zone lock so the page
+		 * might get used since we tested it for buddy
+		 * flag. This is just a informative check so
+		 * live with that and rely that we catch this
+		 * in the page_block test.
+		 */
+		page_block -= 1 << order;
+		page += 1 << order;
+	}
+
+	return true;
+}
+
 /* Return the start of the next active pageblock after a given page */
 static struct page *next_active_pageblock(struct page *page)
 {
@@ -608,13 +641,7 @@ int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
 
 	/* Check the starting page of each pageblock within the range */
 	for (; page < end_page; page = next_active_pageblock(page)) {
-		type = get_pageblock_migratetype(page);
-
-		/*
-		 * A pageblock containing MOVABLE or free pages is considered
-		 * removable
-		 */
-		if (type != MIGRATE_MOVABLE && !pageblock_free(page))
+		if (!is_page_removable(page))
 			return 0;
 
 		/*
@@ -770,6 +797,7 @@ check_pages_isolated_cb(unsigned long start_pfn, unsigned long nr_pages,
 	return ret;
 }
 
+
 static long
 check_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a9649f4..c2e2576 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5277,14 +5277,11 @@ int set_migratetype_isolate(struct page *page)
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
-	int zone_idx;
 
 	zone = page_zone(page);
-	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
-	if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE ||
-	    zone_idx == ZONE_MOVABLE) {
+	if (is_page_removable(page)) {
 		ret = 0;
 		goto out;
 	}
-- 
1.7.1

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
