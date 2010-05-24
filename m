Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0EXOkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:40:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0EXOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:39:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=dDhjsUYJ/wLyrMluLkQQdl+fwKtmRurOLFNkV+OHY+76kCbCJf2kdoXpO+PoD22vb
	/NdeaCR8Ru82J9IeIgOeg==
Message-ID: <4bfa8fb9.d88dd80a.2a28.74b8@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 24 May 2010 16:40:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, ming.m.lin@intel.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: fix event scheduling issues introduced by transactional API
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The transactional API patch between the generic and model-specific
code introduced several important bugs with event scheduling, at
least on X86. If you had pinned events, e.g., watchdog,  and were
over-committing the PMU, you would get bogus counts. The bug was
showing up on Intel CPU because events would move around more
often that on AMD. But the problem also existed on AMD, though
harder to expose.

The issues were:

 - group_sched_in() was missing a cancel_txn() in the error path

 - cpuc->n_added was not properly maintained, leading to missing
   actions in hw_perf_enable(), i.e., n_running being 0. You cannot
   update n_added until you know the transaction has succeeded. In
   case of failed transaction n_added was not adjusted back.

 - in case of failed transactions, event_sched_out() was called
   and eventually invoked x86_disable_event() to touch the HW reg.
   But with transactions, on X86, event_sched_in() does not touch
   HW registers, it simply collects events into a list. Thus, you
   could end up calling x86_disable_event() on a counter which
   did not correspond to the current event when idx != -1.

The patch modifies the generic and X86 code to avoid all those
problems.

First, n_added is now ONLY updated once we know the transaction has
succeeded.

Second, we encapsulate the event_sched_in() and event_sched_out() in
group_sched_in() inside the transaction. That way, in the X6 code, we
can detect that we are being asked to stop an event which was not yet
started by checking cpuc->group_flag.

With this patch, you can now overcommit the PMU even with pinned
system-wide events present and still get valid counts.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fd4db0d..25dfd30 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -105,6 +105,7 @@ struct cpu_hw_events {
 	int			enabled;
 
 	int			n_events;
+	int			n_events_trans;
 	int			n_added;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
@@ -591,7 +592,7 @@ void hw_perf_disable(void)
 	if (!cpuc->enabled)
 		return;
 
-	cpuc->n_added = 0;
+	cpuc->n_added = cpuc->n_events_trans = 0;
 	cpuc->enabled = 0;
 	barrier();
 
@@ -820,7 +821,7 @@ void hw_perf_enable(void)
 		 * apply assignment obtained either from
 		 * hw_perf_group_sched_in() or x86_pmu_enable()
 		 *
-		 * step1: save events moving to new counters
+		 * step1: stop-save old events moving to new counters
 		 * step2: reprogram moved events into new counters
 		 */
 		for (i = 0; i < n_running; i++) {
@@ -982,7 +983,7 @@ static int x86_pmu_enable(struct perf_event *event)
 
 out:
 	cpuc->n_events = n;
-	cpuc->n_added += n - n0;
+	cpuc->n_events_trans += n - n0;
 
 	return 0;
 }
@@ -1070,7 +1071,7 @@ static void x86_pmu_stop(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	if (!__test_and_clear_bit(idx, cpuc->active_mask))
+	if (idx == -1 || !__test_and_clear_bit(idx, cpuc->active_mask))
 		return;
 
 	x86_pmu.disable(event);
@@ -1087,14 +1088,30 @@ static void x86_pmu_stop(struct perf_event *event)
 static void x86_pmu_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	bool no_trans;
 	int i;
 
-	x86_pmu_stop(event);
+	/*
+	 * when coming from a transaction, then the event has not
+	 * actually been scheduled in yet. It has only been collected
+	 * (collect_events), thus we cannot apply a full disable:
+	 * - put_constraints() assumes went thru schedule_events()
+	 * - x86_pmu_stop() assumes went thru x86_pmu_start() because
+	 *   maybe idx != -1 and thus we may overwrite another the wrong
+	 *   counter (e.g, pinned event).
+	 *
+	 * When called from a transaction, we need to un-collect the
+	 * event, i..e, remove the event from event_list[]
+	 */
+	no_trans = !(cpuc->group_flag & PERF_EVENT_TXN_STARTED);
+
+	if (no_trans)
+		x86_pmu_stop(event);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
 
-			if (x86_pmu.put_event_constraints)
+			if (no_trans && x86_pmu.put_event_constraints)
 				x86_pmu.put_event_constraints(cpuc, event);
 
 			while (++i < cpuc->n_events)
@@ -1104,7 +1121,8 @@ static void x86_pmu_disable(struct perf_event *event)
 			break;
 		}
 	}
-	perf_event_update_userpage(event);
+	if (no_trans)
+		perf_event_update_userpage(event);
 }
 
 static int x86_pmu_handle_irq(struct pt_regs *regs)
@@ -1418,7 +1436,8 @@ static int x86_pmu_commit_txn(const struct pmu *pmu)
 	 * will be used by hw_perf_enable()
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
-
+	cpuc->n_added += cpuc->n_events_trans;
+	cpuc->n_events_trans = 0;
 	return 0;
 }
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7e3bcf1..b0ccf4b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -652,8 +652,11 @@ group_sched_in(struct perf_event *group_event,
 	if (txn)
 		pmu->start_txn(pmu);
 
-	if (event_sched_in(group_event, cpuctx, ctx))
+	if (event_sched_in(group_event, cpuctx, ctx)) {
+		if (txn)
+			pmu->cancel_txn(pmu);
 		return -EAGAIN;
+	}
 
 	/*
 	 * Schedule in siblings as one group (if any):
@@ -675,8 +678,6 @@ group_sched_in(struct perf_event *group_event,
 	}
 
 group_error:
-	if (txn)
-		pmu->cancel_txn(pmu);
 
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
@@ -689,6 +690,9 @@ group_error:
 	}
 	event_sched_out(group_event, cpuctx, ctx);
 
+	if (txn)
+		pmu->cancel_txn(pmu);
+
 	return -EAGAIN;
 }
 
