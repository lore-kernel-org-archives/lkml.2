Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1K1XfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:35:25 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43343 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab1K1XfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:35:23 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 09/13] rcu: Reduce latency of rcu_prepare_for_idle()
Date: Mon, 28 Nov 2011 15:33:01 -0800
Message-Id: <1322523185-456-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-5112-0000-0000-0000028618EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Re-enable interrupts across calls to quiescent-state functions and
also across force_quiescent_state() to reduce latency.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3d84dbc..42ca5a4 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2009,7 +2009,6 @@ int rcu_needs_cpu(int cpu)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
-	int c = 0;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -2055,27 +2054,30 @@ static void rcu_prepare_for_idle(int cpu)
 	 */
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
+		local_irq_restore(flags);
 		rcu_preempt_qs(cpu);
 		force_quiescent_state(&rcu_preempt_state, 0);
-		c = c || per_cpu(rcu_preempt_data, cpu).nxtlist;
+		local_irq_save(flags);
 	}
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
+		local_irq_restore(flags);
 		rcu_sched_qs(cpu);
 		force_quiescent_state(&rcu_sched_state, 0);
-		c = c || per_cpu(rcu_sched_data, cpu).nxtlist;
+		local_irq_save(flags);
 	}
 	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
+		local_irq_restore(flags);
 		rcu_bh_qs(cpu);
 		force_quiescent_state(&rcu_bh_state, 0);
-		c = c || per_cpu(rcu_bh_data, cpu).nxtlist;
+		local_irq_save(flags);
 	}
 
 	/*
 	 * If RCU callbacks are still pending, RCU still needs this CPU.
 	 * So try forcing the callbacks through the grace period.
 	 */
-	if (c) {
+	if (rcu_cpu_has_callbacks(cpu)) {
 		local_irq_restore(flags);
 		trace_rcu_prep_idle("More callbacks");
 		invoke_rcu_core();
-- 
1.7.3.2

