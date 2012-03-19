Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031879Ab2CSP2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:28:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35439 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030563Ab2CSP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:28:48 -0400
Date: Mon, 19 Mar 2012 16:28:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core changes for v3.4
Message-ID: <20120319152839.GA4380@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

   HEAD: e04268b0effc0ceea366c50b3107baad9edadafa genirq: Remove paranoid warnons and bogus fixups

 Thanks,

	Ingo

------------------>
Alexander Gordeev (4):
      genirq: Fix incorrect check for forced IRQ thread handler
      genirq: Get rid of unnecessary irqaction field in task_struct
      genirq: No need to check IRQTF_DIED before stopping a thread handler
      genirq: Get rid of unnecessary IRQTF_DIED flag

Heiko Carstens (1):
      softirq: Reduce invoke_softirq() code duplication

Ido Yariv (1):
      genirq: Flush the irq thread on synchronization

Linus Torvalds (1):
      x86-32/irq: Don't switch to irq stack for a user-mode irq

Russell King (1):
      genirq: Fix long-term regression in genirq irq_set_irq_type() handling

Thomas Gleixner (1):
      genirq: Remove paranoid warnons and bogus fixups


 arch/x86/kernel/irq_32.c |   11 ++----
 include/linux/sched.h    |   10 +++---
 kernel/exit.c            |    4 +-
 kernel/irq/chip.c        |    3 +-
 kernel/irq/handle.c      |   14 +++++++-
 kernel/irq/internals.h   |    2 -
 kernel/irq/manage.c      |   86 ++++++++++++++++++++-------------------------
 kernel/softirq.c         |   18 ++-------
 8 files changed, 66 insertions(+), 82 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 40fc861..58b7f27 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -100,13 +100,8 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	irqctx->tinfo.task = curctx->tinfo.task;
 	irqctx->tinfo.previous_esp = current_stack_pointer;
 
-	/*
-	 * Copy the softirq bits in preempt_count so that the
-	 * softirq checks work in the hardirq context.
-	 */
-	irqctx->tinfo.preempt_count =
-		(irqctx->tinfo.preempt_count & ~SOFTIRQ_MASK) |
-		(curctx->tinfo.preempt_count & SOFTIRQ_MASK);
+	/* Copy the preempt_count so that the [soft]irq checks work. */
+	irqctx->tinfo.preempt_count = curctx->tinfo.preempt_count;
 
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
@@ -196,7 +191,7 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 	if (unlikely(!desc))
 		return false;
 
-	if (!execute_on_irq_stack(overflow, desc, irq)) {
+	if (user_mode_vm(regs) || !execute_on_irq_stack(overflow, desc, irq)) {
 		if (unlikely(overflow))
 			print_stack_overflow();
 		desc->handle_irq(irq, desc);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0657368..abb67cf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1319,6 +1319,11 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+	/* IRQ handler threads */
+	unsigned irq_thread:1;
+#endif
+
 	pid_t pid;
 	pid_t tgid;
 
@@ -1427,11 +1432,6 @@ struct task_struct {
  * mempolicy */
 	spinlock_t alloc_lock;
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-	/* IRQ handler threads */
-	struct irqaction *irqaction;
-#endif
-
 	/* Protection of the PI data structures: */
 	raw_spinlock_t pi_lock;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..752d2c0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -935,8 +935,6 @@ void do_exit(long code)
 		schedule();
 	}
 
-	exit_irq_thread();
-
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
@@ -945,6 +943,8 @@ void do_exit(long code)
 	smp_mb();
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
+	exit_irq_thread();
+
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
 				current->comm, task_pid_nr(current),
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index fb7db75..25784d6 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -61,8 +61,7 @@ int irq_set_irq_type(unsigned int irq, unsigned int type)
 		return -EINVAL;
 
 	type &= IRQ_TYPE_SENSE_MASK;
-	if (type != IRQ_TYPE_NONE)
-		ret = __irq_set_trigger(desc, irq, type);
+	ret = __irq_set_trigger(desc, irq, type);
 	irq_put_desc_busunlock(desc, flags);
 	return ret;
 }
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 470d08c..6ff84e6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -60,7 +60,7 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 	 * device interrupt, so no irq storm is lurking. If the
 	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
+	if ((action->thread->flags & PF_EXITING) ||
 	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		return;
 
@@ -110,6 +110,18 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 	 * threads_oneshot untouched and runs the thread another time.
 	 */
 	desc->threads_oneshot |= action->thread_mask;
+
+	/*
+	 * We increment the threads_active counter in case we wake up
+	 * the irq thread. The irq thread decrements the counter when
+	 * it returns from the handler or in the exit path and wakes
+	 * up waiters which are stuck in synchronize_irq() when the
+	 * active count becomes zero. synchronize_irq() is serialized
+	 * against this code (hard irq handler) via IRQS_INPROGRESS
+	 * like the finalize_oneshot() code. See comment above.
+	 */
+	atomic_inc(&desc->threads_active);
+
 	wake_up_process(action->thread);
 }
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 40378ff..8e5c56b 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -20,14 +20,12 @@ extern bool noirqdebug;
 /*
  * Bits used by threaded handlers:
  * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
- * IRQTF_DIED      - handler thread died
  * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
  * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
  * IRQTF_FORCED_THREAD  - irq action is force threaded
  */
 enum {
 	IRQTF_RUNTHREAD,
-	IRQTF_DIED,
 	IRQTF_WARNED,
 	IRQTF_AFFINITY,
 	IRQTF_FORCED_THREAD,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0f0d470..b0ccd1a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -759,6 +759,13 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 	return ret;
 }
 
+static void wake_threads_waitq(struct irq_desc *desc)
+{
+	if (atomic_dec_and_test(&desc->threads_active) &&
+	    waitqueue_active(&desc->wait_for_threads))
+		wake_up(&desc->wait_for_threads);
+}
+
 /*
  * Interrupt handler thread
  */
@@ -771,57 +778,41 @@ static int irq_thread(void *data)
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
 			struct irqaction *action);
-	int wake;
 
-	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
+	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
 					&action->thread_flags))
 		handler_fn = irq_forced_thread_fn;
 	else
 		handler_fn = irq_thread_fn;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->irqaction = action;
+	current->irq_thread = 1;
 
 	while (!irq_wait_for_interrupt(action)) {
+		irqreturn_t action_ret;
 
 		irq_thread_check_affinity(desc, action);
 
-		atomic_inc(&desc->threads_active);
+		action_ret = handler_fn(desc, action);
+		if (!noirqdebug)
+			note_interrupt(action->irq, desc, action_ret);
 
-		raw_spin_lock_irq(&desc->lock);
-		if (unlikely(irqd_irq_disabled(&desc->irq_data))) {
-			/*
-			 * CHECKME: We might need a dedicated
-			 * IRQ_THREAD_PENDING flag here, which
-			 * retriggers the thread in check_irq_resend()
-			 * but AFAICT IRQS_PENDING should be fine as it
-			 * retriggers the interrupt itself --- tglx
-			 */
-			desc->istate |= IRQS_PENDING;
-			raw_spin_unlock_irq(&desc->lock);
-		} else {
-			irqreturn_t action_ret;
-
-			raw_spin_unlock_irq(&desc->lock);
-			action_ret = handler_fn(desc, action);
-			if (!noirqdebug)
-				note_interrupt(action->irq, desc, action_ret);
-		}
-
-		wake = atomic_dec_and_test(&desc->threads_active);
-
-		if (wake && waitqueue_active(&desc->wait_for_threads))
-			wake_up(&desc->wait_for_threads);
+		wake_threads_waitq(desc);
 	}
 
-	/* Prevent a stale desc->threads_oneshot */
-	irq_finalize_oneshot(desc, action, true);
-
 	/*
-	 * Clear irqaction. Otherwise exit_irq_thread() would make
+	 * This is the regular exit path. __free_irq() is stopping the
+	 * thread via kthread_stop() after calling
+	 * synchronize_irq(). So neither IRQTF_RUNTHREAD nor the
+	 * oneshot mask bit can be set. We cannot verify that as we
+	 * cannot touch the oneshot mask at this point anymore as
+	 * __setup_irq() might have given out currents thread_mask
+	 * again.
+	 *
+	 * Clear irq_thread. Otherwise exit_irq_thread() would make
 	 * fuzz about an active irq thread going into nirvana.
 	 */
-	current->irqaction = NULL;
+	current->irq_thread = 0;
 	return 0;
 }
 
@@ -832,27 +823,28 @@ void exit_irq_thread(void)
 {
 	struct task_struct *tsk = current;
 	struct irq_desc *desc;
+	struct irqaction *action;
 
-	if (!tsk->irqaction)
+	if (!tsk->irq_thread)
 		return;
 
+	action = kthread_data(tsk);
+
 	printk(KERN_ERR
 	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, tsk->irqaction->irq);
+	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
 
-	desc = irq_to_desc(tsk->irqaction->irq);
+	desc = irq_to_desc(action->irq);
 
 	/*
-	 * Prevent a stale desc->threads_oneshot. Must be called
-	 * before setting the IRQTF_DIED flag.
+	 * If IRQTF_RUNTHREAD is set, we need to decrement
+	 * desc->threads_active and wake possible waiters.
 	 */
-	irq_finalize_oneshot(desc, tsk->irqaction, true);
+	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		wake_threads_waitq(desc);
 
-	/*
-	 * Set the THREAD DIED flag to prevent further wakeups of the
-	 * soon to be gone threaded handler.
-	 */
-	set_bit(IRQTF_DIED, &tsk->irqaction->flags);
+	/* Prevent a stale desc->threads_oneshot */
+	irq_finalize_oneshot(desc, action, true);
 }
 
 static void irq_setup_forced_threading(struct irqaction *new)
@@ -1135,8 +1127,7 @@ out_thread:
 		struct task_struct *t = new->thread;
 
 		new->thread = NULL;
-		if (likely(!test_bit(IRQTF_DIED, &new->thread_flags)))
-			kthread_stop(t);
+		kthread_stop(t);
 		put_task_struct(t);
 	}
 out_mput:
@@ -1246,8 +1237,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 #endif
 
 	if (action->thread) {
-		if (!test_bit(IRQTF_DIED, &action->thread_flags))
-			kthread_stop(action->thread);
+		kthread_stop(action->thread);
 		put_task_struct(action->thread);
 	}
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..c82d95a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -310,31 +310,21 @@ void irq_enter(void)
 	__irq_enter();
 }
 
-#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads)
+	if (!force_irqthreads) {
+#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
-	else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
-		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
-}
 #else
-static inline void invoke_softirq(void)
-{
-	if (!force_irqthreads)
 		do_softirq();
-	else {
+#endif
+	} else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
 		__local_bh_enable(SOFTIRQ_OFFSET);
 	}
 }
-#endif
 
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
