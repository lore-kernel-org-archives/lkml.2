Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725Ab2DLVNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab2DLVNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:13:48 -0400
Date: Thu, 12 Apr 2012 23:12:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] genirq: reimplement exit_irq_thread() hook via
	task_work_queue()
Message-ID: <20120412211248.GC30456@redhat.com>
References: <20120412211146.GA30448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412211146.GA30448@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_irq_thread() and task->irq_thread are needed to handle
the unexpected (and unlikely) exit of irq-thread.

We can use task_work instead and make this all private to
kernel/irq/manage.c, simplification plus micro-optimization.

1. rename exit_irq_thread() to irq_thread_dtor(), make it
   static, and move it up before irq_thread().

2. change irq_thread() to do task_queue_work(irq_thread_dtor)
   at the start and task_work_cancel() before return.

   tracehook_notify_resume() can never play with kthreads,
   only do_exit()->exit_task_work() can call the callback
   and this is what we want.

3. remove task_struct->irq_thread and the special hook
   in do_exit().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/interrupt.h |    4 --
 include/linux/sched.h     |   10 +-----
 kernel/exit.c             |    2 -
 kernel/irq/manage.c       |   69 +++++++++++++++++++++-----------------------
 4 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2aea5d2..1cdd4d0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -142,8 +142,6 @@ request_any_context_irq(unsigned int irq, irq_handler_t handler,
 extern int __must_check
 request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		   const char *devname, void __percpu *percpu_dev_id);
-
-extern void exit_irq_thread(void);
 #else
 
 extern int __must_check
@@ -177,8 +175,6 @@ request_percpu_irq(unsigned int irq, irq_handler_t handler,
 {
 	return request_irq(irq, handler, 0, devname, percpu_dev_id);
 }
-
-static inline void exit_irq_thread(void) { }
 #endif
 
 extern void free_irq(unsigned int, void *);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index be004ac..e36edfb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1346,11 +1346,6 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-	/* IRQ handler threads */
-	unsigned irq_thread:1;
-#endif
-
 	pid_t pid;
 	pid_t tgid;
 
@@ -1358,10 +1353,9 @@ struct task_struct {
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
 #endif
-
-	/* 
+	/*
 	 * pointers to (original) parent process, youngest child, younger sibling,
-	 * older sibling, respectively.  (p->father can be replaced with 
+	 * older sibling, respectively.  (p->father can be replaced with
 	 * p->real_parent->pid)
 	 */
 	struct task_struct __rcu *real_parent; /* real parent process */
diff --git a/kernel/exit.c b/kernel/exit.c
index dc852c2..c1ca919 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -954,8 +954,6 @@ void do_exit(long code)
 
 	exit_task_work(tsk);
 
-	exit_irq_thread();
-
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
 				current->comm, task_pid_nr(current),
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 89a3ea8..8b0d648 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/task_work.h>
 
 #include "internals.h"
 
@@ -773,11 +774,39 @@ static void wake_threads_waitq(struct irq_desc *desc)
 		wake_up(&desc->wait_for_threads);
 }
 
+static void irq_thread_dtor(struct task_work *unused)
+{
+	struct task_struct *tsk = current;
+	struct irq_desc *desc;
+	struct irqaction *action;
+
+	if (WARN_ON_ONCE(!(current->flags & PF_EXITING)))
+		return;
+
+	action = kthread_data(tsk);
+
+	printk(KERN_ERR
+	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
+	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
+
+	desc = irq_to_desc(action->irq);
+	/*
+	 * If IRQTF_RUNTHREAD is set, we need to decrement
+	 * desc->threads_active and wake possible waiters.
+	 */
+	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		wake_threads_waitq(desc);
+
+	/* Prevent a stale desc->threads_oneshot */
+	irq_finalize_oneshot(desc, action);
+}
+
 /*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)
 {
+	struct task_work on_exit_work;
 	static const struct sched_param param = {
 		.sched_priority = MAX_USER_RT_PRIO/2,
 	};
@@ -793,7 +822,9 @@ static int irq_thread(void *data)
 		handler_fn = irq_thread_fn;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->irq_thread = 1;
+
+	init_task_work(&on_exit_work, irq_thread_dtor, NULL);
+	task_work_queue(current, &on_exit_work, false);
 
 	while (!irq_wait_for_interrupt(action)) {
 		irqreturn_t action_ret;
@@ -815,45 +846,11 @@ static int irq_thread(void *data)
 	 * cannot touch the oneshot mask at this point anymore as
 	 * __setup_irq() might have given out currents thread_mask
 	 * again.
-	 *
-	 * Clear irq_thread. Otherwise exit_irq_thread() would make
-	 * fuzz about an active irq thread going into nirvana.
 	 */
-	current->irq_thread = 0;
+	task_work_cancel(current, irq_thread_dtor);
 	return 0;
 }
 
-/*
- * Called from do_exit()
- */
-void exit_irq_thread(void)
-{
-	struct task_struct *tsk = current;
-	struct irq_desc *desc;
-	struct irqaction *action;
-
-	if (!tsk->irq_thread)
-		return;
-
-	action = kthread_data(tsk);
-
-	printk(KERN_ERR
-	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
-
-	desc = irq_to_desc(action->irq);
-
-	/*
-	 * If IRQTF_RUNTHREAD is set, we need to decrement
-	 * desc->threads_active and wake possible waiters.
-	 */
-	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
-		wake_threads_waitq(desc);
-
-	/* Prevent a stale desc->threads_oneshot */
-	irq_finalize_oneshot(desc, action);
-}
-
 static void irq_setup_forced_threading(struct irqaction *new)
 {
 	if (!force_irqthreads)
-- 
1.5.5.1


