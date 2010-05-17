Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0EQTDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:03:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:11713 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab0EQTC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="518662466"
Message-Id: <20100517184028.032341083@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:27:32 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 6/7] sched: change nohz.load_balancer to be nr_cpu_ids based
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=sched_change_nohz_load_balancer_to_nr_cpu_ids.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venki@google.com>
Subject: sched: change nohz.load_balancer to be nr_cpu_ids based

nohz.load_balancer was using -1 when it is not set to any cpu. Change it
to nr_cpu_ids, making it similar to other such variables in this file.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/hrtimer.c    |    2 +-
 kernel/sched.c      |    1 +
 kernel/sched_fair.c |   26 ++++++++++++++++----------
 kernel/timer.c      |    2 +-
 4 files changed, 19 insertions(+), 12 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -3101,13 +3101,15 @@ static struct {
 	cpumask_var_t idle_cpus_mask;
 	cpumask_var_t grp_idle_mask;
 	unsigned long next_balance;     /* in jiffy units */
-} nohz ____cacheline_aligned = {
-	.load_balancer = ATOMIC_INIT(-1),
-};
+} nohz ____cacheline_aligned;
 
 int get_nohz_load_balancer(void)
 {
-	return atomic_read(&nohz.load_balancer);
+	int load_balancer = atomic_read(&nohz.load_balancer);
+	if (load_balancer >= nr_cpu_ids)
+		return nr_cpu_ids;
+
+	return load_balancer;
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -3237,7 +3239,8 @@ static void nohz_balancer_kick(int cpu)
 	nohz.next_balance++;
 
 	ilb_cpu = get_nohz_load_balancer();
-	if (ilb_cpu < 0) {
+
+	if (ilb_cpu >= nr_cpu_ids) {
 		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
 		if (ilb_cpu >= nr_cpu_ids)
 			return;
@@ -3279,7 +3282,8 @@ void select_nohz_load_balancer(int stop_
 			 * If we are going offline and still the leader,
 			 * give up!
 			 */
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
+					   nr_cpu_ids) != cpu)
 				BUG();
 
 			return;
@@ -3292,11 +3296,12 @@ void select_nohz_load_balancer(int stop_
 		if (atomic_read(&nohz.second_pick_cpu) == cpu)
 			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
 
-		if (atomic_read(&nohz.load_balancer) == -1) {
+		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
 			int new_ilb;
 
 			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) != -1)
+			if (atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids,
+					   cpu) != nr_cpu_ids)
 				return;
 
 			/*
@@ -3305,7 +3310,7 @@ void select_nohz_load_balancer(int stop_
 			 */
 			new_ilb = find_new_ilb(cpu);
 			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
-				atomic_set(&nohz.load_balancer, -1);
+				atomic_set(&nohz.load_balancer, nr_cpu_ids);
 				resched_cpu(new_ilb);
 				return;
 			}
@@ -3318,7 +3323,8 @@ void select_nohz_load_balancer(int stop_
 		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
 
 		if (atomic_read(&nohz.load_balancer) == cpu)
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
+					   nr_cpu_ids) != cpu)
 				BUG();
 	}
 	return;
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -7656,6 +7656,7 @@ void __init sched_init(void)
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
+	atomic_set(&nohz.load_balancer, nr_cpu_ids);
 	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
 	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
 #endif
Index: tip/kernel/hrtimer.c
===================================================================
--- tip.orig/kernel/hrtimer.c
+++ tip/kernel/hrtimer.c
@@ -147,7 +147,7 @@ static int hrtimer_get_target(int this_c
 	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu)) {
 		int preferred_cpu = get_nohz_load_balancer();
 
-		if (preferred_cpu >= 0)
+		if (preferred_cpu < nr_cpu_ids)
 			return preferred_cpu;
 	}
 #endif
Index: tip/kernel/timer.c
===================================================================
--- tip.orig/kernel/timer.c
+++ tip/kernel/timer.c
@@ -682,7 +682,7 @@ __mod_timer(struct timer_list *timer, un
 	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
 		int preferred_cpu = get_nohz_load_balancer();
 
-		if (preferred_cpu >= 0)
+		if (preferred_cpu < nr_cpu_ids)
 			cpu = preferred_cpu;
 	}
 #endif


