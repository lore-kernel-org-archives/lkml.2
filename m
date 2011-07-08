Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1GHPo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:44:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44959 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1GHPoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:44:23 -0400
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
Subject: [PATCH RFC tip/core/rcu 2/6] rcu: Inform the user about dynticks-idle mode on PROVE_RCU warning
Date: Fri,  8 Jul 2011 08:43:49 -0700
Message-Id: <1310139833-20804-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110708154331.GA20161@linux.vnet.ibm.com>
References: <20110708154331.GA20161@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Inform the user if an RCU usage error is detected by lockdep while in
an extended quiescent state (in this case, dyntick-idle mode).  This
is accomplished by adding a line to the RCU lockdep splat indicating
whether or not the splat occurred in dyntick-idle mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/lockdep.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 298c927..f2bff04 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3998,6 +3998,26 @@ void lockdep_rcu_dereference(const char *file, const int line)
 			file, line);
 	printk("\nother info that might help us debug this:\n\n");
 	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
+
+	/*
+	 * If a CPU is in dyntick-idle mode (CONFIG_NO_HZ), then RCU
+	 * considers that CPU to be in an "extended quiescent state",
+	 * which means that RCU will be completely ignoring that CPU.
+	 * Therefore, rcu_read_lock() and friends have absolutely no
+	 * effect on a dyntick-idle CPU.  In other words, even if a
+	 * dyntick-idle CPU has called rcu_read_lock(), RCU might well
+	 * delete data structures out from under it.  RCU really has no
+	 * choice here: if it were to consult the CPU, that would wake
+	 * the CPU up, and the whole point of dyntick-idle mode is to
+	 * allow CPUs to enter extremely deep sleep states.
+	 *
+	 * So complain bitterly if someone does call rcu_read_lock(),
+	 * rcu_read_lock_bh() and so on from extended quiescent states
+	 * such as dyntick-idle mode.
+	 */
+	if (rcu_check_extended_qs())
+		printk("RCU used illegally from extended quiescent state!\n");
+
 	lockdep_print_held_locks(curr);
 	printk("\nstack backtrace:\n");
 	dump_stack();
-- 
1.7.3.2

