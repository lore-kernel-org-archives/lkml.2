Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2ENFA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:00:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49409 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2ENFAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:00:24 -0400
Date: Sun, 13 May 2012 22:00:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm/memcg: get_lru_size not get_lruvec_size
In-Reply-To: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1205132158470.6148@eggly.anvils>
References: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin just introduced mem_cgroup_get_lruvec_size() and
get_lruvec_size(), I'm about to add mem_cgroup_update_lru_size():
but we're dealing with the same thing, lru_size[lru].  We ought to
agree on the naming, and I do think lru_size is the more correct:
so rename his ones to get_lru_size().

Signed-off-by: Hugh Dickins <hughd@google.com>
---
But I'd prefer this patch to vanish and you just edit Konstantin's.

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   10 +++++-----
 mm/vmscan.c                |   19 +++++++++----------
 3 files changed, 16 insertions(+), 17 deletions(-)

--- 3046N.orig/include/linux/memcontrol.h	2012-05-13 20:41:20.506117289 -0700
+++ 3046N/include/linux/memcontrol.h	2012-05-13 20:41:24.330117381 -0700
@@ -121,7 +121,7 @@ void mem_cgroup_iter_break(struct mem_cg
 int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec);
 int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
-unsigned long mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list);
+unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
 struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
@@ -340,7 +340,7 @@ mem_cgroup_inactive_file_is_low(struct l
 }
 
 static inline unsigned long
-mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	return 0;
 }
--- 3046N.orig/mm/memcontrol.c	2012-05-13 20:41:20.510117289 -0700
+++ 3046N/mm/memcontrol.c	2012-05-13 20:41:24.334117380 -0700
@@ -742,7 +742,7 @@ static void mem_cgroup_charge_statistics
 }
 
 unsigned long
-mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
 
@@ -1234,8 +1234,8 @@ int mem_cgroup_inactive_anon_is_low(stru
 	unsigned long active;
 	unsigned long gb;
 
-	inactive = mem_cgroup_get_lruvec_size(lruvec, LRU_INACTIVE_ANON);
-	active = mem_cgroup_get_lruvec_size(lruvec, LRU_ACTIVE_ANON);
+	inactive = mem_cgroup_get_lru_size(lruvec, LRU_INACTIVE_ANON);
+	active = mem_cgroup_get_lru_size(lruvec, LRU_ACTIVE_ANON);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -1251,8 +1251,8 @@ int mem_cgroup_inactive_file_is_low(stru
 	unsigned long active;
 	unsigned long inactive;
 
-	inactive = mem_cgroup_get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
-	active = mem_cgroup_get_lruvec_size(lruvec, LRU_ACTIVE_FILE);
+	inactive = mem_cgroup_get_lru_size(lruvec, LRU_INACTIVE_FILE);
+	active = mem_cgroup_get_lru_size(lruvec, LRU_ACTIVE_FILE);
 
 	return (active > inactive);
 }
--- 3046N.orig/mm/vmscan.c	2012-05-13 20:41:20.510117289 -0700
+++ 3046N/mm/vmscan.c	2012-05-13 20:41:24.334117380 -0700
@@ -145,10 +145,10 @@ static bool global_reclaim(struct scan_c
 }
 #endif
 
-static unsigned long get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (!mem_cgroup_disabled())
-		return mem_cgroup_get_lruvec_size(lruvec, lru);
+		return mem_cgroup_get_lru_size(lruvec, lru);
 
 	return zone_page_state(lruvec_zone(lruvec), NR_LRU_BASE + lru);
 }
@@ -1608,10 +1608,10 @@ static void get_scan_count(struct lruvec
 		goto out;
 	}
 
-	anon  = get_lruvec_size(lruvec, LRU_ACTIVE_ANON) +
-		get_lruvec_size(lruvec, LRU_INACTIVE_ANON);
-	file  = get_lruvec_size(lruvec, LRU_ACTIVE_FILE) +
-		get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
+	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
+		get_lru_size(lruvec, LRU_INACTIVE_ANON);
+	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
+		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
 	if (global_reclaim(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
@@ -1674,7 +1674,7 @@ out:
 		int file = is_file_lru(lru);
 		unsigned long scan;
 
-		scan = get_lruvec_size(lruvec, lru);
+		scan = get_lru_size(lruvec, lru);
 		if (sc->priority || noswap) {
 			scan >>= sc->priority;
 			if (!scan && force_scan)
@@ -1743,10 +1743,9 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
+	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
-		inactive_lru_pages += get_lruvec_size(lruvec,
-						      LRU_INACTIVE_ANON);
+		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
