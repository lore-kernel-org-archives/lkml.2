Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2GFIRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:17:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2GFIRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:17:42 -0400
Date: Thu, 5 Jul 2012 23:26:01 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-a1eac7ac903ea9afbd4f133659710a0588c8eca5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1340217996-2254-3-git-send-email-robert.richter@amd.com>
References: <1340217996-2254-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Move Intel specific code to intel_pmu_init()
Git-Commit-ID: a1eac7ac903ea9afbd4f133659710a0588c8eca5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:26:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1eac7ac903ea9afbd4f133659710a0588c8eca5
Gitweb:     http://git.kernel.org/tip/a1eac7ac903ea9afbd4f133659710a0588c8eca5
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 20 Jun 2012 20:46:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 21:19:40 +0200

perf/x86: Move Intel specific code to intel_pmu_init()

There is some Intel specific code in the generic x86 path. Move it to
intel_pmu_init().

Since p4 and p6 pmus don't have fixed counters we may skip the check
in case such a pmu is detected.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1340217996-2254-3-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c       |   34 +------------------------------
 arch/x86/kernel/cpu/perf_event_intel.c |   33 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6680500..7b4f1e8 100644
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
index 5b0b362..2e9444c 100644
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
