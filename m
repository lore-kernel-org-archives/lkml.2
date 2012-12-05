Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2LEQFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:05:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:48693 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2LEQFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:05:33 -0500
Date: Wed, 5 Dec 2012 17:05:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.9-rt21
Message-ID: <alpine.LFD.2.02.1212051659160.2701@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.9-rt21 release. 3.6.7-rt18, 3.6.8-rt19
and 3.6.9-rt20 are not announced updates to the respective 3.6.y
stable releases without any RT changes

Changes since 3.6.9-rt20:

   * Fix the PREEMPT_LAZY implementation on ARM

   * Fix the RCUTINY issues

   * Fix a long standing scheduler bug (See commit log of
     sched-enqueue-to-head.patch)


Known issues:

   * There is still a possibility to get false positives from the NOHZ
     idle softirq pending detector. It's rather complex to fix and I
     have postponed it for a separate release. The warnings are
     harmless and can be ignored for now.

The delta patch against 3.6.9-rt20 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.9-rt20-rt21.patch.xz

The RT patch against 3.6.9 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.9-rt21.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.9-rt21.tar.xz

Enjoy,

	tglx

------------->
Index: linux-stable/arch/arm/kernel/entry-armv.S
===================================================================
--- linux-stable.orig/arch/arm/kernel/entry-armv.S
+++ linux-stable/arch/arm/kernel/entry-armv.S
@@ -216,17 +216,18 @@ __irq_svc:
 #ifdef CONFIG_PREEMPT
 	get_thread_info tsk
 	ldr	r8, [tsk, #TI_PREEMPT]		@ get preempt count
-	ldr	r0, [tsk, #TI_FLAGS]		@ get flags
 	teq	r8, #0				@ if preempt count != 0
-	movne	r0, #0				@ force flags to 0
-	tst	r0, #_TIF_NEED_RESCHED
-	blne	svc_preempt
-	ldr	r8, [tsk, #TI_PREEMPT_LAZY]	@ get preempt lazy count
+	bne	1f				@ return from exeption
 	ldr	r0, [tsk, #TI_FLAGS]		@ get flags
+	tst	r0, #_TIF_NEED_RESCHED		@ if NEED_RESCHED is set
+	blne	svc_preempt			@ preempt!
+
+	ldr	r8, [tsk, #TI_PREEMPT_LAZY]	@ get preempt lazy count
 	teq	r8, #0				@ if preempt lazy count != 0
 	movne	r0, #0				@ force flags to 0
 	tst	r0, #_TIF_NEED_RESCHED_LAZY
 	blne	svc_preempt
+1:
 #endif
 
 #ifdef CONFIG_TRACE_IRQFLAGS
Index: linux-stable/kernel/Makefile
===================================================================
--- linux-stable.orig/kernel/Makefile
+++ linux-stable/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o lglock.o
+	    async.o range.o groups.o lglock.o wait-simple.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
Index: linux-stable/kernel/rcutiny_plugin.h
===================================================================
--- linux-stable.orig/kernel/rcutiny_plugin.h
+++ linux-stable/kernel/rcutiny_plugin.h
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/wait-simple.h>
 
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
@@ -260,7 +261,7 @@ static void show_tiny_preempt_stats(stru
 
 /* Controls for rcu_kthread() kthread. */
 static struct task_struct *rcu_kthread_task;
-static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
+static DEFINE_SWAIT_HEAD(rcu_kthread_wq);
 static unsigned long have_rcu_kthread_work;
 
 /*
@@ -710,7 +711,7 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
-static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
+static DEFINE_SWAIT_HEAD(sync_rcu_preempt_exp_wq);
 static unsigned long sync_rcu_preempt_exp_count;
 static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
 
@@ -732,7 +733,7 @@ static int rcu_preempted_readers_exp(voi
  */
 static void rcu_report_exp_done(void)
 {
-	wake_up(&sync_rcu_preempt_exp_wq);
+	swait_wake(&sync_rcu_preempt_exp_wq);
 }
 
 /*
@@ -784,8 +785,8 @@ void synchronize_rcu_expedited(void)
 	} else {
 		rcu_initiate_boost();
 		local_irq_restore(flags);
-		wait_event(sync_rcu_preempt_exp_wq,
-			   !rcu_preempted_readers_exp());
+		swait_event(sync_rcu_preempt_exp_wq,
+			    !rcu_preempted_readers_exp());
 	}
 
 	/* Clean up and exit. */
@@ -855,7 +856,7 @@ static void invoke_rcu_callbacks(void)
 {
 	have_rcu_kthread_work = 1;
 	if (rcu_kthread_task != NULL)
-		wake_up(&rcu_kthread_wq);
+		swait_wake(&rcu_kthread_wq);
 }
 
 #ifdef CONFIG_RCU_TRACE
@@ -885,8 +886,8 @@ static int rcu_kthread(void *arg)
 	unsigned long flags;
 
 	for (;;) {
-		wait_event_interruptible(rcu_kthread_wq,
-					 have_rcu_kthread_work != 0);
+		swait_event_interruptible(rcu_kthread_wq,
+					  have_rcu_kthread_work != 0);
 		morework = rcu_boost();
 		local_irq_save(flags);
 		work = have_rcu_kthread_work;
Index: linux-stable/kernel/sched/core.c
===================================================================
--- linux-stable.orig/kernel/sched/core.c
+++ linux-stable/kernel/sched/core.c
@@ -4268,6 +4268,8 @@ void rt_mutex_setprio(struct task_struct
 
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
+	if (oldprio == prio)
+		goto out_unlock;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
@@ -4618,6 +4620,13 @@ recheck:
 		task_rq_unlock(rq, p, &flags);
 		goto recheck;
 	}
+
+	p->sched_reset_on_fork = reset_on_fork;
+
+	oldprio = p->prio;
+	if (oldprio == param->sched_priority)
+		goto out;
+
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -4625,18 +4634,17 @@ recheck:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->sched_reset_on_fork = reset_on_fork;
-
-	oldprio = p->prio;
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, oldprio < param->sched_priority ?
+			     ENQUEUE_HEAD : 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
+out:
 	task_rq_unlock(rq, p, &flags);
 
 	rt_mutex_adjust_pi(p);
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt20
+-rt21
Index: linux-stable/include/linux/wait-simple.h
===================================================================
--- /dev/null
+++ linux-stable/include/linux/wait-simple.h
@@ -0,0 +1,204 @@
+#ifndef _LINUX_WAIT_SIMPLE_H
+#define _LINUX_WAIT_SIMPLE_H
+
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+#include <asm/current.h>
+
+struct swaiter {
+	struct task_struct	*task;
+	struct list_head	node;
+};
+
+#define DEFINE_SWAITER(name)					\
+	struct swaiter name = {					\
+		.task	= current,				\
+		.node	= LIST_HEAD_INIT((name).node),		\
+	}
+
+struct swait_head {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+
+#define DEFINE_SWAIT_HEAD(name)					\
+	struct swait_head name = {				\
+		.lock	= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.list	= LIST_HEAD_INIT((name).list),		\
+	}
+
+extern void __init_swait_head(struct swait_head *h, struct lock_class_key *key);
+
+#define init_swait_head(swh)					\
+	do {							\
+		static struct lock_class_key __key;		\
+								\
+		__init_swait_head((swh), &__key);		\
+	} while (0)
+
+/*
+ * Waiter functions
+ */
+static inline bool swaiter_enqueued(struct swaiter *w)
+{
+	return w->task != NULL;
+}
+
+extern void swait_prepare(struct swait_head *head, struct swaiter *w, int state);
+extern void swait_finish(struct swait_head *head, struct swaiter *w);
+
+/*
+ * Adds w to head->list. Must be called with head->lock locked.
+ */
+static inline void __swait_enqueue(struct swait_head *head, struct swaiter *w)
+{
+	list_add(&w->node, &head->list);
+}
+
+/*
+ * Removes w from head->list. Must be called with head->lock locked.
+ */
+static inline void __swait_dequeue(struct swaiter *w)
+{
+	list_del_init(&w->node);
+}
+
+/*
+ * Check whether a head has waiters enqueued
+ */
+static inline bool swait_head_has_waiters(struct swait_head *h)
+{
+	return !list_empty(&h->list);
+}
+
+/*
+ * Wakeup functions
+ */
+extern int __swait_wake(struct swait_head *head, unsigned int state);
+
+static inline int swait_wake(struct swait_head *head)
+{
+	return swait_head_has_waiters(head) ?
+		__swait_wake(head, TASK_NORMAL) : 0;
+}
+
+static inline int swait_wake_interruptible(struct swait_head *head)
+{
+	return swait_head_has_waiters(head) ?
+		__swait_wake(head, TASK_INTERRUPTIBLE) : 0;
+}
+
+/*
+ * Event API
+ */
+
+#define __swait_event(wq, condition)					\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event(wq, condition)					\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event(wq, condition);					\
+} while (0)
+
+#define __swait_event_interruptible(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_interruptible - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event_interruptible(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__swait_event_interruptible(wq, condition, __ret);	\
+	__ret;								\
+})
+
+#define __swait_event_timeout(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		ret = schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_timeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if the @timeout elapsed, and the remaining
+ * jiffies if the condition evaluated to true before the timeout elapsed.
+ */
+#define swait_event_timeout(wq, condition, timeout)			\
+({									\
+	long __ret = timeout;						\
+	if (!(condition))						\
+		__swait_event_timeout(wq, condition, __ret);		\
+	__ret;								\
+})
+
+#endif
Index: linux-stable/kernel/wait-simple.c
===================================================================
--- /dev/null
+++ linux-stable/kernel/wait-simple.c
@@ -0,0 +1,68 @@
+/*
+ * Simple waitqueues without fancy flags and callbacks
+ *
+ * (C) 2011 Thomas Gleixner <tglx@linutronix.de>
+ *
+ * Based on kernel/wait.c
+ *
+ * For licencing details see kernel-base/COPYING
+ */
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/wait-simple.h>
+
+void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
+{
+	raw_spin_lock_init(&head->lock);
+	lockdep_set_class(&head->lock, key);
+	INIT_LIST_HEAD(&head->list);
+}
+EXPORT_SYMBOL_GPL(__init_swait_head);
+
+void swait_prepare(struct swait_head *head, struct swaiter *w, int state)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	w->task = current;
+	if (list_empty(&w->node))
+		__swait_enqueue(head, w);
+	set_current_state(state);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
+EXPORT_SYMBOL_GPL(swait_prepare);
+
+void swait_finish(struct swait_head *head, struct swaiter *w)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+	if (w->task) {
+		raw_spin_lock_irqsave(&head->lock, flags);
+		__swait_dequeue(w);
+		raw_spin_unlock_irqrestore(&head->lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(swait_finish);
+
+int __swait_wake(struct swait_head *head, unsigned int state)
+{
+	struct swaiter *curr, *next;
+	unsigned long flags;
+	int woken = 0;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+
+	list_for_each_entry_safe(curr, next, &head->list, node) {
+		if (wake_up_state(curr->task, state)) {
+			__swait_dequeue(curr);
+			curr->task = NULL;
+			woken++;
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+	return woken;
+}
+EXPORT_SYMBOL_GPL(__swait_wake);
