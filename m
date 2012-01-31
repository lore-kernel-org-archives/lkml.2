Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2AaNcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:32:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57356 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2AaNcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:32:11 -0500
Message-ID: <1328016724.2446.229.camel@twins>
Subject: [RFC][PATCH] srcu: Implement call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Avi Kiviti <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 31 Jan 2012 14:32:04 +0100
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: srcu: Implement call_srcu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jan 30 23:20:49 CET 2012

Implement call_srcu() by using a state machine driven by
call_rcu_sched() and timer callbacks.

The state machine is a direct derivation of the existing
synchronize_srcu() code and replaces synchronize_sched() calls with a
call_rcu_sched() callback and the schedule_timeout() calls with simple
timer callbacks.

It then re-implements synchronize_srcu() using a completion where we
send the complete through call_srcu().

It completely wrecks synchronize_srcu_expedited() which is only used
by KVM. 3 of the 5 use cases look like they really want to use
call_srcu() instead, the remaining 2 I don't know but hope they can,
which would let us remove it.

Compile tested only!! :-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/srcu.h |   23 +++
 kernel/srcu.c        |  304 +++++++++++++++++++++++++++++----------------------
 2 files changed, 196 insertions(+), 131 deletions(-)

--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -27,17 +27,35 @@
 #ifndef _LINUX_SRCU_H
 #define _LINUX_SRCU_H
 
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/timer.h>
 
 struct srcu_struct_array {
 	int c[2];
 };
 
+enum srcu_state {
+	srcu_idle,
+	srcu_sync_1,
+	srcu_sync_2,
+	srcu_sync_2b,
+	srcu_wait,
+	srcu_wait_b,
+	srcu_sync_3,
+	srcu_sync_3b,
+};
+
 struct srcu_struct {
 	int completed;
 	struct srcu_struct_array __percpu *per_cpu_ref;
-	struct mutex mutex;
+	raw_spinlock_t lock;
+	enum srcu_state state;
+	union {
+		struct rcu_head head;
+		struct timer_list timer;
+	};
+	struct rcu_head *pending[2];
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
@@ -73,6 +91,7 @@ void __srcu_read_unlock(struct srcu_stru
 void synchronize_srcu(struct srcu_struct *sp);
 void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
+void call_srcu(struct srcu_struct *sp, struct rcu_head *head, void (*func)(struct rcu_head *));
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -16,6 +16,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
+ * Copyright (C) 2012 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
  *
@@ -33,11 +34,14 @@
 #include <linux/smp.h>
 #include <linux/delay.h>
 #include <linux/srcu.h>
+#include <linux/completion.h>
 
 static int init_srcu_struct_fields(struct srcu_struct *sp)
 {
 	sp->completed = 0;
-	mutex_init(&sp->mutex);
+	raw_spin_lock_init(&sp->lock);
+	sp->state = srcu_idle;
+	sp->pending[0] = sp->pending[1] = NULL;
 	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
 	return sp->per_cpu_ref ? 0 : -ENOMEM;
 }
@@ -155,119 +159,190 @@ void __srcu_read_unlock(struct srcu_stru
 }
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
-/*
- * We use an adaptive strategy for synchronize_srcu() and especially for
- * synchronize_srcu_expedited().  We spin for a fixed time period
- * (defined below) to allow SRCU readers to exit their read-side critical
- * sections.  If there are still some readers after 10 microseconds,
- * we repeatedly block for 1-millisecond time periods.  This approach
- * has done well in testing, so there is no need for a config parameter.
+
+/**
+ * synchronize_srcu_expedited - like synchronize_srcu, but less patient
+ * @sp: srcu_struct with which to synchronize.
+ *
+ * Note that it is illegal to call synchronize_srcu_expedited()
+ * from the corresponding SRCU read-side critical section; doing so
+ * will result in deadlock.  However, it is perfectly legal to call
+ * synchronize_srcu_expedited() on one srcu_struct from some other
+ * srcu_struct's read-side critical section.
  */
-#define SYNCHRONIZE_SRCU_READER_DELAY 10
+void synchronize_srcu_expedited(struct srcu_struct *sp)
+{
+	/* XXX kill me */
+	synchronize_srcu(sp);
+}
+EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
-/*
- * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
+/**
+ * srcu_batches_completed - return batches completed.
+ * @sp: srcu_struct on which to report batch completion.
+ *
+ * Report the number of batches, correlated with, but not necessarily
+ * precisely the same as, the number of grace periods that have elapsed.
  */
-static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
+long srcu_batches_completed(struct srcu_struct *sp)
 {
-	int idx;
+	return sp->completed;
+}
+EXPORT_SYMBOL_GPL(srcu_batches_completed);
+
+static void do_srcu_state(struct srcu_struct *sp);
 
-	idx = sp->completed;
-	mutex_lock(&sp->mutex);
+static void do_srcu_state_timer(unsigned long __data)
+{
+	struct srcu_struct *sp = (void *)__data;
+	do_srcu_state(sp);
+}
 
-	/*
-	 * Check to see if someone else did the work for us while we were
-	 * waiting to acquire the lock.  We need -two- advances of
-	 * the counter, not just one.  If there was but one, we might have
-	 * shown up -after- our helper's first synchronize_sched(), thus
-	 * having failed to prevent CPU-reordering races with concurrent
-	 * srcu_read_unlock()s on other CPUs (see comment below).  So we
-	 * either (1) wait for two or (2) supply the second ourselves.
-	 */
+static void do_srcu_state_rcu(struct rcu_head *head)
+{
+	struct srcu_struct *sp = container_of(head, struct srcu_struct, head);
+	do_srcu_state(sp);
+}
 
-	if ((sp->completed - idx) >= 2) {
-		mutex_unlock(&sp->mutex);
-		return;
+static void do_srcu_state(struct srcu_struct *sp)
+{
+	struct rcu_head *head, *next;
+	unsigned long flags;
+	int idx;
+
+	raw_spin_lock_irqsave(&sp->lock, flags);
+	switch (sp->state) {
+	case srcu_idle:
+		BUG();
+
+	case srcu_sync_1:
+		/*
+		 * The preceding synchronize_sched() ensures that any CPU that
+		 * sees the new value of sp->completed will also see any
+		 * preceding changes to data structures made by this CPU.  This
+		 * prevents some other CPU from reordering the accesses in its
+		 * SRCU read-side critical section to precede the corresponding
+		 * srcu_read_lock() -- ensuring that such references will in
+		 * fact be protected.
+		 *
+		 * So it is now safe to do the flip.
+		 */
+		idx = sp->completed & 0x1;
+		sp->completed++;
+
+		sp->state = srcu_sync_2 + idx;
+		call_rcu_sched(&sp->head, do_srcu_state_rcu);
+		break;
+
+	case srcu_sync_2:
+	case srcu_sync_2b:
+		idx = sp->state - srcu_sync_2;
+
+		init_timer(&sp->timer);
+		sp->timer.data = (unsigned long)sp;
+		sp->timer.function = do_srcu_state_timer;
+		sp->state = srcu_wait + idx;
+
+		/*
+		 * At this point, because of the preceding synchronize_sched(),
+		 * all srcu_read_lock() calls using the old counters have
+		 * completed. Their corresponding critical sections might well
+		 * be still executing, but the srcu_read_lock() primitives
+		 * themselves will have finished executing.
+		 */
+test_pending:
+		if (!srcu_readers_active_idx(sp, idx)) {
+			sp->state = srcu_sync_3 + idx;
+			call_rcu_sched(&sp->head, do_srcu_state_rcu);
+			break;
+		}
+
+		mod_timer(&sp->timer, jiffies + 1);
+		break;
+
+	case srcu_wait:
+	case srcu_wait_b:
+		idx = sp->state - srcu_wait;
+		goto test_pending;
+
+	case srcu_sync_3:
+	case srcu_sync_3b:
+		idx = sp->state - srcu_sync_3;
+		/*
+		 * The preceding synchronize_sched() forces all
+		 * srcu_read_unlock() primitives that were executing
+		 * concurrently with the preceding for_each_possible_cpu() loop
+		 * to have completed by this point. More importantly, it also
+		 * forces the corresponding SRCU read-side critical sections to
+		 * have also completed, and the corresponding references to
+		 * SRCU-protected data items to be dropped.
+		 */
+		head = sp->pending[idx];
+		sp->pending[idx] = NULL;
+		raw_spin_unlock(&sp->lock);
+		while (head) {
+			next = head->next;
+			head->func(head);
+			head = next;
+		}
+		raw_spin_lock(&sp->lock);
+
+		/*
+		 * If there's a new batch waiting...
+		 */
+		if (sp->pending[idx ^ 1]) {
+			sp->state = srcu_sync_1;
+			call_rcu_sched(&sp->head, do_srcu_state_rcu);
+			break;
+		}
+
+		/*
+		 * We done!!
+		 */
+		sp->state = srcu_idle;
+		break;
 	}
+	raw_spin_unlock_irqrestore(&sp->lock, flags);
+}
 
-	sync_func();  /* Force memory barrier on all CPUs. */
+void call_srcu(struct srcu_struct *sp,
+	       struct rcu_head *head, void (*func)(struct rcu_head *))
+{
+	unsigned long flags;
+	int idx;
 
-	/*
-	 * The preceding synchronize_sched() ensures that any CPU that
-	 * sees the new value of sp->completed will also see any preceding
-	 * changes to data structures made by this CPU.  This prevents
-	 * some other CPU from reordering the accesses in its SRCU
-	 * read-side critical section to precede the corresponding
-	 * srcu_read_lock() -- ensuring that such references will in
-	 * fact be protected.
-	 *
-	 * So it is now safe to do the flip.
-	 */
+	head->func = func;
 
-	idx = sp->completed & 0x1;
-	sp->completed++;
+	raw_spin_lock_irqsave(&sp->lock, flags);
+	idx = sp->completed & 1;
+	barrier(); /* look at sp->completed once */
+	head->next = sp->pending[idx];
+	sp->pending[idx] = head;
+
+	if (sp->state == srcu_idle) {
+		sp->state = srcu_sync_1;
+		call_rcu_sched(&sp->head, do_srcu_state_rcu);
+	}
+	raw_spin_unlock_irqrestore(&sp->lock, flags);
+}
+EXPORT_SYMBOL_GPL(call_srcu);
 
-	sync_func();  /* Force memory barrier on all CPUs. */
+struct srcu_waiter {
+	struct completion wait;
+	struct rcu_head head;
+};
 
-	/*
-	 * At this point, because of the preceding synchronize_sched(),
-	 * all srcu_read_lock() calls using the old counters have completed.
-	 * Their corresponding critical sections might well be still
-	 * executing, but the srcu_read_lock() primitives themselves
-	 * will have finished executing.  We initially give readers
-	 * an arbitrarily chosen 10 microseconds to get out of their
-	 * SRCU read-side critical sections, then loop waiting 1/HZ
-	 * seconds per iteration.  The 10-microsecond value has done
-	 * very well in testing.
-	 */
-
-	if (srcu_readers_active_idx(sp, idx))
-		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
-	while (srcu_readers_active_idx(sp, idx))
-		schedule_timeout_interruptible(1);
-
-	sync_func();  /* Force memory barrier on all CPUs. */
-
-	/*
-	 * The preceding synchronize_sched() forces all srcu_read_unlock()
-	 * primitives that were executing concurrently with the preceding
-	 * for_each_possible_cpu() loop to have completed by this point.
-	 * More importantly, it also forces the corresponding SRCU read-side
-	 * critical sections to have also completed, and the corresponding
-	 * references to SRCU-protected data items to be dropped.
-	 *
-	 * Note:
-	 *
-	 *	Despite what you might think at first glance, the
-	 *	preceding synchronize_sched() -must- be within the
-	 *	critical section ended by the following mutex_unlock().
-	 *	Otherwise, a task taking the early exit can race
-	 *	with a srcu_read_unlock(), which might have executed
-	 *	just before the preceding srcu_readers_active() check,
-	 *	and whose CPU might have reordered the srcu_read_unlock()
-	 *	with the preceding critical section.  In this case, there
-	 *	is nothing preventing the synchronize_sched() task that is
-	 *	taking the early exit from freeing a data structure that
-	 *	is still being referenced (out of order) by the task
-	 *	doing the srcu_read_unlock().
-	 *
-	 *	Alternatively, the comparison with "2" on the early exit
-	 *	could be changed to "3", but this increases synchronize_srcu()
-	 *	latency for bulk loads.  So the current code is preferred.
-	 */
+static void synchronize_srcu_complete(struct rcu_head *head)
+{
+	struct srcu_waiter *waiter = container_of(head, struct srcu_waiter, head);
 
-	mutex_unlock(&sp->mutex);
+	complete(&waiter->wait);
 }
 
 /**
  * synchronize_srcu - wait for prior SRCU read-side critical-section completion
  * @sp: srcu_struct with which to synchronize.
  *
- * Flip the completed counter, and wait for the old count to drain to zero.
- * As with classic RCU, the updater must use some separate means of
- * synchronizing concurrent updates.  Can block; must be called from
- * process context.
- *
  * Note that it is illegal to call synchronize_srcu() from the corresponding
  * SRCU read-side critical section; doing so will result in deadlock.
  * However, it is perfectly legal to call synchronize_srcu() on one
@@ -275,41 +350,12 @@ static void __synchronize_srcu(struct sr
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, synchronize_sched);
-}
-EXPORT_SYMBOL_GPL(synchronize_srcu);
+	struct srcu_waiter waiter = {
+		.wait = COMPLETION_INITIALIZER_ONSTACK(waiter.wait),
+	};
 
-/**
- * synchronize_srcu_expedited - like synchronize_srcu, but less patient
- * @sp: srcu_struct with which to synchronize.
- *
- * Flip the completed counter, and wait for the old count to drain to zero.
- * As with classic RCU, the updater must use some separate means of
- * synchronizing concurrent updates.  Can block; must be called from
- * process context.
- *
- * Note that it is illegal to call synchronize_srcu_expedited()
- * from the corresponding SRCU read-side critical section; doing so
- * will result in deadlock.  However, it is perfectly legal to call
- * synchronize_srcu_expedited() on one srcu_struct from some other
- * srcu_struct's read-side critical section.
- */
-void synchronize_srcu_expedited(struct srcu_struct *sp)
-{
-	__synchronize_srcu(sp, synchronize_sched_expedited);
-}
-EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
-
-/**
- * srcu_batches_completed - return batches completed.
- * @sp: srcu_struct on which to report batch completion.
- *
- * Report the number of batches, correlated with, but not necessarily
- * precisely the same as, the number of grace periods that have elapsed.
- */
+	call_srcu(sp, &waiter.head, synchronize_srcu_complete);
 
-long srcu_batches_completed(struct srcu_struct *sp)
-{
-	return sp->completed;
+	wait_for_completion(&waiter.wait);
 }
-EXPORT_SYMBOL_GPL(srcu_batches_completed);
+EXPORT_SYMBOL_GPL(synchronize_srcu);

