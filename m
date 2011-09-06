Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1IGGZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:25:57 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52601 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab1IGGVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 16/55] rcu: Put names into TINY_RCU structures under RCU_TRACE
Date: Tue,  6 Sep 2011 11:00:10 -0700
Message-Id: <1315332049-2604-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

In order to allow event tracing to distinguish between flavors of
RCU, we need those names in the relevant RCU data structures.  TINY_RCU
has avoided them for memory-footprint reasons, so add them only if
CONFIG_RCU_TRACE=y.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu.h            |   10 ++++++++--
 kernel/rcutiny.c        |   13 -------------
 kernel/rcutiny_plugin.h |   10 ++++------
 kernel/rcutree.c        |   10 +++++-----
 kernel/rcutree_plugin.h |    2 +-
 5 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/kernel/rcu.h b/kernel/rcu.h
index 7bc1643..d7f00ec 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -23,6 +23,12 @@
 #ifndef __LINUX_RCU_H
 #define __LINUX_RCU_H
 
+#ifdef CONFIG_RCU_TRACE
+#define RCU_TRACE(stmt) stmt
+#else /* #ifdef CONFIG_RCU_TRACE */
+#define RCU_TRACE(stmt)
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
 /*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
  * by call_rcu() and rcu callback execution, and are therefore not part of the
@@ -68,10 +74,10 @@ static inline void __rcu_reclaim(struct rcu_head *head)
 	unsigned long offset = (unsigned long)head->func;
 
 	if (__is_kfree_rcu_offset(offset)) {
-		trace_rcu_invoke_kfree_callback(head, offset);
+		RCU_TRACE(trace_rcu_invoke_kfree_callback(head, offset));
 		kfree((void *)head - offset);
 	} else {
-		trace_rcu_invoke_callback(head);
+		RCU_TRACE(trace_rcu_invoke_callback(head));
 		head->func(head);
 	}
 }
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 19453ba..0d28974 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -38,20 +38,7 @@
 #include <linux/prefetch.h>
 
 #ifdef CONFIG_RCU_TRACE
-
 #include <trace/events/rcu.h>
-
-#else /* #ifdef CONFIG_RCU_TRACE */
-
-/* No by-default tracing in TINY_RCU: Keep TINY_RCU tiny! */
-static void trace_rcu_invoke_kfree_callback(struct rcu_head *rhp,
-					    unsigned long offset)
-{
-}
-static void trace_rcu_invoke_callback(struct rcu_head *head)
-{
-}
-
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
 #include "rcu.h"
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 6b0cedb..791ddf7 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -26,29 +26,26 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
-#ifdef CONFIG_RCU_TRACE
-#define RCU_TRACE(stmt)	stmt
-#else /* #ifdef CONFIG_RCU_TRACE */
-#define RCU_TRACE(stmt)
-#endif /* #else #ifdef CONFIG_RCU_TRACE */
-
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
 	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
 	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
 	struct rcu_head **curtail;	/* ->next pointer of last CB. */
 	RCU_TRACE(long qlen);		/* Number of pending CBs. */
+	RCU_TRACE(char *name);		/* Name of RCU type. */
 };
 
 /* Definition for rcupdate control block. */
 static struct rcu_ctrlblk rcu_sched_ctrlblk = {
 	.donetail	= &rcu_sched_ctrlblk.rcucblist,
 	.curtail	= &rcu_sched_ctrlblk.rcucblist,
+	RCU_TRACE(.name = "rcu_sched")
 };
 
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.donetail	= &rcu_bh_ctrlblk.rcucblist,
 	.curtail	= &rcu_bh_ctrlblk.rcucblist,
+	RCU_TRACE(.name = "rcu_bh")
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -131,6 +128,7 @@ static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
 	.rcb.curtail = &rcu_preempt_ctrlblk.rcb.rcucblist,
 	.nexttail = &rcu_preempt_ctrlblk.rcb.rcucblist,
 	.blkd_tasks = LIST_HEAD_INIT(rcu_preempt_ctrlblk.blkd_tasks),
+	RCU_TRACE(.rcb.name = "rcu_preempt")
 };
 
 static int rcu_preempted_readers_exp(void);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2a9643b..b953e2c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -61,7 +61,7 @@
 static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 
 #define RCU_STATE_INITIALIZER(structname) { \
-	.level = { &structname.node[0] }, \
+	.level = { &structname##_state.node[0] }, \
 	.levelcnt = { \
 		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
 		NUM_RCU_LVL_1, \
@@ -72,17 +72,17 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
-	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname.onofflock), \
-	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname.fqslock), \
+	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.onofflock), \
+	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
 	.name = #structname, \
 }
 
-struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched_state);
+struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched);
 DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 
-struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
+struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 static struct rcu_state *rcu_state;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 43daa46..a90bf3c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -64,7 +64,7 @@ static void __init rcu_bootup_announce_oddness(void)
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
-struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
+struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
-- 
1.7.3.2

