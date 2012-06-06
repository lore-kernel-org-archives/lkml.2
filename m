Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2FFA5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 20:57:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:1717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab2FFA5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 20:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152109432"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eranian@google.com, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] perf, x86: Don't assume the alternative cycles encoding is architectural
Date: Tue,  5 Jun 2012 17:56:47 -0700
Message-Id: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

cycles:p uses an special cycles encoding by default. However that is not
architectural, so it can only be used when the CPU is known
(it already caused problems on Sandy Bridge). It may or may not work
on future CPUs.

So make it opt-in only. Right now I enabled it on Core2, Nehalem, Westmere
and not on Sandy-Bridge or Atom.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h       |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6638aaf..cdddcef 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -355,6 +355,7 @@ struct x86_pmu {
 	 */
 	u64			intel_ctrl;
 	union perf_capabilities intel_cap;
+	bool			pebs_cycles;
 
 	/*
 	 * Intel DebugStore bits
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546e..2e40391 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1308,7 +1308,8 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		return ret;
 
 	if (event->attr.precise_ip &&
-	    (event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
+	    (event->hw.config & X86_RAW_EVENT_MASK) == 0x003c &&
+            x86_pmu.pebs_cycles) {
 		/*
 		 * Use an alternative encoding for CPU_CLK_UNHALTED.THREAD_P
 		 * (0x003c) so that we can use it with PEBS.
@@ -1772,6 +1773,7 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_core2_event_constraints;
 		x86_pmu.pebs_constraints = intel_core2_pebs_event_constraints;
+		x86_pmu.pebs_cycles = true;
 		pr_cont("Core2 events, ");
 		break;
 
@@ -1799,6 +1801,7 @@ __init int intel_pmu_init(void)
 
 		x86_add_quirk(intel_nehalem_quirk);
 
+		x86_pmu.pebs_cycles = true;
 		pr_cont("Nehalem events, ");
 		break;
 
@@ -1836,6 +1839,7 @@ __init int intel_pmu_init(void)
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
 			X86_CONFIG(.event=0xb1, .umask=0x3f, .inv=1, .cmask=1);
 
+		x86_pmu.pebs_cycles = true;
 		pr_cont("Westmere events, ");
 		break;
 
-- 
1.7.7.6

