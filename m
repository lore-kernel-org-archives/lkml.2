Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0DVHuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:50:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:5781 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0DVHus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:50:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,254,1270450800"; 
   d="scan'208";a="791705131"
Subject: [RFC][PATCH 2/4] perf: x86, implement group scheduling
 transactional APIs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>, arjan@linux.intel.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 Apr 2010 15:51:11 +0800
Message-Id: <1271922671.30535.108.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: x86, implement group scheduling transaction APIs
   
Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |  167 ++++++++++++-------------------------
 1 files changed, 54 insertions(+), 113 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7de7061..cf6812f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -110,6 +110,8 @@ struct cpu_hw_events {
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 
+	u8			group_flag;
+
 	/*
 	 * Intel DebugStore bits
 	 */
@@ -944,6 +946,9 @@ static int x86_pmu_enable(struct perf_event *event)
 	if (n < 0)
 		return n;
 
+	if (cpuc->group_flag & PERF_EVENT_TRAN_STARTED)
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
+	cpuc->group_flag |= PERF_EVENT_TRAN_STARTED;
+}
+
+static void x86_pmu_stop_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	cpuc->group_flag &= ~PERF_EVENT_TRAN_STARTED;
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


