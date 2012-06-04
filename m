Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab2FDMJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:09:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45477 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033Ab2FDMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:09:09 -0400
From: fweisbec@gmail.com
To: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] rcu: New rcu_user_enter() and rcu_user_exit() APIs
Date: Mon,  4 Jun 2012 14:08:27 +0200
Message-Id: <1338811708-18819-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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
 include/linux/rcupdate.h |    2 +
 kernel/rcutree.c         |  135 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 112 insertions(+), 25 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b737a5b..e8323df 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -191,6 +191,8 @@ extern void rcu_idle_enter(void);
 extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
+extern void rcu_user_enter(void);
+extern void rcu_user_exit(void);
 extern void exit_rcu(void);
 
 /**
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6acb7c0..59ac305 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -349,6 +349,29 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 	return 0;
 }
 
+static void rcu_check_idle_entry(void)
+{
+	struct task_struct *idle;
+	struct rcu_dynticks *rdtp;
+	unsigned long flags;
+
+	if (is_idle_task(current))
+		return;
+
+	local_irq_save(flags);
+
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	idle = idle_task(smp_processor_id());
+
+	trace_rcu_dyntick("Error on entry: not idle task", rdtp->dynticks_nesting, 0);
+	ftrace_dump(DUMP_ORIG);
+	WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+		  current->pid, current->comm,
+		  idle->pid, idle->comm); /* must be idle task! */
+
+	local_irq_restore(flags);
+}
+
 /*
  * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
  *
@@ -359,15 +382,6 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 {
 	trace_rcu_dyntick("Start", oldval, 0);
-	if (!is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
-
-		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
-		ftrace_dump(DUMP_ORIG);
-		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
-			  current->pid, current->comm,
-			  idle->pid, idle->comm); /* must be idle task! */
-	}
 	rcu_prepare_for_idle(smp_processor_id());
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
@@ -387,8 +401,9 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 			   "Illegal idle entry in RCU-sched read-side critical section.");
 }
 
-/**
- * rcu_idle_enter - inform RCU that current CPU is entering idle
+/*
+ * __rcu_idle_enter - inform RCU that current CPU is entering RCU
+ * idle mode.
  *
  * Enter idle mode, in other words, -leave- the mode in which RCU
  * read-side critical sections can occur.  (Though RCU read-side
@@ -399,7 +414,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
  * the possibility of usermode upcalls having messed up our count
  * of interrupt nesting level during the prior busy period.
  */
-void rcu_idle_enter(void)
+static void __rcu_idle_enter(void)
 {
 	unsigned long flags;
 	long long oldval;
@@ -416,9 +431,38 @@ void rcu_idle_enter(void)
 	rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
+
+/**
+ * rcu_idle_enter - inform RCU that current CPU is entering RCU
+ * idle mode from the idle task.
+ *
+ * Enter idle mode from the idle task before we put the CPU into
+ * low power mode. No use of RCU is permitted between this call and
+ * rcu_idle_exit(). This way the CPU doesn't need to keep the
+ * timer tick to report quiescent states, which is desired for energy
+ * savings.
+ */
+void rcu_idle_enter(void)
+{
+	rcu_check_idle_entry();
+	__rcu_idle_enter();
+}
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 /**
+ * rcu_user_enter - inform RCU that we are resuming userspace.
+ *
+ * Enter RCU idle mode right before resuming userspace. No use of RCU
+ * is permitted between this call and rcu_user_exit(). This way the
+ * CPU doesn't need to maintain the tick for RCU maintainance purpose
+ * when the CPU runs in userspace.
+ */
+void rcu_user_enter(void)
+{
+	__rcu_idle_enter();
+}
+
+/**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
  *
  * Exit from an interrupt handler, which might possibly result in entering
@@ -452,6 +496,29 @@ void rcu_irq_exit(void)
 	local_irq_restore(flags);
 }
 
+static void rcu_check_idle_exit(long long oldval)
+{
+	struct task_struct *idle;
+	struct rcu_dynticks *rdtp;
+	unsigned long flags;
+
+	if (is_idle_task(current))
+		return;
+
+	local_irq_save(flags);
+
+	idle = idle_task(smp_processor_id());
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	trace_rcu_dyntick("Error on exit: not idle task",
+			  oldval, rdtp->dynticks_nesting);
+	ftrace_dump(DUMP_ORIG);
+	WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+		  current->pid, current->comm,
+		  idle->pid, idle->comm); /* must be idle task! */
+
+	local_irq_restore(flags);
+}
+
 /*
  * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
  *
@@ -468,20 +535,11 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
-	if (!is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
-
-		trace_rcu_dyntick("Error on exit: not idle task",
-				  oldval, rdtp->dynticks_nesting);
-		ftrace_dump(DUMP_ORIG);
-		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
-			  current->pid, current->comm,
-			  idle->pid, idle->comm); /* must be idle task! */
-	}
 }
 
-/**
- * rcu_idle_exit - inform RCU that current CPU is leaving idle
+/*
+ * rcu_idle_exit - inform RCU that current CPU is leaving RCU
+ * idle mode.
  *
  * Exit idle mode, in other words, -enter- the mode in which RCU
  * read-side critical sections can occur.
@@ -491,7 +549,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
  * of interrupt nesting level during the busy period that is just
  * now starting.
  */
-void rcu_idle_exit(void)
+static long long __rcu_idle_exit(void)
 {
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
@@ -507,10 +565,37 @@ void rcu_idle_exit(void)
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
+
+	return oldval;
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
 /**
+ * rcu_idle_exit - inform RCU that current CPU is leaving RCU
+ * idle mode from the idle task.
+ *
+ * Exit idle mode from the idle task after we wake the CPU up from
+ * low power mode. The CPU can make use of RCU read side critical
+ * sections again after this call.
+ */
+void rcu_idle_exit(void)
+{
+	long long oldval = __rcu_idle_exit();
+	rcu_check_idle_exit(oldval);
+}
+
+/**
+ * rcu_user_exit - inform RCU that we are exiting userspace.
+ *
+ * Exit RCU idle mode while entering the kernel because it can
+ * run an RCU read side critical section anytime.
+ */
+void rcu_user_exit(void)
+{
+	__rcu_idle_exit();
+}
+
+/**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
  *
  * Enter an interrupt handler, which might possibly result in exiting
-- 
1.7.5.4

