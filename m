Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab0KBH2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:28:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:31962 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430Ab0KBH2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:28:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,279,1286175600"; 
   d="scan'208";a="853252289"
Subject: [DRAFT PATCH 1/3] perf: Update x86_perf_event_update/set_period
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com,
        Cyrill Gorcunov <gorcunov@gmail.com>, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 15:27:53 +0800
Message-ID: <1288682873.12061.106.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_perf_event_update/set_period will be used by later uncore patches.

And add PERF_TYPE_UNCORE to present uncore pmu event.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   23 +++++++++++++----------
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++--
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 include/linux/perf_event.h             |    1 +
 4 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..7cea0f4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -277,11 +277,11 @@ static u64 __read_mostly hw_cache_event_ids
  * Can only be executed on the CPU where the event is active.
  * Returns the delta events processed.
  */
-static u64
-x86_perf_event_update(struct perf_event *event)
+u64
+x86_perf_event_update(struct perf_event *event, int cntval_bits)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	int shift = 64 - x86_pmu.cntval_bits;
+	int shift = 64 - cntval_bits;
 	u64 prev_raw_count, new_raw_count;
 	int idx = hwc->idx;
 	s64 delta;
@@ -924,10 +924,12 @@ x86_perf_event_set_period(struct perf_event *event)
 	if (unlikely(left < 2))
 		left = 2;
 
-	if (left > x86_pmu.max_period)
-		left = x86_pmu.max_period;
+	if (event->attr.type != PERF_TYPE_UNCORE) {
+		if (left > x86_pmu.max_period)
+			left = x86_pmu.max_period;
 
-	per_cpu(pmc_prev_left[idx], smp_processor_id()) = left;
+		per_cpu(pmc_prev_left[idx], smp_processor_id()) = left;
+	}
 
 	/*
 	 * The hw event starts counting from this event offset,
@@ -942,7 +944,8 @@ x86_perf_event_set_period(struct perf_event *event)
 	 * a second write to be sure the register
 	 * is updated properly
 	 */
-	if (x86_pmu.perfctr_second_write) {
+	if (event->attr.type != PERF_TYPE_UNCORE &&
+			x86_pmu.perfctr_second_write) {
 		wrmsrl(hwc->event_base + idx,
 			(u64)(-left) & x86_pmu.cntval_mask);
 	}
@@ -1109,7 +1112,7 @@ static void x86_pmu_stop(struct perf_event *event, int flags)
 		 * Drain the remaining delta count out of a event
 		 * that we are disabling:
 		 */
-		x86_perf_event_update(event);
+		x86_perf_event_update(event, x86_pmu.cntval_bits);
 		hwc->state |= PERF_HES_UPTODATE;
 	}
 }
@@ -1171,7 +1174,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 		event = cpuc->events[idx];
 
-		val = x86_perf_event_update(event);
+		val = x86_perf_event_update(event, x86_pmu.cntval_bits);
 		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
 			continue;
 
@@ -1424,7 +1427,7 @@ void __init init_hw_perf_events(void)
 
 static inline void x86_pmu_read(struct perf_event *event)
 {
-	x86_perf_event_update(event);
+	x86_perf_event_update(event, x86_pmu.cntval_bits);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c8f5c08..a9f35e2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -536,7 +536,7 @@ static void intel_pmu_nhm_workaround(void)
 	for (i = 0; i < 4; i++) {
 		event = cpuc->events[i];
 		if (event)
-			x86_perf_event_update(event);
+			x86_perf_event_update(event, x86_pmu.cntval_bits);
 	}
 
 	for (i = 0; i < 4; i++) {
@@ -673,7 +673,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
  */
 static int intel_pmu_save_and_restart(struct perf_event *event)
 {
-	x86_perf_event_update(event);
+	x86_perf_event_update(event, x86_pmu.cntval_bits);
 	return x86_perf_event_set_period(event);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 81400b9..63aca68 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -919,7 +919,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		/* it might be unflagged overflow */
 		overflow = p4_pmu_clear_cccr_ovf(hwc);
 
-		val = x86_perf_event_update(event);
+		val = x86_perf_event_update(event, x86_pmu.cntval_bits);
 		if (!overflow && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
 			continue;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..b012880 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -32,6 +32,7 @@ enum perf_type_id {
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
 	PERF_TYPE_BREAKPOINT			= 5,
+	PERF_TYPE_UNCORE			= 6,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
-- 
1.7.1




