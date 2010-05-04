Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab0EDMk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:40:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:51778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab0EDMjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:17 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/12] perf: add @rq to perf_event_task_sched_out()
Date: Tue,  4 May 2010 14:38:36 +0200
Message-Id: <1272976724-14312-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add @rq to perf_event_task_sched_out() so that its argument matches
those of trace_sched_switch().  This will help unifying notifiers in
sched.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    5 +++--
 kernel/perf_event.c        |    4 ++--
 kernel/sched.c             |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a5eec48..1e3c6c3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -756,7 +756,8 @@ extern const struct pmu *hw_perf_event_init(struct perf_event *event);
 
 extern void perf_event_task_migrate(struct task_struct *task, int new_cpu);
 extern void perf_event_task_sched_in(struct task_struct *task);
-extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
+extern void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
+				      struct task_struct *next);
 extern void perf_event_task_tick(struct task_struct *task);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
@@ -954,7 +955,7 @@ perf_event_task_migrate(struct task_struct *task, int new_cpu)		{ }
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
 static inline void
-perf_event_task_sched_out(struct task_struct *task,
+perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
 			    struct task_struct *next)			{ }
 static inline void
 perf_event_task_tick(struct task_struct *task)				{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a01ba31..73e2c1c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1169,8 +1169,8 @@ void perf_event_task_migrate(struct task_struct *task, int new_cpu)
  * accessing the event control register. If a NMI hits, then it will
  * not restart the event.
  */
-void perf_event_task_sched_out(struct task_struct *task,
-				 struct task_struct *next)
+void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
+			       struct task_struct *next)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
diff --git a/kernel/sched.c b/kernel/sched.c
index 2568911..4c5e4c9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3720,7 +3720,7 @@ need_resched_nonpreemptible:
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
-		perf_event_task_sched_out(prev, next);
+		perf_event_task_sched_out(rq, prev, next);
 
 		rq->nr_switches++;
 		rq->curr = next;
-- 
1.6.4.2

