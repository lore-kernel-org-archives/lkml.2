Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1K1VdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:33:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45351 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1K1VdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:33:19 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 16:33:18 EST
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 3/4 RFC] rcu: New rcu_user_enter() and rcu_user_exit() APIs
Date: Mon, 28 Nov 2011 22:24:46 +0100
Message-Id: <1322515487-18690-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
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
Cc: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |   98 +++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 68 insertions(+), 30 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b80cb41..00a9fba 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -341,6 +341,15 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
+static void rcu_check_idle_enter(void)
+{
+	if (!idle_cpu(smp_processor_id())) {
+		WARN_ON_ONCE(1);	/* must be idle task! */
+		trace_rcu_dyntick("Error on entry: not idle task", 0);
+		ftrace_dump(DUMP_ALL);
+	}
+}
+
 /*
  * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
  *
@@ -351,11 +360,6 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
 {
 	trace_rcu_dyntick("Start", 0);
-	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
-		trace_rcu_dyntick("Error on entry: not idle task", 0);
-		ftrace_dump(DUMP_ALL);
-	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
@@ -363,6 +367,18 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
+static void __rcu_idle_enter(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp->dynticks_nesting = 0;
+	rcu_idle_enter_common(rdtp);
+	local_irq_restore(flags);
+}
+
 /**
  * rcu_idle_enter - inform RCU that current CPU is entering idle
  *
@@ -377,14 +393,13 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
  */
 void rcu_idle_enter(void)
 {
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
+	__rcu_idle_enter();
+	rcu_check_idle_enter();
+}
 
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	rdtp->dynticks_nesting = 0;
-	rcu_idle_enter_common(rdtp);
-	local_irq_restore(flags);
+void rcu_user_enter(void)
+{
+	__rcu_idle_enter();
 }
 
 /**
@@ -412,13 +427,24 @@ void rcu_irq_exit(void)
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
-	if (rdtp->dynticks_nesting)
+	if (rdtp->dynticks_nesting) {
 		trace_rcu_dyntick("--=", rdtp->dynticks_nesting);
-	else
+	} else {
 		rcu_idle_enter_common(rdtp);
+		rcu_check_idle_enter();
+	}
 	local_irq_restore(flags);
 }
 
+static void rcu_check_idle_exit(long long oldval)
+{
+	if (!idle_cpu(smp_processor_id())) {
+		WARN_ON_ONCE(1);	/* must be idle task! */
+		trace_rcu_dyntick("Error on exit: not idle task", oldval);
+		ftrace_dump(DUMP_ALL);
+	}
+}
+
 /*
  * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
  *
@@ -434,11 +460,23 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	trace_rcu_dyntick("End", oldval);
-	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
-		trace_rcu_dyntick("Error on exit: not idle task", oldval);
-		ftrace_dump(DUMP_ALL);
-	}
+}
+
+static long long __rcu_idle_exit(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+	long long oldval;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
+	WARN_ON_ONCE(oldval != 0);
+	rdtp->dynticks_nesting = LLONG_MAX / 2;
+	rcu_idle_exit_common(rdtp, oldval);
+	local_irq_restore(flags);
+
+	return oldval;
 }
 
 /**
@@ -454,17 +492,15 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
  */
 void rcu_idle_exit(void)
 {
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
 	long long oldval;
 
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE(oldval != 0);
-	rdtp->dynticks_nesting = LLONG_MAX / 2;
-	rcu_idle_exit_common(rdtp, oldval);
-	local_irq_restore(flags);
+	oldval = __rcu_idle_exit();
+	rcu_check_idle_exit(oldval);
+}
+
+void rcu_user_exit(void)
+{
+	__rcu_idle_exit();
 }
 
 /**
@@ -497,10 +533,12 @@ void rcu_irq_enter(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
-	if (oldval)
+	if (oldval) {
 		trace_rcu_dyntick("++=", rdtp->dynticks_nesting);
-	else
+	} else {
+		rcu_check_idle_exit(oldval);
 		rcu_idle_exit_common(rdtp, oldval);
+	}
 	local_irq_restore(flags);
 }
 
-- 
1.7.5.4

