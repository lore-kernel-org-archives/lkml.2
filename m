Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2JHWgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:36:31 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47531 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab2JHWgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:36:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] cputime: Specialize irq vtime hooks
Date: Tue,  9 Oct 2012 00:36:07 +0200
Message-Id: <1349735768-17586-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1349735768-17586-1-git-send-email-fweisbec@gmail.com>
References: <1349735768-17586-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_VIRT_CPU_TIME_ACCOUNTING, When vtime_account()
is called in irq entry/exit, we perform a check on the
context: if we are interrupting the idle task when the
interrupt fires, account the pending cputime to idle,
otherwise account to system time or its sub-areas: tsk->stime,
hardirq time, softirq time, ...

However this check for idle only concerns the hardirq entry.
We only account pending idle time when a hardirq interrupts idle.

In the other cases we always account to system/irq time:

* On hardirq exit we account the time to hardirq time.

* Softirqs don't interrupt idle directly. They are either
following a hardirq that has already accounted the pending
idle time or we are running ksoftird and idle time has been
accounted in a previous context switch.

To optimize this and avoid the indirect call to vtime_account()
and the checks it performs, specialize the vtime irq APIs and
only perform the check on hard irq entry. Other vtime calls
can directly call vtime_account_system().

CONFIG_IRQ_TIME_ACCOUNTING behaviour doesn't change and directly
maps to its own vtime_account() implementation. One may want
to take benefits from the new APIs to optimize irq time accounting
as well in the future.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hardirq.h     |   82 +++++++++++++++++++++++++++++++++++--------
 include/linux/kernel_stat.h |    9 -----
 kernel/softirq.c            |    6 ++--
 3 files changed, 70 insertions(+), 27 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index cab3da3..c126ffb 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -131,13 +131,65 @@ extern void synchronize_irq(unsigned int irq);
 
 struct task_struct;
 
-#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
-static inline void vtime_account(struct task_struct *tsk)
+#ifdef CONFIG_TICK_CPU_ACCOUNTING
+static inline void vtime_account(struct task_struct *tsk) { }
+static inline void vtime_account_irq_enter(struct task_struct *tsk,
+					   unsigned long offset) { }
+static inline void vtime_account_irq_exit(struct task_struct *tsk,
+					  unsigned long offset) { }
+#else /* !CONFIG_TICK_CPU_ACCOUNTING */
+extern void vtime_account(struct task_struct *tsk);
+#endif /* !CONFIG_TICK_CPU_ACCOUNTING */
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+extern void vtime_task_switch(struct task_struct *prev);
+extern void vtime_account_system(struct task_struct *tsk);
+extern void vtime_account_idle(struct task_struct *tsk);
+
+static inline void vtime_account_irq_enter(struct task_struct *tsk,
+					   unsigned long offset)
 {
+	/*
+	 * On hardirq entry We need to check which context we are interrupting.
+	 * Time may be accounted to either idle or system.
+	 */
+	if (offset == HARDIRQ_OFFSET) {
+		vtime_account(tsk);
+	} else {
+		/*
+		 * Softirqs never interrupt idle directly. Either the hardirq
+		 * already did and accounted the idle time or we run in
+		 * ksoftirqd and idle time was accounted on context switch.
+		 */
+		vtime_account_system(tsk);
+	}
 }
-#else
-extern void vtime_account(struct task_struct *tsk);
-#endif
+
+static inline void vtime_account_irq_exit(struct task_struct *tsk,
+					  unsigned long offset)
+{
+	/* On hard|softirq exit we always account to hard|softirq cputime */
+	vtime_account_system(tsk);
+}
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
+static inline void vtime_task_switch(struct task_struct *prev) { }
+static inline void vtime_account_system(struct task_struct *tsk) { }
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+static inline void vtime_account_irq_enter(struct task_struct *tsk,
+					   unsigned long offset)
+{
+	vtime_account(tsk);
+}
+
+static inline void vtime_account_irq_exit(struct task_struct *tsk,
+					  unsigned long offset)
+{
+	vtime_account(tsk);
+}
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
 
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
 
@@ -160,11 +212,11 @@ extern void rcu_nmi_exit(void);
  * always balanced, so the interrupted value of ->hardirq_context
  * will always be restored.
  */
-#define __irq_enter()					\
-	do {						\
-		vtime_account(current);		\
-		add_preempt_count(HARDIRQ_OFFSET);	\
-		trace_hardirq_enter();			\
+#define __irq_enter()							\
+	do {								\
+		vtime_account_irq_enter(current, HARDIRQ_OFFSET);	\
+		add_preempt_count(HARDIRQ_OFFSET);			\
+		trace_hardirq_enter();					\
 	} while (0)
 
 /*
@@ -175,11 +227,11 @@ extern void irq_enter(void);
 /*
  * Exit irq context without processing softirqs:
  */
-#define __irq_exit()					\
-	do {						\
-		trace_hardirq_exit();			\
-		vtime_account(current);		\
-		sub_preempt_count(HARDIRQ_OFFSET);	\
+#define __irq_exit()							\
+	do {								\
+		trace_hardirq_exit();					\
+		vtime_account_irq_exit(current, HARDIRQ_OFFSET);	\
+		sub_preempt_count(HARDIRQ_OFFSET);			\
 	} while (0)
 
 /*
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 6747d4b..2fbd905 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -130,13 +130,4 @@ extern void account_process_tick(struct task_struct *, int user);
 extern void account_steal_ticks(unsigned long ticks);
 extern void account_idle_ticks(unsigned long ticks);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void vtime_task_switch(struct task_struct *prev);
-extern void vtime_account_system(struct task_struct *tsk);
-extern void vtime_account_idle(struct task_struct *tsk);
-#else
-static inline void vtime_task_switch(struct task_struct *prev) { }
-static inline void vtime_account_system(struct task_struct *tsk) { }
-#endif
-
 #endif /* _LINUX_KERNEL_STAT_H */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index cc96bdc..402d4b5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -221,7 +221,7 @@ asmlinkage void __do_softirq(void)
 	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
-	vtime_account(current);
+	vtime_account_irq_enter(current, SOFTIRQ_OFFSET);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
@@ -272,7 +272,7 @@ restart:
 
 	lockdep_softirq_exit();
 
-	vtime_account(current);
+	vtime_account_irq_exit(current, SOFTIRQ_OFFSET);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
@@ -341,7 +341,7 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
-	vtime_account(current);
+	vtime_account_irq_exit(current, HARDIRQ_OFFSET);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
-- 
1.7.5.4

