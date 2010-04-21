Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0DUIIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:08:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:38211 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0DUIH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:07:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,249,1270450800"; 
   d="scan'208";a="511022705"
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Gary.Mohr@Bull.com" <Gary.Mohr@Bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Stephane Eranian <eranian@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271764993.1676.431.camel@laptop>
References: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
	 <1271424250.4807.2277.camel@twins>
	 <1271764547.13968.69.camel@minggr.sh.intel.com>
	 <1271764993.1676.431.camel@laptop>
Content-Type: text/plain
Date: Wed, 21 Apr 2010 16:08:14 +0800
Message-Id: <1271837295.3794.3.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 20:03 +0800, Peter Zijlstra wrote:
> On Tue, 2010-04-20 at 19:55 +0800, Lin Ming wrote:
> 
> > > One thing not on that list, which should happen first I guess, is to
> > > remove hw_perf_group_sched_in(). The idea is to add some sort of
> > > transactional API to the struct pmu, so that we can delay the
> > > schedulability check until commit time (and roll back when it fails).
> > > 
> > > Something as simple as:
> > > 
> > >   struct pmu {
> > >     void start_txn(struct pmu *);
> > >     void commit_txn(struct pmu *);
> > > 
> > >     ,,,
> > >   };
> > 
> > Could you please explain a bit more?
> > 
> > Does it mean that "start_txn" perform the schedule events stuff
> > and "commit_txn" perform the assign events stuff?
> > 
> > Does "commit time" mean the actual activation in hw_perf_enable?
> 
> No, the idea behind hw_perf_group_sched_in() is to not perform
> schedulability tests on each event in the group, but to add the group as
> a whole and then perform one test.
> 
> Of course, when that test fails, you'll have to roll-back the whole
> group again.
> 
> So start_txn (or a better name) would simply toggle a flag in the pmu
> implementation that will make pmu::enable() not perform the
> schedulablilty test.
> 
> Then commit_txn() will perform the schedulability test (so note the
> method has to have a !void return value, my mistake in the earlier
> email).
> 
> This will allow us to use the regular
> kernel/perf_event.c::group_sched_in() and all the rollback code.
> Currently each hw_perf_group_sched_in() implementation duplicates all
> the rolllback code (with various bugs).
> 
> 
> 
> We must get rid of all weak hw_perf_*() functions before we can properly
> consider multiple struct pmu implementations.
> 

Thanks for the clear explanation.

Does below patch show what you mean?

I only touch the x86 arch code now.

---
 arch/x86/kernel/cpu/perf_event.c |  161 +++++++++++--------------------------
 include/linux/perf_event.h       |   10 ++-
 kernel/perf_event.c              |   28 +++----
 3 files changed, 67 insertions(+), 132 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 626154a..62aa9a1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -944,6 +944,9 @@ static int x86_pmu_enable(struct perf_event *event)
 	if (n < 0)
 		return n;
 
+	if (!(event->pmu->flag & PERF_EVENT_TRAN_STARTED))
+		goto out;
+
 	ret = x86_pmu.schedule_events(cpuc, n, assign);
 	if (ret)
 		return ret;
@@ -953,6 +956,7 @@ static int x86_pmu_enable(struct perf_event *event)
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
+out:
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
 
@@ -1210,119 +1214,6 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
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
@@ -1454,6 +1345,47 @@ static inline void x86_pmu_read(struct perf_event *event)
 	x86_perf_event_update(event);
 }
 
+/*
+ * Set the flag to make pmu::enable() not perform the
+ * schedulablilty test.
+ */
+static void x86_pmu_start_txn(struct pmu *pmu)
+{
+	pmu->flag |= PERF_EVENT_TRAN_STARTED;
+}
+
+static void x86_pmu_stop_txn(struct pmu *pmu)
+{
+	pmu->flag &= ~PERF_EVENT_TRAN_STARTED;
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
 static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
@@ -1461,6 +1393,9 @@ static const struct pmu pmu = {
 	.stop		= x86_pmu_stop,
 	.read		= x86_pmu_read,
 	.unthrottle	= x86_pmu_unthrottle,
+	.start_txn	= x86_pmu_start_txn,
+	.stop_txn	= x86_pmu_stop_txn,
+	.commit_txn	= x86_pmu_commit_txn,
 };
 
 /*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bf896d0..93aa8d8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -524,6 +524,8 @@ struct hw_perf_event {
 
 struct perf_event;
 
+#define PERF_EVENT_TRAN_STARTED 1
+
 /**
  * struct pmu - generic performance monitoring unit
  */
@@ -534,6 +536,11 @@ struct pmu {
 	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
+	void (*start_txn)		(struct pmu *pmu);
+	void (*stop_txn)		(struct pmu *pmu);
+	int (*commit_txn)		(struct pmu *pmu);
+
+	u8 flag;
 };
 
 /**
@@ -799,9 +806,6 @@ extern void perf_disable(void);
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
index 07b7a43..4537676 100644
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
@@ -642,14 +634,13 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group;
+	struct pmu *pmu = (struct pmu *)group_event->pmu;
 	int ret;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
-	ret = hw_perf_group_sched_in(group_event, cpuctx, ctx);
-	if (ret)
-		return ret < 0 ? ret : 0;
+	pmu->start_txn(pmu);
 
 	if (event_sched_in(group_event, cpuctx, ctx))
 		return -EAGAIN;
@@ -664,16 +655,21 @@ group_sched_in(struct perf_event *group_event,
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


