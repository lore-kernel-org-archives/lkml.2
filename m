Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0DVHu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:50:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:36228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0DVHuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:50:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,254,1270450800"; 
   d="scan'208";a="615474432"
Subject: [RFC][PATCH 4/4] perf: sparc, implement group scheduling
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
Date: Thu, 22 Apr 2010 15:51:17 +0800
Message-Id: <1271922677.30535.110.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: sparc, implement group scheduling transactional APIs
    
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/sparc/kernel/perf_event.c |   95 ++++++++++++++++++++--------------------
 1 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index e277193..48a6f91 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -91,6 +91,8 @@ struct cpu_hw_events {
 
 	/* Enabled/disable state.  */
 	int			enabled;
+
+	u8			group_flag;
 };
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = { .enabled = 1, };
 
@@ -980,53 +982,6 @@ static int collect_events(struct perf_event *group, int max_count,
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
-int hw_perf_group_sched_in(struct perf_event *group_leader,
-			   struct perf_cpu_context *cpuctx,
-			   struct perf_event_context *ctx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct perf_event *sub;
-	int n0, n;
-
-	if (!sparc_pmu)
-		return 0;
-
-	n0 = cpuc->n_events;
-	n = collect_events(group_leader, perf_max_events - n0,
-			   &cpuc->event[n0], &cpuc->events[n0],
-			   &cpuc->current_idx[n0]);
-	if (n < 0)
-		return -EAGAIN;
-	if (check_excludes(cpuc->event, n0, n))
-		return -EINVAL;
-	if (sparc_check_constraints(cpuc->event, cpuc->events, n + n0))
-		return -EAGAIN;
-	cpuc->n_events = n0 + n;
-	cpuc->n_added += n;
-
-	cpuctx->active_oncpu += n;
-	n = 1;
-	event_sched_in(group_leader);
-	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
-		if (sub->state != PERF_EVENT_STATE_OFF) {
-			event_sched_in(sub);
-			n++;
-		}
-	}
-	ctx->nr_active += n;
-
-	return 1;
-}
-
 static int sparc_pmu_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1044,11 +999,15 @@ static int sparc_pmu_enable(struct perf_event *event)
 	cpuc->events[n0] = event->hw.event_base;
 	cpuc->current_idx[n0] = PIC_NO_INDEX;
 
+	if (cpuhw->group_flag & PERF_EVENT_TRAN_STARTED)
+		goto nocheck;
+
 	if (check_excludes(cpuc->event, n0, 1))
 		goto out;
 	if (sparc_check_constraints(cpuc->event, cpuc->events, n0 + 1))
 		goto out;
 
+nocheck:
 	cpuc->n_events++;
 	cpuc->n_added++;
 
@@ -1128,11 +1087,53 @@ static int __hw_perf_event_init(struct perf_event *event)
 	return 0;
 }
 
+/*
+ * Set the flag to make pmu::enable() not perform the
+ * schedulablilty test.
+ */
+static void sparc_pmu_start_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag |= PERF_EVENT_TRAN_STARTED;
+}
+
+static void sparc_pmu_stop_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag &= ~PERF_EVENT_TRAN_STARTED;
+}
+
+/*
+ * Return 0 if commit transaction success
+ */
+static int sparc_pmu_commit_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int n;
+
+	if (!sparc_pmu)
+		return -EINVAL;
+
+	cpuc = &__get_cpu_var(cpu_hw_events);
+	n = cpuc->n_events;
+	if (check_excludes(cpuc->event, 0, n))
+		return -EINVAL;
+	if (sparc_check_constraints(cpuc->event, cpuc->events, n))
+		return -EAGAIN;
+
+	return 0;
+}
+
 static const struct pmu pmu = {
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
 	.read		= sparc_pmu_read,
 	.unthrottle	= sparc_pmu_unthrottle,
+	.start_txn	= sparc_pmu_start_txn,
+	.stop_txn	= sparc_pmu_stop_txn,
+	.commit_txn	= sparc_pmu_commit_txn,
 };
 
 const struct pmu *hw_perf_event_init(struct perf_event *event)


