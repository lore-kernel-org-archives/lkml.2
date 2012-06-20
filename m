Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2FTSrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:47:07 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:49134 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756684Ab2FTSq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:46:59 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5XIU5-01-38V-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/4] perf, x86: Move Intel specific code to intel_pmu_init()
Date: Wed, 20 Jun 2012 20:46:34 +0200
Message-ID: <1340217996-2254-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
References: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is some Intel specific code in the generic x86 path. Move it to
intel_pmu_init().

Since p4 and p6 pmus don't have fixed counters we may skip the check
in case such a pmu is detected.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   34 +------------------------------
 arch/x86/kernel/cpu/perf_event_intel.c |   33 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5d0585d..bb340dc 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1307,7 +1307,6 @@ static struct attribute_group x86_pmu_format_group = {
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
-	struct event_constraint *c;
 	int err;
 
 	pr_info("Performance Events: ");
@@ -1338,21 +1337,8 @@ static int __init init_hw_perf_events(void)
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
+	if (!x86_pmu.intel_ctrl)
+		x86_pmu.intel_ctrl = (1 << x86_pmu.num_counters) - 1;
 
 	perf_events_lapic_init();
 	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI");
@@ -1361,22 +1347,6 @@ static int __init init_hw_perf_events(void)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
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
index 1e3fafe..b89fe33 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1765,6 +1765,7 @@ __init int intel_pmu_init(void)
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
 	union cpuid10_ebx ebx;
+	struct event_constraint *c;
 	unsigned int unused;
 	int version;
 
@@ -1953,5 +1954,37 @@ __init int intel_pmu_init(void)
 		}
 	}
 
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
 	return 0;
 }
-- 
1.7.8.4


