Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2L2QpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:45:18 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:63410 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2L2QoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:44:07 -0500
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
Subject: [PATCH 22/27] nohz: Don't turn off the tick if rcu needs it
Date: Sat, 29 Dec 2012 17:43:01 +0100
Message-Id: <1356799386-4212-23-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If RCU is waiting for the current CPU to complete a grace
period, don't turn off the tick. Unlike dynctik-idle, we
are not necessarily going to enter into rcu extended quiescent
state, so we may need to keep the tick to note current CPU's
quiescent states.

[added build fix from Zen Lin]

CHECKME: OTOH we don't want to handle a locally started
grace period, this should be offloaded for rcu_nocb CPUs.
What we want is to be kicked if we stay dynticks in the kernel
for too long (ie: to report a quiescent state).
rcu_pending() is perhaps an overkill just for that.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/rcupdate.h |    1 +
 kernel/rcutree.c         |    3 +--
 kernel/time/tick-sched.c |    3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 829312e..2ebadac 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -211,6 +211,7 @@ static inline int rcu_preempt_depth(void)
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
+extern int rcu_pending(int cpu);
 struct notifier_block;
 extern void rcu_idle_enter(void);
 extern void rcu_idle_exit(void);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e9e0ffa..6ba3e02 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -232,7 +232,6 @@ module_param(jiffies_till_next_fqs, ulong, 0644);
 
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
 static void force_quiescent_state(struct rcu_state *rsp);
-static int rcu_pending(int cpu);
 
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
@@ -2521,7 +2520,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-static int rcu_pending(int cpu)
+int rcu_pending(int cpu)
 {
 	struct rcu_state *rsp;
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 78e5341..04504c4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -596,6 +596,9 @@ static bool can_stop_full_tick(int cpu)
 	if (!rcu_is_nocb_cpu(cpu))
 		return false;
 
+	if (rcu_pending(cpu))
+		return false;
+
 	return true;
 }
 #endif
-- 
1.7.5.4

