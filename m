Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1G0Fx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 01:53:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38180 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1G0Fx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:53:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Jul 2011 14:46:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH v4 1/5] memcg : update numascan info by schedule_work
Message-Id: <20110727144642.bef211c2.kamezawa.hiroyu@jp.fujitsu.com>
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


Making memcg numa's scanning information update by schedule_work().

Now, memcg's numa information is updated under a thread doing
memory reclaim. It's not very heavy weight now. But upcoming updates
around numa scanning will add more works. This patch makes
the update be done by schedule_work() and reduce latency caused
by this updates.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

Index: mmotm-0710/mm/memcontrol.c
===================================================================
--- mmotm-0710.orig/mm/memcontrol.c
+++ mmotm-0710/mm/memcontrol.c
@@ -284,6 +284,7 @@ struct mem_cgroup {
 	nodemask_t	scan_nodes;
 	atomic_t	numainfo_events;
 	atomic_t	numainfo_updating;
+	struct work_struct	numainfo_update_work;
 #endif
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
@@ -1551,6 +1552,23 @@ static bool test_mem_cgroup_node_reclaim
 }
 #if MAX_NUMNODES > 1
 
+static void mem_cgroup_numainfo_update_work(struct work_struct *work)
+{
+	struct mem_cgroup *memcg;
+	int nid;
+
+	memcg = container_of(work, struct mem_cgroup, numainfo_update_work);
+
+	memcg->scan_nodes = node_states[N_HIGH_MEMORY];
+	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
+		if (!test_mem_cgroup_node_reclaimable(memcg, nid, false))
+			node_clear(nid, memcg->scan_nodes);
+	}
+	atomic_set(&memcg->numainfo_updating, 0);
+	css_put(&memcg->css);
+}
+
+
 /*
  * Always updating the nodemask is not very good - even if we have an empty
  * list or the wrong list here, we can start from some node and traverse all
@@ -1559,7 +1577,6 @@ static bool test_mem_cgroup_node_reclaim
  */
 static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
 {
-	int nid;
 	/*
 	 * numainfo_events > 0 means there was at least NUMAINFO_EVENTS_TARGET
 	 * pagein/pageout changes since the last update.
@@ -1568,18 +1585,9 @@ static void mem_cgroup_may_update_nodema
 		return;
 	if (atomic_inc_return(&mem->numainfo_updating) > 1)
 		return;
-
-	/* make a nodemask where this memcg uses memory from */
-	mem->scan_nodes = node_states[N_HIGH_MEMORY];
-
-	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
-
-		if (!test_mem_cgroup_node_reclaimable(mem, nid, false))
-			node_clear(nid, mem->scan_nodes);
-	}
-
 	atomic_set(&mem->numainfo_events, 0);
-	atomic_set(&mem->numainfo_updating, 0);
+	css_get(&mem->css);
+	schedule_work(&mem->numainfo_update_work);
 }
 
 /*
@@ -1652,6 +1660,12 @@ bool mem_cgroup_reclaimable(struct mem_c
 	return false;
 }
 
+static void mem_cgroup_numascan_init(struct mem_cgroup *memcg)
+{
+	INIT_WORK(&memcg->numainfo_update_work,
+		mem_cgroup_numainfo_update_work);
+}
+
 #else
 int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
 {
@@ -1662,6 +1676,9 @@ bool mem_cgroup_reclaimable(struct mem_c
 {
 	return test_mem_cgroup_node_reclaimable(mem, 0, noswap);
 }
+static void mem_cgroup_numascan_init(struct mem_cgroup *memcg)
+{
+}
 #endif
 
 static void __mem_cgroup_record_scanstat(unsigned long *stats,
@@ -5032,6 +5049,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
 	spin_lock_init(&mem->scanstat.lock);
+	mem_cgroup_numascan_init(mem);
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);

