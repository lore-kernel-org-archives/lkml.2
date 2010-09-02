Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0IBNTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:19:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab0IBNS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:18:59 -0400
Date: Thu, 2 Sep 2010 15:18:55 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH] Make is_mem_section_removable more conformable with
 offlining code
Message-ID: <20100902131855.GC10265@tiehlicka.suse.cz>
References: <20100822004232.GA11007@localhost>
 <20100823092246.GA25772@tiehlicka.suse.cz>
 <20100831141942.GA30353@localhost>
 <20100901121951.GC6663@tiehlicka.suse.cz>
 <20100901124138.GD6663@tiehlicka.suse.cz>
 <20100902144500.a0d05b08.kamezawa.hiroyu@jp.fujitsu.com>
 <20100902082829.GA10265@tiehlicka.suse.cz>
 <20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
 <20100902092454.GA17971@tiehlicka.suse.cz>
 <AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02-09-10 20:19:45, Hiroyuki Kamezawa wrote:
> 2010/9/2 Michal Hocko <mhocko@suse.cz>:
> > On Thu 02-09-10 18:03:43, KAMEZAWA Hiroyuki wrote:
> >> On Thu, 2 Sep 2010 10:28:29 +0200
> >> Michal Hocko <mhocko@suse.cz> wrote:
> >>
> >> > On Thu 02-09-10 14:45:00, KAMEZAWA Hiroyuki wrote:
[...]
> >> > By the higher fragmentation you mean that all movable pageblocks (even
> >> > reclaimable) gets to MIGRATE_MOVABLE until we get first failure. In the
> >> > worst case, if we fail near the end of the zone then there is imbalance
> >> > in MIGRATE_MOVABLE vs. MIGRATE_RECALIMABLE. Is that what you are
> >> > thinking of? Doesn't this just gets the zone to the state after
> >> > onlining? Or is the problem if we fail somewhere in the middle?
> >> >
> >>
> >> No. My concern is pageblock type changes before/after memory hotplug failure.
> >> ? ? ? before isolation: MIGRATE_RECLAIMABLE
> >> ? ? ? after isolation failure : MIGRATE_MOVABLE
> >
> > Ahh, OK I can see your point now. unset_migratetype_isolate called on
> > the failure path sets migrate type unconditionally as it cannot know
> > what was the original migration type.
> >
> Right.
> 
> > What about MIGRATE_RESERVE? Is there anything that can make those
> > allocations fail offlining?
> >
> MIGRATE_RESERVE can contain several typs of pages, mixture of movable/unmovable
> pages.

Ahh, ok. This is just a fallback zone. I see.

> 
> IIRC, my 1st version of code of set_migratetype_isolate() just checks
> zone_idx and
> I think checking MIGRATE_TYPE is my mistake.
> (As Mel explained, it can be a mixture of several types.)
> 
> So, how about using the latter half of set_migratetype_isolate()'s check ?
> It checks that the given range just includes free pages and LRU pages.
> It's 100% accurate and more trustable than migrate_type check.
> 
> Whatever migratetype the pageblock has, if the block only contains free pages
> and lru pages, changing the type as MOVABLE (at failure) is not very bad.
> 
> (Or, checking contents of pageblock in failure path and set proper
> MIGRATE type.)
> 
> Anyway, not very difficult. Just a bit larger patch than you have.

What about this? Just compile tested.

---
>From a2aaeafbaeb5b195b699df25060128b9e547949c Mon Sep 17 00:00:00 2001
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

Do not rely on any of MIGRATE_* types as all others than MIGRATE_MOVABLE
may be tricky. MIGRATE_RESERVE can be anything that just happened to
fallback to that allocation, MIGRATE_RECLAIMABLE can be unmovable
because slab (or what ever) has this page currently in use. If we tried
to remove those pages and the isolation failed then those blocks
would get to the MIRAGTE_MOVABLE list and we will end up with the
unmovable pages in the movable zone.

Let's, instead, check just whether a pageblock contains free or LRU
pages.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/mmzone.h |   24 ++++++++++++++++++++++++
 mm/memory_hotplug.c    |   19 +------------------
 mm/page_alloc.c        |    5 +----
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6e6e626..0bd941b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -669,6 +669,30 @@ unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
  */
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+/*
+ * A free or LRU pages block are removable
+ * Do not use MIGRATE_MOVABLE because it can be insufficient and
+ * other MIGRATE types are tricky.
+ */
+static inline bool is_page_removable(struct page *page)
+{
+	int page_block = 1 << pageblock_order;
+	for (page_block > 0) {
+		if (PageBuddy(page)) {
+			page_block -= page_order(page);
+		}else if (PageLRU(page))
+			page_block--;
+		else 
+			return false;
+	}
+
+	return true;
+}
+#else
+#define is_page_removable(p) 0
+#endif
+
 static inline int populated_zone(struct zone *zone)
 {
 	return (!!zone->present_pages);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a4cfcdc..66195b8 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -569,17 +569,6 @@ out:
 EXPORT_SYMBOL_GPL(add_memory);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-/*
- * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy
- * set and the size of the free page is given by page_order(). Using this,
- * the function determines if the pageblock contains only free pages.
- * Due to buddy contraints, a free page at least the size of a pageblock will
- * be located at the start of the pageblock
- */
-static inline int pageblock_free(struct page *page)
-{
-	return PageBuddy(page) && page_order(page) >= pageblock_order;
-}
 
 /* Return the start of the next active pageblock after a given page */
 static struct page *next_active_pageblock(struct page *page)
@@ -608,13 +597,7 @@ int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
 
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
