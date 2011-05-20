Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414Ab1ETOAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:00:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53861 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934220Ab1ETOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=D+qyeprKIZ6ACAgbevWmV6AxyLfFr4l7U28lbF6cUj/LyO5vFIN7K/W8jsL7hGzpqK
         ke3ftElkqAPeUdhFSTJQ==
Date: Fri, 20 May 2011 16:00:33 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, andi@firstfloor.org,
        ming.m.lin@intel.com
Subject: [PATCH 3/3] perf_events: add Intel Sandy Bridge offcore_response
 low-level support
Message-ID: <20110520140033.GA13468@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
        This patch adds Intel Sandy Bridge offcore_response support by
	providing the low-level constraint table for those events.
    
        On Sandy Bridge, there are two offcore_response events. Each uses
        its own dedictated extra register. But those registers are NOT shared
        between sibling CPUs when HT is on unlike Nehalem/Westmere. They are
	always private to each CPU. But they still need to be controlled within
	an event group. All events within an event group must use the same
	value for the extra MSR. That's not controlled by the second patch in
	this series.
    
        Furthermore on Sandy Bridge, the offcore_response events have NO
	counter constraints contrary to what the official documentation
	indicates, so drop the events from the contraint table.
    
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b0f0415..efe4684 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -304,6 +304,7 @@ struct x86_pmu {
 	 * Extra registers for events
 	 */
 	struct extra_reg *extra_regs;
+	bool regs_no_ht_sharing;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3e6459b..72cdac6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -121,8 +121,6 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
-	INTEL_EVENT_CONSTRAINT(0xb7, 0x1), /* OFF_CORE_RESPONSE_0 */
-	INTEL_EVENT_CONSTRAINT(0xbb, 0x8), /* OFF_CORE_RESPONSE_1 */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
 	EVENT_CONSTRAINT_END
@@ -143,6 +141,13 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_snb_extra_regs[] __read_mostly =
+{
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	EVENT_EXTRA_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -1287,7 +1292,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	 */
 	intel_pmu_lbr_reset();
 
-	if (!cpuc->shared_regs)
+	if (!cpuc->shared_regs || x86_pmu.regs_no_ht_sharing)
 		return;
 
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
@@ -1529,6 +1534,9 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.regs_no_ht_sharing = true;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
