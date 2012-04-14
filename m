Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2DNQUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:20:54 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41540 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2DNQUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:20:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 1/7] rcu: Move PREEMPT_RCU preemption to switch_to() invocation
Date: Sat, 14 Apr 2012 09:20:31 -0700
Message-Id: <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120414161953.GA18140@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-2398-0000-0000-000005D1BC11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, PREEMPT_RCU readers are enqueued upon entry to the scheduler.
This is inefficient because enqueuing is required only if there is a
context switch, and entry to the scheduler does not guarantee a context
switch.

The commit therefore moves the enqueuing to immediately precede the
call to switch_to() from the scheduler.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/um/drivers/mconsole_kern.c |    1 +
 include/linux/rcupdate.h        |    1 +
 include/linux/rcutiny.h         |    6 ------
 include/linux/sched.h           |   10 ++++++++++
 kernel/rcutree.c                |    1 -
 kernel/rcutree.h                |    1 -
 kernel/rcutree_plugin.h         |   14 +++-----------
 kernel/sched/core.c             |    1 +
 8 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index c70e047..f69ff2d 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -704,6 +704,7 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
+	rcu_switch_from(from);
 	switch_to(from, to, from);
 }
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9372174..aca4ef0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -183,6 +183,7 @@ static inline int rcu_preempt_depth(void)
 /* Internal to kernel */
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
+extern void rcu_preempt_note_context_switch(void);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
 extern void rcu_idle_enter(void);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e93df77..080b5bd 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -87,10 +87,6 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 #ifdef CONFIG_TINY_RCU
 
-static inline void rcu_preempt_note_context_switch(void)
-{
-}
-
 static inline void exit_rcu(void)
 {
 }
@@ -102,7 +98,6 @@ static inline int rcu_needs_cpu(int cpu)
 
 #else /* #ifdef CONFIG_TINY_RCU */
 
-void rcu_preempt_note_context_switch(void);
 extern void exit_rcu(void);
 int rcu_preempt_needs_cpu(void);
 
@@ -116,7 +111,6 @@ static inline int rcu_needs_cpu(int cpu)
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
-	rcu_preempt_note_context_switch();
 }
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e692aba..a749c9d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1879,12 +1879,22 @@ static inline void rcu_copy_process(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
+static inline void rcu_switch_from(struct task_struct *prev)
+{
+	if (prev->rcu_read_lock_nesting != 0)
+		rcu_preempt_note_context_switch();
+}
+
 #else
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
 }
 
+static inline void rcu_switch_from(struct task_struct *prev)
+{
+}
+
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1050d6d..6135150 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -192,7 +192,6 @@ void rcu_note_context_switch(int cpu)
 {
 	trace_rcu_utilization("Start context switch");
 	rcu_sched_qs(cpu);
-	rcu_preempt_note_context_switch(cpu);
 	trace_rcu_utilization("End context switch");
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index cdd1be0..d6b70b08 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -423,7 +423,6 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
-static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..b1ac22e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -153,7 +153,7 @@ static void rcu_preempt_qs(int cpu)
  *
  * Caller must disable preemption.
  */
-static void rcu_preempt_note_context_switch(int cpu)
+void rcu_preempt_note_context_switch(void)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
@@ -164,7 +164,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
+		rdp = __this_cpu_ptr(rcu_preempt_state.rda);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
@@ -228,7 +228,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	 * means that we continue to block the current grace period.
 	 */
 	local_irq_save(flags);
-	rcu_preempt_qs(cpu);
+	rcu_preempt_qs(smp_processor_id());
 	local_irq_restore(flags);
 }
 
@@ -1018,14 +1018,6 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
- * Because preemptible RCU does not exist, we never have to check for
- * CPUs being in quiescent states.
- */
-static void rcu_preempt_note_context_switch(int cpu)
-{
-}
-
-/*
  * Because preemptible RCU does not exist, there are never any preempted
  * RCU readers.
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..10689da 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2051,6 +2051,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
+	rcu_switch_from(prev);
 	switch_to(prev, next, prev);
 
 	barrier();
-- 
1.7.8

