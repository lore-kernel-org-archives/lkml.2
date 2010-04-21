Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0DUJmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:42:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:20414 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0DUJmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:42:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,249,1270450800"; 
   d="scan'208";a="560076336"
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Lin Ming <ming.m.lin@intel.com>
To: "eranian@gmail.com" <eranian@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <i2j7c86c4471004210144kd8223bfbve5d6bee2820d0ccf@mail.gmail.com>
References: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
	 <1271424250.4807.2277.camel@twins>
	 <1271764547.13968.69.camel@minggr.sh.intel.com>
	 <1271764993.1676.431.camel@laptop>
	 <1271837295.3794.3.camel@minggr.sh.intel.com>
	 <m2q7c86c4471004210132id258e98y47134ab3bd486efe@mail.gmail.com>
	 <1271839190.3794.5.camel@minggr.sh.intel.com>
	 <i2j7c86c4471004210144kd8223bfbve5d6bee2820d0ccf@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Apr 2010 17:42:54 +0800
Message-Id: <1271842974.3794.16.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 16:44 +0800, stephane eranian wrote:
> On Wed, Apr 21, 2010 at 10:39 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > On Wed, 2010-04-21 at 16:32 +0800, stephane eranian wrote:
> >> Seems to me that struct pmu is a shared resource across all CPUs.
> >> I don't understand why scheduling on one CPU would have to impact
> >> all the other CPUs, unless I am missing something here.
> >
> > Do you mean the pmu->flag?
> 
> Yes.

Thanks for the review.

Changes log:

v2.
pmu->flag should be per cpu (Stephane Eranian)

change definition of "const struct pmu" to "struct pmu" since it's not
read only now.

v1.
remove hw_perf_group_sched_in() based on Peter's idea.

---
 arch/x86/kernel/cpu/perf_event.c |  183 ++++++++++++++------------------------
 include/linux/perf_event.h       |   16 +++-
 kernel/perf_event.c              |   55 ++++++------
 3 files changed, 106 insertions(+), 148 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 626154a..1113fd5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -598,7 +598,7 @@ static void x86_pmu_enable_all(int added)
 	}
 }
 
-static const struct pmu pmu;
+static struct pmu pmu;
 
 static inline int is_x86_event(struct perf_event *event)
 {
@@ -935,6 +935,7 @@ static int x86_pmu_enable(struct perf_event *event)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc;
 	int assign[X86_PMC_IDX_MAX];
+	u8 *flag;
 	int n, n0, ret;
 
 	hwc = &event->hw;
@@ -944,6 +945,10 @@ static int x86_pmu_enable(struct perf_event *event)
 	if (n < 0)
 		return n;
 
+	flag = perf_pmu_flag((struct pmu *)event->pmu);
+	if (!(*flag & PERF_EVENT_TRAN_STARTED))
+		goto out;
+
 	ret = x86_pmu.schedule_events(cpuc, n, assign);
 	if (ret)
 		return ret;
@@ -953,6 +958,7 @@ static int x86_pmu_enable(struct perf_event *event)
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
+out:
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
 
@@ -1210,119 +1216,6 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	return &unconstrained;
 }
 
-static int x86_event_sched_in(struct perf_event *event,
-			  struct perf_cpu_context *cpuctx)
-{
-	int ret = 0;
-
-	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = smp_processor_id();
-	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
-
-	if (!is_x86_event(event))
-		ret = event->pmu->enable(event);
-
-	if (!ret && !is_software_event(event))
-		cpuctx->active_oncpu++;
-
-	if (!ret && event->attr.exclusive)
-		cpuctx->exclusive = 1;
-
-	return ret;
-}
-
-static void x86_event_sched_out(struct perf_event *event,
-			    struct perf_cpu_context *cpuctx)
-{
-	event->state = PERF_EVENT_STATE_INACTIVE;
-	event->oncpu = -1;
-
-	if (!is_x86_event(event))
-		event->pmu->disable(event);
-
-	event->tstamp_running -= event->ctx->time - event->tstamp_stopped;
-
-	if (!is_software_event(event))
-		cpuctx->active_oncpu--;
-
-	if (event->attr.exclusive || !cpuctx->active_oncpu)
-		cpuctx->exclusive = 0;
-}
-
-/*
- * Called to enable a whole group of events.
- * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
- * Assumes the caller has disabled interrupts and has
- * frozen the PMU with hw_perf_save_disable.
- *
- * called with PMU disabled. If successful and return value 1,
- * then guaranteed to call perf_enable() and hw_perf_enable()
- */
-int hw_perf_group_sched_in(struct perf_event *leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct perf_event *sub;
-	int assign[X86_PMC_IDX_MAX];
-	int n0, n1, ret;
-
-	if (!x86_pmu_initialized())
-		return 0;
-
-	/* n0 = total number of events */
-	n0 = collect_events(cpuc, leader, true);
-	if (n0 < 0)
-		return n0;
-
-	ret = x86_pmu.schedule_events(cpuc, n0, assign);
-	if (ret)
-		return ret;
-
-	ret = x86_event_sched_in(leader, cpuctx);
-	if (ret)
-		return ret;
-
-	n1 = 1;
-	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
-		if (sub->state > PERF_EVENT_STATE_OFF) {
-			ret = x86_event_sched_in(sub, cpuctx);
-			if (ret)
-				goto undo;
-			++n1;
-		}
-	}
-	/*
-	 * copy new assignment, now we know it is possible
-	 * will be used by hw_perf_enable()
-	 */
-	memcpy(cpuc->assign, assign, n0*sizeof(int));
-
-	cpuc->n_events  = n0;
-	cpuc->n_added  += n1;
-	ctx->nr_active += n1;
-
-	/*
-	 * 1 means successful and events are active
-	 * This is not quite true because we defer
-	 * actual activation until hw_perf_enable() but
-	 * this way we* ensure caller won't try to enable
-	 * individual events
-	 */
-	return 1;
-undo:
-	x86_event_sched_out(leader, cpuctx);
-	n0  = 1;
-	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
-		if (sub->state == PERF_EVENT_STATE_ACTIVE) {
-			x86_event_sched_out(sub, cpuctx);
-			if (++n0 == n1)
-				break;
-		}
-	}
-	return ret;
-}
-
 #include "perf_event_amd.c"
 #include "perf_event_p6.c"
 #include "perf_event_p4.c"
@@ -1397,6 +1290,14 @@ void __init init_hw_perf_events(void)
 		return;
 	}
 
+	/*
+	 * TBD: will move this to pmu register function
+	 * when multiple hw pmu support is added
+	 */
+	pmu.flag = alloc_percpu(u8);
+	if (!pmu.flag)
+		return;
+
 	pmu_check_apic();
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
@@ -1454,13 +1355,61 @@ static inline void x86_pmu_read(struct perf_event *event)
 	x86_perf_event_update(event);
 }
 
-static const struct pmu pmu = {
+/*
+ * Set the flag to make pmu::enable() not perform the
+ * schedulablilty test.
+ */
+static void x86_pmu_start_txn(struct pmu *pmu)
+{
+	u8 *flag = perf_pmu_flag(pmu);
+
+	*flag |= PERF_EVENT_TRAN_STARTED;
+}
+
+static void x86_pmu_stop_txn(struct pmu *pmu)
+{
+	u8 *flag = perf_pmu_flag(pmu);
+
+	*flag &= ~PERF_EVENT_TRAN_STARTED;
+}
+
+/*
+ * Return 0 if commit transaction success
+ */
+static int x86_pmu_commit_txn(struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int assign[X86_PMC_IDX_MAX];
+	int n, ret;
+
+	n = cpuc->n_events;
+
+	if (!x86_pmu_initialized())
+		return -EAGAIN;
+
+	ret = x86_pmu.schedule_events(cpuc, n, assign);
+	if (ret)
+		return ret;
+
+	/*
+	 * copy new assignment, now we know it is possible
+	 * will be used by hw_perf_enable()
+	 */
+	memcpy(cpuc->assign, assign, n*sizeof(int));
+
+	return 0;
+}
+
+static struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
 	.start		= x86_pmu_start,
 	.stop		= x86_pmu_stop,
 	.read		= x86_pmu_read,
 	.unthrottle	= x86_pmu_unthrottle,
+	.start_txn	= x86_pmu_start_txn,
+	.stop_txn	= x86_pmu_stop_txn,
+	.commit_txn	= x86_pmu_commit_txn,
 };
 
 /*
@@ -1537,9 +1486,9 @@ out:
 	return ret;
 }
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
-	const struct pmu *tmp;
+	struct pmu *tmp;
 	int err;
 
 	err = __hw_perf_event_init(event);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bf896d0..9fa3f46 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -524,6 +524,8 @@ struct hw_perf_event {
 
 struct perf_event;
 
+#define PERF_EVENT_TRAN_STARTED 1
+
 /**
  * struct pmu - generic performance monitoring unit
  */
@@ -534,6 +536,12 @@ struct pmu {
 	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
+	void (*start_txn)		(struct pmu *pmu);
+	void (*stop_txn)		(struct pmu *pmu);
+	int (*commit_txn)		(struct pmu *pmu);
+
+	/* percpu flag */
+	u8 *flag;
 };
 
 /**
@@ -610,7 +618,7 @@ struct perf_event {
 	int				group_flags;
 	struct perf_event		*group_leader;
 	struct perf_event		*output;
-	const struct pmu		*pmu;
+	struct pmu			*pmu;
 
 	enum perf_event_active_state	state;
 	atomic64_t			count;
@@ -782,7 +790,7 @@ struct perf_output_handle {
  */
 extern int perf_max_events;
 
-extern const struct pmu *hw_perf_event_init(struct perf_event *event);
+extern struct pmu *hw_perf_event_init(struct perf_event *event);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
@@ -799,9 +807,6 @@ extern void perf_disable(void);
 extern void perf_enable(void);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
-extern int hw_perf_group_sched_in(struct perf_event *group_leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
@@ -811,6 +816,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				perf_overflow_handler_t callback);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
+extern u8 *perf_pmu_flag(struct pmu *pmu);
 
 struct perf_sample_data {
 	u64				type;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 07b7a43..4820090 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -75,7 +75,7 @@ static DEFINE_SPINLOCK(perf_resource_lock);
 /*
  * Architecture provided APIs - weak aliases:
  */
-extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
+extern __weak struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
@@ -83,15 +83,14 @@ extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
-int __weak
-hw_perf_group_sched_in(struct perf_event *group_leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx)
+void __weak perf_event_print_debug(void)	{ }
+
+u8 *perf_pmu_flag(struct pmu *pmu)
 {
-	return 0;
-}
+	int cpu = smp_processor_id();
 
-void __weak perf_event_print_debug(void)	{ }
+	return per_cpu_ptr(pmu->flag, cpu);
+}
 
 static DEFINE_PER_CPU(int, perf_disable_count);
 
@@ -642,14 +641,13 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group;
+	struct pmu *pmu = group_event->pmu;
 	int ret;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
-	ret = hw_perf_group_sched_in(group_event, cpuctx, ctx);
-	if (ret)
-		return ret < 0 ? ret : 0;
+	pmu->start_txn(pmu);
 
 	if (event_sched_in(group_event, cpuctx, ctx))
 		return -EAGAIN;
@@ -664,16 +662,21 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
-	return 0;
+	ret = pmu->commit_txn(pmu);
+	if (!ret) {
+		pmu->stop_txn(pmu);
+		return 0;
+	}
 
 group_error:
+	pmu->stop_txn(pmu);
+
 	/*
-	 * Groups can be scheduled in as one unit only, so undo any
-	 * partial group before returning:
+	 * Commit transaction fails, rollback
+	 * Groups can be scheduled in as one unit only, so undo
+	 * whole group before returning:
 	 */
 	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
-		if (event == partial_group)
-			break;
 		event_sched_out(event, cpuctx, ctx);
 	}
 	event_sched_out(group_event, cpuctx, ctx);
@@ -4139,7 +4142,7 @@ static void perf_swevent_disable(struct perf_event *event)
 	hlist_del_rcu(&event->hlist_entry);
 }
 
-static const struct pmu perf_ops_generic = {
+static struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
 	.read		= perf_swevent_read,
@@ -4250,7 +4253,7 @@ static void cpu_clock_perf_event_read(struct perf_event *event)
 	cpu_clock_perf_event_update(event);
 }
 
-static const struct pmu perf_ops_cpu_clock = {
+static struct pmu perf_ops_cpu_clock = {
 	.enable		= cpu_clock_perf_event_enable,
 	.disable	= cpu_clock_perf_event_disable,
 	.read		= cpu_clock_perf_event_read,
@@ -4307,7 +4310,7 @@ static void task_clock_perf_event_read(struct perf_event *event)
 	task_clock_perf_event_update(event, time);
 }
 
-static const struct pmu perf_ops_task_clock = {
+static struct pmu perf_ops_task_clock = {
 	.enable		= task_clock_perf_event_enable,
 	.disable	= task_clock_perf_event_disable,
 	.read		= task_clock_perf_event_read,
@@ -4448,7 +4451,7 @@ static void tp_perf_event_destroy(struct perf_event *event)
 	swevent_hlist_put(event);
 }
 
-static const struct pmu *tp_perf_event_init(struct perf_event *event)
+static struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	int err;
 
@@ -4505,7 +4508,7 @@ static int perf_tp_event_match(struct perf_event *event,
 	return 1;
 }
 
-static const struct pmu *tp_perf_event_init(struct perf_event *event)
+static struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
@@ -4527,7 +4530,7 @@ static void bp_perf_event_destroy(struct perf_event *event)
 	release_bp_slot(event);
 }
 
-static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	int err;
 
@@ -4551,7 +4554,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else
-static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	return NULL;
 }
@@ -4573,9 +4576,9 @@ static void sw_perf_event_destroy(struct perf_event *event)
 	swevent_hlist_put(event);
 }
 
-static const struct pmu *sw_perf_event_init(struct perf_event *event)
+static struct pmu *sw_perf_event_init(struct perf_event *event)
 {
-	const struct pmu *pmu = NULL;
+	struct pmu *pmu = NULL;
 	u64 event_id = event->attr.config;
 
 	/*
@@ -4637,7 +4640,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 		   perf_overflow_handler_t overflow_handler,
 		   gfp_t gfpflags)
 {
-	const struct pmu *pmu;
+	struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	long err;


> 
> > You are right, pmu->flag should be per cpu data.
> >
> > Will update the patch.
> >
> > Thanks,
> > Lin Ming
> >
> >>


