Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2BQJ1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:27:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56208 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2BQJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:27:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Feb 2012 18:26:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 2/6] memcg: simplify move_account() check.
Message-Id: <20120217182612.810f6784.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3b6620772d7fd7b2126d5253eafb6afaf4ed6e34 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 2 Feb 2012 10:02:39 +0900
Subject: [PATCH 2/6] memcg: simplify move_account() check.

In memcg, for avoiding take-lock-irq-off at accessing page_cgroup,
a logic, flag + rcu_read_lock(), is used. This works as following

     CPU-A                     CPU-B
                             rcu_read_lock()
    set flag
                             if(flag is set)
                                   take heavy lock
                             do job.
    synchronize_rcu()        rcu_read_unlock()
    take heavy lock.

In recent discussion, it's argued that using per-cpu value for this
flag just complicates the code because 'set flag' is very rare.

This patch changes 'flag' implementation from percpu to atomic_t.
This will be much simpler.

Changelog v5.
 - removed redundant ().
 - updated patch description.

Changelog: v4
 - fixed many typos.
 - fixed return value to be bool
 - add comments.
Changelog: v3
 - this is a new patch since v3.

Acked-by: Greg Thelen <gthelen@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 memcontrol.c |   65 ++++++++++++++++++++++-------------------------------------
 1 file changed, 25 insertions(+), 40 deletions(-)
---
 mm/memcontrol.c |   70 +++++++++++++++++++++++-------------------------------
 1 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4c2b759..9c94389 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -89,7 +89,6 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
-	MEM_CGROUP_ON_MOVE,	/* someone is moving account between groups */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -278,6 +277,10 @@ struct mem_cgroup {
 	 */
 	unsigned long 	move_charge_at_immigrate;
 	/*
+	 * set > 0 if pages under this cgroup are moving to other cgroup.
+	 */
+	atomic_t	moving_account;
+	/*
 	 * percpu counter.
 	 */
 	struct mem_cgroup_stat_cpu *stat;
@@ -1253,36 +1256,37 @@ int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 	return memcg->swappiness;
 }
+/*
+ * memcg->moving_account is used for checking possibility that some thread is
+ * calling move_account(). When a thread on CPU-A starts moving pages under
+ * a memcg, other threads should check memcg->moving_account under
+ * rcu_read_lock(), like this:
+ *
+ *         CPU-A                                    CPU-B
+ *                                              rcu_read_lock()
+ *         memcg->moving_account+1              if (memcg->mocing_account)
+ *                                                   take heavy locks.
+ *         synchronize_rcu()                    update something.
+ *                                              rcu_read_unlock()
+ *         start move here.
+ */
 
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
-	int cpu;
-
-	get_online_cpus();
-	spin_lock(&memcg->pcp_counter_lock);
-	for_each_online_cpu(cpu)
-		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
-	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] += 1;
-	spin_unlock(&memcg->pcp_counter_lock);
-	put_online_cpus();
-
+	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
 }
 
 static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 {
-	int cpu;
-
-	if (!memcg)
-		return;
-	get_online_cpus();
-	spin_lock(&memcg->pcp_counter_lock);
-	for_each_online_cpu(cpu)
-		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
-	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] -= 1;
-	spin_unlock(&memcg->pcp_counter_lock);
-	put_online_cpus();
+	/*
+	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
+	 * We check NULL in callee rather than caller.
+	 */
+	if (memcg)
+		atomic_dec(&memcg->moving_account);
 }
+
 /*
  * 2 routines for checking "mem" is under move_account() or not.
  *
@@ -1298,7 +1302,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 static bool mem_cgroup_stealed(struct mem_cgroup *memcg)
 {
 	VM_BUG_ON(!rcu_read_lock_held());
-	return this_cpu_read(memcg->stat->count[MEM_CGROUP_ON_MOVE]) > 0;
+	return atomic_read(&memcg->moving_account) > 0;
 }
 
 static bool mem_cgroup_under_move(struct mem_cgroup *memcg)
@@ -1849,8 +1853,8 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask)
  * by flags.
  *
  * Considering "move", this is an only case we see a race. To make the race
- * small, we check MEM_CGROUP_ON_MOVE percpu value and detect there are
- * possibility of race condition. If there is, we take a lock.
+ * small, we check mm->moving_account and detect there are possibility of race
+ * If there is, we take a lock.
  */
 
 void mem_cgroup_update_page_stat(struct page *page,
@@ -2067,17 +2071,6 @@ static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *memcg, int cpu)
 		per_cpu(memcg->stat->events[i], cpu) = 0;
 		memcg->nocpu_base.events[i] += x;
 	}
-	/* need to clear ON_MOVE value, works as a kind of lock. */
-	per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) = 0;
-	spin_unlock(&memcg->pcp_counter_lock);
-}
-
-static void synchronize_mem_cgroup_on_move(struct mem_cgroup *memcg, int cpu)
-{
-	int idx = MEM_CGROUP_ON_MOVE;
-
-	spin_lock(&memcg->pcp_counter_lock);
-	per_cpu(memcg->stat->count[idx], cpu) = memcg->nocpu_base.count[idx];
 	spin_unlock(&memcg->pcp_counter_lock);
 }
 
@@ -2089,11 +2082,8 @@ static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *iter;
 
-	if ((action == CPU_ONLINE)) {
-		for_each_mem_cgroup(iter)
-			synchronize_mem_cgroup_on_move(iter, cpu);
+	if (action == CPU_ONLINE)
 		return NOTIFY_OK;
-	}
 
 	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
-- 
1.7.4.1


