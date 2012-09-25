Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2IYQ0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:26:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:14538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892Ab2IYQ0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,484,1344236400"; 
   d="scan'208";a="197504121"
From: "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
To: Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "eranian@gmail.com" <eranian@gmail.com>
Subject: RE: [PATCH V2 1/1] perf, Add support for Xeon-Phi PMU
Thread-Topic: [PATCH V2 1/1] perf, Add support for Xeon-Phi PMU
Thread-Index: AQHNmzoX8TU9HkMJLkys4jEK2MczPJebPirw
Date: Tue, 25 Sep 2012 16:26:16 +0000
Message-ID: <BE3749A5E777734CA7AF35D0CBF344CC2411919B@FMSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.02.1209251215340.8741@vincent-weaver-1.um.maine.edu>
In-Reply-To: <alpine.DEB.2.02.1209251215340.8741@vincent-weaver-1.um.maine.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recommend that you use KNC. Xeon Phi is a marketing name. PMU for followon Xeon Phi chips will probably be different.

-----Original Message-----
From: Vince Weaver [mailto:vincent.weaver@maine.edu] 
Sent: Tuesday, September 25, 2012 9:23 AM
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra; Cyrill Gorcunov; Paul Mackerras; Ingo Molnar; Arnaldo Carvalho de Melo; eranian@gmail.com; Meadows, Lawrence F
Subject: [PATCH V2 1/1] perf, Add support for Xeon-Phi PMU

Hello

This is an updated version of the patch.  It uses ARCH_PERFMON_EVENTSEL_INT for the DATA_READ event, with the assumption that x86_pmu_hw_config() is going to set that bit anyway.  This lets the code get through the test for an event being 0 without triggering -ENOENT.

One remaining question, is "Phi" a marketing name and should we find/replace all PHI with KNC for Knight's Corner?


Included below is a patch that adds perf support for the Xeon-Phi PMU,
as documented in the "Intel Xeon Phi Coprocessor (codename: Knights 
Corner) Performance Monitoring Units" manual.

Even though it is a co-processor, a Phi runs a full Linux environment
and can support performance counters.

This is just barebones support, it does not add support for
interesting new features such as the SPFLT intruction that
allows starting/stopping events without entering the kernel.

The PMU internally is just like that of an original Pentium, but 
a "P6-like" MSR interface is provided.  The interface is different enough
from a real P6 that it's not easy (or practical) to re-use the code in 
perf_event_p6.c


Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff -Nur linux-3.6-rc6/arch/x86/include/asm/msr-index.h linux-3.6-rc6-mic/arch/x86/include/asm/msr-index.h
--- linux-3.6-rc6/arch/x86/include/asm/msr-index.h	2012-09-16 17:58:51.000000000 -0400
+++ linux-3.6-rc6-mic/arch/x86/include/asm/msr-index.h	2012-09-20 11:55:14.854332191 -0400
@@ -121,6 +121,11 @@
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
 
+#define MSR_PHI_PERFCTR0               0x00000020
+#define MSR_PHI_PERFCTR1               0x00000021
+#define MSR_PHI_EVNTSEL0               0x00000028
+#define MSR_PHI_EVNTSEL1               0x00000029
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff -Nur linux-3.6-rc6/arch/x86/kernel/cpu/Makefile linux-3.6-rc6-mic/arch/x86/kernel/cpu/Makefile
--- linux-3.6-rc6/arch/x86/kernel/cpu/Makefile	2012-09-16 17:58:51.000000000 -0400
+++ linux-3.6-rc6-mic/arch/x86/kernel/cpu/Makefile	2012-09-20 12:15:21.042331190 -0400
@@ -32,7 +32,7 @@
 
 ifdef CONFIG_PERF_EVENTS
 obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_phi.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
 endif
diff -Nur linux-3.6-rc6/arch/x86/kernel/cpu/perfctr-watchdog.c linux-3.6-rc6-mic/arch/x86/kernel/cpu/perfctr-watchdog.c
--- linux-3.6-rc6/arch/x86/kernel/cpu/perfctr-watchdog.c	2012-09-16 17:58:51.000000000 -0400
+++ linux-3.6-rc6-mic/arch/x86/kernel/cpu/perfctr-watchdog.c	2012-09-20 11:56:51.430332108 -0400
@@ -56,6 +56,8 @@
 		switch (boot_cpu_data.x86) {
 		case 6:
 			return msr - MSR_P6_PERFCTR0;
+		case 11:
+			return msr - MSR_PHI_PERFCTR0;
 		case 15:
 			return msr - MSR_P4_BPU_PERFCTR0;
 		}
@@ -82,6 +84,8 @@
 		switch (boot_cpu_data.x86) {
 		case 6:
 			return msr - MSR_P6_EVNTSEL0;
+		case 11:
+			return msr - MSR_PHI_EVNTSEL0;
 		case 15:
 			return msr - MSR_P4_BSU_ESCR0;
 		}
diff -Nur linux-3.6-rc6/arch/x86/kernel/cpu/perf_event.h linux-3.6-rc6-mic/arch/x86/kernel/cpu/perf_event.h
--- linux-3.6-rc6/arch/x86/kernel/cpu/perf_event.h	2012-09-16 17:58:51.000000000 -0400
+++ linux-3.6-rc6-mic/arch/x86/kernel/cpu/perf_event.h	2012-09-20 12:49:25.782329486 -0400
@@ -624,6 +624,8 @@
 
 int p6_pmu_init(void);
 
+int phi_pmu_init(void);
+
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static inline void reserve_ds_buffers(void)
diff -Nur linux-3.6-rc6/arch/x86/kernel/cpu/perf_event_intel.c linux-3.6-rc6-mic/arch/x86/kernel/cpu/perf_event_intel.c
--- linux-3.6-rc6/arch/x86/kernel/cpu/perf_event_intel.c	2012-09-16 17:58:51.000000000 -0400
+++ linux-3.6-rc6-mic/arch/x86/kernel/cpu/perf_event_intel.c	2012-09-20 12:14:37.082331232 -0400
@@ -1906,6 +1906,8 @@
 		switch (boot_cpu_data.x86) {
 		case 0x6:
 			return p6_pmu_init();
+		case 0xb:
+			return phi_pmu_init();
 		case 0xf:
 			return p4_pmu_init();
 		}
diff -Nur linux-3.6-rc6/arch/x86/kernel/cpu/perf_event_phi.c linux-3.6-rc6-mic/arch/x86/kernel/cpu/perf_event_phi.c
--- linux-3.6-rc6/arch/x86/kernel/cpu/perf_event_phi.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-3.6-rc6-mic/arch/x86/kernel/cpu/perf_event_phi.c	2012-09-25 12:10:46.505972473 -0400
@@ -0,0 +1,246 @@
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include "perf_event.h"
+
+static const u64 phi_perfmon_event_map[] =
+{
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x002a,
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x0016,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0028,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0029,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x0012,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
+};
+
+static __initconst u64 phi_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		/* On Xeon Phi event "0" is a valid DATA_READ          */
+		/*   (L1 Data Cache Reads) Instruction.                */
+		/* We code this as ARCH_PERFMON_EVENTSEL_INT as this   */
+		/* bit will always be set in x86_pmu_hw_config().      */
+		[ C(RESULT_ACCESS) ] = ARCH_PERFMON_EVENTSEL_INT,
+						/* DATA_READ           */
+		[ C(RESULT_MISS)   ] = 0x0003,	/* DATA_READ_MISS      */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0001,	/* DATA_WRITE          */
+		[ C(RESULT_MISS)   ] = 0x0004,	/* DATA_WRITE_MISS     */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0011,	/* L1_DATA_PF1         */
+		[ C(RESULT_MISS)   ] = 0x001c,	/* L1_DATA_PF1_MISS    */
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x000c,	/* CODE_READ          */
+		[ C(RESULT_MISS)   ] = 0x000e,	/* CODE_CACHE_MISS    */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0x10cb,	/* L2_READ_MISS */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x10cc,	/* L2_WRITE_HIT */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x10fc,	/* L2_DATA_PF2      */
+		[ C(RESULT_MISS)   ] = 0x10fe,	/* L2_DATA_PF2_MISS */
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = ARCH_PERFMON_EVENTSEL_INT,
+						/* DATA_READ */
+						/* see note on L1 OP_READ */
+		[ C(RESULT_MISS)   ] = 0x0002,	/* DATA_PAGE_WALK */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0001,	/* DATA_WRITE */
+		[ C(RESULT_MISS)   ] = 0x0002,	/* DATA_PAGE_WALK */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x000c,	/* CODE_READ */
+		[ C(RESULT_MISS)   ] = 0x000d,	/* CODE_PAGE_WALK */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+ [ C(BPU ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0012,	/* BRANCHES */
+		[ C(RESULT_MISS)   ] = 0x002b,	/* BRANCHES_MISPREDICTED */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+};
+
+
+static u64 phi_pmu_event_map(int hw_event)
+{
+	return phi_perfmon_event_map[hw_event];
+}
+
+static struct event_constraint phi_event_constraints[] =
+{
+	INTEL_EVENT_CONSTRAINT(0xc3, 0x1),	/* HWP_L2HIT */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0x1),	/* HWP_L2MISS */
+	INTEL_EVENT_CONSTRAINT(0xc8, 0x1),	/* L2_READ_HIT_E */
+	INTEL_EVENT_CONSTRAINT(0xc9, 0x1),	/* L2_READ_HIT_M */
+	INTEL_EVENT_CONSTRAINT(0xca, 0x1),	/* L2_READ_HIT_S */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),	/* L2_READ_MISS */
+	INTEL_EVENT_CONSTRAINT(0xcc, 0x1),	/* L2_WRITE_HIT */
+	INTEL_EVENT_CONSTRAINT(0xce, 0x1),	/* L2_STRONGLY_ORDERED_STREAMING_VSTORES_MISS */
+	INTEL_EVENT_CONSTRAINT(0xcf, 0x1),	/* L2_WEAKLY_ORDERED_STREAMING_VSTORE_MISS */
+	INTEL_EVENT_CONSTRAINT(0xd7, 0x1),	/* L2_VICTIM_REQ_WITH_DATA */
+	INTEL_EVENT_CONSTRAINT(0xe3, 0x1),	/* SNP_HITM_BUNIT */
+	INTEL_EVENT_CONSTRAINT(0xe6, 0x1),	/* SNP_HIT_L2 */
+	INTEL_EVENT_CONSTRAINT(0xe7, 0x1),	/* SNP_HITM_L2 */
+	INTEL_EVENT_CONSTRAINT(0xf1, 0x1),	/* L2_DATA_READ_MISS_CACHE_FILL */
+	INTEL_EVENT_CONSTRAINT(0xf2, 0x1),	/* L2_DATA_WRITE_MISS_CACHE_FILL */
+	INTEL_EVENT_CONSTRAINT(0xf6, 0x1),	/* L2_DATA_READ_MISS_MEM_FILL */
+	INTEL_EVENT_CONSTRAINT(0xf7, 0x1),	/* L2_DATA_WRITE_MISS_MEM_FILL */
+	INTEL_EVENT_CONSTRAINT(0xfc, 0x1),	/* L2_DATA_PF2 */
+	INTEL_EVENT_CONSTRAINT(0xfd, 0x1),	/* L2_DATA_PF2_DROP */
+	INTEL_EVENT_CONSTRAINT(0xfe, 0x1),	/* L2_DATA_PF2_MISS */
+	INTEL_EVENT_CONSTRAINT(0xff, 0x1),	/* L2_DATA_HIT_INFLIGHT_PF2 */
+	EVENT_CONSTRAINT_END
+};
+
+#define MSR_PHI_IA32_PERF_GLOBAL_STATUS		0x0000002d
+#define MSR_PHI_IA32_PERF_GLOBAL_OVF_CONTROL	0x0000002e
+#define MSR_PHI_IA32_PERF_GLOBAL_CTRL		0x0000002f
+
+#define PHI_ENABLE_COUNTER0			0x00000001
+#define PHI_ENABLE_COUNTER1			0x00000002
+
+static void phi_pmu_disable_all(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_PHI_IA32_PERF_GLOBAL_CTRL, val);
+	val &= ~(PHI_ENABLE_COUNTER0|PHI_ENABLE_COUNTER1);
+	wrmsrl(MSR_PHI_IA32_PERF_GLOBAL_CTRL, val);
+}
+
+static void phi_pmu_enable_all(int added)
+{
+	u64 val;
+
+	rdmsrl(MSR_PHI_IA32_PERF_GLOBAL_CTRL, val);
+	val |= (PHI_ENABLE_COUNTER0|PHI_ENABLE_COUNTER1);
+	wrmsrl(MSR_PHI_IA32_PERF_GLOBAL_CTRL, val);
+}
+
+static inline void
+phi_pmu_disable_event(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	u64 val;
+
+	val = hwc->config;
+	if (cpuc->enabled)
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+
+	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
+}
+
+static void phi_pmu_enable_event(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	u64 val;
+
+	val = hwc->config;
+	if (cpuc->enabled)
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
+
+	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
+}
+
+PMU_FORMAT_ATTR(event,	"config:0-7"	);
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *intel_phi_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
+static __initconst struct x86_pmu phi_pmu = {
+	.name			= "phi",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= phi_pmu_disable_all,
+	.enable_all		= phi_pmu_enable_all,
+	.enable			= phi_pmu_enable_event,
+	.disable		= phi_pmu_disable_event,
+	.hw_config		= x86_pmu_hw_config,
+	.schedule_events	= x86_schedule_events,
+	.eventsel		= MSR_PHI_EVNTSEL0,
+	.perfctr		= MSR_PHI_PERFCTR0,
+	.event_map		= phi_pmu_event_map,
+	.max_events             = ARRAY_SIZE(phi_perfmon_event_map),
+	.apic			= 1,
+	.max_period		= (1ULL << 31) - 1,
+	.version		= 0,
+	.num_counters		= 2,
+	/* in theory 40 bits, early silicon is buggy though */
+	.cntval_bits		= 32,
+	.cntval_mask		= (1ULL << 32) - 1,
+	.get_event_constraints	= x86_get_event_constraints,
+	.event_constraints	= phi_event_constraints,
+	.format_attrs		= intel_phi_formats_attr,
+};
+
+__init int phi_pmu_init(void)
+{
+	x86_pmu = phi_pmu;
+
+	memcpy(hw_cache_event_ids, phi_hw_cache_event_ids, 
+		sizeof(hw_cache_event_ids));
+
+	return 0;
+}
