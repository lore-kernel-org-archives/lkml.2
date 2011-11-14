Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1KNRwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:52:39 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:49418
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755625Ab1KNRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:52:38 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUNWBH-02-47D-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v3 2/2] perf, x86: Fix event scheduler for constraints with overlapping counters
Date: Mon, 14 Nov 2011 18:51:11 +0100
Message-ID: <1321293071-8636-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1321293071-8636-1-git-send-email-robert.richter@amd.com>
References: <20111111142935.GI15738@erda.amd.com>
 <1321293071-8636-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
overlap flag. We set the overlap flag for such constraints to give the
scheduler a hint which events to select for counter rescheduling. The
EVENT_CONSTRAINT_OVERLAP() macro can be used for this.

Care must be taken as the rescheduling algorithm is O(n!) which will
increase scheduling cycles for an over-commited system dramatically.
The number of such EVENT_CONSTRAINT_OVERLAP() macros and its counter
masks must be kept at a minimum. Thus, the current stack is limited to
2 states to limit the number of loops the algorithm takes in the worst
case.

On systems with no overlapping-counter constraints, this
implementation does not increase the loop count compared to the
previous algorithm.

V2:
* Renamed redo -> overlap.
* Reimplementation using perf scheduling helper functions.

V3:
* Added WARN_ON_ONCE() if out of save states.
* Changed function interface of perf_sched_restore_state() to use bool
  as return value.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |   45 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event.h     |   30 +++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 3 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ad73725..68baed0e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -503,11 +503,16 @@ struct sched_state {
 	unsigned long used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 };
 
+/* Total max is X86_PMC_IDX_MAX, but we are O(n!) limited */
+#define	SCHED_STATES_MAX	2
+
 struct perf_sched {
 	int			max_weight;
 	int			max_events;
 	struct event_constraint	**constraints;
 	struct sched_state	state;
+	int			saved_states;
+	struct sched_state	saved[SCHED_STATES_MAX];
 };
 
 /*
@@ -525,11 +530,34 @@ static void perf_sched_init(struct perf_sched *sched, struct event_constraint **
 	sched->state.unassigned	= num;
 }
 
+static void perf_sched_save_state(struct perf_sched *sched)
+{
+	if (WARN_ON_ONCE(sched->saved_states >= SCHED_STATES_MAX))
+		return;
+
+	sched->saved[sched->saved_states] = sched->state;
+	sched->saved_states++;
+}
+
+static bool perf_sched_restore_state(struct perf_sched *sched)
+{
+	if (!sched->saved_states)
+		return false;
+
+	sched->saved_states--;
+	sched->state = sched->saved[sched->saved_states];
+
+	/* continue with next counter: */
+	clear_bit(sched->state.counter++, sched->state.used);
+
+	return true;
+}
+
 /*
  * Select a counter for the current event to schedule. Return true on
  * success.
  */
-static bool perf_sched_find_counter(struct perf_sched *sched)
+static bool __perf_sched_find_counter(struct perf_sched *sched)
 {
 	struct event_constraint *c;
 	int idx;
@@ -550,6 +578,19 @@ static bool perf_sched_find_counter(struct perf_sched *sched)
 	if (idx >= X86_PMC_IDX_MAX)
 		return false;
 
+	if (c->overlap)
+		perf_sched_save_state(sched);
+
+	return true;
+}
+
+static bool perf_sched_find_counter(struct perf_sched *sched)
+{
+	while (!__perf_sched_find_counter(sched)) {
+		if (!perf_sched_restore_state(sched))
+			return false;
+	}
+
 	return true;
 }
 
@@ -1243,7 +1284,7 @@ static int __init init_hw_perf_events(void)
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
-				   0, x86_pmu.num_counters);
+				   0, x86_pmu.num_counters, 0);
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index b9698d4..51a985c 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -45,6 +45,7 @@ struct event_constraint {
 	u64	code;
 	u64	cmask;
 	int	weight;
+	int	overlap;
 };
 
 struct amd_nb {
@@ -151,15 +152,40 @@ struct cpu_hw_events {
 	void				*kfree_on_online;
 };
 
-#define __EVENT_CONSTRAINT(c, n, m, w) {\
+#define __EVENT_CONSTRAINT(c, n, m, w, o) {\
 	{ .idxmsk64 = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
 	.weight = (w),			\
+	.overlap = (o),			\
 }
 
 #define EVENT_CONSTRAINT(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0)
+
+/*
+ * The overlap flag marks event constraints with overlapping counter
+ * masks. This is the case if the counter mask of such an event is not
+ * a subset of any other counter mask of a constraint with an equal or
+ * higher weight, e.g.:
+ *
+ *  c_overlaps = EVENT_CONSTRAINT_OVERLAP(0, 0x09, 0);
+ *  c_another1 = EVENT_CONSTRAINT(0, 0x07, 0);
+ *  c_another2 = EVENT_CONSTRAINT(0, 0x38, 0);
+ *
+ * The event scheduler may not select the correct counter in the first
+ * cycle because it needs to know which subsequent events will be
+ * scheduled. It may fail to schedule the events then. So we set the
+ * overlap flag for such constraints to give the scheduler a hint which
+ * events to select for counter rescheduling.
+ *
+ * Care must be taken as the rescheduling algorithm is O(n!) which
+ * will increase scheduling cycles for an over-commited system
+ * dramatically.  The number of such EVENT_CONSTRAINT_OVERLAP() macros
+ * and its counter masks must be kept at a minimum.
+ */
+#define EVENT_CONSTRAINT_OVERLAP(c, n, m)	\
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 1)
 
 /*
  * Constraint on the Event code.
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index aeefd45..0397b23 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -492,7 +492,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
 static struct event_constraint amd_f15_PMC20 = EVENT_CONSTRAINT(0, 0x07, 0);
 static struct event_constraint amd_f15_PMC3  = EVENT_CONSTRAINT(0, 0x08, 0);
-static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT(0, 0x09, 0);
+static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09, 0);
 static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 
-- 
1.7.7


