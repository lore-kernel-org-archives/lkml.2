Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab2HWOWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:22:07 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44921 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab2HWOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:21:53 -0400
Message-Id: <20120823141506.660023400@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:27 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [patch 05/16] sched: add an rq migration call-back to sched_class
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-migrate_rq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

Since we are now doing bottom up load accumulation we need explicit
notification when a task has been re-parented so that the old hierarchy can be
updated.

Adds: migrate_task_rq(struct task_struct *p, int next_cpu)

(The alternative is to do this out of __set_task_cpu, but it was suggested that
this would be a cleaner encapsulation.)

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    2 ++
 kernel/sched/fair.c   |   12 ++++++++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7406249..93e27c0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1105,6 +1105,7 @@ struct sched_class {
 
 #ifdef CONFIG_SMP
 	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 33e6fe1..b3e2442 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -952,6 +952,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	trace_sched_migrate_task(p, new_cpu);
 
 	if (task_cpu(p) != new_cpu) {
+		if (p->sched_class->migrate_task_rq)
+			p->sched_class->migrate_task_rq(p, new_cpu);
 		p->se.nr_migrations++;
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
 	}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0ce8d91..e11e24c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3028,6 +3028,17 @@ unlock:
 
 	return new_cpu;
 }
+
+/*
+ * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
+ * cfs_rq_of(p) references at time of call are still valid and identify the
+ * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
+ * other assumptions, including the state of rq->lock, should be made.
+ */
+static void
+migrate_task_rq_fair(struct task_struct *p, int next_cpu)
+{
+}
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -5591,6 +5602,7 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
+	.migrate_task_rq	= migrate_task_rq_fair,
 
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,


