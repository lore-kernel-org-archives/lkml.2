Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab1FPEEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:04:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43701 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1FPEEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:04:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jun 2011 12:57:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: [PATCH 7/7] memcg: proportional fair vicitm node selection
Message-Id: <20110616125741.c3d6a802.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4fbd49697456c227c86f1d5b46f2cd2169bf1c5b Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 16 Jun 2011 11:25:23 +0900
Subject: [PATCH 7/7] memcg: proportional fair node vicitm selection

commit 889976 implements a round-robin scan of numa nodes for
LRU scanning of memcg at hitting limit.
But, round-robin is not very good.

This patch implements a proportionally fair victim selection of nodes
rather than round-robin. The logic is fair against each node's weight.

Each node's weight is calculated periodically and we build an node's
scheduling entity as

     total_ticket = 0;
     for_each_node(node)
     	node->ticket_start =  total_ticket;
        node->ticket_end   =  total_ticket + this_node's_weight()
        total_ticket = node->ticket_end;

Then, each nodes has some amounts of tickets in proportion to its own weight.

At selecting victim, a random number is selected and the node which contains
the random number in [ticket_start, ticket_end) is selected as vicitm.
This is a lottery scheduling algorithm.

For quick search of victim, this patch uses bsearch().

Test result:
  on 8cpu box with 2 nodes.
  limit memory to be 300MB and run httpd for 4096files/600MB working set.
  do (normalized) random access by apache-bench and see scan_stat.
  The test makes 40960 request. and see scan_stat.
  (Because a httpd thread just use 10% cpu, the number of threads will
   not be balanced between nodes. Then, file caches will not be balanced
   between nodes.)

  [Before patch]
  [kamezawa@bluextal ~]$ cat /cgroup/memory/test/memory.scan_stat
  scanned_pages_by_limit 550740
  freed_pages_by_limit 206473
  elapsed_ns_by_limit 9485418834

  [After patch]
  scanned_pages_by_limit 521520
  freed_pages_by_limit 199330
  elapsed_ns_by_limit 7904913234

Total number of scan, elapsed time for scan are decreased in this test.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |  116 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 92 insertions(+), 24 deletions(-)

Index: mmotm-0615/mm/memcontrol.c
===================================================================
--- mmotm-0615.orig/mm/memcontrol.c
+++ mmotm-0615/mm/memcontrol.c
@@ -49,6 +49,8 @@
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
+#include <linux/random.h>
+#include <linux/bsearch.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -149,7 +151,14 @@ struct mem_cgroup_per_node {
 
 struct mem_cgroup_lru_info {
 	struct mem_cgroup_per_node *nodeinfo[MAX_NUMNODES];
-	unsigned long total_weight;
+	u32 total_weight;
+};
+
+/* a structure for numa victim selection scheduling */
+struct mem_cgroup_numasched {
+	int nid;
+	u32 start;
+	u32 ticket;
 };
 
 /*
@@ -289,10 +298,11 @@ struct mem_cgroup {
 	 * reclaimed from.
 	 */
 	int last_scanned_child;
-	int last_scanned_node;
 #if MAX_NUMNODES > 1
 	nodemask_t	scan_nodes;
 	struct mutex	numascan_mutex;
+	struct mem_cgroup_numasched *nsched;
+	int		nr_nsched;
 #endif
 	atomic_t	numascan_update;
 	/*
@@ -1660,8 +1670,10 @@ static unsigned long mem_cgroup_numascan
 static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
 {
 	bool inactive_file_low, inactive_anon_low;
-	int nid;
-	unsigned long long limit;
+	int nid, factor;
+	unsigned long long limit, usage;
+	struct mem_cgroup_numasched *ns;
+
 	/* if no limit, we never reach here */
 	limit = res_counter_read_u64(&mem->res, RES_LIMIT);
 	limit /= PAGE_SIZE;
@@ -1683,13 +1695,41 @@ static void mem_cgroup_may_update_nodema
 	inactive_anon_low = mem_cgroup_inactive_anon_is_low(mem);
 	mem->info.total_weight = 0;
 
+	/*
+	 * mem->nsched is an array of nodes with weight. If weight==0,
+	 * the nid will not appear in the array. Each ns entry has
+	 * [start, ticket] pair and the array. This ticket will be used
+	 * for lottery.
+	 */
+	ns = mem->nsched;
+	mem->nr_nsched = 0;
+
+	/*
+	 * We use random32() for lottery. so, we'd like to make
+	 * total_weight smaller than u32. calculate the factor to limit
+	 * total_weight, here.
+	 */
+	usage = res_counter_read_u64(&mem->res, RES_USAGE);
+	factor = 0;
+
+	while ((usage >> factor) > 0x7fffffff)
+		factor++;
+
 	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
 		unsigned long weight;
 
 		weight = mem_cgroup_numascan_weight(mem, nid,
 						inactive_file_low,
 						inactive_anon_low);
-		if (!weight)
+		if (weight) {
+			/* we'd like to fit total_weight to u32. */
+			weight = (weight >> factor) + 1;
+			ns->nid = nid;
+			ns->start = mem->info.total_weight;
+			ns->ticket = weight;
+			ns++;
+			mem->nr_nsched++;
+		} else
 			node_clear(nid, mem->scan_nodes);
 
 		mem->info.total_weight += weight;
@@ -1707,34 +1747,58 @@ static void mem_cgroup_may_update_nodema
  * hit limits, it will see a contention on a node. But freeing from remote
  * node means more costs for memory reclaim because of memory latency.
  *
- * Now, we use round-robin. Better algorithm is welcomed.
+ * Now, we use lottery scheduling based on each node's weight.
  */
+int node_weight_compare(const void *key, const void *elt)
+{
+	const unsigned long lottery = (unsigned long)key;
+	const struct mem_cgroup_numasched *ns = elt;
+
+	if (lottery < ns->start)
+		return -1;
+	if (lottery >= ns->start + ns->ticket)
+		return 1;
+	return 0;
+}
+
 int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
 {
+	unsigned long lottery;
+	struct mem_cgroup_numasched *ns;
 	int node;
 
 	mem_cgroup_may_update_nodemask(mem);
-	node = mem->last_scanned_node;
+	if (!mutex_trylock(&mem->numascan_mutex))
+		return numa_node_id();
 
-	node = next_node(node, mem->scan_nodes);
-	if (node == MAX_NUMNODES)
-		node = first_node(mem->scan_nodes);
-	/*
-	 * We call this when we hit limit, not when pages are added to LRU.
-	 * No LRU may hold pages because all pages are UNEVICTABLE or
-	 * memcg is too small and all pages are not on LRU. In that case,
-	 * we use curret node.
-	 */
-	if (unlikely(node == MAX_NUMNODES))
-		node = numa_node_id();
+	lottery = random32()/mem->info.total_weight;
+	ns = bsearch((void *)lottery, mem->nsched, mem->nr_nsched,
+		sizeof(struct mem_cgroup_numasched), node_weight_compare);
 
-	mem->last_scanned_node = node;
+	if (unlikely(ns == NULL))
+		node = numa_node_id();
+	else
+		node = ns->nid;
+	mutex_unlock(&mem->numascan_mutex);
 	return node;
 }
 
-static void mem_cgroup_numascan_init(struct mem_cgroup *mem)
+static bool mem_cgroup_numascan_init(struct mem_cgroup *mem)
 {
+	int size;
+
 	mutex_init(&mem->numascan_mutex);
+
+	size = sizeof(struct mem_cgroup_numasched) * num_possible_cpus();
+	mem->nsched = kmalloc(size, GFP_KERNEL);
+	if (!mem->nsched)
+		return false;
+	return true;
+}
+
+static void mem_cgroup_numascan_free(struct mem_cgroup *mem)
+{
+	kfree(mem->nsched);
 }
 
 static bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
@@ -1759,9 +1823,12 @@ int mem_cgroup_select_victim_node(struct
 {
 	return 0;
 }
-static void mem_cgroup_numascan_init(struct mem_cgroup *mem)
+static bool mem_cgroup_numascan_init(struct mem_cgroup *mem)
+{
+	return true;
+}
+static void mem_cgroup_numascan_free(struct mem_cgroup *mem)
 {
-	return 0;
 }
 
 static bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
@@ -5024,6 +5091,7 @@ static void __mem_cgroup_free(struct mem
 
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
+	mem_cgroup_numascan_free(mem);
 
 	free_percpu(mem->stat);
 	if (sizeof(struct mem_cgroup) < PAGE_SIZE)
@@ -5113,6 +5181,8 @@ mem_cgroup_create(struct cgroup_subsys *
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
+	if (!mem_cgroup_numascan_init(mem))
+		goto free_out;
 
 	/* root ? */
 	if (cont->parent == NULL) {
@@ -5149,7 +5219,6 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->memsw, NULL);
 	}
 	mem->last_scanned_child = 0;
-	mem->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
@@ -5157,7 +5226,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
-	mem_cgroup_numascan_init(mem);
 	spin_lock_init(&mem->scanstat.lock);
 	return &mem->css;
 free_out:

