Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993270Ab2KOIvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:51:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2993227Ab2KOIv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:51:29 -0500
X-IronPort-AV: E=Sophos;i="4.83,256,1352044800"; 
   d="scan'208";a="6205588"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Lin feng <linfeng@cn.fujitsu.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PART3 Patch v2 04/14] memcontrol: use N_MEMORY instead N_HIGH_MEMORY
Date: Thu, 15 Nov 2012 16:57:27 +0800
Message-Id: <1352969857-26623-5-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969857-26623-1-git-send-email-wency@cn.fujitsu.com>
References: <1352969857-26623-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 16:51:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 16:51:20,
	Serialize complete at 2012/11/15 16:51:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 mm/memcontrol.c  | 18 +++++++++---------
 mm/page_cgroup.c |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7acf43b..1b69665 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -800,7 +800,7 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 	int nid;
 	u64 total = 0;
 
-	for_each_node_state(nid, N_HIGH_MEMORY)
+	for_each_node_state(nid, N_MEMORY)
 		total += mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask);
 	return total;
 }
@@ -1611,9 +1611,9 @@ static void mem_cgroup_may_update_nodemask(struct mem_cgroup *memcg)
 		return;
 
 	/* make a nodemask where this memcg uses memory from */
-	memcg->scan_nodes = node_states[N_HIGH_MEMORY];
+	memcg->scan_nodes = node_states[N_MEMORY];
 
-	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
+	for_each_node_mask(nid, node_states[N_MEMORY]) {
 
 		if (!test_mem_cgroup_node_reclaimable(memcg, nid, false))
 			node_clear(nid, memcg->scan_nodes);
@@ -1684,7 +1684,7 @@ static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
 	/*
 	 * Check rest of nodes.
 	 */
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		if (node_isset(nid, memcg->scan_nodes))
 			continue;
 		if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
@@ -3759,7 +3759,7 @@ move_account:
 		drain_all_stock_sync(memcg);
 		ret = 0;
 		mem_cgroup_start_move(memcg);
-		for_each_node_state(node, N_HIGH_MEMORY) {
+		for_each_node_state(node, N_MEMORY) {
 			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
 				enum lru_list lru;
 				for_each_lru(lru) {
@@ -4087,7 +4087,7 @@ static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 
 	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
 	seq_printf(m, "total=%lu", total_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
@@ -4095,7 +4095,7 @@ static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 
 	file_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_FILE);
 	seq_printf(m, "file=%lu", file_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				LRU_ALL_FILE);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
@@ -4104,7 +4104,7 @@ static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 
 	anon_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_ANON);
 	seq_printf(m, "anon=%lu", anon_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				LRU_ALL_ANON);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
@@ -4113,7 +4113,7 @@ static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 
 	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
 	seq_printf(m, "unevictable=%lu", unevictable_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				BIT(LRU_UNEVICTABLE));
 		seq_printf(m, " N%d=%lu", nid, node_nr);
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5ddad0c..c1054ad 100644
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
1.8.0

