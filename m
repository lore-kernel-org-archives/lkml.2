Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab2FOON1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:13:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:41570 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab2FOONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:13:25 -0400
Message-Id: <20120615140714.592954302@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jun 2012 14:13:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: [RFC patch V2 4/7] softirq: Use hotplug thread infrastructure
References: <20120615140217.933711648@linutronix.de>
Content-Disposition: inline; filename=softirq-use-smboot-threads.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/softirq.c |   84 +++++++++++--------------------------------------------
 1 file changed, 18 insertions(+), 66 deletions(-)

Index: tip/kernel/softirq.c
===================================================================
--- tip.orig/kernel/softirq.c
+++ tip/kernel/softirq.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/ftrace.h>
 #include <linux/smp.h>
+#include <linux/smpboot.h>
 #include <linux/tick.h>
 
 #define CREATE_TRACE_POINTS
@@ -733,24 +734,17 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
-static int run_ksoftirqd(void * __bind_cpu)
+static int run_ksoftirqd(void *td)
 {
-	set_current_state(TASK_INTERRUPTIBLE);
-
-	while (!kthread_should_stop()) {
+	while (!smpboot_thread_check_parking(td)) {
+		set_current_state(TASK_INTERRUPTIBLE);
 		preempt_disable();
-		if (!local_softirq_pending()) {
+		if (!local_softirq_pending())
 			schedule_preempt_disabled();
-		}
 
 		__set_current_state(TASK_RUNNING);
 
 		while (local_softirq_pending()) {
-			/* Preempt disable stops cpu going offline.
-			   If already offline, we'll be on wrong CPU:
-			   don't process */
-			if (cpu_is_offline((long)__bind_cpu))
-				goto wait_to_die;
 			local_irq_disable();
 			if (local_softirq_pending())
 				__do_softirq();
@@ -758,23 +752,10 @@ static int run_ksoftirqd(void * __bind_c
 			sched_preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
-			rcu_note_context_switch((long)__bind_cpu);
+			rcu_note_context_switch(smp_processor_id());
 		}
 		preempt_enable();
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
-
-wait_to_die:
-	preempt_enable();
-	/* Wait for kthread_stop */
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	__set_current_state(TASK_RUNNING);
 	return 0;
 }
 
@@ -841,50 +822,17 @@ static int __cpuinit cpu_callback(struct
 				  unsigned long action,
 				  void *hcpu)
 {
-	int hotcpu = (unsigned long)hcpu;
-	struct task_struct *p;
-
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create_on_node(run_ksoftirqd,
-					   hcpu,
-					   cpu_to_node(hotcpu),
-					   "ksoftirqd/%d", hotcpu);
-		if (IS_ERR(p)) {
-			printk("ksoftirqd for %i failed\n", hotcpu);
-			return notifier_from_errno(PTR_ERR(p));
-		}
-		kthread_bind(p, hotcpu);
-  		per_cpu(ksoftirqd, hotcpu) = p;
- 		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		wake_up_process(per_cpu(ksoftirqd, hotcpu));
-		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!per_cpu(ksoftirqd, hotcpu))
-			break;
-		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(ksoftirqd, hotcpu),
-			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
-		static const struct sched_param param = {
-			.sched_priority = MAX_RT_PRIO-1
-		};
-
-		p = per_cpu(ksoftirqd, hotcpu);
-		per_cpu(ksoftirqd, hotcpu) = NULL;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-		kthread_stop(p);
+		int hotcpu = (unsigned long)hcpu;
+
 		takeover_tasklets(hotcpu);
 		break;
 	}
 #endif /* CONFIG_HOTPLUG_CPU */
- 	}
+	}
 	return NOTIFY_OK;
 }
 
@@ -892,14 +840,18 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
+static struct smp_hotplug_thread softirq_threads = {
+	.store		= &ksoftirqd,
+	.thread_fn	= run_ksoftirqd,
+	.thread_comm	= "ksoftirqd/%u",
+};
+
 static __init int spawn_ksoftirqd(void)
 {
-	void *cpu = (void *)(long)smp_processor_id();
-	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-
-	BUG_ON(err != NOTIFY_OK);
-	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
+
+	BUG_ON(smpboot_register_percpu_thread(&softirq_threads));
+
 	return 0;
 }
 early_initcall(spawn_ksoftirqd);


