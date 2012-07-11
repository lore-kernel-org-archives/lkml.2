Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab2GKS1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:27:15 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47918 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab2GKS1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:27:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/11] rcu: Switch task's syscall hooks on context switch
Date: Wed, 11 Jul 2012 20:26:33 +0200
Message-Id: <1342031200-22731-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
References: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the syscalls hook of a task when it's scheduled out so that if
the task migrates, it doesn't run the syscall slow path on a CPU
that might not need it.

Also set the syscalls hook on the next task if needed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/um/drivers/mconsole_kern.c |    2 +-
 include/linux/rcupdate.h        |    2 ++
 include/linux/sched.h           |   20 +++++++++++---------
 kernel/rcutree.c                |   15 +++++++++++++++
 kernel/sched/core.c             |    2 +-
 5 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 88e466b..e61922d 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -705,7 +705,7 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
-	rcu_switch_from(from);
+	rcu_switch(from, to);
 	switch_to(from, to, from);
 }
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a72f25e..1e57888 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -198,6 +198,8 @@ extern void rcu_user_enter(void);
 extern void rcu_user_exit(void);
 extern void rcu_user_enter_irq(void);
 extern void rcu_user_exit_irq(void);
+extern void rcu_user_hooks_switch(struct task_struct *prev,
+				  struct task_struct *next);
 #else
 static inline void rcu_user_enter(void) { }
 static inline void rcu_user_exit(void) { }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4059c0f..e17fcd0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1871,23 +1871,25 @@ static inline void rcu_copy_process(struct task_struct *p)
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
+#endif
 
+static inline void rcu_switch(struct task_struct *prev,
+			      struct task_struct *next)
+{
+#ifdef CONFIG_PREEMPT_RCU
+	if (prev->rcu_read_lock_nesting != 0)
+		rcu_preempt_note_context_switch();
+#endif
+#ifdef CONFIG_RCU_USER_QS
+	rcu_user_hooks_switch(prev, next);
 #endif
+}
 
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p,
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 78b0c30..2d79308 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -720,6 +720,21 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
+#ifdef CONFIG_RCU_USER_QS
+void rcu_user_hooks_switch(struct task_struct *prev,
+			   struct task_struct *next)
+{
+	struct rcu_dynticks *rdtp;
+
+	/* Interrupts are disabled in context switch */
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	if (!rdtp->ignore_user_qs) {
+		clear_tsk_thread_flag(prev, TIF_NOHZ);
+		set_tsk_thread_flag(next, TIF_NOHZ);
+	}
+}
+#endif
+
 #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..fa61d8a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2081,7 +2081,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
-	rcu_switch_from(prev);
+	rcu_switch(prev, next);
 	switch_to(prev, next, prev);
 
 	barrier();
-- 
1.7.5.4

