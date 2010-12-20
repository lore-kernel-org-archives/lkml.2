Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab0LTPYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:24:51 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:54867 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab0LTPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IyDH7ulzV8N5rTlfjPhoInMsJugacxbSQZ3nc6e5PSnoFq+SpsGhhVvDVHM2RZiY9V
         bIAZKVwDfv3cGpR6Z0ePormMsJFPw6HQRe7JC3DxLlVhYN7zYbR1jZfPtWd9bGUlwje1
         LkfoSQmlx8+D1z+FGnC9jIiXHifyFQLokf3oE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 07/15] nohz_task: Restart tick when RCU forces nohz task cpu quiescent state
Date: Mon, 20 Dec 2010 16:24:14 +0100
Message-Id: <1292858662-5650-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a cpu is in nohz mode due to a nohz task running, then
it is not able to notify quiescent states requested by other
CPUs.

Then restart the tick to remotely force the quiescent states on the
nohz task cpus.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   21 +++++++++++++++------
 kernel/sched.c   |    2 +-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 44dce3f..ed6aba3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -227,6 +227,8 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
  */
 static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 {
+	int has_nohz_task;
+
 	/*
 	 * If the CPU is offline, it is in a quiescent state.  We can
 	 * trust its state not to change because interrupts are disabled.
@@ -236,15 +238,22 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
+	has_nohz_task = cpu_has_nohz_task(rdp->cpu);
+
 	/* If preemptable RCU, no point in sending reschedule IPI. */
-	if (rdp->preemptable)
+	if (rdp->preemptable && !has_nohz_task)
 		return 0;
 
-	/* The CPU is online, so send it a reschedule IPI. */
-	if (rdp->cpu != smp_processor_id())
-		smp_send_reschedule(rdp->cpu);
-	else
-		set_need_resched();
+	if (!has_nohz_task) {
+		/* The CPU is online, so send it a reschedule IPI. */
+		if (rdp->cpu != smp_processor_id())
+			smp_send_reschedule(rdp->cpu);
+		else
+			set_need_resched();
+	} else {
+		smp_send_update_nohz_task_cpu(rdp->cpu);
+	}
+
 	rdp->resched_ipi++;
 	return 0;
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 45bd6e2..b99f192 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2461,7 +2461,7 @@ static void nohz_task_cpu_update(void *unused)
 	 */
 	rq = this_rq();
 	cpu = smp_processor_id();
-	if (rq->nr_running > 1) {
+	if (rq->nr_running > 1 || rcu_pending(cpu) || rcu_needs_cpu(cpu)) {
 		__get_cpu_var(task_nohz_mode) = 0;
 		tick_nohz_restart_sched_tick();
 	}
-- 
1.7.3.2

