Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1IGGZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:25:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52604 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab1IGGVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 46/55] rcu: Remove rcu_needs_cpu_flush() to avoid false quiescent states
Date: Tue,  6 Sep 2011 11:00:40 -0700
Message-Id: <1315332049-2604-46-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of rcu_needs_cpu_flush() was to iterate on pushing the
current grace period in order to help the current CPU enter dyntick-idle
mode.  However, this can result in failures if the CPU starts entering
dyntick-idle mode, but then backs out.  In this case, the call to
rcu_pending() from rcu_needs_cpu_flush() might end up announcing a
non-existing quiescent state.

This commit therefore removes rcu_needs_cpu_flush() in favor of letting
the dyntick-idle machinery at the end of the softirq handler push the
loop along via its call to rcu_pending().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    3 ---
 kernel/rcutree.h        |    1 -
 kernel/rcutree_plugin.h |   25 -------------------------
 3 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 743a658..ab37c19 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1528,9 +1528,6 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
-
-	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
-	rcu_needs_cpu_flush();
 	trace_rcu_utilization("End RCU core");
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index f509f72..849ce9e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -458,7 +458,6 @@ static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
-static void rcu_needs_cpu_flush(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
 static void invoke_rcu_callbacks_kthread(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f751a2d..e4fb1ff 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1949,15 +1949,6 @@ int rcu_needs_cpu(int cpu)
 	return rcu_needs_cpu_quick_check(cpu);
 }
 
-/*
- * Check to see if we need to continue a callback-flush operations to
- * allow the last CPU to enter dyntick-idle mode.  But fast dyntick-idle
- * entry is not configured, so we never do need to.
- */
-static void rcu_needs_cpu_flush(void)
-{
-}
-
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #define RCU_NEEDS_CPU_FLUSHES 5
@@ -2033,20 +2024,4 @@ int rcu_needs_cpu(int cpu)
 	return c;
 }
 
-/*
- * Check to see if we need to continue a callback-flush operations to
- * allow the last CPU to enter dyntick-idle mode.
- */
-static void rcu_needs_cpu_flush(void)
-{
-	int cpu = smp_processor_id();
-	unsigned long flags;
-
-	if (per_cpu(rcu_dyntick_drain, cpu) <= 0)
-		return;
-	local_irq_save(flags);
-	(void)rcu_needs_cpu(cpu);
-	local_irq_restore(flags);
-}
-
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
-- 
1.7.3.2

