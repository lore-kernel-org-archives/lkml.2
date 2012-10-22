Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2JVNV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:21:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33468 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2JVNVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:21:06 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com
Subject: [PATCH v2 2/2] perf: enforce SNB exclusive access for INST_RETIRED:PREC_DIST
Date: Mon, 22 Oct 2012 15:20:52 +0200
Message-Id: <1350912052-10066-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350912052-10066-1-git-send-email-eranian@google.com>
References: <1350912052-10066-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On all Intel SandyBridge processors, the INST_RETIRED:PREC_DIST
when used with PEBS must be measured alone. That means no other
event can be active on the PMU at the same time as per Intel SDM
Vol3b. This is what the exclusive mode of perf_events provides.
However, it was not enforced for that event.

This patch forces the INST_RETIRED:PREC_DIST event to have
the attr->exclusive bit set in order to be used with PEBS
on SNB. On Intel Ivybridge, that restriction is gone.

In V2, addressed the issue of the pr_info(). Now using
the pr_warn_once() call.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h       |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |   30 +++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 271d257..722ab12 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -382,7 +382,7 @@ struct x86_pmu {
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
-	void		(*pebs_aliases)(struct perf_event *event);
+	int		(*pebs_aliases)(struct perf_event *event);
 	int 		max_pebs_events;
 
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 324bb52..93d61d5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1416,7 +1416,7 @@ static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
-static void intel_pebs_aliases_core2(struct perf_event *event)
+static int intel_pebs_aliases_core2(struct perf_event *event)
 {
 	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
 		/*
@@ -1442,9 +1442,10 @@ static void intel_pebs_aliases_core2(struct perf_event *event)
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
 	}
+	return 0;
 }
 
-static void intel_pebs_aliases_snb(struct perf_event *event)
+static int intel_pebs_aliases_ivb(struct perf_event *event)
 {
 	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
 		/*
@@ -1470,6 +1471,22 @@ static void intel_pebs_aliases_snb(struct perf_event *event)
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
 	}
+	return 0;
+}
+
+static int intel_pebs_aliases_snb(struct perf_event *event)
+{
+	u64 cfg = event->hw.config;
+	/*
+	 * for INST_RETIRED.PREC_DIST to work correctly with PEBS, it must
+	 * be measured alone on SNB (exclusive PMU access) as per Intel SDM.
+	 */
+	if ((cfg & INTEL_ARCH_EVENT_MASK) == 0x01c0 && !event->attr.exclusive) {
+		pr_warn_once("perf: INST_RETIRED.PREC_DIST only works in exclusive mode\n");
+		return -EINVAL;
+	}
+
+	return intel_pebs_aliases_ivb(event);
 }
 
 static int intel_pmu_hw_config(struct perf_event *event)
@@ -1479,8 +1496,11 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
-		x86_pmu.pebs_aliases(event);
+	if (event->attr.precise_ip && x86_pmu.pebs_aliases) {
+		ret = x86_pmu.pebs_aliases(event);
+		if (ret)
+			return ret;
+	}
 
 	if (intel_pmu_needs_lbr_smpl(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
@@ -2084,7 +2104,7 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
-		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_ivb;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-- 
1.7.9.5

