Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab1IJOyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 10:54:35 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:32141
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933092Ab1IJOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 10:54:32 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRBAQN-02-22O-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/2] perf, x86: Implement event scheduler helper functions
Date: Sat, 10 Sep 2011 16:49:02 +0200
Message-ID: <1315666143-7106-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315666143-7106-1-git-send-email-robert.richter@amd.com>
References: <1315666143-7106-1-git-send-email-robert.richter@amd.com>
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

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |  158 +++++++++++++++++++++++++-------------
 1 files changed, 105 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 594d425..44ec767 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -790,18 +790,118 @@ static inline int is_x86_event(struct perf_event *event)
 	return event->pmu == &pmu;
 }
 
+struct sched_state {
+	int	weight;
+	int	event;
+	int	counter;
+	int	unassigned;
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
+static void perf_sched_init(struct perf_sched *sched, struct event_constraint **c,
+			    int num, int wmin, int wmax)
+{
+	memset(sched, 0, sizeof(*sched));
+	sched->max_events	= num;
+	sched->max_weight	= wmax;
+	sched->constraints	= c;
+
+	sched->state.weight	= wmin;
+	sched->state.unassigned	= num;
+}
+
+static struct sched_state *perf_sched_find_counter(struct perf_sched *sched)
+{
+	struct event_constraint *c;
+	int idx;
+
+	if (!sched->state.unassigned)
+		return NULL;
+
+	c = sched->constraints[sched->state.event];
+
+	idx = sched->state.counter;
+	/* for each bit in idxmsk starting from idx */
+	while (idx < X86_PMC_IDX_MAX) {
+		idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX, idx);
+		if (idx == X86_PMC_IDX_MAX)
+			break;
+		if (!__test_and_set_bit(idx, sched->state.used))
+			break;
+		idx++;
+	}
+	sched->state.counter = idx;
+
+	if (idx >= X86_PMC_IDX_MAX)
+		return NULL;
+
+	return &sched->state;
+}
+
+static int perf_sched_next_event(struct perf_sched *sched)
+{
+	struct event_constraint *c;
+
+	if (!sched->state.unassigned || !--sched->state.unassigned)
+		return 0;
+
+	do {
+		/* next event */
+		sched->state.event++;
+		if (sched->state.event >= sched->max_events) {
+			/* next weight */
+			sched->state.event = 0;
+			sched->state.weight++;
+			if (sched->state.weight > sched->max_weight)
+				return 0;
+		}
+		c = sched->constraints[sched->state.event];
+	} while (c->weight != sched->state.weight);
+
+	sched->state.counter = 0;	/* start with first counter */
+
+	return 1;
+}
+
+static int perf_assign_events(struct event_constraint **constraints, int n,
+			      int wmin, int wmax, int *assign)
+{
+	struct perf_sched sched;
+	struct sched_state *state;
+
+	perf_sched_init(&sched, constraints, n, wmin, wmax);
+	do {
+		state = perf_sched_find_counter(&sched);
+		if (!state)
+			break;	/* failed */
+		if (assign)
+			assign[state->event] = state->counter;
+	} while (perf_sched_next_event(&sched));
+
+	return sched.state.unassigned;
+}
+
 static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
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
@@ -827,59 +927,11 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		if (assign)
 			assign[i] = hwc->idx;
 	}
-	if (i == n)
-		goto done;
 
-	/*
-	 * begin slow path
-	 */
+	/* slow path */
+	if (i != n)
+		num = perf_assign_events(constraints, n, wmin, wmax, assign);
 
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
-
-	/*
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
 	/*
 	 * scheduling failed or is just a simulation,
 	 * free resources if necessary
-- 
1.7.6.1


