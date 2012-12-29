Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2L2QnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:43:24 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58842 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2L2QnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:43:20 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/27] cputime: Generic on-demand virtual cputime accounting
Date: Sat, 29 Dec 2012 17:42:41 +0100
Message-Id: <1356799386-4212-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
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
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/context_tracking.h |   28 +++++++++++
 include/linux/vtime.h            |    5 ++
 init/Kconfig                     |   10 ++++-
 kernel/context_tracking.c        |   22 ++-------
 kernel/sched/cputime.c           |   92 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 135 insertions(+), 22 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index e24339c..9f33fbc 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,12 +3,40 @@
 
 #ifdef CONFIG_CONTEXT_TRACKING
 #include <linux/sched.h>
+#include <linux/percpu.h>
+
+struct context_tracking {
+	/*
+	 * When active is false, hooks are unset in order
+	 * to minimize overhead: TIF flags are cleared
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
index ae30ab5..1151960 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -14,9 +14,14 @@ extern void vtime_account(struct task_struct *tsk);
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
 static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
+static inline void vtime_account_user(struct task_struct *tsk) { }
 static inline void vtime_account(struct task_struct *tsk) { }
 #endif
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
+#endif
+
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 extern void irqtime_account_irq(struct task_struct *tsk);
 #else
diff --git a/init/Kconfig b/init/Kconfig
index 5cc8713..dad2b88 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -340,7 +340,8 @@ config TICK_CPU_ACCOUNTING
 
 config VIRT_CPU_ACCOUNTING
 	bool "Deterministic task and CPU time accounting"
-	depends on HAVE_VIRT_CPU_ACCOUNTING
+	depends on HAVE_VIRT_CPU_ACCOUNTING || HAVE_CONTEXT_TRACKING
+	select VIRT_CPU_ACCOUNTING_GEN if !HAVE_VIRT_CPU_ACCOUNTING
 	help
 	  Select this option to enable more accurate task and CPU time
 	  accounting.  This is done by reading a CPU counter on each
@@ -363,6 +364,13 @@ config IRQ_TIME_ACCOUNTING
 
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
index 9f6c38f..ca1e073 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -17,24 +17,10 @@
 #include <linux/context_tracking.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
-#include <linux/percpu.h>
 #include <linux/hardirq.h>
 
-struct context_tracking {
-	/*
-	 * When active is false, hooks are unset in order
-	 * to minimize overhead: TIF flags are cleared
-	 * and calls to user_enter/exit are ignored. This
-	 * may be further optimized using static keys.
-	 */
-	bool active;
-	enum {
-		IN_KERNEL = 0,
-		IN_USER,
-	} state;
-};
 
-static DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
+DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE
 	.active = true,
 #endif
@@ -70,7 +56,7 @@ void user_enter(void)
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.active) &&
 	    __this_cpu_read(context_tracking.state) != IN_USER) {
-		__this_cpu_write(context_tracking.state, IN_USER);
+		vtime_account_system(current);
 		/*
 		 * At this stage, only low level arch entry code remains and
 		 * then we'll run in userspace. We can assume there won't be
@@ -79,6 +65,7 @@ void user_enter(void)
 		 * on the tick.
 		 */
 		rcu_user_enter();
+		__this_cpu_write(context_tracking.state, IN_USER);
 	}
 	local_irq_restore(flags);
 }
@@ -104,12 +91,13 @@ void user_exit(void)
 
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.state) == IN_USER) {
-		__this_cpu_write(context_tracking.state, IN_KERNEL);
 		/*
 		 * We are going to run code that may use RCU. Inform
 		 * RCU core about that (ie: we may need the tick again).
 		 */
 		rcu_user_exit();
+		vtime_account_user(current);
+		__this_cpu_write(context_tracking.state, IN_KERNEL);
 	}
 	local_irq_restore(flags);
 }
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 293b202..3749a0e 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -3,6 +3,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kernel_stat.h>
 #include <linux/static_key.h>
+#include <linux/context_tracking.h>
 #include "sched.h"
 
 
@@ -495,10 +496,24 @@ void vtime_task_switch(struct task_struct *prev)
 #ifndef __ARCH_HAS_VTIME_ACCOUNT
 void vtime_account(struct task_struct *tsk)
 {
-	if (in_interrupt() || !is_idle_task(tsk))
-		vtime_account_system(tsk);
-	else
-		vtime_account_idle(tsk);
+	if (!in_interrupt()) {
+		/*
+		 * If we interrupted user, context_tracking_in_user()
+		 * is 1 because the context tracking don't hook
+		 * on irq entry/exit. This way we know if
+		 * we need to flush user time on kernel entry.
+		 */
+		if (context_tracking_in_user()) {
+			vtime_account_user(tsk);
+			return;
+		}
+
+		if (is_idle_task(tsk)) {
+			vtime_account_idle(tsk);
+			return;
+		}
+	}
+	vtime_account_system(tsk);
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
@@ -587,3 +602,72 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
 #endif
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
+void vtime_account_system(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
+}
+
+void vtime_account_user(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	/*
+	 * This is an unfortunate hack: if we flush user time only on
+	 * irq entry, we miss the jiffies update and the time is spuriously
+	 * accounted to system time.
+	 */
+	if (context_tracking_in_user())
+		account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
+}
+
+void vtime_account_idle(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	account_idle_time(delta_cpu);
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

