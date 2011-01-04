Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1ADPNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:13:19 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54883 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1ADPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:12:16 -0500
Message-Id: <20110104150103.164045216@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 15:59:46 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 17/18] sched: Move the second half of ttwu() to the remote cpu
References: <20110104145929.772813816@chello.nl>
Content-Disposition: inline; filename=sched-ttwu-queue-remote.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've removed the rq->lock requirement from the first part of
ttwu() and can compute placement without holding any rq->lock, ensure
we execute the second half of ttwu() on the actual cpu we want the
task to run on.

This avoids having to take rq->lock and doing the task enqueue
remotely, saving lots on cacheline transfers.

As measured using: http://oss.oracle.com/~mason/sembench.c

$ echo 4096 32000 64 128 > /proc/sys/kernel/sem
$ ./sembench -t 2048 -w 1900 -o 0

unpatched: run time 30 seconds 639476 worker burns per second
patched:   run time 30 seconds 847526 worker burns per second

Still need to sort out all the races marked XXX (non-trivial), and its
x86 only for the moment.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/smp.c   |    1 
 include/linux/sched.h   |    2 
 kernel/sched.c          |  139 +++++++++++++++++++++++++++++++++++++-----------
 kernel/sched_features.h |    2 
 4 files changed, 113 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/x86/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp.c
+++ linux-2.6/arch/x86/kernel/smp.c
@@ -205,6 +205,7 @@ void smp_reschedule_interrupt(struct pt_
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
+	sched_ttwu_pending();
 }
 
 void smp_call_function_interrupt(struct pt_regs *regs)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1020,6 +1020,7 @@ partition_sched_domains(int ndoms_new, c
 }
 #endif	/* !CONFIG_SMP */
 
+void sched_ttwu_pending(void);
 
 struct io_context;			/* See blkdev.h */
 
@@ -1201,6 +1202,7 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
+	struct task_struct *wake_entry;
 	int on_cpu;
 #endif
 	int on_rq;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -559,6 +559,10 @@ struct rq {
 	/* BKL stats */
 	unsigned int bkl_count;
 #endif
+
+#ifdef CONFIG_SMP
+	struct task_struct *wake_list;
+#endif
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -2431,6 +2435,96 @@ ttwu_do_wakeup(struct rq *rq, struct tas
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
+static void
+ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
+{
+	WARN_ON_ONCE(task_cpu(p) != cpu_of(rq));
+
+	if (p->sched_contributes_to_load)
+		rq->nr_uninterruptible--;
+
+	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
+	ttwu_do_wakeup(rq, p, wake_flags);
+}
+
+/*
+ * Called in case the task @p isn't fully descheduled from its runqueue,
+ * in this case we must do a remote wakeup. Its a 'light' wakeup though,
+ * since all we need to do is flip p->state to TASK_RUNNING, since
+ * the task is still ->on_rq.
+ */
+static int ttwu_remote(struct task_struct *p, int wake_flags)
+{
+	struct rq *rq;
+	int ret = 0;
+
+	rq = __task_rq_lock(p);
+	if (p->on_rq) {
+		ttwu_do_wakeup(rq, p, wake_flags);
+		ret = 1;
+	}
+	__task_rq_unlock(rq);
+
+	return ret;
+}
+
+void sched_ttwu_pending(void)
+{
+#ifdef CONFIG_SMP
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	raw_spin_lock(&rq->lock);
+
+	while (list) {
+		struct task_struct *p = list;
+		list = list->wake_entry;
+		ttwu_do_activate(rq, p, 0);
+	}
+
+	raw_spin_unlock(&rq->lock);
+#endif
+}
+
+#ifdef CONFIG_SMP
+static void ttwu_queue_remote(struct task_struct *p, int cpu)
+{
+	struct task_struct *next = NULL;
+	struct rq *rq = cpu_rq(cpu);
+
+	for (;;) {
+		struct task_struct *old = next;
+
+		p->wake_entry = next;
+		next = cmpxchg(&rq->wake_list, old, p);
+		if (next == old)
+			break;
+	}
+
+	if (!next)
+		smp_send_reschedule(cpu);
+}
+#endif
+
+static void ttwu_queue(struct task_struct *p, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+#ifdef CONFIG_SMP
+	if (!sched_feat(TTWU_FORCE_REMOTE) && cpu != smp_processor_id()) {
+		ttwu_queue_remote(p, cpu);
+		return;
+	}
+#endif
+
+	raw_spin_lock(&rq->lock);
+	ttwu_do_activate(rq, p, 0);
+	raw_spin_unlock(&rq->lock);
+}
+
 /**
  * try_to_wake_up - wake up a thread
  * @p: the thread to be awakened
@@ -2449,60 +2543,43 @@ ttwu_do_wakeup(struct rq *rq, struct tas
 static int
 try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
-	int cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq;
-
-	this_cpu = get_cpu();
+	int cpu, success = 0;
 
 	smp_wmb();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	if (!(p->state & state))
 		goto out;
 
+	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (p->on_rq) {
-		rq = __task_rq_lock(p);
-		if (p->on_rq)
-			goto out_running;
-		__task_rq_unlock(rq);
-	}
+	if (p->on_rq && ttwu_remote(p, wake_flags))
+		goto stat;
+
+	p->sched_contributes_to_load = !!task_contributes_to_load(p);
+	p->state = TASK_WAKING;
 
 #ifdef CONFIG_SMP
+	/*
+	 * If the owning (remote) cpu is still in the middle of schedule() with
+	 * this task as prev, wait until its done referencing the task.
+	 */
 	while (p->on_cpu)
 		cpu_relax();
 
-	p->sched_contributes_to_load = !!task_contributes_to_load(p);
-	p->state = TASK_WAKING;
-
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(p);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	set_task_cpu(p, cpu);
 #endif /* CONFIG_SMP */
 
-	rq = cpu_rq(cpu);
-	raw_spin_lock(&rq->lock);
-
-#ifdef CONFIG_SMP
-	if (cpu != task_cpu(p))
-		set_task_cpu(p, cpu);
-
-	if (p->sched_contributes_to_load)
-		rq->nr_uninterruptible--;
-#endif
-
-	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
-out_running:
-	ttwu_do_wakeup(rq, p, wake_flags);
-	success = 1;
-	__task_rq_unlock(rq);
-
+	ttwu_queue(p, cpu);
+stat:
 	ttwu_stat(p, cpu, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
-	put_cpu();
 
 	return success;
 }
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -64,3 +64,5 @@ SCHED_FEAT(OWNER_SPIN, 1)
  * Decrement CPU power based on irq activity
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
+
+SCHED_FEAT(TTWU_FORCE_REMOTE, 0)


