Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab0JFJLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:11:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:43152 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0JFJLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=IgkNBC4LZkk1KqJKkJ7My0PhwlBJv26sfJ7OC9qJQhBSGJwXOuTjoPd3QBDrMRCfEA
         y587+9aKI6Uw1FOD1ZCA==
Message-ID: <4cac3d2e.21edd80a.7008.1831@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 6 Oct 2010 11:08:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup monitoring (v4)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel patch adds the ability to filter monitoring based on
container groups (cgroups). This is for use in per-cpu mode only.
    
The cgroup to monitor is passed as a file descriptor in the pid
argument to the syscall. The file descriptor must be opened to 
the cgroup name in the cgroup filesystem. For instance, if the
cgroup name is foo and cgroupfs is mounted in /cgroup, then the
file descriptor is opened to /cgroup/foo. Cgroup mode is
activated by passing PERF_FLAG_PID_CGROUP into the flags argument
to the syscall.
    
Signed-off-by: Stephane Eranian <eranian@google.com>

---

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 709dfb9..67cf276 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -623,6 +623,8 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
 
+struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ccefff0..93f86b7 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -65,4 +65,8 @@ SUBSYS(net_cls)
 SUBSYS(blkio)
 #endif
 
+#ifdef CONFIG_PERF_EVENTS
+SUBSYS(perf)
+#endif
+
 /* */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 61b1e2d..ad79f0a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -454,6 +454,7 @@ enum perf_callchain_context {
 
 #define PERF_FLAG_FD_NO_GROUP	(1U << 0)
 #define PERF_FLAG_FD_OUTPUT	(1U << 1)
+#define PERF_FLAG_PID_CGROUP	(1U << 2) /* pid=cgroup id, per-cpu mode */
 
 #ifdef __KERNEL__
 /*
@@ -461,6 +462,7 @@ enum perf_callchain_context {
  */
 
 #ifdef CONFIG_PERF_EVENTS
+# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -698,6 +700,18 @@ struct swevent_hlist {
 #define PERF_ATTACH_CONTEXT	0x01
 #define PERF_ATTACH_GROUP	0x02
 
+#ifdef CONFIG_CGROUPS
+struct perf_cgroup_time {
+	u64 time;
+	u64 timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state css;
+	struct perf_cgroup_time *time;
+};
+#endif
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -801,6 +815,10 @@ struct perf_event {
 	struct event_filter		*filter;
 #endif
 
+#ifdef CONFIG_CGROUPS
+	struct perf_cgroup		*css;
+#endif
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -854,6 +872,8 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	struct rcu_head			rcu_head;
+
+	int				nr_cgroups;
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 291ba3d..2de239a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4723,6 +4723,28 @@ css_get_next(struct cgroup_subsys *ss, int id,
 	return ret;
 }
 
+/*
+ * get corresponding css from file open on cgroupfs directory
+ */
+struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
+{
+	struct cgroup *cgrp;
+	struct inode *inode;
+
+	inode = f->f_dentry->d_inode;
+	/* check in cgroup filesystem dir */
+	if (inode->i_op != &cgroup_dir_inode_operations)
+		return ERR_PTR(-EBADF);
+
+	if (id < 0 || id >= CGROUP_SUBSYS_COUNT)
+		return ERR_PTR(-EINVAL);
+
+	/* get cgroup */
+	cgrp = __d_cgrp(f->f_dentry);
+
+	return cgrp->subsys[id];
+}
+
 #ifdef CONFIG_CGROUP_DEBUG
 static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
 						   struct cgroup *cont)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 64507ea..9c37f94 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -34,6 +34,8 @@
 
 #include <asm/irq_regs.h>
 
+#define PERF_TSTAMP_ENABLE_INVALID (~0) /* invalid marker, cannot be zero */
+
 static atomic_t nr_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -63,6 +65,232 @@ static atomic64_t perf_event_id;
 
 void __weak perf_event_print_debug(void)	{ }
 
+static DEFINE_PER_CPU(struct list_head, rotation_list);
+
+enum event_type_t {
+	EVENT_FLEXIBLE = 0x1,
+	EVENT_PINNED = 0x2,
+	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
+};
+
+#define PERF_FLAG_ALL	(PERF_FLAG_FD_NO_GROUP |\
+			 PERF_FLAG_FD_OUTPUT  |\
+			 PERF_FLAG_PID_CGROUP)
+
+static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type);
+
+static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type,
+			     struct task_struct *task, int css_sw);
+static inline u64 perf_clock(void)
+{
+	return local_clock();
+}
+
+#ifdef CONFIG_CGROUPS
+static inline struct perf_cgroup *
+perf_cgroup_from_task(struct task_struct *task)
+{
+	if (!task)
+		return NULL;
+	return container_of(task_subsys_state(task, perf_subsys_id),
+			struct perf_cgroup, css);
+}
+
+static inline
+struct perf_cgroup *perf_cgroup_from_cont(struct cgroup *cont)
+{
+	return container_of(cgroup_subsys_state(cont, perf_subsys_id),
+			struct perf_cgroup, css);
+}
+
+static inline bool
+perf_cgroup_match(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_cgroup *css = perf_cgroup_from_task(task);
+	return !event->css || event->css == css;
+}
+
+static void *perf_get_cgroup(int fd)
+{
+	struct cgroup_subsys_state *css;
+	struct file *file;
+	int fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	css = cgroup_css_from_dir(file, perf_subsys_id);
+	if (!IS_ERR(css))
+		css_get(css);
+
+	fput_light(file, fput_needed);
+
+	return css;
+}
+
+static inline void perf_put_cgroup(struct perf_event *event)
+{
+	if (event->css)
+		css_put(&event->css->css);
+}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return event->css != NULL;
+}
+
+static inline int is_css_current(struct perf_event *event)
+{
+	struct perf_cgroup *css = perf_cgroup_from_task(current);
+
+	return css == event->css;
+}
+
+static inline u64 __perf_event_css_time(struct perf_event *event)
+{
+	struct perf_cgroup_time *t;
+	t = per_cpu_ptr(event->css->time, event->cpu);
+	return t->time;
+}
+
+static inline void __update_css_time(struct perf_cgroup *css)
+{
+	u64 now;
+	struct perf_cgroup_time *t;
+	int cpu = smp_processor_id();
+
+	if (!css)
+		return;
+
+	now = perf_clock();
+
+	t = per_cpu_ptr(css->time, cpu);
+
+	t->time += now - t->timestamp;
+	t->timestamp = now;
+}
+
+static inline void update_task_css_time(struct task_struct *task)
+{
+	struct perf_cgroup *css_out = perf_cgroup_from_task(task);
+	__update_css_time(css_out);
+}
+
+static inline void update_event_css_time(struct perf_event *event)
+{
+	if (!is_css_current(event))
+		return;
+	__update_css_time(event->css);
+}
+
+static inline void perf_cgroup_switch(struct task_struct *task,
+				      struct task_struct *next)
+{
+	struct perf_cgroup *css_out = perf_cgroup_from_task(task);
+	struct perf_cgroup *css_in = perf_cgroup_from_task(next);
+	struct perf_cgroup_time *t;
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+
+	if (css_out == css_in)
+		return;
+
+	update_task_css_time(task);
+	t = per_cpu_ptr(css_in->time, smp_processor_id());
+	t->timestamp = perf_clock();
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->ctx.nr_cgroups > 0) {
+			cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+			cpu_ctx_sched_in(cpuctx, EVENT_ALL, next, 1);
+		}
+	}
+	rcu_read_unlock();
+}
+
+static inline int perf_connect_cgroup(pid_t pid, struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
+{
+	struct perf_cgroup *css;
+
+	/* pid contains cgroup fd */
+	css = perf_get_cgroup(pid);
+	if (IS_ERR(css))
+		return PTR_ERR(css);
+	/*
+	 * all events in a group must monitor
+	 * the same cgroup because a thread belongs
+	 * to only one cgroup at a time
+	 */
+	if (group_leader && group_leader->css != css) {
+		event->css = css;
+		perf_put_cgroup(event);
+		return -EINVAL;
+	}
+	event->css = css;
+
+	return 0;
+}
+
+#else /* !CONFIG_CGROUP */
+
+static inline bool
+perf_cgroup_match(struct perf_event *event, struct task_struct *task)
+{
+	return true;
+}
+
+static inline void *perf_get_cgroup(int fd)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline void perf_put_cgroup(struct perf_event *event)
+{}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline int is_css_current(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline u64 __perf_event_css_time(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline void update_css_time(void *css)
+{}
+
+static inline void update_event_css_time(struct perf_event *event)
+{}
+
+static inline void update_task_css_time(struct task_struct *t)
+{}
+static inline void perf_cgroup_switch(struct perf_cpu_context *cpuctx,
+				      struct task_struct *task,
+				      struct task_struct *next)
+{}
+
+static inline int perf_connect_cgroup(struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *gorup_leader)
+{
+	return -EINVAL;
+}
+
+#endif
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -77,8 +305,6 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
-static DEFINE_PER_CPU(struct list_head, rotation_list);
-
 /*
  * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
  * because they're strictly cpu affine and rotate_start is called with IRQs
@@ -209,11 +435,6 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 	put_ctx(ctx);
 }
 
-static inline u64 perf_clock(void)
-{
-	return local_clock();
-}
-
 /*
  * Update the record of the current time in a context.
  */
@@ -225,29 +446,45 @@ static void update_context_time(struct perf_event_context *ctx)
 	ctx->timestamp = now;
 }
 
+static u64 perf_event_time(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+
+	if (is_cgroup_event(event)) {
+		if (event->cpu == -1) {
+			WARN_ON(event->cpu != smp_processor_id());
+			return 0;
+		}
+		return __perf_event_css_time(event);
+	}
+
+	return ctx ? ctx->time : 0;
+}
+
 /*
  * Update the total_time_enabled and total_time_running fields for a event.
  */
 static void update_event_times(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
-	u64 run_end;
+	u64 run_end, run_start;
 
 	if (event->state < PERF_EVENT_STATE_INACTIVE ||
 	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
 		return;
 
-	if (ctx->is_active)
-		run_end = ctx->time;
-	else
-		run_end = event->tstamp_stopped;
+	run_end = perf_event_time(event);
+	run_start = event->tstamp_enabled;
+	/*
+	 * that means the cgroup never got scheduled in
+	 * so ensure total_time_enabled is zero
+	 */
+	if (run_start == PERF_TSTAMP_ENABLE_INVALID)
+		run_start = run_end;
 
-	event->total_time_enabled = run_end - event->tstamp_enabled;
+	event->total_time_enabled = run_end - run_start;
 
 	if (event->state == PERF_EVENT_STATE_INACTIVE)
 		run_end = event->tstamp_stopped;
-	else
-		run_end = ctx->time;
 
 	event->total_time_running = run_end - event->tstamp_running;
 }
@@ -298,6 +535,9 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		list_add_tail(&event->group_entry, list);
 	}
 
+	if (is_cgroup_event(event))
+		ctx->nr_cgroups++;
+
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
 		perf_pmu_rotate_start(ctx->pmu);
@@ -339,6 +579,9 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
+	if (is_cgroup_event(event))
+		ctx->nr_cgroups--;
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -402,9 +645,10 @@ static void perf_group_detach(struct perf_event *event)
 }
 
 static inline int
-event_filter_match(struct perf_event *event)
+event_filter_match(struct perf_event *event, struct task_struct *task)
 {
-	return event->cpu == -1 || event->cpu == smp_processor_id();
+	return (event->cpu == -1 || event->cpu == smp_processor_id())
+	    && perf_cgroup_match(event, task);
 }
 
 static void
@@ -412,6 +656,7 @@ event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
 	u64 delta;
 	/*
 	 * An event which could not be activated because of
@@ -420,10 +665,10 @@ event_sched_out(struct perf_event *event,
 	 * via read() for time_enabled, time_running:
 	 */
 	if (event->state == PERF_EVENT_STATE_INACTIVE
-	    && !event_filter_match(event)) {
-		delta = ctx->time - event->tstamp_stopped;
+	    && !event_filter_match(event, current)) {
+		delta = tstamp - event->tstamp_stopped;
 		event->tstamp_running += delta;
-		event->tstamp_stopped = ctx->time;
+		event->tstamp_stopped = tstamp;
 	}
 
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
@@ -434,7 +679,7 @@ event_sched_out(struct perf_event *event,
 		event->pending_disable = 0;
 		event->state = PERF_EVENT_STATE_OFF;
 	}
-	event->tstamp_stopped = ctx->time;
+	event->tstamp_stopped = tstamp;
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
@@ -578,6 +823,11 @@ static void __perf_event_disable(void *info)
 	 * If it is in error state, leave it in error state.
 	 */
 	if (event->state >= PERF_EVENT_STATE_INACTIVE) {
+		/*
+		 * update css time only if current->css corresponds
+		 * to event. This is used to update tstamp->stopped
+		 */
+		update_event_css_time(event);
 		update_context_time(ctx);
 		update_group_times(event);
 		if (event == event->group_leader)
@@ -646,6 +896,8 @@ event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
 		 struct perf_event_context *ctx)
 {
+	u64 tstamp;
+
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
@@ -661,8 +913,8 @@ event_sched_in(struct perf_event *event,
 		event->oncpu = -1;
 		return -EAGAIN;
 	}
-
-	event->tstamp_running += ctx->time - event->tstamp_stopped;
+	tstamp = perf_event_time(event);
+	event->tstamp_running += tstamp - event->tstamp_stopped;
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
@@ -756,11 +1008,32 @@ static int group_can_go_on(struct perf_event *event,
 static void add_event_to_ctx(struct perf_event *event,
 			       struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
+
 	list_add_event(event, ctx);
 	perf_group_attach(event);
-	event->tstamp_enabled = ctx->time;
-	event->tstamp_running = ctx->time;
-	event->tstamp_stopped = ctx->time;
+
+	event->tstamp_running = tstamp;
+	event->tstamp_stopped = tstamp;
+	event->tstamp_enabled = tstamp;
+	/*
+	 * an event is added to a context even if the css constraint
+	 * is not satisfied.  In per-cgroup mode, time_enabled only
+	 * counts when threads from the css are active on the CPU.
+	 *
+	 * tstamp_enabled denotes the first time the event CAN be
+	 * enabled, i.e., the first time threads from the css are
+	 * scheduled in. Note that the event may not be scheduled
+	 * immediately if the PMU is overcommitted yet the timestamp
+	 * points to the first css activation.
+	 *
+	 * If css is not currently active, then we mark
+	 * tstamp_enabled = ~0 to remember that it needs to be
+	 * corrected in ctx_flexible_sched_in() and
+	 * ctx_pinned_sched_in()
+	 */
+	if (is_cgroup_event(event) && !is_css_current(event))
+		event->tstamp_enabled = PERF_TSTAMP_ENABLE_INVALID;
 }
 
 /*
@@ -792,10 +1065,16 @@ static void __perf_install_in_context(void *info)
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
+	/*
+	 * in cgroup mode, we know the event matches
+	 * the current cgroup, so update the cgroup's
+	 * time so we timestamp correctly.
+	 */
+	update_event_css_time(event);
 
 	add_event_to_ctx(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -900,14 +1179,13 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 					struct perf_event_context *ctx)
 {
 	struct perf_event *sub;
+	u64 tstamp = perf_event_time(event);
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
-	event->tstamp_enabled = ctx->time - event->total_time_enabled;
+	event->tstamp_enabled = tstamp - event->total_time_enabled;
 	list_for_each_entry(sub, &event->sibling_list, group_entry) {
-		if (sub->state >= PERF_EVENT_STATE_INACTIVE) {
-			sub->tstamp_enabled =
-				ctx->time - sub->total_time_enabled;
-		}
+		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
+			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
 	}
 }
 
@@ -938,9 +1216,17 @@ static void __perf_event_enable(void *info)
 
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		goto unlock;
+
+	/*
+	 * in cgroup mode, we know the event matches
+	 * the current cgroup, so update the cgroup's
+	 * time so we timestamp correctly.
+	 */
+	update_event_css_time(event);
+
 	__perf_event_mark_enabled(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -1051,12 +1337,6 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	return 0;
 }
 
-enum event_type_t {
-	EVENT_FLEXIBLE = 0x1,
-	EVENT_PINNED = 0x2,
-	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
-};
-
 static void ctx_sched_out(struct perf_event_context *ctx,
 			  struct perf_cpu_context *cpuctx,
 			  enum event_type_t event_type)
@@ -1069,6 +1349,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		goto out;
 	update_context_time(ctx);
+	update_task_css_time(current);
 
 	if (!ctx->nr_active)
 		goto out;
@@ -1258,6 +1539,13 @@ void perf_event_task_sched_out(struct task_struct *task,
 
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
+	/*
+	 * switching cgroups
+	 * must update time in outgoing cgroup
+	 * mark new start time in coming in cgroup
+	 */
+	perf_cgroup_switch(task, next);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 }
@@ -1296,16 +1584,40 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
-		    struct perf_cpu_context *cpuctx)
+		    struct perf_cpu_context *cpuctx,
+		    struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
+
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event)) {
+			u64 tstamp = perf_event_time(event);
+			/*
+			 * if css was not active when the event was
+			 * added to ctx, then this is the first time
+			 * the event can be effectively scheduled, thus
+			 * we update tstamp_enabled
+			 */
+			if (event->tstamp_enabled == PERF_TSTAMP_ENABLE_INVALID)
+				event->tstamp_enabled = tstamp;
+			/*
+			 * if we come here because of a context switch
+			 * with cgroup switch, then we need to update
+			 * the point in time at which all cgroup events
+			 * have been stopped. Oterwise, we would compute
+			 * bogus tstamp_running deltas, which would include
+			 * time the cgorup is not active.
+			 */
+			if (css_sw)
+				event->tstamp_stopped = tstamp;
+		}
+
 		if (group_can_go_on(event, cpuctx, 1))
 			group_sched_in(event, cpuctx, ctx);
 
@@ -1322,7 +1634,8 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx)
+		      struct perf_cpu_context *cpuctx,
+		      struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1335,9 +1648,31 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event)) {
+			u64 tstamp = perf_event_time(event);
+			/*
+			 * if css was not active when the event was
+			 * added to ctx, then this is the first time
+			 * the event can be effectively scheduled, thus
+			 * we update tstamp_enabled
+			 */
+			if (event->tstamp_enabled == PERF_TSTAMP_ENABLE_INVALID)
+				event->tstamp_enabled = tstamp;
+			/*
+			 * if we come here because of a context switch
+			 * with cgroup switch, then we need to update
+			 * the point in time at which all cgroup events
+			 * have been stopped. Oterwise, we would compute
+			 * bogus tstamp_running deltas, which would include
+			 * time the cgorup is not active.
+			 */
+			if (css_sw)
+				event->tstamp_stopped = tstamp;
+		}
+
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
@@ -1348,7 +1683,8 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 static void
 ctx_sched_in(struct perf_event_context *ctx,
 	     struct perf_cpu_context *cpuctx,
-	     enum event_type_t event_type)
+	     enum event_type_t event_type,
+	     struct task_struct *task, int css_sw)
 {
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
@@ -1362,22 +1698,23 @@ ctx_sched_in(struct perf_event_context *ctx,
 	 * in order to give them the best chance of going on.
 	 */
 	if (event_type & EVENT_PINNED)
-		ctx_pinned_sched_in(ctx, cpuctx);
+		ctx_pinned_sched_in(ctx, cpuctx, task, css_sw);
 
 	/* Then walk through the lower prio flexible groups */
 	if (event_type & EVENT_FLEXIBLE)
-		ctx_flexible_sched_in(ctx, cpuctx);
+		ctx_flexible_sched_in(ctx, cpuctx, task, css_sw);
 
 out:
 	raw_spin_unlock(&ctx->lock);
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type)
+			     enum event_type_t event_type,
+			     struct task_struct *task, int css_sw)
 {
 	struct perf_event_context *ctx = &cpuctx->ctx;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, task, css_sw);
 }
 
 static void task_ctx_sched_in(struct perf_event_context *ctx,
@@ -1389,11 +1726,12 @@ static void task_ctx_sched_in(struct perf_event_context *ctx,
 	if (cpuctx->task_ctx == ctx)
 		return;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, ctx->task, 0);
 	cpuctx->task_ctx = ctx;
 }
 
-void perf_event_context_sched_in(struct perf_event_context *ctx)
+void perf_event_context_sched_in(struct perf_event_context *ctx,
+				 struct task_struct *task)
 {
 	struct perf_cpu_context *cpuctx;
 
@@ -1409,9 +1747,9 @@ void perf_event_context_sched_in(struct perf_event_context *ctx)
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task, 0);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task, 0);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task, 0);
 
 	cpuctx->task_ctx = ctx;
 
@@ -1444,7 +1782,7 @@ void perf_event_task_sched_in(struct task_struct *task)
 		if (likely(!ctx))
 			continue;
 
-		perf_event_context_sched_in(ctx);
+		perf_event_context_sched_in(ctx, task);
 	}
 }
 
@@ -1562,7 +1900,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event, current))
 			continue;
 
 		hwc = &event->hw;
@@ -1645,7 +1983,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current, 0);
 	if (ctx)
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
@@ -1724,7 +2062,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_context_sched_in(ctx);
+	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
 }
@@ -1749,6 +2087,7 @@ static void __perf_event_read(void *info)
 		return;
 
 	raw_spin_lock(&ctx->lock);
+	update_event_css_time(event);
 	update_context_time(ctx);
 	update_event_times(event);
 	raw_spin_unlock(&ctx->lock);
@@ -2169,6 +2508,9 @@ static void free_event(struct perf_event *event)
 		event->buffer = NULL;
 	}
 
+	if (is_cgroup_event(event))
+		perf_put_cgroup(event);
+
 	if (event->destroy)
 		event->destroy(event);
 
@@ -3806,7 +4148,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -3931,7 +4273,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm)
@@ -4069,7 +4411,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
@@ -5082,6 +5424,7 @@ static void task_clock_event_read(struct perf_event *event)
 	u64 time;
 
 	if (!in_nmi()) {
+		update_event_css_time(event);
 		update_context_time(event->ctx);
 		time = event->ctx->time;
 	} else {
@@ -5285,7 +5628,8 @@ unlock:
  * Allocate and initialize a event structure
  */
 static struct perf_event *
-perf_event_alloc(struct perf_event_attr *attr, int cpu,
+perf_event_alloc(struct perf_event_attr *attr, int cpu, pid_t pid,
+		   unsigned long flags,
 		   struct perf_event *group_leader,
 		   struct perf_event *parent_event,
 		   perf_overflow_handler_t overflow_handler)
@@ -5299,6 +5643,14 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
+	if (flags & PERF_FLAG_PID_CGROUP) {
+		err = perf_connect_cgroup(pid, event, attr, group_leader);
+		if (err) {
+			kfree(event);
+			return ERR_PTR(err);
+		}
+	}
+
 	/*
 	 * Single events are their own group leaders, with an
 	 * empty sibling list:
@@ -5365,6 +5717,7 @@ done:
 	if (err) {
 		if (event->ns)
 			put_pid_ns(event->ns);
+		perf_put_cgroup(event);
 		kfree(event);
 		return ERR_PTR(err);
 	}
@@ -5547,7 +5900,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int err;
 
 	/* for future expandability... */
-	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
+	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
 	err = perf_copy_attr(attr_uptr, &attr);
@@ -5564,6 +5917,10 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	/* cgroup must provide pid (cgroup fd) and cpu */
+	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
+		return -EINVAL;
+
 	event_fd = get_unused_fd_flags(O_RDWR);
 	if (event_fd < 0)
 		return event_fd;
@@ -5581,7 +5938,8 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
-	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
+	event = perf_event_alloc(&attr, cpu, pid, flags, group_leader,
+				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_fd;
@@ -5615,6 +5973,8 @@ SYSCALL_DEFINE5(perf_event_open,
 			move_group = 1;
 		}
 	}
+	if (flags & PERF_FLAG_PID_CGROUP)
+		pid = -1;
 
 	if (pid != -1) {
 		task = find_lively_task_by_vpid(pid);
@@ -5754,7 +6114,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, NULL, NULL, overflow_handler);
+	event = perf_event_alloc(attr, cpu, -1, 0, NULL, NULL,
+				 overflow_handler);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -6021,7 +6382,7 @@ inherit_event(struct perf_event *parent_event,
 		parent_event = parent_event->parent;
 
 	child_event = perf_event_alloc(&parent_event->attr,
-					   parent_event->cpu,
+					   parent_event->cpu, -1, 0,
 					   group_leader, parent_event,
 					   NULL);
 	if (IS_ERR(child_event))
@@ -6356,3 +6717,49 @@ void __init perf_event_init(void)
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 }
+
+#ifdef CONFIG_CGROUPS
+static struct cgroup_subsys_state *perf_cgroup_create(
+	struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+	struct perf_cgroup_time *t;
+	int c;
+
+	jc = vmalloc(sizeof(*jc));
+	if (!jc)
+		return ERR_PTR(-ENOMEM);
+
+	memset(jc, 0, sizeof(*jc));
+
+	jc->time = alloc_percpu(struct perf_cgroup_time);
+	if (!jc->time) {
+		vfree(jc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for_each_possible_cpu(c) {
+		t = per_cpu_ptr(jc->time, c);
+		t->time = 0;
+		t->timestamp = 0;
+	}
+	return &jc->css;
+}
+
+static void perf_cgroup_destroy(struct cgroup_subsys *ss,
+				struct cgroup *cont)
+{
+	struct perf_cgroup *jc = perf_cgroup_from_cont(cont);
+
+	free_percpu(jc->time);
+	vfree(jc);
+}
+
+struct cgroup_subsys perf_subsys = {
+	.name = "perf_event",
+	.subsys_id = perf_subsys_id,
+	.create = perf_cgroup_create,
+	.destroy = perf_cgroup_destroy,
+	.early_init = 0,
+};
+#endif /* CONFIG_CGROUP */
