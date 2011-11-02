Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1KBUdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:33:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34902 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab1KBUcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:32:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 03/28] rcu: Avoid RCU-preempt expedited grace-period botch
Date: Wed,  2 Nov 2011 13:30:24 -0700
Message-Id: <1320265849-5744-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5806-0000-0000-000000F80A1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because rcu_read_unlock_special() samples rcu_preempted_readers_exp(rnp)
after dropping rnp->lock, the following sequence of events is possible:

1.	Task A exits its RCU read-side critical section, and removes
	itself from the ->blkd_tasks list, releases rnp->lock, and is
	then preempted.  Task B remains on the ->blkd_tasks list, and
	blocks the current expedited grace period.

2.	Task B exits from its RCU read-side critical section and removes
	itself from the ->blkd_tasks list.  Because it is the last task
	blocking the current expedited grace period, it ends that
	expedited grace period.

3.	Task A resumes, and samples rcu_preempted_readers_exp(rnp) which
	of course indicates that nothing is blocking the nonexistent
	expedited grace period. Task A is again preempted.

4.	Some other CPU starts an expedited grace period.  There are several
	tasks blocking this expedited grace period queued on the
	same rcu_node structure that Task A was using in step 1 above.

5.	Task A examines its state and incorrectly concludes that it was
	the last task blocking the expedited grace period on the current
	rcu_node structure.  It therefore reports completion up the
	rcu_node tree.

6.	The expedited grace period can then incorrectly complete before
	the tasks blocked on this same rcu_node structure exit their
	RCU read-side critical sections.  Arbitrarily bad things happen.

This commit therefore takes a snapshot of rcu_preempted_readers_exp(rnp)
prior to dropping the lock, so that only the last task thinks that it is
the last task, thus avoiding the failure scenario laid out above.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 4b9b9f8..7986053 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -312,6 +312,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
+	int empty_exp_now;
 	unsigned long flags;
 	struct list_head *np;
 #ifdef CONFIG_RCU_BOOST
@@ -382,8 +383,10 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		/*
 		 * If this was the last task on the current list, and if
 		 * we aren't waiting on any CPUs, report the quiescent state.
-		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock.
+		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock,
+		 * so we must take a snapshot of the expedited state.
 		 */
+		empty_exp_now = !rcu_preempted_readers_exp(rnp);
 		if (!empty && !rcu_preempt_blocked_readers_cgp(rnp)) {
 			trace_rcu_quiescent_state_report("preempt_rcu",
 							 rnp->gpnum,
@@ -406,7 +409,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		 * If this was the last task on the expedited lists,
 		 * then we need to report up the rcu_node hierarchy.
 		 */
-		if (!empty_exp && !rcu_preempted_readers_exp(rnp))
+		if (!empty_exp && empty_exp_now)
 			rcu_report_exp_rnp(&rcu_preempt_state, rnp);
 	} else {
 		local_irq_restore(flags);
-- 
1.7.3.2

