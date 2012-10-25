Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab2JYAwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:52:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44516 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949Ab2JYAwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:52:13 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 5/5] cputime: Separate irqtime accounting from generic vtime
Date: Thu, 25 Oct 2012 02:51:53 +0200
Message-Id: <1351126313-17804-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
References: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vtime_account() doesn't have the same role in
CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_IRQ_TIME_ACCOUNTING.

In the first case it handles time accounting in any context. In
the second case it only handles irq time accounting.

So when vtime_account() is called from outside vtime_account_irq_*()
this call is pointless to CONFIG_IRQ_TIME_ACCOUNTING.

To fix the confusion, change vtime_account() to irqtime_account_irq()
in CONFIG_IRQ_TIME_ACCOUNTING. This way we ensure future account_vtime()
calls won't waste useless cycles in the irqtime APIs.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/vtime.h  |   19 +++++++++----------
 kernel/sched/cputime.c |    4 ++--
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 40634fb..f1f91ac 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -8,17 +8,18 @@ extern void vtime_task_switch(struct task_struct *prev);
 extern void vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_system_irqsafe(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
+extern void vtime_account(struct task_struct *tsk);
 #else
 static inline void vtime_task_switch(struct task_struct *prev) { }
+static inline void vtime_account_system(struct task_struct *tsk) { }
 static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
+static inline void vtime_account(struct task_struct *tsk) { }
 #endif
 
-#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
-static inline void vtime_account(struct task_struct *tsk)
-{
-}
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+extern void irqtime_account_irq(struct task_struct *tsk);
 #else
-extern void vtime_account(struct task_struct *tsk);
+static inline void irqtime_account_irq(struct task_struct *tsk) { }
 #endif
 
 static inline void vtime_account_irq_enter(struct task_struct *tsk)
@@ -33,17 +34,15 @@ static inline void vtime_account_irq_enter(struct task_struct *tsk)
 	 * the idle time is flushed on hardirq time already.
 	 */
 	vtime_account(tsk);
+	irqtime_account_irq(tsk);
 }
 
 static inline void vtime_account_irq_exit(struct task_struct *tsk)
 {
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
 	/* On hard|softirq exit we always account to hard|softirq cputime */
 	vtime_account_system(tsk);
-#endif
-#ifdef CONFIG_IRQ_TIME_ACCOUNTING
-	vtime_account(tsk);
-#endif
+	irqtime_account_irq(tsk);
+
 }
 
 #endif /* _LINUX_KERNEL_VTIME_H */
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 3ccbea0..1a7e1369 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -43,7 +43,7 @@ DEFINE_PER_CPU(seqcount_t, irq_time_seq);
  * Called before incrementing preempt_count on {soft,}irq_enter
  * and before decrementing preempt_count on {soft,}irq_exit.
  */
-void vtime_account(struct task_struct *curr)
+void irqtime_account_irq(struct task_struct *curr)
 {
 	unsigned long flags;
 	s64 delta;
@@ -73,7 +73,7 @@ void vtime_account(struct task_struct *curr)
 	irq_time_write_end();
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(vtime_account);
+EXPORT_SYMBOL_GPL(irqtime_account_irq);
 
 static int irqtime_account_hi_update(void)
 {
-- 
1.7.5.4

