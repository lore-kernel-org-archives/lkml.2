Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab1FPEDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:03:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52723 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1FPEDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:03:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jun 2011 12:56:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: [PATCH 6/7] memcg: calc NUMA node's weight for scan.
Message-Id: <20110616125633.9b9fa703.kamezawa.hiroyu@jp.fujitsu.com>
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

>From fb8aaa2c5f7fd99dfcb5d2ecb3c1226a58caafea Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 16 Jun 2011 10:05:46 +0900
Subject: [PATCH 6/7] memcg: calc NUMA node's weight for scan.

Now, by commit 889976, numa node scan of memcg is in round-robin.
As commit log says, "a better algorithm is needed".

for implementing some good scheduling, one of required things is
defining importance of each node at LRU scanning.

This patch defines each node's weight for scan as

swappiness = (memcg's swappiness)? memcg's swappiness : 1
FILE = inactive_file + (inactive_file_is_low)? active_file : 0
ANON = inactive_anon + (inactive_anon_is_low)? active_anon : 0

weight = (FILE * (200-swappiness) + ANON * swappiness)/200.

Note: After we have dirty page accounting per memcg, we can make use of
      dirty page information. (very dirty node should be skipped...)

Following patch will implement a scheduling using this weight.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 8 deletions(-)

Index: mmotm-0615/mm/memcontrol.c
===================================================================
--- mmotm-0615.orig/mm/memcontrol.c
+++ mmotm-0615/mm/memcontrol.c
@@ -144,10 +144,12 @@ struct mem_cgroup_per_zone {
 
 struct mem_cgroup_per_node {
 	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
+	unsigned long weight;
 };
 
 struct mem_cgroup_lru_info {
 	struct mem_cgroup_per_node *nodeinfo[MAX_NUMNODES];
+	unsigned long total_weight;
 };
 
 /*
@@ -1617,6 +1619,33 @@ mem_cgroup_select_victim(struct mem_cgro
 
 #if MAX_NUMNODES > 1
 
+static unsigned long mem_cgroup_numascan_weight(struct mem_cgroup *mem,
+				int nid, bool inactive_file_low,
+				bool inactive_anon_low)
+{
+	unsigned int swappiness = mem_cgroup_swappiness(mem);
+	unsigned long file, anon, weight;
+
+	/* swappiness == 0 needs some care for avoiding very heavy scanning */
+	if (!swappiness)
+		swappiness = 1;
+
+	file = mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_FILE);
+	if (inactive_file_low)
+		file += mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_FILE);
+
+	anon = mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_ANON);
+	if (inactive_anon_low)
+		anon += mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_ANON);
+
+	if (!total_swap_pages || !res_counter_margin(&mem->memsw))
+		weight = file;
+	else
+		weight = (file * (200 - swappiness) + anon * swappiness)/200;
+	mem->info.nodeinfo[nid]->weight = weight;
+	return weight;
+}
+
 /*
  * Always updating the nodemask is not very good - even if we have an empty
  * list or the wrong list here, we can start from some node and traverse all
@@ -1630,6 +1659,7 @@ mem_cgroup_select_victim(struct mem_cgro
 #define NUMASCAN_UPDATE_THRESH	(16384UL) /* 16k events of pagein/pageout */
 static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
 {
+	bool inactive_file_low, inactive_anon_low;
 	int nid;
 	unsigned long long limit;
 	/* if no limit, we never reach here */
@@ -1649,17 +1679,20 @@ static void mem_cgroup_may_update_nodema
 	/* make a nodemask where this memcg uses memory from */
 	mem->scan_nodes = node_states[N_HIGH_MEMORY];
 
+	inactive_file_low = mem_cgroup_inactive_file_is_low(mem);
+	inactive_anon_low = mem_cgroup_inactive_anon_is_low(mem);
+	mem->info.total_weight = 0;
+
 	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
+		unsigned long weight;
 
-		if (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_FILE) ||
-		    mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_FILE))
-			continue;
+		weight = mem_cgroup_numascan_weight(mem, nid,
+						inactive_file_low,
+						inactive_anon_low);
+		if (!weight)
+			node_clear(nid, mem->scan_nodes);
 
-		if (total_swap_pages &&
-		    (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_ANON) ||
-		     mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_ANON)))
-			continue;
-		node_clear(nid, mem->scan_nodes);
+		mem->info.total_weight += weight;
 	}
 	mutex_unlock(&mem->numascan_mutex);
 }
@@ -4295,6 +4328,15 @@ static int mem_control_numa_stat_show(st
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
 	seq_putc(m, '\n');
+
+	seq_printf(m, "scan_weight=%lu", mem_cont->info.total_weight);
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		unsigned long weight;
+
+		weight = mem_cont->info.nodeinfo[nid]->weight;
+		seq_printf(m, " N%d=%lu", nid, weight);
+	}
+	seq_putc(m, '\n');
 	return 0;
 }
 #endif /* CONFIG_NUMA */

