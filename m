Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0EKXdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:33:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41153 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab0EKXdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:33:11 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH RFC tip/core/rcu 03/11] rcu: remove all rcu head initializations, except on_stack initializations
Date: Tue, 11 May 2010 16:32:58 -0700
Message-Id: <1273620786-20392-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100511233241.GA20250@linux.vnet.ibm.com>
References: <20100511233241.GA20250@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all rcu head inits. We don't care about the RCU head state before passing
it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
keep track of objects on stack.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |    1 -
 kernel/rcutiny.c          |    6 ++++++
 kernel/rcutorture.c       |    2 ++
 kernel/rcutree.c          |    4 ++++
 kernel/rcutree_plugin.h   |    2 ++
 5 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index b1ed1cd..7996fc2 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -49,7 +49,6 @@ extern struct group_info init_groups;
 		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
 		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
 	},								\
-	.rcu		= RCU_HEAD_INIT,				\
 	.level		= 0,						\
 	.numbers	= { {						\
 		.nr		= 0,					\
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index b1804ff..38729d3 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -245,11 +245,13 @@ void rcu_barrier(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
@@ -257,11 +259,13 @@ void rcu_barrier_bh(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_bh(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_bh);
 
@@ -269,11 +273,13 @@ void rcu_barrier_sched(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_sched(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 58df55b..077defb 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -464,9 +464,11 @@ static void rcu_bh_torture_synchronize(void)
 {
 	struct rcu_bh_torture_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ba69969..d443734 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1484,11 +1484,13 @@ void synchronize_sched(void)
 	if (rcu_blocking_is_gp())
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_sched(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
@@ -1508,11 +1510,13 @@ void synchronize_rcu_bh(void)
 	if (rcu_blocking_is_gp())
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_bh(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ac7d80f..0e4f420 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -557,11 +557,13 @@ void synchronize_rcu(void)
 	if (!rcu_scheduler_active)
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
-- 
1.7.0.6

