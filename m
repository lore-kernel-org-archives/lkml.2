Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2KCQKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:10:10 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57221 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2KCQKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:10:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] cputime: Generic on-demand virtual cputime accounting
Date: Sat,  3 Nov 2012 17:09:43 +0100
Message-Id: <1351958983-31355-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
References: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to stop the tick further idle, we need to be
able to account the cputime without using the tick.

Virtual based cputime accounting solves that problem by
hooking into kernel/user boundaries.

However implementing CONFIG_VIRT_CPU_ACCOUNTING require
to set low level hooks and involves more overhead. But
we already have a generic context tracking subsystem
that is required for RCU needs by archs which will want to
shut down the tick outside idle.

This patch implements a generic virtual based cputime
accounting that relies on these generic kernel/user hooks.

There are some upsides of doing this:

- This requires no arch code to implement CONFIG_VIRT_CPU_ACCOUNTING
if context tracking is already built (already necessary for RCU in full
tickless mode).

- We can rely on the generic context tracking subsystem to dynamically
(de)activate the hooks, so that we can switch anytime between virtual
and tick based accounting. This way we don't have the overhead
of the virtual accounting when the tick is running periodically.

And a few downsides:

- It relies on jiffies and the hooks are set in high level code. This
results in less precise cputime accounting than with a true native
virtual based cputime accounting which hooks on low level code and use
a cpu hardware clock. Precision is not the goal of this though.

- There is probably more overhead than a native virtual based cputime
accounting. But this relies on hooks that are already set anyway.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/context_tracking.h |   28 ++++++++++
 include/linux/vtime.h            |    7 +++
 init/Kconfig                     |   11 ++++-
 kernel/context_tracking.c        |   16 +-----
 kernel/sched/cputime.c           |  112 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 154 insertions(+), 20 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index e24339c..3b63210 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,12 +3,40 @@
 
 #ifdef CONFIG_CONTEXT_TRACKING
 #include <linux/sched.h>
+#include <linux/percpu.h>
+
+struct context_tracking {
+	/*
+	 * When active is false, hooks are not set to
+	 * minimize overhead: TIF flags are cleared
+	 * and calls to user_enter/exit are ignored. This
+	 * may be further optimized using static keys.
+	 */
+	bool active;
+	enum {
+		IN_KERNEL = 0,
+		IN_USER,
+	} state;
+};
+
+DECLARE_PER_CPU(struct context_tracking, context_tracking);
+
+static inline bool context_tracking_in_user(void)
+{
+	return __this_cpu_read(context_tracking.state) == IN_USER;
+}
+
+static inline bool context_tracking_active(void)
+{
+	return __this_cpu_read(context_tracking.active);
+}
 
 extern void user_enter(void);
 extern void user_exit(void);
 extern void context_tracking_task_switch(struct task_struct *prev,
 					 struct task_struct *next);
 #else
+static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 85a1f0f..3ea63a1 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -23,6 +23,13 @@ static inline void vtime_account(struct task_struct *tsk) { }
 static inline bool vtime_accounting(void) { return false; }
 #endif
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+extern void __vtime_account_user(struct task_struct *tsk);
+extern bool vtime_accounting(void);
+#else
+static inline void __vtime_account_user(struct task_struct *tsk) { }
+#endif
+
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 extern void irqtime_account_irq(struct task_struct *tsk);
 #else
diff --git a/init/Kconfig b/init/Kconfig
index 15e44e7..ad96572 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -344,7 +344,9 @@ config TICK_CPU_ACCOUNTING
 
 config VIRT_CPU_ACCOUNTING
 	bool "Deterministic task and CPU time accounting"
-	depends on HAVE_VIRT_CPU_ACCOUNTING
+	depends on HAVE_VIRT_CPU_ACCOUNTING || HAVE_CONTEXT_TRACKING
+	select VIRT_CPU_ACCOUNTING_GEN if !HAVE_VIRT_CPU_ACCOUNTING
+	default y if PPC64
 	help
 	  Select this option to enable more accurate task and CPU time
 	  accounting.  This is done by reading a CPU counter on each
@@ -367,6 +369,13 @@ config IRQ_TIME_ACCOUNTING
 
 endchoice
 
+config VIRT_CPU_ACCOUNTING_GEN
+	select CONTEXT_TRACKING
+	bool
+	help
+	  Implement a generic virtual based cputime accounting by using
+	  the context tracking subsystem.
+
 config BSD_PROCESS_ACCT
 	bool "BSD Process Accounting"
 	help
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index d7983ea..1a1ded6 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -1,22 +1,8 @@
 #include <linux/context_tracking.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
-#include <linux/percpu.h>
 #include <linux/hardirq.h>
 
-struct context_tracking {
-	/*
-	 * When active is false, hooks are not set to
-	 * minimize overhead: TIF flags are cleared
-	 * and calls to user_enter/exit are ignored. This
-	 * may be further optimized using static keys.
-	 */
-	bool active;
-	enum {
-		IN_KERNEL = 0,
-		IN_USER,
-	} state;
-};
 
 DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE
@@ -45,6 +31,7 @@ void user_enter(void)
 	if (__this_cpu_read(context_tracking.active) &&
 	    __this_cpu_read(context_tracking.state) != IN_USER) {
 		__this_cpu_write(context_tracking.state, IN_USER);
+		__vtime_account_system(current);
 		rcu_user_enter();
 	}
 	local_irq_restore(flags);
@@ -69,6 +56,7 @@ void user_exit(void)
 	if (__this_cpu_read(context_tracking.state) == IN_USER) {
 		__this_cpu_write(context_tracking.state, IN_KERNEL);
 		rcu_user_exit();
+		__vtime_account_user(current);
 	}
 	local_irq_restore(flags);
 }
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ff608f6..53990e7 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -3,6 +3,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kernel_stat.h>
 #include <linux/static_key.h>
+#include <linux/context_tracking.h>
 #include "sched.h"
 
 
@@ -444,11 +445,25 @@ void vtime_account(struct task_struct *tsk)
 
 	local_irq_save(flags);
 
-	if (in_interrupt() || !is_idle_task(tsk))
-		__vtime_account_system(tsk);
-	else
-		__vtime_account_idle(tsk);
-
+	if (!in_interrupt()) {
+		/*
+		 * If we interrupted user, context_tracking_in_user()
+		 * is 1 because the context tracking don't hook
+		 * on irq entry/exit. This way we know if
+		 * we need to flush user time on kernel entry.
+		 */
+		if (context_tracking_in_user()) {
+			__vtime_account_user(tsk);
+			goto out;
+		}
+
+		if (is_idle_task(tsk)) {
+			__vtime_account_idle(tsk);
+			goto out;
+		}
+	}
+	__vtime_account_system(tsk);
+out:
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(vtime_account);
@@ -534,3 +549,90 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	*ut = sig->prev_utime;
 	*st = sig->prev_stime;
 }
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+static DEFINE_PER_CPU(long, last_jiffies) = INITIAL_JIFFIES;
+
+static cputime_t get_vtime_delta(void)
+{
+	long delta;
+
+	delta = jiffies - __this_cpu_read(last_jiffies);
+	__this_cpu_add(last_jiffies, delta);
+
+	return jiffies_to_cputime(delta);
+}
+
+void __vtime_account_system(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
+}
+
+void __vtime_account_user(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
+}
+
+void __vtime_account_idle(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	account_idle_time(delta_cpu);
+}
+
+void vtime_task_switch(struct task_struct *prev)
+{
+	if (is_idle_task(prev))
+		__vtime_account_idle(prev);
+	else
+		__vtime_account_system(prev);
+}
+
+/*
+ * This is an unfortunate hack: if we flush user time only on
+ * irq entry, we miss the jiffies update and the time is spuriously
+ * accounted to system time.
+ */
+void vtime_account_process_tick(struct task_struct *p, int user_tick)
+{
+	if (context_tracking_in_user())
+		__vtime_account_user(p);
+}
+
+bool vtime_accounting(void)
+{
+	return context_tracking_active();
+}
+
+static int __cpuinit vtime_cpu_notify(struct notifier_block *self,
+				      unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	long *last_jiffies_cpu = per_cpu_ptr(&last_jiffies, cpu);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		/*
+		 * CHECKME: ensure that's visible by the CPU
+		 * once it wakes up
+		 */
+		*last_jiffies_cpu = jiffies;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static int __init init_vtime(void)
+{
+	cpu_notifier(vtime_cpu_notify, 0);
+	return 0;
+}
+early_initcall(init_vtime);
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
-- 
1.7.5.4

