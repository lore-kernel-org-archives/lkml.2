Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2LMOsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:48:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab2LMOHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 100/241] memcg: fix hotplugged memory zone oops
Date: Thu, 13 Dec 2012 11:57:45 -0200
Message-Id: <1355407206-17100-101-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit bea8c150a7efbc0f204e709b7274fe273f55e0d3 upstream.

When MEMCG is configured on (even when it's disabled by boot option),
when adding or removing a page to/from its lru list, the zone pointer
used for stats updates is nowadays taken from the struct lruvec.  (On
many configurations, calculating zone from page is slower.)

But we have no code to update all the lruvecs (per zone, per memcg) when
a memory node is hotadded.  Here's an extract from the oops which
results when running numactl to bind a program to a newly onlined node:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000f60
  IP:  __mod_zone_page_state+0x9/0x60
  Pid: 1219, comm: numactl Not tainted 3.6.0-rc5+ #180 Bochs Bochs
  Process numactl (pid: 1219, threadinfo ffff880039abc000, task ffff8800383c4ce0)
  Call Trace:
    __pagevec_lru_add_fn+0xdf/0x140
    pagevec_lru_move_fn+0xb1/0x100
    __pagevec_lru_add+0x1c/0x30
    lru_add_drain_cpu+0xa3/0x130
    lru_add_drain+0x2f/0x40
   ...

The natural solution might be to use a memcg callback whenever memory is
hotadded; but that solution has not been scoped out, and it happens that
we do have an easy location at which to update lruvec->zone.  The lruvec
pointer is discovered either by mem_cgroup_zone_lruvec() or by
mem_cgroup_page_lruvec(), and both of those do know the right zone.

So check and set lruvec->zone in those; and remove the inadequate
attempt to set lruvec->zone from lruvec_init(), which is called before
NODE_DATA(node) has been allocated in such cases.

Ah, there was one exceptionr.  For no particularly good reason,
mem_cgroup_force_empty_list() has its own code for deciding lruvec.
Change it to use the standard mem_cgroup_zone_lruvec() and
mem_cgroup_get_lru_size() too.  In fact it was already safe against such
an oops (the lru lists in danger could only be empty), but we're better
proofed against future changes this way.

I've marked this for stable (3.6) since we introduced the problem in 3.5
(now closed to stable); but I have no idea if this is the only fix
needed to get memory hotadd working with memcg in 3.6, and received no
answer when I enquired twice before.

Reported-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ herton: CONFIG_MEMCG was CONFIG_CGROUP_MEM_RES_CTLR (renamed),
  adjusted context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/mmzone.h |    2 +-
 mm/memcontrol.c        |   46 +++++++++++++++++++++++++++++++++++-----------
 mm/mmzone.c            |    6 +-----
 mm/page_alloc.c        |    2 +-
 4 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 68c569f..bf06b19 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -732,7 +732,7 @@ extern int init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
 				     unsigned long size,
 				     enum memmap_context context);
 
-extern void lruvec_init(struct lruvec *lruvec, struct zone *zone);
+extern void lruvec_init(struct lruvec *lruvec);
 
 static inline struct zone *lruvec_zone(struct lruvec *lruvec)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3ddd346..08bcbd8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1060,12 +1060,24 @@ struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
 				      struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_per_zone *mz;
+	struct lruvec *lruvec;
 
-	if (mem_cgroup_disabled())
-		return &zone->lruvec;
+	if (mem_cgroup_disabled()) {
+		lruvec = &zone->lruvec;
+		goto out;
+	}
 
 	mz = mem_cgroup_zoneinfo(memcg, zone_to_nid(zone), zone_idx(zone));
-	return &mz->lruvec;
+	lruvec = &mz->lruvec;
+out:
+	/*
+	 * Since a node can be onlined after the mem_cgroup was created,
+	 * we have to be prepared to initialize lruvec->zone here;
+	 * and if offlined then reonlined, we need to reinitialize it.
+	 */
+	if (unlikely(lruvec->zone != zone))
+		lruvec->zone = zone;
+	return lruvec;
 }
 
 /*
@@ -1092,9 +1104,12 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
 	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
+	struct lruvec *lruvec;
 
-	if (mem_cgroup_disabled())
-		return &zone->lruvec;
+	if (mem_cgroup_disabled()) {
+		lruvec = &zone->lruvec;
+		goto out;
+	}
 
 	pc = lookup_page_cgroup(page);
 	memcg = pc->mem_cgroup;
@@ -1112,7 +1127,16 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
 		pc->mem_cgroup = memcg = root_mem_cgroup;
 
 	mz = page_cgroup_zoneinfo(memcg, page);
-	return &mz->lruvec;
+	lruvec = &mz->lruvec;
+out:
+	/*
+	 * Since a node can be onlined after the mem_cgroup was created,
+	 * we have to be prepared to initialize lruvec->zone here;
+	 * and if offlined then reonlined, we need to reinitialize it.
+	 */
+	if (unlikely(lruvec->zone != zone))
+		lruvec->zone = zone;
+	return lruvec;
 }
 
 /**
@@ -3626,7 +3650,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 				int node, int zid, enum lru_list lru)
 {
-	struct mem_cgroup_per_zone *mz;
+	struct lruvec *lruvec;
 	unsigned long flags, loop;
 	struct list_head *list;
 	struct page *busy;
@@ -3634,10 +3658,10 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 	int ret = 0;
 
 	zone = &NODE_DATA(node)->node_zones[zid];
-	mz = mem_cgroup_zoneinfo(memcg, node, zid);
-	list = &mz->lruvec.lists[lru];
+	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+	list = &lruvec->lists[lru];
 
-	loop = mz->lru_size[lru];
+	loop = mem_cgroup_get_lru_size(lruvec, lru);
 	/* give some margin against EBUSY etc...*/
 	loop += 256;
 	busy = NULL;
@@ -4683,7 +4707,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
-		lruvec_init(&mz->lruvec, &NODE_DATA(node)->node_zones[zone]);
+		lruvec_init(&mz->lruvec);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->memcg = memcg;
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 6830eab..4596d81 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -87,7 +87,7 @@ int memmap_valid_within(unsigned long pfn,
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
 
-void lruvec_init(struct lruvec *lruvec, struct zone *zone)
+void lruvec_init(struct lruvec *lruvec)
 {
 	enum lru_list lru;
 
@@ -95,8 +95,4 @@ void lruvec_init(struct lruvec *lruvec, struct zone *zone)
 
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
-
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-	lruvec->zone = zone;
-#endif
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 34d879e..9bd526c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4407,7 +4407,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		zone->zone_pgdat = pgdat;
 
 		zone_pcp_init(zone);
-		lruvec_init(&zone->lruvec, zone);
+		lruvec_init(&zone->lruvec);
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
-- 
1.7.9.5

