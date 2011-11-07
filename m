Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1KGLB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:01:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49965 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab1KGLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:01:55 -0500
Date: Mon, 7 Nov 2011 12:01:49 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: robert.richter@amd.com, peterz@infradead.org, mingo@elte.hu,
        ming.m.lin@intel.com, ak@linux.intel.com
Subject: [PATCH] perf_events: fix and improve x86 event scheduling
Message-ID: <20111107110149.GA5177@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Major rewrite of the x86 event scheduling routine.
The routine is shared between AMD and Intel.

The existing code had an issue with certain combinations
of constraints. As Robert Richter @ AMD demonstrated on
AMD Bulldozer:

e0 [3,0]
e1 [2:0]
e2 [2:0]
e3 [2:0]

With this list of events, the existing scheduling algorithm
would never schedule e3. That's because it would always choose
counter 0 for e0:
  e0 -> 0
  e1 -> 1
  e2 -> 2
  e3 -> X

Robert Richter proposed a fix to the algorithm which was based
on tagging constraints that overlap. He was using rollbacks to
simulate recursion.

We propose an alternate solution which is simpler, faster. This
is a small modification to the existing algorithm. It adds some
smart in how a counter is chosen for a given event. The first
available counter is not systemtically selected. Instead, the
algorithm checks how the constraints between the events overlap.
For each counter, it assigns a weight which is the number of events
which it can count for the event set. For each event, the algorithm
assigns the counter with the smallest weight first.

In the example above, the new algoritm assigns:
  e0 -> 3
  e1 -> 0
  e2 -> 1
  e3 -> 2

Because:
  counter 0, weight = 4
  counter 1, weight = 3
  counter 2, weight = 3
  counter 3, weight = 1

We maximize PMU usage and ensure all events are measured.

The patch also restructures the code to separate scheduling of
constrained vs. unconstrained events. An unconstrained event is
one that can be programmed into any of the generic counters. For
those, we now use the simplest algorihtm possible: use next free
counter. There is now a fast path which is beneficial on
processors such as AMD64 Fam10h.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6408910..95cca3c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -488,60 +488,37 @@ static inline int is_x86_event(struct perf_event *event)
 	return event->pmu == &pmu;
 }
 
-int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
+static int
+x86_sched_constrained(struct perf_event **c_events, int num_c,
+		  struct event_constraint **constraints,
+		  int n,
+		  unsigned long *used_mask,
+		  int *assign)
 {
-	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
-	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	int i, j, w, wmax, num = 0;
-	struct hw_perf_event *hwc;
-
-	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
-
-	for (i = 0; i < n; i++) {
-		c = x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
-		constraints[i] = c;
-	}
+	struct event_constraint *c;
+	struct perf_event **e;
+	int wcnt[X86_PMC_IDX_MAX];
+	int i, j, w, wmax, num;
+	int map_idx;
+	int min_wcnt, wcnt_idx;
 
+	memset(wcnt, 0, sizeof(wcnt));
 	/*
-	 * fastpath, try to reuse previous register
+	 * compute counter weight: given a set of event constraints, the weight
+	 * represents the number of events which can be programmed on a counter
 	 */
 	for (i = 0; i < n; i++) {
-		hwc = &cpuc->event_list[i]->hw;
 		c = constraints[i];
-
-		/* never assigned */
-		if (hwc->idx == -1)
-			break;
-
-		/* constraint still honored */
-		if (!test_bit(hwc->idx, c->idxmsk))
-			break;
-
-		/* not already used */
-		if (test_bit(hwc->idx, used_mask))
-			break;
-
-		__set_bit(hwc->idx, used_mask);
-		if (assign)
-			assign[i] = hwc->idx;
+		for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
+			wcnt[j]++;
+		}
 	}
-	if (i == n)
-		goto done;
 
 	/*
-	 * begin slow path
-	 */
-
-	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
-
-	/*
-	 * weight = number of possible counters
+	 * constraint weight = number of possible counters for an event
 	 *
 	 * 1    = most constrained, only works on one counter
 	 * wmax = least constrained, works on any counter
-	 *
-	 * assign events to counters starting with most
-	 * constrained events.
 	 */
 	wmax = x86_pmu.num_counters;
 
@@ -553,42 +530,179 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	if (x86_pmu.num_counters_fixed)
 		wmax++;
 
-	for (w = 1, num = n; num && w <= wmax; w++) {
-		/* for each event */
-		for (i = 0; num && i < n; i++) {
-			c = constraints[i];
-			hwc = &cpuc->event_list[i]->hw;
+	/*
+	 * assign from most constrained to least constrained
+	 */
+	for (w = 1, num = num_c; num && w <= wmax; w++) {
+		/* for each constrained event */
+		for (i = 0, e = c_events; i < num_c; i++, e++) {
+
+			map_idx = (*e)->hw.map_idx;
+			c = constraints[map_idx];
 
 			if (c->weight != w)
 				continue;
 
+			min_wcnt = INT_MAX;
+			wcnt_idx = -1;
+			/*
+			 * scan all possible counters for this event
+			 * but use the one with the smallest counter weight,
+			 * i.e., give a chance to other less constrained events
+			 */
 			for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
-				if (!test_bit(j, used_mask))
-					break;
-			}
 
-			if (j == X86_PMC_IDX_MAX)
+				if (test_bit(j, used_mask))
+					continue;
+
+				if (wcnt[j] < min_wcnt) {
+					min_wcnt = wcnt[j];
+					wcnt_idx = j;
+				}
+			}
+			if (wcnt_idx == -1)
 				break;
 
-			__set_bit(j, used_mask);
+			__set_bit(wcnt_idx, used_mask);
 
 			if (assign)
-				assign[i] = j;
-			num--;
+				assign[map_idx] = wcnt_idx;
+
+			/* marked used */
+			wcnt[wcnt_idx] = INT_MAX;
+
+			if (--num == 0)
+				break;
+		}
+	}
+	return num;
+}
+
+static int x86_sched_unconstrained(struct perf_event **events,
+				   int num_u,
+				   int n,
+				   unsigned long *used_mask,
+				   int *assign)
+{
+	unsigned long free_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	struct perf_event **e = events + n - num_u;
+	int i;
+
+	/*
+	 * it is faster to stick with X86_PMC_IDX_MAX which is a
+	 * power of 2 rather than trying to limit complement to
+	 * actual number of counters
+	 */
+	bitmap_complement(free_mask, used_mask, X86_PMC_IDX_MAX);
+
+	/*
+	 * faster to use X86_PMC_IDX_MAX rather than the actual
+	 * number of counters. We bail out once all events have
+	 * been assigned anyway.
+	 */
+	for_each_set_bit(i, free_mask, X86_PMC_IDX_MAX) {
+		if (i >= x86_pmu.num_counters)
+			break;
+		if (assign)
+			assign[(*e)->hw.map_idx] = i;
+		if (--num_u == 0)
+			break;
+		e++;
+	}
+	return num_u;
+}
+
+
+int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
+{
+	struct event_constraint **c;
+	struct event_constraint *constraints[X86_PMC_IDX_MAX];
+	struct perf_event *events[X86_PMC_IDX_MAX];
+	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int i;
+	int num_c = 0, num_u = 0;
+	struct hw_perf_event *hwc;
+
+	/*
+	 * collect event constraints
+	 * separate constrained vs. unconstrained events
+	 *
+	 * map_idx = actual index in event_list and assign arrays
+	 *
+	 * we add constrained events from index 0 to n
+	 * we add unconstrained events from index n - 1 to 0
+	 * that way we save stack memory by not defining two arrays
+	 */
+	for (i = 0; i < n; i++) {
+		constraints[i] =
+		    x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
+		if (constraints[i] != &unconstrained) {
+			events[num_c] = cpuc->event_list[i];
+			events[num_c]->hw.map_idx = i;
+			num_c++;
+		} else {
+			events[n - num_u - 1] = cpuc->event_list[i];
+			events[n - num_u - 1]->hw.map_idx = i;
+			num_u++;
 		}
 	}
+	/*
+	 * fastpath: try to reuse previous assignments
+	 */
+	for (i = 0, c = constraints; i < n; i++, c++) {
+		hwc = &cpuc->event_list[i]->hw;
+
+		/* never assigned, must go to slow path */
+		if (hwc->idx == -1)
+			break;
+
+		/* constraint still honored */
+		if (!test_bit(hwc->idx, (*c)->idxmsk))
+			break;
+
+		/* counter not already used */
+		if (test_bit(hwc->idx, used_mask))
+			break;
+
+		__set_bit(hwc->idx, used_mask);
+		if (assign)
+			assign[i] = hwc->idx;
+	}
+	/* was able to reuse every counter, we're done */
+	if (i == n) {
+		num_u = num_c = 0;
+		goto done;
+	}
+
+	/*
+	 * begin slow path
+	 */
+	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
+
+	/* schedule constrained events */
+	if (num_c)
+		num_c = x86_sched_constrained(events,
+					      num_c,
+					      constraints,
+					      n, used_mask, assign);
+
+	/* schedule unconstrained events */
+	if (num_u)
+		num_u = x86_sched_unconstrained(events,
+						num_u,
+						n, used_mask, assign);
 done:
 	/*
 	 * scheduling failed or is just a simulation,
 	 * free resources if necessary
 	 */
-	if (!assign || num) {
+	if (!assign || num_u || num_c) {
 		for (i = 0; i < n; i++) {
 			if (x86_pmu.put_event_constraints)
 				x86_pmu.put_event_constraints(cpuc, cpuc->event_list[i]);
 		}
 	}
-	return num ? -ENOSPC : 0;
+	return num_c || num_u ? -ENOSPC : 0;
 }
 
 /*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e9ebe5..2605244 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -564,6 +564,7 @@ struct hw_perf_event {
 			int		idx;
 			int		last_cpu;
 			struct hw_perf_event_extra extra_reg;
+			int		map_idx;
 		};
 		struct { /* software */
 			struct hrtimer	hrtimer;
