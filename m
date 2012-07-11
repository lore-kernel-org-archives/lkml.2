Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab2GKS1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:27:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47918 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231Ab2GKS1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:27:00 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/11] rcu: Allow rcu_user_enter()/exit() to nest
Date: Wed, 11 Jul 2012 20:26:31 +0200
Message-Id: <1342031200-22731-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
References: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow calls to rcu_user_enter() even if we are already
in userspace (as seen by RCU) and allow calls to rcu_user_exit()
even if we are already in the kernel.

This makes the APIs more flexible to be called from architectures.
Exception entries for example won't need to know if they come from
userspace before calling rcu_user_exit().

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
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rcutree.c |   41 +++++++++++++++++++++++++++++++++--------
 kernel/rcutree.h |    3 +++
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index efa5983..d5df618 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -389,11 +389,9 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
  */
 static void rcu_eqs_enter(bool user)
 {
-	unsigned long flags;
 	long long oldval;
 	struct rcu_dynticks *rdtp;
 
-	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
@@ -402,7 +400,6 @@ static void rcu_eqs_enter(bool user)
 	else
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
 	rcu_eqs_enter_common(rdtp, oldval, user);
-	local_irq_restore(flags);
 }
 
 /**
@@ -419,7 +416,11 @@ static void rcu_eqs_enter(bool user)
  */
 void rcu_idle_enter(void)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	rcu_eqs_enter(0);
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
@@ -434,7 +435,18 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
  */
 void rcu_user_enter(void)
 {
-	rcu_eqs_enter(1);
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	WARN_ON_ONCE(!current->mm);
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	if (!rdtp->in_user) {
+		rdtp->in_user = true;
+		rcu_eqs_enter(1);
+	}
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_user_enter);
 
@@ -529,11 +541,9 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
  */
 static void rcu_eqs_exit(bool user)
 {
-	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 	long long oldval;
 
-	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
@@ -542,7 +552,6 @@ static void rcu_eqs_exit(bool user)
 	else
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_eqs_exit_common(rdtp, oldval, user);
-	local_irq_restore(flags);
 }
 
 /**
@@ -558,7 +567,11 @@ static void rcu_eqs_exit(bool user)
  */
 void rcu_idle_exit(void)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	rcu_eqs_exit(0);
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
@@ -571,7 +584,16 @@ EXPORT_SYMBOL_GPL(rcu_idle_exit);
  */
 void rcu_user_exit(void)
 {
-	rcu_eqs_exit(1);
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	if (rdtp->in_user) {
+		rdtp->in_user = false;
+		rcu_eqs_exit(1);
+	}
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_user_exit);
 
@@ -2660,6 +2682,9 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
+#ifdef CONFIG_RCU_USER_QS
+	WARN_ON_ONCE(rdp->dynticks->in_user);
+#endif
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index cad96cb..4d82cb5 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -102,6 +102,9 @@ struct rcu_dynticks {
 				    /* idle-period nonlazy_posted snapshot. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
+#ifdef CONFIG_RCU_USER_QS
+	bool in_user;		    /* Is the CPU in userland from RCU POV? */
+#endif
 };
 
 /* RCU's kthread states for tracing. */
-- 
1.7.5.4

