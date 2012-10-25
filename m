Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954Ab2JYRsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:48:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37029 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab2JYRsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:48:15 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/5] vtime: Gather vtime declarations to their own header file
Date: Thu, 25 Oct 2012 19:47:59 +0200
Message-Id: <1351187283-20715-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
References: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These APIs are scattered around and are going to expand a bit.
Let's create a dedicated header file for sanity.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/hardirq.h     |   11 +----------
 include/linux/kernel_stat.h |    9 +--------
 include/linux/vtime.h       |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/vtime.h

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index cab3da3..b083a47 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -4,6 +4,7 @@
 #include <linux/preempt.h>
 #include <linux/lockdep.h>
 #include <linux/ftrace_irq.h>
+#include <linux/vtime.h>
 #include <asm/hardirq.h>
 
 /*
@@ -129,16 +130,6 @@ extern void synchronize_irq(unsigned int irq);
 # define synchronize_irq(irq)	barrier()
 #endif
 
-struct task_struct;
-
-#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
-static inline void vtime_account(struct task_struct *tsk)
-{
-}
-#else
-extern void vtime_account(struct task_struct *tsk);
-#endif
-
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
 
 static inline void rcu_nmi_enter(void)
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 36d12f0..1865b1f 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -7,6 +7,7 @@
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/vtime.h>
 #include <asm/irq.h>
 #include <asm/cputime.h>
 
@@ -130,12 +131,4 @@ extern void account_process_tick(struct task_struct *, int user);
 extern void account_steal_ticks(unsigned long ticks);
 extern void account_idle_ticks(unsigned long ticks);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void vtime_task_switch(struct task_struct *prev);
-extern void vtime_account_system(struct task_struct *tsk);
-extern void vtime_account_idle(struct task_struct *tsk);
-#else
-static inline void vtime_task_switch(struct task_struct *prev) { }
-#endif
-
 #endif /* _LINUX_KERNEL_STAT_H */
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
new file mode 100644
index 0000000..7199c24
--- /dev/null
+++ b/include/linux/vtime.h
@@ -0,0 +1,22 @@
+#ifndef _LINUX_KERNEL_VTIME_H
+#define _LINUX_KERNEL_VTIME_H
+
+struct task_struct;
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+extern void vtime_task_switch(struct task_struct *prev);
+extern void vtime_account_system(struct task_struct *tsk);
+extern void vtime_account_idle(struct task_struct *tsk);
+#else
+static inline void vtime_task_switch(struct task_struct *prev) { }
+#endif
+
+#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
+static inline void vtime_account(struct task_struct *tsk)
+{
+}
+#else
+extern void vtime_account(struct task_struct *tsk);
+#endif
+
+#endif /* _LINUX_KERNEL_VTIME_H */
-- 
1.7.5.4

