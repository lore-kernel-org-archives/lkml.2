Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0KUMAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 07:00:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:60295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab0KUMAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 07:00:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="679559472"
Subject: [RFC PATCH 1/3 v2] perf: add counter bits argument for
 x86_perf_event_update
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 20:00:35 +0800
Message-Id: <1290340835.2245.123.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_perf_event_update will be used by later uncore patches.
Add an argument to it to specify counter bits of pmu.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   12 ++++++------
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++--
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5273c7b..cb16b9c 100644
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
@@ -1100,7 +1100,7 @@ static void x86_pmu_stop(struct perf_event *event, int flags)
 		 * Drain the remaining delta count out of a event
 		 * that we are disabling:
 		 */
-		x86_perf_event_update(event);
+		x86_perf_event_update(event, x86_pmu.cntval_bits);
 		hwc->state |= PERF_HES_UPTODATE;
 	}
 }
@@ -1162,7 +1162,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 		event = cpuc->events[idx];
 
-		val = x86_perf_event_update(event);
+		val = x86_perf_event_update(event, x86_pmu.cntval_bits);
 		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
 			continue;
 
@@ -1415,7 +1415,7 @@ void __init init_hw_perf_events(void)
 
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
 
-- 
1.7.2.3





