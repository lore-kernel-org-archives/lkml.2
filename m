Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0CZNIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:08:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:33091 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0CZNIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:08:47 -0400
Subject: [PATCH] perf, x86: Add Nehelem PMU programming errata workaround
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 14:08:44 +0100
Message-ID: <1269608924.12097.147.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf, x86: Add Nehelem PMU programming errata workaround
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Mar 26 13:59:41 CET 2010

Implement the workaround for Intel Errata AAK100 and AAP53.

Also, remove the Core-i7 name for Nehalem events since there are also
Westmere based i7 chips.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
(compile tested only, since I don't actually have an affected chip)

 arch/x86/kernel/cpu/perf_event.c       |    8 +++---
 arch/x86/kernel/cpu/perf_event_intel.c |   43 +++++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 -
 arch/x86/kernel/cpu/perf_event_p6.c    |    2 -
 4 files changed, 45 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -185,7 +185,7 @@ struct x86_pmu {
 	int		version;
 	int		(*handle_irq)(struct pt_regs *);
 	void		(*disable_all)(void);
-	void		(*enable_all)(void);
+	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
 	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
@@ -577,7 +577,7 @@ void hw_perf_disable(void)
 	x86_pmu.disable_all();
 }
 
-static void x86_pmu_enable_all(void)
+static void x86_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
@@ -785,7 +785,7 @@ void hw_perf_enable(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
-	int i;
+	int i, added = cpuc->n_added;
 
 	if (!x86_pmu_initialized())
 		return;
@@ -837,7 +837,7 @@ void hw_perf_enable(void)
 	cpuc->enabled = 1;
 	barrier();
 
-	x86_pmu.enable_all();
+	x86_pmu.enable_all(added);
 }
 
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -483,7 +483,7 @@ static void intel_pmu_disable_all(void)
 	intel_pmu_lbr_disable_all();
 }
 
-static void intel_pmu_enable_all(void)
+static void intel_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -502,6 +502,40 @@ static void intel_pmu_enable_all(void)
 	}
 }
 
+/*
+ * Workaround for:
+ *   Intel Errata AAK100 (model 26)
+ *   Intel Errata AAP53  (model 30)
+ *
+ * These chips need to be 'reset' when adding counters by programming
+ * the magic three (non counting) events 0x4300D2, 0x4300B1 and 0x4300B5
+ * either in sequence on the same PMC or on different PMCs.
+ */
+static void intel_pmu_nhm_enable_all(int added)
+{
+	if (added) {
+		struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+		int i;
+
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 0, 0x4300D2);
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
+
+		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
+		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
+
+		for (i = 0; i < 3; i++) {
+			struct perf_event *event = cpuc->events[i];
+
+			if (!event)
+				continue;
+
+			__x86_pmu_enable_event(&event->hw);
+		}
+	}
+	intel_pmu_enable_all(added);
+}
+
 static inline u64 intel_pmu_get_status(void)
 {
 	u64 status;
@@ -658,7 +692,7 @@ static int intel_pmu_handle_irq(struct p
 	intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
 	if (!status) {
-		intel_pmu_enable_all();
+		intel_pmu_enable_all(0);
 		return 0;
 	}
 
@@ -707,7 +741,7 @@ again:
 		goto again;
 
 done:
-	intel_pmu_enable_all();
+	intel_pmu_enable_all(0);
 	return 1;
 }
 
@@ -920,7 +954,8 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
-		pr_cont("Nehalem/Corei7 events, ");
+		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
+		pr_cont("Nehalem events, ");
 		break;
 
 	case 28: /* Atom */
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
@@ -423,7 +423,7 @@ static void p4_pmu_enable_event(struct p
 		(u64)(p4_config_unpack_cccr(hwc->config)) | P4_CCCR_ENABLE);
 }
 
-static void p4_pmu_enable_all(void)
+static void p4_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p6.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p6.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p6.c
@@ -66,7 +66,7 @@ static void p6_pmu_disable_all(void)
 	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
-static void p6_pmu_enable_all(void)
+static void p6_pmu_enable_all(int added)
 {
 	unsigned long val;
 


