Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1I2COG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:14:06 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42552 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab1I2COE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:14:04 -0400
Date: Thu, 29 Sep 2011 07:43:43 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venki Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110929021343.GA12029@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
 <1317167376.11592.53.camel@sbsiddha-desk.sc.intel.com>
 <20110928041501.GH4357@linux.vnet.ibm.com>
 <1317257264.11592.76.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317257264.11592.76.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11092902-8974-0000-0000-00000081703A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2011-09-28 17:47:43]:

> Anyways, this appended patch is just for your quick experiment. I will
> think a bit more tomorrow morning before sending the patch with complete
> changelog. Thanks.


Ran my usual test to check idle time and here are the results:


Idle time ->		Avg.	Std.Dev	   Min      Max

Without your patch	8.9%     1.9	   5%	    14%
With your patch		3.5%     1.2	   2%	     7%
With my addon patch	2.8%	 0.5%	   2%	     4%

So your patch does improve things, but there is scope to improve it
further with an addon patch like below. I will experiment with some more
changes (like a sorted list of idle_cpu rq->next_balance) and send my v2
to apply on top of your patch later.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -1404,6 +1404,12 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+static void reset_first_second_pick_cpu(int cpu);
+
+#else	/* CONFIG_NO_HZ */
+
+static inline void reset_first_second_pick_cpu(int cpu) { }
+
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
@@ -8359,6 +8365,7 @@ void __init sched_init(void)
 	atomic_set(&nohz.load_balancer, nr_cpu_ids);
 	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
 	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
+	spin_lock_init(&nohz.next_balance_lock);
 #endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -4286,6 +4286,7 @@ static struct {
 	cpumask_var_t idle_cpus_mask;
 	cpumask_var_t grp_idle_mask;
 	unsigned long next_balance;     /* in jiffy units */
+	spinlock_t next_balance_lock;   /* Serialize update to 'next_balance' */
 } nohz ____cacheline_aligned;
 
 int get_nohz_load_balancer(void)
@@ -4427,8 +4428,12 @@ static void nohz_balancer_kick(int cpu)
 
 	ilb_cpu = get_nohz_load_balancer();
 
-	if (ilb_cpu >= nr_cpu_ids) {
-		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
+	/*
+	 * ilb_cpu itself can be attempting to kick another idle cpu. Pick
+	 * another idle cpu in that case.
+	 */
+	if (ilb_cpu >= nr_cpu_ids || ilb_cpu == cpu) {
+		ilb_cpu = cpumask_any_but(nohz.idle_cpus_mask, cpu);
 		if (ilb_cpu >= nr_cpu_ids)
 			return;
 	}
@@ -4440,6 +4445,18 @@ static void nohz_balancer_kick(int cpu)
 	return;
 }
 
+/* Update nohz.next_balance with a new minimum value */
+static inline void set_nohz_next_balance(unsigned long next_balance)
+{
+	if (time_after(next_balance, nohz.next_balance))
+		return;
+
+	spin_lock(&nohz.next_balance_lock);
+	if (time_before(next_balance, nohz.next_balance))
+		nohz.next_balance = next_balance;
+	spin_unlock(&nohz.next_balance_lock);
+}
+
 /*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
@@ -4475,11 +4492,6 @@ void select_nohz_load_balancer(int stop_
 
 		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
 
-		if (atomic_read(&nohz.first_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
-		if (atomic_read(&nohz.second_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
-
 		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
 			int new_ilb;
 
@@ -4498,8 +4510,10 @@ void select_nohz_load_balancer(int stop_
 				resched_cpu(new_ilb);
 				return;
 			}
+			set_nohz_next_balance(cpu_rq(cpu)->next_balance);
 			return;
 		}
+		set_nohz_next_balance(cpu_rq(cpu)->next_balance);
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
 			return;
@@ -4615,9 +4629,16 @@ static void nohz_idle_balance(int this_c
 	struct rq *rq;
 	int balance_cpu;
 
-	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
+	if (!this_rq->nohz_balance_kick)
 		return;
 
+	/* Wakeup another idle cpu to do idle load balance if we got busy */
+	if (!idle_cpu(this_cpu)) {
+		nohz_balancer_kick(this_cpu);
+		this_rq->nohz_balance_kick = 0;
+		return;
+	}
+
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
 		if (balance_cpu == this_cpu)
 			continue;
@@ -4628,7 +4649,7 @@ static void nohz_idle_balance(int this_c
 		 * balancing owner will pick it up.
 		 */
 		if (need_resched()) {
-			this_rq->nohz_balance_kick = 0;
+			nohz_balancer_kick(this_cpu);
 			break;
 		}
 
@@ -4643,7 +4664,7 @@ static void nohz_idle_balance(int this_c
 		if (time_after(this_rq->next_balance, rq->next_balance))
 			this_rq->next_balance = rq->next_balance;
 	}
-	nohz.next_balance = this_rq->next_balance;
+	set_nohz_next_balance(this_rq->next_balance);
 	this_rq->nohz_balance_kick = 0;
 }
 
@@ -4692,9 +4713,24 @@ static inline int nohz_kick_needed(struc
 	}
 	return 0;
 }
-#else
+
+/*
+ * Reset first_pick_cpu or second_pick_cpu identifier in case
+ * corresponding cpu is going idle.
+ */
+static void reset_first_second_pick_cpu(int cpu)
+{
+	if (atomic_read(&nohz.first_pick_cpu) == cpu)
+		atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
+	if (atomic_read(&nohz.second_pick_cpu) == cpu)
+		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
+}
+
+#else	/* CONFIG_NO_HZ */
+
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
-#endif
+
+#endif	/* CONFIG_NO_HZ */
 
 /*
  * run_rebalance_domains is triggered when needed from the scheduler tick.
@@ -4732,7 +4768,7 @@ static inline void trigger_load_balance(
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
 }
Index: current/kernel/sched_idletask.c
===================================================================
--- current.orig/kernel/sched_idletask.c
+++ current/kernel/sched_idletask.c
@@ -24,6 +24,8 @@ static struct task_struct *pick_next_tas
 {
 	schedstat_inc(rq, sched_goidle);
 	calc_load_account_idle(rq);
+	reset_first_second_pick_cpu(cpu_of(rq));
+
 	return rq->idle;
 }
 





