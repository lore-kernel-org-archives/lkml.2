Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0LTPYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:24:47 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63472 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab0LTPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G/gKgJrS8NfjWERYkEGhTbcOw0qvF1/j43nJRZynA1Z4T+yYyDj9jbFxQX34xnQSyV
         QGvm4ZwqnuAgz+HsVABHw0PDl5EiA0B15Lums3xaa2vokKsToybmoAmwe/yWUFnanBke
         7kYgXG246w/1wLdAaWq7fEmEt9uFGE8cXU3bo=
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
Subject: [RFC PATCH 05/15] nohz_task: Restart the tick when another task compete on the cpu
Date: Mon, 20 Dec 2010 16:24:12 +0100
Message-Id: <1292858662-5650-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a new task is enqueued on the same cpu than a nohz task, then
the tick must be restarted in case it was stopped for the nohz
task, so that preemption can work again.

Do this remotely using a specific IPI.

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
 include/linux/sched.h |    2 ++
 kernel/sched.c        |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 858a876..f80088a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2550,8 +2550,10 @@ extern void task_oncpu_function_call(struct task_struct *p,
 				     void (*func) (void *info), void *info);
 
 #ifdef CONFIG_NO_HZ_TASK
+extern void smp_send_update_nohz_task_cpu(int cpu);
 extern int nohz_task_can_stop_tick(void);
 #else
+static inline void smp_send_update_nohz_task_cpu(int cpu) { }
 static inline int nohz_task_can_stop_tick(void) { return 0; }
 #endif
 
diff --git a/kernel/sched.c b/kernel/sched.c
index e9cdd7a..6dbae46 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2446,6 +2446,27 @@ static void update_avg(u64 *avg, u64 sample)
 #ifdef CONFIG_NO_HZ_TASK
 DEFINE_PER_CPU(int, task_nohz_mode);
 
+/* Must be called with irq disabled! */
+static void nohz_task_cpu_update(void *unused)
+{
+	struct rq *rq;
+	int cpu;
+
+	if (!__get_cpu_var(task_nohz_mode))
+		return;
+
+	/*
+	 * Look at nr_running lockless. At worst, the new task was deactivated
+	 * and we just exit without doing anything.
+	 */
+	rq = this_rq();
+	cpu = smp_processor_id();
+	if (rq->nr_running > 1) {
+		__get_cpu_var(task_nohz_mode) = 0;
+		tick_nohz_restart_sched_tick();
+	}
+}
+
 int nohz_task_can_stop_tick(void)
 {
 	struct rq *rq = this_rq();
@@ -2455,6 +2476,12 @@ int nohz_task_can_stop_tick(void)
 
 	return 1;
 }
+
+void smp_send_update_nohz_task_cpu(int cpu)
+{
+	smp_call_function_single(cpu, nohz_task_cpu_update,
+				 NULL, 0);
+}
 #endif
 
 static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
@@ -2477,6 +2504,8 @@ static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
 static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 					int wake_flags, bool success)
 {
+	int cpu = cpu_of(rq);
+
 	trace_sched_wakeup(p, success);
 	check_preempt_curr(rq, p, wake_flags);
 
@@ -2498,7 +2527,21 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 #endif
 	/* if a worker is waking up, notify workqueue */
 	if ((p->flags & PF_WQ_WORKER) && success)
-		wq_worker_waking_up(p, cpu_of(rq));
+		wq_worker_waking_up(p, cpu);
+
+#ifdef CONFIG_NO_HZ_TASK
+	/*
+	 * CHECKME:
+	 * Ideally, we need to check if the target has a nohz task
+	 * and only send the IPI if so. But there is nothing but
+	 * a racy way to do that. Or can we assume at that point
+	 * of the wake up that if cpu_has_nohz_task(cpu) is 0, then
+	 * it's ok, even if it has a task about to switch to nohz
+	 * task mode?
+	 */
+	if (rq->nr_running == 2)
+		smp_send_update_nohz_task_cpu(cpu);
+#endif
 }
 
 /**
-- 
1.7.3.2

