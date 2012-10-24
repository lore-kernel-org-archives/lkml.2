Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2JXJs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:48:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2JXJs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:48:57 -0400
Date: Wed, 24 Oct 2012 02:47:44 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-0a74bef8bed18dc6889e9bc37ea1050a50c86c89@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141506.660023400@google.com>
References: <20120823141506.660023400@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Add an rq migration call-back to sched_class
Git-Commit-ID: 0a74bef8bed18dc6889e9bc37ea1050a50c86c89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:47:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a74bef8bed18dc6889e9bc37ea1050a50c86c89
Gitweb:     http://git.kernel.org/tip/0a74bef8bed18dc6889e9bc37ea1050a50c86c89
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:23 +0200

sched: Add an rq migration call-back to sched_class

Since we are now doing bottom up load accumulation we need explicit
notification when a task has been re-parented so that the old hierarchy can be
updated.

Adds: migrate_task_rq(struct task_struct *p, int next_cpu)

(The alternative is to do this out of __set_task_cpu, but it was suggested that
this would be a cleaner encapsulation.)

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141506.660023400@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    2 ++
 kernel/sched/fair.c   |   12 ++++++++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b1831ac..e483ccb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1061,6 +1061,7 @@ struct sched_class {
 
 #ifdef CONFIG_SMP
 	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 00898f1..f268600 100644
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
index 8319417..5e602e6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3047,6 +3047,17 @@ unlock:
 
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
@@ -5607,6 +5618,7 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
+	.migrate_task_rq	= migrate_task_rq_fair,
 
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
