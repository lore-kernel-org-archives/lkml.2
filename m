Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1JCTla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:41:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37490 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1JCTlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:41:24 -0400
Subject: Re: [patch 1/2] sched: use resched IPI to kick off the nohz idle
 balance
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Date: Mon, 03 Oct 2011 21:40:25 +0200
References: <20110929223242.837017656@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317670825.20367.39.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Something like so in fact,.. except for the MB bits..

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1404,6 +1404,18 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+static inline bool got_nohz_kick(void)
+{
+	return !!this_rq()->nohz_balance_kick;
+}
+
+#else /* CONFIG_NO_HZ */
+
+static inline bool got_nohz_kick(void)
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
+	if (llist_empty(&this_rq()->wake_list) && got_nohz_kick())
 		return;
 
 	/*
@@ -2734,7 +2746,14 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
-	sched_ttwu_pending();
+	if (list)
+		sched_ttwu_do_pending(list);
+
+	/*
+ 	 * Check if someone kicked us for doing the nohz idle load balance.
+ 	 */
+	if (unlikely(got_nohz_kick() && idle_cpu(smp_processor_id()) && !need_resched()))
+		raise_softirq_irqoff(SCHED_SOFTIRQ);
 	irq_exit();
 }
 
@@ -8288,7 +8307,6 @@ void __init sched_init(void)
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_balance_kick = 0;
-		init_sched_softirq_csd(&per_cpu(remote_sched_softirq_cb, i));
 #endif
 #endif
 		init_rq_hrtick(rq);
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -4269,22 +4269,6 @@ static int active_load_balance_cpu_stop(
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
@@ -4450,11 +4434,14 @@ static void nohz_balancer_kick(int cpu)
 	}
 
 	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		struct call_single_data *cp;
-
 		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
-		cp = &per_cpu(remote_sched_softirq_cb, cpu);
-		__smp_call_function_single(ilb_cpu, cp, 0);
+		/*
+		 * Use kick_process instead of resched_cpu.
+		 * This way we generate a sched IPI on the target cpu which
+		 * is idle. And the softirq performing nohz idle load balance
+		 * will be run before returning from the IPI.
+		 */
+		kick_process(idle_task(ilb_cpu));
 	}
 	return;
 }

