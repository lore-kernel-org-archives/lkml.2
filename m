Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab1LFJpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:45:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:45:30 -0500
Date: Tue, 6 Dec 2011 01:45:03 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-bc1738f6ee83015f090867813dcca4d690e7917c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1321616122-1533-3-git-send-email-robert.richter@amd.com>
References: <1321616122-1533-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Fix event scheduler for constraints with overlapping counters
Git-Commit-ID: bc1738f6ee83015f090867813dcca4d690e7917c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:45:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc1738f6ee83015f090867813dcca4d690e7917c
Gitweb:     http://git.kernel.org/tip/bc1738f6ee83015f090867813dcca4d690e7917c
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Fri, 18 Nov 2011 12:35:22 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:33:56 +0100

perf, x86: Fix event scheduler for constraints with overlapping counters

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

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1321616122-1533-3-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c     |   45 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event.h     |   30 +++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 3 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5a469d3..fa6fdec 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -499,11 +499,16 @@ struct sched_state {
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
@@ -529,11 +534,34 @@ static void perf_sched_init(struct perf_sched *sched, struct event_constraint **
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
@@ -557,6 +585,19 @@ static bool perf_sched_find_counter(struct perf_sched *sched)
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
 
@@ -1250,7 +1291,7 @@ static int __init init_hw_perf_events(void)
 
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
 
