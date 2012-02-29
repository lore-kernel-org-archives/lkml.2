Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2B2FZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 00:25:40 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36395 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2B2FZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 00:25:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.220.168 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Tue, 28 Feb 2012 21:25:02 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3.3] memcg: fix deadlock by inverting lrucare nesting
Message-ID: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have forgotten the rules of lock nesting: the irq-safe ones must be
taken inside the non-irq-safe ones, otherwise we are open to deadlock:

CPU0                          CPU1
----                          ----
lock(&(&pc->lock)->rlock);
                              local_irq_disable();
                              lock(&(&zone->lru_lock)->rlock);
                              lock(&(&pc->lock)->rlock);
<Interrupt>
lock(&(&zone->lru_lock)->rlock);

To check a different locking issue, I happened to add a spin_lock to
memcg's bit_spin_lock in lock_page_cgroup(), and lockdep very quickly
complained about __mem_cgroup_commit_charge_lrucare() (on CPU1 above).

So delete __mem_cgroup_commit_charge_lrucare(), passing a bool lrucare
to __mem_cgroup_commit_charge() instead, taking zone->lru_lock under
lock_page_cgroup() in the lrucare case.

The original was using spin_lock_irqsave, but we'd be in more trouble
if it were ever called at interrupt time: unconditional _irq is enough.
And ClearPageLRU before del from lru, SetPageLRU before add to lru: no
strong reason, but that is the ordering used consistently elsewhere.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
Not needed for -stable: this issue came into 3.3-rc1.

 mm/memcontrol.c |   72 +++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 35 deletions(-)

--- 3.3-rc5/mm/memcontrol.c	2012-02-25 13:02:05.165830574 -0800
+++ linux/mm/memcontrol.c	2012-02-27 23:24:54.676160755 -0800
@@ -2408,8 +2408,12 @@ static void __mem_cgroup_commit_charge(s
 				       struct page *page,
 				       unsigned int nr_pages,
 				       struct page_cgroup *pc,
-				       enum charge_type ctype)
+				       enum charge_type ctype,
+				       bool lrucare)
 {
+	struct zone *uninitialized_var(zone);
+	bool was_on_lru = false;
+
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
@@ -2420,6 +2424,21 @@ static void __mem_cgroup_commit_charge(s
 	 * we don't need page_cgroup_lock about tail pages, becase they are not
 	 * accessed by any other context at this point.
 	 */
+
+	/*
+	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
+	 * may already be on some other mem_cgroup's LRU.  Take care of it.
+	 */
+	if (lrucare) {
+		zone = page_zone(page);
+		spin_lock_irq(&zone->lru_lock);
+		if (PageLRU(page)) {
+			ClearPageLRU(page);
+			del_page_from_lru_list(zone, page, page_lru(page));
+			was_on_lru = true;
+		}
+	}
+
 	pc->mem_cgroup = memcg;
 	/*
 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
@@ -2443,9 +2462,18 @@ static void __mem_cgroup_commit_charge(s
 		break;
 	}
 
+	if (lrucare) {
+		if (was_on_lru) {
+			VM_BUG_ON(PageLRU(page));
+			SetPageLRU(page);
+			add_page_to_lru_list(zone, page, page_lru(page));
+		}
+		spin_unlock_irq(&zone->lru_lock);
+	}
+
 	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
 	unlock_page_cgroup(pc);
-	WARN_ON_ONCE(PageLRU(page));
+
 	/*
 	 * "charge_statistics" updated event counter. Then, check it.
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
@@ -2643,7 +2671,7 @@ static int mem_cgroup_charge_common(stru
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret == -ENOMEM)
 		return ret;
-	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype);
+	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype, false);
 	return 0;
 }
 
@@ -2663,35 +2691,6 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
 					enum charge_type ctype);
 
-static void
-__mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *memcg,
-					enum charge_type ctype)
-{
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	struct zone *zone = page_zone(page);
-	unsigned long flags;
-	bool removed = false;
-
-	/*
-	 * In some case, SwapCache, FUSE(splice_buf->radixtree), the page
-	 * is already on LRU. It means the page may on some other page_cgroup's
-	 * LRU. Take care of it.
-	 */
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	if (PageLRU(page)) {
-		del_page_from_lru_list(zone, page, page_lru(page));
-		ClearPageLRU(page);
-		removed = true;
-	}
-	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
-	if (removed) {
-		add_page_to_lru_list(zone, page, page_lru(page));
-		SetPageLRU(page);
-	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
-	return;
-}
-
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
@@ -2769,13 +2768,16 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
+	struct page_cgroup *pc;
+
 	if (mem_cgroup_disabled())
 		return;
 	if (!memcg)
 		return;
 	cgroup_exclude_rmdir(&memcg->css);
 
-	__mem_cgroup_commit_charge_lrucare(page, memcg, ctype);
+	pc = lookup_page_cgroup(page);
+	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype, true);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
@@ -3248,7 +3250,7 @@ int mem_cgroup_prepare_migration(struct
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype, false);
 	return ret;
 }
 
@@ -3332,7 +3334,7 @@ void mem_cgroup_replace_page_cache(struc
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
 	 * LRU while we overwrite pc->mem_cgroup.
 	 */
-	__mem_cgroup_commit_charge_lrucare(newpage, memcg, type);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type, true);
 }
 
 #ifdef CONFIG_DEBUG_VM
