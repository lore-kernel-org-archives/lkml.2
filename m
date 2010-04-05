Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0DESgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:36:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36931 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0DESem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:34:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 10/10] rcu: slim down rcutiny by removing rcu_scheduler_active and friends
Date: Mon,  5 Apr 2010 11:34:32 -0700
Message-Id: <1270492472-23222-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100405183403.GA23075@linux.vnet.ibm.com>
References: <20100405183403.GA23075@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TINY_RCU does not need rcu_scheduler_active unless CONFIG_DEBUG_LOCK_ALLOC.
So conditionally compile rcu_scheduler_active in order to slim down
rcutiny a bit more.  Also gets rid of an EXPORT_SYMBOL_GPL, which is
responsible for most of the slimming.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    4 +---
 include/linux/rcutiny.h  |   13 +++++++++++++
 include/linux/rcutree.h  |    3 +++
 kernel/rcupdate.c        |   19 -------------------
 kernel/rcutiny.c         |    7 +++++++
 kernel/rcutiny_plugin.h  |   39 +++++++++++++++++++++++++++++++++++++++
 kernel/rcutree.c         |   19 +++++++++++++++++++
 7 files changed, 82 insertions(+), 22 deletions(-)
 create mode 100644 kernel/rcutiny_plugin.h

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 56fa2d4..7a411b7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -64,8 +64,6 @@ extern int sched_expedited_torture_stats(char *page);
 
 /* Internal to kernel */
 extern void rcu_init(void);
-extern int rcu_scheduler_active;
-extern void rcu_scheduler_starting(void);
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
@@ -181,7 +179,7 @@ static inline int rcu_read_lock_bh_held(void)
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
-	return !rcu_scheduler_active || preempt_count() != 0 || irqs_disabled();
+	return preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index ff22b97..14e5a76 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -128,4 +128,17 @@ static inline int rcu_preempt_depth(void)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+extern int rcu_scheduler_active __read_mostly;
+extern void rcu_scheduler_starting(void);
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+static inline void rcu_scheduler_starting(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index b9f7460..4828205 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -123,4 +123,7 @@ static inline int rcu_blocking_is_gp(void)
 	return num_online_cpus() == 1;
 }
 
+extern void rcu_scheduler_starting(void);
+extern int rcu_scheduler_active __read_mostly;
+
 #endif /* __LINUX_RCUTREE_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 63fe254..9b19fee 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -44,7 +44,6 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
-#include <linux/kernel_stat.h>
 #include <linux/hardirq.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -64,9 +63,6 @@ struct lockdep_map rcu_sched_lock_map =
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 #endif
 
-int rcu_scheduler_active __read_mostly;
-EXPORT_SYMBOL_GPL(rcu_scheduler_active);
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 /**
@@ -90,21 +86,6 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /*
- * This function is invoked towards the end of the scheduler's initialization
- * process.  Before this is called, the idle task might contain
- * RCU read-side critical sections (during which time, this idle
- * task is booting the system).  After this function is called, the
- * idle tasks are prohibited from containing RCU read-side critical
- * sections.
- */
-void rcu_scheduler_starting(void)
-{
-	WARN_ON(num_online_cpus() != 1);
-	WARN_ON(nr_context_switches() > 0);
-	rcu_scheduler_active = 1;
-}
-
-/*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
  */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index d9f8a62..b1804ff 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -54,6 +54,11 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.curtail	= &rcu_bh_ctrlblk.rcucblist,
 };
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+int rcu_scheduler_active __read_mostly;
+EXPORT_SYMBOL_GPL(rcu_scheduler_active);
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 #ifdef CONFIG_NO_HZ
 
 static long rcu_dynticks_nesting = 1;
@@ -276,3 +281,5 @@ void __init rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
+
+#include "rcutiny_plugin.h"
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
new file mode 100644
index 0000000..d223a92
--- /dev/null
+++ b/kernel/rcutiny_plugin.h
@@ -0,0 +1,39 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ * Internal non-public definitions that provide either classic
+ * or preemptable semantics.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2009
+ *
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+#include <linux/kernel_stat.h>
+
+/*
+ * During boot, we forgive RCU lockdep issues.  After this function is
+ * invoked, we start taking RCU lockdep issues seriously.
+ */
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
+}
+
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e336313..3623f8e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -46,6 +46,7 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/time.h>
+#include <linux/kernel_stat.h>
 
 #include "rcutree.h"
 
@@ -80,6 +81,9 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+int rcu_scheduler_active __read_mostly;
+EXPORT_SYMBOL_GPL(rcu_scheduler_active);
+
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
@@ -1784,6 +1788,21 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 }
 
 /*
+ * This function is invoked towards the end of the scheduler's initialization
+ * process.  Before this is called, the idle task might contain
+ * RCU read-side critical sections (during which time, this idle
+ * task is booting the system).  After this function is called, the
+ * idle tasks are prohibited from containing RCU read-side critical
+ * sections.  This function also enables RCU lockdep checking.
+ */
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
+}
+
+/*
  * Compute the per-level fanout, either using the exact fanout specified
  * or balancing the tree, depending on CONFIG_RCU_FANOUT_EXACT.
  */
-- 
1.7.0

