Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab2GNHn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 03:43:59 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48929 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2GNHn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 03:43:57 -0400
Date: Sat, 14 Jul 2012 09:43:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU fix
Message-ID: <20120714074351.GA6521@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: 40b3c43f042c2ba8915aff5c63708207ed7639cb Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/urgent

 Thanks,

	Ingo

------------------>
Paul E. McKenney (1):
      Revert "rcu: Move PREEMPT_RCU preemption to switch_to() invocation"


 arch/um/drivers/mconsole_kern.c |    1 -
 include/linux/rcupdate.h        |    1 -
 include/linux/rcutiny.h         |    6 ++++++
 include/linux/sched.h           |   10 ----------
 kernel/rcutree.c                |    1 +
 kernel/rcutree.h                |    1 +
 kernel/rcutree_plugin.h         |   14 +++++++++++---
 kernel/sched/core.c             |    1 -
 8 files changed, 19 insertions(+), 16 deletions(-)

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
index 26d1a47..9cac722 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -184,7 +184,6 @@ static inline int rcu_preempt_depth(void)
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
index 38ecdda..4b97bba 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -201,6 +201,7 @@ void rcu_note_context_switch(int cpu)
 {
 	trace_rcu_utilization("Start context switch");
 	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch(cpu);
 	trace_rcu_utilization("End context switch");
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index ea05649..19b61ac 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -444,6 +444,7 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
+static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 5271a02..3e48994 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -153,7 +153,7 @@ static void rcu_preempt_qs(int cpu)
  *
  * Caller must disable preemption.
  */
-void rcu_preempt_note_context_switch(void)
+static void rcu_preempt_note_context_switch(int cpu)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
@@ -164,7 +164,7 @@ void rcu_preempt_note_context_switch(void)
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		rdp = __this_cpu_ptr(rcu_preempt_state.rda);
+		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
@@ -228,7 +228,7 @@ void rcu_preempt_note_context_switch(void)
 	 * means that we continue to block the current grace period.
 	 */
 	local_irq_save(flags);
-	rcu_preempt_qs(smp_processor_id());
+	rcu_preempt_qs(cpu);
 	local_irq_restore(flags);
 }
 
@@ -1002,6 +1002,14 @@ void rcu_force_quiescent_state(void)
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
