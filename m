Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2BATml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:42:41 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44368 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab2BATmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:38 -0500
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
Subject: [PATCH RFC tip/core/rcu 36/41] rcu: No interrupt disabling for rcu_prepare_for_idle()
Date: Wed,  1 Feb 2012 11:41:54 -0800
Message-Id: <1328125319-5205-36-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5518-0000-0000-000001F05D5A
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
index 9706a12..3dc58cc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2095,10 +2095,6 @@ static void rcu_cleanup_after_idle(int cpu)
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
@@ -2106,7 +2102,6 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!rcu_cpu_has_callbacks(cpu)) {
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("No callbacks");
 		return;
 	}
@@ -2116,7 +2111,6 @@ static void rcu_prepare_for_idle(int cpu)
 	 * refrained from disabling the scheduling-clock tick.
 	 */
 	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies) {
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("In holdoff");
 		return;
 	}
@@ -2141,7 +2135,6 @@ static void rcu_prepare_for_idle(int cpu)
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("Begin holdoff");
 		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
 		return;
@@ -2153,23 +2146,17 @@ static void rcu_prepare_for_idle(int cpu)
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
@@ -2177,13 +2164,10 @@ static void rcu_prepare_for_idle(int cpu)
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

