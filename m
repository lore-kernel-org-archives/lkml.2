Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab0EDMkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:40:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:51808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab0EDMjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:46 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/12] perf: factor out perf_event_switch_clones()
Date: Tue,  4 May 2010 14:38:41 +0200
Message-Id: <1272976724-14312-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out perf_event_switch_clones() from
perf_event_task_sched_out().  This is to ease future changes and
doesn't cause any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/perf_event.c |   62 +++++++++++++++++++++++++++++---------------------
 1 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 295699f..3f3e328 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1158,30 +1158,14 @@ void perf_event_task_migrate(struct task_struct *task, int new_cpu)
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
 }
 
-/*
- * Called from scheduler to remove the events of the current task,
- * with interrupts disabled.
- *
- * We stop each event and update the event value in event->count.
- *
- * This does not protect us against NMI, but disable()
- * sets the disabled bit in the control field of event _before_
- * accessing the event control register. If a NMI hits, then it will
- * not restart the event.
- */
-void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
-			       struct task_struct *next)
+static bool perf_event_switch_clones(struct perf_cpu_context *cpuctx,
+				     struct perf_event_context *ctx,
+				     struct task_struct *task,
+				     struct task_struct *next)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
-	struct perf_event_context *ctx = task->perf_event_ctxp;
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
-	int do_switch = 1;
-
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
-
-	if (likely(!ctx || !cpuctx->task_ctx))
-		return;
+	bool switched = false;
 
 	rcu_read_lock();
 	parent = rcu_dereference(ctx->parent_ctx);
@@ -1208,7 +1192,7 @@ void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
 			next->perf_event_ctxp = ctx;
 			ctx->task = next;
 			next_ctx->task = task;
-			do_switch = 0;
+			switched = true;
 
 			perf_event_sync_stat(ctx, next_ctx);
 		}
@@ -1217,10 +1201,36 @@ void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
 	}
 	rcu_read_unlock();
 
-	if (do_switch) {
-		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
-		cpuctx->task_ctx = NULL;
-	}
+	return switched;
+}
+
+/*
+ * Called from scheduler to remove the events of the current task,
+ * with interrupts disabled.
+ *
+ * We stop each event and update the event value in event->count.
+ *
+ * This does not protect us against NMI, but disable()
+ * sets the disabled bit in the control field of event _before_
+ * accessing the event control register. If a NMI hits, then it will
+ * not restart the event.
+ */
+void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
+			       struct task_struct *next)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_event_context *ctx = task->perf_event_ctxp;
+
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
+
+	if (likely(!ctx || !cpuctx->task_ctx))
+		return;
+
+	if (perf_event_switch_clones(cpuctx, ctx, task, next))
+		return;
+
+	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
+	cpuctx->task_ctx = NULL;
 }
 
 static void task_ctx_sched_out(struct perf_event_context *ctx,
-- 
1.6.4.2

