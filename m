Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab0EDMj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:39:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:51838 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979Ab0EDMjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:49 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/12] perf: prepare to move sched perf functions on top of tracepoints
Date: Tue,  4 May 2010 14:38:43 +0200
Message-Id: <1272976724-14312-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move prototypes of perf_event_task_{migrate|sched_in|sched_out|tick}()
  into a separate #ifdef block and append _fn to function names and
  define macros to redirect calls.

* Define PE_STATIC which currently is empty so that these functions
  can be made static depending on config option.

* Define no-op perf_task_sched_out_done() and call it from the end of
  perf_task_sched_out().

Other than renaming the functions, this function doesn't introduce any
visible change.  This is to prepare for moving these functions on top
of tracepoints.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |   43 +++++++++++++++++++++++++++++--------------
 kernel/perf_event.c        |   30 ++++++++++++++++++++----------
 2 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e3c6c3..0ad898b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -747,6 +747,35 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
+extern void perf_event_task_migrate_fn(struct task_struct *task, int new_cpu);
+extern void perf_event_task_sched_in_fn(struct task_struct *task);
+extern void perf_event_task_sched_out_fn(struct rq *rq,
+					 struct task_struct *task,
+					 struct task_struct *next);
+extern void perf_event_task_tick_fn(struct task_struct *task);
+
+#define perf_event_task_migrate(t, c)	perf_event_task_migrate_fn((t), (c))
+#define perf_event_task_sched_in(t)	perf_event_task_sched_in_fn((t))
+#define perf_event_task_sched_out(r, t, n) \
+	perf_event_task_sched_out_fn((r), (t), (n))
+#define perf_event_task_tick(t)		perf_event_task_tick_fn((t))
+
+#else
+
+static inline void
+perf_event_task_migrate(struct task_struct *task, int new_cpu)		{ }
+static inline void
+perf_event_task_sched_in(struct task_struct *task)			{ }
+static inline void
+perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
+			  struct task_struct *next)			{ }
+static inline void
+perf_event_task_tick(struct task_struct *task)				{ }
+
+#endif
+
+#ifdef CONFIG_PERF_EVENTS
+
 /*
  * Set by architecture code:
  */
@@ -754,11 +783,6 @@ extern int perf_max_events;
 
 extern const struct pmu *hw_perf_event_init(struct perf_event *event);
 
-extern void perf_event_task_migrate(struct task_struct *task, int new_cpu);
-extern void perf_event_task_sched_in(struct task_struct *task);
-extern void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
-				      struct task_struct *next);
-extern void perf_event_task_tick(struct task_struct *task);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -950,15 +974,6 @@ extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 #else
-static inline void
-perf_event_task_migrate(struct task_struct *task, int new_cpu)		{ }
-static inline void
-perf_event_task_sched_in(struct task_struct *task)			{ }
-static inline void
-perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
-			    struct task_struct *next)			{ }
-static inline void
-perf_event_task_tick(struct task_struct *task)				{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 621d1f1..1c83dc6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -76,6 +76,8 @@ static DEFINE_SPINLOCK(perf_resource_lock);
  */
 static DEFINE_MUTEX(perf_online_mutex);
 
+#define PE_STATIC
+
 static int perf_inc_nr_events(void)
 {
 	mutex_lock(&perf_online_mutex);
@@ -91,6 +93,10 @@ static void perf_dec_nr_events(void)
 	mutex_unlock(&perf_online_mutex);
 }
 
+static void perf_task_sched_out_done(struct perf_event_context *ctx)
+{
+}
+
 /*
  * Architecture provided APIs - weak aliases:
  */
@@ -189,7 +195,7 @@ perf_lock_task_context(struct task_struct *task, unsigned long *flags)
 		/*
 		 * If this context is a clone of another, it might
 		 * get swapped for another underneath us by
-		 * perf_event_task_sched_out, though the
+		 * perf_event_task_sched_out_fn, though the
 		 * rcu_read_lock() protects us from any context
 		 * getting freed.  Lock the context and check if it
 		 * got swapped before we could get the lock, and retry
@@ -582,7 +588,8 @@ static void __perf_event_disable(void *info)
  * goes to exit will block in sync_child_event.
  * When called from perf_pending_event it's OK because event->ctx
  * is the current context on this CPU and preemption is disabled,
- * hence we can't get into perf_event_task_sched_out for this context.
+ * hence we can't get into perf_event_task_sched_out_fn for this
+ * context.
  */
 void perf_event_disable(struct perf_event *event)
 {
@@ -1172,7 +1179,7 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
  * If the task is moving to a different cpu, generate a migration sw
  * event.
  */
-void perf_event_task_migrate(struct task_struct *task, int new_cpu)
+PE_STATIC void perf_event_task_migrate_fn(struct task_struct *task, int new_cpu)
 {
 	if (task_cpu(task) != new_cpu)
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
@@ -1235,8 +1242,9 @@ static bool perf_event_switch_clones(struct perf_cpu_context *cpuctx,
  * accessing the event control register. If a NMI hits, then it will
  * not restart the event.
  */
-void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
-			       struct task_struct *next)
+PE_STATIC void perf_event_task_sched_out_fn(struct rq *rq,
+					    struct task_struct *task,
+					    struct task_struct *next)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
@@ -1244,13 +1252,15 @@ void perf_event_task_sched_out(struct rq *rq, struct task_struct *task,
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
 	if (likely(!ctx || !cpuctx->task_ctx))
-		return;
+		goto out;
 
 	if (perf_event_switch_clones(cpuctx, ctx, task, next))
-		return;
+		goto out;
 
 	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 	cpuctx->task_ctx = NULL;
+out:
+	perf_task_sched_out_done(cpuctx->task_ctx);
 }
 
 static void task_ctx_sched_out(struct perf_event_context *ctx,
@@ -1397,7 +1407,7 @@ static void task_ctx_sched_in(struct task_struct *task,
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-void perf_event_task_sched_in(struct task_struct *task)
+PE_STATIC void perf_event_task_sched_in_fn(struct task_struct *task)
 {
 	struct perf_event_context *ctx = task->perf_event_ctxp;
 	struct perf_cpu_context *cpuctx;
@@ -1603,7 +1613,7 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	raw_spin_unlock(&ctx->lock);
 }
 
-void perf_event_task_tick(struct task_struct *curr)
+PE_STATIC void perf_event_task_tick_fn(struct task_struct *curr)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
@@ -1705,7 +1715,7 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_task_sched_in(task);
+	perf_event_task_sched_in_fn(task);
  out:
 	local_irq_restore(flags);
 }
-- 
1.6.4.2

