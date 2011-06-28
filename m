Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1F1IrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:47:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55403 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab1F1IrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:47:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Jun 2011 17:39:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] memcg: fix reclaimable lru check in memcg.
Message-Id: <20110628173958.4f213b26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110628173122.9e5aecdf.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110628173122.9e5aecdf.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b52bcd09843e903e5f184d0ee499909d072f3c8d Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 28 Jun 2011 15:45:38 +0900
Subject: [PATCH 1/3] memcg: fix reclaimable lru check in memcg.

Now, in mem_cgroup_hierarchical_reclaim(), mem_cgroup_local_usage()
is used for checking whether the memcg contains reclaimable pages
or not. If no pages in it, the routine skips it.

But, mem_cgroup_local_usage() contains Unevictable pages and cannot
handle "noswap" condition correctly. This doesn't work on a swapless
system.

This patch adds test_mem_cgroup_reclaimable() and replaces
mem_cgroup_local_usage(). test_mem_cgroup_reclaimable() see LRU
counter and returns correct answer to the caller.
And this new function has "noswap" argument and can see only
FILE LRU if necessary.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelug:
  - make use of mem_cgroup_node_nr_file_lru_pages()
  - fixed coding styles.
---
 mm/memcontrol.c |   83 ++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ddffc74..c624312 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -577,15 +577,6 @@ static long mem_cgroup_read_stat(struct mem_cgroup *mem,
 	return val;
 }
 
-static long mem_cgroup_local_usage(struct mem_cgroup *mem)
-{
-	long ret;
-
-	ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
-	ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
-	return ret;
-}
-
 static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
 					 bool charge)
 {
@@ -1559,6 +1550,27 @@ mem_cgroup_select_victim(struct mem_cgroup *root_mem)
 	return ret;
 }
 
+/** test_mem_cgroup_node_reclaimable
+ * @mem: the target memcg
+ * @nid: the node ID to be checked.
+ * @noswap : specify true here if the user wants flle only information.
+ *
+ * This function returns whether the specified memcg contains any
+ * reclaimable pages on a node. Returns true if there are any reclaimable
+ * pages in the node.
+ */
+static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *mem,
+		int nid, bool noswap)
+{
+	if (mem_cgroup_node_nr_file_lru_pages(mem, nid))
+		return true;
+        if (noswap || !total_swap_pages)
+                return false;
+        if (mem_cgroup_node_nr_anon_lru_pages(mem, nid))
+                return true;
+        return false;
+
+}
 #if MAX_NUMNODES > 1
 
 /*
@@ -1580,15 +1592,8 @@ static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
 
 	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
 
-		if (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_FILE) ||
-		    mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_FILE))
-			continue;
-
-		if (total_swap_pages &&
-		    (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_ANON) ||
-		     mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_ANON)))
-			continue;
-		node_clear(nid, mem->scan_nodes);
+		if (!test_mem_cgroup_node_reclaimable(mem, nid, false))
+			node_clear(nid, mem->scan_nodes);
 	}
 }
 
@@ -1627,11 +1632,51 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
 	return node;
 }
 
+/*
+ * Check all nodes whether it contains reclaimable pages or not.
+ * For quick scan, we make use of scan_nodes. This will allow us to skip
+ * unused nodes. But scan_nodes is lazily updated and may not cotain
+ * enough new information. We need to do double check.
+ */
+bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
+{
+	int nid;
+
+	/*
+	 * quick check...making use of scan_node.
+	 * We can skip unused nodes.
+	 */
+	if (!nodes_empty(mem->scan_nodes)) {
+		for (nid = first_node(mem->scan_nodes);
+		     nid < MAX_NUMNODES;
+		     nid = next_node(nid, mem->scan_nodes)) {
+
+			if (test_mem_cgroup_node_reclaimable(mem, nid, noswap))
+				return true;
+		}
+	}
+	/*
+ 	 * Check rest of nodes.
+ 	 */
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		if (node_isset(nid, mem->scan_nodes))
+			continue;
+		if (test_mem_cgroup_node_reclaimable(mem, nid, noswap))
+			return true;	
+	}
+	return false;
+}
+
 #else
 int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
 {
 	return 0;
 }
+
+bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
+{
+	return test_mem_cgroup_node_reclaimable(mem, 0, noswap);
+}
 #endif
 
 /*
@@ -1702,7 +1747,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 				}
 			}
 		}
-		if (!mem_cgroup_local_usage(victim)) {
+		if (!mem_cgroup_reclaimable(victim, noswap)) {
 			/* this cgroup's local usage == 0 */
 			css_put(&victim->css);
 			continue;
-- 
1.7.4.1


