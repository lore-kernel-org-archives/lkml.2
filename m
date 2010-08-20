Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0HTSqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:46:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51057 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0HTSpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:45:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/7] rcu: repair code-duplication FIXMEs
Date: Fri, 20 Aug 2010 11:45:40 -0700
Message-Id: <1282329945-26043-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100820184521.GA24715@linux.vnet.ibm.com>
References: <20100820184521.GA24715@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine the duplicate definitions of ULONG_CMP_GE(), ULONG_CMP_LT(),
and rcu_preempt_depth() into include/linux/rcupdate.h.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   15 +++++++++++++++
 include/linux/rcutiny.h  |    7 -------
 include/linux/rcutree.h  |    6 ------
 kernel/rcutiny_plugin.h  |    4 ----
 kernel/rcutree.h         |    3 ---
 5 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d7af96e..325bad7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -47,6 +47,9 @@
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+#define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
+#define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
+
 /**
  * struct rcu_head - callback structure for use with RCU
  * @next: next update requests in a list
@@ -66,6 +69,18 @@ extern int sched_expedited_torture_stats(char *page);
 /* Internal to kernel */
 extern void rcu_init(void);
 
+#ifdef CONFIG_PREEMPT_RCU
+
+/*
+ * Defined as a macro as it is a very low level header included from
+ * areas that don't even know about current.  This gives the rcu_read_lock()
+ * nesting depth, but makes sense only if CONFIG_PREEMPT_RCU -- in other
+ * types of kernel builds, the rcu_read_lock() nesting depth is unknowable.
+ */
+#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
+
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
 #elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 3fa1797..c6b11dc 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -133,13 +133,6 @@ static inline int rcu_needs_cpu(int cpu)
 	return rcu_preempt_needs_cpu();
 }
 
-/*
- * Defined as macro as it is a very low level header
- * included from areas that don't even know about current
- * FIXME: combine with include/linux/rcutree.h into rcupdate.h.
- */
-#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
-
 #endif /* #else #ifdef CONFIG_TINY_RCU */
 
 static inline void rcu_note_context_switch(int cpu)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 0726809..54a20c1 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -45,12 +45,6 @@ extern void __rcu_read_unlock(void);
 extern void synchronize_rcu(void);
 extern void exit_rcu(void);
 
-/*
- * Defined as macro as it is a very low level header
- * included from areas that don't even know about current
- */
-#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
-
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock(void)
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index e6bc1b4..c5bea11 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -26,10 +26,6 @@
 
 #include <linux/delay.h>
 
-/* FIXME: merge with definitions in kernel/rcutree.h. */
-#define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
-#define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
-
 /* Global control variables for preemptible RCU. */
 struct rcu_preempt_ctrlblk {
 	struct rcu_ctrlblk rcb;	/* curtail: ->next ptr of last CB for GP. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7abd439..7918ba6 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -272,9 +272,6 @@ struct rcu_data {
 
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
-#define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
-#define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
-
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
  * represented in "heap" form in a dense array.  The root (first level)
-- 
1.7.0.6

