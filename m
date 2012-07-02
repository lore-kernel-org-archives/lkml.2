Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2GBOgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:36:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57663 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab2GBOgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:36:43 -0400
Date: Mon, 2 Jul 2012 07:22:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
Message-ID: <20120702142252.GA22868@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1340964584.2936.40.camel@lappy>
 <20120629172320.GA2416@linux.vnet.ibm.com>
 <1341006040.26928.4.camel@lappy>
 <1341225139.23484.4.camel@twins>
 <20120702113541.GI2907@linux.vnet.ibm.com>
 <1341230352.23484.7.camel@twins>
 <1341234773.2958.4.camel@lappy>
 <20120702133334.GA2508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702133334.GA2508@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12070214-1976-0000-0000-00000EC96CE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 06:33:34AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 02, 2012 at 03:12:53PM +0200, Sasha Levin wrote:
> > On Mon, 2012-07-02 at 13:59 +0200, Peter Zijlstra wrote:

[ . . . ]

> > [   37.048018]  *** DEADLOCK ***
> 
> OK, so it looks like the context-switch-time call into preemptible RCU
> needs to be outside of the runqueue-lock critical section.  One way
> to do this is be reverting 616c310e (Move PREEMPT_RCU preemption to
> switch_to() invocation).  Sasha, could you please try this out?

Hmmmm...  Here is a patch for this reversion on top of -rcu with
conflicts resolved.

							Thanx, Paul

------------------------------------------------------------------------

Revert "rcu: Move PREEMPT_RCU preemption to switch_to() invocation"

This reverts commit 616c310e83b872024271c915c1b9ab505b9efad9.
(Move PREEMPT_RCU preemption to switch_to() invocation).
Testing by Sasha Levin <levinsasha928@gmail.com> showed that this
can result in deadlock due to invoking the scheduler when one of
the runqueue locks is held.  Because this commit was simply a
performance optimization, revert it.

Conflicts (resolved):
    
    include/linux/rcutiny.h

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 88e466b..43b39d6 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -705,7 +705,6 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
-	rcu_switch_from(from);
 	switch_to(from, to, from);
 }
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2f5d89b..115ead2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -185,7 +185,6 @@ static inline int rcu_preempt_depth(void)
 /* Internal to kernel */
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
-extern void rcu_preempt_note_context_switch(void);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
 extern void rcu_idle_enter(void);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 854dc4c..4e56a9c 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -87,6 +87,10 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 #ifdef CONFIG_TINY_RCU
 
+static inline void rcu_preempt_note_context_switch(void)
+{
+}
+
 static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
@@ -95,6 +99,7 @@ static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 
 #else /* #ifdef CONFIG_TINY_RCU */
 
+void rcu_preempt_note_context_switch(void);
 int rcu_preempt_needs_cpu(void);
 
 static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
@@ -108,6 +113,7 @@ static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch();
 }
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4059c0f..06a4c5f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1871,22 +1871,12 @@ static inline void rcu_copy_process(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
-static inline void rcu_switch_from(struct task_struct *prev)
-{
-	if (prev->rcu_read_lock_nesting != 0)
-		rcu_preempt_note_context_switch();
-}
-
 #else
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
 }
 
-static inline void rcu_switch_from(struct task_struct *prev)
-{
-}
-
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b9e6aaf..955f18c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -203,6 +203,7 @@ void rcu_note_context_switch(int cpu)
 {
 	trace_rcu_utilization("Start context switch");
 	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch(cpu);
 	trace_rcu_utilization("End context switch");
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 86a40b5..b9065dd 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -467,6 +467,7 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
+static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index dde457e..cf15a61 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -158,7 +158,7 @@ static void rcu_preempt_qs(int cpu)
  *
  * Caller must disable preemption.
  */
-void rcu_preempt_note_context_switch(void)
+static void rcu_preempt_note_context_switch(int cpu)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
@@ -169,7 +169,7 @@ void rcu_preempt_note_context_switch(void)
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		rdp = __this_cpu_ptr(rcu_preempt_state.rda);
+		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
@@ -233,7 +233,7 @@ void rcu_preempt_note_context_switch(void)
 	 * means that we continue to block the current grace period.
 	 */
 	local_irq_save(flags);
-	rcu_preempt_qs(smp_processor_id());
+	rcu_preempt_qs(cpu);
 	local_irq_restore(flags);
 }
 
@@ -902,6 +902,14 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
+ * Because preemptible RCU does not exist, we never have to check for
+ * CPUs being in quiescent states.
+ */
+static void rcu_preempt_note_context_switch(int cpu)
+{
+}
+
+/*
  * Because preemptible RCU does not exist, there are never any preempted
  * RCU readers.
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..eaead2d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2081,7 +2081,6 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
-	rcu_switch_from(prev);
 	switch_to(prev, next, prev);
 
 	barrier();

