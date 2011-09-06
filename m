Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab1IGGVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:21:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37864 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab1IGGVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 18/55] rcu: Update comments to reflect softirqs vs. kthreads
Date: Tue,  6 Sep 2011 11:00:12 -0700
Message-Id: <1315332049-2604-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711882
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

We now have kthreads only for flavors of RCU that support boosting,
so update the now-misleading comments accordingly.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   23 ++++++++++++-----------
 kernel/rcutree_plugin.h |    3 ++-
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index eb6e731..4e24399 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -198,7 +198,7 @@ DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 };
 #endif /* #ifdef CONFIG_NO_HZ */
 
-static int blimit = 10;		/* Maximum callbacks per softirq. */
+static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
 static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 
@@ -1261,7 +1261,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	local_irq_restore(flags);
 
-	/* Re-raise the RCU softirq if there are callbacks remaining. */
+	/* Re-invoke RCU core processing if there are callbacks remaining. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
 		invoke_rcu_core();
 }
@@ -1269,7 +1269,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Check to see if this CPU is in a non-context-switch quiescent state
  * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
- * Also schedule the RCU softirq handler.
+ * Also schedule RCU core processing.
  *
  * This function must be called with hardirqs disabled.  It is normally
  * invoked from the scheduling-clock interrupt.  If rcu_pending returns
@@ -1448,9 +1448,9 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 #endif /* #else #ifdef CONFIG_SMP */
 
 /*
- * This does the RCU processing work from softirq context for the
- * specified rcu_state and rcu_data structures.  This may be called
- * only from the CPU to whom the rdp belongs.
+ * This does the RCU core processing work for the specified rcu_state
+ * and rcu_data structures.  This may be called only from the CPU to
+ * whom the rdp belongs.
  */
 static void
 __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
@@ -1487,7 +1487,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
- * Do softirq processing for the current CPU.
+ * Do RCU core processing for the current CPU.
  */
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
@@ -1503,10 +1503,11 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 }
 
 /*
- * Wake up the current CPU's kthread.  This replaces raise_softirq()
- * in earlier versions of RCU.  Note that because we are running on
- * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
- * cannot disappear out from under us.
+ * Schedule RCU callback invocation.  If the specified type of RCU
+ * does not support RCU priority boosting, just do a direct call,
+ * otherwise wake up the per-CPU kernel kthread.  Note that because we
+ * are running on the current CPU with interrupts disabled, the
+ * rcu_cpu_kthread_task cannot disappear out from under us.
  */
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a90bf3c..ecd48a2 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1478,7 +1478,8 @@ static int rcu_cpu_kthread_should_stop(int cpu)
 
 /*
  * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
- * earlier RCU softirq.
+ * RCU softirq used in flavors and configurations of RCU that do not
+ * support RCU priority boosting.
  */
 static int rcu_cpu_kthread(void *arg)
 {
-- 
1.7.3.2

