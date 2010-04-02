Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0DBAx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 20:53:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39025 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab0DBAxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 20:53:24 -0400
Date: Thu, 1 Apr 2010 17:53:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: don't call rcu_preempt_note_context_switch() in
 rcu_check_callbacks()
Message-ID: <20100402005317.GI2472@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BB014DF.9030905@cn.fujitsu.com>
 <20100329044236.GB2343@linux.vnet.ibm.com>
 <4BB1C7C5.5070700@cn.fujitsu.com>
 <20100330160339.GB2513@linux.vnet.ibm.com>
 <20100331153656.GA4623@linux.vnet.ibm.com>
 <4BB3EF25.1040804@cn.fujitsu.com>
 <20100401011747.GJ2461@linux.vnet.ibm.com>
 <4BB44A15.60306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB44A15.60306@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 03:24:05PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > Possibly by moving the clearing of RCU_READ_UNLOCK_NEED_QS to
> > rcu_preempt_check_callbacks() 
> 
> current rcu_preempt_check_callbacks() already has code to
> clear RCU_READ_UNLOCK_NEED_QS.

English is failing me.  How about the following patch instead?  Untested,
probably does not even compile.

							Thanx, Paul

------------------------------------------------------------------------

>From 9a1687fcd572ef34ac394a336d6ea79974e1e7e8 Mon Sep 17 00:00:00 2001
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date: Thu, 1 Apr 2010 17:37:01 -0700
Subject: [PATCH tip/core/rcu 1/1] rcu: refactor RCU's context-switch handling

The addition of preemptible RCU to treercu resulted in a bit of
confusion and inefficiency surrounding the handling of context switches
for RCU-sched and for RCU-preempt.  For RCU-sched, a context switch
is a quiescent state, pure and simple, just like it always has been.
For RCU-preempt, a context switch is in no way a quiescent state, but
special handling is required when a task blocks in an RCU read-side
critical section.

However, the callout from the scheduler and the outer loop in ksoftirqd
still calls something named rcu_sched_qs(), whose name is no longer
accurate.  Furthermore, when rcu_check_callbacks() notes an RCU-sched
quiescent state, it ends up unnecessarily (though harmlessly, aside
from the performance hit) enqueuing the current task if it happens to
be running in an RCU-preempt read-side critical section.  This not only
increases the maximum latency of scheduler_tick(), it also needlessly
increases the overhead of the next outermost rcu_read_unlock() invocation.

This patch addresses this situation by separating the notion of RCU's
context-switch handling from that of RCU-sched's quiescent states.
The context-switch handling is covered by rcu_note_context_switch() in
general and by rcu_preempt_note_context_switch() for preemptible RCU.
This permits rcu_sched_qs() to handle quiescent states and only quiescent
states.  It also reduces the maximum latency of scheduler_tick(), though
probably by much less than a microsecond.  Finally, it means that tasks
within preemptible-RCU read-side critical sections avoid incurring the
overhead of queuing unless there really is a context switch.

Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h |    4 ++++
 include/linux/rcutree.h |    1 +
 kernel/rcutree.c        |   17 ++++++++++++-----
 kernel/rcutree_plugin.h |   11 +++++++----
 kernel/sched.c          |    2 +-
 kernel/softirq.c        |    2 +-
 6 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index bbeb55b..ff22b97 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -29,6 +29,10 @@
 
 void rcu_sched_qs(int cpu);
 void rcu_bh_qs(int cpu);
+static inline void rcu_note_context_switch(int cpu)
+{
+	rcu_sched_qs(cpu);
+}
 
 #define __rcu_read_lock()	preempt_disable()
 #define __rcu_read_unlock()	preempt_enable()
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 7484fe6..b9f7460 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -34,6 +34,7 @@ struct notifier_block;
 
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
+extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern int rcu_expedited_torture_stats(char *page);
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1309338..ffc4665 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -97,25 +97,32 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
  */
 void rcu_sched_qs(int cpu)
 {
-	struct rcu_data *rdp;
+	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
 
-	rdp = &per_cpu(rcu_sched_data, cpu);
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
-	rcu_preempt_note_context_switch(cpu);
 }
 
 void rcu_bh_qs(int cpu)
 {
-	struct rcu_data *rdp;
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
 
-	rdp = &per_cpu(rcu_bh_data, cpu);
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 }
 
+/*
+ * Note a context switch.  This is a quiescent state for RCU-sched,
+ * and requires special handling for preemptible RCU.
+ */
+void rcu_note_context_switch(int cpu)
+{
+	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch(cpu);
+}
+
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = 1,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 687c4e9..f9bc83a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -75,13 +75,19 @@ EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
  * while in an RCU read-side critical section.
+ *
+ * Unlike the other rcu_*_qs() functions, callers to this function
+ * must disable irqs in order to protect the assignment to
+ * ->rcu_read_unlock_special.
  */
 static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
+
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
+	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 }
 
 /*
@@ -144,9 +150,8 @@ static void rcu_preempt_note_context_switch(int cpu)
 	 * grace period, then the fact that the task has been enqueued
 	 * means that we continue to block the current grace period.
 	 */
-	rcu_preempt_qs(cpu);
 	local_irq_save(flags);
-	t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	rcu_preempt_qs(cpu);
 	local_irq_restore(flags);
 }
 
@@ -236,7 +241,6 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	 */
 	special = t->rcu_read_unlock_special;
 	if (special & RCU_READ_UNLOCK_NEED_QS) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 		rcu_preempt_qs(smp_processor_id());
 	}
 
@@ -473,7 +477,6 @@ static void rcu_preempt_check_callbacks(int cpu)
 	struct task_struct *t = current;
 
 	if (t->rcu_read_lock_nesting == 0) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 		rcu_preempt_qs(cpu);
 		return;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index 9ab3cd7..d78a9dd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3695,7 +3695,7 @@ need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
-	rcu_sched_qs(cpu);
+	rcu_note_context_switch(cpu);
 	prev = rq->curr;
 	switch_count = &prev->nivcsw;
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7c1a67e..0db913a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -716,7 +716,7 @@ static int run_ksoftirqd(void * __bind_cpu)
 			preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
-			rcu_sched_qs((long)__bind_cpu);
+			rcu_note_context_switch((long)__bind_cpu);
 		}
 		preempt_enable();
 		set_current_state(TASK_INTERRUPTIBLE);
-- 
1.7.0

