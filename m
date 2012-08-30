Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2H3VTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:19:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38789 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2H3VOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/26] rcu: Allow rcu_user_enter()/exit() to nest
Date: Thu, 30 Aug 2012 14:05:22 -0700
Message-Id: <1346360743-3628-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-7282-0000-0000-00000C766162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   41 +++++++++++++++++++++++++++++++++--------
 kernel/rcutree.h |    3 +++
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e287c4a..8bbc7fb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -390,11 +390,9 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
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
@@ -403,7 +401,6 @@ static void rcu_eqs_enter(bool user)
 	else
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
 	rcu_eqs_enter_common(rdtp, oldval, user);
-	local_irq_restore(flags);
 }
 
 /**
@@ -420,7 +417,11 @@ static void rcu_eqs_enter(bool user)
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
 
@@ -435,7 +436,18 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
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
 
@@ -530,11 +542,9 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
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
@@ -543,7 +553,6 @@ static void rcu_eqs_exit(bool user)
 	else
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_eqs_exit_common(rdtp, oldval, user);
-	local_irq_restore(flags);
 }
 
 /**
@@ -559,7 +568,11 @@ static void rcu_eqs_exit(bool user)
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
 
@@ -572,7 +585,16 @@ EXPORT_SYMBOL_GPL(rcu_idle_exit);
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
 
@@ -2590,6 +2612,9 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
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
index 4d29169..0dd5fd6 100644
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
1.7.8

