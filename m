Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab1EKQli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:41:38 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57855 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab1EKPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:49 -0400
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] perf: Carve out cgroup-related code
Date: Wed, 11 May 2011 15:16:55 +0200
Message-Id: <1305119816-26280-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1305119816-26280-1-git-send-email-bp@amd64.org>
References: <1305119816-26280-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move cgroup perf support into a different compilation module -
kernel/events/cgroup.c - thus slimming perf_event.c some more.

While at it,

* push some oneliners into perf_event.h now that they're used in
multiple .c files.

* drop is_cgroup_event() check for perf_cgroup_defer_enabled() at its
callsite in __perf_event_enable since the latter does the check anyway.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |  126 +++++++++++-
 kernel/events/Makefile     |    1 +
 kernel/events/cgroup.c     |  324 +++++++++++++++++++++++++++++
 kernel/events/core.c       |  496 +-------------------------------------------
 4 files changed, 461 insertions(+), 486 deletions(-)
 create mode 100644 kernel/events/cgroup.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..687f852 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -954,8 +954,15 @@ struct perf_output_handle {
 	int				sample;
 };
 
+enum event_type_t {
+	EVENT_FLEXIBLE = 0x1,
+	EVENT_PINNED = 0x2,
+	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
+};
+
 #ifdef CONFIG_PERF_EVENTS
 
+extern struct list_head pmus;
 extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
@@ -1153,6 +1160,47 @@ extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+
+static inline struct perf_cpu_context *
+__get_cpu_context(struct perf_event_context *ctx)
+{
+	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
+}
+
+static inline u64 perf_clock(void)
+{
+	return local_clock();
+}
+
+extern void ctx_sched_out(struct perf_event_context *ctx,
+			  struct perf_cpu_context *cpuctx,
+			  enum event_type_t event_type);
+/*
+ * Called with IRQs disabled
+ */
+static inline void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
+				     enum event_type_t event_type)
+{
+	ctx_sched_out(&cpuctx->ctx, cpuctx, event_type);
+}
+
+extern void ctx_sched_in(struct perf_event_context *ctx,
+			 struct perf_cpu_context *cpuctx,
+			 enum event_type_t event_type,
+			 struct task_struct *task);
+
+static inline void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+				    enum event_type_t event_type,
+				    struct task_struct *task)
+{
+	struct perf_event_context *ctx = &cpuctx->ctx;
+
+	ctx_sched_in(ctx, cpuctx, event_type, task);
+}
+
+extern int
+task_function_call(struct task_struct *p, int (*func) (void *info), void *info);
+extern u64 perf_event_time(struct perf_event *event);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1187,7 +1235,83 @@ static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
-#endif
+#endif /* CONFIG_PERF_EVENTS */
+
+#ifdef CONFIG_CGROUP_PERF
+extern struct perf_cgroup *
+perf_cgroup_from_task(struct task_struct *task);
+extern bool perf_cgroup_match(struct perf_event *event);
+extern int
+perf_cgroup_connect(pid_t pid, struct perf_event *event,
+		    struct perf_event_attr *attr,
+		    struct perf_event *group_leader);
+extern void perf_detach_cgroup(struct perf_event *event);
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return event->cgrp != NULL;
+}
+
+extern u64 perf_cgroup_event_time(struct perf_event *event);
+extern void update_cgrp_time_from_event(struct perf_event *event);
+extern void
+update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx);
+extern void
+perf_cgroup_set_timestamp(struct task_struct *task,
+			  struct perf_event_context *ctx);
+
+extern void perf_cgroup_sched_out(struct task_struct *task);
+extern void perf_cgroup_sched_in(struct task_struct *task);
+
+static inline void
+perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
+{
+	struct perf_cgroup_info *t;
+	t = per_cpu_ptr(event->cgrp->info, event->cpu);
+	event->shadow_ctx_time = now - t->timestamp;
+}
+
+static inline void
+perf_cgroup_defer_enabled(struct perf_event *event)
+{
+	/*
+	 * when the current task's perf cgroup does not match
+	 * the event's, we need to remember to call the
+	 * perf_mark_enable() function the first time a task with
+	 * a matching perf cgroup is scheduled in.
+	 */
+	if (is_cgroup_event(event) && !perf_cgroup_match(event))
+		event->cgrp_defer_enabled = 1;
+}
+extern inline void
+perf_cgroup_mark_enabled(struct perf_event *event,
+			 struct perf_event_context *ctx);
+#else
+static inline struct perf_cgroup *
+perf_cgroup_from_task(struct task_struct *task)				{ return NULL; }
+static inline bool perf_cgroup_match(struct perf_event *event)		{ return true; }
+static inline int
+perf_cgroup_connect(pid_t pid, struct perf_event *event,
+		    struct perf_event_attr *attr,
+		    struct perf_event *group_leader)			{ return -EINVAL; }
+static inline void perf_detach_cgroup(struct perf_event *event)		{ }
+static inline int is_cgroup_event(struct perf_event *event)		{ return 0; }
+static inline u64 perf_cgroup_event_time(struct perf_event *event)	{ return 0; }
+static inline void update_cgrp_time_from_event(struct perf_event *e)	{ }
+static inline void
+update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)		{ }
+static inline void
+perf_cgroup_set_timestamp(struct task_struct *task,
+			  struct perf_event_context *ctx)		{ }
+static inline void perf_cgroup_sched_out(struct task_struct *task)	{ }
+static inline void perf_cgroup_sched_in(struct task_struct *task)	{ }
+static inline void
+perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)		{ }
+static inline void perf_cgroup_defer_enabled(struct perf_event *event)	{ }
+static inline void
+perf_cgroup_mark_enabled(struct perf_event *event,
+			 struct perf_event_context *ctx)		{ }
+#endif /* CONFIG_CGROUP_PERF */
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 1ce23d3..21b7da7 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -4,3 +4,4 @@ endif
 
 obj-y := core.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
+obj-$(CONFIG_CGROUP_PERF)	 += cgroup.o
diff --git a/kernel/events/cgroup.c b/kernel/events/cgroup.c
new file mode 100644
index 0000000..5516928
--- /dev/null
+++ b/kernel/events/cgroup.c
@@ -0,0 +1,324 @@
+#include <linux/file.h>
+#include <linux/slab.h>
+#include <linux/perf_event.h>
+
+/*
+ * Must ensure cgroup is pinned (css_get) before calling
+ * this function. In other words, we cannot call this function
+ * if there is no cgroup event for the current CPU context.
+ */
+inline struct perf_cgroup *perf_cgroup_from_task(struct task_struct *task)
+{
+	return container_of(task_subsys_state(task, perf_subsys_id),
+			    struct perf_cgroup, css);
+}
+
+inline bool perf_cgroup_match(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
+
+	return !event->cgrp || event->cgrp == cpuctx->cgrp;
+}
+
+static inline void perf_get_cgroup(struct perf_event *event)
+{
+	css_get(&event->cgrp->css);
+}
+
+inline int perf_cgroup_connect(int fd, struct perf_event *event,
+			       struct perf_event_attr *attr,
+			       struct perf_event *group_leader)
+{
+	struct perf_cgroup *cgrp;
+	struct cgroup_subsys_state *css;
+	struct file *file;
+	int ret = 0, fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return -EBADF;
+
+	css = cgroup_css_from_dir(file, perf_subsys_id);
+	if (IS_ERR(css)) {
+		ret = PTR_ERR(css);
+		goto out;
+	}
+
+	cgrp = container_of(css, struct perf_cgroup, css);
+	event->cgrp = cgrp;
+
+	/* must be done before we fput() the file */
+	perf_get_cgroup(event);
+
+	/*
+	 * all events in a group must monitor
+	 * the same cgroup because a task belongs
+	 * to only one perf cgroup at a time
+	 */
+	if (group_leader && group_leader->cgrp != cgrp) {
+		perf_detach_cgroup(event);
+		ret = -EINVAL;
+	}
+out:
+	fput_light(file, fput_needed);
+	return ret;
+}
+
+static inline void perf_put_cgroup(struct perf_event *event)
+{
+	css_put(&event->cgrp->css);
+}
+
+inline void perf_detach_cgroup(struct perf_event *event)
+{
+	perf_put_cgroup(event);
+	event->cgrp = NULL;
+}
+
+inline u64 perf_cgroup_event_time(struct perf_event *event)
+{
+	struct perf_cgroup_info *t;
+
+	t = per_cpu_ptr(event->cgrp->info, event->cpu);
+	return t->time;
+}
+
+inline void
+perf_cgroup_mark_enabled(struct perf_event *event,
+			 struct perf_event_context *ctx)
+{
+	struct perf_event *sub;
+	u64 tstamp = perf_event_time(event);
+
+	if (!event->cgrp_defer_enabled)
+		return;
+
+	event->cgrp_defer_enabled = 0;
+
+	event->tstamp_enabled = tstamp - event->total_time_enabled;
+	list_for_each_entry(sub, &event->sibling_list, group_entry) {
+		if (sub->state >= PERF_EVENT_STATE_INACTIVE) {
+			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
+			sub->cgrp_defer_enabled = 0;
+		}
+	}
+}
+
+static inline void __update_cgrp_time(struct perf_cgroup *cgrp)
+{
+	struct perf_cgroup_info *info;
+	u64 now;
+
+	now = perf_clock();
+
+	info = this_cpu_ptr(cgrp->info);
+
+	info->time += now - info->timestamp;
+	info->timestamp = now;
+}
+
+inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
+{
+	struct perf_cgroup *cgrp_out = cpuctx->cgrp;
+	if (cgrp_out)
+		__update_cgrp_time(cgrp_out);
+}
+
+inline void update_cgrp_time_from_event(struct perf_event *event)
+{
+	struct perf_cgroup *cgrp;
+
+	/*
+	 * ensure we access cgroup data only when needed and
+	 * when we know the cgroup is pinned (css_get)
+	 */
+	if (!is_cgroup_event(event))
+		return;
+
+	cgrp = perf_cgroup_from_task(current);
+	/*
+	 * Do not update time when cgroup is not active
+	 */
+	if (cgrp == event->cgrp)
+		__update_cgrp_time(event->cgrp);
+}
+
+inline void perf_cgroup_set_timestamp(struct task_struct *task,
+				      struct perf_event_context *ctx)
+{
+	struct perf_cgroup *cgrp;
+	struct perf_cgroup_info *info;
+
+	/*
+	 * ctx->lock held by caller
+	 * ensure we do not access cgroup data
+	 * unless we have the cgroup pinned (css_get)
+	 */
+	if (!task || !ctx->nr_cgroups)
+		return;
+
+	cgrp = perf_cgroup_from_task(task);
+	info = this_cpu_ptr(cgrp->info);
+	info->timestamp = ctx->timestamp;
+}
+
+#define PERF_CGROUP_SWOUT	0x1 /* cgroup switch out every event */
+#define PERF_CGROUP_SWIN	0x2 /* cgroup switch in events based on task */
+
+/*
+ * reschedule events based on the cgroup constraint of task.
+ *
+ * mode SWOUT : schedule out everything
+ * mode SWIN : schedule in based on cgroup for next
+ */
+void perf_cgroup_switch(struct task_struct *task, int mode)
+{
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	unsigned long flags;
+
+	/*
+	 * disable interrupts to avoid geting nr_cgroup
+	 * changes via __perf_event_disable(). Also
+	 * avoids preemption.
+	 */
+	local_irq_save(flags);
+
+	/*
+	 * we reschedule only in the presence of cgroup
+	 * constrained events.
+	 */
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		/*
+		 * perf_cgroup_events says at least one
+		 * context on this CPU has cgroup events.
+		 *
+		 * ctx->nr_cgroups reports the number of cgroup
+		 * events for a context.
+		 */
+		if (cpuctx->ctx.nr_cgroups > 0) {
+
+			if (mode & PERF_CGROUP_SWOUT) {
+				cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+				/*
+				 * must not be done before ctxswout due
+				 * to event_filter_match() in event_sched_out()
+				 */
+				cpuctx->cgrp = NULL;
+			}
+
+			if (mode & PERF_CGROUP_SWIN) {
+				WARN_ON_ONCE(cpuctx->cgrp);
+				/* set cgrp before ctxsw in to
+				 * allow event_filter_match() to not
+				 * have to pass task around
+				 */
+				cpuctx->cgrp = perf_cgroup_from_task(task);
+				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
+			}
+		}
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+	}
+
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
+inline void perf_cgroup_sched_out(struct task_struct *task)
+{
+	perf_cgroup_switch(task, PERF_CGROUP_SWOUT);
+}
+
+inline void perf_cgroup_sched_in(struct task_struct *task)
+{
+	perf_cgroup_switch(task, PERF_CGROUP_SWIN);
+}
+
+static int __perf_cgroup_move(void *info)
+{
+	struct task_struct *task = info;
+	perf_cgroup_switch(task, PERF_CGROUP_SWOUT | PERF_CGROUP_SWIN);
+	return 0;
+}
+
+static void perf_cgroup_move(struct task_struct *task)
+{
+	task_function_call(task, __perf_cgroup_move, task);
+}
+
+static void perf_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		struct cgroup *old_cgrp, struct task_struct *task,
+		bool threadgroup)
+{
+	perf_cgroup_move(task);
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
+			perf_cgroup_move(c);
+		}
+		rcu_read_unlock();
+	}
+}
+
+static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		struct cgroup *old_cgrp, struct task_struct *task)
+{
+	/*
+	 * cgroup_exit() is called in the copy_process() failure path.
+	 * Ignore this case since the task hasn't ran yet, this avoids
+	 * trying to poke a half freed task state from generic code.
+	 */
+	if (!(task->flags & PF_EXITING))
+		return;
+
+	perf_cgroup_move(task);
+}
+
+static struct cgroup_subsys_state *perf_cgroup_create(struct cgroup_subsys *ss,
+						      struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+
+	jc = kzalloc(sizeof(*jc), GFP_KERNEL);
+	if (!jc)
+		return ERR_PTR(-ENOMEM);
+
+	jc->info = alloc_percpu(struct perf_cgroup_info);
+	if (!jc->info) {
+		kfree(jc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return &jc->css;
+}
+
+static void perf_cgroup_destroy(struct cgroup_subsys *ss,
+				struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+	jc = container_of(cgroup_subsys_state(cont, perf_subsys_id),
+			  struct perf_cgroup, css);
+	free_percpu(jc->info);
+	kfree(jc);
+}
+
+struct cgroup_subsys perf_subsys = {
+	.name		= "perf_event",
+	.subsys_id	= perf_subsys_id,
+	.create		= perf_cgroup_create,
+	.destroy	= perf_cgroup_destroy,
+	.exit		= perf_cgroup_exit,
+	.attach		= perf_cgroup_attach,
+};
+
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0fc34a3..b65905f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -72,7 +72,7 @@ static void remote_function(void *data)
  *	    -ESRCH  - when the process isn't running
  *	    -EAGAIN - when the process moved away
  */
-static int
+int
 task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
 {
 	struct remote_function_call data = {
@@ -115,12 +115,6 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 		       PERF_FLAG_FD_OUTPUT  |\
 		       PERF_FLAG_PID_CGROUP)
 
-enum event_type_t {
-	EVENT_FLEXIBLE = 0x1,
-	EVENT_PINNED = 0x2,
-	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
-};
-
 /*
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
@@ -132,7 +126,7 @@ static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
 
-static LIST_HEAD(pmus);
+LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;
 
@@ -172,15 +166,7 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
 
 static atomic64_t perf_event_id;
 
-static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
-			      enum event_type_t event_type);
-
-static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type,
-			     struct task_struct *task);
-
 static void update_context_time(struct perf_event_context *ctx);
-static u64 perf_event_time(struct perf_event *event);
 
 void __weak perf_event_print_debug(void)	{ }
 
@@ -189,366 +175,6 @@ extern __weak const char *perf_pmu_name(void)
 	return "pmu";
 }
 
-static inline u64 perf_clock(void)
-{
-	return local_clock();
-}
-
-static inline struct perf_cpu_context *
-__get_cpu_context(struct perf_event_context *ctx)
-{
-	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
-}
-
-#ifdef CONFIG_CGROUP_PERF
-
-/*
- * Must ensure cgroup is pinned (css_get) before calling
- * this function. In other words, we cannot call this function
- * if there is no cgroup event for the current CPU context.
- */
-static inline struct perf_cgroup *
-perf_cgroup_from_task(struct task_struct *task)
-{
-	return container_of(task_subsys_state(task, perf_subsys_id),
-			struct perf_cgroup, css);
-}
-
-static inline bool
-perf_cgroup_match(struct perf_event *event)
-{
-	struct perf_event_context *ctx = event->ctx;
-	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
-
-	return !event->cgrp || event->cgrp == cpuctx->cgrp;
-}
-
-static inline void perf_get_cgroup(struct perf_event *event)
-{
-	css_get(&event->cgrp->css);
-}
-
-static inline void perf_put_cgroup(struct perf_event *event)
-{
-	css_put(&event->cgrp->css);
-}
-
-static inline void perf_detach_cgroup(struct perf_event *event)
-{
-	perf_put_cgroup(event);
-	event->cgrp = NULL;
-}
-
-static inline int is_cgroup_event(struct perf_event *event)
-{
-	return event->cgrp != NULL;
-}
-
-static inline u64 perf_cgroup_event_time(struct perf_event *event)
-{
-	struct perf_cgroup_info *t;
-
-	t = per_cpu_ptr(event->cgrp->info, event->cpu);
-	return t->time;
-}
-
-static inline void __update_cgrp_time(struct perf_cgroup *cgrp)
-{
-	struct perf_cgroup_info *info;
-	u64 now;
-
-	now = perf_clock();
-
-	info = this_cpu_ptr(cgrp->info);
-
-	info->time += now - info->timestamp;
-	info->timestamp = now;
-}
-
-static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
-{
-	struct perf_cgroup *cgrp_out = cpuctx->cgrp;
-	if (cgrp_out)
-		__update_cgrp_time(cgrp_out);
-}
-
-static inline void update_cgrp_time_from_event(struct perf_event *event)
-{
-	struct perf_cgroup *cgrp;
-
-	/*
-	 * ensure we access cgroup data only when needed and
-	 * when we know the cgroup is pinned (css_get)
-	 */
-	if (!is_cgroup_event(event))
-		return;
-
-	cgrp = perf_cgroup_from_task(current);
-	/*
-	 * Do not update time when cgroup is not active
-	 */
-	if (cgrp == event->cgrp)
-		__update_cgrp_time(event->cgrp);
-}
-
-static inline void
-perf_cgroup_set_timestamp(struct task_struct *task,
-			  struct perf_event_context *ctx)
-{
-	struct perf_cgroup *cgrp;
-	struct perf_cgroup_info *info;
-
-	/*
-	 * ctx->lock held by caller
-	 * ensure we do not access cgroup data
-	 * unless we have the cgroup pinned (css_get)
-	 */
-	if (!task || !ctx->nr_cgroups)
-		return;
-
-	cgrp = perf_cgroup_from_task(task);
-	info = this_cpu_ptr(cgrp->info);
-	info->timestamp = ctx->timestamp;
-}
-
-#define PERF_CGROUP_SWOUT	0x1 /* cgroup switch out every event */
-#define PERF_CGROUP_SWIN	0x2 /* cgroup switch in events based on task */
-
-/*
- * reschedule events based on the cgroup constraint of task.
- *
- * mode SWOUT : schedule out everything
- * mode SWIN : schedule in based on cgroup for next
- */
-void perf_cgroup_switch(struct task_struct *task, int mode)
-{
-	struct perf_cpu_context *cpuctx;
-	struct pmu *pmu;
-	unsigned long flags;
-
-	/*
-	 * disable interrupts to avoid geting nr_cgroup
-	 * changes via __perf_event_disable(). Also
-	 * avoids preemption.
-	 */
-	local_irq_save(flags);
-
-	/*
-	 * we reschedule only in the presence of cgroup
-	 * constrained events.
-	 */
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(pmu, &pmus, entry) {
-
-		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-
-		perf_pmu_disable(cpuctx->ctx.pmu);
-
-		/*
-		 * perf_cgroup_events says at least one
-		 * context on this CPU has cgroup events.
-		 *
-		 * ctx->nr_cgroups reports the number of cgroup
-		 * events for a context.
-		 */
-		if (cpuctx->ctx.nr_cgroups > 0) {
-
-			if (mode & PERF_CGROUP_SWOUT) {
-				cpu_ctx_sched_out(cpuctx, EVENT_ALL);
-				/*
-				 * must not be done before ctxswout due
-				 * to event_filter_match() in event_sched_out()
-				 */
-				cpuctx->cgrp = NULL;
-			}
-
-			if (mode & PERF_CGROUP_SWIN) {
-				WARN_ON_ONCE(cpuctx->cgrp);
-				/* set cgrp before ctxsw in to
-				 * allow event_filter_match() to not
-				 * have to pass task around
-				 */
-				cpuctx->cgrp = perf_cgroup_from_task(task);
-				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
-			}
-		}
-
-		perf_pmu_enable(cpuctx->ctx.pmu);
-	}
-
-	rcu_read_unlock();
-
-	local_irq_restore(flags);
-}
-
-static inline void perf_cgroup_sched_out(struct task_struct *task)
-{
-	perf_cgroup_switch(task, PERF_CGROUP_SWOUT);
-}
-
-static inline void perf_cgroup_sched_in(struct task_struct *task)
-{
-	perf_cgroup_switch(task, PERF_CGROUP_SWIN);
-}
-
-static inline int perf_cgroup_connect(int fd, struct perf_event *event,
-				      struct perf_event_attr *attr,
-				      struct perf_event *group_leader)
-{
-	struct perf_cgroup *cgrp;
-	struct cgroup_subsys_state *css;
-	struct file *file;
-	int ret = 0, fput_needed;
-
-	file = fget_light(fd, &fput_needed);
-	if (!file)
-		return -EBADF;
-
-	css = cgroup_css_from_dir(file, perf_subsys_id);
-	if (IS_ERR(css)) {
-		ret = PTR_ERR(css);
-		goto out;
-	}
-
-	cgrp = container_of(css, struct perf_cgroup, css);
-	event->cgrp = cgrp;
-
-	/* must be done before we fput() the file */
-	perf_get_cgroup(event);
-
-	/*
-	 * all events in a group must monitor
-	 * the same cgroup because a task belongs
-	 * to only one perf cgroup at a time
-	 */
-	if (group_leader && group_leader->cgrp != cgrp) {
-		perf_detach_cgroup(event);
-		ret = -EINVAL;
-	}
-out:
-	fput_light(file, fput_needed);
-	return ret;
-}
-
-static inline void
-perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
-{
-	struct perf_cgroup_info *t;
-	t = per_cpu_ptr(event->cgrp->info, event->cpu);
-	event->shadow_ctx_time = now - t->timestamp;
-}
-
-static inline void
-perf_cgroup_defer_enabled(struct perf_event *event)
-{
-	/*
-	 * when the current task's perf cgroup does not match
-	 * the event's, we need to remember to call the
-	 * perf_mark_enable() function the first time a task with
-	 * a matching perf cgroup is scheduled in.
-	 */
-	if (is_cgroup_event(event) && !perf_cgroup_match(event))
-		event->cgrp_defer_enabled = 1;
-}
-
-static inline void
-perf_cgroup_mark_enabled(struct perf_event *event,
-			 struct perf_event_context *ctx)
-{
-	struct perf_event *sub;
-	u64 tstamp = perf_event_time(event);
-
-	if (!event->cgrp_defer_enabled)
-		return;
-
-	event->cgrp_defer_enabled = 0;
-
-	event->tstamp_enabled = tstamp - event->total_time_enabled;
-	list_for_each_entry(sub, &event->sibling_list, group_entry) {
-		if (sub->state >= PERF_EVENT_STATE_INACTIVE) {
-			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
-			sub->cgrp_defer_enabled = 0;
-		}
-	}
-}
-#else /* !CONFIG_CGROUP_PERF */
-
-static inline bool
-perf_cgroup_match(struct perf_event *event)
-{
-	return true;
-}
-
-static inline void perf_detach_cgroup(struct perf_event *event)
-{}
-
-static inline int is_cgroup_event(struct perf_event *event)
-{
-	return 0;
-}
-
-static inline u64 perf_cgroup_event_cgrp_time(struct perf_event *event)
-{
-	return 0;
-}
-
-static inline void update_cgrp_time_from_event(struct perf_event *event)
-{
-}
-
-static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
-{
-}
-
-static inline void perf_cgroup_sched_out(struct task_struct *task)
-{
-}
-
-static inline void perf_cgroup_sched_in(struct task_struct *task)
-{
-}
-
-static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
-				      struct perf_event_attr *attr,
-				      struct perf_event *group_leader)
-{
-	return -EINVAL;
-}
-
-static inline void
-perf_cgroup_set_timestamp(struct task_struct *task,
-			  struct perf_event_context *ctx)
-{
-}
-
-void
-perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
-{
-}
-
-static inline void
-perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
-{
-}
-
-static inline u64 perf_cgroup_event_time(struct perf_event *event)
-{
-	return 0;
-}
-
-static inline void
-perf_cgroup_defer_enabled(struct perf_event *event)
-{
-}
-
-static inline void
-perf_cgroup_mark_enabled(struct perf_event *event,
-			 struct perf_event_context *ctx)
-{
-}
-#endif
-
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -727,7 +353,7 @@ static void update_context_time(struct perf_event_context *ctx)
 	ctx->timestamp = now;
 }
 
-static u64 perf_event_time(struct perf_event *event)
+u64 perf_event_time(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 
@@ -1641,8 +1267,7 @@ static int __perf_event_enable(void *info)
 	__perf_event_mark_enabled(event, ctx);
 
 	if (!event_filter_match(event)) {
-		if (is_cgroup_event(event))
-			perf_cgroup_defer_enabled(event);
+		perf_cgroup_defer_enabled(event);
 		goto unlock;
 	}
 
@@ -1761,9 +1386,9 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	return 0;
 }
 
-static void ctx_sched_out(struct perf_event_context *ctx,
-			  struct perf_cpu_context *cpuctx,
-			  enum event_type_t event_type)
+void ctx_sched_out(struct perf_event_context *ctx,
+		   struct perf_cpu_context *cpuctx,
+		   enum event_type_t event_type)
 {
 	struct perf_event *event;
 
@@ -1988,15 +1613,6 @@ static void task_ctx_sched_out(struct perf_event_context *ctx,
 	cpuctx->task_ctx = NULL;
 }
 
-/*
- * Called with IRQs disabled
- */
-static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
-			      enum event_type_t event_type)
-{
-	ctx_sched_out(&cpuctx->ctx, cpuctx, event_type);
-}
-
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
 		    struct perf_cpu_context *cpuctx)
@@ -2056,11 +1672,10 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 	}
 }
 
-static void
-ctx_sched_in(struct perf_event_context *ctx,
-	     struct perf_cpu_context *cpuctx,
-	     enum event_type_t event_type,
-	     struct task_struct *task)
+void ctx_sched_in(struct perf_event_context *ctx,
+		  struct perf_cpu_context *cpuctx,
+		  enum event_type_t event_type,
+		  struct task_struct *task)
 {
 	u64 now;
 
@@ -2087,15 +1702,6 @@ out:
 	raw_spin_unlock(&ctx->lock);
 }
 
-static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type,
-			     struct task_struct *task)
-{
-	struct perf_event_context *ctx = &cpuctx->ctx;
-
-	ctx_sched_in(ctx, cpuctx, event_type, task);
-}
-
 static void task_ctx_sched_in(struct perf_event_context *ctx,
 			      enum event_type_t event_type)
 {
@@ -7373,83 +6979,3 @@ unlock:
 	return ret;
 }
 device_initcall(perf_event_sysfs_init);
-
-#ifdef CONFIG_CGROUP_PERF
-static struct cgroup_subsys_state *perf_cgroup_create(
-	struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	struct perf_cgroup *jc;
-
-	jc = kzalloc(sizeof(*jc), GFP_KERNEL);
-	if (!jc)
-		return ERR_PTR(-ENOMEM);
-
-	jc->info = alloc_percpu(struct perf_cgroup_info);
-	if (!jc->info) {
-		kfree(jc);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	return &jc->css;
-}
-
-static void perf_cgroup_destroy(struct cgroup_subsys *ss,
-				struct cgroup *cont)
-{
-	struct perf_cgroup *jc;
-	jc = container_of(cgroup_subsys_state(cont, perf_subsys_id),
-			  struct perf_cgroup, css);
-	free_percpu(jc->info);
-	kfree(jc);
-}
-
-static int __perf_cgroup_move(void *info)
-{
-	struct task_struct *task = info;
-	perf_cgroup_switch(task, PERF_CGROUP_SWOUT | PERF_CGROUP_SWIN);
-	return 0;
-}
-
-static void perf_cgroup_move(struct task_struct *task)
-{
-	task_function_call(task, __perf_cgroup_move, task);
-}
-
-static void perf_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		struct cgroup *old_cgrp, struct task_struct *task,
-		bool threadgroup)
-{
-	perf_cgroup_move(task);
-	if (threadgroup) {
-		struct task_struct *c;
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			perf_cgroup_move(c);
-		}
-		rcu_read_unlock();
-	}
-}
-
-static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		struct cgroup *old_cgrp, struct task_struct *task)
-{
-	/*
-	 * cgroup_exit() is called in the copy_process() failure path.
-	 * Ignore this case since the task hasn't ran yet, this avoids
-	 * trying to poke a half freed task state from generic code.
-	 */
-	if (!(task->flags & PF_EXITING))
-		return;
-
-	perf_cgroup_move(task);
-}
-
-struct cgroup_subsys perf_subsys = {
-	.name		= "perf_event",
-	.subsys_id	= perf_subsys_id,
-	.create		= perf_cgroup_create,
-	.destroy	= perf_cgroup_destroy,
-	.exit		= perf_cgroup_exit,
-	.attach		= perf_cgroup_attach,
-};
-#endif /* CONFIG_CGROUP_PERF */
-- 
1.7.4.rc2

