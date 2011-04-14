Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab1DNIeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:34:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:47178 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920Ab1DNIeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:34:21 -0400
Date: Thu, 14 Apr 2011 08:33:16 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-d7c01d27ab767a30d672d1fd657aa8336ebdcbca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152728.908177058@chello.nl>
References: <20110405152728.908177058@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Clean up ttwu() stats
Git-Commit-ID: d7c01d27ab767a30d672d1fd657aa8336ebdcbca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:33:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7c01d27ab767a30d672d1fd657aa8336ebdcbca
Gitweb:     http://git.kernel.org/tip/d7c01d27ab767a30d672d1fd657aa8336ebdcbca
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:34 +0200

sched: Clean up ttwu() stats

Collect all ttwu() stat code into a single function and ensure its
always called for an actual wakeup (changing p->state to
TASK_RUNNING).

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152728.908177058@chello.nl
---
 kernel/sched.c |   75 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3919aa4..4481638 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2406,20 +2406,43 @@ static void update_avg(u64 *avg, u64 sample)
 }
 #endif
 
-static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
-				 bool is_sync, bool is_migrate, bool is_local,
-				 unsigned long en_flags)
+static void
+ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
 {
+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_SMP
+	int this_cpu = smp_processor_id();
+
+	if (cpu == this_cpu) {
+		schedstat_inc(rq, ttwu_local);
+		schedstat_inc(p, se.statistics.nr_wakeups_local);
+	} else {
+		struct sched_domain *sd;
+
+		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+		for_each_domain(this_cpu, sd) {
+			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
+				schedstat_inc(sd, ttwu_wake_remote);
+				break;
+			}
+		}
+	}
+#endif /* CONFIG_SMP */
+
+	schedstat_inc(rq, ttwu_count);
 	schedstat_inc(p, se.statistics.nr_wakeups);
-	if (is_sync)
+
+	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.statistics.nr_wakeups_sync);
-	if (is_migrate)
+
+	if (cpu != task_cpu(p))
 		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
-	if (is_local)
-		schedstat_inc(p, se.statistics.nr_wakeups_local);
-	else
-		schedstat_inc(p, se.statistics.nr_wakeups_remote);
 
+#endif /* CONFIG_SCHEDSTATS */
+}
+
+static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
+{
 	activate_task(rq, p, en_flags);
 
 	/* if a worker is waking up, notify workqueue */
@@ -2481,12 +2504,12 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (!(p->state & state))
 		goto out;
 
+	cpu = task_cpu(p);
+
 	if (p->se.on_rq)
 		goto out_running;
 
-	cpu = task_cpu(p);
 	orig_cpu = cpu;
-
 #ifdef CONFIG_SMP
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
@@ -2527,27 +2550,12 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	WARN_ON(task_cpu(p) != cpu);
 	WARN_ON(p->state != TASK_WAKING);
 
-#ifdef CONFIG_SCHEDSTATS
-	schedstat_inc(rq, ttwu_count);
-	if (cpu == this_cpu)
-		schedstat_inc(rq, ttwu_local);
-	else {
-		struct sched_domain *sd;
-		for_each_domain(this_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				schedstat_inc(sd, ttwu_wake_remote);
-				break;
-			}
-		}
-	}
-#endif /* CONFIG_SCHEDSTATS */
-
 out_activate:
 #endif /* CONFIG_SMP */
-	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
-		      cpu == this_cpu, en_flags);
+	ttwu_activate(rq, p, en_flags);
 out_running:
 	ttwu_post_activation(p, rq, wake_flags);
+	ttwu_stat(rq, p, cpu, wake_flags);
 	success = 1;
 out:
 	task_rq_unlock(rq, &flags);
@@ -2575,14 +2583,11 @@ static void try_to_wake_up_local(struct task_struct *p)
 	if (!(p->state & TASK_NORMAL))
 		return;
 
-	if (!p->se.on_rq) {
-		if (likely(!task_running(rq, p))) {
-			schedstat_inc(rq, ttwu_count);
-			schedstat_inc(rq, ttwu_local);
-		}
-		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
-	}
+	if (!p->se.on_rq)
+		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+
 	ttwu_post_activation(p, rq, 0);
+	ttwu_stat(rq, p, smp_processor_id(), 0);
 }
 
 /**
