Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2HMPMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:12:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2HMPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:12:29 -0400
Date: Mon, 13 Aug 2012 08:12:10 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-3e339b5dae24a7065e196eb8d0145ab2f8cc2d2d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, namhyung@kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, namhyung@kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120716103948.456416747@linutronix.de>
References: <20120716103948.456416747@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] softirq: Use hotplug thread infrastructure
Git-Commit-ID: 3e339b5dae24a7065e196eb8d0145ab2f8cc2d2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 08:12:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e339b5dae24a7065e196eb8d0145ab2f8cc2d2d
Gitweb:     http://git.kernel.org/tip/3e339b5dae24a7065e196eb8d0145ab2f8cc2d2d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 16 Jul 2012 10:42:37 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 17:01:07 +0200

softirq: Use hotplug thread infrastructure

[ paulmck: Call rcu_note_context_switch() with interrupts enabled. ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20120716103948.456416747@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/softirq.c |  111 +++++++++++++----------------------------------------
 1 files changed, 27 insertions(+), 84 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b73e681..5c6a5bd 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/ftrace.h>
 #include <linux/smp.h>
+#include <linux/smpboot.h>
 #include <linux/tick.h>
 
 #define CREATE_TRACE_POINTS
@@ -742,49 +743,22 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
-static int run_ksoftirqd(void * __bind_cpu)
+static int ksoftirqd_should_run(unsigned int cpu)
 {
-	set_current_state(TASK_INTERRUPTIBLE);
-
-	while (!kthread_should_stop()) {
-		preempt_disable();
-		if (!local_softirq_pending()) {
-			schedule_preempt_disabled();
-		}
-
-		__set_current_state(TASK_RUNNING);
-
-		while (local_softirq_pending()) {
-			/* Preempt disable stops cpu going offline.
-			   If already offline, we'll be on wrong CPU:
-			   don't process */
-			if (cpu_is_offline((long)__bind_cpu))
-				goto wait_to_die;
-			local_irq_disable();
-			if (local_softirq_pending())
-				__do_softirq();
-			local_irq_enable();
-			sched_preempt_enable_no_resched();
-			cond_resched();
-			preempt_disable();
-			rcu_note_context_switch((long)__bind_cpu);
-		}
-		preempt_enable();
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	return local_softirq_pending();
+}
 
-wait_to_die:
-	preempt_enable();
-	/* Wait for kthread_stop */
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		set_current_state(TASK_INTERRUPTIBLE);
+static void run_ksoftirqd(unsigned int cpu)
+{
+	local_irq_disable();
+	if (local_softirq_pending()) {
+		__do_softirq();
+		rcu_note_context_switch(cpu);
+		local_irq_enable();
+		cond_resched();
+		return;
 	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	local_irq_enable();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -850,50 +824,14 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
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
-	case CPU_DEAD_FROZEN: {
-		static const struct sched_param param = {
-			.sched_priority = MAX_RT_PRIO-1
-		};
-
-		p = per_cpu(ksoftirqd, hotcpu);
-		per_cpu(ksoftirqd, hotcpu) = NULL;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-		kthread_stop(p);
-		takeover_tasklets(hotcpu);
+	case CPU_DEAD_FROZEN:
+		takeover_tasklets((unsigned long)hcpu);
 		break;
-	}
 #endif /* CONFIG_HOTPLUG_CPU */
- 	}
+	}
 	return NOTIFY_OK;
 }
 
@@ -901,14 +839,19 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+static struct smp_hotplug_thread softirq_threads = {
+	.store			= &ksoftirqd,
+	.thread_should_run	= ksoftirqd_should_run,
+	.thread_fn		= run_ksoftirqd,
+	.thread_comm		= "ksoftirqd/%u",
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
