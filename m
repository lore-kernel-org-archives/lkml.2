Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0DUONM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:13:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:31135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0DUONI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:13:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,250,1270450800"; 
   d="scan'208";a="615240592"
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271843869.1776.65.camel@laptop>
References: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
	 <1271424250.4807.2277.camel@twins>
	 <1271764547.13968.69.camel@minggr.sh.intel.com>
	 <1271764993.1676.431.camel@laptop>
	 <1271837295.3794.3.camel@minggr.sh.intel.com>
	 <m2q7c86c4471004210132id258e98y47134ab3bd486efe@mail.gmail.com>
	 <1271839190.3794.5.camel@minggr.sh.intel.com>
	 <i2j7c86c4471004210144kd8223bfbve5d6bee2820d0ccf@mail.gmail.com>
	 <1271842974.3794.16.camel@minggr.sh.intel.com>
	 <1271843869.1776.65.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 22:12:22 +0000
Message-Id: <1271887942.3054.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 17:57 +0800, Peter Zijlstra wrote:
> On Wed, 2010-04-21 at 17:42 +0800, Lin Ming wrote:
> > +       /*
> > +        * TBD: will move this to pmu register function
> > +        * when multiple hw pmu support is added
> > +        */
> > +       pmu.flag = alloc_percpu(u8);
> > +       if (!pmu.flag)
> > +               return; 
> 
> Why not simply use a field in struct cpu_hw_events?
> 
> That's where we track all per-cpu pmu state.

That's good idea!

Thanks for the review.

Changes log:

v3.
track per-cpu pmu transaction state in cpu_hw_events (Peter Zijlstra)
move pmu definition back to const ("struct pmu" -> "const struct pmu")

v2.
pmu->flag should be per cpu (Stephane Eranian)

change definition of "const struct pmu" to "struct pmu" since it's not
read only now.

v1.
remove hw_perf_group_sched_in() based on Peter's idea.

---
 arch/x86/kernel/cpu/perf_event.c |  167 ++++++++++++-------------------------
 include/linux/perf_event.h       |    8 +-
 kernel/perf_event.c              |   23 +++---
 3 files changed, 69 insertions(+), 129 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 626154a..4a1dc62 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -110,6 +110,8 @@ struct cpu_hw_events {
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 
+	u8			flag;
+
 	/*
 	 * Intel DebugStore bits
 	 */
@@ -944,6 +946,9 @@ static int x86_pmu_enable(struct perf_event *event)
 	if (n < 0)
 		return n;
 
+	if (cpuc->flag & PERF_EVENT_TRAN_STARTED)
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
@@ -1454,6 +1347,51 @@ static inline void x86_pmu_read(struct perf_event *event)
 	x86_perf_event_update(event);
 }
 
+/*
+ * Set the flag to make pmu::enable() not perform the
+ * schedulablilty test.
+ */
+static void x86_pmu_start_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	cpuc->flag |= PERF_EVENT_TRAN_STARTED;
+}
+
+static void x86_pmu_stop_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	cpuc->flag &= ~PERF_EVENT_TRAN_STARTED;
+}
+
+/*
+ * Return 0 if commit transaction success
+ */
+static int x86_pmu_commit_txn(const struct pmu *pmu)
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
 static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
@@ -1461,6 +1399,9 @@ static const struct pmu pmu = {
 	.stop		= x86_pmu_stop,
 	.read		= x86_pmu_read,
 	.unthrottle	= x86_pmu_unthrottle,
+	.start_txn	= x86_pmu_start_txn,
+	.stop_txn	= x86_pmu_stop_txn,
+	.commit_txn	= x86_pmu_commit_txn,
 };
 
 /*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bf896d0..862b965 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -524,6 +524,8 @@ struct hw_perf_event {
 
 struct perf_event;
 
+#define PERF_EVENT_TRAN_STARTED 1
+
 /**
  * struct pmu - generic performance monitoring unit
  */
@@ -534,6 +536,9 @@ struct pmu {
 	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
+	void (*start_txn)		(const struct pmu *pmu);
+	void (*stop_txn)		(const struct pmu *pmu);
+	int (*commit_txn)		(const struct pmu *pmu);
 };
 
 /**
@@ -799,9 +804,6 @@ extern void perf_disable(void);
 extern void perf_enable(void);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
-extern int hw_perf_group_sched_in(struct perf_event *group_leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 07b7a43..1503174 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -83,14 +83,6 @@ extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
-int __weak
-hw_perf_group_sched_in(struct perf_event *group_leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx)
-{
-	return 0;
-}
-
 void __weak perf_event_print_debug(void)	{ }
 
 static DEFINE_PER_CPU(int, perf_disable_count);
@@ -641,15 +633,14 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_event_context *ctx)
 {
-	struct perf_event *event, *partial_group;
+	struct perf_event *event, *partial_group = NULL;
+	const struct pmu *pmu = group_event->pmu;
 	int ret;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
-	ret = hw_perf_group_sched_in(group_event, cpuctx, ctx);
-	if (ret)
-		return ret < 0 ? ret : 0;
+	pmu->start_txn(pmu);
 
 	if (event_sched_in(group_event, cpuctx, ctx))
 		return -EAGAIN;
@@ -664,9 +655,15 @@ group_sched_in(struct perf_event *group_event,
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
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:


