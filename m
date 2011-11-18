Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1KRLgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:36:03 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:21576
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209Ab1KRLf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:35:57 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LUUTJS-02-DWX-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v4 1/2] perf, x86: Implement event scheduler helper functions
Date: Fri, 18 Nov 2011 12:35:21 +0100
Message-ID: <1321616122-1533-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
References: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces x86 perf scheduler code helper functions. We
need this to later add more complex functionality to support
overlapping counter constraints (next patch).

The algorithm is modified so that the range of weight values is now
generated from the constraints. There shouldn't be other functional
changes.

With the helper functions the scheduler is controlled. There are
functions to initialize, traverse the event list, find unused counters
etc. The scheduler keeps its own state.

V3:
* Added macro for_each_set_bit_cont().
* Changed functions interfaces of perf_sched_find_counter() and
  perf_sched_next_event() to use bool as return value.
* Added some comments to make code better understandable.

V4:
* Fix broken event assignment if weight of the first event is not
  wmin (perf_sched_init()).

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |  185 +++++++++++++++++++++++++++-----------
 include/linux/bitops.h           |   10 ++-
 2 files changed, 140 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6408910..02b9020 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -488,18 +488,145 @@ static inline int is_x86_event(struct perf_event *event)
 	return event->pmu == &pmu;
 }
 
+/*
+ * Event scheduler state:
+ *
+ * Assign events iterating over all events and counters, beginning
+ * with events with least weights first. Keep the current iterator
+ * state in struct sched_state.
+ */
+struct sched_state {
+	int	weight;
+	int	event;		/* event index */
+	int	counter;	/* counter index */
+	int	unassigned;	/* number of events to be assigned left */
+	unsigned long used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+};
+
+struct perf_sched {
+	int			max_weight;
+	int			max_events;
+	struct event_constraint	**constraints;
+	struct sched_state	state;
+};
+
+/*
+ * Initialize interator that runs through all events and counters.
+ */
+static void perf_sched_init(struct perf_sched *sched, struct event_constraint **c,
+			    int num, int wmin, int wmax)
+{
+	int idx;
+
+	memset(sched, 0, sizeof(*sched));
+	sched->max_events	= num;
+	sched->max_weight	= wmax;
+	sched->constraints	= c;
+
+	for (idx = 0; idx < num; idx++) {
+		if (c[idx]->weight == wmin)
+			break;
+	}
+
+	sched->state.event	= idx;		/* start with min weight */
+	sched->state.weight	= wmin;
+	sched->state.unassigned	= num;
+}
+
+/*
+ * Select a counter for the current event to schedule. Return true on
+ * success.
+ */
+static bool perf_sched_find_counter(struct perf_sched *sched)
+{
+	struct event_constraint *c;
+	int idx;
+
+	if (!sched->state.unassigned)
+		return false;
+
+	if (sched->state.event >= sched->max_events)
+		return false;
+
+	c = sched->constraints[sched->state.event];
+
+	/* Grab the first unused counter starting with idx */
+	idx = sched->state.counter;
+	for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_MAX) {
+		if (!__test_and_set_bit(idx, sched->state.used))
+			break;
+	}
+	sched->state.counter = idx;
+
+	if (idx >= X86_PMC_IDX_MAX)
+		return false;
+
+	return true;
+}
+
+/*
+ * Go through all unassigned events and find the next one to schedule.
+ * Take events with the least weight first. Return true on success.
+ */
+static bool perf_sched_next_event(struct perf_sched *sched)
+{
+	struct event_constraint *c;
+
+	if (!sched->state.unassigned || !--sched->state.unassigned)
+		return false;
+
+	do {
+		/* next event */
+		sched->state.event++;
+		if (sched->state.event >= sched->max_events) {
+			/* next weight */
+			sched->state.event = 0;
+			sched->state.weight++;
+			if (sched->state.weight > sched->max_weight)
+				return false;
+		}
+		c = sched->constraints[sched->state.event];
+	} while (c->weight != sched->state.weight);
+
+	sched->state.counter = 0;	/* start with first counter */
+
+	return true;
+}
+
+/*
+ * Assign a counter for each event.
+ */
+static int perf_assign_events(struct event_constraint **constraints, int n,
+			      int wmin, int wmax, int *assign)
+{
+	struct perf_sched sched;
+
+	perf_sched_init(&sched, constraints, n, wmin, wmax);
+
+	do {
+		if (!perf_sched_find_counter(&sched))
+			break;	/* failed */
+		if (assign)
+			assign[sched.state.event] = sched.state.counter;
+	} while (perf_sched_next_event(&sched));
+
+	return sched.state.unassigned;
+}
+
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	int i, j, w, wmax, num = 0;
+	int i, wmin, wmax, num = 0;
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
-	for (i = 0; i < n; i++) {
+	for (i = 0, wmin = X86_PMC_IDX_MAX, wmax = 0; i < n; i++) {
 		c = x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
 		constraints[i] = c;
+		wmin = min(wmin, c->weight);
+		wmax = max(wmax, c->weight);
 	}
 
 	/*
@@ -525,60 +652,12 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		if (assign)
 			assign[i] = hwc->idx;
 	}
-	if (i == n)
-		goto done;
-
-	/*
-	 * begin slow path
-	 */
 
-	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
-
-	/*
-	 * weight = number of possible counters
-	 *
-	 * 1    = most constrained, only works on one counter
-	 * wmax = least constrained, works on any counter
-	 *
-	 * assign events to counters starting with most
-	 * constrained events.
-	 */
-	wmax = x86_pmu.num_counters;
+	/* slow path */
+	if (i != n)
+		num = perf_assign_events(constraints, n, wmin, wmax, assign);
 
 	/*
-	 * when fixed event counters are present,
-	 * wmax is incremented by 1 to account
-	 * for one more choice
-	 */
-	if (x86_pmu.num_counters_fixed)
-		wmax++;
-
-	for (w = 1, num = n; num && w <= wmax; w++) {
-		/* for each event */
-		for (i = 0; num && i < n; i++) {
-			c = constraints[i];
-			hwc = &cpuc->event_list[i]->hw;
-
-			if (c->weight != w)
-				continue;
-
-			for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
-				if (!test_bit(j, used_mask))
-					break;
-			}
-
-			if (j == X86_PMC_IDX_MAX)
-				break;
-
-			__set_bit(j, used_mask);
-
-			if (assign)
-				assign[i] = j;
-			num--;
-		}
-	}
-done:
-	/*
 	 * scheduling failed or is just a simulation,
 	 * free resources if necessary
 	 */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3ef66a..3c1063a 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -22,8 +22,14 @@ extern unsigned long __sw_hweight64(__u64 w);
 #include <asm/bitops.h>
 
 #define for_each_set_bit(bit, addr, size) \
-	for ((bit) = find_first_bit((addr), (size)); \
-	     (bit) < (size); \
+	for ((bit) = find_first_bit((addr), (size));		\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+/* same as for_each_set_bit() but use bit as value to start with */
+#define for_each_set_bit_cont(bit, addr, size) \
+	for ((bit) = find_next_bit((addr), (size), (bit));	\
+	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
 static __inline__ int get_bitmask_order(unsigned int count)
-- 
1.7.7


