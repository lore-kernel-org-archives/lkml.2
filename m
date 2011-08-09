Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1HIKUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:20:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53952 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1HIKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:20:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 19:13:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH v5 6/6]  memg: do target scan if unbalanced
Message-Id: <20110809191319.40c1c01c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
 mm/vmscan.c                |    9 +++++++--
 3 files changed, 26 insertions(+), 5 deletions(-)

Index: mmotm-Aug3/mm/memcontrol.c
===================================================================
--- mmotm-Aug3.orig/mm/memcontrol.c
+++ mmotm-Aug3/mm/memcontrol.c
@@ -296,6 +296,7 @@ struct mem_cgroup {
 	atomic_t	numainfo_updating;
 	struct work_struct	numainfo_update_work;
 	unsigned long	total_weight;
+	bool		numascan_balance;
 	int		numascan_generation;
 	int		numascan_tickets_num[2];
 	struct numascan_ticket *numascan_tickets[2];
@@ -1679,12 +1680,15 @@ mem_cgroup_calc_numascan_weight(struct m
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
@@ -1692,6 +1696,11 @@ static void mem_cgroup_update_numascan_t
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
@@ -1704,6 +1713,9 @@ static void mem_cgroup_update_numascan_t
 		assigned_tickets += node_ticket;
 		nt++;
 		assigned_num++;
+		if ((weight < balance_low) ||
+		    (weight > balance_high))
+			memcg->numascan_balance = false;
 	}
 	memcg->numascan_tickets_num[generation] = assigned_num;
 	smp_wmb();
@@ -1774,7 +1786,7 @@ static int node_weight_compare(const voi
  * node means more costs for memory reclaim because of memory latency.
  */
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg, nodemask_t **mask,
-				struct memcg_scanrecord *rec)
+				struct memcg_scanrecord *rec, bool *fallback)
 {
 	int node = MAX_NUMNODES;
 	struct numascan_ticket *nt;
@@ -1801,8 +1813,11 @@ out:
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
@@ -1880,6 +1895,7 @@ int mem_cgroup_select_victim_node(struct
 				struct memcg_scanrecord *rec)
 {
 	*mask = NULL;
+	*fallback = true;
 	return 0;
 }
 
Index: mmotm-Aug3/include/linux/memcontrol.h
===================================================================
--- mmotm-Aug3.orig/include/linux/memcontrol.h
+++ mmotm-Aug3/include/linux/memcontrol.h
@@ -119,7 +119,7 @@ extern void mem_cgroup_end_migration(str
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg, nodemask_t **mask,
-				struct memcg_scanrecord *rec);
+				struct memcg_scanrecord *rec, bool *fallback);
 unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
 					int nid, int zid, unsigned int lrumask);
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
Index: mmotm-Aug3/mm/vmscan.c
===================================================================
--- mmotm-Aug3.orig/mm/vmscan.c
+++ mmotm-Aug3/mm/vmscan.c
@@ -2355,6 +2355,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
 	ktime_t start, end;
+	bool fallback;
 	int nid;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
@@ -2378,9 +2379,13 @@ unsigned long try_to_free_mem_cgroup_pag
 	 * take care of from where we get pages. So the node where we start the
 	 * scan does not need to be the current node.
 	 */
-	nid = mem_cgroup_select_victim_node(mem_cont, &sc.nodemask, rec);
+	nid = mem_cgroup_select_victim_node(mem_cont, &sc.nodemask,
+				rec, &fallback);
 
-	zonelist = &NODE_DATA(nid)->node_zonelists[0];
+	if (fallback) /* memcg/NUMA is balanced and fallback works well */
+		zonelist = &NODE_DATA(nid)->node_zonelists[0];
+	else /* memcg/NUMA is not balanced, do target reclaim */
+		zonelist = &NODE_DATA(nid)->node_zonelists[1];
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,

