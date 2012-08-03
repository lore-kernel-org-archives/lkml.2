Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2HCPDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:03:06 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61497 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab2HCPDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:03:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/5] cputime: Generic on-demand virtual cputime accounting
Date: Fri,  3 Aug 2012 17:02:25 +0200
Message-Id: <1344006145-26115-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344006145-26115-1-git-send-email-fweisbec@gmail.com>
References: <1344006145-26115-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to stop the tick further idle, we need to be
able to account the cputime without using the tick.

Virtual based cputime accounting solves that problem by
hooking into kernel/user boundaries.

However implementing CONFIG_VIRT_CPU_ACCOUNTING requires
to set low level hooks and involves more overhead. But
we already have a generic code domain tracking subsystem
that is required for RCU needs by archs which will want to
shut down the tick outside idle.

This patch implements a generic virtual based cputime
accounting that relies on these generic kernel/user hooks.

There are some upsides of doing this:

- This requires no arch code to implement CONFIG_VIRT_CPU_ACCOUNTING
if code domain tracking is already built (already necessary for RCU in full
tickless mode).

- We can rely on the generic code domain tracking subsystem to dynamically
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
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-generic/cputime.h |    2 +
 include/linux/code_domain.h   |   26 ++++++++++
 include/linux/kernel_stat.h   |   12 ++++-
 init/Kconfig                  |   11 ++++-
 kernel/code_domain_tracking.c |   20 ++------
 kernel/sched/cputime.c        |  112 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 166 insertions(+), 17 deletions(-)

diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 212c8bb..2a78aa7 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -66,9 +66,11 @@ typedef u64 __nocast cputime64_t;
 #define cputime64_to_clock_t(__ct)	\
 	jiffies_64_to_clock_t(cputime64_to_jiffies64(__ct))
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 static inline bool accounting_vtime(void)
 {
 	return false;
 }
+#endif
 
 #endif
diff --git a/include/linux/code_domain.h b/include/linux/code_domain.h
index 5d4513d..4d47a7b 100644
--- a/include/linux/code_domain.h
+++ b/include/linux/code_domain.h
@@ -4,6 +4,32 @@
 #ifdef CONFIG_CODE_DOMAIN_TRACKING
 #include <linux/sched.h>
 
+struct code_domain_tracking {
+	/*
+	 * When tracking_active is false, hooks are not
+	 * set to minimize overhead: TIF flags are cleared
+	 * and calls to user_enter/exit are ignored. This
+	 * may be further optimized using static keys.
+	 */
+	bool tracking_active;
+	enum {
+		IN_KERNEL = 0,
+		IN_USER,
+	} state;
+};
+
+DECLARE_PER_CPU(struct code_domain_tracking, code_domain);
+
+static inline bool code_domain_in_user(void)
+{
+	return __this_cpu_read(code_domain.state) == IN_USER;
+}
+
+static inline bool code_domain_tracking_active(void)
+{
+	return __this_cpu_read(code_domain.tracking_active);
+}
+
 extern void user_enter(void);
 extern void user_exit(void);
 extern void code_domain_task_switch(struct task_struct *prev,
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 1270b86..6e509a9 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -130,13 +130,23 @@ extern void account_process_tick(struct task_struct *, int user);
 extern void account_steal_ticks(unsigned long ticks);
 extern void account_idle_ticks(unsigned long ticks);
 
+
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void account_switch_vtime(struct task_struct *prev);
-extern bool account_process_tick_vtime(struct task_struct *p, int user_tick);
+extern void account_process_tick_vtime(struct task_struct *p, int user_tick);
 #else
 static inline void account_switch_vtime(struct task_struct *prev) { }
 static inline void account_process_tick_vtime(struct task_struct *p,
 					      int user_tick) { }
 #endif
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+void account_system_vtime(struct task_struct *tsk);
+void account_user_vtime(struct task_struct *tsk);
+bool accounting_vtime(void);
+#else
+static inline void account_system_vtime(struct task_struct *tsk) { }
+static inline void account_user_vtime(struct task_struct *tsk) { }
+#endif
+
 #endif /* _LINUX_KERNEL_STAT_H */
diff --git a/init/Kconfig b/init/Kconfig
index cf5e86e..1bf2e43 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -269,7 +269,9 @@ config POSIX_MQUEUE_SYSCTL
 
 config VIRT_CPU_ACCOUNTING
 	bool "Deterministic task and CPU time accounting"
-	depends on HAVE_VIRT_CPU_ACCOUNTING && !IRQ_TIME_ACCOUNTING
+	depends on HAVE_VIRT_CPU_ACCOUNTING || HAVE_CODE_DOMAIN_TRACKING
+	depends on !IRQ_TIME_ACCOUNTING
+	select VIRT_CPU_ACCOUNTING_GEN if !HAVE_VIRT_CPU_ACCOUNTING
 	default y if PPC64
 	help
 	  Select this option to enable more accurate task and CPU time
@@ -280,6 +282,13 @@ config VIRT_CPU_ACCOUNTING
 	  stolen time on logically-partitioned systems running on
 	  IBM POWER5-based machines.
 
+config VIRT_CPU_ACCOUNTING_GEN
+	select CODE_DOMAIN_TRACKING
+	bool
+	help
+	  Implement a generic virtual based cputime accounting by using
+	  the code domain tracking subsystem.
+
 config BSD_PROCESS_ACCT
 	bool "BSD Process Accounting"
 	help
diff --git a/kernel/code_domain_tracking.c b/kernel/code_domain_tracking.c
index 8332c76..19c2bc0 100644
--- a/kernel/code_domain_tracking.c
+++ b/kernel/code_domain_tracking.c
@@ -1,21 +1,7 @@
 #include <linux/code_domain.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
-#include <linux/percpu.h>
-
-struct code_domain_tracking {
-	/*
-	 * When tracking_active is false, hooks are not
-	 * set to minimize overhead: TIF flags are cleared
-	 * and calls to user_enter/exit are ignored. This
-	 * may be further optimized using static keys.
-	 */
-	bool tracking_active;
-	enum {
-		IN_KERNEL = 0,
-		IN_USER,
-	} state;
-};
+#include <linux/kernel_stat.h>
 
 DEFINE_PER_CPU(struct code_domain_tracking, code_domain) = {
 #ifdef CONFIG_CODE_DOMAIN_TRACKING_FORCE
@@ -32,6 +18,8 @@ void user_enter(void)
 	if (__this_cpu_read(code_domain.tracking_active) &&
 	    __this_cpu_read(code_domain.state) != IN_USER) {
 		__this_cpu_write(code_domain.state, IN_USER);
+		if (accounting_vtime())
+			account_system_vtime(current);
 		rcu_user_enter();
 	}
 	local_irq_restore(flags);
@@ -44,6 +32,8 @@ void user_exit(void)
 	local_irq_save(flags);
 	if (__this_cpu_read(code_domain.state) == IN_USER) {
 		__this_cpu_write(code_domain.state, IN_KERNEL);
+		if (accounting_vtime())
+			account_user_vtime(current);
 		rcu_user_exit();
 	}
 	local_irq_restore(flags);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 53b03cc..d55d9cf 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/tsacct_kern.h>
 #include <linux/kernel_stat.h>
+#include <linux/code_domain.h>
 #include "sched.h"
 
 
@@ -490,3 +491,114 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
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
+void account_system_vtime(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
+}
+
+void account_user_vtime(struct task_struct *tsk)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
+}
+
+static void account_idle_vtime(void)
+{
+	cputime_t delta_cpu = get_vtime_delta();
+
+	account_idle_time(delta_cpu);
+}
+
+void account_vtime(struct task_struct *tsk)
+{
+	unsigned long count = irq_count();
+
+	if (!count) {
+		/*
+		 * If we interrupted user, code_domain_in_user()
+		 * is 1 because the code domain tracking don't hook
+		 * on irq entry/exit. This way we know if
+		 * we need to flush user time on kernel entry.
+		 */
+		if (code_domain_in_user())
+			account_user_vtime(tsk);
+	} else {
+		if (count == HARDIRQ_OFFSET ||
+		    count == SOFTIRQ_OFFSET) {
+			if (is_idle_task(tsk))
+				account_idle_vtime();
+			else
+				account_system_vtime(tsk);
+		}
+	}
+}
+
+void account_switch_vtime(struct task_struct *prev)
+{
+	if (is_idle_task(prev))
+		account_idle_vtime();
+	else
+		account_system_vtime(prev);
+}
+
+/*
+ * This is a kind of hack: if we flush user time only on
+ * irq entry, we miss the jiffies update and the time is spuriously
+ * accounted to system time.
+ */
+void account_process_tick_vtime(struct task_struct *p, int user_tick)
+{
+	if (code_domain_in_user())
+		account_user_vtime(p);
+}
+
+bool accounting_vtime(void)
+{
+	return code_domain_tracking_active();
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

