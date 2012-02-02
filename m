Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2BBKHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:07:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab2BBKH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:07:28 -0500
Date: Thu, 2 Feb 2012 11:07:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120202100709.GA6294@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: cb297a3e433dbdcf7ad81e0564e7b804c941ff0d sched/rt: Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_CTXSW

 Thanks,

	Ingo

------------------>
Chanho Min (1):
      sched/rt: Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_CTXSW

Christian Borntraeger (1):
      sched/s390: Fix compile error in sched/core.c

Peter Zijlstra (1):
      sched: Fix rq->nr_uninterruptible update race

Suresh Siddha (1):
      sched/nohz: Fix nohz cpu idle load balancing state with cpu hotplug

Yasunori Goto (1):
      sched: Fix ancient race in do_exit()


 kernel/exit.c       |   16 ++++++++++++++++
 kernel/sched/core.c |   19 +++++++------------
 kernel/sched/fair.c |   34 +++++++++++++++++++++++++++++-----
 kernel/sched/rt.c   |    5 +++++
 4 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 294b170..4b4042f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1038,6 +1038,22 @@ void do_exit(long code)
 	if (tsk->nr_dirtied)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
 	exit_rcu();
+
+	/*
+	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
+	 * when the following two conditions become true.
+	 *   - There is race condition of mmap_sem (It is acquired by
+	 *     exit_mm()), and
+	 *   - SMI occurs before setting TASK_RUNINNG.
+	 *     (or hypervisor of virtual machine switches to other guest)
+	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
+	 *
+	 * To avoid it, we have to wait for releasing tsk->pi_lock which
+	 * is held by try_to_wake_up()
+	 */
+	smp_mb();
+	raw_spin_unlock_wait(&tsk->pi_lock);
+
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index df00cb0..5255c9d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -74,6 +74,7 @@
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
+#include <asm/mutex.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #endif
@@ -723,9 +724,6 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 	p->sched_class->dequeue_task(rq, p, flags);
 }
 
-/*
- * activate_task - move a task to the runqueue.
- */
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
@@ -734,9 +732,6 @@ void activate_task(struct rq *rq, struct task_struct *p, int flags)
 	enqueue_task(rq, p, flags);
 }
 
-/*
- * deactivate_task - remove a task from the runqueue.
- */
 void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
@@ -4134,7 +4129,7 @@ recheck:
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
-		deactivate_task(rq, p, 0);
+		dequeue_task(rq, p, 0);
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
@@ -4147,7 +4142,7 @@ recheck:
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
-		activate_task(rq, p, 0);
+		enqueue_task(rq, p, 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
@@ -4998,9 +4993,9 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * placed properly.
 	 */
 	if (p->on_rq) {
-		deactivate_task(rq_src, p, 0);
+		dequeue_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
-		activate_task(rq_dest, p, 0);
+		enqueue_task(rq_dest, p, 0);
 		check_preempt_curr(rq_dest, p, 0);
 	}
 done:
@@ -7032,10 +7027,10 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 
 	on_rq = p->on_rq;
 	if (on_rq)
-		deactivate_task(rq, p, 0);
+		dequeue_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
 	if (on_rq) {
-		activate_task(rq, p, 0);
+		enqueue_task(rq, p, 0);
 		resched_task(rq->curr);
 	}
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 84adb2d..7c6414f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4866,6 +4866,15 @@ static void nohz_balancer_kick(int cpu)
 	return;
 }
 
+static inline void clear_nohz_tick_stopped(int cpu)
+{
+	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
+		atomic_dec(&nohz.nr_cpus);
+		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
+	}
+}
+
 static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
@@ -4904,6 +4913,12 @@ void select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
 
+	/*
+	 * If this cpu is going down, then nothing needs to be done.
+	 */
+	if (!cpu_active(cpu))
+		return;
+
 	if (stop_tick) {
 		if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 			return;
@@ -4914,6 +4929,18 @@ void select_nohz_load_balancer(int stop_tick)
 	}
 	return;
 }
+
+static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DYING:
+		clear_nohz_tick_stopped(smp_processor_id());
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
 #endif
 
 static DEFINE_SPINLOCK(balancing);
@@ -5070,11 +5097,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	* busy tick after returning from idle, we will update the busy stats.
 	*/
 	set_cpu_sd_state_busy();
-	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
-		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
-		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
-		atomic_dec(&nohz.nr_cpus);
-	}
+	clear_nohz_tick_stopped(cpu);
 
 	/*
 	 * None are in tickless mode and hence no need for NOHZ idle load
@@ -5590,6 +5613,7 @@ __init void init_sched_fair_class(void)
 
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	cpu_notifier(sched_ilb_notifier, 0);
 #endif
 #endif /* SMP */
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3640ebb..f42ae7f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1587,6 +1587,11 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
 
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+       if (unlikely(task_running(rq, next_task)))
+               return 0;
+#endif
+
 retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
