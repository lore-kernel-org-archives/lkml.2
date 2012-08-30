Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2H3VQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:16:55 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38879 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2H3VOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH tip/core/rcu 01/26] rcu: New rcu_user_enter() and rcu_user_exit() APIs
Date: Thu, 30 Aug 2012 14:05:18 -0700
Message-Id: <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120830210520.GA2824@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-7282-0000-0000-00000C7661D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

RCU currently insists that only idle tasks can enter RCU idle mode, which
prohibits an adaptive tickless kernel (AKA nohz cpusets), which in turn
would mean that usermode execution would always take scheduling-clock
interrupts, even when there is only one task runnable on the CPU in
question.

This commit therefore adds rcu_user_enter() and rcu_user_exit(), which
allow non-idle tasks to enter RCU idle mode.  These are quite similar
to rcu_idle_enter() and rcu_idle_exit(), respectively, except that they
omit the idle-task checks.

[ Updated to use "user" flag rather than separate check functions. ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rcupdate.h |    2 +
 kernel/rcutree.c         |  115 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 83 insertions(+), 34 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 115ead2..2a7549c 100644
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
index f280e54..c0507b7 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -346,16 +346,17 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 }
 
 /*
- * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
+ * rcu_eqs_enter_common - current CPU is moving towards extended quiescent state
  *
  * If the new value of the ->dynticks_nesting counter now is zero,
  * we really have entered idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
+static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
+				bool user)
 {
 	trace_rcu_dyntick("Start", oldval, 0);
-	if (!is_idle_task(current)) {
+	if (!is_idle_task(current) && !user) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
@@ -372,7 +373,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 
 	/*
-	 * The idle task is not permitted to enter the idle loop while
+	 * It is illegal to enter an extended quiescent state while
 	 * in an RCU read-side critical section.
 	 */
 	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
@@ -383,19 +384,11 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 			   "Illegal idle entry in RCU-sched read-side critical section.");
 }
 
-/**
- * rcu_idle_enter - inform RCU that current CPU is entering idle
- *
- * Enter idle mode, in other words, -leave- the mode in which RCU
- * read-side critical sections can occur.  (Though RCU read-side
- * critical sections can occur in irq handlers in idle, a possibility
- * handled by irq_enter() and irq_exit().)
- *
- * We crowbar the ->dynticks_nesting field to zero to allow for
- * the possibility of usermode upcalls having messed up our count
- * of interrupt nesting level during the prior busy period.
+/*
+ * Enter an RCU extended quiescent state, which can be either the
+ * idle loop or adaptive-tickless usermode execution.
  */
-void rcu_idle_enter(void)
+static void rcu_eqs_enter(bool user)
 {
 	unsigned long flags;
 	long long oldval;
@@ -409,12 +402,44 @@ void rcu_idle_enter(void)
 		rdtp->dynticks_nesting = 0;
 	else
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
-	rcu_idle_enter_common(rdtp, oldval);
+	rcu_eqs_enter_common(rdtp, oldval, user);
 	local_irq_restore(flags);
 }
+
+/**
+ * rcu_idle_enter - inform RCU that current CPU is entering idle
+ *
+ * Enter idle mode, in other words, -leave- the mode in which RCU
+ * read-side critical sections can occur.  (Though RCU read-side
+ * critical sections can occur in irq handlers in idle, a possibility
+ * handled by irq_enter() and irq_exit().)
+ *
+ * We crowbar the ->dynticks_nesting field to zero to allow for
+ * the possibility of usermode upcalls having messed up our count
+ * of interrupt nesting level during the prior busy period.
+ */
+void rcu_idle_enter(void)
+{
+	rcu_eqs_enter(0);
+}
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 /**
+ * rcu_user_enter - inform RCU that we are resuming userspace.
+ *
+ * Enter RCU idle mode right before resuming userspace.  No use of RCU
+ * is permitted between this call and rcu_user_exit(). This way the
+ * CPU doesn't need to maintain the tick for RCU maintenance purposes
+ * when the CPU runs in userspace.
+ */
+void rcu_user_enter(void)
+{
+	rcu_eqs_enter(1);
+}
+EXPORT_SYMBOL_GPL(rcu_user_enter);
+
+
+/**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
  *
  * Exit from an interrupt handler, which might possibly result in entering
@@ -444,18 +469,19 @@ void rcu_irq_exit(void)
 	if (rdtp->dynticks_nesting)
 		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
 	else
-		rcu_idle_enter_common(rdtp, oldval);
+		rcu_eqs_enter_common(rdtp, oldval, 1);
 	local_irq_restore(flags);
 }
 
 /*
- * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
+ * rcu_eqs_exit_common - current CPU moving away from extended quiescent state
  *
  * If the new value of the ->dynticks_nesting counter was previously zero,
  * we really have exited idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
+static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
+			       int user)
 {
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
@@ -464,7 +490,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
-	if (!is_idle_task(current)) {
+	if (!is_idle_task(current) && !user) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on exit: not idle task",
@@ -476,18 +502,11 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	}
 }
 
-/**
- * rcu_idle_exit - inform RCU that current CPU is leaving idle
- *
- * Exit idle mode, in other words, -enter- the mode in which RCU
- * read-side critical sections can occur.
- *
- * We crowbar the ->dynticks_nesting field to DYNTICK_TASK_NEST to
- * allow for the possibility of usermode upcalls messing up our count
- * of interrupt nesting level during the busy period that is just
- * now starting.
+/*
+ * Exit an RCU extended quiescent state, which can be either the
+ * idle loop or adaptive-tickless usermode execution.
  */
-void rcu_idle_exit(void)
+static void rcu_eqs_exit(bool user)
 {
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
@@ -501,12 +520,40 @@ void rcu_idle_exit(void)
 		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
 	else
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
-	rcu_idle_exit_common(rdtp, oldval);
+	rcu_eqs_exit_common(rdtp, oldval, user);
 	local_irq_restore(flags);
 }
+
+/**
+ * rcu_idle_exit - inform RCU that current CPU is leaving idle
+ *
+ * Exit idle mode, in other words, -enter- the mode in which RCU
+ * read-side critical sections can occur.
+ *
+ * We crowbar the ->dynticks_nesting field to DYNTICK_TASK_NEST to
+ * allow for the possibility of usermode upcalls messing up our count
+ * of interrupt nesting level during the busy period that is just
+ * now starting.
+ */
+void rcu_idle_exit(void)
+{
+	rcu_eqs_exit(0);
+}
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
 /**
+ * rcu_user_exit - inform RCU that we are exiting userspace.
+ *
+ * Exit RCU idle mode while entering the kernel because it can
+ * run a RCU read side critical section anytime.
+ */
+void rcu_user_exit(void)
+{
+	rcu_eqs_exit(1);
+}
+EXPORT_SYMBOL_GPL(rcu_user_exit);
+
+/**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
  *
  * Enter an interrupt handler, which might possibly result in exiting
@@ -539,7 +586,7 @@ void rcu_irq_enter(void)
 	if (oldval)
 		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
 	else
-		rcu_idle_exit_common(rdtp, oldval);
+		rcu_eqs_exit_common(rdtp, oldval, 1);
 	local_irq_restore(flags);
 }
 
-- 
1.7.8

