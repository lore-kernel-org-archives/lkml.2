Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2EAAFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:05:51 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:52058 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab2EAAFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:05:48 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 37/41] rcu: New rcu_user_enter() and rcu_user_exit() APIs
Date: Tue,  1 May 2012 01:55:11 +0200
Message-Id: <1335830115-14335-38-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two APIs are provided to help the implementation
of an adaptive tickless kernel (cf: nohz cpusets). We need
to run into RCU extended quiescent state when we are in
userland so that a tickless CPU is not involved in the
global RCU state machine and can shutdown its tick safely.

These APIs are called from syscall and exception entry/exit
points and can't be called from interrupt.

They are essentially the same than rcu_idle_enter() and
rcu_idle_exit() minus the checks that ensure the CPU is
running the idle task.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
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
 include/linux/rcupdate.h |    5 ++
 kernel/rcutree.c         |  107 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 81 insertions(+), 31 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e06639e..6539290 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -191,6 +191,11 @@ extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+void rcu_user_enter(void);
+void rcu_user_exit(void);
+#endif
+
 /*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b8d300c..cba1332 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -357,16 +357,8 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
-/*
- * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
- *
- * If the new value of the ->dynticks_nesting counter now is zero,
- * we really have entered idle, and must do the appropriate accounting.
- * The caller must have disabled interrupts.
- */
-static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
+static void rcu_check_idle_enter(long long oldval)
 {
-	trace_rcu_dyntick("Start", oldval, 0);
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
@@ -376,6 +368,18 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+}
+
+/*
+ * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
+ *
+ * If the new value of the ->dynticks_nesting counter now is zero,
+ * we really have entered idle, and must do the appropriate accounting.
+ * The caller must have disabled interrupts.
+ */
+static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
+{
+	trace_rcu_dyntick("Start", oldval, 0);
 	rcu_prepare_for_idle(smp_processor_id());
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
@@ -384,6 +388,22 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
+static long long __rcu_idle_enter(void)
+{
+	unsigned long flags;
+	long long oldval;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
+	rdtp->dynticks_nesting = 0;
+	rcu_idle_enter_common(rdtp, oldval);
+	local_irq_restore(flags);
+
+	return oldval;
+}
+
 /**
  * rcu_idle_enter - inform RCU that current CPU is entering idle
  *
@@ -398,16 +418,15 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
  */
 void rcu_idle_enter(void)
 {
-	unsigned long flags;
 	long long oldval;
-	struct rcu_dynticks *rdtp;
 
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	oldval = rdtp->dynticks_nesting;
-	rdtp->dynticks_nesting = 0;
-	rcu_idle_enter_common(rdtp, oldval);
-	local_irq_restore(flags);
+	oldval = __rcu_idle_enter();
+	rcu_check_idle_enter(oldval);
+}
+
+void rcu_user_enter(void)
+{
+	__rcu_idle_enter();
 }
 
 /**
@@ -437,6 +456,7 @@ void rcu_irq_exit(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
+
 	if (rdtp->dynticks_nesting)
 		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
 	else
@@ -444,6 +464,20 @@ void rcu_irq_exit(void)
 	local_irq_restore(flags);
 }
 
+static void rcu_check_idle_exit(struct rcu_dynticks *rdtp, long long oldval)
+{
+	if (!is_idle_task(current)) {
+		struct task_struct *idle = idle_task(smp_processor_id());
+
+		trace_rcu_dyntick("Error on exit: not idle task",
+				  oldval, rdtp->dynticks_nesting);
+		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
+	}
+}
+
 /*
  * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
  *
@@ -460,16 +494,18 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
-	if (!is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+}
 
-		trace_rcu_dyntick("Error on exit: not idle task",
-				  oldval, rdtp->dynticks_nesting);
-		ftrace_dump(DUMP_ALL);
-		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
-			  current->pid, current->comm,
-			  idle->pid, idle->comm); /* must be idle task! */
-	}
+static long long __rcu_idle_exit(struct rcu_dynticks *rdtp)
+{
+	long long oldval;
+
+	oldval = rdtp->dynticks_nesting;
+	WARN_ON_ONCE(oldval != 0);
+	rdtp->dynticks_nesting = LLONG_MAX / 2;
+	rcu_idle_exit_common(rdtp, oldval);
+
+	return oldval;
 }
 
 /**
@@ -485,16 +521,25 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
  */
 void rcu_idle_exit(void)
 {
+	long long oldval;
+	struct rcu_dynticks *rdtp;
 	unsigned long flags;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = __rcu_idle_exit(rdtp);
+	rcu_check_idle_exit(rdtp, oldval);
+	local_irq_restore(flags);
+}
+
+void rcu_user_exit(void)
+{
 	struct rcu_dynticks *rdtp;
-	long long oldval;
+	unsigned long flags;
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE(oldval != 0);
-	rdtp->dynticks_nesting = DYNTICK_TASK_NESTING;
-	rcu_idle_exit_common(rdtp, oldval);
+	 __rcu_idle_exit(rdtp);
 	local_irq_restore(flags);
 }
 
-- 
1.7.5.4

