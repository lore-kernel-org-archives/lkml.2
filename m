Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab1EKRJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:09:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53732 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1EKRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:09:49 -0400
Date: Wed, 11 May 2011 19:09:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        osrc-patches <osrc-patches@elbe.amd.com>
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110511170912.GA27362@aftab>
References: <20110511121135.GA25865@aftab>
 <1305121600.2914.214.camel@laptop>
 <20110511140208.GD25827@aftab>
 <20110511141342.GA19053@elte.hu>
 <20110511143149.GA26548@aftab>
 <20110511152156.GA21707@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511152156.GA21707@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:21:56AM -0400, Ingo Molnar wrote:

[..]

> > > There's not that many that are in perf_event.h and are only used in 
> > > kernel/event/core.c.
> > > 
> > > Below is a generated list of all exported functions and their usage sites. Out 
> > > of 40 functions 7 should not be exported:
> > > 
> > >  __perf_sw_event()
> > >  perf_swevent_put_recursion_context()
> > >  perf_pmu_unregister()
> > >  perf_output_copy()
> > >  __perf_event_task_sched_in()
> > >  __perf_event_task_sched_out()
> > >  perf_event_read_value()
> > 
> > Right, but splitting perf_event.c further would cause a bunch more of them to 
> > go up in the header since they're being shared among kernel/events/*.c files. 
> > But in the end, this is a judgement call - I mean, even the polluting ones 
> > have a clearly defined namespace starting their names with {_-,}perf_*. If 
> > you asked me, I'd do an internal.h header from the get-go so that all is kept 
> > as clean as possible.
> 
> We seem to be in wild agreement wrt. internal.h!

Done, patch below. I've moved all exports local to kernel/events/* to
internal.h. Branch at

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git perf-split

also updated.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 11 May 2011 19:02:10 +0200
Subject: [PATCH] perf: Cleanup namespace

Add an internal header containing all function declarations used only by
kernel/events/* compilation units. Drop declarations used in one .c file
only.

No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |  132 --------------------------------------------
 kernel/events/callchain.c  |    3 +
 kernel/events/cgroup.c     |    2 +
 kernel/events/core.c       |    2 +
 kernel/events/internal.h   |  129 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 136 insertions(+), 132 deletions(-)
 create mode 100644 kernel/events/internal.h

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7978850..6b25452 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -963,7 +963,6 @@ enum event_type_t {
 #ifdef CONFIG_PERF_EVENTS
 extern struct list_head pmus;
 extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
-extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
@@ -985,8 +984,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				struct task_struct *task,
 				perf_overflow_handler_t callback);
-extern u64 perf_event_read_value(struct perf_event *event,
-				 u64 *enabled, u64 *running);
 
 struct perf_sample_data {
 	u64				type;
@@ -1152,60 +1149,10 @@ extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size,
 			     int nmi, int sample);
 extern void perf_output_end(struct perf_output_handle *handle);
-extern void perf_output_copy(struct perf_output_handle *handle,
-			     const void *buf, unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
-extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
-
-static inline struct perf_cpu_context *
-__get_cpu_context(struct perf_event_context *ctx)
-{
-	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
-}
-
-static inline u64 perf_clock(void)
-{
-	return local_clock();
-}
-
-extern void ctx_sched_out(struct perf_event_context *ctx,
-			  struct perf_cpu_context *cpuctx,
-			  enum event_type_t event_type);
-/*
- * Called with IRQs disabled
- */
-static inline void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
-				     enum event_type_t event_type)
-{
-	ctx_sched_out(&cpuctx->ctx, cpuctx, event_type);
-}
-
-extern void ctx_sched_in(struct perf_event_context *ctx,
-			 struct perf_cpu_context *cpuctx,
-			 enum event_type_t event_type,
-			 struct task_struct *task);
-
-static inline void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-				    enum event_type_t event_type,
-				    struct task_struct *task)
-{
-	struct perf_event_context *ctx = &cpuctx->ctx;
-
-	ctx_sched_in(ctx, cpuctx, event_type, task);
-}
-
-extern int
-task_function_call(struct task_struct *p, int (*func) (void *info), void *info);
-extern u64 perf_event_time(struct perf_event *event);
-
-extern int get_recursion_context(int *recursion);
-extern inline void put_recursion_context(int *recursion, int rctx);
-extern void put_callchain_buffers(void);
-extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
-extern int get_callchain_buffers(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1236,90 +1183,11 @@ static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
-static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
 #endif /* CONFIG_PERF_EVENTS */
 
-#ifdef CONFIG_CGROUP_PERF
-extern struct perf_cgroup *
-perf_cgroup_from_task(struct task_struct *task);
-extern bool perf_cgroup_match(struct perf_event *event);
-extern int
-perf_cgroup_connect(pid_t pid, struct perf_event *event,
-		    struct perf_event_attr *attr,
-		    struct perf_event *group_leader);
-extern void perf_detach_cgroup(struct perf_event *event);
-
-static inline int is_cgroup_event(struct perf_event *event)
-{
-	return event->cgrp != NULL;
-}
-
-extern u64 perf_cgroup_event_time(struct perf_event *event);
-extern void update_cgrp_time_from_event(struct perf_event *event);
-extern void
-update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx);
-extern void
-perf_cgroup_set_timestamp(struct task_struct *task,
-			  struct perf_event_context *ctx);
-
-extern void perf_cgroup_sched_out(struct task_struct *task);
-extern void perf_cgroup_sched_in(struct task_struct *task);
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
-extern inline void
-perf_cgroup_mark_enabled(struct perf_event *event,
-			 struct perf_event_context *ctx);
-#else
-static inline struct perf_cgroup *
-perf_cgroup_from_task(struct task_struct *task)				{ return NULL; }
-static inline bool perf_cgroup_match(struct perf_event *event)		{ return true; }
-static inline int
-perf_cgroup_connect(pid_t pid, struct perf_event *event,
-		    struct perf_event_attr *attr,
-		    struct perf_event *group_leader)			{ return -EINVAL; }
-static inline void perf_detach_cgroup(struct perf_event *event)		{ }
-static inline int is_cgroup_event(struct perf_event *event)		{ return 0; }
-static inline u64 perf_cgroup_event_time(struct perf_event *event)	{ return 0; }
-static inline void update_cgrp_time_from_event(struct perf_event *e)	{ }
-static inline void
-update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)		{ }
-static inline void
-perf_cgroup_set_timestamp(struct task_struct *task,
-			  struct perf_event_context *ctx)		{ }
-static inline void perf_cgroup_sched_out(struct task_struct *task)	{ }
-static inline void perf_cgroup_sched_in(struct task_struct *task)	{ }
-static inline void
-perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)		{ }
-static inline void perf_cgroup_defer_enabled(struct perf_event *event)	{ }
-static inline void
-perf_cgroup_mark_enabled(struct perf_event *event,
-			 struct perf_event_context *ctx)		{ }
-#endif /* CONFIG_CGROUP_PERF */
-
-#define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
-
 /*
  * This has to have a higher priority than migration_notifier in sched.c.
  */
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 0b495fc..86bb85a 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -1,6 +1,9 @@
 #include <linux/slab.h>
 #include <linux/hardirq.h>
 #include <linux/perf_event.h>
+
+#include "internal.h"
+
 /*
  * Callchain support
  */
diff --git a/kernel/events/cgroup.c b/kernel/events/cgroup.c
index 5516928..e50c677 100644
--- a/kernel/events/cgroup.c
+++ b/kernel/events/cgroup.c
@@ -2,6 +2,8 @@
 #include <linux/slab.h>
 #include <linux/perf_event.h>
 
+#include "internal.h"
+
 /*
  * Must ensure cgroup is pinned (css_get) before calling
  * this function. In other words, we cannot call this function
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 364cad6..e817d91 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -38,6 +38,8 @@
 
 #include <asm/irq_regs.h>
 
+#include "internal.h"
+
 struct remote_function_call {
 	struct task_struct	*p;
 	int			(*func)(void *info);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
new file mode 100644
index 0000000..5cbec39
--- /dev/null
+++ b/kernel/events/internal.h
@@ -0,0 +1,129 @@
+#ifndef __PERF_EVENT_INTERNAL__
+#define __PERF_EVENT_INTERNAL__
+
+#define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
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
+
+extern int get_recursion_context(int *recursion);
+extern inline void put_recursion_context(int *recursion, int rctx);
+
+extern void put_callchain_buffers(void);
+extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+extern int get_callchain_buffers(void);
+#endif /* __PERF_EVENT_INTERNAL__ */
-- 
1.7.4.rc2



-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
