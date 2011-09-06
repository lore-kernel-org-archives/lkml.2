Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1IGGVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:21:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48766 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab1IGGUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/55] rcu: Catch rcutorture up to new RCU API additions
Date: Tue,  6 Sep 2011 11:00:03 -0700
Message-Id: <1315332049-2604-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the RCU API contains synchronize_rcu_bh(), synchronize_sched(),
call_rcu_sched(), and rcu_bh_expedited()...

Make rcutorture test synchronize_rcu_bh(), getting rid of the old
rcu_bh_torture_synchronize() workaround.  Similarly, make rcutorture test
synchronize_sched(), getting rid of the old sched_torture_synchronize()
workaround.  Make rcutorture test call_rcu_sched() instead of wrappering
synchronize_sched().  Also add testing of rcu_bh_expedited().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/torture.txt |    3 ++
 kernel/rcutorture.c           |   55 +++++++++++++++-------------------------
 2 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 4205ed1..783d6c1 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -122,6 +122,9 @@ torture_type	The type of RCU to test, with string values as follows:
 		"rcu_bh_sync": rcu_read_lock_bh(), rcu_read_unlock_bh(),
 			and synchronize_rcu_bh().
 
+		"rcu_bh_expedited": rcu_read_lock_bh(), rcu_read_unlock_bh(),
+			and synchronize_rcu_bh_expedited().
+
 		"srcu": srcu_read_lock(), srcu_read_unlock() and
 			synchronize_srcu().
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 920eb50..e0f39ea 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -480,30 +480,6 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 	call_rcu_bh(&p->rtort_rcu, rcu_torture_cb);
 }
 
-struct rcu_bh_torture_synchronize {
-	struct rcu_head head;
-	struct completion completion;
-};
-
-static void rcu_bh_torture_wakeme_after_cb(struct rcu_head *head)
-{
-	struct rcu_bh_torture_synchronize *rcu;
-
-	rcu = container_of(head, struct rcu_bh_torture_synchronize, head);
-	complete(&rcu->completion);
-}
-
-static void rcu_bh_torture_synchronize(void)
-{
-	struct rcu_bh_torture_synchronize rcu;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
-}
-
 static struct rcu_torture_ops rcu_bh_ops = {
 	.init		= NULL,
 	.cleanup	= NULL,
@@ -512,7 +488,7 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.readunlock	= rcu_bh_torture_read_unlock,
 	.completed	= rcu_bh_torture_completed,
 	.deferred_free	= rcu_bh_torture_deferred_free,
-	.sync		= rcu_bh_torture_synchronize,
+	.sync		= synchronize_rcu_bh,
 	.cb_barrier	= rcu_barrier_bh,
 	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
@@ -528,7 +504,7 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.readunlock	= rcu_bh_torture_read_unlock,
 	.completed	= rcu_bh_torture_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= rcu_bh_torture_synchronize,
+	.sync		= synchronize_rcu_bh,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
@@ -536,6 +512,22 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.name		= "rcu_bh_sync"
 };
 
+static struct rcu_torture_ops rcu_bh_expedited_ops = {
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= rcu_bh_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_bh_torture_read_unlock,
+	.completed	= rcu_bh_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= synchronize_rcu_bh_expedited,
+	.cb_barrier	= NULL,
+	.fqs		= rcu_bh_force_quiescent_state,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_bh_expedited"
+};
+
 /*
  * Definitions for srcu torture testing.
  */
@@ -659,11 +651,6 @@ static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 	call_rcu_sched(&p->rtort_rcu, rcu_torture_cb);
 }
 
-static void sched_torture_synchronize(void)
-{
-	synchronize_sched();
-}
-
 static struct rcu_torture_ops sched_ops = {
 	.init		= rcu_sync_torture_init,
 	.cleanup	= NULL,
@@ -672,7 +659,7 @@ static struct rcu_torture_ops sched_ops = {
 	.readunlock	= sched_torture_read_unlock,
 	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sched_torture_deferred_free,
-	.sync		= sched_torture_synchronize,
+	.sync		= synchronize_sched,
 	.cb_barrier	= rcu_barrier_sched,
 	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
@@ -688,7 +675,7 @@ static struct rcu_torture_ops sched_sync_ops = {
 	.readunlock	= sched_torture_read_unlock,
 	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= sched_torture_synchronize,
+	.sync		= synchronize_sched,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
@@ -1427,7 +1414,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
-		  &rcu_bh_ops, &rcu_bh_sync_ops,
+		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
 		  &srcu_ops, &srcu_expedited_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
-- 
1.7.3.2

