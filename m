Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2BATmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:42:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47574 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2BATmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:33 -0500
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
Subject: [PATCH RFC tip/core/rcu 27/41] rcu: Remove #ifdef CONFIG_SMP from TREE_RCU
Date: Wed,  1 Feb 2012 11:41:45 -0800
Message-Id: <1328125319-5205-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-4242-0000-0000-000000AAB83E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Now that both TINY_RCU and TINY_PREEMPT_RCU have been in place for awhile,
it is time to remove UP support from TREE_RCU, which is what this commit
does.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   19 -------------------
 kernel/rcutree_plugin.h |   12 ------------
 2 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e11bee9..ee45ae7 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -301,8 +301,6 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 	return &rsp->node[0];
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * If the specified CPU is offline, tell the caller that it is in
  * a quiescent state.  Otherwise, whack it with a reschedule IPI.
@@ -339,8 +337,6 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 	return 0;
 }
 
-#endif /* #ifdef CONFIG_SMP */
-
 /*
  * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
  *
@@ -609,8 +605,6 @@ int rcu_is_cpu_rrupt_from_idle(void)
 	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * Snapshot the specified CPU's dynticks counter so that we can later
  * credit them with an implicit quiescent state.  Return 1 if this CPU
@@ -654,8 +648,6 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	return rcu_implicit_offline_qs(rdp);
 }
 
-#endif /* #ifdef CONFIG_SMP */
-
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
@@ -1520,8 +1512,6 @@ void rcu_check_callbacks(int cpu, int user)
 	trace_rcu_utilization("End scheduler-tick");
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
@@ -1644,15 +1634,6 @@ unlock_fqs_ret:
 	trace_rcu_utilization("End fqs");
 }
 
-#else /* #ifdef CONFIG_SMP */
-
-static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
-{
-	set_need_resched();
-}
-
-#endif /* #else #ifdef CONFIG_SMP */
-
 /*
  * This does the RCU core processing work for the specified rcu_state
  * and rcu_data structures.  This may be called only from the CPU to
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 25bd9c1..1b2a82b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1857,16 +1857,6 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
-#ifndef CONFIG_SMP
-
-void synchronize_sched_expedited(void)
-{
-	cond_resched();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#else /* #ifndef CONFIG_SMP */
-
 static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
 static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
 
@@ -1981,8 +1971,6 @@ void synchronize_sched_expedited(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
-#endif /* #else #ifndef CONFIG_SMP */
-
 #if !defined(CONFIG_RCU_FAST_NO_HZ)
 
 /*
-- 
1.7.8

