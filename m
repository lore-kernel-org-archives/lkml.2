Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1FNF02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:26:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:60766 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1FNF01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:26:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,362,1304319600"; 
   d="scan'208";a="15911923"
Subject: rcu: performance regression
From: Shaohua Li <shaohua.li@intel.com>
To: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 13:26:25 +0800
Message-ID: <1308029185.15392.147.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a26ac2455ffcf3(rcu: move TREE_RCU from softirq to kthread)
introduced performance regression. In our AIM7 test, this commit caused
about 40% regression.
The commit runs rcu callbacks in a kthread instead of softirq. We
observed high rate of context switch which is caused by this. Out test
system has 64 CPUs and HZ is 1000, so we saw more than 64k context
switch per second which is caused by the rcu thread.
I also did trace and found when rcy thread is woken up, most time the
thread doesn't handle any callbacks actually, it just initializes new gp
or end one gp or similar.
>From my understanding, the purpose to make rcu runs in kthread is to
speed up rcu callbacks run (with help of rtmutex PI), not for end gp and
so on, which runs pretty fast actually and doesn't need boost.
To verify my findings, I had below debug patch applied. It still handles
rcu callbacks in kthread if there is any pending callbacks, but other
things are still running in softirq. this completely solved our
regression. I thought this can still boost callbacks run. but I'm not
expert in the area, so please help.

Thanks,
Shaohua
---
 Documentation/filesystems/proc.txt  |    1 +
 include/linux/interrupt.h           |    1 +
 include/trace/events/irq.h          |    3 ++-
 kernel/rcutree.c                    |   23 +++++++++++++++++++----
 kernel/rcutree.h                    |    1 +
 kernel/rcutree_plugin.h             |    9 +++++++++
 kernel/softirq.c                    |    2 +-
 tools/perf/util/trace-event-parse.c |    1 +
 8 files changed, 35 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -414,6 +414,7 @@ enum
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
+	RCU_SOFTIRQ,    /* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
 };
Index: linux-2.6/include/trace/events/irq.h
===================================================================
--- linux-2.6.orig/include/trace/events/irq.h
+++ linux-2.6/include/trace/events/irq.h
@@ -20,7 +20,8 @@ struct softirq_action;
 			 softirq_name(BLOCK_IOPOLL),	\
 			 softirq_name(TASKLET),		\
 			 softirq_name(SCHED),		\
-			 softirq_name(HRTIMER))
+			 softirq_name(HRTIMER),		\
+			 softirq_name(RCU))
 
 /**
  * irq_handler_entry - called immediately before the irq action handler
Index: linux-2.6/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/proc.txt
+++ linux-2.6/Documentation/filesystems/proc.txt
@@ -843,6 +843,7 @@ Provides counts of softirq handlers serv
  TASKLET:          0          0          0        290
    SCHED:      27035      26983      26971      26746
  HRTIMER:          0          0          0          0
+     RCU:       1678       1769       2178       2250
 
 
 1.3 IDE devices in /proc/ide
Index: linux-2.6/kernel/rcutree.c
===================================================================
--- linux-2.6.orig/kernel/rcutree.c
+++ linux-2.6/kernel/rcutree.c
@@ -1407,6 +1407,7 @@ static void force_quiescent_state(struct
 
 #endif /* #else #ifdef CONFIG_SMP */
 
+static void __invoke_rcu_cpu_kthread(void);
 /*
  * This does the RCU processing work from softirq context for the
  * specified rcu_state and rcu_data structures.  This may be called
@@ -1442,13 +1443,21 @@ __rcu_process_callbacks(struct rcu_state
 	}
 
 	/* If there are callbacks ready, invoke them. */
-	rcu_do_batch(rsp, rdp);
+	if (cpu_has_callbacks_ready_to_invoke(rdp))
+		__invoke_rcu_cpu_kthread();
+}
+
+static void rcu_kthread_do_work(void)
+{
+	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
+	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	rcu_preempt_do_callbacks();
 }
 
 /*
  * Do softirq processing for the current CPU.
  */
-static void rcu_process_callbacks(void)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
@@ -1465,7 +1474,7 @@ static void rcu_process_callbacks(void)
  * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
  * cannot disappear out from under us.
  */
-static void invoke_rcu_cpu_kthread(void)
+static void __invoke_rcu_cpu_kthread(void)
 {
 	unsigned long flags;
 
@@ -1479,6 +1488,11 @@ static void invoke_rcu_cpu_kthread(void)
 	local_irq_restore(flags);
 }
 
+static void invoke_rcu_cpu_kthread(void)
+{
+	raise_softirq(RCU_SOFTIRQ);
+}
+
 /*
  * Wake up the specified per-rcu_node-structure kthread.
  * Because the per-rcu_node kthreads are immortal, we don't need
@@ -1613,7 +1627,7 @@ static int rcu_cpu_kthread(void *arg)
 		*workp = 0;
 		local_irq_restore(flags);
 		if (work)
-			rcu_process_callbacks();
+			rcu_kthread_do_work();
 		local_bh_enable();
 		if (*workp != 0)
 			spincnt++;
@@ -2410,6 +2424,7 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
+	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -58,7 +58,7 @@ DEFINE_PER_CPU(struct task_struct *, kso
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
-	"TASKLET", "SCHED", "HRTIMER"
+	"TASKLET", "SCHED", "HRTIMER", "RCU"
 };
 
 /*
Index: linux-2.6/tools/perf/util/trace-event-parse.c
===================================================================
--- linux-2.6.orig/tools/perf/util/trace-event-parse.c
+++ linux-2.6/tools/perf/util/trace-event-parse.c
@@ -2187,6 +2187,7 @@ static const struct flag flags[] = {
 	{ "TASKLET_SOFTIRQ", 6 },
 	{ "SCHED_SOFTIRQ", 7 },
 	{ "HRTIMER_SOFTIRQ", 8 },
+	{ "RCU_SOFTIRQ", 9 },
 
 	{ "HRTIMER_NORESTART", 0 },
 	{ "HRTIMER_RESTART", 1 },
Index: linux-2.6/kernel/rcutree_plugin.h
===================================================================
--- linux-2.6.orig/kernel/rcutree_plugin.h
+++ linux-2.6/kernel/rcutree_plugin.h
@@ -602,6 +602,11 @@ static void rcu_preempt_process_callback
 				&__get_cpu_var(rcu_preempt_data));
 }
 
+static void rcu_preempt_do_callbacks(void)
+{
+	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
+}
+
 /*
  * Queue a preemptible-RCU callback for invocation after a grace period.
  */
@@ -997,6 +1002,10 @@ static void rcu_preempt_process_callback
 {
 }
 
+static void rcu_preempt_do_callbacks(void)
+{
+}
+
 /*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
  * But because preemptible RCU does not exist, map to rcu-sched.
Index: linux-2.6/kernel/rcutree.h
===================================================================
--- linux-2.6.orig/kernel/rcutree.h
+++ linux-2.6/kernel/rcutree.h
@@ -439,6 +439,7 @@ static void rcu_preempt_offline_cpu(int 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
+static void rcu_preempt_do_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
 static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);


