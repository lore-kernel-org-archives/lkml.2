Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab2F1C5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:57:17 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37149 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153Ab2F1C40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:26 -0400
Subject: [PATCH 05/16] sched: add an rq migration call-back to sched_class
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 19:24:14 -0700
Message-ID: <20120628022414.30496.73413.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are now doing bottom up load accumulation we need explicit
notification when a task has been re-parented so that the old hierarchy can be
updated.

Adds task_migrate_rq(struct rq *prev, struct *rq new_rq);

(The alternative is to do this out of __set_task_cpu, but it was suggested that
this would be a cleaner encapsulation.)

Signed-off-by: Paul Turner <pjt@google.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    2 ++
 kernel/sched/fair.c   |   12 ++++++++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 842c4df..fdfdfab 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1102,6 +1102,7 @@ struct sched_class {
 
 #ifdef CONFIG_SMP
 	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index aeb8e56..c3686eb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1109,6 +1109,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	trace_sched_migrate_task(p, new_cpu);
 
 	if (task_cpu(p) != new_cpu) {
+		if (p->sched_class->migrate_task_rq)
+			p->sched_class->migrate_task_rq(p, new_cpu);
 		p->se.nr_migrations++;
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
 	}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6200d20..33f582a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3089,6 +3089,17 @@ unlock:
 
 	return new_cpu;
 }
+
+/*
+ * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
+ * cfs_rq_of(p) references at time of call are still valid and identify the
+ * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
+ * other assumptions, including rq->lock state, should be made.
+ * Caller guarantees p->pi_lock held, but nothing else.
+ */
+static void
+migrate_task_rq_fair(struct task_struct *p, int next_cpu) {
+}
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -5754,6 +5765,7 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
+	.migrate_task_rq	= migrate_task_rq_fair,
 
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,


