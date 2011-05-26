Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1EZFYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:24:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48660 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab1EZFYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:24:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 26 May 2011 14:18:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [RFC][PATCH v3 2/10] memcg: fix cached charge drain ratio
Message-Id: <20110526141805.e55da40c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


IIUC, this is a bugfix.
=
Memory cgroup cachess charge per cpu for avoinding heavy access
on res_counter. At memory reclaim, caches are drained in asynchronous
way.

On SMP system, if memcg hits limit heavily, this draining is
called too frequently and you'll see tons of kworker... 
Reduce it.

By this patch,
  - drain_all_stock_async is called only after 1st trial of reclaim fails.
  - drain_all_stock_async checks "cached" information is related to
    memory reclaim target.
  - drain_all_stock_async checks a flag per cpu to do draining.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

Index: memcg_async/mm/memcontrol.c
===================================================================
--- memcg_async.orig/mm/memcontrol.c
+++ memcg_async/mm/memcontrol.c
@@ -367,7 +367,7 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
-static void drain_all_stock_async(void);
+static void drain_all_stock_async(struct mem_cgroup *mem);
 
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
@@ -1768,8 +1768,6 @@ static int mem_cgroup_hierarchical_recla
 			return total;
 		if (victim == root_mem) {
 			loop++;
-			if (loop >= 1)
-				drain_all_stock_async();
 			if (loop >= 2) {
 				/*
 				 * If we have not been able to reclaim
@@ -1818,6 +1816,8 @@ static int mem_cgroup_hierarchical_recla
 				return total;
 		} else if (mem_cgroup_margin(root_mem))
 			return total;
+		/* we failed with the first memcg, drain cached ones. */
+		drain_all_stock_async(root_mem);
 	}
 	return total;
 }
@@ -2029,9 +2029,10 @@ struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
 	struct work_struct work;
+	unsigned long flags;
+#define STOCK_FLUSHING		(0)
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
-static atomic_t memcg_drain_count;
 
 /*
  * Try to consume stocked charge on this cpu. If success, one page is consumed
@@ -2078,7 +2079,9 @@ static void drain_stock(struct memcg_sto
 static void drain_local_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock = &__get_cpu_var(memcg_stock);
+
 	drain_stock(stock);
+	clear_bit(STOCK_FLUSHING, &stock->flags);
 }
 
 /*
@@ -2103,36 +2106,37 @@ static void refill_stock(struct mem_cgro
  * expects some charges will be back to res_counter later but cannot wait for
  * it.
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
-	 */
-	if (atomic_read(&memcg_drain_count))
-		return;
 	/* Notify other cpus that system-wide "drain" is running */
-	atomic_inc(&memcg_drain_count);
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		schedule_work_on(cpu, &stock->work);
+		struct mem_cgroup *mem;
+
+		rcu_read_lock();
+		mem = stock->cached;
+		if (!mem) {
+			rcu_read_unlock();
+			continue;
+		}
+		if ((mem == root_mem ||
+		     css_is_ancestor(&mem->css, &root_mem->css))) {
+			rcu_read_unlock();
+			if (!test_and_set_bit(STOCK_FLUSHING, &stock->flags))
+				schedule_work_on(cpu, &stock->work);
+		} else
+			rcu_read_unlock();
 	}
  	put_online_cpus();
-	atomic_dec(&memcg_drain_count);
-	/* We don't wait for flush_work */
 }
 
 /* This is a synchronous drain interface. */
 static void drain_all_stock_sync(void)
 {
 	/* called when force_empty is called */
-	atomic_inc(&memcg_drain_count);
 	schedule_on_each_cpu(drain_local_stock);
-	atomic_dec(&memcg_drain_count);
 }
 
 /*

