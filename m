Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2JEHZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:25:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60089 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2JEHZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:25:13 -0400
Date: Fri, 5 Oct 2012 00:24:06 -0700
From: tip-bot for Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <tip-e717bf4e4fe8adc519f25c4ff93ee50ed0a36710@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, gorcunov@openvz.org, lawrence.f.meadows@intel.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, lawrence.f.meadows@intel.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1209261405320.8398@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1209261405320.8398@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Add support for Intel Xeon-Phi Knights Corner PMU
Git-Commit-ID: e717bf4e4fe8adc519f25c4ff93ee50ed0a36710
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 00:24:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e717bf4e4fe8adc519f25c4ff93ee50ed0a36710
Gitweb:     http://git.kernel.org/tip/e717bf4e4fe8adc519f25c4ff93ee50ed0a36710
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Wed, 26 Sep 2012 14:12:52 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 4 Oct 2012 13:32:37 +0200

perf/x86: Add support for Intel Xeon-Phi Knights Corner PMU

The following patch adds perf_event support for the Xeon-Phi
PMU, as documented in the "Intel Xeon Phi Coprocessor (codename:
Knights Corner) Performance Monitoring Units" manual.

Even though it is a co-processor, a Phi runs a full Linux
environment and can support performance counters.

This is just barebones support, it does not add support for
interesting new features such as the SPFLT intruction that
allows starting/stopping events without entering the kernel.

The PMU internally is just like that of an original Pentium, but
a "P6-like" MSR interface is provided.  The interface is
different enough from a real P6 that it's not easy (or
practical) to re-use the code in  perf_event_p6.c

Acked-by: Lawrence F Meadows <lawrence.f.meadows@intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: eranian@gmail.com
Cc: Lawrence F <lawrence.f.meadows@intel.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1209261405320.8398@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/msr-index.h       |    5 +
 arch/x86/kernel/cpu/Makefile           |    2 +-
 arch/x86/kernel/cpu/perf_event.h       |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +
 arch/x86/kernel/cpu/perf_event_knc.c   |  248 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perfctr-watchdog.c |    4 +
 6 files changed, 262 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 957ec87..07f96cb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -121,6 +121,11 @@
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
 
+#define MSR_KNC_PERFCTR0               0x00000020
+#define MSR_KNC_PERFCTR1               0x00000021
+#define MSR_KNC_EVNTSEL0               0x00000028
+#define MSR_KNC_EVNTSEL1               0x00000029
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index d30a6a9..a0e067d 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 ifdef CONFIG_PERF_EVENTS
 obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
 endif
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8b6defe..271d257 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -626,6 +626,8 @@ int p4_pmu_init(void);
 
 int p6_pmu_init(void);
 
+int knc_pmu_init(void);
+
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static inline void reserve_ds_buffers(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6bca492..324bb52 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1906,6 +1906,8 @@ __init int intel_pmu_init(void)
 		switch (boot_cpu_data.x86) {
 		case 0x6:
 			return p6_pmu_init();
+		case 0xb:
+			return knc_pmu_init();
 		case 0xf:
 			return p4_pmu_init();
 		}
diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
new file mode 100644
index 0000000..7c46bfd
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -0,0 +1,248 @@
+/* Driver for Intel Xeon Phi "Knights Corner" PMU */
+
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include "perf_event.h"
+
+static const u64 knc_perfmon_event_map[] =
+{
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x002a,
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x0016,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0028,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0029,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x0012,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
+};
+
+static __initconst u64 knc_hw_cache_event_ids
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
+static u64 knc_pmu_event_map(int hw_event)
+{
+	return knc_perfmon_event_map[hw_event];
+}
+
+static struct event_constraint knc_event_constraints[] =
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
+#define MSR_KNC_IA32_PERF_GLOBAL_STATUS		0x0000002d
+#define MSR_KNC_IA32_PERF_GLOBAL_OVF_CONTROL	0x0000002e
+#define MSR_KNC_IA32_PERF_GLOBAL_CTRL		0x0000002f
+
+#define KNC_ENABLE_COUNTER0			0x00000001
+#define KNC_ENABLE_COUNTER1			0x00000002
+
+static void knc_pmu_disable_all(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+	val &= ~(KNC_ENABLE_COUNTER0|KNC_ENABLE_COUNTER1);
+	wrmsrl(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+}
+
+static void knc_pmu_enable_all(int added)
+{
+	u64 val;
+
+	rdmsrl(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+	val |= (KNC_ENABLE_COUNTER0|KNC_ENABLE_COUNTER1);
+	wrmsrl(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+}
+
+static inline void
+knc_pmu_disable_event(struct perf_event *event)
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
+static void knc_pmu_enable_event(struct perf_event *event)
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
+static struct attribute *intel_knc_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
+static __initconst struct x86_pmu knc_pmu = {
+	.name			= "knc",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= knc_pmu_disable_all,
+	.enable_all		= knc_pmu_enable_all,
+	.enable			= knc_pmu_enable_event,
+	.disable		= knc_pmu_disable_event,
+	.hw_config		= x86_pmu_hw_config,
+	.schedule_events	= x86_schedule_events,
+	.eventsel		= MSR_KNC_EVNTSEL0,
+	.perfctr		= MSR_KNC_PERFCTR0,
+	.event_map		= knc_pmu_event_map,
+	.max_events             = ARRAY_SIZE(knc_perfmon_event_map),
+	.apic			= 1,
+	.max_period		= (1ULL << 31) - 1,
+	.version		= 0,
+	.num_counters		= 2,
+	/* in theory 40 bits, early silicon is buggy though */
+	.cntval_bits		= 32,
+	.cntval_mask		= (1ULL << 32) - 1,
+	.get_event_constraints	= x86_get_event_constraints,
+	.event_constraints	= knc_event_constraints,
+	.format_attrs		= intel_knc_formats_attr,
+};
+
+__init int knc_pmu_init(void)
+{
+	x86_pmu = knc_pmu;
+
+	memcpy(hw_cache_event_ids, knc_hw_cache_event_ids, 
+		sizeof(hw_cache_event_ids));
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 966512b..2e8caf0 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -56,6 +56,8 @@ static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
 		switch (boot_cpu_data.x86) {
 		case 6:
 			return msr - MSR_P6_PERFCTR0;
+		case 11:
+			return msr - MSR_KNC_PERFCTR0;
 		case 15:
 			return msr - MSR_P4_BPU_PERFCTR0;
 		}
@@ -82,6 +84,8 @@ static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
 		switch (boot_cpu_data.x86) {
 		case 6:
 			return msr - MSR_P6_EVNTSEL0;
+		case 11:
+			return msr - MSR_KNC_EVNTSEL0;
 		case 15:
 			return msr - MSR_P4_BSU_ESCR0;
 		}
