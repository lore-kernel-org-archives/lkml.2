Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2FSSMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:12:08 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:39216
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab2FSSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VPS7(z1039ozzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMIJ-01-1OX-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/10] perf, amd: Unify AMD's generic and family 15h pmus
Date: Tue, 19 Jun 2012 20:10:44 +0200
Message-ID: <1340129448-8690-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable amd_{get,put}_event_constraints() functions also for family
15h. We enable the setup of nb counters for family 15h now, but do not
yet enable the use of nb counters. This will be done in a later patch.

Keeping separate pmu structs no longer makes sense now. We can use
only a single pmu struct for all AMD cpus. This patch introduces
functions to setup the pmu to enabe core performance counters or
counter constraints.

Also, use cpuid checks instead of family checks where possible. Thus,
it enables the code independently of cpu families if the feature flag
is set.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h    |    3 +-
 arch/x86/kernel/cpu/perf_event_amd.c |  104 +++++++++++++++------------------
 arch/x86/oprofile/op_model_amd.c     |    4 +-
 3 files changed, 50 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 3b31248..ffdf5e0 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -47,8 +47,7 @@
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
 #define AMD64_NUM_COUNTERS				4
-#define AMD64_NUM_COUNTERS_F15H				6
-#define AMD64_NUM_COUNTERS_MAX				AMD64_NUM_COUNTERS_F15H
+#define AMD64_NUM_COUNTERS_CORE				6
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index b5ed2e1..27b2806 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -350,7 +350,7 @@ static void amd_pmu_cpu_starting(int cpu)
 
 	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
 
-	if (boot_cpu_data.x86_max_cores < 2 || boot_cpu_data.x86 == 0x15)
+	if (boot_cpu_data.x86_max_cores < 2)
 		return;
 
 	nb_id = amd_get_nb_id(cpu);
@@ -406,35 +406,6 @@ static struct attribute *amd_format_attr[] = {
 	NULL,
 };
 
-static __initconst const struct x86_pmu amd_pmu = {
-	.name			= "AMD",
-	.handle_irq		= x86_pmu_handle_irq,
-	.disable_all		= x86_pmu_disable_all,
-	.enable_all		= x86_pmu_enable_all,
-	.enable			= x86_pmu_enable_event,
-	.disable		= x86_pmu_disable_event,
-	.hw_config		= amd_pmu_hw_config,
-	.schedule_events	= x86_schedule_events,
-	.eventsel		= MSR_K7_EVNTSEL0,
-	.perfctr		= MSR_K7_PERFCTR0,
-	.event_map		= amd_pmu_event_map,
-	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_counters		= AMD64_NUM_COUNTERS,
-	.cntval_bits		= 48,
-	.cntval_mask		= (1ULL << 48) - 1,
-	.apic			= 1,
-	/* use highest bit to detect overflow */
-	.max_period		= (1ULL << 47) - 1,
-	.get_event_constraints	= amd_get_event_constraints,
-	.put_event_constraints	= amd_put_event_constraints,
-
-	.format_attrs		= amd_format_attr,
-
-	.cpu_prepare		= amd_pmu_cpu_prepare,
-	.cpu_starting		= amd_pmu_cpu_starting,
-	.cpu_dead		= amd_pmu_cpu_dead,
-};
-
 /* AMD Family 15h */
 
 #define AMD_EVENT_TYPE_MASK	0x000000F0ULL
@@ -581,8 +552,8 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 	}
 }
 
-static __initconst const struct x86_pmu amd_pmu_f15h = {
-	.name			= "AMD Family 15h",
+static __initconst const struct x86_pmu amd_pmu = {
+	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
 	.enable_all		= x86_pmu_enable_all,
@@ -590,50 +561,69 @@ static __initconst const struct x86_pmu amd_pmu_f15h = {
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= amd_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
-	.eventsel		= MSR_F15H_PERF_CTL,
-	.perfctr		= MSR_F15H_PERF_CTR,
+	.eventsel		= MSR_K7_EVNTSEL0,
+	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_counters		= AMD64_NUM_COUNTERS_F15H,
+	.num_counters		= AMD64_NUM_COUNTERS,
 	.cntval_bits		= 48,
 	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
-	.get_event_constraints	= amd_get_event_constraints_f15h,
-	/* nortbridge counters not yet implemented: */
-#if 0
+	.get_event_constraints	= amd_get_event_constraints,
 	.put_event_constraints	= amd_put_event_constraints,
 
+	.format_attrs		= amd_format_attr,
+
 	.cpu_prepare		= amd_pmu_cpu_prepare,
-	.cpu_dead		= amd_pmu_cpu_dead,
-#endif
 	.cpu_starting		= amd_pmu_cpu_starting,
-	.format_attrs		= amd_format_attr,
+	.cpu_dead		= amd_pmu_cpu_dead,
 };
 
+static int setup_event_constraints(void)
+{
+	if (boot_cpu_data.x86 >= 0x15)
+		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
+	return 0;
+}
+
+static int setup_perfctr_core(void)
+{
+	if (!cpu_has_perfctr_core) {
+		WARN(x86_pmu.get_event_constraints == amd_get_event_constraints_f15h,
+		     KERN_ERR "Odd, counter constraints enabled but no core perfctrs detected!");
+		return -ENODEV;
+	}
+
+	WARN(x86_pmu.get_event_constraints == amd_get_event_constraints,
+	     KERN_ERR "hw perf events core counters need constraints handler!");
+
+	/*
+	 * If core performance counter extensions exists, we must use
+	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
+	 * x86_pmu_addr_offset().
+	 */
+	x86_pmu.eventsel	= MSR_F15H_PERF_CTL;
+	x86_pmu.perfctr		= MSR_F15H_PERF_CTR;
+	x86_pmu.num_counters	= AMD64_NUM_COUNTERS_CORE;
+	x86_pmu.counters_mask64	= (1ULL << AMD64_NUM_COUNTERS_CORE) - 1;
+
+	printk(KERN_INFO "perf: AMD core performance counters detected\n");
+
+	return 0;
+}
+
 __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
 	if (boot_cpu_data.x86 < 6)
 		return -ENODEV;
 
-	/*
-	 * If core performance counter extensions exists, it must be
-	 * family 15h, otherwise fail. See x86_pmu_addr_offset().
-	 */
-	switch (boot_cpu_data.x86) {
-	case 0x15:
-		if (!cpu_has_perfctr_core)
-			return -ENODEV;
-		x86_pmu = amd_pmu_f15h;
-		break;
-	default:
-		if (cpu_has_perfctr_core)
-			return -ENODEV;
-		x86_pmu = amd_pmu;
-		break;
-	}
+	x86_pmu = amd_pmu;
+
+	setup_event_constraints();
+	setup_perfctr_core();
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 303f086..b2b9443 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -312,7 +312,7 @@ static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
 			goto fail;
 		}
 		/* both registers must be reserved */
-		if (num_counters == AMD64_NUM_COUNTERS_F15H) {
+		if (num_counters == AMD64_NUM_COUNTERS_CORE) {
 			msrs->counters[i].addr = MSR_F15H_PERF_CTR + (i << 1);
 			msrs->controls[i].addr = MSR_F15H_PERF_CTL + (i << 1);
 		} else {
@@ -514,7 +514,7 @@ static int op_amd_init(struct oprofile_operations *ops)
 	ops->create_files = setup_ibs_files;
 
 	if (boot_cpu_data.x86 == 0x15) {
-		num_counters = AMD64_NUM_COUNTERS_F15H;
+		num_counters = AMD64_NUM_COUNTERS_CORE;
 	} else {
 		num_counters = AMD64_NUM_COUNTERS;
 	}
-- 
1.7.8.4


