Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2L2QoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:44:08 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:58272 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2L2QoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:44:05 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 21/27] nohz: Only stop the tick on RCU nocb CPUs
Date: Sat, 29 Dec 2012 17:43:00 +0100
Message-Id: <1356799386-4212-22-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a full dynticks CPU, we want the RCU callbacks to be
offlined to another CPU, otherwise we need to keep
the tick to wait for the grace period completion.

Ensure the full dynticks CPU is also an rcu_nocb one.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rcupdate.h |    7 +++++++
 kernel/rcutree.c         |    6 +++---
 kernel/rcutree_plugin.h  |   13 ++++---------
 kernel/time/tick-sched.c |   20 +++++++++++++++++---
 4 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 275aa3f..829312e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -992,4 +992,11 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
+#ifdef CONFIG_RCU_NOCB_CPU
+bool rcu_is_nocb_cpu(int cpu);
+#else
+static inline bool rcu_is_nocb_cpu(int cpu) { return false; };
+#endif
+
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 302d360..e9e0ffa 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1589,7 +1589,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 			  struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	/* No-CBs CPUs do not have orphanable callbacks. */
-	if (is_nocb_cpu(rdp->cpu))
+	if (rcu_is_nocb_cpu(rdp->cpu))
 		return;
 
 	/*
@@ -2651,10 +2651,10 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * corresponding CPU's preceding callbacks have been invoked.
 	 */
 	for_each_possible_cpu(cpu) {
-		if (!cpu_online(cpu) && !is_nocb_cpu(cpu))
+		if (!cpu_online(cpu) && !rcu_is_nocb_cpu(cpu))
 			continue;
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (is_nocb_cpu(cpu)) {
+		if (rcu_is_nocb_cpu(cpu)) {
 			_rcu_barrier_trace(rsp, "OnlineNoCB", cpu,
 					   rsp->n_barrier_done);
 			atomic_inc(&rsp->barrier_cpu_count);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f6e5ec2..625b327 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2160,7 +2160,7 @@ static int __init rcu_nocb_setup(char *str)
 __setup("rcu_nocbs=", rcu_nocb_setup);
 
 /* Is the specified CPU a no-CPUs CPU? */
-static bool is_nocb_cpu(int cpu)
+bool rcu_is_nocb_cpu(int cpu)
 {
 	if (have_rcu_nocb_mask)
 		return cpumask_test_cpu(cpu, rcu_nocb_mask);
@@ -2218,7 +2218,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy)
 {
 
-	if (!is_nocb_cpu(rdp->cpu))
+	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return 0;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
 	return 1;
@@ -2235,7 +2235,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 	long qll = rsp->qlen_lazy;
 
 	/* If this is not a no-CBs CPU, tell the caller to do it the old way. */
-	if (!is_nocb_cpu(smp_processor_id()))
+	if (!rcu_is_nocb_cpu(smp_processor_id()))
 		return 0;
 	rsp->qlen = 0;
 	rsp->qlen_lazy = 0;
@@ -2275,7 +2275,7 @@ static bool nocb_cpu_expendable(int cpu)
 	 * If there are no no-CB CPUs or if this CPU is not a no-CB CPU,
 	 * then offlining this CPU is harmless.  Let it happen.
 	 */
-	if (!have_rcu_nocb_mask || is_nocb_cpu(cpu))
+	if (!have_rcu_nocb_mask || rcu_is_nocb_cpu(cpu))
 		return 1;
 
 	/* If no memory, play it safe and keep the CPU around. */
@@ -2456,11 +2456,6 @@ static void __init rcu_init_nocb(void)
 
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 
-static bool is_nocb_cpu(int cpu)
-{
-	return false;
-}
-
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy)
 {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9d31b08..78e5341 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -587,6 +587,19 @@ void tick_nohz_idle_enter(void)
 	local_irq_enable();
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+static bool can_stop_full_tick(int cpu)
+{
+	if (!sched_can_stop_tick())
+		return false;
+
+	if (!rcu_is_nocb_cpu(cpu))
+		return false;
+
+	return true;
+}
+#endif
+
 static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 {
 #ifdef CONFIG_NO_HZ_FULL
@@ -598,7 +611,7 @@ static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
 		return;
 
-	if (!sched_can_stop_tick())
+	if (!can_stop_full_tick(cpu))
 		return;
 
 	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
@@ -860,10 +873,11 @@ static inline void tick_check_nohz(int cpu) { }
 void tick_nohz_full_check(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	int cpu = smp_processor_id();
 
-	if (tick_nohz_full_cpu(smp_processor_id())) {
+	if (tick_nohz_full_cpu(cpu)) {
 		if (ts->tick_stopped && !is_idle_task(current)) {
-			if (!sched_can_stop_tick())
+			if (!can_stop_full_tick(cpu))
 				tick_nohz_restart_sched_tick(ts, ktime_get());
 		}
 	}
-- 
1.7.5.4

