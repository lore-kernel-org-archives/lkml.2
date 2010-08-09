Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab0HIFNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:13:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:39139 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0HIFNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:13:19 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH 2/2] rcu,debug_core: allow the kernel debugger to reset the rcu stall timer
Date: Mon,  9 Aug 2010 00:12:12 -0500
Message-Id: <1281330732-17164-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281330732-17164-2-git-send-email-jason.wessel@windriver.com>
References: <1281330732-17164-1-git-send-email-jason.wessel@windriver.com>
 <1281330732-17164-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Aug 2010 05:12:49.0615 (UTC) FILETIME=[82DEF5F0:01CB3781]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When returning from the kernel debugger allow a reset of the rcu
jiffies_stall value to prevent the rcu stall detector from sending NMI
events which stack dumps on all the cpus in the system.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Dipankar Sarma <dipankar@in.ibm.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h  |    8 ++++++++
 kernel/debug/debug_core.c |    2 ++
 kernel/rcutree.c          |    9 +++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9fbc54a..abd3ab6 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -599,4 +599,12 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 #define rcu_dereference_index_check(p, c) \
 	__rcu_dereference_index_check((p), (c))
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+extern void rcu_cpu_stall_reset(void);
+#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+static inline void rcu_cpu_stall_reset(void)
+{
+}
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index e4d6819..1600e90 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -47,6 +47,7 @@
 #include <linux/pid.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/rcupdate.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -474,6 +475,7 @@ static void dbg_touch_watchdogs(void)
 {
 	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
+	rcu_cpu_stall_reset();
 }
 
 static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d5bc439..209b755 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -532,6 +532,9 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_cpu_stall_panicking)
 		return;
+	/* Gracefully handle a watch dog reset when jiffies_stall == 0 */
+	if (!rsp->jiffies_stall)
+		return;
 	delta = jiffies - rsp->jiffies_stall;
 	rnp = rdp->mynode;
 	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
@@ -561,6 +564,12 @@ static void __init check_cpu_stall_init(void)
 	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
 }
 
+void rcu_cpu_stall_reset(void)
+{
+	rcu_sched_state.jiffies_stall = 0;
+	rcu_bh_state.jiffies_stall = 0;
+}
+
 #else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
-- 
1.6.3.3

