Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0HTSp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:45:57 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47912 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab0HTSpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:45:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH tip/core/rcu 1/7] rcu: permit suppressing current grace period's CPU stall warnings
Date: Fri, 20 Aug 2010 11:45:39 -0700
Message-Id: <1282329945-26043-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100820184521.GA24715@linux.vnet.ibm.com>
References: <20100820184521.GA24715@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a kernel debugger, a long sojourn in the debugger can get
you lots of RCU CPU stall warnings once you resume.  This might not be
helpful, especially if you are using the system console.  This patch
therefore allows RCU CPU stall warnings to be suppressed, but only for
the duration of the current set of grace periods.

This differs from Jason's original patch in that it adds support for
tiny RCU and preemptible RCU, and uses a slightly different method for
suppressing the RCU CPU stall warning messages.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/rcutiny.h |    4 ++++
 include/linux/rcutree.h |    1 +
 kernel/rcutree.c        |   20 ++++++++++++++++++++
 kernel/rcutree.h        |    1 +
 kernel/rcutree_plugin.h |   18 ++++++++++++++++++
 5 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 4cc5eba..3fa1797 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -178,6 +178,10 @@ static inline void rcu_sched_force_quiescent_state(void)
 {
 }
 
+static inline void rcu_cpu_stall_reset(void)
+{
+}
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 extern int rcu_scheduler_active __read_mostly;
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c13b85d..0726809 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -36,6 +36,7 @@ extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
+extern void rcu_cpu_stall_reset(void);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ff21411..42140a8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -565,6 +565,22 @@ static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 	return NOTIFY_DONE;
 }
 
+/**
+ * rcu_cpu_stall_reset - prevent further stall warnings in current grace period
+ *
+ * Set the stall-warning timeout way off into the future, thus preventing
+ * any RCU CPU stall-warning messages from appearing in the current set of
+ * RCU grace periods.
+ *
+ * The caller must disable hard irqs.
+ */
+void rcu_cpu_stall_reset(void)
+{
+	rcu_sched_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+	rcu_bh_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+	rcu_preempt_stall_reset();
+}
+
 static struct notifier_block rcu_panic_block = {
 	.notifier_call = rcu_panic,
 };
@@ -584,6 +600,10 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 }
 
+void rcu_cpu_stall_reset(void)
+{
+}
+
 static void __init check_cpu_stall_init(void)
 {
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index bb4d086..7abd439 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -372,6 +372,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
+static void rcu_preempt_stall_reset(void);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 63bb771..561410f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -417,6 +417,16 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 	}
 }
 
+/*
+ * Suppress preemptible RCU's CPU stall warnings by pushing the
+ * time of the next stall-warning message comfortably far into the
+ * future.
+ */
+static void rcu_preempt_stall_reset(void)
+{
+	rcu_preempt_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+}
+
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
@@ -867,6 +877,14 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 {
 }
 
+/*
+ * Because preemptible RCU does not exist, there is no need to suppress
+ * its CPU stall warnings.
+ */
+static void rcu_preempt_stall_reset(void)
+{
+}
+
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
-- 
1.7.0.6

