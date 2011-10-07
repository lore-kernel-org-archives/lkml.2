Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab1JGQWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:22:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37783 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1JGQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:22:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 02/11] rcu: Inform the user about extended quiescent state on PROVE_RCU warning
Date: Fri,  7 Oct 2011 18:22:01 +0200
Message-Id: <1318004530-705-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.5.4

