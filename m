Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1GTATR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:19:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58189 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab1GTATO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:19:14 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 5/7] sched: Add irq_{enter,exit}() to scheduler_ipi()
Date: Tue, 19 Jul 2011 17:18:21 -0700
Message-Id: <1311121103-16978-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110720001738.GA16369@linux.vnet.ibm.com>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ensure scheduler_ipi() calls irq_{enter,exit} when it does some actual
work. Traditionally we never did any actual work from the resched IPI
and all magic happened in the return from interrupt path.

Now that we do do some work, we need to ensure irq_{enter,exit} are
called so that we don't confuse things.

This affects things like timekeeping, NO_HZ and RCU, basically
everything with a hook in irq_enter/exit.

Explicit examples of things going wrong are:

  sched_clock_cpu() -- has a callback when leaving NO_HZ state to take
                    a new reading from GTOD and TSC. Without this
                    callback, time is stuck in the past.

  RCU -- needs in_irq() to work in order to avoid some nasty deadlocks

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/sched.c |   44 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9769c75..1930ee1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2544,13 +2544,9 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 }
 
 #ifdef CONFIG_SMP
-static void sched_ttwu_pending(void)
+static void sched_ttwu_do_pending(struct task_struct *list)
 {
 	struct rq *rq = this_rq();
-	struct task_struct *list = xchg(&rq->wake_list, NULL);
-
-	if (!list)
-		return;
 
 	raw_spin_lock(&rq->lock);
 
@@ -2563,9 +2559,45 @@ static void sched_ttwu_pending(void)
 	raw_spin_unlock(&rq->lock);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void sched_ttwu_pending(void)
+{
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	sched_ttwu_do_pending(list);
+}
+
+#endif /* CONFIG_HOTPLUG_CPU */
+
 void scheduler_ipi(void)
 {
-	sched_ttwu_pending();
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	/*
+	 * Not all reschedule IPI handlers call irq_enter/irq_exit, since
+	 * traditionally all their work was done from the interrupt return
+	 * path. Now that we actually do some work, we need to make sure
+	 * we do call them.
+	 *
+	 * Some archs already do call them, luckily irq_enter/exit nest
+	 * properly.
+	 *
+	 * Arguably we should visit all archs and update all handlers,
+	 * however a fair share of IPIs are still resched only so this would
+	 * somewhat pessimize the simple resched case.
+	 */
+	irq_enter();
+	sched_ttwu_do_pending(list);
+	irq_exit();
 }
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
-- 
1.7.3.2

