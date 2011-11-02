Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1KBUgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:36:25 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51238 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab1KBUbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH RFC tip/core/rcu 13/28] rcu: Inform the user about extended quiescent state on PROVE_RCU warning
Date: Wed,  2 Nov 2011 13:30:34 -0700
Message-Id: <1320265849-5744-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-1976-0000-0000-000000ABACB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Inform the user if an RCU usage error is detected by lockdep while in
an extended quiescent state (in this case, the RCU-free window in idle).
This is accomplished by adding a line to the RCU lockdep splat indicating
whether or not the splat occurred in extended quiescent state.

Uses of RCU from within extended quiescent state mode are totally ignored
by RCU, hence the importance of this diagnostic.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/lockdep.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1e48f1c..8873f6e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4026,6 +4026,28 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
 	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
+
+	/*
+	 * If a CPU is in the RCU-free window in idle (ie: in the section
+	 * between rcu_idle_enter() and rcu_idle_exit(), then RCU
+	 * considers that CPU to be in an "extended quiescent state",
+	 * which means that RCU will be completely ignoring that CPU.
+	 * Therefore, rcu_read_lock() and friends have absolutely no
+	 * effect on a CPU running in that state. In other words, even if
+	 * such an RCU-idle CPU has called rcu_read_lock(), RCU might well
+	 * delete data structures out from under it.  RCU really has no
+	 * choice here: we need to keep an RCU-free window in idle where
+	 * the CPU may possibly enter into low power mode. This way we can
+	 * notice an extended quiescent state to other CPUs that started a grace
+	 * period. Otherwise we would delay any grace period as long as we run
+	 * in the idle task.
+	 *
+	 * So complain bitterly if someone does call rcu_read_lock(),
+	 * rcu_read_lock_bh() and so on from extended quiescent states.
+	 */
+	if (rcu_is_cpu_idle())
+		printk("RCU used illegally from extended quiescent state!\n");
+
 	lockdep_print_held_locks(curr);
 	printk("\nstack backtrace:\n");
 	dump_stack();
-- 
1.7.3.2

