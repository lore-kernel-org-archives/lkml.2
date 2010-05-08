Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab0EHK6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 06:58:13 -0400
Received: from ozlabs.org ([203.10.76.45]:41464 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0EHK6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 06:58:10 -0400
Date: Sat, 8 May 2010 20:28:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Add group scheduling transactional APIs
Message-ID: <20100508102841.GA10650@brick.ozlabs.ibm.com>
References: <1272002160.5707.60.camel@minggr.sh.intel.com>
 <tip-6bde9b6ce0127e2a56228a2071536d422be31336@git.kernel.org>
 <1273269355.1642.383.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273269355.1642.383.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 11:55:55PM +0200, Peter Zijlstra wrote:

> Paul, are you ok with the powerpc patch that goes with this:
>   https://patchwork.kernel.org/patch/94620/
> 
> (I've got a slightly modified version because I did rename things back
> to txn)

That version doesn't update event->hw.config properly; the thing is
that some events have multiple event codes that count the same thing
but have different constraints (e.g. one code might only work on one
hardware counter whereas another might work on any counter but
constrain what can be counted on other counters).

So power_check_constraints() searches through the space of possible
alternative codes and returns the results in cpuhw->events[].  I then
put the alternatives chosen back into each event->hw.config to use as
the starting point for the search next time.  This means that
event->hw.config has to be updated after power_check_constraints() has
been called in power_pmu_commit_txn, not in the no-check case in
power_pmu_enable().

Here's the patch I ended up with.

--------------
Subject: perf, powerpc: Implement group scheduling transactional APIs
From: Lin Ming <ming.m.lin@intel.com>

[paulus@samba.org: Set cpuhw->event[i]->hw.config in
power_pmu_commit_txn.]

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 08460a2..43b83c3 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -35,6 +35,9 @@ struct cpu_hw_events {
 	u64 alternatives[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
 	unsigned long amasks[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
 	unsigned long avalues[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
+
+	unsigned int group_flag;
+	int n_txn_start;
 };
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 
@@ -718,66 +721,6 @@ static int collect_events(struct perf_event *group, int max_count,
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
@@ -805,12 +748,22 @@ static int power_pmu_enable(struct perf_event *event)
 	cpuhw->event[n0] = event;
 	cpuhw->events[n0] = event->hw.config;
 	cpuhw->flags[n0] = event->hw.event_base;
+
+	/*
+	 * If group events scheduling transaction was started,
+	 * skip the schedulability test here, it will be peformed
+	 * at commit time(->commit_txn) as a whole
+	 */
+	if (cpuhw->group_flag & PERF_EVENT_TXN_STARTED)
+		goto nocheck;
+
 	if (check_excludes(cpuhw->event, cpuhw->flags, n0, 1))
 		goto out;
 	if (power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n0 + 1))
 		goto out;
-
 	event->hw.config = cpuhw->events[n0];
+
+nocheck:
 	++cpuhw->n_events;
 	++cpuhw->n_added;
 
@@ -896,11 +849,65 @@ static void power_pmu_unthrottle(struct perf_event *event)
 	local_irq_restore(flags);
 }
 
+/*
+ * Start group events scheduling transaction
+ * Set the flag to make pmu::enable() not perform the
+ * schedulability test, it will be performed at commit time
+ */
+void power_pmu_start_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuhw->n_txn_start = cpuhw->n_events;
+}
+
+/*
+ * Stop group events scheduling transaction
+ * Clear the flag and pmu::enable() will perform the
+ * schedulability test.
+ */
+void power_pmu_cancel_txn(const struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	cpuhw->group_flag &= ~PERF_EVENT_TXN_STARTED;
+}
+
+/*
+ * Commit group events scheduling transaction
+ * Perform the group schedulability test as a whole
+ * Return 0 if success
+ */
+int power_pmu_commit_txn(const struct pmu *pmu)
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
+	for (i = cpuhw->n_txn_start; i < n; ++i)
+		cpuhw->event[i]->hw.config = cpuhw->events[i];
+
+	return 0;
+}
+
 struct pmu power_pmu = {
 	.enable		= power_pmu_enable,
 	.disable	= power_pmu_disable,
 	.read		= power_pmu_read,
 	.unthrottle	= power_pmu_unthrottle,
+	.start_txn	= power_pmu_start_txn,
+	.cancel_txn	= power_pmu_cancel_txn,
+	.commit_txn	= power_pmu_commit_txn,
 };
 
 /*
