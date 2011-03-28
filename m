Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1C1JlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:41:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:51941 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1C1JlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:41:02 -0400
X-Mailbox-Line: From mhocko@suse.cz Mon Mar 28 11:39:57 2011
Message-Id: <20110328093957.450790892@suse.cz>
User-Agent: quilt/0.48-1
Date: Mon, 28 Mar 2011 11:39:59 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 2/3] Implement isolated LRU cgroups
References: <20110328093957.089007035@suse.cz>
Content-Disposition: inline; filename=memcg_handle_global_lru_isolated_pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The primary idea behind isolated pages is in a better isolation of a group from
the global system and other groups activity. At the moment, memory cgroups are
mainly used to throttle processes in a group by placing a cap on their memory
usage. However, mem. cgroups don't protect their (charged) memory from being
evicted by the global reclaim as all its pages are on the global LRU.

This feature will provide an easy way to setup an application in
the memory isolated environment without necessity of mlock to keep its pages
in the memory. Due to per-cgroup reclaim, we can eliminate interference between
unrelated cgroups that exhibit a spike in memory usage.

A similar setup could be achieved with the current implementation as well by
placing the critical application into the root group while all other
processes would be placed in another group (or groups). This is, however,
much harder to configure and also we have only one such an "exclusive" group
on the system which is quite limiting.

This goal is achieved by isolating those pages from the global LRU and
keeping them on a per-cgroup LRU only so the memory cgroup is not affected
by the global reclaim at all.

If we isolate mem-cgroup pages from the global LRU we can still do the
per-cgroup reclaim so the isolation is not the same thing as mlocking that
memory.

is_mem_cgroup_isolated is not called directly by the code that adds
(__add_page_to_lru_list) or moves (isolate_lru_pages,
move_active_pages_to_lru, check_move_unevictable_page, pagevec_move_tail,
lru_deactivate) pages into an LRU because we would need to find a
page_cgroup for the page and this would add an overhead. We changed the
semantic for memcg LRU functions (which add or move pages to mem cgroup LRU)
instead to return a flag whether the page is global (return true) or mem
cgroup isolated.

page->lru is initialized to an empty list whenever the page is not on the
global LRU to make the LRU removal path without modifications. The page is
still mark PageLRU so nobody else will misuse page->lru for other purposes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>

---
 include/linux/memcontrol.h |   22 ++++++++++++----------
 include/linux/mm_inline.h  |   10 ++++++++--
 mm/memcontrol.c            |   36 +++++++++++++++++++++---------------
 mm/swap.c                  |   12 ++++++++----
 mm/vmscan.c                |   25 +++++++++++++++++--------
 5 files changed, 66 insertions(+), 39 deletions(-)

Index: linux-2.6.38-rc8/include/linux/memcontrol.h
===================================================================
--- linux-2.6.38-rc8.orig/include/linux/memcontrol.h	2011-03-28 11:23:58.000000000 +0200
+++ linux-2.6.38-rc8/include/linux/memcontrol.h	2011-03-28 11:24:20.000000000 +0200
@@ -60,12 +60,12 @@ extern void mem_cgroup_cancel_charge_swa
 
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
-extern void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru);
+extern bool mem_cgroup_add_lru_list(struct page *page, enum lru_list lru);
 extern void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru);
-extern void mem_cgroup_rotate_reclaimable_page(struct page *page);
-extern void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru);
+extern bool mem_cgroup_rotate_reclaimable_page(struct page *page);
+extern bool mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru);
 extern void mem_cgroup_del_lru(struct page *page);
-extern void mem_cgroup_move_lists(struct page *page,
+extern bool mem_cgroup_move_lists(struct page *page,
 				  enum lru_list from, enum lru_list to);
 
 /* For coalescing uncharge for reducing memcg' overhead*/
@@ -209,13 +209,14 @@ static inline int mem_cgroup_shmem_charg
 	return 0;
 }
 
-static inline void mem_cgroup_add_lru_list(struct page *page, int lru)
+static inline bool mem_cgroup_add_lru_list(struct page *page, int lru)
 {
+	return true;
 }
 
-static inline void mem_cgroup_del_lru_list(struct page *page, int lru)
+static inline bool mem_cgroup_del_lru_list(struct page *page, int lru)
 {
-	return ;
+	return true;
 }
 
 static inline inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
@@ -223,9 +224,9 @@ static inline inline void mem_cgroup_rot
 	return ;
 }
 
-static inline void mem_cgroup_rotate_lru_list(struct page *page, int lru)
+static inline bool mem_cgroup_rotate_lru_list(struct page *page, int lru)
 {
-	return ;
+	return true;
 }
 
 static inline void mem_cgroup_del_lru(struct page *page)
@@ -233,9 +234,10 @@ static inline void mem_cgroup_del_lru(st
 	return ;
 }
 
-static inline void
+static inline bool
 mem_cgroup_move_lists(struct page *page, enum lru_list from, enum lru_list to)
 {
+	return true;
 }
 
 static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
Index: linux-2.6.38-rc8/include/linux/mm_inline.h
===================================================================
--- linux-2.6.38-rc8.orig/include/linux/mm_inline.h	2011-03-28 11:23:58.000000000 +0200
+++ linux-2.6.38-rc8/include/linux/mm_inline.h	2011-03-28 11:24:20.000000000 +0200
@@ -25,9 +25,15 @@ static inline void
 __add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l,
 		       struct list_head *head)
 {
-	list_add(&page->lru, head);
 	__mod_zone_page_state(zone, NR_LRU_BASE + l, hpage_nr_pages(page));
-	mem_cgroup_add_lru_list(page, l);
+
+	/* Add to the global LRU only if cgroup doesn't want the page 
+	 * exclusively 
+	 */
+	if (mem_cgroup_add_lru_list(page, l))
+		list_add(&page->lru, head);
+	else
+		INIT_LIST_HEAD(&page->lru);
 }
 
 static inline void
Index: linux-2.6.38-rc8/mm/memcontrol.c
===================================================================
--- linux-2.6.38-rc8.orig/mm/memcontrol.c	2011-03-28 11:23:58.000000000 +0200
+++ linux-2.6.38-rc8/mm/memcontrol.c	2011-03-28 11:24:20.000000000 +0200
@@ -866,58 +866,62 @@ void mem_cgroup_del_lru(struct page *pag
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
  * inactive list.
  */
-void mem_cgroup_rotate_reclaimable_page(struct page *page)
+bool mem_cgroup_rotate_reclaimable_page(struct page *page)
 {
 	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
 	enum lru_list lru = page_lru(page);
 
 	if (mem_cgroup_disabled())
-		return;
+		return true;
 
 	pc = lookup_page_cgroup(page);
 	/* unused or root page is not rotated. */
 	if (!PageCgroupUsed(pc))
-		return;
+		return true;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
+		return true;
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move_tail(&pc->lru, &mz->lists[lru]);
+
+	return !is_mem_cgroup_isolated(pc->mem_cgroup);
 }
 
-void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru)
+bool mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
 
 	if (mem_cgroup_disabled())
-		return;
+		return true;
 
 	pc = lookup_page_cgroup(page);
 	/* unused or root page is not rotated. */
 	if (!PageCgroupUsed(pc))
-		return;
+		return true;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
+		return true;
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move(&pc->lru, &mz->lists[lru]);
+
+	return !is_mem_cgroup_isolated(pc->mem_cgroup);
 }
 
-void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru)
+bool mem_cgroup_add_lru_list(struct page *page, enum lru_list lru)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
 
 	if (mem_cgroup_disabled())
-		return;
+		return true;
 	pc = lookup_page_cgroup(page);
 	VM_BUG_ON(PageCgroupAcctLRU(pc));
 	if (!PageCgroupUsed(pc))
-		return;
+		return true;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
@@ -925,8 +929,10 @@ void mem_cgroup_add_lru_list(struct page
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
 	SetPageCgroupAcctLRU(pc);
 	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
+		return true;
 	list_add(&pc->lru, &mz->lists[lru]);
+
+	return !is_mem_cgroup_isolated(pc->mem_cgroup);
 }
 
 /*
@@ -979,13 +985,13 @@ static void mem_cgroup_lru_add_after_com
 }
 
 
-void mem_cgroup_move_lists(struct page *page,
+bool mem_cgroup_move_lists(struct page *page,
 			   enum lru_list from, enum lru_list to)
 {
 	if (mem_cgroup_disabled())
-		return;
+		return true;
 	mem_cgroup_del_lru_list(page, from);
-	mem_cgroup_add_lru_list(page, to);
+	return mem_cgroup_add_lru_list(page, to);
 }
 
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
Index: linux-2.6.38-rc8/mm/vmscan.c
===================================================================
--- linux-2.6.38-rc8.orig/mm/vmscan.c	2011-03-28 11:23:58.000000000 +0200
+++ linux-2.6.38-rc8/mm/vmscan.c	2011-03-28 11:24:57.000000000 +0200
@@ -1049,8 +1049,10 @@ static unsigned long isolate_lru_pages(u
 
 		case -EBUSY:
 			/* else it is being freed elsewhere */
-			list_move(&page->lru, src);
-			mem_cgroup_rotate_lru_list(page, page_lru(page));
+			if (mem_cgroup_rotate_lru_list(page, page_lru(page)))
+				list_move(&page->lru, src);
+			else
+				list_del_init(&page->lru);
 			continue;
 
 		default:
@@ -1482,8 +1484,11 @@ static void move_active_pages_to_lru(str
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 
-		list_move(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_add_lru_list(page, lru);
+		if (mem_cgroup_add_lru_list(page, lru))
+			list_move(&page->lru, &zone->lru[lru].list);
+		else
+			list_del_init(&page->lru);
+
 		pgmoved += hpage_nr_pages(page);
 
 		if (!pagevec_add(&pvec, page) || list_empty(list)) {
@@ -3133,8 +3138,10 @@ retry:
 		enum lru_list l = page_lru_base_type(page);
 
 		__dec_zone_state(zone, NR_UNEVICTABLE);
-		list_move(&page->lru, &zone->lru[l].list);
-		mem_cgroup_move_lists(page, LRU_UNEVICTABLE, l);
+		if (mem_cgroup_move_lists(page, LRU_UNEVICTABLE, l))
+			list_move(&page->lru, &zone->lru[l].list);
+		else
+			list_del_init(&page->lru);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
 		__count_vm_event(UNEVICTABLE_PGRESCUED);
 	} else {
@@ -3142,8 +3149,10 @@ retry:
 		 * rotate unevictable list
 		 */
 		SetPageUnevictable(page);
-		list_move(&page->lru, &zone->lru[LRU_UNEVICTABLE].list);
-		mem_cgroup_rotate_lru_list(page, LRU_UNEVICTABLE);
+		if (mem_cgroup_rotate_lru_list(page, LRU_UNEVICTABLE))
+			list_move(&page->lru, &zone->lru[LRU_UNEVICTABLE].list);
+		else
+			list_del_init(&page->lru);
 		if (page_evictable(page, NULL))
 			goto retry;
 	}
Index: linux-2.6.38-rc8/mm/swap.c
===================================================================
--- linux-2.6.38-rc8.orig/mm/swap.c	2011-03-28 11:23:58.000000000 +0200
+++ linux-2.6.38-rc8/mm/swap.c	2011-03-28 11:24:20.000000000 +0200
@@ -201,8 +201,10 @@ static void pagevec_move_tail(struct pag
 		}
 		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 			enum lru_list lru = page_lru_base_type(page);
-			list_move_tail(&page->lru, &zone->lru[lru].list);
-			mem_cgroup_rotate_reclaimable_page(page);
+			if (mem_cgroup_rotate_reclaimable_page(page))
+				list_move_tail(&page->lru, &zone->lru[lru].list);
+			else
+				list_del_init(&page->lru);
 			pgmoved++;
 		}
 	}
@@ -402,8 +404,10 @@ static void lru_deactivate(struct page *
 		 * The page's writeback ends up during pagevec
 		 * We moves tha page into tail of inactive.
 		 */
-		list_move_tail(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_rotate_reclaimable_page(page);
+		if (mem_cgroup_rotate_reclaimable_page(page))
+			list_move_tail(&page->lru, &zone->lru[lru].list);
+		else
+			list_del_init(&page->lru);
 		__count_vm_event(PGROTATED);
 	}
 


