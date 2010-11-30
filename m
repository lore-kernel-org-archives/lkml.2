Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0K3SWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:22:18 -0500
Received: from smtp-out.google.com ([74.125.121.35]:7021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab0K3SWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:22:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=wMtpnxQbXM501LjFhVZwNJt2wAtpU/hh4c+waPpaK+xcT7Rq/ZNlaFpTOP8Nku6AYN
         Dcu9w8OsZDNQH7+6cqBw==
Message-ID: <4cf540d1.5d1be30a.7c7b.577d@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 30 Nov 2010 19:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 4/5] perf_events: add cgroup support (v6)
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
activated by passing PERF_FLAG_PID_CGROUP in the flags argument
to the syscall.

For instance to measure in cgroup foo on CPU1 assuming
cgroupfs is mounted under /cgroup:

struct perf_event_attr attr;
int cgroup_fd, fd;

cgroup_fd = open("/cgroup/foo", O_RDONLY);
fd = perf_event_open(&attr, cgroup_fd, 1, -1, PERF_FLAG_PID_CGROUP);
close(cgroup_fd);

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ed4ba11..5449b61 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -626,6 +626,7 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 /* Get id and depth of css */
 unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
+struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 
 #else /* !CONFIG_CGROUPS */
 
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ccefff0..c93ea28 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -65,4 +65,8 @@ SUBSYS(net_cls)
 SUBSYS(blkio)
 #endif
 
+#ifdef CONFIG_PERF_CGROUPS
+SUBSYS(perf)
+#endif
+
 /* */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cbf04cc..a3a9732 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -454,6 +454,7 @@ enum perf_callchain_context {
 
 #define PERF_FLAG_FD_NO_GROUP	(1U << 0)
 #define PERF_FLAG_FD_OUTPUT	(1U << 1)
+#define PERF_FLAG_PID_CGROUP	(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
 #ifdef __KERNEL__
 /*
@@ -461,6 +462,7 @@ enum perf_callchain_context {
  */
 
 #ifdef CONFIG_PERF_EVENTS
+# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -702,6 +704,22 @@ struct swevent_hlist {
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
 
+#ifdef CONFIG_PERF_CGROUPS
+/*
+ * perf_cgroup_info keeps track of time_enabled for a cgroup.
+ * This is a per-cpu dynamically allocated data structure.
+ */
+struct perf_cgroup_info {
+	u64 time;
+	u64 timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state css;
+	struct perf_cgroup_info *info;	/* timing info, one per cpu */
+};
+#endif
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -815,6 +833,10 @@ struct perf_event {
 	struct event_filter		*filter;
 #endif
 
+#ifdef CONFIG_PERF_CGROUPS
+	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
+#endif
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -869,6 +891,7 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	struct rcu_head			rcu_head;
+	int				nr_cgroups; /* cgroup events present */
 };
 
 /*
@@ -1022,11 +1045,11 @@ have_event:
 	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
-extern atomic_t perf_task_events;
+extern atomic_t perf_sched_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
-	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
+	COND_STMT(&perf_sched_events, __perf_event_task_sched_in(task));
 }
 
 static inline
@@ -1034,7 +1057,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
+	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/init/Kconfig b/init/Kconfig
index b28dd23..10d408e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1066,6 +1066,17 @@ config PERF_COUNTERS
 
 	  Say N if unsure.
 
+config PERF_CGROUPS
+	bool "Enable per-cpu per-container group (cgroup) monitoring"
+	default y if CGROUPS
+	depends on PERF_EVENTS
+	help
+	  This option extends the per-cpu mode to restrict monitoring to
+	  threads which belong to the cgroup specificied and run on the
+	  designated cpu.
+
+	  Say N if unsure.
+
 config DEBUG_PERF_USE_VMALLOC
 	default n
 	bool "Debug: use vmalloc to back perf mmap() buffers"
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 66a416b..1c8bee8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4790,6 +4790,29 @@ css_get_next(struct cgroup_subsys *ss, int id,
 	return ret;
 }
 
+/*
+ * get corresponding css from file open on cgroupfs directory
+ */
+struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
+{
+	struct cgroup *cgrp;
+	struct inode *inode;
+	struct cgroup_subsys_state *css;
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
+	css = cgrp->subsys[id];
+	return css ? css : ERR_PTR(-ENOENT);
+}
+
 #ifdef CONFIG_CGROUP_DEBUG
 static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
 						   struct cgroup *cont)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f17fa83..60fe6f1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -35,13 +35,22 @@
 
 #include <asm/irq_regs.h>
 
+#define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
+		       PERF_FLAG_FD_OUTPUT  |\
+		       PERF_FLAG_PID_CGROUP)
+
 enum event_type_t {
 	EVENT_FLEXIBLE = 0x1,
 	EVENT_PINNED = 0x2,
 	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
 };
 
-atomic_t perf_task_events __read_mostly;
+/* perf_sched_events : >0 events exist
+ * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
+ */
+atomic_t perf_sched_events __read_mostly;
+static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
+
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
@@ -72,7 +81,10 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 			      enum event_type_t event_type);
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type);
+			     enum event_type_t event_type,
+			     struct task_struct *task, int css_sw);
+
+static u64 perf_event_time(struct perf_event *event);
 
 void __weak perf_event_print_debug(void)	{ }
 
@@ -86,6 +98,329 @@ static inline u64 perf_clock(void)
 	return local_clock();
 }
 
+#ifdef CONFIG_PERF_CGROUPS
+static inline struct perf_cgroup *
+perf_cgroup_from_task(struct task_struct *task)
+{
+	if (!task)
+		return NULL;
+	return container_of(task_subsys_state(task, perf_subsys_id),
+			struct perf_cgroup, css);
+}
+
+static inline bool
+perf_cgroup_match(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_cgroup *cgrp = NULL;
+	if (task)
+		cgrp = perf_cgroup_from_task(task);
+	return !event->cgrp || event->cgrp == cgrp;
+}
+
+static struct perf_cgroup *perf_get_cgroup(int fd)
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
+	return container_of(css, struct perf_cgroup, css);
+}
+
+static inline void perf_put_cgroup(struct perf_event *event)
+{
+	if (event->cgrp)
+		css_put(&event->cgrp->css);
+}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return event->cgrp != NULL;
+}
+
+static inline u64 perf_cgroup_event_css_time(struct perf_event *event)
+{
+	struct perf_cgroup_info *t;
+
+	if (WARN_ON_ONCE(event->cpu == -1))
+		return 0;
+
+	t = per_cpu_ptr(event->cgrp->info, event->cpu);
+	return t->time;
+}
+
+static inline void __update_css_time(struct perf_cgroup *cgrp)
+{
+	struct perf_cgroup_info *t;
+	u64 now;
+	int cpu = smp_processor_id();
+
+	if (!cgrp)
+		return;
+
+	now = perf_clock();
+
+	t = per_cpu_ptr(cgrp->info, cpu);
+
+	t->time += now - t->timestamp;
+	t->timestamp = now;
+}
+
+static inline void update_css_time_from_task(struct task_struct *task)
+{
+	struct perf_cgroup *cgrp_out = perf_cgroup_from_task(task);
+	__update_css_time(cgrp_out);
+}
+
+static inline void update_css_time_from_event(struct perf_event *event)
+{
+	struct perf_cgroup *cgrp = perf_cgroup_from_task(current);
+	/*
+	 * do not update time when css is not active
+	 */
+	if (!event->cgrp || cgrp != event->cgrp)
+		return;
+
+	__update_css_time(event->cgrp);
+}
+
+static inline void
+perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+{
+	struct perf_cgroup *cgrp;
+	struct perf_cgroup_info *info;
+
+	if (!task)
+		return;
+
+	cgrp = perf_cgroup_from_task(task);
+	info = per_cpu_ptr(cgrp->info, smp_processor_id());
+	info->timestamp = now;
+}
+
+static inline void
+perf_cgroup_sched_in(struct perf_event *event, int css_sw)
+{
+	/*
+	 * if we come here because of a context switch
+	 * with cgroup switch, then we need to update
+	 * the point in time at which all cgroup events
+	 * have been stopped. Otherwise, we would compute
+	 * bogus tstamp_running deltas, which would include
+	 * time the cgroup was not active.
+	 */
+	if (css_sw)
+		event->tstamp_stopped = perf_event_time(event);
+}
+
+/*
+ * called from perf_event_ask_sched_out() conditional to jump label
+ */
+void
+perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
+{
+	struct perf_cgroup *cgrp_out = perf_cgroup_from_task(task);
+	struct perf_cgroup *cgrp_in = perf_cgroup_from_task(next);
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	/*
+	 * if task is DEAD, then css_out is irrelevant, it has
+	 * been changed to init_css in cgroup_exit() from do_exit().
+	 * Furthermore, perf_cgroup_exit_task(), has scheduled out
+	 * all css constrained events, only unconstrained events
+	 * remain. Therefore we need to reschedule based on css_in.
+	 */
+	if (task->state != TASK_DEAD && cgrp_out == cgrp_in)
+		return;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		/*
+		 * perf_cgroup_events says at least one
+		 * context on this CPU has cgroup events.
+		 *
+		 * ctx->nr_cgroups reports the number of cgroup
+		 * events for a context. Given there can be multiple
+		 * PMUs, there can be multiple contexts.
+		 */
+		if (cpuctx->ctx.nr_cgroups > 0) {
+			/*
+			 * schedule out everything we have
+			 * task == DEAD: only unconstrained events
+			 * task != DEAD: css constrained + unconstrained events
+			 *
+			 * We kick out all events (even if unconstrained)
+			 * to allow the constrained events to be scheduled
+			 * based on their position in the event list (fairness)
+			 */
+			cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+			/*
+			 * reschedule css_in constrained + unconstrained events
+			 */
+			cpu_ctx_sched_in(cpuctx, EVENT_ALL, next, 1);
+		}
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+	}
+
+	rcu_read_unlock();
+}
+
+static inline void
+perf_cgroup_exit_task(struct task_struct *task)
+{
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		if (cpuctx->ctx.nr_cgroups > 0) {
+			/*
+			 * task is going to be detached from css.
+			 * We cannot keep a reference on the css
+			 * as it may disappear before we get to
+			 * perf_cgroup_switch(). Thus, we remove
+			 * all css constrained events.
+			 *
+			 * We do this by scheduling out everything
+			 * we have, and then only rescheduling only
+			 * the unconstrained events. Those can keep
+			 * on counting.
+			 *
+			 * We re-examine the situation in the final
+			 * perf_cgroup_switch() call for this task
+			 * once we know the next task.
+			 */
+			cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+			/*
+			 * task = NULL causes perf_cgroup_match()
+			 * to match only unconstrained events
+			 */
+			cpu_ctx_sched_in(cpuctx, EVENT_ALL, NULL, 1);
+		}
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+	}
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
+static inline int perf_connect_cgroup(int fd, struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
+{
+	struct perf_cgroup *cgrp;
+
+	/* pid contains cgroup fd */
+	cgrp = perf_get_cgroup(fd);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+	/*
+	 * all events in a group must monitor
+	 * the same cgroup because a thread belongs
+	 * to only one perf cgroup at a time
+	 */
+	if (group_leader && group_leader->cgrp != cgrp) {
+		/*
+		 * we artificially link cgrp so it gets
+		 * freed automatically by perf_put_cgroup()
+		 */
+		event->cgrp = cgrp;
+		perf_put_cgroup(event);
+		return -EINVAL;
+	}
+	event->cgrp = cgrp;
+	return 0;
+}
+
+static inline void
+perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
+{
+	struct perf_cgroup_info *t;
+	t = per_cpu_ptr(event->cgrp->info, event->cpu);
+	event->shadow_ctx_time = now - t->timestamp;
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
+static inline void perf_put_cgroup(struct perf_event *event)
+{}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline u64 perf_cgroup_event_css_time(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline void update_css_time_from_event(struct perf_event *event)
+{}
+
+static inline void update_css_time_from_task(struct task_struct *t)
+{}
+
+static inline int perf_connect_cgroup(pid_t pid, struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
+{
+	return -EINVAL;
+}
+
+static inline void
+perf_cgroup_sched_in(struct perf_event *event, int css_sw)
+{}
+
+static inline void
+perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+{}
+
+void
+perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
+{}
+
+static inline void
+perf_cgroup_exit_task(struct task_struct *task)
+{}
+
+static inline void
+perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
+{}
+#endif
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -246,6 +581,10 @@ static void update_context_time(struct perf_event_context *ctx)
 static u64 perf_event_time(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
+
+	if (is_cgroup_event(event))
+		return perf_cgroup_event_css_time(event);
+
 	return ctx ? ctx->time : 0;
 }
 
@@ -261,8 +600,10 @@ static void update_event_times(struct perf_event *event)
 	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
 		return;
 
-	if (ctx->is_active)
-		run_end = perf_event_time(event);
+	if (is_cgroup_event(event))
+		run_end = perf_cgroup_event_css_time(event);
+	else if (ctx->is_active)
+		run_end = ctx->time;
 	else
 		run_end = event->tstamp_stopped;
 
@@ -322,6 +663,17 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		list_add_tail(&event->group_entry, list);
 	}
 
+	if (is_cgroup_event(event)) {
+		ctx->nr_cgroups++;
+		/*
+		 * one more event:
+		 * - that has cgroup constraint on event->cpu
+		 * - that may need work on context switch
+		 */
+		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
+		jump_label_inc(&perf_sched_events);
+	}
+
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
 		perf_pmu_rotate_start(ctx->pmu);
@@ -368,6 +720,12 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
+	if (is_cgroup_event(event)) {
+		ctx->nr_cgroups--;
+		atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
+		jump_label_dec(&perf_sched_events);
+	}
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -431,9 +789,10 @@ static void perf_group_detach(struct perf_event *event)
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
@@ -450,8 +809,8 @@ event_sched_out(struct perf_event *event,
 	 * via read() for time_enabled, time_running:
 	 */
 	if (event->state == PERF_EVENT_STATE_INACTIVE
-	    && !event_filter_match(event)) {
-		delta = ctx->time - event->tstamp_stopped;
+	    && !event_filter_match(event, current)) {
+		delta = tstamp - event->tstamp_stopped;
 		event->tstamp_running += delta;
 		event->tstamp_stopped = tstamp;
 	}
@@ -609,6 +968,7 @@ static void __perf_event_disable(void *info)
 	 */
 	if (event->state >= PERF_EVENT_STATE_INACTIVE) {
 		update_context_time(ctx);
+		update_css_time_from_event(event);
 		update_group_times(event);
 		if (event == event->group_leader)
 			group_sched_out(event, cpuctx, ctx);
@@ -696,7 +1056,35 @@ event_sched_in(struct perf_event *event,
 
 	event->tstamp_running += tstamp - event->tstamp_stopped;
 
-	event->shadow_ctx_time = tstamp - ctx->timestamp;
+	/*
+	 * use the correct time source for the time snapshot
+	 *
+	 * We could get by without this by leveraging the
+	 * fact that to get to this function, the caller
+	 * has most likely already called update_context_time()
+	 * and update_css_time_xx() and thus both timestamp
+	 * are identical (or very close). Given that tstamp is,
+	 * already adjusted for cgroup, we could say that:
+	 *    tstamp - ctx->timestamp
+	 * is equivalent to
+	 *    tstamp - cgrp->timestamp.
+	 *
+	 * Then, in perf_output_read(), the calculation would
+	 * work with no changes because:
+	 * - event is guaranteed scheduled in
+	 * - no scheduled out in between
+	 * - thus the timestamp would be the same
+	 *
+	 * But this is a bit hairy.
+	 *
+	 * So instead, we have an explicit cgroup call to remain
+	 * within the time time source all along. We believe it
+	 * is cleaner and simpler to understand.
+	 */
+	if (is_cgroup_event(event))
+		perf_cgroup_set_shadow_time(event, tstamp);
+	else
+		event->shadow_ctx_time = tstamp - ctx->timestamp;
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
@@ -846,10 +1234,16 @@ static void __perf_install_in_context(void *info)
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
+	/*
+	 * update css time only if current css
+	 * matches event->css. Must be done before
+	 * calling add_event_to_ctx()
+	 */
+	update_css_time_from_event(event);
 
 	add_event_to_ctx(event, ctx);
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -991,9 +1385,16 @@ static void __perf_event_enable(void *info)
 
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		goto unlock;
+	/*
+	 * update css time when current css corresponds
+	 * to event->css. Must be done before calling
+	 * __perf_event_mark_enabled()
+	 */
+	update_css_time_from_event(event);
+
 	__perf_event_mark_enabled(event, ctx);
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		goto unlock;
 
 	/*
@@ -1116,6 +1517,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		goto out;
 	update_context_time(ctx);
+	update_css_time_from_task(current);
 
 	if (!ctx->nr_active)
 		goto out;
@@ -1305,6 +1707,13 @@ void __perf_event_task_sched_out(struct task_struct *task,
 
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
+
+	/*
+	 * if cgroup events exist on this CPU, then we need
+	 * to check if we have to save/restore PMU state.
+	 */
+	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+		perf_cgroup_switch(task, next);
 }
 
 static void task_ctx_sched_out(struct perf_event_context *ctx,
@@ -1333,16 +1742,20 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
-		    struct perf_cpu_context *cpuctx)
+		    struct perf_cpu_context *cpuctx,
+		    struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event))
+			perf_cgroup_sched_in(event, css_sw);
+
 		if (group_can_go_on(event, cpuctx, 1))
 			group_sched_in(event, cpuctx, ctx);
 
@@ -1359,7 +1772,8 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx)
+		      struct perf_cpu_context *cpuctx,
+		      struct task_struct *task, int css_sw)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1372,9 +1786,12 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, task))
 			continue;
 
+		if (is_cgroup_event(event))
+			perf_cgroup_sched_in(event, css_sw);
+
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
@@ -1385,36 +1802,41 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 static void
 ctx_sched_in(struct perf_event_context *ctx,
 	     struct perf_cpu_context *cpuctx,
-	     enum event_type_t event_type)
+	     enum event_type_t event_type,
+	     struct task_struct *task, int css_sw)
 {
+	u64 now;
+
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	if (likely(!ctx->nr_events))
 		goto out;
 
-	ctx->timestamp = perf_clock();
-
+	now = perf_clock();
+	ctx->timestamp = now;
+	perf_cgroup_set_timestamp(task, now);
 	/*
 	 * First go through the list and put on any pinned groups
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
@@ -1426,11 +1848,12 @@ static void task_ctx_sched_in(struct perf_event_context *ctx,
 	if (cpuctx->task_ctx == ctx)
 		return;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, NULL, 0);
 	cpuctx->task_ctx = ctx;
 }
 
-void perf_event_context_sched_in(struct perf_event_context *ctx)
+void perf_event_context_sched_in(struct perf_event_context *ctx,
+				 struct task_struct *task)
 {
 	struct perf_cpu_context *cpuctx;
 
@@ -1446,9 +1869,9 @@ void perf_event_context_sched_in(struct perf_event_context *ctx)
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task, 0);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task, 0);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task, 0);
 
 	cpuctx->task_ctx = ctx;
 
@@ -1481,7 +1904,7 @@ void __perf_event_task_sched_in(struct task_struct *task)
 		if (likely(!ctx))
 			continue;
 
-		perf_event_context_sched_in(ctx);
+		perf_event_context_sched_in(ctx, task);
 	}
 }
 
@@ -1599,7 +2022,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (!event_filter_match(event))
+		if (!event_filter_match(event, current))
 			continue;
 
 		hwc = &event->hw;
@@ -1686,7 +2109,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current, 0);
 	if (ctx)
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
@@ -1765,7 +2188,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_context_sched_in(ctx);
+	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
 }
@@ -1791,6 +2214,7 @@ static void __perf_event_read(void *info)
 
 	raw_spin_lock(&ctx->lock);
 	update_context_time(ctx);
+	update_css_time_from_event(event);
 	update_event_times(event);
 	raw_spin_unlock(&ctx->lock);
 
@@ -1821,8 +2245,10 @@ static u64 perf_event_read(struct perf_event *event)
 		 * (e.g., thread is blocked), in that case
 		 * we cannot update context time
 		 */
-		if (ctx->is_active)
+		if (ctx->is_active) {
 			update_context_time(ctx);
+			update_css_time_from_event(event);
+		}
 		update_event_times(event);
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
@@ -2198,7 +2624,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_task_events);
+			jump_label_dec(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2214,6 +2640,9 @@ static void free_event(struct perf_event *event)
 		event->buffer = NULL;
 	}
 
+	if (is_cgroup_event(event))
+		perf_put_cgroup(event);
+
 	if (event->destroy)
 		event->destroy(event);
 
@@ -3809,7 +4238,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -3934,7 +4363,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if (event->attr.comm)
@@ -4072,7 +4501,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event, current))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
@@ -5085,6 +5514,7 @@ static void task_clock_event_read(struct perf_event *event)
 
 	if (!in_nmi()) {
 		update_context_time(event->ctx);
+		update_css_time_from_event(event);
 		time = event->ctx->time;
 	} else {
 		u64 now = perf_clock();
@@ -5289,6 +5719,7 @@ unlock:
 static struct perf_event *
 perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct task_struct *task,
+		 int cgrp_fd, int flags,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
 		 perf_overflow_handler_t overflow_handler)
@@ -5302,6 +5733,14 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
+	if (flags & PERF_FLAG_PID_CGROUP) {
+		err = perf_connect_cgroup(cgrp_fd, event, attr, group_leader);
+		if (err) {
+			kfree(event);
+			return ERR_PTR(err);
+		}
+	}
+
 	/*
 	 * Single events are their own group leaders, with an
 	 * empty sibling list:
@@ -5380,6 +5819,7 @@ done:
 	if (err) {
 		if (event->ns)
 			put_pid_ns(event->ns);
+		perf_put_cgroup(event);
 		kfree(event);
 		return ERR_PTR(err);
 	}
@@ -5388,7 +5828,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_task_events);
+			jump_label_inc(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -5563,7 +6003,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int err;
 
 	/* for future expandability... */
-	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
+	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
 	err = perf_copy_attr(attr_uptr, &attr);
@@ -5580,6 +6020,15 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	/*
+	 * In cgroup mode, the pid argument is used to pass the fd
+	 * opened to the cgroup directory in cgroupfs. The cpu argument
+	 * designates the cpu on which to monitor threads from that
+	 * cgroup.
+	 */
+	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
+		return -EINVAL;
+
 	event_fd = get_unused_fd_flags(O_RDWR);
 	if (event_fd < 0)
 		return event_fd;
@@ -5597,7 +6046,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
-	if (pid != -1) {
+	if (pid != -1 && !(flags & PERF_FLAG_PID_CGROUP)) {
 		task = find_lively_task_by_vpid(pid);
 		if (IS_ERR(task)) {
 			err = PTR_ERR(task);
@@ -5605,7 +6054,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL, NULL);
+	event = perf_event_alloc(&attr, cpu, task, pid, flags, group_leader,
+				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_task;
@@ -5774,7 +6224,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL, overflow_handler);
+	event = perf_event_alloc(attr, cpu, task, -1, 0, NULL,
+				 NULL, overflow_handler);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -5963,6 +6414,8 @@ void perf_event_exit_task(struct task_struct *child)
 
 	for_each_task_context_nr(ctxn)
 		perf_event_exit_task_context(child, ctxn);
+
+	perf_cgroup_exit_task(child);
 }
 
 static void perf_free_event(struct perf_event *event,
@@ -6053,6 +6506,7 @@ inherit_event(struct perf_event *parent_event,
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu,
 					   child,
+					   -1, 0,
 					   group_leader, parent_event,
 					   NULL);
 	if (IS_ERR(child_event))
@@ -6406,3 +6860,51 @@ void __init perf_event_init(void)
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
 }
+
+#ifdef CONFIG_PERF_CGROUPS
+static struct cgroup_subsys_state *perf_cgroup_create(
+	struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+	struct perf_cgroup_info *t;
+	int c;
+
+	jc = kmalloc(sizeof(*jc), GFP_KERNEL);
+	if (!jc)
+		return ERR_PTR(-ENOMEM);
+
+	memset(jc, 0, sizeof(*jc));
+
+	jc->info = alloc_percpu(struct perf_cgroup_info);
+	if (!jc->info) {
+		kfree(jc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for_each_possible_cpu(c) {
+		t = per_cpu_ptr(jc->info, c);
+		t->time = 0;
+		t->timestamp = 0;
+	}
+	return &jc->css;
+}
+
+static void perf_cgroup_destroy(struct cgroup_subsys *ss,
+				struct cgroup *cont)
+{
+	struct perf_cgroup *jc;
+	jc = container_of(cgroup_subsys_state(cont, perf_subsys_id),
+			  struct perf_cgroup, css);
+
+	free_percpu(jc->info);
+	kfree(jc);
+}
+
+struct cgroup_subsys perf_subsys = {
+	.name = "perf_event",
+	.subsys_id = perf_subsys_id,
+	.create = perf_cgroup_create,
+	.destroy = perf_cgroup_destroy,
+};
+#endif /* CONFIG_PERF_CGROUP */
+
