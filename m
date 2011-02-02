Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1BBRBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:01:38 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:45554
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab1BBRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:01:37 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Feb 2011 12:01:36 EST
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG019D-01-OAC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/5] perf, x86: Store perfctr msr addresses in config_base/event_base
Date: Wed, 2 Feb 2011 17:40:59 +0100
Message-ID: <1296664860-10886-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of storing the base addresses we can store the counter's msr
addresses directly in config_base/event_base of struct hw_perf_event.
This avoids recalculating the address with each msr access. The
addresses are configured one time. We also need this change to later
modify the address calculation.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c    |   21 ++++++++-------------
 arch/x86/kernel/cpu/perf_event_p4.c |   10 +++++-----
 arch/x86/kernel/cpu/perf_event_p6.c |    4 ++--
 3 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ee40c1ad..3161943 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -298,7 +298,7 @@ x86_perf_event_update(struct perf_event *event)
 	 */
 again:
 	prev_raw_count = local64_read(&hwc->prev_count);
-	rdmsrl(hwc->event_base + idx, new_raw_count);
+	rdmsrl(hwc->event_base, new_raw_count);
 
 	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 					new_raw_count) != prev_raw_count)
@@ -655,7 +655,7 @@ static void x86_pmu_disable(struct pmu *pmu)
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 					  u64 enable_mask)
 {
-	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
+	wrmsrl(hwc->config_base, hwc->config | enable_mask);
 }
 
 static void x86_pmu_enable_all(int added)
@@ -834,15 +834,10 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 		hwc->event_base	= 0;
 	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
-		/*
-		 * We set it so that event_base + idx in wrmsr/rdmsr maps to
-		 * MSR_ARCH_PERFMON_FIXED_CTR0 ... CTR2:
-		 */
-		hwc->event_base =
-			MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
+		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0;
 	} else {
-		hwc->config_base = x86_pmu.eventsel;
-		hwc->event_base  = x86_pmu.perfctr;
+		hwc->config_base = x86_pmu_config_addr(hwc->idx);
+		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
 	}
 }
 
@@ -932,7 +927,7 @@ static inline void x86_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	wrmsrl(hwc->config_base + hwc->idx, hwc->config);
+	wrmsrl(hwc->config_base, hwc->config);
 }
 
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
@@ -985,7 +980,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	 */
 	local64_set(&hwc->prev_count, (u64)-left);
 
-	wrmsrl(hwc->event_base + idx, (u64)(-left) & x86_pmu.cntval_mask);
+	wrmsrl(hwc->event_base, (u64)(-left) & x86_pmu.cntval_mask);
 
 	/*
 	 * Due to erratum on certan cpu we need
@@ -993,7 +988,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	 * is updated properly
 	 */
 	if (x86_pmu.perfctr_second_write) {
-		wrmsrl(hwc->event_base + idx,
+		wrmsrl(hwc->event_base,
 			(u64)(-left) & x86_pmu.cntval_mask);
 	}
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index e56b9bf..c0f1747 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -756,14 +756,14 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 	u64 v;
 
 	/* an official way for overflow indication */
-	rdmsrl(hwc->config_base + hwc->idx, v);
+	rdmsrl(hwc->config_base, v);
 	if (v & P4_CCCR_OVF) {
-		wrmsrl(hwc->config_base + hwc->idx, v & ~P4_CCCR_OVF);
+		wrmsrl(hwc->config_base, v & ~P4_CCCR_OVF);
 		return 1;
 	}
 
 	/* it might be unflagged overflow */
-	rdmsrl(hwc->event_base + hwc->idx, v);
+	rdmsrl(hwc->event_base, v);
 	if (!(v & ARCH_P4_CNTRVAL_MASK))
 		return 1;
 
@@ -802,7 +802,7 @@ static inline void p4_pmu_disable_event(struct perf_event *event)
 	 * state we need to clear P4_CCCR_OVF, otherwise interrupt get
 	 * asserted again and again
 	 */
-	(void)checking_wrmsrl(hwc->config_base + hwc->idx,
+	(void)checking_wrmsrl(hwc->config_base,
 		(u64)(p4_config_unpack_cccr(hwc->config)) &
 			~P4_CCCR_ENABLE & ~P4_CCCR_OVF & ~P4_CCCR_RESERVED);
 }
@@ -872,7 +872,7 @@ static void p4_pmu_enable_event(struct perf_event *event)
 	p4_pmu_enable_pebs(hwc->config);
 
 	(void)checking_wrmsrl(escr_addr, escr_conf);
-	(void)checking_wrmsrl(hwc->config_base + hwc->idx,
+	(void)checking_wrmsrl(hwc->config_base,
 				(cccr & ~P4_CCCR_RESERVED) | P4_CCCR_ENABLE);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 34ba07b..20c097e 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -68,7 +68,7 @@ p6_pmu_disable_event(struct perf_event *event)
 	if (cpuc->enabled)
 		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
-	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
+	(void)checking_wrmsrl(hwc->config_base, val);
 }
 
 static void p6_pmu_enable_event(struct perf_event *event)
@@ -81,7 +81,7 @@ static void p6_pmu_enable_event(struct perf_event *event)
 	if (cpuc->enabled)
 		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
-	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
+	(void)checking_wrmsrl(hwc->config_base, val);
 }
 
 static __initconst const struct x86_pmu p6_pmu = {
-- 
1.7.3.4


