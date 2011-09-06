Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1IGGZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:25:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46555 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743Ab1IGGVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 20/55] rcu: Add event-trace markers to TREE_RCU kthreads
Date: Tue,  6 Sep 2011 11:00:14 -0700
Message-Id: <1315332049-2604-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Add event-trace markers to TREE_RCU kthreads to allow including these
kthread's CPU time in the utilization calculations.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |    3 +++
 kernel/rcutree_plugin.h    |   12 ++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 508824e5..ac52aba 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -13,6 +13,9 @@
  * "Start <activity>" -- Mark the start of the specified activity,
  *			 such as "context switch".  Nesting is permitted.
  * "End <activity>" -- Mark the end of the specified activity.
+ *
+ * An "@" character within "<activity>" is a comment character: Data
+ * reduction scripts will ignore the "@" and the remainder of the line.
  */
 TRACE_EVENT(rcu_utilization,
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ecd48a2..94d9ca1 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1219,9 +1219,12 @@ static int rcu_boost_kthread(void *arg)
 	int spincnt = 0;
 	int more2boost;
 
+	trace_rcu_utilization("Start boost kthread@init");
 	for (;;) {
 		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
+		trace_rcu_utilization("End boost kthread@rcu_wait");
 		rcu_wait(rnp->boost_tasks || rnp->exp_tasks);
+		trace_rcu_utilization("Start boost kthread@rcu_wait");
 		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
 		more2boost = rcu_boost(rnp);
 		if (more2boost)
@@ -1229,11 +1232,14 @@ static int rcu_boost_kthread(void *arg)
 		else
 			spincnt = 0;
 		if (spincnt > 10) {
+			trace_rcu_utilization("End boost kthread@rcu_yield");
 			rcu_yield(rcu_boost_kthread_timer, (unsigned long)rnp);
+			trace_rcu_utilization("Start boost kthread@rcu_yield");
 			spincnt = 0;
 		}
 	}
 	/* NOTREACHED */
+	trace_rcu_utilization("End boost kthread@notreached");
 	return 0;
 }
 
@@ -1490,9 +1496,12 @@ static int rcu_cpu_kthread(void *arg)
 	char work;
 	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
 
+	trace_rcu_utilization("Start CPU kthread@init");
 	for (;;) {
 		*statusp = RCU_KTHREAD_WAITING;
+		trace_rcu_utilization("End CPU kthread@rcu_wait");
 		rcu_wait(*workp != 0 || kthread_should_stop());
+		trace_rcu_utilization("Start CPU kthread@rcu_wait");
 		local_bh_disable();
 		if (rcu_cpu_kthread_should_stop(cpu)) {
 			local_bh_enable();
@@ -1513,11 +1522,14 @@ static int rcu_cpu_kthread(void *arg)
 			spincnt = 0;
 		if (spincnt > 10) {
 			*statusp = RCU_KTHREAD_YIELDING;
+			trace_rcu_utilization("End CPU kthread@rcu_yield");
 			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
+			trace_rcu_utilization("Start CPU kthread@rcu_yield");
 			spincnt = 0;
 		}
 	}
 	*statusp = RCU_KTHREAD_STOPPED;
+	trace_rcu_utilization("End CPU kthread@term");
 	return 0;
 }
 
-- 
1.7.3.2

