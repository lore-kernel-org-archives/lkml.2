Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1CBRtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:49:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:59236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1CBRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:25 -0500
Message-Id: <20110302174121.638661917@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 19/22] sched: Restructure ttwu some more
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-ttwu-foo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last few changes to ttwu that allow for adding remote queues.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   83 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 28 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2475,6 +2475,48 @@ ttwu_do_wakeup(struct rq *rq, struct tas
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
+static void
+ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
+{
+#ifdef CONFIG_SMP
+	if (p->sched_contributes_to_load)
+		rq->nr_uninterruptible--;
+#endif
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
+static void ttwu_queue(struct task_struct *p, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	raw_spin_lock(&rq->lock);
+	ttwu_do_activate(rq, p, 0);
+	raw_spin_unlock(&rq->lock);
+}
+
 /**
  * try_to_wake_up - wake up a thread
  * @p: the thread to be awakened
@@ -2493,27 +2535,25 @@ ttwu_do_wakeup(struct rq *rq, struct tas
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
 
 #ifdef CONFIG_SMP
+	/*
+	 * If the owning (remote) cpu is still in the middle of schedule() with
+	 * this task as prev, wait until its done referencing the task.
+	 */
 	while (p->on_cpu) {
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 		/*
@@ -2539,30 +2579,17 @@ try_to_wake_up(struct task_struct *p, un
 		p->sched_class->task_waking(p);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-out_activate:
-#endif /* CONFIG_SMP */
-
-	rq = cpu_rq(cpu);
-	raw_spin_lock(&rq->lock);
-
-#ifdef CONFIG_SMP
-	if (cpu != task_cpu(p))
+	if (task_cpu(p) != cpu)
 		set_task_cpu(p, cpu);
 
-	if (p->sched_contributes_to_load)
-		rq->nr_uninterruptible--;
-#endif
-
-	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
-out_running:
-	ttwu_do_wakeup(rq, p, wake_flags);
-	success = 1;
-	__task_rq_unlock(rq);
+out_activate:
+#endif /* CONFIG_SMP */
 
+	ttwu_queue(p, cpu);
+stat:
 	ttwu_stat(p, cpu, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
-	put_cpu();
 
 	return success;
 }


