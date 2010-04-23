Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0DWF4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:56:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:61592 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab0DWF4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,260,1270450800"; 
   d="scan'208";a="792031630"
Subject: [RFC][PATCH v2 3/4] perf: powerpc, implement group scheduling
 transactional APIs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Apr 2010 13:56:26 +0800
Message-Id: <1272002186.5707.64.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: powerpc, implement group scheduling transactional APIs

Cross build test only.
It's very appreciated if anybody has powerpc can help to test.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/powerpc/kernel/perf_event.c |  130 +++++++++++++++++++-------------------
 1 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 08460a2..b441168 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -35,6 +35,8 @@ struct cpu_hw_events {
 	u64 alternatives[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
 	unsigned long amasks[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
 	unsigned long avalues[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
+
+	unsigned int group_flag;
 };
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 
@@ -718,66 +720,6 @@ static int collect_events(struct perf_event *group, int max_count,
 	return n;
 }
 
-static void event_sched_in(struct perf_event *event)
-{
-	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = smp_processor_id();
-	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
-	if (is_software_event(event))
-		event->pmu->enable(event);
-}
-
-/*
- * Called to enable a whole group of events.
- * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
- * Assumes the caller has disabled interrupts and has
- * frozen the PMU with hw_perf_save_disable.
- */
-int hw_perf_group_sched_in(struct perf_event *group_leader,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx)
-{
-	struct cpu_hw_events *cpuhw;
-	long i, n, n0;
-	struct perf_event *sub;
-
-	if (!ppmu)
-		return 0;
-	cpuhw = &__get_cpu_var(cpu_hw_events);
-	n0 = cpuhw->n_events;
-	n = collect_events(group_leader, ppmu->n_counter - n0,
-			   &cpuhw->event[n0], &cpuhw->events[n0],
-			   &cpuhw->flags[n0]);
-	if (n < 0)
-		return -EAGAIN;
-	if (check_excludes(cpuhw->event, cpuhw->flags, n0, n))
-		return -EAGAIN;
-	i = power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n + n0);
-	if (i < 0)
-		return -EAGAIN;
-	cpuhw->n_events = n0 + n;
-	cpuhw->n_added += n;
-
-	/*
-	 * OK, this group can go on; update event states etc.,
-	 * and enable any software events
-	 */
-	for (i = n0; i < n0 + n; ++i)
-		cpuhw->event[i]->hw.config = cpuhw->events[i];
-	cpuctx->active_oncpu += n;
-	n = 1;
-	event_sched_in(group_leader);
-	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
-		if (sub->state != PERF_EVENT_STATE_OFF) {
-			event_sched_in(sub);
-			++n;
-		}
-	}
-	ctx->nr_active += n;
-
-	return 1;
-}
-
 /*
  * Add a event to the PMU.
  * If all events are not already frozen, then we disable and
@@ -805,11 +747,21 @@ static int power_pmu_enable(struct perf_event *event)
 	cpuhw->event[n0] = event;
 	cpuhw->events[n0] = event->hw.config;
 	cpuhw->flags[n0] = event->hw.event_base;
+
+	/*
+	 * If group events scheduling transaction was started,
+	 * skip the schedulability test here, it will be peformed
+	 * at commit time(->commit_group_trans) as a whole
+	 */
+	if (cpuhw->group_flag & PERF_EVENT_TRAN_STARTED)
+		goto nocheck;
+
 	if (check_excludes(cpuhw->event, cpuhw->flags, n0, 1))
 		goto out;
 	if (power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n0 + 1))
 		goto out;
 
+nocheck:
 	event->hw.config = cpuhw->events[n0];
 	++cpuhw->n_events;
 	++cpuhw->n_added;
@@ -896,11 +848,61 @@ static void power_pmu_unthrottle(struct perf_event *event)
 	local_irq_restore(flags);
 }
 
+/*
+ * Start group events scheduling transaction
+ * Set the flag to make pmu::enable() not perform the
+ * schedulability test, it will be performed at commit time
+ */
+void power_pmu_start_group_trans(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag |= PERF_EVENT_TRAN_STARTED;
+}
+
+/*
+ * Stop group events scheduling transaction
+ * Clear the flag and pmu::enable() will perform the
+ * schedulability test.
+ */
+void power_pmu_stop_group_trans(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag &= ~PERF_EVENT_TRAN_STARTED;
+}
+
+/*
+ * Commit group events scheduling transaction
+ * Perform the group schedulability test as a whole
+ * Return 0 if success
+ */
+int power_pmu_commit_group_trans(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw;
+	long i, n;
+
+	if (!ppmu)
+		return -EAGAIN;
+	cpuhw = &__get_cpu_var(cpu_hw_events);
+	n = cpuhw->n_events;
+	if (check_excludes(cpuhw->event, cpuhw->flags, 0, n))
+		return -EAGAIN;
+	i = power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n);
+	if (i < 0)
+		return -EAGAIN;
+
+	return 0;
+}
+
 struct pmu power_pmu = {
-	.enable		= power_pmu_enable,
-	.disable	= power_pmu_disable,
-	.read		= power_pmu_read,
-	.unthrottle	= power_pmu_unthrottle,
+	.enable			= power_pmu_enable,
+	.disable		= power_pmu_disable,
+	.read			= power_pmu_read,
+	.unthrottle		= power_pmu_unthrottle,
+	.start_group_trans	= power_pmu_start_group_trans,
+	.stop_group_trans	= power_pmu_stop_group_trans,
+	.commit_group_trans	= power_pmu_commit_group_trans,
 };
 
 /*


