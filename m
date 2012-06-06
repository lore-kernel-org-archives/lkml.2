Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2FFA56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 20:57:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:2178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab2FFA5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 20:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148674932"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eranian@google.com, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/5] perf, x86: Prefer RDPMC over RDMSR for reading counters
Date: Tue,  5 Jun 2012 17:56:51 -0700
Message-Id: <1338944211-28275-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

RDPMC is much faster than RDMSR for reading performance counters,
since it's not serializing.  Use it if possible in the perf handler.

Only tested on Sandy Bridge, so I only enabled it there so far.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   20 +++++++++++++++++---
 arch/x86/kernel/cpu/perf_event.h       |    2 ++
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 include/linux/perf_event.h             |    1 +
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e049d6d..7d12888 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -86,7 +86,14 @@ u64 x86_perf_event_update(struct perf_event *event)
 	 */
 again:
 	prev_raw_count = local64_read(&hwc->prev_count);
-	rdmsrl(hwc->event_base, new_raw_count);
+	
+	/* 
+	 * Prefer RDPMC when available since it's faster.
+	 */
+	if (hwc->read_event_base)
+		rdpmcl(hwc->read_event_base, new_raw_count);
+	else
+		rdmsrl(hwc->event_base, new_raw_count);
 
 	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 					new_raw_count) != prev_raw_count)
@@ -819,20 +826,27 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 				struct cpu_hw_events *cpuc, int i)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	int index;
 
 	hwc->idx = cpuc->assign[i];
 	hwc->last_cpu = smp_processor_id();
 	hwc->last_tag = ++cpuc->tags[i];
 
+	hwc->event_base	= 0;
+	hwc->read_event_base = 0;
 	if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
 		hwc->config_base = 0;
-		hwc->event_base	= 0;
 	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
-		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - X86_PMC_IDX_FIXED);
+		index = hwc->idx - X86_PMC_IDX_FIXED;
+		if (x86_pmu.prefer_rdpmc)
+			hwc->read_event_base = 0x40000000 + index;
+	       	hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + index;
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
+		if (x86_pmu.prefer_rdpmc)
+			hwc->read_event_base = hwc->idx;
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 43cfed2..75fe10a 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -385,6 +385,8 @@ struct x86_pmu {
 	 * Intel host/guest support (KVM)
 	 */
 	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
+
+	bool		prefer_rdpmc;
 };
 
 #define x86_add_quirk(func_)						\
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 71b8de5..8a8eda2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1868,6 +1868,7 @@ __init int intel_pmu_init(void)
 			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
 
 		pr_cont("SandyBridge events, ");
+		x86_pmu.prefer_rdpmc = true;
 		break;
 
 	default:
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f325786..0627736 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -677,6 +677,7 @@ struct hw_perf_event {
 			u64		last_tag;
 			unsigned long	config_base;
 			unsigned long	event_base;
+			unsigned long	read_event_base;
 			int		idx;
 			int		last_cpu;
 
-- 
1.7.7.6

