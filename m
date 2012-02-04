Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2BDBro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:47:44 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34555 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694Ab2BDBrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:47:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 37/47] rcu: No interrupt disabling for rcu_prepare_for_idle()
Date: Fri,  3 Feb 2012 17:45:12 -0800
Message-Id: <1328319922-30828-37-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-5806-0000-0000-0000120C5067
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The rcu_prepare_for_idle() function is always called with interrupts
disabled, so there is no reason to disable interrupts again within
rcu_prepare_for_idle().  Therefore, this commit removes all of the
interrupt disabling, also removing a latent disabling-unbalance bug.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 30eaf14..5a1c0fb 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2096,10 +2096,6 @@ static void rcu_cleanup_after_idle(int cpu)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-
 	/*
 	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
 	 * Also reset state to avoid prejudicing later attempts.
@@ -2107,7 +2103,6 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!rcu_cpu_has_callbacks(cpu)) {
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("No callbacks");
 		return;
 	}
@@ -2117,7 +2112,6 @@ static void rcu_prepare_for_idle(int cpu)
 	 * refrained from disabling the scheduling-clock tick.
 	 */
 	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies) {
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("In holdoff");
 		return;
 	}
@@ -2142,7 +2136,6 @@ static void rcu_prepare_for_idle(int cpu)
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("Begin holdoff");
 		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
 		return;
@@ -2154,23 +2147,17 @@ static void rcu_prepare_for_idle(int cpu)
 	 */
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
-		local_irq_restore(flags);
 		rcu_preempt_qs(cpu);
 		force_quiescent_state(&rcu_preempt_state, 0);
-		local_irq_save(flags);
 	}
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
-		local_irq_restore(flags);
 		rcu_sched_qs(cpu);
 		force_quiescent_state(&rcu_sched_state, 0);
-		local_irq_save(flags);
 	}
 	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
-		local_irq_restore(flags);
 		rcu_bh_qs(cpu);
 		force_quiescent_state(&rcu_bh_state, 0);
-		local_irq_save(flags);
 	}
 
 	/*
@@ -2178,13 +2165,10 @@ static void rcu_prepare_for_idle(int cpu)
 	 * So try forcing the callbacks through the grace period.
 	 */
 	if (rcu_cpu_has_callbacks(cpu)) {
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("More callbacks");
 		invoke_rcu_core();
-	} else {
-		local_irq_restore(flags);
+	} else
 		trace_rcu_prep_idle("Callbacks drained");
-	}
 }
 
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
-- 
1.7.8

