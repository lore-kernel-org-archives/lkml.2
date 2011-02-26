Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1BZQWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 11:22:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:40214 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab1BZQWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 11:22:22 -0500
Date: Sat, 26 Feb 2011 16:22:02 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110223234956.388095876@linutronix.de>
References: <20110223234956.388095876@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Prepare the handling of shared oneshot interrupts
Message-ID: <tip-b5faba21a6805c33b40e258d36f57997ee1de131@git.kernel.org>
Git-Commit-ID: b5faba21a6805c33b40e258d36f57997ee1de131
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Feb 2011 16:22:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5faba21a6805c33b40e258d36f57997ee1de131
Gitweb:     http://git.kernel.org/tip/b5faba21a6805c33b40e258d36f57997ee1de131
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 23 Feb 2011 23:52:13 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 25 Feb 2011 20:24:21 +0100

genirq: Prepare the handling of shared oneshot interrupts

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
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110223234956.388095876@linutronix.de>
---
 include/linux/interrupt.h |    2 +
 include/linux/irqdesc.h   |    2 +
 kernel/irq/handle.c       |   76 +++++++++++++++++++++++++++++++++++++--------
 kernel/irq/manage.c       |   54 ++++++++++++++++++++++++++++---
 4 files changed, 115 insertions(+), 19 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 8da6643..e116fef 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -99,6 +99,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
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
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 2f87d64..9eb9cd3 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
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
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index b110c83..517561f 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -51,6 +51,68 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 	       "but no thread function available.", irq, action->name);
 }
 
+static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
+{
+	/*
+	 * Wake up the handler thread for this action. In case the
+	 * thread crashed and was killed we just pretend that we
+	 * handled the interrupt. The hardirq handler has disabled the
+	 * device interrupt, so no irq storm is lurking. If the
+	 * RUNTHREAD bit is already set, nothing to do.
+	 */
+	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
+	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		return;
+
+	/*
+	 * It's safe to OR the mask lockless here. We have only two
+	 * places which write to threads_oneshot: This code and the
+	 * irq thread.
+	 *
+	 * This code is the hard irq context and can never run on two
+	 * cpus in parallel. If it ever does we have more serious
+	 * problems than this bitmask.
+	 *
+	 * The irq threads of this irq which clear their "running" bit
+	 * in threads_oneshot are serialized via desc->lock against
+	 * each other and they are serialized against this code by
+	 * IRQS_INPROGRESS.
+	 *
+	 * Hard irq handler:
+	 *
+	 *	spin_lock(desc->lock);
+	 *	desc->state |= IRQS_INPROGRESS;
+	 *	spin_unlock(desc->lock);
+	 *	set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
+	 *	desc->threads_oneshot |= mask;
+	 *	spin_lock(desc->lock);
+	 *	desc->state &= ~IRQS_INPROGRESS;
+	 *	spin_unlock(desc->lock);
+	 *
+	 * irq thread:
+	 *
+	 * again:
+	 *	spin_lock(desc->lock);
+	 *	if (desc->state & IRQS_INPROGRESS) {
+	 *		spin_unlock(desc->lock);
+	 *		while(desc->state & IRQS_INPROGRESS)
+	 *			cpu_relax();
+	 *		goto again;
+	 *	}
+	 *	if (!test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	 *		desc->threads_oneshot &= ~mask;
+	 *	spin_unlock(desc->lock);
+	 *
+	 * So either the thread waits for us to clear IRQS_INPROGRESS
+	 * or we are waiting in the flow handler for desc->lock to be
+	 * released before we reach this point. The thread also checks
+	 * IRQTF_RUNTHREAD under desc->lock. If set it leaves
+	 * threads_oneshot untouched and runs the thread another time.
+	 */
+	desc->threads_oneshot |= action->thread_mask;
+	wake_up_process(action->thread);
+}
+
 irqreturn_t
 handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
@@ -85,19 +147,7 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
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
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 01f8a95..2301de1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -617,8 +617,11 @@ static int irq_wait_for_interrupt(struct irqaction *action)
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
@@ -631,6 +634,11 @@ again:
 	 * on the other CPU. If we unmask the irq line then the
 	 * interrupt can come in again and masks the line, leaves due
 	 * to IRQS_INPROGRESS and the irq line is masked forever.
+	 *
+	 * This also serializes the state of shared oneshot handlers
+	 * versus "desc->threads_onehsot |= action->thread_mask;" in
+	 * irq_wake_thread(). See the comment there which explains the
+	 * serialization.
 	 */
 	if (unlikely(desc->istate & IRQS_INPROGRESS)) {
 		raw_spin_unlock_irq(&desc->lock);
@@ -639,11 +647,23 @@ again:
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
@@ -691,7 +711,7 @@ static int irq_thread(void *data)
 	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	int wake, oneshot = desc->istate & IRQS_ONESHOT;
+	int wake;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
@@ -719,8 +739,7 @@ static int irq_thread(void *data)
 
 			action->thread_fn(action->irq, action->dev_id);
 
-			if (oneshot)
-				irq_finalize_oneshot(action->irq, desc);
+			irq_finalize_oneshot(desc, action, false);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -729,6 +748,9 @@ static int irq_thread(void *data)
 			wake_up(&desc->wait_for_threads);
 	}
 
+	/* Prevent a stale desc->threads_oneshot */
+	irq_finalize_oneshot(desc, action, true);
+
 	/*
 	 * Clear irqaction. Otherwise exit_irq_thread() would make
 	 * fuzz about an active irq thread going into nirvana.
@@ -743,6 +765,7 @@ static int irq_thread(void *data)
 void exit_irq_thread(void)
 {
 	struct task_struct *tsk = current;
+	struct irq_desc *desc;
 
 	if (!tsk->irqaction)
 		return;
@@ -751,6 +774,14 @@ void exit_irq_thread(void)
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
@@ -767,7 +798,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 {
 	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
-	unsigned long flags;
+	unsigned long flags, thread_mask = 0;
 	int ret, nested, shared = 0;
 	cpumask_var_t mask;
 
@@ -865,12 +896,23 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
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
 
