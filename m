Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1FIAhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 20:37:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57275 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1FIAhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 20:37:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Jun 2011 09:30:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>
Subject: [BUGFIX][PATCH v3] memcg: fix behavior of per cpu charge cache
 draining.
Message-Id: <20110609093045.1f969d30.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0ebd8a90a91d50c512e7c63e5529a22e44e84c42 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 8 Jun 2011 13:51:11 +0900
Subject: [PATCH] Fix behavior of per-cpu charge cache draining in memcg.

For performance, memory cgroup caches some "charge" from res_counter
into per cpu cache. This works well but because it's cache,
it needs to be flushed in some cases. Typical cases are
	1. when someone hit limit.
	2. when rmdir() is called and need to charges to be 0.

But "1" has problem.

Recently, with large SMP machines, we many kworker runs because
of flushing memcg's cache. Bad things in implementation are

a) it's called before calling try_to_free_mem_cgroup_pages()
   so, it's called immidiately when a task hit limit.
   (I though it was better to avoid to run into memory reclaim.
    But it was wrong decision.)

b) Even if a cpu contains a cache for memcg not related to
   a memcg which hits limit, drain code is called.

This patch fixes a) and b) by

A) delay calling of flushing until one run of try_to_free...
   Then, the number of calling is decreased.
B) check percpu cache contains a useful data or not.
plus
C) check asynchronous percpu draining doesn't run.

BTW, why this patch relpaces atomic_t counter with mutex is
to guarantee a memcg which is pointed by stock->cacne is
not destroyed while we check css_id.

Reported-by: Ying Han <yinghan@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog:
 - fixed typo.
 - fixed rcu_read_lock() and add strict mutal execution between
   asynchronous and synchronous flushing. It's requred for validness
   of cached pointer.
 - add root_mem->use_hierarchy check.
---
 mm/memcontrol.c |   54 +++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bd9052a..3baddcb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -359,7 +359,7 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
-static void drain_all_stock_async(void);
+static void drain_all_stock_async(struct mem_cgroup *mem);
 
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
@@ -1670,8 +1670,6 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
-			if (loop >= 1)
-				drain_all_stock_async();
 			if (loop >= 2) {
 				/*
 				 * If we have not been able to reclaim
@@ -1723,6 +1721,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 				return total;
 		} else if (mem_cgroup_margin(root_mem))
 			return total;
+		drain_all_stock_async(root_mem);
 	}
 	return total;
 }
@@ -1934,9 +1933,12 @@ struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
 	struct work_struct work;
+	unsigned long flags;
+#define ASYNC_FLUSHING	(0)
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
-static atomic_t memcg_drain_count;
+/* mutex for draining percpu charge for avoid too much kworker works. */
+DEFINE_MUTEX(percpu_charge_mutex);
 
 /*
  * Try to consume stocked charge on this cpu. If success, one page is consumed
@@ -1984,6 +1986,7 @@ static void drain_local_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock = &__get_cpu_var(memcg_stock);
 	drain_stock(stock);
+	clear_bit(ASYNC_FLUSHING, &stock->flags);
 }
 
 /*
@@ -2006,38 +2009,51 @@ static void refill_stock(struct mem_cgroup *mem, unsigned int nr_pages)
  * Tries to drain stocked charges in other cpus. This function is asynchronous
  * and just put a work per cpu for draining localy on each cpu. Caller can
  * expects some charges will be back to res_counter later but cannot wait for
- * it.
+ * it. This runs only when per-cpu stock contains information of memcg which
+ * is under specified root_mem and no other flush runs.
  */
-static void drain_all_stock_async(void)
+static void drain_all_stock_async(struct mem_cgroup *root_mem)
 {
 	int cpu;
-	/* This function is for scheduling "drain" in asynchronous way.
-	 * The result of "drain" is not directly handled by callers. Then,
-	 * if someone is calling drain, we don't have to call drain more.
-	 * Anyway, WORK_STRUCT_PENDING check in queue_work_on() will catch if
-	 * there is a race. We just do loose check here.
+
+	/*
+	 * If synchronous flushing (which flushes all cpus's cache) runs,
+	 * or some other kworker runs already. avoid more calls.
 	 */
-	if (atomic_read(&memcg_drain_count))
+	if (!mutex_trylock(&percpu_charge_mutex))
 		return;
-	/* Notify other cpus that system-wide "drain" is running */
-	atomic_inc(&memcg_drain_count);
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		schedule_work_on(cpu, &stock->work);
+		struct mem_cgroup *mem;
+		bool do_flush;
+		/*
+		 * This stock->cached is cleared before mem cgroup is destroyed.
+		 * And we have mutex. So it's safe to access stock->cached.
+		 */
+
+		mem = stock->cached;
+		if (!mem)
+			continue;
+		rcu_read_lock();
+		do_flush = ((mem == root_mem) ||
+			(root_mem->use_hierarchy &&
+		     	 css_is_ancestor(&mem->css, &root_mem->css)));
+		rcu_read_unlock();
+		if (do_flush && !test_and_set_bit(ASYNC_FLUSHING, &stock->flags))
+			schedule_work_on(cpu, &stock->work);
 	}
  	put_online_cpus();
-	atomic_dec(&memcg_drain_count);
-	/* We don't wait for flush_work */
+	mutex_unlock(&percpu_charge_mutex);
 }
 
 /* This is a synchronous drain interface. */
 static void drain_all_stock_sync(void)
 {
 	/* called when force_empty is called */
-	atomic_inc(&memcg_drain_count);
+	mutex_lock(&percpu_charge_mutex);
 	schedule_on_each_cpu(drain_local_stock);
-	atomic_dec(&memcg_drain_count);
+	mutex_unlock(&percpu_charge_mutex);
 }
 
 /*
-- 
1.7.4.1


