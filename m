Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1IGG3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:29:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44838 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab1IGGUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH tip/core/rcu 44/55] rcu: wire up RCU_BOOST_PRIO for rcutree
Date: Tue,  6 Sep 2011 11:00:38 -0700
Message-Id: <1315332049-2604-44-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU boost threads start life at RCU_BOOST_PRIO, while others remain
at RCU_KTHREAD_PRIO.  While here, change thread names to match other
kthreads, and adjust rcu_yield() to not override the priority set by
the user.  This last change sets the stage for runtime changes to
priority in the -rt tree.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    2 --
 kernel/rcutree_plugin.h |   20 +++++++++++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c95fa89..8455043 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -131,8 +131,6 @@ static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
-#define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
-
 /*
  * Track the rcutorture test sequence number and the update version
  * number within a given test.  The rcutorture_testseq is incremented
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f6c63ea..f751a2d 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -27,6 +27,14 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 
+#define RCU_KTHREAD_PRIO 1
+
+#ifdef CONFIG_RCU_BOOST
+#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
+#else
+#define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
+#endif
+
 /*
  * Check the RCU kernel configuration parameters and print informative
  * messages about anything out of the ordinary.  If you like #ifdef, you
@@ -1365,13 +1373,13 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (rnp->boost_kthread_task != NULL)
 		return 0;
 	t = kthread_create(rcu_boost_kthread, (void *)rnp,
-			   "rcub%d", rnp_index);
+			   "rcub/%d", rnp_index);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sp.sched_priority = RCU_BOOST_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
@@ -1466,6 +1474,7 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 {
 	struct sched_param sp;
 	struct timer_list yield_timer;
+	int prio = current->normal_prio;
 
 	setup_timer_on_stack(&yield_timer, f, arg);
 	mod_timer(&yield_timer, jiffies + 2);
@@ -1473,7 +1482,8 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
 	set_user_nice(current, 19);
 	schedule();
-	sp.sched_priority = RCU_KTHREAD_PRIO;
+	set_user_nice(current, 0);
+	sp.sched_priority = prio;
 	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
 	del_timer(&yield_timer);
 }
@@ -1592,7 +1602,7 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	t = kthread_create_on_node(rcu_cpu_kthread,
 				   (void *)(long)cpu,
 				   cpu_to_node(cpu),
-				   "rcuc%d", cpu);
+				   "rcuc/%d", cpu);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	if (cpu_online(cpu))
@@ -1701,7 +1711,7 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 		return 0;
 	if (rnp->node_kthread_task == NULL) {
 		t = kthread_create(rcu_node_kthread, (void *)rnp,
-				   "rcun%d", rnp_index);
+				   "rcun/%d", rnp_index);
 		if (IS_ERR(t))
 			return PTR_ERR(t);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-- 
1.7.3.2

