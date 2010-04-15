Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab0DOSQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:16:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45212 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab0DOSNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:13:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 13/16] rcu: print boot-time console messages if RCU configs out of ordinary
Date: Thu, 15 Apr 2010 11:13:36 -0700
Message-Id: <1271355219-20714-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100415181255.GA19588@linux.vnet.ibm.com>
References: <20100415181255.GA19588@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print boot-time messages if tracing is enabled, if fanout is set
to non-default values, if exact fanout is specified, if accelerated
dyntick-idle grace periods have been enabled, if RCU-lockdep is enabled,
if rcutorture has been boot-time enabled, if the CPU stall detector has
been disabled, or if four-level hierarchy has been enabled.

This is all for TREE_RCU and TREE_PREEMPT_RCU.  TINY_RCU will be handled
separately, if at all.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    6 ------
 kernel/rcutree_plugin.h |   44 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 595fb83..ec6196f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1938,12 +1938,6 @@ void __init rcu_init(void)
 	int cpu;
 
 	rcu_bootup_announce();
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-#if NUM_RCU_LVL_4 != 0
-	printk(KERN_INFO "Experimental four-level hierarchy is enabled.\n");
-#endif /* #if NUM_RCU_LVL_4 != 0 */
 	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
 	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
 	__rcu_init_preempt();
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f9bc83a..0ae2339 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -26,6 +26,45 @@
 
 #include <linux/delay.h>
 
+/*
+ * Check the RCU kernel configuration parameters and print informative
+ * messages about anything out of the ordinary.  If you like #ifdef, you
+ * will love this function.
+ */
+static void __init rcu_bootup_announce_oddness(void)
+{
+#ifdef CONFIG_RCU_TRACE
+	printk(KERN_INFO "\tRCU debugfs-based tracing is enabled.\n");
+#endif
+#if (defined(CONFIG_64BIT) && CONFIG_RCU_FANOUT != 64) || (!defined(CONFIG_64BIT) && CONFIG_RCU_FANOUT != 32)
+	printk(KERN_INFO "\tCONFIG_RCU_FANOUT set to non-default value of %d\n",
+	       CONFIG_RCU_FANOUT);
+#endif
+#ifdef CONFIG_RCU_FANOUT_EXACT
+	printk(KERN_INFO "\tHierarchical RCU autobalancing is disabled.\n");
+#endif
+#ifdef CONFIG_RCU_FAST_NO_HZ
+	printk(KERN_INFO
+	       "\tRCU dyntick-idle grace-period acceleration is enabled.\n");
+#endif
+#ifdef CONFIG_PROVE_RCU
+	printk(KERN_INFO "\tRCU lockdep checking is enabled.\n");
+#endif
+#ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
+	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
+#endif
+#ifndef CONFIG_RCU_CPU_STALL_DETECTOR
+	printk(KERN_INFO
+	       "\tRCU-based detection of stalled CPUs is disabled.\n");
+#endif
+#ifndef CONFIG_RCU_CPU_STALL_VERBOSE
+	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
+#endif
+#if NUM_RCU_LVL_4 != 0
+	printk(KERN_INFO "\tExperimental four-level hierarchy is enabled.\n");
+#endif
+}
+
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
@@ -38,8 +77,8 @@ static int rcu_preempted_readers_exp(struct rcu_node *rnp);
  */
 static void __init rcu_bootup_announce(void)
 {
-	printk(KERN_INFO
-	       "Experimental preemptable hierarchical RCU implementation.\n");
+	printk(KERN_INFO "Preemptable hierarchical RCU implementation.\n");
+	rcu_bootup_announce_oddness();
 }
 
 /*
@@ -757,6 +796,7 @@ void exit_rcu(void)
 static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
+	rcu_bootup_announce_oddness();
 }
 
 /*
-- 
1.7.0

