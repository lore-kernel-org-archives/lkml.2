Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1BWXxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:53:07 -0500
Received: from www.tglx.de ([62.245.132.106]:56026 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab1BWXxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:53:02 -0500
Message-Id: <20110223234956.388095876@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 23 Feb 2011 23:52:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/5] genirq: Prepare the handling of shared oneshot interrupts
References: <20110223231601.613115832@linutronix.de>
Content-Disposition: inline;
	filename=genirq-prepare-handling-shared-oneshot-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For level type interrupts we need to track how many threads are on
flight to avoid useless interrupt storms when not all thread handlers
have finished yet. Keep track of the woken threads and only unmask
when there are no more threads in flight.

Yes, I'm lazy and using a bitfield. But not only because I'm lazy, the
main reason is that it's way simpler than using a refcount. A refcount
based solution would need to keep track of various things like
crashing the irq thread, spurious interrupts coming in,
disables/enables, free_irq() and some more. The bitfield keeps the
tracking simple and makes things just work. It's also nicely confined
to the thread code pathes and does not require additional checks all
over the place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    2 +
 include/linux/irqdesc.h   |    2 +
 kernel/irq/handle.c       |   34 ++++++++++++++++++-----------
 kernel/irq/manage.c       |   53 ++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 72 insertions(+), 19 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -99,6 +99,7 @@ typedef irqreturn_t (*irq_handler_t)(int
  * @thread_fn:	interupt handler function for threaded interrupts
  * @thread:	thread pointer for threaded interrupts
  * @thread_flags:	flags related to @thread
+ * @thread_mask:	bitmask for keeping track of @thread activity
  */
 struct irqaction {
 	irq_handler_t handler;
@@ -109,6 +110,7 @@ struct irqaction {
 	irq_handler_t thread_fn;
 	struct task_struct *thread;
 	unsigned long thread_flags;
+	unsigned long thread_mask;
 	const char *name;
 	struct proc_dir_entry *dir;
 } ____cacheline_internodealigned_in_smp;
Index: linux-2.6-tip/include/linux/irqdesc.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqdesc.h
+++ linux-2.6-tip/include/linux/irqdesc.h
@@ -28,6 +28,7 @@ struct timer_rand_state;
  * @lock:		locking for SMP
  * @affinity_notify:	context for notification of affinity changes
  * @pending_mask:	pending rebalanced interrupts
+ * @threads_oneshot:	bitfield to handle shared oneshot threads
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
  * @dir:		/proc/irq/ procfs entry
@@ -86,6 +87,7 @@ struct irq_desc {
 	cpumask_var_t		pending_mask;
 #endif
 #endif
+	unsigned long		threads_oneshot;
 	atomic_t		threads_active;
 	wait_queue_head_t       wait_for_threads;
 #ifdef CONFIG_PROC_FS
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -51,6 +51,26 @@ static void warn_no_thread(unsigned int 
 	       "but no thread function available.", irq, action->name);
 }
 
+static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
+{
+	/*
+	 * Wake up the handler thread for this action. In case the
+	 * thread crashed and was killed we just pretend that we
+	 * handled the interrupt. The hardirq handler has disabled the
+	 * device interrupt, so no irq storm is lurking.
+	 */
+	if (!test_bit(IRQTF_DIED, &action->thread_flags) &&
+	    !test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags)) {
+		/*
+		 * We or the mask lockless. Safe because the code
+		 * which clears the mask is serialized
+		 * vs. IRQ_INPROGRESS.
+		 */
+		desc->threads_oneshot |= action->thread_mask;
+		wake_up_process(action->thread);
+	}
+}
+
 irqreturn_t
 handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
@@ -84,19 +104,7 @@ handle_irq_event_percpu(struct irq_desc 
 				break;
 			}
 
-			/*
-			 * Wake up the handler thread for this
-			 * action. In case the thread crashed and was
-			 * killed we just pretend that we handled the
-			 * interrupt. The hardirq handler above has
-			 * disabled the device interrupt, so no irq
-			 * storm is lurking.
-			 */
-			if (likely(!test_bit(IRQTF_DIED,
-					     &action->thread_flags))) {
-				set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
-				wake_up_process(action->thread);
-			}
+			irq_wake_thread(desc, action);
 
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -617,8 +617,11 @@ static int irq_wait_for_interrupt(struct
  * handler finished. unmask if the interrupt has not been disabled and
  * is marked MASKED.
  */
-static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
+static void irq_finalize_oneshot(struct irq_desc *desc,
+				 struct irqaction *action, bool force)
 {
+	if (!(desc->istate & IRQS_ONESHOT))
+		return;
 again:
 	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
@@ -631,6 +634,10 @@ again:
 	 * on the other CPU. If we unmask the irq line then the
 	 * interrupt can come in again and masks the line, leaves due
 	 * to IRQS_INPROGRESS and the irq line is masked forever.
+	 *
+	 * This also serializes the state of shared oneshot handlers
+	 * versus "desc->threads_onehsot |= action->thread_mask;" in
+	 * handle_irq_event().
 	 */
 	if (unlikely(desc->istate & IRQS_INPROGRESS)) {
 		raw_spin_unlock_irq(&desc->lock);
@@ -639,11 +646,23 @@ again:
 		goto again;
 	}
 
-	if (!(desc->istate & IRQS_DISABLED) && (desc->istate & IRQS_MASKED)) {
+	/*
+	 * Now check again, whether the thread should run. Otherwise
+	 * we would clear the threads_oneshot bit of this thread which
+	 * was just set.
+	 */
+	if (!force && test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		goto out_unlock;
+
+	desc->threads_oneshot &= ~action->thread_mask;
+
+	if (!desc->threads_oneshot && !(desc->istate & IRQS_DISABLED) &&
+	    (desc->istate & IRQS_MASKED)) {
 		irq_compat_clr_masked(desc);
 		desc->istate &= ~IRQS_MASKED;
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 	}
+out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(desc);
 }
@@ -691,7 +710,7 @@ static int irq_thread(void *data)
 	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	int wake, oneshot = desc->istate & IRQS_ONESHOT;
+	int wake;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
@@ -719,8 +738,7 @@ static int irq_thread(void *data)
 
 			action->thread_fn(action->irq, action->dev_id);
 
-			if (oneshot)
-				irq_finalize_oneshot(action->irq, desc);
+			irq_finalize_oneshot(desc, action, false);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -729,6 +747,9 @@ static int irq_thread(void *data)
 			wake_up(&desc->wait_for_threads);
 	}
 
+	/* Prevent a stale desc->threads_oneshot */
+	irq_finalize_oneshot(desc, action, true);
+
 	/*
 	 * Clear irqaction. Otherwise exit_irq_thread() would make
 	 * fuzz about an active irq thread going into nirvana.
@@ -743,6 +764,7 @@ static int irq_thread(void *data)
 void exit_irq_thread(void)
 {
 	struct task_struct *tsk = current;
+	struct irq_desc *desc;
 
 	if (!tsk->irqaction)
 		return;
@@ -751,6 +773,14 @@ void exit_irq_thread(void)
 	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
 	       tsk->comm ? tsk->comm : "", tsk->pid, tsk->irqaction->irq);
 
+	desc = irq_to_desc(tsk->irqaction->irq);
+
+	/*
+	 * Prevent a stale desc->threads_oneshot. Must be called
+	 * before setting the IRQTF_DIED flag.
+	 */
+	irq_finalize_oneshot(desc, tsk->irqaction, true);
+
 	/*
 	 * Set the THREAD DIED flag to prevent further wakeups of the
 	 * soon to be gone threaded handler.
@@ -767,7 +797,7 @@ __setup_irq(unsigned int irq, struct irq
 {
 	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
-	unsigned long flags;
+	unsigned long flags, thread_mask = 0;
 	int ret, nested, shared = 0;
 	cpumask_var_t mask;
 
@@ -865,12 +895,23 @@ __setup_irq(unsigned int irq, struct irq
 
 		/* add new interrupt at end of irq queue */
 		do {
+			thread_mask |= old->thread_mask;
 			old_ptr = &old->next;
 			old = *old_ptr;
 		} while (old);
 		shared = 1;
 	}
 
+	/*
+	 * Setup the thread mask for this irqaction. Unlikely to have
+	 * 32 resp 64 irqs sharing one line, but who knows.
+	 */
+	if (new->flags & IRQF_ONESHOT && thread_mask == ~0UL) {
+		ret = -EBUSY;
+		goto out_mask;
+	}
+	new->thread_mask = 1 << ffz(thread_mask);
+
 	if (!shared) {
 		irq_chip_set_defaults(desc->irq_data.chip);
 


