Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1BNKWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:22:21 -0500
Received: from smtp-out.google.com ([74.125.121.67]:10793 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1BNKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=T6emtXXjj57PaEWHCR84bLNU1dZDpgRUOPrbgs9b2JWkg89sa1fFBU5PgD8Jck7Eer
         KmhW51e7CDvIgqlOP07w==
Message-ID: <4d590250.114ddf0a.689e.4482@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 14 Feb 2011 11:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 1/2] perf_events: add cgroup support (v9)
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
[ added perf_cgroup_{exit,attach} ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ce104e3..e654fa2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -626,6 +627,7 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 /* Get id and depth of css */
 unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
+struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 
 #else /* !CONFIG_CGROUPS */
 
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ccefff0..cdbfcb8 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -65,4 +65,8 @@ SUBSYS(net_cls)
 SUBSYS(blkio)
 #endif
 
+#ifdef CONFIG_CGROUP_PERF
+SUBSYS(perf)
+#endif
+
 /* */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index dda5b0a..38c8b25 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -464,6 +464,7 @@ enum perf_callchain_context {
 
 #define PERF_FLAG_FD_NO_GROUP	(1U << 0)
 #define PERF_FLAG_FD_OUTPUT	(1U << 1)
+#define PERF_FLAG_PID_CGROUP	(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
 #ifdef __KERNEL__
 /*
@@ -471,6 +472,7 @@ enum perf_callchain_context {
  */
 
 #ifdef CONFIG_PERF_EVENTS
+# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -716,6 +718,22 @@ struct swevent_hlist {
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
 
+#ifdef CONFIG_CGROUP_PERF
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
@@ -832,6 +850,11 @@ struct perf_event {
 	struct event_filter		*filter;
 #endif
 
+#ifdef CONFIG_CGROUP_PERF
+	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
+	int				cgrp_defer_enabled;
+#endif
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -886,6 +909,7 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	struct rcu_head			rcu_head;
+	int				nr_cgroups; /* cgroup events present */
 };
 
 /*
@@ -905,6 +929,9 @@ struct perf_cpu_context {
 	struct list_head		rotation_list;
 	int				jiffies_interval;
 	struct pmu			*active_pmu;
+#ifdef CONFIG_CGROUP_PERF
+	struct perf_cgroup		*cgrp;
+#endif
 };
 
 struct perf_output_handle {
@@ -1040,11 +1067,11 @@ have_event:
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
@@ -1052,7 +1079,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
+	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/init/Kconfig b/init/Kconfig
index be788c0..20d6bd9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -683,6 +683,16 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then noswapaccount does the trick).
 
+config CGROUP_PERF
+	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
+	depends on PERF_EVENTS && CGROUPS
+	help
+	  This option extends the per-cpu mode to restrict monitoring to
+	  threads which belong to the cgroup specificied and run on the
+	  designated cpu.
+
+	  Say N if unsure.
+
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
 	depends on EXPERIMENTAL
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b24d702..c6cf94a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4813,6 +4822,29 @@ css_get_next(struct cgroup_subsys *ss, int id,
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
index a353a4d..287aaf1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -111,13 +111,23 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 	return data.ret;
 }
 
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
+/*
+ * perf_sched_events : >0 events exist
+ * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
+ */
+atomic_t perf_sched_events __read_mostly;
+static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
+
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
@@ -148,7 +158,11 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 			      enum event_type_t event_type);
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type);
+			     enum event_type_t event_type,
+			     struct task_struct *task);
+
+static void update_context_time(struct perf_event_context *ctx);
+static u64 perf_event_time(struct perf_event *event);
 
 void __weak perf_event_print_debug(void)	{ }
 
@@ -162,6 +176,331 @@ static inline u64 perf_clock(void)
 	return local_clock();
 }
 
+static inline struct perf_cpu_context *
+__get_cpu_context(struct perf_event_context *ctx)
+{
+	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
+}
+
+#ifdef CONFIG_CGROUP_PERF
+
+static inline struct perf_cgroup *
+perf_cgroup_from_task(struct task_struct *task)
+{
+	return container_of(task_subsys_state(task, perf_subsys_id),
+			struct perf_cgroup, css);
+}
+
+static inline bool
+perf_cgroup_match(struct perf_event *event)
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
+static inline void perf_put_cgroup(struct perf_event *event)
+{
+	css_put(&event->cgrp->css);
+}
+
+static inline void perf_detach_cgroup(struct perf_event *event)
+{
+	perf_put_cgroup(event);
+	event->cgrp = NULL;
+}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return event->cgrp != NULL;
+}
+
+static inline u64 perf_cgroup_event_time(struct perf_event *event)
+{
+	struct perf_cgroup_info *t;
+
+	t = per_cpu_ptr(event->cgrp->info, event->cpu);
+	return t->time;
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
+static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
+{
+	struct perf_cgroup *cgrp_out = cpuctx->cgrp;
+	if (cgrp_out)
+		__update_cgrp_time(cgrp_out);
+}
+
+static inline void update_cgrp_time_from_event(struct perf_event *event)
+{
+	struct perf_cgroup *cgrp = perf_cgroup_from_task(current);
+	/*
+	 * do not update time when cgroup is not active
+	 */
+	if (!event->cgrp || cgrp != event->cgrp)
+		return;
+
+	__update_cgrp_time(event->cgrp);
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
+	info = this_cpu_ptr(cgrp->info);
+	info->timestamp = now;
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
+				 * must not be done before ctxswout dur
+				 * to event_filter_match() in event_sched_out()
+				 */
+				cpuctx->cgrp = NULL;
+			}
+
+			if (mode & PERF_CGROUP_SWIN) {
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
+static inline void perf_cgroup_sched_out(struct task_struct *task)
+{
+	perf_cgroup_switch(task, PERF_CGROUP_SWOUT);
+}
+
+static inline void perf_cgroup_sched_in(struct task_struct *task)
+{
+	perf_cgroup_switch(task, PERF_CGROUP_SWIN);
+}
+
+static inline int perf_cgroup_connect(int fd, struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
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
+	if (IS_ERR(css))
+		return PTR_ERR(css);
+
+	cgrp = container_of(css, struct perf_cgroup, css);
+	event->cgrp = cgrp;
+
+	/*
+	 * all events in a group must monitor
+	 * the same cgroup because a task belongs
+	 * to only one perf cgroup at a time
+	 */
+	if (group_leader && group_leader->cgrp != cgrp) {
+		perf_detach_cgroup(event);
+		ret = -EINVAL;
+	} else {
+		/* must be done before we fput() the file */
+		perf_get_cgroup(event);
+	}
+	fput_light(file, fput_needed);
+	return ret;
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
+
+static inline void
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
+#else /* !CONFIG_CGROUP_PERF */
+
+static inline bool
+perf_cgroup_match(struct perf_event *event)
+{
+	return true;
+}
+
+static inline void perf_detach_cgroup(struct perf_event *event)
+{}
+
+static inline int is_cgroup_event(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline u64 perf_cgroup_event_cgrp_time(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline void update_cgrp_time_from_event(struct perf_event *event)
+{}
+
+static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
+{}
+
+static inline void perf_cgroup_sched_out(struct task_struct *task)
+{
+}
+
+static inline void perf_cgroup_sched_in(struct task_struct *task)
+{
+}
+
+static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
+				      struct perf_event_attr *attr,
+				      struct perf_event *group_leader)
+{
+	return -EINVAL;
+}
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
+perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
+{}
+
+static inline u64 perf_cgroup_event_time(struct perf_event *event)
+{
+	return 0;
+}
+
+static inline void
+perf_cgroup_defer_enabled(struct perf_event *event)
+{}
+
+static inline void
+perf_cgroup_mark_enabled(struct perf_event *event,
+			 struct perf_event_context *ctx)
+{}
+#endif
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -343,6 +682,10 @@ static void update_context_time(struct perf_event_context *ctx)
 static u64 perf_event_time(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
+
+	if (is_cgroup_event(event))
+		return perf_cgroup_event_time(event);
+
 	return ctx ? ctx->time : 0;
 }
 
@@ -357,9 +700,20 @@ static void update_event_times(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE ||
 	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
 		return;
-
-	if (ctx->is_active)
+	/*
+	 * in cgroup mode, time_enabled represents
+	 * the time the event was enabled AND active
+	 * tasks were in the monitored cgroup. This is
+	 * independent of the activity of the context as
+	 * there may be a mix of cgroup and non-cgroup events.
+	 *
+	 * That is why we treat cgroup events differently
+	 * here.
+	 */
+	if (is_cgroup_event(event))
 		run_end = perf_event_time(event);
+	else if (ctx->is_active)
+		run_end = ctx->time;
 	else
 		run_end = event->tstamp_stopped;
 
@@ -371,6 +725,7 @@ static void update_event_times(struct perf_event *event)
 		run_end = perf_event_time(event);
 
 	event->total_time_running = run_end - event->tstamp_running;
+
 }
 
 /*
@@ -419,6 +774,17 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -545,6 +911,12 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
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
@@ -616,7 +988,8 @@ out:
 static inline int
 event_filter_match(struct perf_event *event)
 {
-	return event->cpu == -1 || event->cpu == smp_processor_id();
+	return (event->cpu == -1 || event->cpu == smp_processor_id())
+	    && perf_cgroup_match(event);
 }
 
 static void
@@ -634,7 +1007,7 @@ event_sched_out(struct perf_event *event,
 	 */
 	if (event->state == PERF_EVENT_STATE_INACTIVE
 	    && !event_filter_match(event)) {
-		delta = ctx->time - event->tstamp_stopped;
+		delta = tstamp - event->tstamp_stopped;
 		event->tstamp_running += delta;
 		event->tstamp_stopped = tstamp;
 	}
@@ -678,12 +1051,6 @@ group_sched_out(struct perf_event *group_event,
 		cpuctx->exclusive = 0;
 }
 
-static inline struct perf_cpu_context *
-__get_cpu_context(struct perf_event_context *ctx)
-{
-	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
-}
-
 /*
  * Cross CPU call to remove a performance event
  *
@@ -783,6 +1150,7 @@ static int __perf_event_disable(void *info)
 	 */
 	if (event->state >= PERF_EVENT_STATE_INACTIVE) {
 		update_context_time(ctx);
+		update_cgrp_time_from_event(event);
 		update_group_times(event);
 		if (event == event->group_leader)
 			group_sched_out(event, cpuctx, ctx);
@@ -851,6 +1219,41 @@ retry:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
+static void perf_set_shadow_time(struct perf_event *event,
+				 struct perf_event_context *ctx,
+				 u64 tstamp)
+{
+	/*
+	 * use the correct time source for the time snapshot
+	 *
+	 * We could get by without this by leveraging the
+	 * fact that to get to this function, the caller
+	 * has most likely already called update_context_time()
+	 * and update_cgrp_time_xx() and thus both timestamp
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
+}
+
 static int
 event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
@@ -876,7 +1279,7 @@ event_sched_in(struct perf_event *event,
 
 	event->tstamp_running += tstamp - event->tstamp_stopped;
 
-	event->shadow_ctx_time = tstamp - ctx->timestamp;
+	perf_set_shadow_time(event, ctx, tstamp);
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
@@ -997,7 +1400,8 @@ static void add_event_to_ctx(struct perf_event *event,
 	event->tstamp_stopped = tstamp;
 }
 
-static void perf_event_context_sched_in(struct perf_event_context *ctx);
+static void perf_event_context_sched_in(struct perf_event_context *ctx,
+					struct task_struct *tsk);
 
 /*
  * Cross CPU call to install and enable a performance event
@@ -1018,11 +1422,17 @@ static int  __perf_install_in_context(void *info)
 	 * which do context switches with IRQs enabled.
 	 */
 	if (ctx->task && !cpuctx->task_ctx)
-		perf_event_context_sched_in(ctx);
+		perf_event_context_sched_in(ctx, ctx->task);
 
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
+	/*
+	 * update cgrp time only if current cgrp
+	 * matches event->cgrp. Must be done before
+	 * calling add_event_to_ctx()
+	 */
+	update_cgrp_time_from_event(event);
 
 	add_event_to_ctx(event, ctx);
 
@@ -1160,10 +1570,19 @@ static int __perf_event_enable(void *info)
 
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		goto unlock;
+
+	/*
+	 * set current task's cgroup time reference point
+	 */
+	perf_cgroup_set_timestamp(current, perf_clock());
+
 	__perf_event_mark_enabled(event, ctx);
 
-	if (!event_filter_match(event))
+	if (!event_filter_match(event)) {
+		if (is_cgroup_event(event))
+			perf_cgroup_defer_enabled(event);
 		goto unlock;
+	}
 
 	/*
 	 * If the event is in a group and isn't the group leader,
@@ -1292,6 +1711,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		goto out;
 	update_context_time(ctx);
+	update_cgrp_time_from_cpuctx(cpuctx);
 
 	if (!ctx->nr_active)
 		goto out;
@@ -1481,6 +1901,14 @@ void __perf_event_task_sched_out(struct task_struct *task,
 
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
+
+	/*
+	 * if cgroup events exist on this CPU, then we need
+	 * to check if we have to switch out PMU state.
+	 * cgroup event are system-wide mode only
+	 */
+	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+		perf_cgroup_sched_out(task);
 }
 
 static void task_ctx_sched_out(struct perf_event_context *ctx,
@@ -1519,6 +1947,10 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 		if (!event_filter_match(event))
 			continue;
 
+		/* may need to reset tstamp_enabled */
+		if (is_cgroup_event(event))
+			perf_cgroup_mark_enabled(event, ctx);
+
 		if (group_can_go_on(event, cpuctx, 1))
 			group_sched_in(event, cpuctx, ctx);
 
@@ -1551,6 +1983,10 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		if (!event_filter_match(event))
 			continue;
 
+		/* may need to reset tstamp_enabled */
+		if (is_cgroup_event(event))
+			perf_cgroup_mark_enabled(event, ctx);
+
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
@@ -1561,15 +1997,19 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 static void
 ctx_sched_in(struct perf_event_context *ctx,
 	     struct perf_cpu_context *cpuctx,
-	     enum event_type_t event_type)
+	     enum event_type_t event_type,
+	     struct task_struct *task)
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
@@ -1586,11 +2026,12 @@ out:
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type)
+			     enum event_type_t event_type,
+			     struct task_struct *task)
 {
 	struct perf_event_context *ctx = &cpuctx->ctx;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, task);
 }
 
 static void task_ctx_sched_in(struct perf_event_context *ctx,
@@ -1602,11 +2043,12 @@ static void task_ctx_sched_in(struct perf_event_context *ctx,
 	if (cpuctx->task_ctx == ctx)
 		return;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	ctx_sched_in(ctx, cpuctx, event_type, NULL);
 	cpuctx->task_ctx = ctx;
 }
 
-static void perf_event_context_sched_in(struct perf_event_context *ctx)
+static void perf_event_context_sched_in(struct perf_event_context *ctx,
+					struct task_struct *task)
 {
 	struct perf_cpu_context *cpuctx;
 
@@ -1622,9 +2064,9 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx)
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
 
 	cpuctx->task_ctx = ctx;
 
@@ -1657,8 +2099,15 @@ void __perf_event_task_sched_in(struct task_struct *task)
 		if (likely(!ctx))
 			continue;
 
-		perf_event_context_sched_in(ctx);
+		perf_event_context_sched_in(ctx, task);
 	}
+	/*
+	 * if cgroup events exist on this CPU, then we need
+	 * to check if we have to switch in PMU state.
+	 * cgroup event are system-wide mode only
+	 */
+	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+		perf_cgroup_sched_in(task);
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -1862,7 +2311,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current);
 	if (ctx)
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
@@ -1941,7 +2390,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_context_sched_in(ctx);
+	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
 }
@@ -1966,8 +2415,10 @@ static void __perf_event_read(void *info)
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	if (ctx->is_active)
+	if (ctx->is_active) {
 		update_context_time(ctx);
+		update_cgrp_time_from_event(event);
+	}
 	update_event_times(event);
 	if (event->state == PERF_EVENT_STATE_ACTIVE)
 		event->pmu->read(event);
@@ -1998,8 +2449,10 @@ static u64 perf_event_read(struct perf_event *event)
 		 * (e.g., thread is blocked), in that case
 		 * we cannot update context time
 		 */
-		if (ctx->is_active)
+		if (ctx->is_active) {
 			update_context_time(ctx);
+			update_cgrp_time_from_event(event);
+		}
 		update_event_times(event);
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
@@ -2384,7 +2837,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_task_events);
+			jump_label_dec(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2400,6 +2853,9 @@ static void free_event(struct perf_event *event)
 		event->buffer = NULL;
 	}
 
+	if (is_cgroup_event(event))
+		perf_detach_cgroup(event);
+
 	if (event->destroy)
 		event->destroy(event);
 
@@ -5289,6 +5745,7 @@ static void task_clock_event_read(struct perf_event *event)
 
 	if (!in_nmi()) {
 		update_context_time(event->ctx);
+		update_cgrp_time_from_event(event);
 		time = event->ctx->time;
 	} else {
 		u64 now = perf_clock();
@@ -5714,7 +6171,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_task_events);
+			jump_label_inc(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -5889,7 +6346,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int err;
 
 	/* for future expandability... */
-	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
+	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
 	err = perf_copy_attr(attr_uptr, &attr);
@@ -5906,6 +6363,15 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5923,7 +6389,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
-	if (pid != -1) {
+	if (pid != -1 && !(flags & PERF_FLAG_PID_CGROUP)) {
 		task = find_lively_task_by_vpid(pid);
 		if (IS_ERR(task)) {
 			err = PTR_ERR(task);
@@ -5937,6 +6403,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_task;
 	}
 
+	if (flags & PERF_FLAG_PID_CGROUP) {
+		err = perf_cgroup_connect(pid, event, &attr, group_leader);
+		if (err)
+			goto err_alloc;
+	}
+
 	/*
 	 * Special case software events and allow them to be part of
 	 * any hardware group.
@@ -6797,3 +7269,92 @@ unlock:
 	return ret;
 }
 device_initcall(perf_event_sysfs_init);
+
+#ifdef CONFIG_CGROUP_PERF
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
+	free_percpu(jc->info);
+	kfree(jc);
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
+struct cgroup_subsys perf_subsys = {
+	.name = "perf_event",
+	.subsys_id = perf_subsys_id,
+	.create = perf_cgroup_create,
+	.destroy = perf_cgroup_destroy,
+	.exit = perf_cgroup_exit,
+	.attach = perf_cgroup_attach,
+};
+#endif /* CONFIG_CGROUP_PERF */
