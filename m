Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1G0GAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:00:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54279 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1G0F76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:59:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Jul 2011 14:52:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH v4 6/5] memcg : check numa balance
Message-Id: <20110727145244.1a565a50.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110727144438.a9fdfd5b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110727144438.a9fdfd5b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was required for handling numa-unbalanced memcg.
==
Because do_try_to_free_pages() scans node based on zonelist,
even if we select a victim node, we may scan other nodes.

When the nodes are balanced, it's good because we'll quit scan loop
before updating 'priority'. But when the nodes are unbalanced,
it will force scanning a very small nodes and will cause
swap-out when the node doesn't contains enough file caches.

This patch selects zonelist[] for vmscan scan list for memcg.
If memcg is well balanced among nodes, usual fall back (and mask) is used.
If not, it selects node local zonelist and do target reclaim.

This will reduce unnecessary (anon page) scans when memcg is not balanced.

Now, memcg/NUMA is balanced when each node's weight is between
 80% and 120% of average node weight.
 (*) This value is just a magic number but works well in several tests.
     Further study to detemine this value is appreciated.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |   20 ++++++++++++++++++--
 mm/vmscan.c                |    8 ++++++--
 3 files changed, 25 insertions(+), 5 deletions(-)

Index: mmotm-0710/mm/memcontrol.c
===================================================================
--- mmotm-0710.orig/mm/memcontrol.c
+++ mmotm-0710/mm/memcontrol.c
@@ -295,6 +295,7 @@ struct mem_cgroup {
 	atomic_t	numainfo_updating;
 	struct work_struct	numainfo_update_work;
 	unsigned long	total_weight;
+	bool		numascan_balance;
 	int		numascan_generation;
 	int		numascan_tickets_num[2];
 	struct numascan_ticket *numascan_tickets[2];
@@ -1663,12 +1664,15 @@ mem_cgroup_calc_numascan_weight(struct m
  */
 #define NUMA_TICKET_SHIFT	(16)
 #define NUMA_TICKET_FACTOR	((1 << NUMA_TICKET_SHIFT) - 1)
+#define NUMA_BALANCE_RANGE_LOW	(80)
+#define NUMA_BALANCE_RANGE_HIGH	(120)
 static void mem_cgroup_update_numascan_tickets(struct mem_cgroup *memcg)
 {
 	struct numascan_ticket *nt;
 	unsigned int node_ticket, assigned_tickets;
 	u64 weight;
 	int nid, assigned_num, generation;
+	unsigned long average, balance_low, balance_high;
 
 	/* update ticket information by double buffering */
 	generation = memcg->numascan_generation ^ 0x1;
@@ -1676,6 +1680,11 @@ static void mem_cgroup_update_numascan_t
 	nt = memcg->numascan_tickets[generation];
 	assigned_tickets = 0;
 	assigned_num = 0;
+	average = memcg->total_weight / (nodes_weight(memcg->scan_nodes) + 1);
+	balance_low = NUMA_BALANCE_RANGE_LOW * average / 100;
+	balance_high = NUMA_BALANCE_RANGE_HIGH * average / 100;
+	memcg->numascan_balance = true;
+
 	for_each_node_mask(nid, memcg->scan_nodes) {
 		weight = memcg->info.nodeinfo[nid]->weight;
 		node_ticket = div64_u64(weight << NUMA_TICKET_SHIFT,
@@ -1688,6 +1697,9 @@ static void mem_cgroup_update_numascan_t
 		assigned_tickets += node_ticket;
 		nt++;
 		assigned_num++;
+		if ((weight < balance_low) ||
+		    (weight > balance_high))
+			memcg->numascan_balance = false;
 	}
 	memcg->numascan_tickets_num[generation] = assigned_num;
 	smp_wmb();
@@ -1758,7 +1770,7 @@ static int node_weight_compare(const voi
  * node means more costs for memory reclaim because of memory latency.
  */
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg, nodemask_t **mask,
-				struct memcg_scanrecord *rec)
+				struct memcg_scanrecord *rec, bool *fallback)
 {
 	int node = MAX_NUMNODES;
 	struct numascan_ticket *nt;
@@ -1785,8 +1797,11 @@ out:
 	if (unlikely(node == MAX_NUMNODES)) {
 		node = numa_node_id();
 		*mask = NULL;
-	} else
+		*fallback = true;
+	} else {
 		*mask = &memcg->scan_nodes;
+		*fallback = memcg->numascan_balance;
+	}
 
 	return node;
 }
@@ -1864,6 +1879,7 @@ int mem_cgroup_select_victim_node(struct
 				struct memcg_scanrecord *rec)
 {
 	*mask = NULL;
+	*fallback = true;
 	return 0;
 }
 
Index: mmotm-0710/include/linux/memcontrol.h
===================================================================
--- mmotm-0710.orig/include/linux/memcontrol.h
+++ mmotm-0710/include/linux/memcontrol.h
@@ -118,7 +118,7 @@ extern void mem_cgroup_end_migration(str
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg, nodemask_t **mask,
-				struct memcg_scanrecord *rec);
+				struct memcg_scanrecord *rec, bool *fallback);
 unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
 					int nid, int zid, unsigned int lrumask);
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
Index: mmotm-0710/mm/vmscan.c
===================================================================
--- mmotm-0710.orig/mm/vmscan.c
+++ mmotm-0710/mm/vmscan.c
@@ -2290,6 +2290,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	unsigned long nr_reclaimed;
 	unsigned long start, end;
 	int nid;
+	bool fallback;
 	nodemask_t *mask;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
@@ -2313,9 +2314,12 @@ unsigned long try_to_free_mem_cgroup_pag
 	 * take care of from where we get pages. So the node where we start the
 	 * scan does not need to be the current node.
 	 */
-	nid = mem_cgroup_select_victim_node(mem_cont, &mask, rec);
+	nid = mem_cgroup_select_victim_node(mem_cont, &mask, rec, &fallback);
 
-	zonelist = &NODE_DATA(nid)->node_zonelists[0];
+	if (fallback) /* memcg/NUMA is balanced and fallback works well */
+		zonelist = &NODE_DATA(nid)->node_zonelists[0];
+	else /* memcg/NUMA is not balanced, do target reclaim */
+		zonelist = &NODE_DATA(nid)->node_zonelists[1];
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,

