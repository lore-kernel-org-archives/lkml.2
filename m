Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0EYNV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:21:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab0EYNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:21:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=jAOV0BntHPT1SKvv5NlW2FYKyKVTmej7hig46soyTVWcg/MImZWKACGJIah+T/vwX
	cu+/MPhFR0ZMACZMcacpg==
Message-ID: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 25 May 2010 15:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, ming.m.lin@intel.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: fix event scheduling issues introduced by transactional API (take 2)
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

The patch modifies the generic and X86 code to avoid all those problems.

First, we keep track of the number of events added last. In case the
transaction fails, we substract them from n_added. This approach is
necessary (as opposed to delaying updates to n_added) because not all
event updates use the transaction API, e.g., single events.

Second, we encapsulate the event_sched_in() and event_sched_out() in
group_sched_in() inside the transaction. That makes the operations
symmetrical and you can also detect that you are inside a transaction
and skip the HW reg access by checking cpuc->group_flag.

With this patch, you can now overcommit the PMU even with pinned
system-wide events present and still get valid counts.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c775860..3ea4c5c 100644
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
@@ -983,6 +984,7 @@ static int x86_pmu_enable(struct perf_event *event)
 out:
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
+	cpuc->n_events_trans = n - n0;
 
 	return 0;
 }
@@ -1070,7 +1072,7 @@ static void x86_pmu_stop(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	if (!__test_and_clear_bit(idx, cpuc->active_mask))
+	if (idx == -1 || !__test_and_clear_bit(idx, cpuc->active_mask))
 		return;
 
 	x86_pmu.disable(event);
@@ -1087,14 +1089,30 @@ static void x86_pmu_stop(struct perf_event *event)
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
@@ -1104,7 +1122,8 @@ static void x86_pmu_disable(struct perf_event *event)
 			break;
 		}
 	}
-	perf_event_update_userpage(event);
+	if (no_trans)
+		perf_event_update_userpage(event);
 }
 
 static int x86_pmu_handle_irq(struct pt_regs *regs)
@@ -1391,6 +1410,14 @@ static void x86_pmu_cancel_txn(const struct pmu *pmu)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN_STARTED;
+
+	/*
+	 * adjust for failed transaction
+	 * failed if n_events_trans != 0
+	 */
+	cpuc->n_added -= cpuc->n_events_trans;
+
+	cpuc->n_events_trans = 0;
 }
 
 /*
@@ -1419,6 +1446,14 @@ static int x86_pmu_commit_txn(const struct pmu *pmu)
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
+	/*
+	 * transaction succeeded, no need to adjust
+	 * n_added on cancel_txn()
+	 *
+	 * adjust in cancel_txn for cases with failures
+	 * before we reach commit_txn()
+	 */
+	cpuc->n_events_trans = 0;
 	return 0;
 }
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e099650..b521a0b 100644
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
 
