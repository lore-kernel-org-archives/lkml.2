Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1LCSez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:34:55 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57169 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab1LCSex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:34:53 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 3/7] rcu: Keep invoking callbacks if CPU otherwise idle
Date: Sat,  3 Dec 2011 10:34:38 -0800
Message-Id: <1322937282-19846-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111203183417.GA18914@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
x-cbid: 11120318-9360-0000-0000-000001361771
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The rcu_do_batch() function that invokes callbacks for TREE_RCU and
TREE_PREEMPT_RCU normally throttles callback invocation to avoid degrading
scheduling latency.  However, as long as the CPU would otherwise be idle,
there is no downside to continuing to invoke any callbacks that have passed
through their grace periods.  In fact, processing such callbacks in a
timely manner has the benefit of increasing the probability that the
CPU can enter the power-saving dyntick-idle mode.

Therefore, this commit allows callback invocation to continue beyond the
preset limit as long as the scheduler does not have some other task to
run and as long as context is that of the idle task or the relevant
RCU kthread.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    5 ++++-
 kernel/rcutree.h        |    1 +
 kernel/rcutree_plugin.h |   14 ++++++++++++++
 3 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c0ed376..4ec4b14 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1403,7 +1403,10 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		debug_rcu_head_unqueue(list);
 		__rcu_reclaim(rsp->name, list);
 		list = next;
-		if (++count >= bl)
+		/* Stop only if limit reached and CPU has something to do. */
+		if (++count >= bl &&
+		    (need_resched() ||
+		     (!is_idle_task(current) && !rcu_is_callbacks_kthread())))
 			break;
 	}
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 9bcfbc9..fddff92 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -455,6 +455,7 @@ static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
 static void invoke_rcu_callbacks_kthread(void);
+static bool rcu_is_callbacks_kthread(void);
 #ifdef CONFIG_RCU_BOOST
 static void rcu_preempt_do_callbacks(void);
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index dbcea6b..adb6e66 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1337,6 +1337,15 @@ static void invoke_rcu_callbacks_kthread(void)
 }
 
 /*
+ * Is the current CPU running the RCU-callbacks kthread?
+ * Caller must have preemption disabled.
+ */
+static bool rcu_is_callbacks_kthread(void)
+{
+	return __get_cpu_var(rcu_cpu_kthread_task) == current;
+}
+
+/*
  * Set the affinity of the boost kthread.  The CPU-hotplug locks are
  * held, so no one should be messing with the existence of the boost
  * kthread.
@@ -1780,6 +1789,11 @@ static void invoke_rcu_callbacks_kthread(void)
 	WARN_ON_ONCE(1);
 }
 
+static bool rcu_is_callbacks_kthread(void)
+{
+	return false;
+}
+
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
-- 
1.7.3.2

