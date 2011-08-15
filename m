Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1HOPxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1HOPx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 14/32] nohz/cpuset: Don't turn off the tick if rcu needs it
Date: Mon, 15 Aug 2011 17:52:11 +0200
Message-Id: <1313423549-27093-15-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If RCU is waiting for the current CPU to complete a grace
period, don't turn off the tick. Unlike dynctik-idle, we
are not necessarily going to enter into rcu extended quiescent
state, so we may need to keep the tick to note current CPU's
quiescent states.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    1 +
 kernel/rcutree.c         |    3 +--
 kernel/sched.c           |   14 ++++++++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..55a482a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -133,6 +133,7 @@ static inline int rcu_preempt_depth(void)
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
+extern int rcu_pending(int cpu);
 struct notifier_block;
 
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ba06207..0009bfc 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -205,7 +205,6 @@ int rcu_cpu_stall_suppress __read_mostly;
 module_param(rcu_cpu_stall_suppress, int, 0644);
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
-static int rcu_pending(int cpu);
 
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
@@ -1729,7 +1728,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-static int rcu_pending(int cpu)
+int rcu_pending(int cpu)
 {
 	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
 	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
diff --git a/kernel/sched.c b/kernel/sched.c
index 0e1aa4e..353a66f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2439,6 +2439,7 @@ DEFINE_PER_CPU(int, task_nohz_mode);
 bool cpuset_nohz_can_stop_tick(void)
 {
 	struct rq *rq;
+	int cpu;
 
 	rq = this_rq();
 
@@ -2446,6 +2447,19 @@ bool cpuset_nohz_can_stop_tick(void)
 	if (rq->nr_running > 1)
 		return false;
 
+	cpu = smp_processor_id();
+
+	/*
+	 * FIXME: will probably be removed soon as it's
+	 * already checked from tick_nohz_stop_sched_tick()
+	 */
+	if (rcu_needs_cpu(cpu))
+		return false;
+
+	/* Is there a grace period to complete ? */
+	if (rcu_pending(cpu))
+		return false;
+
 	return true;
 }
 
-- 
1.7.5.4

