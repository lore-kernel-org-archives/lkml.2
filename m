Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2LUQG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:06:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59369 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2LUQGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:06:20 -0500
Message-ID: <1356105970.4547.55.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.6.11-rt24 (apocalypse release)c
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Clark Williams <williams@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 21 Dec 2012 17:06:10 +0100
In-Reply-To: <alpine.LFD.2.02.1212211636460.3148@ionos>
References: <alpine.LFD.2.02.1212211413200.3148@ionos>
	 <20121221092651.55b44bfb@redhat.com>
	 <alpine.LFD.2.02.1212211636460.3148@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:dY2jne3e5nQVmjVIIuBLOBOP9Jm3k/nDGWcBLj5Rq+W
 T8RBs84BMsCADC+meOC0jhSU+dMNHVgPZ3eXAC9ndUF8LQeWoo
 gjiQsG9vdVNMxq0Ea8Oacvt1Y7J8kzSJ9mZiHrddUSkciFYQW8
 vnVhSyy1TPuCMhCLV0m3mMYCEQ/z2S7TFN5R7xGFNaTvMPU18Z
 lqYK14hNvXoMfRXo/aca56OL4agMuZm+p4cYovkM3FPAV7Zkvc
 IKEx6DjK8f9KDyTsEJf2pmHSImqjaUXLXMblKE5Eu7gWIzqjw1
 Sf2kI0tNmPsvbWP3AGQBv0KIU5QThNS9eKyfcsOH/P1zHiGkX2
 YE5zwX2cNt144/EwBjmvCzd1xVlQtIRJSlsjlJkZwaKfYpAfi9
 VzXlhovptnpqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 16:39 +0100, Thomas Gleixner wrote: 
> On Fri, 21 Dec 2012, Clark Williams wrote:
> > I had to add this to get -rt24 to compile:
> > +#include <linux/delay.h>
> 
> Carp. I should have run it through the full tests again after adding
> that last minute fix yesterday night. But it was sooo obvious and of
> course compiled with my config which magically pulls in that header.
> 
> I silently uploaded -rt25

I was just gonna report that, but needn't bother.  I was also gonna
attach an xmas patchlet for those who need/want softirq threads.  I can
still do that I suppose...

Your changes made this a lot less fugly.  The net threads are kinda out
of work with the new scheme, but some folks may find it's still nice to
be able to run some things SCHED_OTHER, or eq hrtimer at max.

Ho Ho.. Hum, merry apocalypse.

-Mike

sched,rt: resurrect softirq threads for RT_FULL

Signed-off-by: Mike Galbraith <bitbucket@.online.de>
---
 include/linux/interrupt.h |    9 +--
 include/linux/sched.h     |    6 ++
 kernel/sched/core.c       |    4 -
 kernel/softirq.c          |  105 +++++++++++++++++++++++++++++++---------------
 4 files changed, 84 insertions(+), 40 deletions(-)

Index: linux-stable/include/linux/interrupt.h
===================================================================
--- linux-stable.orig/include/linux/interrupt.h
+++ linux-stable/include/linux/interrupt.h
@@ -454,8 +454,10 @@ struct softirq_action
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 static inline void thread_do_softirq(void) { do_softirq(); }
+#define NR_SOFTIRQ_THREADS 1
 #else
 extern void thread_do_softirq(void);
+#define NR_SOFTIRQ_THREADS NR_SOFTIRQS
 #endif
 
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
@@ -476,12 +478,7 @@ extern void softirq_check_pending_idle(v
  */
 DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
 
-DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
-
-static inline struct task_struct *this_cpu_ksoftirqd(void)
-{
-	return this_cpu_read(ksoftirqd);
-}
+DECLARE_PER_CPU(struct task_struct * [NR_SOFTIRQ_THREADS], ksoftirqd);
 
 /* Try to send a softirq to a remote cpu.  If this cannot be done, the
  * work will be queued to the local cpu.
Index: linux-stable/include/linux/sched.h
===================================================================
--- linux-stable.orig/include/linux/sched.h
+++ linux-stable/include/linux/sched.h
@@ -1331,6 +1331,7 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+	unsigned sched_is_softirqd:1;
 
 	pid_t pid;
 	pid_t tgid;
@@ -1683,6 +1684,11 @@ static inline struct pid *task_tgid(stru
 	return task->group_leader->pids[PIDTYPE_PID].pid;
 }
 
+static inline bool task_is_softirqd(struct task_struct *task)
+{
+	return task->sched_is_softirqd;
+}
+
 /*
  * Without tasklist or rcu lock it is not safe to dereference
  * the result of task_pgrp/task_session even if task == current,
Index: linux-stable/kernel/sched/core.c
===================================================================
--- linux-stable.orig/kernel/sched/core.c
+++ linux-stable/kernel/sched/core.c
@@ -887,7 +887,7 @@ void account_system_vtime(struct task_st
 	 */
 	if (hardirq_count())
 		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
+	else if (in_serving_softirq() && !task_is_softirqd(curr))
 		__this_cpu_add(cpu_softirq_time, delta);
 
 	irq_time_write_end();
@@ -3122,7 +3122,7 @@ static void irqtime_account_process_tick
 		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
 	} else if (irqtime_account_si_update()) {
 		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
-	} else if (this_cpu_ksoftirqd() == p) {
+	} else if (task_is_softirqd(p)) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
Index: linux-stable/kernel/softirq.c
===================================================================
--- linux-stable.orig/kernel/softirq.c
+++ linux-stable/kernel/softirq.c
@@ -56,13 +56,31 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct task_struct * [NR_SOFTIRQ_THREADS], ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
 	"TASKLET", "SCHED", "HRTIMER", "RCU"
 };
 
+static const char *softirq_to_thread_name [] =
+{
+#ifdef CONFIG_PREEMPT_RT_FULL
+	[HI_SOFTIRQ]		= "sirq-high",
+	[TIMER_SOFTIRQ]		= "sirq-timer",
+	[NET_TX_SOFTIRQ]	= "sirq-net-tx",
+	[NET_RX_SOFTIRQ]	= "sirq-net-rx",
+	[BLOCK_SOFTIRQ]		= "sirq-blk",
+	[BLOCK_IOPOLL_SOFTIRQ]	= "sirq-blk-pol",
+	[TASKLET_SOFTIRQ]	= "sirq-tasklet",
+	[SCHED_SOFTIRQ]		= "sirq-sched",
+	[HRTIMER_SOFTIRQ]	= "sirq-hrtimer",
+	[RCU_SOFTIRQ]		= "sirq-rcu",
+#else
+	[HI_SOFTIRQ]		= "ksoftirqd",
+#endif
+};
+
 #ifdef CONFIG_NO_HZ
 # ifdef CONFIG_PREEMPT_RT_FULL
 
@@ -159,10 +177,10 @@ static inline void softirq_clr_runner(un
  * to the pending events, so lets the scheduler to balance
  * the softirq load for us.
  */
-static void wakeup_softirqd(void)
+static void wakeup_softirqd(int nr)
 {
 	/* Interrupts are disabled: no need to stop preemption */
-	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
+	struct task_struct *tsk =  __this_cpu_read(ksoftirqd[nr]);
 
 	if (tsk && tsk->state != TASK_RUNNING)
 		wake_up_process(tsk);
@@ -362,7 +380,7 @@ restart:
 		goto restart;
 
 	if (pending)
-		wakeup_softirqd();
+		wakeup_softirqd(0);
 
 	lockdep_softirq_exit();
 
@@ -430,7 +448,7 @@ void raise_softirq_irqoff(unsigned int n
 	 * schedule the softirq soon.
 	 */
 	if (!in_interrupt())
-		wakeup_softirqd();
+		wakeup_softirqd(0);
 }
 
 void __raise_softirq_irqoff(unsigned int nr)
@@ -626,15 +644,15 @@ static void do_raise_softirq_irqoff(unsi
 	 */
 	if (!in_irq() && current->softirq_nestcnt)
 		current->softirqs_raised |= (1U << nr);
-	else if (__this_cpu_read(ksoftirqd))
-		__this_cpu_read(ksoftirqd)->softirqs_raised |= (1U << nr);
+	else if (__this_cpu_read(ksoftirqd[nr]))
+		__this_cpu_read(ksoftirqd[nr])->softirqs_raised |= (1U << nr);
 }
 
 void __raise_softirq_irqoff(unsigned int nr)
 {
 	do_raise_softirq_irqoff(nr);
 	if (!in_irq() && !current->softirq_nestcnt)
-		wakeup_softirqd();
+		wakeup_softirqd(nr);
 }
 
 /*
@@ -661,7 +679,7 @@ void raise_softirq_irqoff(unsigned int n
 	 * raise a WARN() if the condition is met.
 	 */
 	if (!current->softirq_nestcnt)
-		wakeup_softirqd();
+		wakeup_softirqd(nr);
 }
 
 static inline int ksoftirqd_softirq_pending(void)
@@ -724,16 +742,24 @@ static inline void invoke_softirq(void)
 	} else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
-		wakeup_softirqd();
+		wakeup_softirqd(0);
 		__local_bh_enable(SOFTIRQ_OFFSET);
 	}
 #else /* PREEMPT_RT_FULL */
+	struct task_struct *tsk;
 	unsigned long flags;
+	u32 pending, nr;
 
 	local_irq_save(flags);
-	if (__this_cpu_read(ksoftirqd) &&
-	    __this_cpu_read(ksoftirqd)->softirqs_raised)
-		wakeup_softirqd();
+	pending = local_softirq_pending();
+
+	while (pending) {
+		nr = __ffs(pending);
+		tsk = __this_cpu_read(ksoftirqd[nr]);
+		if (tsk && tsk->softirqs_raised)
+			wakeup_softirqd(nr);
+		pending &= ~(1U << nr);
+	}
 	local_irq_restore(flags);
 #endif
 }
@@ -1213,6 +1239,7 @@ EXPORT_SYMBOL(tasklet_unlock_wait);
 static int run_ksoftirqd(void * __bind_cpu)
 {
 	ksoftirqd_set_sched_params();
+	current->sched_is_softirqd = 1;
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
@@ -1313,41 +1340,55 @@ static int __cpuinit cpu_callback(struct
 				  unsigned long action,
 				  void *hcpu)
 {
-	int hotcpu = (unsigned long)hcpu;
+	int hotcpu = (unsigned long)hcpu, i;
 	struct task_struct *p;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		p = kthread_create_on_node(run_ksoftirqd,
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			per_cpu(ksoftirqd[i], hotcpu) = NULL;
+		}
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			p = kthread_create_on_node(run_ksoftirqd,
 					   hcpu,
 					   cpu_to_node(hotcpu),
-					   "ksoftirqd/%d", hotcpu);
-		if (IS_ERR(p)) {
-			printk("ksoftirqd for %i failed\n", hotcpu);
-			return notifier_from_errno(PTR_ERR(p));
+					   "%s/%d", softirq_to_thread_name[i], hotcpu);
+			if (IS_ERR(p)) {
+				printk(KERN_ERR "%s/%d failed\n",
+					   softirq_to_thread_name[i], hotcpu);
+				return notifier_from_errno(PTR_ERR(p));
+			}
+			kthread_bind(p, hotcpu);
+			per_cpu(ksoftirqd[i], hotcpu) = p;
 		}
-		kthread_bind(p, hotcpu);
-  		per_cpu(ksoftirqd, hotcpu) = p;
  		break;
 	case CPU_ONLINE:
-		wake_up_process(per_cpu(ksoftirqd, hotcpu));
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++)
+			wake_up_process(per_cpu(ksoftirqd[i], hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-		if (!per_cpu(ksoftirqd, hotcpu))
-			break;
-		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(ksoftirqd, hotcpu),
-			     cpumask_any(cpu_online_mask));
+	case CPU_UP_CANCELED: {
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			p = per_cpu(ksoftirqd[i], hotcpu);
+			if (!p)
+				continue;
+			/* Unbind so it can run. */
+			kthread_bind(p, cpumask_any(cpu_online_mask));
+		}
+	}
 	case CPU_POST_DEAD: {
 		static const struct sched_param param = {
 			.sched_priority = MAX_RT_PRIO-1
 		};
 
-		p = per_cpu(ksoftirqd, hotcpu);
-		per_cpu(ksoftirqd, hotcpu) = NULL;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-		kthread_stop(p);
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			p = per_cpu(ksoftirqd[i], hotcpu);
+			per_cpu(ksoftirqd[i], hotcpu) = NULL;
+			if (!p)
+				continue;
+			sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+			kthread_stop(p);
+		}
 		takeover_tasklets(hotcpu);
 		break;
 	}


