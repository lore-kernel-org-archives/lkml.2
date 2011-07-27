Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1G0Fy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 01:54:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39110 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1G0Fy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:54:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Jul 2011 14:47:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH v4 2/5] memcg : pass scan nodemask
Message-Id: <20110727144742.420cf69c.kamezawa.hiroyu@jp.fujitsu.com>
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


pass memcg's nodemask to try_to_free_pages().

try_to_free_pages can take nodemask as its argument but memcg
doesn't pass it. Considering memcg can be used with cpuset on
big NUMA, memcg should pass nodemask if available.

Now, memcg maintain nodemask with periodic updates. pass it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |    8 ++++++--
 mm/vmscan.c                |    3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

Index: mmotm-0710/include/linux/memcontrol.h
===================================================================
--- mmotm-0710.orig/include/linux/memcontrol.h
+++ mmotm-0710/include/linux/memcontrol.h
@@ -117,7 +117,7 @@ extern void mem_cgroup_end_migration(str
  */
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
-int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
+int mem_cgroup_select_victim_node(struct mem_cgroup *memcg, nodemask_t **mask);
 unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
 					int nid, int zid, unsigned int lrumask);
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
Index: mmotm-0710/mm/memcontrol.c
===================================================================
--- mmotm-0710.orig/mm/memcontrol.c
+++ mmotm-0710/mm/memcontrol.c
@@ -1602,10 +1602,11 @@ static void mem_cgroup_may_update_nodema
  *
  * Now, we use round-robin. Better algorithm is welcomed.
  */
-int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
+int mem_cgroup_select_victim_node(struct mem_cgroup *mem, nodemask_t **mask)
 {
 	int node;
 
+	*mask = NULL;
 	mem_cgroup_may_update_nodemask(mem);
 	node = mem->last_scanned_node;
 
@@ -1620,6 +1621,8 @@ int mem_cgroup_select_victim_node(struct
 	 */
 	if (unlikely(node == MAX_NUMNODES))
 		node = numa_node_id();
+	else
+		*mask = &mem->scan_nodes;
 
 	mem->last_scanned_node = node;
 	return node;
@@ -1667,8 +1670,9 @@ static void mem_cgroup_numascan_init(str
 }
 
 #else
-int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
+int mem_cgroup_select_victim_node(struct mem_cgroup *mem, nodemask_t **mask)
 {
+	*mask = NULL;
 	return 0;
 }
 
Index: mmotm-0710/mm/vmscan.c
===================================================================
--- mmotm-0710.orig/mm/vmscan.c
+++ mmotm-0710/mm/vmscan.c
@@ -2280,6 +2280,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	unsigned long nr_reclaimed;
 	unsigned long start, end;
 	int nid;
+	nodemask_t *mask;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
@@ -2302,7 +2303,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	 * take care of from where we get pages. So the node where we start the
 	 * scan does not need to be the current node.
 	 */
-	nid = mem_cgroup_select_victim_node(mem_cont);
+	nid = mem_cgroup_select_victim_node(mem_cont, &mask);
 
 	zonelist = NODE_DATA(nid)->node_zonelists;
 

