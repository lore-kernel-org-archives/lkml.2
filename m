Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2BATmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:42:37 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34342 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2BATmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:35 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 40/41] rcu: Call out dangers of expedited RCU primitives
Date: Wed,  1 Feb 2012 11:41:58 -0800
Message-Id: <1328125319-5205-40-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-1780-0000-0000-000002CC80F2
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110066; UDB=6.00027381; UTC=2012-02-01
 19:42:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The expedited RCU primitives can be quite useful, but they have some
high costs as well.  This commit updates and creates docbook comments
calling out the costs, and updates the RCU documentation as well.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/checklist.txt |   14 ++++++++++++++
 include/linux/rcutree.h         |   16 ++++++++++++++++
 kernel/rcutree.c                |   22 ++++++++++++++--------
 kernel/rcutree_plugin.h         |   20 ++++++++++++++++----
 kernel/srcu.c                   |   27 +++++++++++++++++----------
 5 files changed, 77 insertions(+), 22 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index bff2d8b..5c8d749 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -180,6 +180,20 @@ over a rather long period of time, but improvements are always welcome!
 	operations that would not normally be undertaken while a real-time
 	workload is running.
 
+	In particular, if you find yourself invoking one of the expedited
+	primitives repeatedly in a loop, please do everyone a favor:
+	Restructure your code so that it batches the updates, allowing
+	a single non-expedited primitive to cover the entire batch.
+	This will very likely be faster than the loop containing the
+	expedited primitive, and will be much much easier on the rest
+	of the system, especially to real-time workloads running on
+	the rest of the system.
+
+	In addition, it is illegal to call the expedited forms from
+	a CPU-hotplug notifier, or while holding a lock that is acquired
+	by a CPU-hotplug notifier.  Failing to observe this restriction
+	will result in deadlock.
+
 7.	If the updater uses call_rcu() or synchronize_rcu(), then the
 	corresponding readers must use rcu_read_lock() and
 	rcu_read_unlock().  If the updater uses call_rcu_bh() or
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 7389248..e8ee5dd 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -63,6 +63,22 @@ extern void synchronize_rcu_expedited(void);
 
 void kfree_call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 
+/**
+ * synchronize_rcu_bh_expedited - Brute-force RCU-bh grace period
+ *
+ * Wait for an RCU-bh grace period to elapse, but use a "big hammer"
+ * approach to force the grace period to end quickly.  This consumes
+ * significant time on all CPUs and is unfriendly to real-time workloads,
+ * so is thus not recommended for any sort of common-case code.  In fact,
+ * if you are using synchronize_rcu_bh_expedited() in a loop, please
+ * restructure your code to batch your updates, and then use a single
+ * synchronize_rcu_bh() instead.
+ *
+ * Note that it is illegal to call this function while holding any lock
+ * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
+ * to call this function from a CPU-hotplug notifier.  Failing to observe
+ * these restriction will result in deadlock.
+ */
 static inline void synchronize_rcu_bh_expedited(void)
 {
 	synchronize_sched_expedited();
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5f71cd1..30abdcb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1962,15 +1962,21 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
 	return 0;
 }
 
-/*
- * Wait for an rcu-sched grace period to elapse, but use "big hammer"
- * approach to force grace period to end quickly.  This consumes
- * significant time on all CPUs, and is thus not recommended for
- * any sort of common-case code.
+/**
+ * synchronize_sched_expedited - Brute-force RCU-sched grace period
+ *
+ * Wait for an RCU-sched grace period to elapse, but use a "big hammer"
+ * approach to force the grace period to end quickly.  This consumes
+ * significant time on all CPUs and is unfriendly to real-time workloads,
+ * so is thus not recommended for any sort of common-case code.  In fact,
+ * if you are using synchronize_sched_expedited() in a loop, please
+ * restructure your code to batch your updates, and then use a single
+ * synchronize_sched() instead.
  *
- * Note that it is illegal to call this function while holding any
- * lock that is acquired by a CPU-hotplug notifier.  Failing to
- * observe this restriction will result in deadlock.
+ * Note that it is illegal to call this function while holding any lock
+ * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
+ * to call this function from a CPU-hotplug notifier.  Failing to observe
+ * these restriction will result in deadlock.
  *
  * This implementation can be thought of as an application of ticket
  * locking to RCU, with sync_sched_expedited_started and
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 56a63bc..bdc2708 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -834,10 +834,22 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 		rcu_report_exp_rnp(rsp, rnp, false); /* Don't wake self. */
 }
 
-/*
- * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
- * is to invoke synchronize_sched_expedited() to push all the tasks to
- * the ->blkd_tasks lists and wait for this list to drain.
+/**
+ * synchronize_rcu_expedited - Brute-force RCU grace period
+ *
+ * Wait for an RCU-preempt grace period, but expedite it.  The basic
+ * idea is to invoke synchronize_sched_expedited() to push all the tasks to
+ * the ->blkd_tasks lists and wait for this list to drain.  This consumes
+ * significant time on all CPUs and is unfriendly to real-time workloads,
+ * so is thus not recommended for any sort of common-case code.
+ * In fact, if you are using synchronize_rcu_expedited() in a loop,
+ * please restructure your code to batch your updates, and then Use a
+ * single synchronize_rcu() instead.
+ *
+ * Note that it is illegal to call this function while holding any lock
+ * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
+ * to call this function from a CPU-hotplug notifier.  Failing to observe
+ * these restriction will result in deadlock.
  */
 void synchronize_rcu_expedited(void)
 {
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 1959763..b150a0a 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -284,19 +284,26 @@ void synchronize_srcu(struct srcu_struct *sp)
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
 /**
- * synchronize_srcu_expedited - like synchronize_srcu, but less patient
+ * synchronize_srcu_expedited - Brute-force SRCU grace period
  * @sp: srcu_struct with which to synchronize.
  *
- * Flip the completed counter, and wait for the old count to drain to zero.
- * As with classic RCU, the updater must use some separate means of
- * synchronizing concurrent updates.  Can block; must be called from
- * process context.
+ * Wait for an SRCU grace period to elapse, but use a "big hammer"
+ * approach to force the grace period to end quickly.  This consumes
+ * significant time on all CPUs and is unfriendly to real-time workloads,
+ * so is thus not recommended for any sort of common-case code.  In fact,
+ * if you are using synchronize_srcu_expedited() in a loop, please
+ * restructure your code to batch your updates, and then use a single
+ * synchronize_srcu() instead.
  *
- * Note that it is illegal to call synchronize_srcu_expedited()
- * from the corresponding SRCU read-side critical section; doing so
- * will result in deadlock.  However, it is perfectly legal to call
- * synchronize_srcu_expedited() on one srcu_struct from some other
- * srcu_struct's read-side critical section.
+ * Note that it is illegal to call this function while holding any lock
+ * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
+ * to call this function from a CPU-hotplug notifier.  Failing to observe
+ * these restriction will result in deadlock.  It is also illegal to call
+ * synchronize_srcu_expedited() from the corresponding SRCU read-side
+ * critical section; doing so will result in deadlock.  However, it is
+ * perfectly legal to call synchronize_srcu_expedited() on one srcu_struct
+ * from some other srcu_struct's read-side critical section, as long as
+ * the resulting graph of srcu_structs is acyclic.
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
 {
-- 
1.7.8

