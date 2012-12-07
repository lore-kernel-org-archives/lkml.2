Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2LGATl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:19:41 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61318 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2LGATj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:19:39 -0500
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
Subject: [PATCH 1/9] numa, sched: Fix NUMA tick ->numa_shared setting
Date: Fri,  7 Dec 2012 01:19:18 +0100
Message-Id: <1354839566-15697-2-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354839566-15697-1-git-send-email-mingo@kernel.org>
References: <1354839566-15697-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out an unlocked variant of __sched_setnuma(),
and use it in the NUMA tick when we are modifying
p->numa_shared.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 19 +++++++++++++++----
 kernel/sched/fair.c  |  2 +-
 kernel/sched/sched.h |  1 +
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 69b18b3..cce84c3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6091,13 +6091,10 @@ static struct sched_domain_topology_level *sched_domain_topology = default_topol
 /*
  * Change a task's NUMA state - called from the placement tick.
  */
-void sched_setnuma(struct task_struct *p, int node, int shared)
+void __sched_setnuma(struct rq *rq, struct task_struct *p, int node, int shared)
 {
-	unsigned long flags;
 	int on_rq, running;
-	struct rq *rq;
 
-	rq = task_rq_lock(p, &flags);
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 
@@ -6113,6 +6110,20 @@ void sched_setnuma(struct task_struct *p, int node, int shared)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
 		enqueue_task(rq, p, 0);
+}
+
+/*
+ * Change a task's NUMA state - called from the placement tick.
+ */
+void sched_setnuma(struct task_struct *p, int node, int shared)
+{
+	unsigned long flags;
+	struct rq *rq;
+
+	rq = task_rq_lock(p, &flags);
+
+	__sched_setnuma(rq, p, node, shared);
+
 	task_rq_unlock(rq, p, &flags);
 
 	/*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 21c10f7..0c83689 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2540,7 +2540,7 @@ static void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	/* Cheap checks first: */
 	if (!task_numa_candidate(curr)) {
 		if (curr->numa_shared >= 0)
-			curr->numa_shared = -1;
+			__sched_setnuma(rq, curr, -1, -1);
 		return;
 	}
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0fdd304..f75bf06 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -513,6 +513,7 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
 #ifdef CONFIG_NUMA_BALANCING
+extern void __sched_setnuma(struct rq *rq, struct task_struct *p, int node, int shared);
 extern void sched_setnuma(struct task_struct *p, int node, int shared);
 static inline void task_numa_free(struct task_struct *p)
 {
-- 
1.7.11.7

