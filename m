Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab1LFKPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:15:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35755 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab1LFKPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:15:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 6 Dec 2011 19:13:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: [RFC][PATCH 2/4] memcg: simplify corner case handling of LRU and
 charge races
Message-Id: <20111206191357.37ae6ac3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111206191211.3be32ccb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111206123923.1432ab52.kamezawa.hiroyu@jp.fujitsu.com>
	<20111206191211.3be32ccb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2949dd497b4b87d9a5a6352053d247b5924516ea Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 6 Dec 2011 15:08:55 +0900
Subject: [PATCH 2/4] memcg: simplify corner case handling of LRU and charge races.

This patch simplifies LRU handling of racy case (memcg+SwapCache).
At charging, SwapCache tend to be on LRU already. So, before
overwriting pc->mem_cgroup, the page must be removed from LRU and
added to LRU later.

This patch does
	spin_lock(zone->lru_lock);
	if (PageLRU(page))
		remove from LRU
	overwrite pc->mem_cgroup
	if (PageLRU(page))
		add to new LRU.
	spin_unlock(zone->lru_lock);

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   90 +++++--------------------------------------------------
 1 files changed, 8 insertions(+), 82 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 947c62c..66a2a59 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1071,86 +1071,6 @@ struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
 }
 
 /*
- * At handling SwapCache and other FUSE stuff, pc->mem_cgroup may be changed
- * while it's linked to lru because the page may be reused after it's fully
- * uncharged. To handle that, unlink page_cgroup from LRU when charge it again.
- * It's done under lock_page and expected that zone->lru_lock isnever held.
- */
-static void mem_cgroup_lru_del_before_commit(struct page *page)
-{
-	enum lru_list lru;
-	unsigned long flags;
-	struct zone *zone = page_zone(page);
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-
-	/*
-	 * Doing this check without taking ->lru_lock seems wrong but this
-	 * is safe. Because if page_cgroup's USED bit is unset, the page
-	 * will not be added to any memcg's LRU. If page_cgroup's USED bit is
-	 * set, the commit after this will fail, anyway.
-	 * This all charge/uncharge is done under some mutual execustion.
-	 * So, we don't need to taking care of changes in USED bit.
-	 */
-	if (likely(!PageLRU(page)))
-		return;
-
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	lru = page_lru(page);
-	/*
-	 * The uncharged page could still be registered to the LRU of
-	 * the stale pc->mem_cgroup.
-	 *
-	 * As pc->mem_cgroup is about to get overwritten, the old LRU
-	 * accounting needs to be taken care of.  Let root_mem_cgroup
-	 * babysit the page until the new memcg is responsible for it.
-	 *
-	 * The PCG_USED bit is guarded by lock_page() as the page is
-	 * swapcache/pagecache.
-	 */
-	if (PageLRU(page) && PageCgroupAcctLRU(pc) && !PageCgroupUsed(pc)) {
-		del_page_from_lru_list(zone, page, lru);
-		add_page_to_lru_list(zone, page, lru);
-	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
-}
-
-static void mem_cgroup_lru_add_after_commit(struct page *page)
-{
-	enum lru_list lru;
-	unsigned long flags;
-	struct zone *zone = page_zone(page);
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	/*
-	 * putback:				charge:
-	 * SetPageLRU				SetPageCgroupUsed
-	 * smp_mb				smp_mb
-	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
-	 *
-	 * Ensure that one of the two sides adds the page to the memcg
-	 * LRU during a race.
-	 */
-	smp_mb();
-	/* taking care of that the page is added to LRU while we commit it */
-	if (likely(!PageLRU(page)))
-		return;
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	lru = page_lru(page);
-	/*
-	 * If the page is not on the LRU, someone will soon put it
-	 * there.  If it is, and also already accounted for on the
-	 * memcg-side, it must be on the right lruvec as setting
-	 * pc->mem_cgroup and PageCgroupUsed is properly ordered.
-	 * Otherwise, root_mem_cgroup has been babysitting the page
-	 * during the charge.  Move it to the new memcg now.
-	 */
-	if (PageLRU(page) && !PageCgroupAcctLRU(pc)) {
-		del_page_from_lru_list(zone, page, lru);
-		add_page_to_lru_list(zone, page, lru);
-	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
-}
-
-/*
  * Checks whether given mem is same or in the root_mem_cgroup's
  * hierarchy subtree
  */
@@ -2695,14 +2615,20 @@ __mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
+	struct zone *zone = page_zone(page);
+	unsigned long flags;
 	/*
 	 * In some case, SwapCache, FUSE(splice_buf->radixtree), the page
 	 * is already on LRU. It means the page may on some other page_cgroup's
 	 * LRU. Take care of it.
 	 */
-	mem_cgroup_lru_del_before_commit(page);
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	if (PageLRU(page))
+		del_page_from_lru_list(zone, page, page_lru(page));
 	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
-	mem_cgroup_lru_add_after_commit(page);
+	if (PageLRU(page))
+		add_page_to_lru_list(zone, page, page_lru(page));
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
 	return;
 }
 
-- 
1.7.4.1


