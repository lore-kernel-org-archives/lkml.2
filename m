Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1DEPbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:31:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:60418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab1DEPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:30 -0400
Message-Id: <20110405152729.515897185@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 20/21] sched: Move the second half of ttwu() to the remote cpu
References: <20110405152338.692966333@chello.nl>
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

$ for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do echo performance > $i; done
$ echo 4096 32000 64 128 > /proc/sys/kernel/sem
$ ./sembench -t 2048 -w 1900 -o 0

unpatched: run time 30 seconds 647278 worker burns per second
patched:   run time 30 seconds 816715 worker burns per second

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h   |    3 +-
 init/Kconfig            |    5 ++++
 kernel/sched.c          |   56 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_features.h |    6 +++++
 4 files changed, 69 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1203,6 +1203,7 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
+	struct task_struct *wake_entry;
 	int on_cpu;
 #endif
 	int on_rq;
@@ -2192,7 +2193,7 @@ extern void set_task_comm(struct task_st
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
-static inline void scheduler_ipi(void) { }
+void scheduler_ipi(void);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
 static inline unsigned long wait_task_inactive(struct task_struct *p,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -556,6 +556,10 @@ struct rq {
 	unsigned int ttwu_count;
 	unsigned int ttwu_local;
 #endif
+
+#ifdef CONFIG_SMP
+	struct task_struct *wake_list;
+#endif
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -2508,10 +2512,61 @@ static int ttwu_remote(struct task_struc
 	return ret;
 }
 
+#ifdef CONFIG_SMP
+static void sched_ttwu_pending(void)
+{
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
+}
+
+void scheduler_ipi(void)
+{
+	sched_ttwu_pending();
+}
+
+static void ttwu_queue_remote(struct task_struct *p, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	struct task_struct *next = rq->wake_list;
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
 static void ttwu_queue(struct task_struct *p, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
+#if defined(CONFIG_SMP) && defined(CONFIG_SCHED_TTWU_QUEUE)
+	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+		ttwu_queue_remote(p, cpu);
+		return;
+	}
+#endif
+
 	raw_spin_lock(&rq->lock);
 	ttwu_do_activate(rq, p, 0);
 	raw_spin_unlock(&rq->lock);
@@ -6321,6 +6376,7 @@ migration_call(struct notifier_block *nf
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
+		sched_ttwu_pending();
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -64,3 +64,9 @@ SCHED_FEAT(OWNER_SPIN, 1)
  * Decrement CPU power based on irq activity
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
+
+/*
+ * Queue remote wakeups on the target CPU and process them
+ * using the scheduler IPI. Reduces rq->lock contention/bounces.
+ */
+SCHED_FEAT(TTWU_QUEUE, 1)
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -827,6 +827,11 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+config SCHED_TTWU_QUEUE
+	bool
+	depends on !SPARC32
+	default y
+
 config MM_OWNER
 	bool
 


