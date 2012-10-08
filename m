Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2JHWgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:36:52 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47531 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab2JHWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:36:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] cputime: Separate irqtime accounting from generic vtime
Date: Tue,  9 Oct 2012 00:36:08 +0200
Message-Id: <1349735768-17586-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1349735768-17586-1-git-send-email-fweisbec@gmail.com>
References: <1349735768-17586-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vtime_account() doesn't have the same role in
CONFIG_VIRT_CPU_TIME_ACCOUNTING and CONFIG_IRQ_TIME_ACCOUNTING.

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
---
 include/linux/hardirq.h |   26 ++++++++++++--------------
 kernel/sched/cputime.c  |    8 ++++----
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index c126ffb..dc2052c 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -131,17 +131,8 @@ extern void synchronize_irq(unsigned int irq);
 
 struct task_struct;
 
-#ifdef CONFIG_TICK_CPU_ACCOUNTING
-static inline void vtime_account(struct task_struct *tsk) { }
-static inline void vtime_account_irq_enter(struct task_struct *tsk,
-					   unsigned long offset) { }
-static inline void vtime_account_irq_exit(struct task_struct *tsk,
-					  unsigned long offset) { }
-#else /* !CONFIG_TICK_CPU_ACCOUNTING */
-extern void vtime_account(struct task_struct *tsk);
-#endif /* !CONFIG_TICK_CPU_ACCOUNTING */
-
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
+extern void vtime_account(struct task_struct *tsk);
 extern void vtime_task_switch(struct task_struct *prev);
 extern void vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
@@ -174,21 +165,28 @@ static inline void vtime_account_irq_exit(struct task_struct *tsk,
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
+extern void irqtime_account_irq(struct task_struct *tsk);
+
 static inline void vtime_account_irq_enter(struct task_struct *tsk,
 					   unsigned long offset)
 {
-	vtime_account(tsk);
+	irqtime_account_irq(tsk);
 }
 
 static inline void vtime_account_irq_exit(struct task_struct *tsk,
 					  unsigned long offset)
 {
-	vtime_account(tsk);
+	irqtime_account_irq(tsk);
 }
-#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+#else /* !CONFIG_IRQ_TIME_ACCOUNTING */
+static inline void vtime_account_irq_enter(struct task_struct *tsk,
+					   unsigned long offset) { }
+static inline void vtime_account_irq_exit(struct task_struct *tsk,
+					  unsigned long offset) { }
+#endif /* !CONFIG_IRQ_TIME_ACCOUNTING */
+#endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
 
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 81b763b..7ad407a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -10,11 +10,11 @@
 
 /*
  * There are no locks covering percpu hardirq/softirq time.
- * They are only modified in vtime_account, on corresponding CPU
+ * They are only modified in irqtime_account_irq, on corresponding CPU
  * with interrupts disabled. So, writes are safe.
  * They are read and saved off onto struct rq in update_rq_clock().
  * This may result in other CPU reading this CPU's irq time and can
- * race with irq/vtime_account on this CPU. We would either get old
+ * race with irqtime_account_irq on this CPU. We would either get old
  * or new value with a side effect of accounting a slice of irq time to wrong
  * task when irq is in progress while we read rq->clock. That is a worthy
  * compromise in place of having locks on each irq in account_system_time.
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

