Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2FSSMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:12:06 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20587 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955Ab2FSSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMIH-02-7QP-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/10] perf, x86: Move Intel specific code to intel_pmu_init()
Date: Tue, 19 Jun 2012 20:10:43 +0200
Message-ID: <1340129448-8690-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is some Intel specific code in the generic x86 path. Move it to
intel_pmu_init().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   33 -----------------------
 arch/x86/kernel/cpu/perf_event_intel.c |   45 +++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2874059..9fbf70a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1308,7 +1308,6 @@ static struct attribute_group x86_pmu_format_group = {
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
-	struct event_constraint *c;
 	int err;
 
 	pr_info("Performance Events: ");
@@ -1339,22 +1338,6 @@ static int __init init_hw_perf_events(void)
 	for (quirk = x86_pmu.quirks; quirk; quirk = quirk->next)
 		quirk->func();
 
-	if (x86_pmu.num_counters > INTEL_PMC_MAX_GENERIC) {
-		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
-		     x86_pmu.num_counters, INTEL_PMC_MAX_GENERIC);
-		x86_pmu.num_counters = INTEL_PMC_MAX_GENERIC;
-	}
-	x86_pmu.intel_ctrl = (1 << x86_pmu.num_counters) - 1;
-
-	if (x86_pmu.num_counters_fixed > INTEL_PMC_MAX_FIXED) {
-		WARN(1, KERN_ERR "hw perf events fixed %d > max(%d), clipping!",
-		     x86_pmu.num_counters_fixed, INTEL_PMC_MAX_FIXED);
-		x86_pmu.num_counters_fixed = INTEL_PMC_MAX_FIXED;
-	}
-
-	x86_pmu.intel_ctrl |=
-		((1LL << x86_pmu.num_counters_fixed)-1) << INTEL_PMC_IDX_FIXED;
-
 	if (!x86_pmu.counters_mask64)
 		x86_pmu.counters_mask64 = (1ULL << x86_pmu.num_counters) - 1;
 	if (x86_pmu.num_counters != hweight64(x86_pmu.counters_mask64)) {
@@ -1370,22 +1353,6 @@ static int __init init_hw_perf_events(void)
 		__EVENT_CONSTRAINT(0, x86_pmu.counters_mask64,
 				   0, x86_pmu.num_counters, 0);
 
-	if (x86_pmu.event_constraints) {
-		/*
-		 * event on fixed counter2 (REF_CYCLES) only works on this
-		 * counter, so do not extend mask to generic counters
-		 */
-		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if (c->cmask != X86_RAW_EVENT_MASK
-			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
-				continue;
-			}
-
-			c->idxmsk64 |= (1ULL << x86_pmu.num_counters) - 1;
-			c->weight += x86_pmu.num_counters;
-		}
-	}
-
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1eb9f00..90d7097 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1760,7 +1760,7 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
-__init int intel_pmu_init(void)
+static __init int __intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
@@ -1955,3 +1955,46 @@ __init int intel_pmu_init(void)
 
 	return 0;
 }
+
+__init int intel_pmu_init(void)
+{
+	struct event_constraint *c;
+	int ret = __intel_pmu_init();
+
+	if (ret)
+		return ret;
+
+	if (x86_pmu.num_counters > INTEL_PMC_MAX_GENERIC) {
+		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
+		     x86_pmu.num_counters, INTEL_PMC_MAX_GENERIC);
+		x86_pmu.num_counters = INTEL_PMC_MAX_GENERIC;
+	}
+	x86_pmu.intel_ctrl = (1 << x86_pmu.num_counters) - 1;
+
+	if (x86_pmu.num_counters_fixed > INTEL_PMC_MAX_FIXED) {
+		WARN(1, KERN_ERR "hw perf events fixed %d > max(%d), clipping!",
+		     x86_pmu.num_counters_fixed, INTEL_PMC_MAX_FIXED);
+		x86_pmu.num_counters_fixed = INTEL_PMC_MAX_FIXED;
+	}
+
+	x86_pmu.intel_ctrl |=
+		((1LL << x86_pmu.num_counters_fixed)-1) << INTEL_PMC_IDX_FIXED;
+
+	if (x86_pmu.event_constraints) {
+		/*
+		 * event on fixed counter2 (REF_CYCLES) only works on this
+		 * counter, so do not extend mask to generic counters
+		 */
+		for_each_event_constraint(c, x86_pmu.event_constraints) {
+			if (c->cmask != X86_RAW_EVENT_MASK
+			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
+				continue;
+			}
+
+			c->idxmsk64 |= (1ULL << x86_pmu.num_counters) - 1;
+			c->weight += x86_pmu.num_counters;
+		}
+	}
+
+	return 0;
+}
-- 
1.7.8.4


