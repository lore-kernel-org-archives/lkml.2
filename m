Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2LDI4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:56:53 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34726 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2LDI41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:56:27 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 04/10] sched,
 cpu hotplug: Use stable online cpus in try_to_wake_up() &
 select_task_rq()
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org
Cc: sbw@mit.edu, tj@kernel.org, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 14:24:50 +0530
Message-ID: <20121204085447.25919.39629.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120408-5816-0000-0000-000005AC33D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With stop_machine() gone from the CPU offline path, we can't depend on
preempt_disable() to prevent CPUs from going offline from under us.

Use the get/put_online_cpus_stable_atomic() APIs to prevent CPUs from going
offline, while invoking from atomic context.

Scheduler functions such as try_to_wake_up() and select_task_rq() (and even
select_fallback_rq()) deal with picking new CPUs to run tasks. It would be
better if they picked those CPUs from the set of CPUs that are going to
remain online. So use the cpu_online_stable_mask while making those decisions.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/sched/core.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..ef6ada4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1103,6 +1103,10 @@ EXPORT_SYMBOL_GPL(kick_process);
 #ifdef CONFIG_SMP
 /*
  * ->cpus_allowed is protected by both rq->lock and p->pi_lock
+ *
+ *  Must be called under get/put_online_cpus_stable_atomic() or
+ *  equivalent, to avoid CPUs from going offline from underneath
+ *  us.
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
@@ -1112,7 +1116,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 
 	/* Look for allowed, online CPU in same node. */
 	for_each_cpu(dest_cpu, nodemask) {
-		if (!cpu_online(dest_cpu))
+		if (!cpu_online_stable(dest_cpu))
 			continue;
 		if (!cpu_active(dest_cpu))
 			continue;
@@ -1123,7 +1127,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	for (;;) {
 		/* Any allowed, online CPU? */
 		for_each_cpu(dest_cpu, tsk_cpus_allowed(p)) {
-			if (!cpu_online(dest_cpu))
+			if (!cpu_online_stable(dest_cpu))
 				continue;
 			if (!cpu_active(dest_cpu))
 				continue;
@@ -1166,6 +1170,9 @@ out:
 
 /*
  * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
+ *
+ * Must be called under get/put_online_cpus_stable_atomic(), to prevent
+ * CPUs from going offline from underneath us.
  */
 static inline
 int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
@@ -1183,7 +1190,7 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 	 *   not worry about this generic constraint ]
 	 */
 	if (unlikely(!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)) ||
-		     !cpu_online(cpu)))
+		     !cpu_online_stable(cpu)))
 		cpu = select_fallback_rq(task_cpu(p), p);
 
 	return cpu;
@@ -1406,6 +1413,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	int cpu, success = 0;
 
 	smp_wmb();
+	get_online_cpus_stable_atomic();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	if (!(p->state & state))
 		goto out;
@@ -1446,6 +1454,7 @@ stat:
 	ttwu_stat(p, cpu, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	put_online_cpus_stable_atomic();
 
 	return success;
 }
@@ -1624,6 +1633,7 @@ void wake_up_new_task(struct task_struct *p)
 	unsigned long flags;
 	struct rq *rq;
 
+	get_online_cpus_stable_atomic();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 #ifdef CONFIG_SMP
 	/*
@@ -1644,6 +1654,7 @@ void wake_up_new_task(struct task_struct *p)
 		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, p, &flags);
+	put_online_cpus_stable_atomic();
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -2541,6 +2552,7 @@ void sched_exec(void)
 	unsigned long flags;
 	int dest_cpu;
 
+	get_online_cpus_stable_atomic();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
@@ -2550,11 +2562,13 @@ void sched_exec(void)
 		struct migration_arg arg = { p, dest_cpu };
 
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		put_online_cpus_stable_atomic();
 		stop_one_cpu(task_cpu(p), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	put_online_cpus_stable_atomic();
 }
 
 #endif

