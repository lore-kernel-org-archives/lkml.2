Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1DSK0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:26:17 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:27778
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753637Ab1DSK0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:26:14 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzef8Kzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJWABD-02-5XL-02
X-M-MSG: 
Date: Tue, 19 Apr 2011 12:26:00 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
Message-ID: <20110419102600.GU31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1302913676-14352-5-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version 2 implements an algorithm which does not increase the
loop count for systems with no overlapping-counter constraints. With
overlapping-counter constraints the loop count is reduceded to the
minimum and also limited by a stack depth of 2 states.

See below.

-Robert


>From cd70a579995fa7da885ec25db8ebe04ba4a0c30e Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 15 Apr 2011 11:04:06 +0200
Subject: [PATCH] perf, x86: Fix event scheduler for constraints with overlapping counters

The current x86 event scheduler fails to resolve scheduling problems
of certain combinations of events and constraints. This happens if the
counter mask of such an event is not a subset of any other counter
mask of a constraint with an equal or higher weight, e.g. constraints
of the AMD family 15h pmu:

                        counter mask    weight

 amd_f15_PMC30          0x09            2  <--- overlapping counters
 amd_f15_PMC20          0x07            3
 amd_f15_PMC53          0x38            3

The scheduler does not find then an existing solution. Here is an
example:

 event code     counter         failure         possible solution

 0x02E          PMC[3,0]        0               3
 0x043          PMC[2:0]        1               0
 0x045          PMC[2:0]        2               1
 0x046          PMC[2:0]        FAIL            2

The event scheduler may not select the correct counter in the first
cycle because it needs to know which subsequent events will be
scheduled. It may fail to schedule the events then.

To solve this, we now save the scheduler state of events with
overlapping counter counstraints.  If we fail to schedule the events
we rollback to those states and try to use another free counter.

Constraints with overlapping counters are marked with a new introduced
redo flag. We set the redo flag for such constraints to give the
scheduler a hint which events to select for counter rescheduling. The
EVENT_CONSTRAINT_REDO() macro can be used for this.

Care must be taken as the rescheduling algorithm is O(n!) which will
increase scheduling cycles for an over-commited system dramatically.
The number of such EVENT_CONSTRAINT_REDO() macros and its counter
masks must be kept at a minimum. Thus, the current stack is limited to
2 states to limit the number of loops the algorithm takes in the worst
case.

On systems with no overlapping-counter constraints, this
implementation does not increase the loop count compared to the
previous algorithm.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |   97 ++++++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 2 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 224a84f..2d4cfae 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -86,6 +86,7 @@ struct event_constraint {
 	u64	code;
 	u64	cmask;
 	int	weight;
+	int	redo;
 };
 
 struct amd_nb {
@@ -144,15 +145,40 @@ struct cpu_hw_events {
 	struct amd_nb		*amd_nb;
 };
 
-#define __EVENT_CONSTRAINT(c, n, m, w) {\
+#define __EVENT_CONSTRAINT(c, n, m, w, r) {\
 	{ .idxmsk64 = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
 	.weight = (w),			\
+	.redo = (r),			\
 }
 
 #define EVENT_CONSTRAINT(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0)
+
+/*
+ * The redo flag marks event constraints with overlapping counter
+ * masks. This is the case if the counter mask of such an event is not
+ * a subset of any other counter mask of a constraint with an equal or
+ * higher weight, e.g.:
+ *
+ *  c_overlaps = EVENT_CONSTRAINT_REDO(0, 0x09, 0);
+ *  c_another1 = EVENT_CONSTRAINT(0, 0x07, 0);
+ *  c_another2 = EVENT_CONSTRAINT(0, 0x38, 0);
+ *
+ * The event scheduler may not select the correct counter in the first
+ * cycle because it needs to know which subsequent events will be
+ * scheduled. It may fail to schedule the events then. So we set the
+ * redo flag for such constraints to give the scheduler a hint which
+ * events to select for counter rescheduling.
+ *
+ * Care must be taken as the rescheduling algorithm is O(n!) which
+ * will increase scheduling cycles for an over-commited system
+ * dramatically.  The number of such EVENT_CONSTRAINT_REDO() macros
+ * and its counter masks must be kept at a minimum.
+ */
+#define EVENT_CONSTRAINT_REDO(c, n, m)	\
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 1)
 
 /*
  * Constraint on the Event code.
@@ -770,11 +796,24 @@ static inline int is_x86_event(struct perf_event *event)
 	return event->pmu == &pmu;
 }
 
+struct sched_state
+{
+	int	i;
+	int	w;
+	int	idx;
+	int	num;
+	unsigned long used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+};
+
+/* Total max is X86_PMC_IDX_MAX, but we are O(n!) limited */
+#define	SCHED_STATES_MAX	2
+
 static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	int i, j, w, wmax, num = 0;
+	struct sched_state sched_state[SCHED_STATES_MAX];
+	int i, idx, w, wmax, num = 0, state = 0;
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
@@ -838,25 +877,61 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	for (w = 1, num = n; num && w <= wmax; w++) {
 		/* for each event */
 		for (i = 0; num && i < n; i++) {
+			idx = 0;
+		redo:
 			c = constraints[i];
 			hwc = &cpuc->event_list[i]->hw;
 
 			if (c->weight != w)
 				continue;
 
-			for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
-				if (!test_bit(j, used_mask))
+			/* for each bit in idxmsk starting from idx */
+			while (idx < X86_PMC_IDX_MAX) {
+				idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX,
+						    idx);
+				if (idx == X86_PMC_IDX_MAX)
 					break;
+				if (!__test_and_set_bit(idx, used_mask))
+					break;
+				idx++;
 			}
 
-			if (j == X86_PMC_IDX_MAX)
-				break;
-
-			__set_bit(j, used_mask);
+			if (idx >= X86_PMC_IDX_MAX) {
+				/*
+				 * roll back and try to reschedule
+				 * events on other counters
+				 */
+				if (!state)
+					/* no events to reschedule */
+					goto done;
+				state--;
+				/* restore previous state: */
+				i = sched_state[state].i;
+				w = sched_state[state].w;
+				idx = sched_state[state].idx;
+				num = sched_state[state].num;
+				bitmap_copy(used_mask, sched_state[state].used, n);
+				/* try next counter: */
+				clear_bit(idx, used_mask);
+				num++;
+				idx++;
+				goto redo;
+			}
 
 			if (assign)
-				assign[i] = j;
+				assign[i] = idx;
+
 			num--;
+
+			if (c->redo && state < SCHED_STATES_MAX) {
+				/* store scheduler state: */
+				sched_state[state].i = i;
+				sched_state[state].w = w;
+				sched_state[state].idx = idx;
+				sched_state[state].num = num;
+				bitmap_copy(sched_state[state].used, used_mask, n);
+				state++;
+			}
 		}
 	}
 done:
@@ -1535,7 +1610,7 @@ static int __init init_hw_perf_events(void)
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
-				   0, x86_pmu.num_counters);
+				   0, x86_pmu.num_counters, 0);
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 758cccc..21821eb 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -457,7 +457,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
 static struct event_constraint amd_f15_PMC20 = EVENT_CONSTRAINT(0, 0x07, 0);
 static struct event_constraint amd_f15_PMC3  = EVENT_CONSTRAINT(0, 0x08, 0);
-static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT(0, 0x09, 0);
+static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_REDO(0, 0x09, 0);
 static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 
-- 
1.7.3.4


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

