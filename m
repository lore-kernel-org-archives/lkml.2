Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1BBQqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:46:40 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:5115 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752959Ab1BBQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:46:37 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG019E-02-KEV-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/5] perf, x86: Calculate perfctr msr addresses in helper functions
Date: Wed, 2 Feb 2011 17:40:57 +0100
Message-ID: <1296664860-10886-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds helper functions to calculate perfctr msr addresses.
We need this to later add support for AMD family 15h cpus. For this we
have to change the algorithms to generate the perfctr's msr addresses.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   36 ++++++++++++++++++++-----------
 arch/x86/kernel/cpu/perf_event_intel.c |    4 +-
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 70d6d8f..ee40c1ad 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -321,6 +321,16 @@ again:
 	return new_raw_count;
 }
 
+static inline unsigned int x86_pmu_config_addr(int index)
+{
+	return x86_pmu.eventsel + index;
+}
+
+static inline unsigned int x86_pmu_event_addr(int index)
+{
+	return x86_pmu.perfctr + index;
+}
+
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
@@ -331,12 +341,12 @@ static bool reserve_pmc_hardware(void)
 	int i;
 
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (!reserve_perfctr_nmi(x86_pmu.perfctr + i))
+		if (!reserve_perfctr_nmi(x86_pmu_event_addr(i)))
 			goto perfctr_fail;
 	}
 
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
+		if (!reserve_evntsel_nmi(x86_pmu_config_addr(i)))
 			goto eventsel_fail;
 	}
 
@@ -344,13 +354,13 @@ static bool reserve_pmc_hardware(void)
 
 eventsel_fail:
 	for (i--; i >= 0; i--)
-		release_evntsel_nmi(x86_pmu.eventsel + i);
+		release_evntsel_nmi(x86_pmu_config_addr(i));
 
 	i = x86_pmu.num_counters;
 
 perfctr_fail:
 	for (i--; i >= 0; i--)
-		release_perfctr_nmi(x86_pmu.perfctr + i);
+		release_perfctr_nmi(x86_pmu_event_addr(i));
 
 	return false;
 }
@@ -360,8 +370,8 @@ static void release_pmc_hardware(void)
 	int i;
 
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		release_perfctr_nmi(x86_pmu.perfctr + i);
-		release_evntsel_nmi(x86_pmu.eventsel + i);
+		release_perfctr_nmi(x86_pmu_event_addr(i));
+		release_evntsel_nmi(x86_pmu_config_addr(i));
 	}
 }
 
@@ -382,7 +392,7 @@ static bool check_hw_exists(void)
 	 * complain and bail.
 	 */
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		reg = x86_pmu.eventsel + i;
+		reg = x86_pmu_config_addr(i);
 		ret = rdmsrl_safe(reg, &val);
 		if (ret)
 			goto msr_fail;
@@ -407,8 +417,8 @@ static bool check_hw_exists(void)
 	 * that don't trap on the MSR access and always return 0s.
 	 */
 	val = 0xabcdUL;
-	ret = checking_wrmsrl(x86_pmu.perfctr, val);
-	ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
+	ret = checking_wrmsrl(x86_pmu_event_addr(0), val);
+	ret |= rdmsrl_safe(x86_pmu_event_addr(0), &val_new);
 	if (ret || val != val_new)
 		goto msr_fail;
 
@@ -617,11 +627,11 @@ static void x86_pmu_disable_all(void)
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
-		rdmsrl(x86_pmu.eventsel + idx, val);
+		rdmsrl(x86_pmu_config_addr(idx), val);
 		if (!(val & ARCH_PERFMON_EVENTSEL_ENABLE))
 			continue;
 		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
-		wrmsrl(x86_pmu.eventsel + idx, val);
+		wrmsrl(x86_pmu_config_addr(idx), val);
 	}
 }
 
@@ -1110,8 +1120,8 @@ void perf_event_print_debug(void)
 	pr_info("CPU#%d: active:     %016llx\n", cpu, *(u64 *)cpuc->active_mask);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		rdmsrl(x86_pmu.eventsel + idx, pmc_ctrl);
-		rdmsrl(x86_pmu.perfctr  + idx, pmc_count);
+		rdmsrl(x86_pmu_config_addr(idx), pmc_ctrl);
+		rdmsrl(x86_pmu_event_addr(idx), pmc_count);
 
 		prev_left = per_cpu(pmc_prev_left[idx], cpu);
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 008835c..084b383 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -691,8 +691,8 @@ static void intel_pmu_reset(void)
 	printk("clearing PMU state on CPU#%d\n", smp_processor_id());
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		checking_wrmsrl(x86_pmu.eventsel + idx, 0ull);
-		checking_wrmsrl(x86_pmu.perfctr  + idx, 0ull);
+		checking_wrmsrl(x86_pmu_config_addr(idx), 0ull);
+		checking_wrmsrl(x86_pmu_event_addr(idx),  0ull);
 	}
 	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++)
 		checking_wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, 0ull);
-- 
1.7.3.4


