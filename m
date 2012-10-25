Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992510Ab2JYRsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:48:35 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37029 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935000Ab2JYRs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:48:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 4/5] cputime: Specialize irq vtime hooks
Date: Thu, 25 Oct 2012 19:48:02 +0200
Message-Id: <1351187283-20715-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
References: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_VIRT_CPU_ACCOUNTING, when vtime_account()
is called in irq entry/exit, we perform a check on the
context: if we are interrupting the idle task we
account the pending cputime to idle, otherwise account
to system time or its sub-areas: tsk->stime, hardirq time,
softirq time, ...

However this check for idle only concerns the hardirq entry
and softirq entry:

* Hardirq may directly interrupt the idle task, in which case
we need to flush the pending CPU time to idle.

* The idle task may be directly interrupted by a softirq if
it calls local_bh_enable(). There is probably no such call
in any idle task but we need to cover every case. Ksoftirqd
is not concerned because the idle time is flushed on context
switch and softirq in the end of hardirq have the idle time
already flushed from the hardirq entry.

In the other cases we always account to system/irq time:

* On hardirq exit we account the time to hardirq time.
* On softirq exit we account the time to softirq time.

To optimize this and avoid the indirect call to vtime_account()
and the checks it performs, specialize the vtime irq APIs and
only perform the check on irq entry. Irq exit can directly call
vtime_account_system().

CONFIG_IRQ_TIME_ACCOUNTING behaviour doesn't change and directly
maps to its own vtime_account() implementation. One may want
to take benefits from the new APIs to optimize irq time accounting
as well in the future.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/hardirq.h |    4 ++--
 include/linux/vtime.h   |   25 +++++++++++++++++++++++++
 kernel/softirq.c        |    6 +++---
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index b083a47..624ef3f 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -153,7 +153,7 @@ extern void rcu_nmi_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
-		vtime_account(current);		\
+		vtime_account_irq_enter(current);	\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
@@ -169,7 +169,7 @@ extern void irq_enter(void);
 #define __irq_exit()					\
 	do {						\
 		trace_hardirq_exit();			\
-		vtime_account(current);		\
+		vtime_account_irq_exit(current);	\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
 	} while (0)
 
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index b9fc4f9..c35c022 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -21,4 +21,29 @@ static inline void vtime_account(struct task_struct *tsk)
 extern void vtime_account(struct task_struct *tsk);
 #endif
 
+static inline void vtime_account_irq_enter(struct task_struct *tsk)
+{
+	/*
+	 * Hardirq can interrupt idle task anytime. So we need vtime_account()
+	 * that performs the idle check in CONFIG_VIRT_CPU_ACCOUNTING.
+	 * Softirq can also interrupt idle task directly if it calls
+	 * local_bh_enable(). Such case probably don't exist but we never know.
+	 * Ksoftirqd is not concerned because idle time is flushed on context
+	 * switch. Softirqs in the end of hardirqs are also not a problem because
+	 * the idle time is flushed on hardirq time already.
+	 */
+	vtime_account(tsk);
+}
+
+static inline void vtime_account_irq_exit(struct task_struct *tsk)
+{
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+	/* On hard|softirq exit we always account to hard|softirq cputime */
+	__vtime_account_system(tsk);
+#endif
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	vtime_account(tsk);
+#endif
+}
+
 #endif /* _LINUX_KERNEL_VTIME_H */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index cc96bdc..ed567ba 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -221,7 +221,7 @@ asmlinkage void __do_softirq(void)
 	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
-	vtime_account(current);
+	vtime_account_irq_enter(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
@@ -272,7 +272,7 @@ restart:
 
 	lockdep_softirq_exit();
 
-	vtime_account(current);
+	vtime_account_irq_exit(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
@@ -341,7 +341,7 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
-	vtime_account(current);
+	vtime_account_irq_exit(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
-- 
1.7.5.4

