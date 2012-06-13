Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2FMLBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:01:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:48233 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab2FMLBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:01:00 -0400
Message-Id: <20120613105815.132283147@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 13 Jun 2012 11:00:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: [RFC patch 1/5] kthread: Implement park/unpark facility
References: <20120613102823.373180763@linutronix.de>
Content-Disposition: inline; filename=kthread-implement-park-and-percpu.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid the full teardown/setup of per cpu kthreads in the case of
cpu hot(un)plug, provide a facility which allows to put the kthread
into a park position and unpark it when the cpu comes online again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kthread.h |   11 ++-
 kernel/kthread.c        |  165 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 162 insertions(+), 14 deletions(-)

Index: tip/include/linux/kthread.h
===================================================================
--- tip.orig/include/linux/kthread.h
+++ tip/include/linux/kthread.h
@@ -14,6 +14,11 @@ struct task_struct *kthread_create_on_no
 	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
 
 
+struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
+					  void *data,
+					  unsigned int cpu,
+					  const char *namefmt);
+
 /**
  * kthread_run - create and wake a thread.
  * @threadfn: the function to run until signal_pending(current).
@@ -34,9 +39,13 @@ struct task_struct *kthread_create_on_no
 
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
-int kthread_should_stop(void);
+bool kthread_should_stop(void);
+bool kthread_should_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
+int kthread_park(struct task_struct *k);
+void kthread_unpark(struct task_struct *k);
+void kthread_parkme(void);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
Index: tip/kernel/kthread.c
===================================================================
--- tip.orig/kernel/kthread.c
+++ tip/kernel/kthread.c
@@ -37,11 +37,20 @@ struct kthread_create_info
 };
 
 struct kthread {
-	int should_stop;
+	unsigned long flags;
+	unsigned int cpu;
 	void *data;
+	struct completion parked;
 	struct completion exited;
 };
 
+enum KTHREAD_BITS {
+	KTHREAD_IS_PER_CPU = 0,
+	KTHREAD_SHOULD_STOP,
+	KTHREAD_SHOULD_PARK,
+	KTHREAD_IS_PARKED,
+};
+
 #define to_kthread(tsk)	\
 	container_of((tsk)->vfork_done, struct kthread, exited)
 
@@ -52,13 +61,29 @@ struct kthread {
  * and this will return true.  You should then return, and your return
  * value will be passed through to kthread_stop().
  */
-int kthread_should_stop(void)
+bool kthread_should_stop(void)
 {
-	return to_kthread(current)->should_stop;
+	return test_bit(KTHREAD_SHOULD_STOP, &to_kthread(current)->flags);
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
 /**
+ * kthread_should_park - should this kthread return now?
+ *
+ * When someone calls kthread_park() on your kthread, it will be woken
+ * and this will return true.  You should then return, and your return
+ * value will be passed through to kthread_park().
+ *
+ * Similar to kthread_should_stop(), but this keeps the thread alive
+ * and in a park position. kthread_unpark() "restart" the thread and
+ * calls the thread function again.
+ */
+bool kthread_should_park(void)
+{
+	return test_bit(KTHREAD_SHOULD_PARK, &to_kthread(current)->flags);
+}
+
+/**
  * kthread_freezable_should_stop - should this freezable kthread return now?
  * @was_frozen: optional out parameter, indicates whether %current was frozen
  *
@@ -96,6 +121,23 @@ void *kthread_data(struct task_struct *t
 	return to_kthread(task)->data;
 }
 
+static void __kthread_parkme(struct kthread *self)
+{
+	__set_current_state(TASK_INTERRUPTIBLE);
+	while (test_bit(KTHREAD_SHOULD_PARK, &self->flags)) {
+		if (!test_and_set_bit(KTHREAD_IS_PARKED, &self->flags))
+			complete(&self->parked);
+		schedule();
+	}
+	clear_bit(KTHREAD_IS_PARKED, &self->flags);
+	__set_current_state(TASK_RUNNING);
+}
+
+void kthread_parkme(void)
+{
+	__kthread_parkme(to_kthread(current));
+}
+
 static int kthread(void *_create)
 {
 	/* Copy data: it's on kthread's stack */
@@ -105,9 +147,10 @@ static int kthread(void *_create)
 	struct kthread self;
 	int ret;
 
-	self.should_stop = 0;
+	self.flags = 0;
 	self.data = data;
 	init_completion(&self.exited);
+	init_completion(&self.parked);
 	current->vfork_done = &self.exited;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
@@ -117,9 +160,11 @@ static int kthread(void *_create)
 	schedule();
 
 	ret = -EINTR;
-	if (!self.should_stop)
-		ret = threadfn(data);
 
+	if (!test_bit(KTHREAD_SHOULD_STOP, &self.flags)) {
+		__kthread_parkme(&self);
+		ret = threadfn(data);
+	}
 	/* we can't just return, we must preserve "self" on stack */
 	do_exit(ret);
 }
@@ -172,8 +217,7 @@ static void create_kthread(struct kthrea
  * Returns a task_struct or ERR_PTR(-ENOMEM).
  */
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
-					   void *data,
-					   int node,
+					   void *data, int node,
 					   const char namefmt[],
 					   ...)
 {
@@ -210,6 +254,13 @@ struct task_struct *kthread_create_on_no
 }
 EXPORT_SYMBOL(kthread_create_on_node);
 
+static void __kthread_bind(struct task_struct *p, unsigned int cpu)
+{
+	/* It's safe because the task is inactive. */
+	do_set_cpus_allowed(p, cpumask_of(cpu));
+	p->flags |= PF_THREAD_BOUND;
+}
+
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
  * @p: thread created by kthread_create().
@@ -226,14 +277,102 @@ void kthread_bind(struct task_struct *p,
 		WARN_ON(1);
 		return;
 	}
-
-	/* It's safe because the task is inactive. */
-	do_set_cpus_allowed(p, cpumask_of(cpu));
-	p->flags |= PF_THREAD_BOUND;
+	__kthread_bind(p, cpu);
 }
 EXPORT_SYMBOL(kthread_bind);
 
 /**
+ * kthread_create_on_cpu - Create a cpu bound kthread
+ * @threadfn: the function to run until signal_pending(current).
+ * @data: data ptr for @threadfn.
+ * @node: memory node number.
+ * @namefmt: printf-style name for the thread.
+ *
+ * Description: This helper function creates and names a kernel thread
+ * and binds it to a given CPU. The thread will be woken and put into
+ * park mode.
+ */
+struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
+					  void *data, unsigned int cpu,
+					  const char *namefmt)
+{
+	struct task_struct *p;
+
+	p = kthread_create_on_node(threadfn, data, cpu_to_node(cpu), namefmt,
+				   cpu);
+	if (IS_ERR(p))
+		return p;
+	/* Park the thread, mark it percpu and then bind it */
+	kthread_park(p);
+	set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
+	to_kthread(p)->cpu = cpu;
+	__kthread_bind(p, cpu);
+	return p;
+}
+
+/**
+ * kthread_unpark - unpark a thread created by kthread_create().
+ * @k:		thread created by kthread_create().
+ *
+ * Sets kthread_should_park() for @k to return false, wakes it, and
+ * waits for it to return. If the thread is marked percpu then its
+ * bound to the cpu again.
+ */
+void kthread_unpark(struct task_struct *k)
+{
+	struct kthread *kthread;
+
+	get_task_struct(k);
+
+	kthread = to_kthread(k);
+	barrier(); /* it might have exited */
+	if (k->vfork_done != NULL) {
+		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
+		if (test_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
+			if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
+				__kthread_bind(k, kthread->cpu);
+			wake_up_process(k);
+		}
+	}
+	put_task_struct(k);
+}
+
+/**
+ * kthread_park - park a thread created by kthread_create().
+ * @k: thread created by kthread_create().
+ *
+ * Sets kthread_should_park() for @k to return true, wakes it, and
+ * waits for it to return. This can also be called after kthread_create()
+ * instead of calling wake_up_process(): the thread will park without
+ * calling threadfn().
+ *
+ * Returns 0 if the thread is parked, -ENOSYS if the thread exited.
+ * If called by the kthread itself just the park bit is set.
+ */
+int kthread_park(struct task_struct *k)
+{
+	struct kthread *kthread;
+	int ret = -ENOSYS;
+
+	get_task_struct(k);
+
+	kthread = to_kthread(k);
+	barrier(); /* it might have exited */
+	if (k->vfork_done != NULL) {
+		if (!test_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
+			set_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
+			if (k != current) {
+				wake_up_process(k);
+				wait_for_completion(&kthread->parked);
+			}
+		}
+		ret = 0;
+	}
+	put_task_struct(k);
+	return ret;
+}
+
+/**
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
  *
@@ -259,7 +398,7 @@ int kthread_stop(struct task_struct *k)
 	kthread = to_kthread(k);
 	barrier(); /* it might have exited */
 	if (k->vfork_done != NULL) {
-		kthread->should_stop = 1;
+		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
 		wake_up_process(k);
 		wait_for_completion(&kthread->exited);
 	}


