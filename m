Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0IUJl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:41:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33670 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab0IUJl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:41:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Sep 2010 18:36:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3][-mm] memcg: cpu hotplug aware quick acount_move
 detection
Message-Id: <20100921183647.9c3f538f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100921183127.1c4c2bc1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100921183127.1c4c2bc1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

An event counter MEM_CGROUP_ON_MOVE is used for quick check whether
file stat update can be done in async manner or not. Now, it use
percpu counter and for_each_possible_cpu to update.

This patch replaces for_each_possible_cpu to for_each_online_cpu
and adds necessary synchronization logic at CPU HOTPLUG.

Changelog:
 - make use of cpu independent "core" value to synchronize.
 - replaces mc.lock with pcp_coutner_lock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

Index: mmotm-0915/mm/memcontrol.c
===================================================================
--- mmotm-0915.orig/mm/memcontrol.c
+++ mmotm-0915/mm/memcontrol.c
@@ -1116,11 +1116,14 @@ static unsigned int get_swappiness(struc
 static void mem_cgroup_start_move(struct mem_cgroup *mem)
 {
 	int cpu;
-	/* Because this is for moving account, reuse mc.lock */
-	spin_lock(&mc.lock);
-	for_each_possible_cpu(cpu)
+
+	get_online_cpus();
+	spin_lock(&mem->pcp_counter_lock);
+	for_each_online_cpu(cpu)
 		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
-	spin_unlock(&mc.lock);
+	mem->nocpu_base.count[MEM_CGROUP_ON_MOVE] += 1;
+	spin_unlock(&mem->pcp_counter_lock);
+	put_online_cpus();
 
 	synchronize_rcu();
 }
@@ -1131,10 +1134,13 @@ static void mem_cgroup_end_move(struct m
 
 	if (!mem)
 		return;
-	spin_lock(&mc.lock);
-	for_each_possible_cpu(cpu)
+	get_online_cpus();
+	spin_lock(&mem->pcp_counter_lock);
+	for_each_online_cpu(cpu)
 		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
-	spin_unlock(&mc.lock);
+	mem->nocpu_base.count[MEM_CGROUP_ON_MOVE] -= 1;
+	spin_unlock(&mem->pcp_counter_lock);
+	put_online_cpus();
 }
 /*
  * 2 routines for checking "mem" is under move_account() or not.
@@ -1735,6 +1741,17 @@ static void mem_cgroup_drain_pcp_counter
 		per_cpu(mem->stat->count[i], cpu) = 0;
 		mem->nocpu_base.count[i] += x;
 	}
+	/* need to clear ON_MOVE value, works as a kind of lock. */
+	per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE],cpu) = 0;
+	spin_unlock(&mem->pcp_counter_lock);
+}
+
+static void synchronize_mem_cgroup_on_move(struct mem_cgroup *mem, int cpu)
+{
+	int idx = MEM_CGROUP_ON_MOVE;
+
+	spin_lock(&mem->pcp_counter_lock);
+	per_cpu(mem->stat->count[idx],cpu) = mem->nocpu_base.count[idx];
 	spin_unlock(&mem->pcp_counter_lock);
 }
 
@@ -1746,6 +1763,12 @@ static int __cpuinit memcg_cpu_hotplug_c
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *iter;
 
+	if ((action == CPU_ONLINE)) {
+		for_each_mem_cgroup_all(iter)
+			synchronize_mem_cgroup_on_move(iter, cpu);
+		return NOTIFY_OK;
+	}
+
 	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 

