Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2LBQN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 11:13:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57795 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2LBQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 11:13:27 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 1/2] sched: Exclude pinned tasks from the NUMA-balancing logic
Date: Sun,  2 Dec 2012 17:13:15 +0100
Message-Id: <1354464796-14343-2-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354464796-14343-1-git-send-email-mingo@kernel.org>
References: <1354464796-14343-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try to NUMA-balance hard-bound tasks in vein. This
also makes it easier to compare hard-bound workloads against
NUMA-balanced workloads, because the NUMA code will
be completely inactive for those hard-bound tasks.

( Keep a debugging feature flag around: for development it
  makes sense to observe what NUMA balancing tries to do
  with hard-affine tasks. )

[ Note: the duplicated test condition will be consolidated
  in the next patch. ]

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c     | 6 ++++++
 kernel/sched/debug.c    | 1 +
 kernel/sched/fair.c     | 7 +++++++
 kernel/sched/features.h | 1 +
 4 files changed, 15 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 85fd67c..69b18b3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4664,6 +4664,12 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 
 	cpumask_copy(&p->cpus_allowed, new_mask);
 	p->nr_cpus_allowed = cpumask_weight(new_mask);
+
+#ifdef CONFIG_NUMA_BALANCING
+	/* Don't disturb hard-bound tasks: */
+	if (sched_feat(NUMA_EXCLUDE_AFFINE) && (p->nr_cpus_allowed != num_online_cpus()))
+		p->numa_shared = -1;
+#endif
 }
 
 /*
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..e10b714 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -448,6 +448,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
+	P(nr_cpus_allowed);
 #ifdef CONFIG_SCHEDSTATS
 	PN(se.statistics.wait_start);
 	PN(se.statistics.sleep_start);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eaff006..9667191 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2495,6 +2495,13 @@ static void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	if (!curr->mm || (curr->flags & PF_EXITING) || !curr->numa_faults)
 		return;
 
+	/* Don't disturb hard-bound tasks: */
+	if (sched_feat(NUMA_EXCLUDE_AFFINE) && (curr->nr_cpus_allowed != num_online_cpus())) {
+		if (curr->numa_shared >= 0)
+			curr->numa_shared = -1;
+		return;
+	}
+
 	task_tick_numa_scan(rq, curr);
 	task_tick_numa_placement(rq, curr);
 }
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 1775b80..5598f63 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -77,6 +77,7 @@ SCHED_FEAT(WAKE_ON_IDEAL_CPU,		false)
 SCHED_FEAT(NUMA,			true)
 SCHED_FEAT(NUMA_BALANCE_ALL,		false)
 SCHED_FEAT(NUMA_BALANCE_INTERNODE,	false)
+SCHED_FEAT(NUMA_EXCLUDE_AFFINE,		true)
 SCHED_FEAT(NUMA_LB,			false)
 SCHED_FEAT(NUMA_GROUP_LB_COMPRESS,	true)
 SCHED_FEAT(NUMA_GROUP_LB_SPREAD,	true)
-- 
1.7.11.7

