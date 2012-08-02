Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2HBGFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:05:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab2HBGA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:00:59 -0400
X-IronPort-AV: E=Sophos;i="4.77,698,1336320000"; 
   d="scan'208";a="5534625"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org
Subject: [RFC PATCH 07/23 V2] memcontrol: use N_MEMORY instead N_HIGH_MEMORY
Date: Thu, 2 Aug 2012 14:01:12 +0800
Message-Id: <1343887288-8866-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:28,
	Serialize complete at 2012/08/02 14:01:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/memcontrol.c  |   18 +++++++++---------
 mm/page_cgroup.c |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f72b5e5..4402c2e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -797,7 +797,7 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 	int nid;
 	u64 total = 0;
 
-	for_each_node_state(nid, N_HIGH_MEMORY)
+	for_each_node_state(nid, N_MEMORY)
 		total += mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask);
 	return total;
 }
@@ -1549,9 +1549,9 @@ static void mem_cgroup_may_update_nodemask(struct mem_cgroup *memcg)
 		return;
 
 	/* make a nodemask where this memcg uses memory from */
-	memcg->scan_nodes = node_states[N_HIGH_MEMORY];
+	memcg->scan_nodes = node_states[N_MEMORY];
 
-	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
+	for_each_node_mask(nid, node_states[N_MEMORY]) {
 
 		if (!test_mem_cgroup_node_reclaimable(memcg, nid, false))
 			node_clear(nid, memcg->scan_nodes);
@@ -1622,7 +1622,7 @@ static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
 	/*
 	 * Check rest of nodes.
 	 */
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		if (node_isset(nid, memcg->scan_nodes))
 			continue;
 		if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
@@ -3700,7 +3700,7 @@ move_account:
 		drain_all_stock_sync(memcg);
 		ret = 0;
 		mem_cgroup_start_move(memcg);
-		for_each_node_state(node, N_HIGH_MEMORY) {
+		for_each_node_state(node, N_MEMORY) {
 			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
 				enum lru_list lru;
 				for_each_lru(lru) {
@@ -4025,7 +4025,7 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 
 	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
 	seq_printf(m, "total=%lu", total_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
@@ -4033,7 +4033,7 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 
 	file_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_FILE);
 	seq_printf(m, "file=%lu", file_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				LRU_ALL_FILE);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
@@ -4042,7 +4042,7 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 
 	anon_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_ANON);
 	seq_printf(m, "anon=%lu", anon_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				LRU_ALL_ANON);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
@@ -4051,7 +4051,7 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 
 	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
 	seq_printf(m, "unevictable=%lu", unevictable_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				BIT(LRU_UNEVICTABLE));
 		seq_printf(m, " N%d=%lu", nid, node_nr);
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index eb750f8..e775239 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -271,7 +271,7 @@ void __init page_cgroup_init(void)
 	if (mem_cgroup_disabled())
 		return;
 
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long start_pfn, end_pfn;
 
 		start_pfn = node_start_pfn(nid);
-- 
1.7.1

