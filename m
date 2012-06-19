Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2FSSLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:11:33 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20617 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445Ab2FSSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMII-01-1OQ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/10] perf, amd: Generalize northbridge constraints code for family 15h
Date: Tue, 19 Jun 2012 20:10:45 +0200
Message-ID: <1340129448-8690-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize northbridge constraints code for family 15h and use this
code there too. The main difference is the use of a counter mask for
northbridge counters. Families others than 15h use unconstraints mask
(any generic counter) while on family 15h we have 4 separate nb
counters. We get the nb counter bit mask from the constraint that we
get for a nb event. Still, the nb counters are not yet enabled. See
next patch for this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   59 +++++++++++++++++++++++-----------
 1 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 27b2806..e538512 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -188,20 +188,13 @@ static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 	return nb && nb->nb_id != -1;
 }
 
-static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
-				      struct perf_event *event)
+static void amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
+					 struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
 	struct amd_nb *nb = cpuc->amd_nb;
 	int i;
 
 	/*
-	 * only care about NB events
-	 */
-	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
-		return;
-
-	/*
 	 * need to scan whole list because event may not have
 	 * been assigned during scheduling
 	 *
@@ -247,12 +240,13 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
   *
   * Given that resources are allocated (cmpxchg), they must be
   * eventually freed for others to use. This is accomplished by
-  * calling amd_put_event_constraints().
+  * calling amd_put_nb_event_constraints().
   *
   * Non NB events are not impacted by this restriction.
   */
 static struct event_constraint *
-amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+__amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
+			       struct event_constraint *c)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct amd_nb *nb = cpuc->amd_nb;
@@ -260,12 +254,6 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	int idx, new = -1;
 
 	/*
-	 * if not NB event or no NB, then no constraints
-	 */
-	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
-		return &unconstrained;
-
-	/*
 	 * detect if already present, if so reuse
 	 *
 	 * cannot merge with actual allocation
@@ -275,7 +263,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	 * because of successive calls to x86_schedule_events() from
 	 * hw_perf_group_sched_in() without hw_perf_enable()
 	 */
-	for_each_generic_counter(idx) {
+	for_each_set_bit(idx, c->idxmsk, X86_PMC_IDX_MAX) {
 		if (new == -1 || hwc->idx == idx)
 			/* assign free slot, prefer hwc->idx */
 			old = cmpxchg(nb->owners + idx, NULL, event);
@@ -481,7 +469,7 @@ static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 
 static struct event_constraint *
-amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
+__amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned int event_code = amd_get_event_code(hwc);
@@ -552,6 +540,39 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 	}
 }
 
+static struct event_constraint *
+amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
+			    struct event_constraint *c)
+{
+	/*
+	 * only care about NB events
+	 */
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
+		return c;
+
+	return __amd_get_nb_event_constraints(cpuc, event, c);
+}
+
+static struct event_constraint *
+amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	return amd_get_nb_event_constraints(cpuc, event, &unconstrained);
+}
+
+static struct event_constraint *
+amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct event_constraint *c = __amd_get_event_constraints_f15h(cpuc, event);
+	return amd_get_nb_event_constraints(cpuc, event, c);
+}
+
+static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
+				      struct perf_event *event)
+{
+	if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
+		amd_put_nb_event_constraints(cpuc, event);
+}
+
 static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
-- 
1.7.8.4


