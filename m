Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1IZLu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:50:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37233 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab1IZLuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:50:55 -0400
Date: Mon, 26 Sep 2011 17:20:49 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110926115049.GA22604@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to test recently introduced cpu bandwidth control feature for
non-realtime tasks, we noticed "more than expected" idle time, which
reduced considerably when booted with nohz=off. This patch is an attempt
to fix that discrepancy so that we see little variance in idle time between
nohz=on and nohz=off.

Test setup:

Machine : 16-cpus (2 Quad-core w/ HT enabled)
Kernel  : Latest code (HEAD at 6e8d0472ea63969e2df77c7e84741495fedf7d9b) found 
	  at git://tesla.tglx.de/git/linux-2.6-tip

Cgroups :

5 in number (/L1/L2/C1 - /L1/L2/C5), each having {2, 2, 4, 8, 16} tasks
respectively. /L1 and /L2 were added to the hierarchy to mimic cgroup hierarchy 
created by libvirt and otherwise do not contain any tasks. Each cgroup has 
cpu.shares proportional to # of tasks in it. For ex: /L1/L2/C1's cpu.shares =
2 * 1024 = 2048, C3's cpu.shares = 4096 etc. Further, each task is placed in its
own (sub-)cgroup with default shares of 1024 and a capped usage of 50% CPU.
  
        /L1/L2/C1/C1_1/Task1  -> capped at 50% cpu usage
        /L1/L2/C1/C1_2/Task2  -> capped at 50% cpu usage
        /L1/L2/C2/C2_1/Task3  -> capped at 50% cpu usage
        /L1/L2/C2/C2_2/Task3  -> capped at 50% cpu usage
        /L1/L2/C3/C3_1/Task4  -> capped at 50% cpu usage
        /L1/L2/C3/C3_2/Task4  -> capped at 50% cpu usage
        /L1/L2/C3/C3_3/Task4  -> capped at 50% cpu usage
        /L1/L2/C3/C3_4/Task4  -> capped at 50% cpu usage
        ...
        /L1/L2/C5/C5_16/Task32 -> capped at 50% cpu usage

So we have 32 tasks, each capped at 50% CPU usage, run on a 16-CPU
system, which one may expect to consume all CPU resource leaving no idle
time. While that may be "insane" expectation, the goal is to minimize idle time
in this situation as much as possible.

I am using a slightly modified script provided at
https://lkml.org/lkml/2011/6/7/352 for generating this test scenario -
can make that available if required.

Idle time was sampled every second (using vmstat) over a window of 60 seconds
and was found as below:

Idle time 		Average	 Std-deviation	 Min	Max
============================================================

nohz=off		4%        0.5%           3%      5%
nohz=on	 		10% 	  2.4% 		 5%	 18%
nohz=on + patch		5.3%      1.3%		 3%      9%

The patch cuts down idle time significantly when kernel is booted 
with 'nohz=on' (which is good for saving power when idle).

Description of the patch
========================

Reviewing idle load balancer code and testing it with some
trace_printk(), I observed the following:

1. I had put a trace_printk() in nohz_idle_balance() as below:

	nohz_idle_balance()
	{

	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
		return;

	..

		trace_printk("Running rebalance for %d\n", balance_cpu);

		rebalance_domains(balance_cpu, CPU_IDLE);
	}

    I *never* got that printed during the test. Further investigation
    revealed that ilb_cpu was bailing out early because idle =
    CPU_NOT_IDLE i.e ilb_cpu was no longer idle_at_tick by the time it
    got around to handle the kick. As a result, no one was truly
    doing a load balance on behalf of sleeping idle cpus.


2. nohz.next_interval is supposed to reflect min(rq->next_balance)
   across all sleeping idle cpus. As new idle cpus go tickless, we 
   don't update nohz.next_balance to reflect the fact that the 
   idle cpu going tickless may have rq->next_balance earlier than
   nohz.next_balance. Putting some trace_printk() I noticed that 
   difference (between nohz.next_interval and its desired new value) 
   was between  30 - 1673 ticks (CONFIG_HZ=1000 in my case).

3. AFAICS CPUs desigated as first_pick_cpu or second_pick_cpu can be
   idle for sometime before going tickless. When that happens, they
   stop kicking ilb_cpu. More importantly other busy cpus also 
   don't kick ilb_cpu as they are neither first nor second pick_cpu.
   In this situation, ilb_cpu is not woken up in a timely manner to
   do idle load balance.

This patch is an attempt to solve above issues observed with idle load
balancer. 

- The patch causes a ilb_cpu (that was kicked) to kick another idle 
  cpu in case it was found to be !idle_at_tick (so that another idle cpu
  can do load balance on behalf of idle cpus). This fixes issue #1

- The patch introduces a 'nohz.next_balance_lock' spinlock which is used
  to update nohz.next_balance, so that it stays as min(rq->next_balance).
  This fixes issue #2. I don't like a global spinlock so much, but don't
  see easy way out. Besides, this lock is taken in context of idle cpu.

- It allows any busy cpu to kick ilb_cpu if it has greater than 2
  runnable tasks. This addresses issue #3

The patch is against latest tip code (HEAD at
6e8d0472ea63969e2df77c7e84741495fedf7d9b) found at
git://tesla.tglx.de/git/linux-2.6-tip

Another improvement that we may want to look at is to have second_pick_cpu
avoid kicking in case there is no power/performance benefit (i.e its not a
thread/core sibling of first_pick_cpu).

Comments/flames welcome!

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -8355,6 +8355,7 @@ void __init sched_init(void)
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
@@ -4302,6 +4302,7 @@ static struct {
 	cpumask_var_t idle_cpus_mask;
 	cpumask_var_t grp_idle_mask;
 	unsigned long next_balance;     /* in jiffy units */
+	spinlock_t next_balance_lock;   /* Serialize update to 'next_balance' */
 } nohz ____cacheline_aligned;
 
 int get_nohz_load_balancer(void)
@@ -4443,8 +4444,12 @@ static void nohz_balancer_kick(int cpu)
 
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
@@ -4459,6 +4464,18 @@ static void nohz_balancer_kick(int cpu)
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
@@ -4517,8 +4534,10 @@ void select_nohz_load_balancer(int stop_
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
@@ -4634,9 +4653,16 @@ static void nohz_idle_balance(int this_c
 	struct rq *rq;
 	int balance_cpu;
 
-	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
+	if (!this_rq->nohz_balance_kick)
 		return;
 
+	/* Wakeup another idle cpu to do idle load balance if we got busy */
+	if (idle != CPU_IDLE) {
+		nohz_balancer_kick(this_cpu);
+		this_rq->nohz_balance_kick = 0;
+		return;
+	}
+
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
 		if (balance_cpu == this_cpu)
 			continue;
@@ -4646,10 +4672,8 @@ static void nohz_idle_balance(int this_c
 		 * work being done for other cpus. Next load
 		 * balancing owner will pick it up.
 		 */
-		if (need_resched()) {
-			this_rq->nohz_balance_kick = 0;
+		if (need_resched())
 			break;
-		}
 
 		raw_spin_lock_irq(&this_rq->lock);
 		update_rq_clock(this_rq);
@@ -4663,7 +4687,7 @@ static void nohz_idle_balance(int this_c
 		if (time_after(this_rq->next_balance, rq->next_balance))
 			this_rq->next_balance = rq->next_balance;
 	}
-	nohz.next_balance = this_rq->next_balance;
+	set_nohz_next_balance(this_rq->next_balance);
 	this_rq->nohz_balance_kick = 0;
 }
 
@@ -4695,8 +4719,11 @@ static inline int nohz_kick_needed(struc
 	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
 
 	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
-	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
+	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu) {
+		if (rq->nr_running > 1)
+			return 1;
 		return 0;
+	}
 
 	ret = atomic_cmpxchg(&nohz.first_pick_cpu, nr_cpu_ids, cpu);
 	if (ret == nr_cpu_ids || ret == cpu) {
@@ -4752,7 +4779,7 @@ static inline void trigger_load_balance(
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
 }
