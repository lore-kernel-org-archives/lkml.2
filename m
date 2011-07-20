Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1GTATv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:19:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49169 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab1GTATu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:19:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 4/7] rcu: protect __rcu_read_unlock() against scheduler-using irq handlers
Date: Tue, 19 Jul 2011 17:18:20 -0700
Message-Id: <1311121103-16978-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110720001738.GA16369@linux.vnet.ibm.com>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The addition of RCU read-side critical sections within runqueue and
priority-inheritance lock critical sections introduced some deadlock
cycles, for example, involving interrupts from __rcu_read_unlock()
where the interrupt handlers call wake_up().  This situation can cause
the instance of __rcu_read_unlock() invoked from interrupt to do some
of the processing that would otherwise have been carried out by the
task-level instance of __rcu_read_unlock().  When the interrupt-level
instance of __rcu_read_unlock() is called with a scheduler lock held
from interrupt-entry/exit situations where in_irq() returns false,
deadlock can result.

This commit resolves these deadlocks by using negative values of
the per-task ->rcu_read_lock_nesting counter to indicate that an
instance of __rcu_read_unlock() is in flight, which in turn prevents
instances from interrupt handlers from doing any special processing.
This patch is inspired by Steven Rostedt's earlier patch that similarly
made __rcu_read_unlock() guard against interrupt-mediated recursion
(see https://lkml.org/lkml/2011/7/15/326), but this commit refines
Steven's approach to avoid the need for preemption disabling on the
__rcu_read_unlock() fastpath and to also avoid the need for manipulating
a separate per-CPU variable.

This patch avoids need for preempt_disable() by instead using negative
values of the per-task ->rcu_read_lock_nesting counter.  Note that nested
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
which could result in deadlock if that critical section happened to be in
the scheduler where the runqueue or priority-inheritance locks were held.

This situation is dealt with by making rcu_preempt_note_context_switch()
check for negative ->rcu_read_lock_nesting, thus refraining from
queuing the task (and from setting RCU_READ_UNLOCK_BLOCKED) if we are
already exiting from the outermost RCU read-side critical section (in
other words, we really are no longer actually in that RCU read-side
critical section).  In addition, rcu_preempt_note_context_switch()
invokes rcu_read_unlock_special() to carry out the cleanup in this case,
which clears out the ->rcu_read_unlock_special bits and dequeues the task
(if necessary), in turn avoiding needless delay of the current RCU grace
period and needless RCU priority boosting.

It is still illegal to call rcu_read_unlock() while holding a scheduler
lock if the prior RCU read-side critical section has ever had either
preemption or irqs enabled.  However, the common use case is legal,
namely where then entire RCU read-side critical section executes with
irqs disabled, for example, when the scheduler lock is held across the
entire lifetime of the RCU read-side critical section.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 9439a25..ad4539a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -68,6 +68,7 @@ struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
+static void rcu_read_unlock_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
 /*
@@ -147,7 +148,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
-	if (t->rcu_read_lock_nesting &&
+	if (t->rcu_read_lock_nesting > 0 &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
@@ -190,6 +191,14 @@ static void rcu_preempt_note_context_switch(int cpu)
 				rnp->gp_tasks = &t->rcu_node_entry;
 		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	} else if (t->rcu_read_lock_nesting < 0 &&
+		   t->rcu_read_unlock_special) {
+
+		/*
+		 * Complete exit from RCU read-side critical section on
+		 * behalf of preempted instance of __rcu_read_unlock().
+		 */
+		rcu_read_unlock_special(t);
 	}
 
 	/*
@@ -391,10 +400,15 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
-	if (--t->rcu_read_lock_nesting == 0) {
-		barrier();  /* decr before ->rcu_read_unlock_special load */
+	if (t->rcu_read_lock_nesting != 1)
+		--t->rcu_read_lock_nesting;
+	else {
+		t->rcu_read_lock_nesting = INT_MIN;
+		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
+		barrier();  /* ->rcu_read_unlock_special load before assign */
+		t->rcu_read_lock_nesting = 0;
 	}
 #ifdef CONFIG_PROVE_LOCKING
 	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
@@ -593,7 +607,8 @@ static void rcu_preempt_check_callbacks(int cpu)
 		rcu_preempt_qs(cpu);
 		return;
 	}
-	if (per_cpu(rcu_preempt_data, cpu).qs_pending)
+	if (t->rcu_read_lock_nesting > 0 &&
+	    per_cpu(rcu_preempt_data, cpu).qs_pending)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
-- 
1.7.3.2

