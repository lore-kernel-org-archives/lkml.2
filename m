Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab2FENmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:42:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:46231 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934257Ab2FENmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:42:06 -0400
Date: Tue, 5 Jun 2012 15:41:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Peter Zijlstra <peterz@infradead.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] kthread: Implement park/unpark facility
In-Reply-To: <alpine.LFD.2.02.1206051135260.3086@ionos>
Message-ID: <alpine.LFD.2.02.1206051538280.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au> <alpine.LFD.2.02.1206051135260.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: kthread: Implement park/unpark facility
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 18 Apr 2012 16:37:40 +0200

To avoid the full teardown/setup of per cpu kthreads in the case of
cpu hot(un)plug, provide a facility which allows to put the kthread
into a park position and unpark it when the cpu comes online again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kthread.h |   10 ++
 kernel/kthread.c        |  161 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 160 insertions(+), 11 deletions(-)

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
@@ -34,9 +39,12 @@ struct task_struct *kthread_create_on_no
 
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
-int kthread_should_stop(void);
+bool kthread_should_stop(void);
+bool kthread_should_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
+int kthread_park(struct task_struct *k);
+void kthread_unpark(struct task_struct *k);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
Index: tip/kernel/kthread.c
===================================================================
--- tip.orig/kernel/kthread.c
+++ tip/kernel/kthread.c
@@ -37,8 +37,13 @@ struct kthread_create_info
 };
 
 struct kthread {
-	int should_stop;
+	bool should_stop;
+	bool should_park;
+	bool is_parked;
+	bool is_percpu;
+	unsigned int cpu;
 	void *data;
+	struct completion parked;
 	struct completion exited;
 };
 
@@ -52,13 +57,29 @@ struct kthread {
  * and this will return true.  You should then return, and your return
  * value will be passed through to kthread_stop().
  */
-int kthread_should_stop(void)
+bool kthread_should_stop(void)
 {
 	return to_kthread(current)->should_stop;
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
+	return to_kthread(current)->should_park;
+}
+
+/**
  * kthread_freezable_should_stop - should this freezable kthread return now?
  * @was_frozen: optional out parameter, indicates whether %current was frozen
  *
@@ -96,6 +117,23 @@ void *kthread_data(struct task_struct *t
 	return to_kthread(task)->data;
 }
 
+static bool kthread_parking(struct kthread *self)
+{
+	bool ret = false;
+
+	__set_current_state(TASK_INTERRUPTIBLE);
+	if (self->should_park) {
+		ret = true;
+		if (!self->is_parked) {
+			self->is_parked = true;
+			complete(&self->parked);
+		}
+		schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	return ret;
+}
+
 static int kthread(void *_create)
 {
 	/* Copy data: it's on kthread's stack */
@@ -105,9 +143,12 @@ static int kthread(void *_create)
 	struct kthread self;
 	int ret;
 
-	self.should_stop = 0;
+	self.should_stop = false;
+	self.should_park = false;
+	self.is_parked = false;
 	self.data = data;
 	init_completion(&self.exited);
+	init_completion(&self.parked);
 	current->vfork_done = &self.exited;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
@@ -117,9 +158,15 @@ static int kthread(void *_create)
 	schedule();
 
 	ret = -EINTR;
-	if (!self.should_stop)
-		ret = threadfn(data);
 
+	while (!self.should_stop) {
+		if (kthread_parking(&self))
+			continue;
+		self.is_parked = false;
+		ret = threadfn(data);
+		if (!self.should_park)
+			break;
+	}
 	/* we can't just return, we must preserve "self" on stack */
 	do_exit(ret);
 }
@@ -210,6 +257,13 @@ struct task_struct *kthread_create_on_no
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
@@ -226,14 +280,101 @@ void kthread_bind(struct task_struct *p,
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
+					  void *data,
+					  unsigned int cpu,
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
+	to_kthread(p)->is_percpu = true;
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
+	if (k->vfork_done != NULL && kthread->is_parked) {
+		if (kthread->is_percpu)
+			__kthread_bind(k, kthread->cpu);
+		kthread->should_park = false;
+		wake_up_process(k);
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
+		if (!kthread->is_parked) {
+			kthread->should_park = true;
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
@@ -259,7 +400,7 @@ int kthread_stop(struct task_struct *k)
 	kthread = to_kthread(k);
 	barrier(); /* it might have exited */
 	if (k->vfork_done != NULL) {
-		kthread->should_stop = 1;
+		kthread->should_stop = true;
 		wake_up_process(k);
 		wait_for_completion(&kthread->exited);
 	}
