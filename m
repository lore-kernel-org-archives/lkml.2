Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0LBFRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:17:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:51617 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab0LBFRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:17:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,286,1288594800"; 
   d="scan'208";a="863422395"
Subject: [RFC PATCH 1/3 v3] perf: add counter bits argument for
 x86_perf_event_update
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 13:19:57 +0800
Message-ID: <1291267197.2405.312.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_perf_event_update will be used by later uncore patches.
Add an argument to it to specify counter bits of pmu.

(No update from v2)

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   12 ++++++------
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++--
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 817d2b1..7202762 100644
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
@@ -1114,7 +1114,7 @@ static void x86_pmu_stop(struct perf_event *event, int flags)
 		 * Drain the remaining delta count out of a event
 		 * that we are disabling:
 		 */
-		x86_perf_event_update(event);
+		x86_perf_event_update(event, x86_pmu.cntval_bits);
 		hwc->state |= PERF_HES_UPTODATE;
 	}
 }
@@ -1176,7 +1176,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 		event = cpuc->events[idx];
 
-		val = x86_perf_event_update(event);
+		val = x86_perf_event_update(event, x86_pmu.cntval_bits);
 		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
 			continue;
 
@@ -1438,7 +1438,7 @@ early_initcall(init_hw_perf_events);
 
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
1.5.3




