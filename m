Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1BPNsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:48:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:40002 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab1BPNs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:48:29 -0500
Date: Wed, 16 Feb 2011 13:48:01 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1296664860-10886-3-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Calculate perfctr msr addresses in helper functions
Message-ID: <tip-41bf498949a263fa0b2d32524b89d696ac330e94@git.kernel.org>
Git-Commit-ID: 41bf498949a263fa0b2d32524b89d696ac330e94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:48:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41bf498949a263fa0b2d32524b89d696ac330e94
Gitweb:     http://git.kernel.org/tip/41bf498949a263fa0b2d32524b89d696ac330e94
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 2 Feb 2011 17:40:57 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:30:50 +0100

perf, x86: Calculate perfctr msr addresses in helper functions

This patch adds helper functions to calculate perfctr msr addresses.
We need this to later add support for AMD family 15h cpus. For this we
have to change the algorithms to generate the perfctr's msr addresses.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1296664860-10886-3-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
