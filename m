Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0EQTC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:02:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:11713 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab0EQTC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="518662464"
Message-Id: <20100517184028.114595207@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:27:33 -0700
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
Subject: [patch 7/7] timers: use nearest busy cpu for migrating timers from an idle cpu
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=use_nearest_busy_cpu_for_migrating_timers_from_idle_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are migrating the unpinned timers from an idle to the cpu
doing idle load balancing (when all the cpus in the system are idle,
there is no idle load balacncing cpu and timers get added to the same idle cpu
where the request was made. So the current optimization works only on semi idle
system).

And In semi idle system, we no longer have periodic ticks on the idle cpu
doing the idle load balancing on behalf of all the cpu's. Using that cpu
will add more delays to the timers than intended (as that cpu's timer base
may not be uptodate wrt jiffies etc). This was causing mysterious slowdowns
during boot etc.

For now, in the semi idle case, use the nearest busy cpu for migrating timers from an
idle cpu.  This is good for power-savings anyway.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/sched.h |    2 +-
 kernel/hrtimer.c      |    8 ++------
 kernel/sched.c        |   13 +++++++++++++
 kernel/timer.c        |    8 ++------
 4 files changed, 18 insertions(+), 13 deletions(-)

Index: tip/kernel/hrtimer.c
===================================================================
--- tip.orig/kernel/hrtimer.c
+++ tip/kernel/hrtimer.c
@@ -144,12 +144,8 @@ struct hrtimer_clock_base *lock_hrtimer_
 static int hrtimer_get_target(int this_cpu, int pinned)
 {
 #ifdef CONFIG_NO_HZ
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu)) {
-		int preferred_cpu = get_nohz_load_balancer();
-
-		if (preferred_cpu < nr_cpu_ids)
-			return preferred_cpu;
-	}
+	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
+		return get_nohz_timer_target();
 #endif
 	return this_cpu;
 }
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -1201,6 +1201,19 @@ static void resched_cpu(int cpu)
 }
 
 #ifdef CONFIG_NO_HZ
+int get_nohz_timer_target(void)
+{
+	int cpu = smp_processor_id();
+	int i;
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd) {
+		for_each_cpu(i, sched_domain_span(sd))
+			if (!idle_cpu(i))
+				return i;
+	}
+	return cpu;
+}
 /*
  * When add_timer_on() enqueues a timer into the timer wheel of an
  * idle CPU then this timer might expire before the next timer event
Index: tip/kernel/timer.c
===================================================================
--- tip.orig/kernel/timer.c
+++ tip/kernel/timer.c
@@ -679,12 +679,8 @@ __mod_timer(struct timer_list *timer, un
 	cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
-		int preferred_cpu = get_nohz_load_balancer();
-
-		if (preferred_cpu < nr_cpu_ids)
-			cpu = preferred_cpu;
-	}
+	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
+		cpu = get_nohz_timer_target();
 #endif
 	new_base = per_cpu(tvec_bases, cpu);
 
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -273,7 +273,7 @@ extern void task_rq_unlock_wait(struct t
 extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
-extern int get_nohz_load_balancer(void);
+extern int get_nohz_timer_target(void);
 extern int nohz_ratelimit(int cpu);
 #else
 static inline void select_nohz_load_balancer(int stop_tick) { }


