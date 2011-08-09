Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1HIKSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:18:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46374 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1HIKSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:18:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 19:11:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH v5 4/6]  memg: calculate numa weight for vmscan
Message-Id: <20110809191100.6c4c3285.kamezawa.hiroyu@jp.fujitsu.com>
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

caclculate node scan weight.

Now, memory cgroup selects a scan target node in round-robin.
It's not very good...there is not scheduling based on page usages.

This patch is for calculating each node's weight for scanning.
If weight of a node is high, the node is worth to be scanned.

The weight is now calucauted on following concept.

   - make use of swappiness.
   - If inactive-file is enough, ignore active-file
   - If file is enough (w.r.t swappiness), ignore anon
   - make use of recent_scan/rotated reclaim stats.

Then, a node contains many inactive file pages will be a 1st victim.
Node selection logic based on this weight will be in the next patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 105 insertions(+), 5 deletions(-)

Index: mmotm-Aug3/mm/memcontrol.c
===================================================================
--- mmotm-Aug3.orig/mm/memcontrol.c
+++ mmotm-Aug3/mm/memcontrol.c
@@ -144,6 +144,7 @@ struct mem_cgroup_per_zone {
 
 struct mem_cgroup_per_node {
 	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
+	unsigned long weight;
 };
 
 struct mem_cgroup_lru_info {
@@ -286,6 +287,7 @@ struct mem_cgroup {
 	atomic_t	numainfo_events;
 	atomic_t	numainfo_updating;
 	struct work_struct	numainfo_update_work;
+	unsigned long total_weight;
 #endif
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
@@ -1568,18 +1570,108 @@ static bool test_mem_cgroup_node_reclaim
 }
 #if MAX_NUMNODES > 1
 
+static unsigned long
+__mem_cgroup_calc_numascan_weight(struct mem_cgroup * memcg,
+				int nid,
+				unsigned long anon_prio,
+				unsigned long file_prio,
+				int lru_mask)
+{
+	u64 file, anon;
+	unsigned long weight, mask;
+	unsigned long rotated[2], scanned[2];
+	int zid;
+
+	scanned[0] = 0;
+	scanned[1] = 0;
+	rotated[0] = 0;
+	rotated[1] = 0;
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct mem_cgroup_per_zone *mz;
+
+		mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+		scanned[0] += mz->reclaim_stat.recent_scanned[0];
+		scanned[1] += mz->reclaim_stat.recent_scanned[1];
+		rotated[0] += mz->reclaim_stat.recent_rotated[0];
+		rotated[1] += mz->reclaim_stat.recent_rotated[1];
+	}
+	file = mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask & LRU_ALL_FILE);
+
+	if (total_swap_pages)
+		anon = mem_cgroup_node_nr_lru_pages(memcg,
+					nid, mask & LRU_ALL_ANON);
+	else
+		anon = 0;
+	if (!(file + anon))
+		node_clear(nid, memcg->scan_nodes);
+
+	/* 'scanned - rotated/scanned' means ratio of finding not active. */
+	anon = anon * (scanned[0] - rotated[0]) / (scanned[0] + 1);
+	file = file * (scanned[1] - rotated[1]) / (scanned[1] + 1);
+
+	weight = (anon * anon_prio + file * file_prio) / 200;
+	return weight;
+}
+
+/*
+ * Calculate each NUMA node's scan weight. scan weight is determined by
+ * amount of pages and recent scan ratio, swappiness.
+ */
+static unsigned long
+mem_cgroup_calc_numascan_weight(struct mem_cgroup *memcg)
+{
+	unsigned long weight, total_weight;
+	u64 anon_prio, file_prio, nr_anon, nr_file;
+	int lru_mask;
+	int nid;
+
+	anon_prio = mem_cgroup_swappiness(memcg) + 1;
+	file_prio = 200 - anon_prio + 1;
+
+	lru_mask = BIT(LRU_INACTIVE_FILE);
+	if (mem_cgroup_inactive_file_is_low(memcg))
+		lru_mask |= BIT(LRU_ACTIVE_FILE);
+	/*
+	 * In vmscan.c, we'll scan anonymous pages with regard to memcg/zone's
+	 * amounts of file/anon pages and swappiness and reclaim_stat. Here,
+	 * we try to find good node to be scanned. If the memcg contains enough
+	 * file caches, we'll ignore anon's weight.
+	 * (Note) scanning anon-only node tends to be waste of time.
+	 */
+
+	nr_file = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_FILE);
+	nr_anon = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_ANON);
+
+	/* If file cache is small w.r.t swappiness, check anon page's weight */
+	if (nr_file * file_prio >= nr_anon * anon_prio)
+		lru_mask |= BIT(LRU_INACTIVE_ANON);
+
+	total_weight = 0;
+
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		weight = __mem_cgroup_calc_numascan_weight(memcg,
+				nid, anon_prio, file_prio, lru_mask);
+		memcg->info.nodeinfo[nid]->weight = weight;
+		total_weight += weight;
+	}
+
+	return total_weight;
+}
+
+/*
+ * Update all node's scan weight in background.
+ */
 static void mem_cgroup_numainfo_update_work(struct work_struct *work)
 {
 	struct mem_cgroup *memcg;
-	int nid;
 
 	memcg = container_of(work, struct mem_cgroup, numainfo_update_work);
 
 	memcg->scan_nodes = node_states[N_HIGH_MEMORY];
-	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
-		if (!test_mem_cgroup_node_reclaimable(memcg, nid, false))
-			node_clear(nid, memcg->scan_nodes);
-	}
+
+	memcg->total_weight = mem_cgroup_calc_numascan_weight(memcg);
+
 	atomic_set(&memcg->numainfo_updating, 0);
 	css_put(&memcg->css);
 }
@@ -4277,6 +4369,14 @@ static int mem_control_numa_stat_show(st
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
 	seq_putc(m, '\n');
+
+	seq_printf(m, "scan_weight=%lu", mem_cont->total_weight);
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		unsigned long weight;
+		weight = mem_cont->info.nodeinfo[nid]->weight;
+		seq_printf(m, " N%d=%lu", nid, weight);
+	}
+	seq_putc(m, '\n');
 	return 0;
 }
 #endif /* CONFIG_NUMA */

