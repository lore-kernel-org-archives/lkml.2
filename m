Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2BWNwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:52:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39147 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2BWNwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:52:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.148.90 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v3 07/21] mm: add lruvec->pages_count
To: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Date: Thu, 23 Feb 2012 17:52:08 +0400
Message-ID: <20120223135208.12988.74252.stgit@zurg>
In-Reply-To: <20120223133728.12988.5432.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move lru pages counter from mem_cgroup_per_zone->count[] to lruvec->pages_count[]

Account pages in all lruvecs, incuding root,
this isn't a huge overhead, but it greatly simplifies all code.

Redundant page_lruvec() calls will be optimized in further patches.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/memcontrol.h |   29 --------------
 include/linux/mm_inline.h  |   15 +++++--
 include/linux/mmzone.h     |    1 
 mm/memcontrol.c            |   93 +-------------------------------------------
 mm/swap.c                  |    7 +--
 mm/vmscan.c                |   25 +++++++++---
 6 files changed, 34 insertions(+), 136 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4822d53..b9d555b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -63,12 +63,6 @@ extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
 
 struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
-struct lruvec *mem_cgroup_lru_add_list(struct zone *, struct page *,
-				       enum lru_list);
-void mem_cgroup_lru_del_list(struct page *, enum lru_list);
-void mem_cgroup_lru_del(struct page *);
-struct lruvec *mem_cgroup_lru_move_lists(struct zone *, struct page *,
-					 enum lru_list, enum lru_list);
 
 /* For coalescing uncharge for reducing memcg' overhead*/
 extern void mem_cgroup_uncharge_start(void);
@@ -212,29 +206,6 @@ static inline struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
 	return &zone->lruvec;
 }
 
-static inline struct lruvec *mem_cgroup_lru_add_list(struct zone *zone,
-						     struct page *page,
-						     enum lru_list lru)
-{
-	return &zone->lruvec;
-}
-
-static inline void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
-{
-}
-
-static inline void mem_cgroup_lru_del(struct page *page)
-{
-}
-
-static inline struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
-						       struct page *page,
-						       enum lru_list from,
-						       enum lru_list to)
-{
-	return &zone->lruvec;
-}
-
 static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
 	return NULL;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 8415596..daa3d15 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -24,19 +24,24 @@ static inline int page_is_file_cache(struct page *page)
 static inline void
 add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
 {
-	struct lruvec *lruvec;
+	struct lruvec *lruvec = page_lruvec(page);
+	int numpages = hpage_nr_pages(page);
 
-	lruvec = mem_cgroup_lru_add_list(zone, page, lru);
 	list_add(&page->lru, &lruvec->pages_lru[lru]);
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, hpage_nr_pages(page));
+	lruvec->pages_count[lru] += numpages;
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, numpages);
 }
 
 static inline void
 del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
 {
-	mem_cgroup_lru_del_list(page, lru);
+	struct lruvec *lruvec = page_lruvec(page);
+	int numpages = hpage_nr_pages(page);
+
 	list_del(&page->lru);
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -hpage_nr_pages(page));
+	lruvec->pages_count[lru] -= numpages;
+	VM_BUG_ON((long)lruvec->pages_count[lru] < 0);
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -numpages);
 }
 
 /**
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index be8873a..69b0f31 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -298,6 +298,7 @@ struct zone_reclaim_stat {
 
 struct lruvec {
 	struct list_head	pages_lru[NR_LRU_LISTS];
+	unsigned long		pages_count[NR_LRU_LISTS];
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	struct zone		*zone;
 	struct pglist_data	*node;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8b53150..80ce60c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -135,7 +135,6 @@ struct mem_cgroup_reclaim_iter {
  */
 struct mem_cgroup_per_zone {
 	struct lruvec		lruvec;
-	unsigned long		lru_size[NR_LRU_LISTS];
 
 	struct mem_cgroup_reclaim_iter reclaim_iter[DEF_PRIORITY + 1];
 
@@ -710,7 +709,7 @@ mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
 
 	for_each_lru(lru) {
 		if (BIT(lru) & lru_mask)
-			ret += mz->lru_size[lru];
+			ret += mz->lruvec.pages_count[lru];
 	}
 	return ret;
 }
@@ -1062,93 +1061,6 @@ struct lruvec *page_lruvec(struct page *page)
  * When moving account, the page is not on LRU. It's isolated.
  */
 
-/**
- * mem_cgroup_lru_add_list - account for adding an lru page and return lruvec
- * @zone: zone of the page
- * @page: the page
- * @lru: current lru
- *
- * This function accounts for @page being added to @lru, and returns
- * the lruvec for the given @zone and the memcg @page is charged to.
- *
- * The callsite is then responsible for physically linking the page to
- * the returned lruvec->pages_lru[@lru].
- */
-struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
-				       enum lru_list lru)
-{
-	struct mem_cgroup_per_zone *mz;
-	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
-
-	if (mem_cgroup_disabled())
-		return &zone->lruvec;
-
-	pc = lookup_page_cgroup(page);
-	memcg = pc->mem_cgroup;
-	mz = page_cgroup_zoneinfo(memcg, page);
-	/* compound_order() is stabilized through lru_lock */
-	mz->lru_size[lru] += 1 << compound_order(page);
-	return &mz->lruvec;
-}
-
-/**
- * mem_cgroup_lru_del_list - account for removing an lru page
- * @page: the page
- * @lru: target lru
- *
- * This function accounts for @page being removed from @lru.
- *
- * The callsite is then responsible for physically unlinking
- * @page->lru.
- */
-void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
-{
-	struct mem_cgroup_per_zone *mz;
-	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	pc = lookup_page_cgroup(page);
-	memcg = pc->mem_cgroup;
-	VM_BUG_ON(!memcg);
-	mz = page_cgroup_zoneinfo(memcg, page);
-	/* huge page split is done under lru_lock. so, we have no races. */
-	VM_BUG_ON(mz->lru_size[lru] < (1 << compound_order(page)));
-	mz->lru_size[lru] -= 1 << compound_order(page);
-}
-
-void mem_cgroup_lru_del(struct page *page)
-{
-	mem_cgroup_lru_del_list(page, page_lru(page));
-}
-
-/**
- * mem_cgroup_lru_move_lists - account for moving a page between lrus
- * @zone: zone of the page
- * @page: the page
- * @from: current lru
- * @to: target lru
- *
- * This function accounts for @page being moved between the lrus @from
- * and @to, and returns the lruvec for the given @zone and the memcg
- * @page is charged to.
- *
- * The callsite is then responsible for physically relinking
- * @page->lru to the returned lruvec->lists[@to].
- */
-struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
-					 struct page *page,
-					 enum lru_list from,
-					 enum lru_list to)
-{
-	/* XXX: Optimize this, especially for @from == @to */
-	mem_cgroup_lru_del_list(page, from);
-	return mem_cgroup_lru_add_list(zone, page, to);
-}
-
 /*
  * Checks whether given mem is same or in the root_mem_cgroup's
  * hierarchy subtree
@@ -3615,8 +3527,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 	zone = &NODE_DATA(node)->node_zones[zid];
 	mz = mem_cgroup_zoneinfo(memcg, node, zid);
 	list = &mz->lruvec.pages_lru[lru];
-
-	loop = mz->lru_size[lru];
+	loop = mz->lruvec.pages_count[lru];
 	/* give some margin against EBUSY etc...*/
 	loop += 256;
 	busy = NULL;
diff --git a/mm/swap.c b/mm/swap.c
index 17993c0..2afe02c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -234,10 +234,8 @@ static void pagevec_move_tail_fn(struct page *page, void *arg)
 
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		enum lru_list lru = page_lru_base_type(page);
-		struct lruvec *lruvec;
+		struct lruvec *lruvec = page_lruvec(page);
 
-		lruvec = mem_cgroup_lru_move_lists(page_zone(page),
-						   page, lru, lru);
 		list_move_tail(&page->lru, &lruvec->pages_lru[lru]);
 		(*pgmoved)++;
 	}
@@ -476,12 +474,11 @@ static void lru_deactivate_fn(struct page *page, void *arg)
 		 */
 		SetPageReclaim(page);
 	} else {
-		struct lruvec *lruvec;
+		struct lruvec *lruvec = page_lruvec(page);
 		/*
 		 * The page's writeback ends up during pagevec
 		 * We moves tha page into tail of inactive.
 		 */
-		lruvec = mem_cgroup_lru_move_lists(zone, page, lru, lru);
 		list_move_tail(&page->lru, &lruvec->pages_lru[lru]);
 		__count_vm_event(PGROTATED);
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e41ad52..f3c0fbe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1180,7 +1180,6 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 
 		switch (__isolate_lru_page(page, mode, file)) {
 		case 0:
-			mem_cgroup_lru_del(page);
 			list_move(&page->lru, dst);
 			nr_taken += hpage_nr_pages(page);
 			break;
@@ -1238,10 +1237,16 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				unsigned int isolated_pages;
+				struct lruvec *cursor_lruvec;
+				int cursor_lru = page_lru(cursor_page);
 
-				mem_cgroup_lru_del(cursor_page);
 				list_move(&cursor_page->lru, dst);
 				isolated_pages = hpage_nr_pages(cursor_page);
+				cursor_lruvec = page_lruvec(cursor_page);
+				cursor_lruvec->pages_count[cursor_lru] -=
+								isolated_pages;
+				VM_BUG_ON((long)cursor_lruvec->
+						pages_count[cursor_lru] < 0);
 				nr_taken += isolated_pages;
 				nr_lumpy_taken += isolated_pages;
 				if (PageDirty(cursor_page))
@@ -1273,6 +1278,9 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			nr_lumpy_failed++;
 	}
 
+	lruvec->pages_count[lru] -= nr_taken - nr_lumpy_taken;
+	VM_BUG_ON((long)lruvec->pages_count[lru] < 0);
+
 	*nr_scanned = scan;
 
 	trace_mm_vmscan_lru_isolate(sc->order,
@@ -1656,15 +1664,18 @@ static void move_active_pages_to_lru(struct zone *zone,
 
 	while (!list_empty(list)) {
 		struct lruvec *lruvec;
+		int numpages;
 
 		page = lru_to_page(list);
 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 
-		lruvec = mem_cgroup_lru_add_list(zone, page, lru);
+		lruvec = page_lruvec(page);
 		list_move(&page->lru, &lruvec->pages_lru[lru]);
-		pgmoved += hpage_nr_pages(page);
+		numpages = hpage_nr_pages(page);
+		lruvec->pages_count[lru] += numpages;
+		pgmoved += numpages;
 
 		if (put_page_testzero(page)) {
 			__ClearPageLRU(page);
@@ -3590,8 +3601,10 @@ void check_move_unevictable_pages(struct page **pages, int nr_pages)
 			VM_BUG_ON(PageActive(page));
 			ClearPageUnevictable(page);
 			__dec_zone_state(zone, NR_UNEVICTABLE);
-			lruvec = mem_cgroup_lru_move_lists(zone, page,
-						LRU_UNEVICTABLE, lru);
+			lruvec = page_lruvec(page);
+			lruvec->pages_count[LRU_UNEVICTABLE]--;
+			VM_BUG_ON((long)lruvec->pages_count[LRU_UNEVICTABLE] < 0);
+			lruvec->pages_count[lru]++;
 			list_move(&page->lru, &lruvec->pages_lru[lru]);
 			__inc_zone_state(zone, NR_INACTIVE_ANON + lru);
 			pgrescued++;

