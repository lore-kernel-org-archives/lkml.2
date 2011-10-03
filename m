Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab1JCWLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:11:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:23847 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab1JCWLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:11:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="59514251"
Message-Id: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 03 Oct 2011 15:09:00 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org
Subject: [patch v2 1/2] sched: Use resched IPI to kick off the nohz idle balance
Content-Disposition: inline; filename=sched-use_resched_ipi_to_kick_off_the_nohz_idle.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current use of smp call function to kick the nohz idle balance can deadlock
in this scenario.

1. cpu-A did a generic_exec_single() to cpu-B and after queuing its call single
data (csd) to the call single queue, cpu-A took a timer interrupt.  Actual IPI
to cpu-B to process the call single queue is not yet sent.

2. As part of the timer interrupt handler, cpu-A decided to kick cpu-B
for the idle load balancing (sets cpu-B's rq->nohz_balance_kick to 1)
and __smp_call_function_single() with nowait will queue the csd to the
cpu-B's queue. But the generic_exec_single() won't send an IPI to cpu-B
as the call single queue was not empty.

3. cpu-A is busy with lot of interrupts

4. Meanwhile cpu-B is entering and exiting idle and noticed that it has
it's rq->nohz_balance_kick set to '1'. So it will go ahead and do the
idle load balancer and clear its rq->nohz_balance_kick.

5. At this point, csd queued as part of the step-2 above is still locked
and waiting to be serviced on cpu-B.

6. cpu-A is still busy with interrupt load and now it got another timer
interrupt and as part of it decided to kick cpu-B for another idle load
balancing (as it finds cpu-B's rq->nohz_balance_kick cleared in step-4
above) and does __smp_call_function_single() with the same csd that is
still locked.

7. And we get a deadlock waiting for the csd_lock() in the
__smp_call_function_single().

Main issue here is that cpu-B can service the idle load balancer kick
request from cpu-A even with out receiving the IPI and this lead to
doing multiple __smp_call_function_single() on the same csd leading to
deadlock.

To kick a cpu, scheduler already has the reschedule vector reserved. Use
that mechanism (kick_process()) instead of using the generic smp call function
mechanism to kick off the nohz idle load balancing and avoid the deadlock.

   [ This issue is present from 2.6.35+ kernels, but marking it -stable
     only from v3.0+ as the proposed fix depends on the scheduler_ipi()
     that is introduced recently. ]

Reported-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org # v3.0+
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   21 +++++++++++++++++++--
 kernel/sched_fair.c |   29 +++++++++--------------------
 2 files changed, 28 insertions(+), 22 deletions(-)
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -1404,6 +1404,18 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+static inline bool got_nohz_idle_kick(void)
+{
+	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
+}
+
+#else /* CONFIG_NO_HZ */
+
+static inline bool got_nohz_idle_kick(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
@@ -2717,7 +2729,7 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
-	if (llist_empty(&this_rq()->wake_list))
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
 		return;
 
 	/*
@@ -2735,6 +2747,12 @@ void scheduler_ipi(void)
 	 */
 	irq_enter();
 	sched_ttwu_pending();
+
+	/*
+	 * Check if someone kicked us for doing the nohz idle load balance.
+	 */
+	if (unlikely(got_nohz_idle_kick() && !need_resched()))
+		raise_softirq_irqoff(SCHED_SOFTIRQ);
 	irq_exit();
 }
 
@@ -8280,7 +8298,6 @@ void __init sched_init(void)
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_balance_kick = 0;
-		init_sched_softirq_csd(&per_cpu(remote_sched_softirq_cb, i));
 #endif
 #endif
 		init_rq_hrtick(rq);
Index: linux-2.6-tip/kernel/sched_fair.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_fair.c
+++ linux-2.6-tip/kernel/sched_fair.c
@@ -4269,22 +4269,6 @@ out_unlock:
 }
 
 #ifdef CONFIG_NO_HZ
-
-static DEFINE_PER_CPU(struct call_single_data, remote_sched_softirq_cb);
-
-static void trigger_sched_softirq(void *data)
-{
-	raise_softirq_irqoff(SCHED_SOFTIRQ);
-}
-
-static inline void init_sched_softirq_csd(struct call_single_data *csd)
-{
-	csd->func = trigger_sched_softirq;
-	csd->info = NULL;
-	csd->flags = 0;
-	csd->priv = 0;
-}
-
 /*
  * idle load balancing details
  * - One of the idle CPUs nominates itself as idle load_balancer, while
@@ -4450,11 +4434,16 @@ static void nohz_balancer_kick(int cpu)
 	}
 
 	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		struct call_single_data *cp;
-
 		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
-		cp = &per_cpu(remote_sched_softirq_cb, cpu);
-		__smp_call_function_single(ilb_cpu, cp, 0);
+
+		smp_mb();
+		/*
+		 * Use smp_send_reschedule() instead of resched_cpu().
+		 * This way we generate a sched IPI on the target cpu which
+		 * is idle. And the softirq performing nohz idle load balance
+		 * will be run before returning from the IPI.
+		 */
+		smp_send_reschedule(ilb_cpu);
 	}
 	return;
 }


