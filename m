Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2BATyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:54:06 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44342 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab2BATmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:36 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 18/41] rcu: Protect __rcu_read_unlock() against scheduler-using irq handlers
Date: Wed,  1 Feb 2012 11:41:36 -0800
Message-Id: <1328125319-5205-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5518-0000-0000-000001F05D49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit ports commit #10f39bb1b2 (rcu: protect __rcu_read_unlock()
against scheduler-using irq handlers) from TREE_PREEMPT_RCU to
TINY_PREEMPT_RCU.  The following is a corresponding port of that
commit message.

The addition of RCU read-side critical sections within runqueue and
priority-inheritance critical sections introduced some deadlocks,
for example, involving interrupts from __rcu_read_unlock() where the
interrupt handlers call wake_up().  This situation can cause the
instance of __rcu_read_unlock() invoked from interrupt to do some
of the processing that would otherwise have been carried out by the
task-level instance of __rcu_read_unlock().  When the interrupt-level
instance of __rcu_read_unlock() is called with a scheduler lock held from
interrupt-entry/exit situations where in_irq() returns false, deadlock can
result.  Of course, in a UP kernel, there are not really any deadlocks,
but the upper-level critical section can still be be fatally confused
by the lower-level critical section changing things out from under it.

This commit resolves these deadlocks by using negative values of the
per-task ->rcu_read_lock_nesting counter to indicate that an instance of
__rcu_read_unlock() is in flight, which in turn prevents instances from
interrupt handlers from doing any special processing.  Note that nested
rcu_read_lock()/rcu_read_unlock() pairs are still permitted, but they will
never see ->rcu_read_lock_nesting go to zero, and will therefore never
invoke rcu_read_unlock_special(), thus preventing them from seeing the
RCU_READ_UNLOCK_BLOCKED bit should it be set in ->rcu_read_unlock_special.
This patch also adds a check for ->rcu_read_unlock_special being negative
in rcu_check_callbacks(), thus preventing the RCU_READ_UNLOCK_NEED_QS
bit from being set should a scheduling-clock interrupt occur while
__rcu_read_unlock() is exiting from an outermost RCU read-side critical
section.

Of course, __rcu_read_unlock() can be preempted during the time that
->rcu_read_lock_nesting is negative.  This could result in the setting
of the RCU_READ_UNLOCK_BLOCKED bit after __rcu_read_unlock() checks it,
and would also result it this task being queued on the corresponding
rcu_node structure's blkd_tasks list.  Therefore, some later RCU read-side
critical section would enter rcu_read_unlock_special() to clean up --
which could result in deadlock (OK, OK, fatal confusion) if that RCU
read-side critical section happened to be in the scheduler where the
runqueue or priority-inheritance locks were held.

To prevent the possibility of fatal confusion that might result from
preemption during the time that ->rcu_read_lock_nesting is negative,
this commit also makes rcu_preempt_note_context_switch() check for
negative ->rcu_read_lock_nesting, thus refraining from queuing the task
(and from setting RCU_READ_UNLOCK_BLOCKED) if we are already exiting
from the outermost RCU read-side critical section (in other words,
we really are no longer actually in that RCU read-side critical
section).  In addition, rcu_preempt_note_context_switch() invokes
rcu_read_unlock_special() to carry out the cleanup in this case, which
clears out the ->rcu_read_unlock_special bits and dequeues the task
(if necessary), in turn avoiding needless delay of the current RCU grace
period and needless RCU priority boosting.

It is still illegal to call rcu_read_unlock() while holding a scheduler
lock if the prior RCU read-side critical section has ever had both
preemption and irqs enabled.  However, the common use case is legal,
namely where then entire RCU read-side critical section executes with
irqs disabled, for example, when the scheduler lock is held across the
entire lifetime of the RCU read-side critical section.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |   43 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index dd672e7..6cba20b 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -132,6 +132,7 @@ static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
 	RCU_TRACE(.rcb.name = "rcu_preempt")
 };
 
+static void rcu_read_unlock_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(void);
 static void rcu_report_exp_done(void);
 
@@ -146,6 +147,16 @@ static int rcu_cpu_blocking_cur_gp(void)
 /*
  * Check for a running RCU reader.  Because there is only one CPU,
  * there can be but one running RCU reader at a time.  ;-)
+ *
+ * Returns zero if there are no running readers.  Returns a positive
+ * number if there is at least one reader within its RCU read-side
+ * critical section.  Returns a negative number if an outermost reader
+ * is in the midst of exiting from its RCU read-side critical section
+ *
+ * Returns zero if there are no running readers.  Returns a positive
+ * number if there is at least one reader within its RCU read-side
+ * critical section.  Returns a negative number if an outermost reader
+ * is in the midst of exiting from its RCU read-side critical section.
  */
 static int rcu_preempt_running_reader(void)
 {
@@ -475,7 +486,7 @@ void rcu_preempt_note_context_switch(void)
 	unsigned long flags;
 
 	local_irq_save(flags); /* must exclude scheduler_tick(). */
-	if (rcu_preempt_running_reader() &&
+	if (rcu_preempt_running_reader() > 0 &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
@@ -494,6 +505,13 @@ void rcu_preempt_note_context_switch(void)
 		list_add(&t->rcu_node_entry, &rcu_preempt_ctrlblk.blkd_tasks);
 		if (rcu_cpu_blocking_cur_gp())
 			rcu_preempt_ctrlblk.gp_tasks = &t->rcu_node_entry;
+	} else if (rcu_preempt_running_reader() < 0 &&
+		   t->rcu_read_unlock_special) {
+		/*
+		 * Complete exit from RCU read-side critical section on
+		 * behalf of preempted instance of __rcu_read_unlock().
+		 */
+		rcu_read_unlock_special(t);
 	}
 
 	/*
@@ -618,13 +636,22 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
-	--t->rcu_read_lock_nesting;
-	barrier();  /* decrement before load of ->rcu_read_unlock_special */
-	if (t->rcu_read_lock_nesting == 0 &&
-	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-		rcu_read_unlock_special(t);
+	if (t->rcu_read_lock_nesting != 1)
+		--t->rcu_read_lock_nesting;
+	else {
+		t->rcu_read_lock_nesting = INT_MIN;
+		barrier();  /* assign before ->rcu_read_unlock_special load */
+		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+			rcu_read_unlock_special(t);
+		barrier();  /* ->rcu_read_unlock_special load before assign */
+		t->rcu_read_lock_nesting = 0;
+	}
 #ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(t->rcu_read_lock_nesting < 0);
+	{
+		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+
+		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
+	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
@@ -649,7 +676,7 @@ static void rcu_preempt_check_callbacks(void)
 		invoke_rcu_callbacks();
 	if (rcu_preempt_gp_in_progress() &&
 	    rcu_cpu_blocking_cur_gp() &&
-	    rcu_preempt_running_reader())
+	    rcu_preempt_running_reader() > 0)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
-- 
1.7.8

