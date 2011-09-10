Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab1IJOyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 10:54:33 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:5994
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933087Ab1IJOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 10:54:32 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRBAQM-02-22N-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/2] perf, x86: Fix event scheduler for constraints with
Date: Sat, 10 Sep 2011 16:49:03 +0200
Message-ID: <1315666143-7106-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315666143-7106-1-git-send-email-robert.richter@amd.com>
References: <1315666143-7106-1-git-send-email-robert.richter@amd.com>
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

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |   78 ++++++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 2 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 44ec767..096744f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -74,6 +74,7 @@ struct event_constraint {
 	u64	code;
 	u64	cmask;
 	int	weight;
+	int	overlap;
 };
 
 struct amd_nb {
@@ -133,15 +134,40 @@ struct cpu_hw_events {
 	void			*kfree_on_online;
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
@@ -798,11 +824,17 @@ struct sched_state {
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
+
+	int			saved_states;
+	struct sched_state	saved[SCHED_STATES_MAX];
 };
 
 static void perf_sched_init(struct perf_sched *sched, struct event_constraint **c,
@@ -817,7 +849,30 @@ static void perf_sched_init(struct perf_sched *sched, struct event_constraint **
 	sched->state.unassigned	= num;
 }
 
-static struct sched_state *perf_sched_find_counter(struct perf_sched *sched)
+static void perf_sched_save_state(struct perf_sched *sched)
+{
+	if (sched->saved_states >= SCHED_STATES_MAX)
+		return;
+
+	sched->saved[sched->saved_states] = sched->state;
+	sched->saved_states++;
+}
+
+static int perf_sched_restore_state(struct perf_sched *sched)
+{
+	if (!sched->saved_states)
+		return 0;
+
+	sched->saved_states--;
+	sched->state = sched->saved[sched->saved_states];
+
+	/* continue with next counter: */
+	clear_bit(sched->state.counter++, sched->state.used);
+
+	return 1;
+}
+
+static struct sched_state *__perf_sched_find_counter(struct perf_sched *sched)
 {
 	struct event_constraint *c;
 	int idx;
@@ -842,9 +897,24 @@ static struct sched_state *perf_sched_find_counter(struct perf_sched *sched)
 	if (idx >= X86_PMC_IDX_MAX)
 		return NULL;
 
+	if (c->overlap)
+		perf_sched_save_state(sched);
+
 	return &sched->state;
 }
 
+static struct sched_state *perf_sched_find_counter(struct perf_sched *sched)
+{
+	struct sched_state *state;
+
+	while (!(state = __perf_sched_find_counter(sched))) {
+		if (!perf_sched_restore_state(sched))
+			break;
+	}
+
+	return state;
+}
+
 static int perf_sched_next_event(struct perf_sched *sched)
 {
 	struct event_constraint *c;
@@ -1621,7 +1691,7 @@ static int __init init_hw_perf_events(void)
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
-				   0, x86_pmu.num_counters);
+				   0, x86_pmu.num_counters, 0);
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index ee9436c..7c259e0 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -473,7 +473,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
 static struct event_constraint amd_f15_PMC20 = EVENT_CONSTRAINT(0, 0x07, 0);
 static struct event_constraint amd_f15_PMC3  = EVENT_CONSTRAINT(0, 0x08, 0);
-static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT(0, 0x09, 0);
+static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09, 0);
 static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 
-- 
1.7.6.1


