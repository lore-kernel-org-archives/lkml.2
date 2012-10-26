Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab2JZOo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:44:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51177 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306Ab2JZOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:44:27 -0400
Date: Fri, 26 Oct 2012 16:44:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20121026144415.GA12686@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 64dfab8e83644902ad2fd559a56c411b47e3ef3c perf/x86: Remove unused variable in nhmex_rbox_alter_er()

Most of the kernel diffstat relates to a group of Intel P6 and 
KNC (Xeon-Phi Knights Corner) PMU driver fixes, neither of which 
is in heavy use, so we took the fixes.

The rest is diverse smallish fixes to the tooling and kernel 
side.

 Thanks,

	Ingo

------------------>
Andre Przywara (1):
      x86/perf: Fix virtualization sanity check

Arnaldo Carvalho de Melo (2):
      perf trace: Validate syscall id before growing syscall table
      perf trace: Check if sample raw_data field is set

Jiri Olsa (1):
      perf test: Fix exclude_guest parse events tests

Luigi Semenzato (1):
      perf tools: do not flush maps on COMM for perf report

Namhyung Kim (1):
      perf help: Fix --help for builtins

Srivatsa S. Bhat (2):
      perf, cpu hotplug: Run CPU_STARTING notifiers with irqs disabled
      perf, cpu hotplug: Use cached value of smp_processor_id()

Vince Weaver (6):
      perf/x86: Fix P6 FP_ASSIST event constraint
      perf/x86: Update/fix generic events on P6 PMU
      perf/x86: Remove P6 cpuc->enabled check
      perf/x86: Make Intel KNC use full 40-bit width of counters
      perf/x86: Remove cpuc->enable check on Intl KNC event enable/disable
      perf/x86: Enable overflow on Intel KNC with a custom knc_pmu_handle_irq()

Wei Yongjun (1):
      perf/x86: Remove unused variable in nhmex_rbox_alter_er()

Yan, Zheng (1):
      perf/x86/uncore: Handle pci_read_config_dword() errors


 arch/x86/kernel/cpu/perf_event.c              |  10 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  45 +++++----
 arch/x86/kernel/cpu/perf_event_knc.c          |  93 ++++++++++++++++---
 arch/x86/kernel/cpu/perf_event_p6.c           | 127 +++++++++++++++++++++++---
 include/linux/perf_event.h                    |  10 +-
 tools/perf/builtin-help.c                     |   2 +-
 tools/perf/builtin-trace.c                    |  18 +++-
 tools/perf/util/parse-events-test.c           |  12 ++-
 tools/perf/util/thread.c                      |   1 -
 9 files changed, 257 insertions(+), 61 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3373f84..4a3374e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -208,12 +208,14 @@ static bool check_hw_exists(void)
 	}
 
 	/*
-	 * Now write a value and read it back to see if it matches,
-	 * this is needed to detect certain hardware emulators (qemu/kvm)
-	 * that don't trap on the MSR access and always return 0s.
+	 * Read the current value, change it and read it back to see if it
+	 * matches, this is needed to detect certain hardware emulators
+	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
 	 */
-	val = 0xabcdUL;
 	reg = x86_pmu_event_addr(0);
+	if (rdmsrl_safe(reg, &val))
+		goto msr_fail;
+	val ^= 0xffffUL;
 	ret = wrmsrl_safe(reg, val);
 	ret |= rdmsrl_safe(reg, &val_new);
 	if (ret || val != val_new)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 5df8d32..3cf3d97 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -118,22 +118,24 @@ static void snbep_uncore_pci_disable_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = uncore_pci_box_ctl(box);
-	u32 config;
+	u32 config = 0;
 
-	pci_read_config_dword(pdev, box_ctl, &config);
-	config |= SNBEP_PMON_BOX_CTL_FRZ;
-	pci_write_config_dword(pdev, box_ctl, config);
+	if (!pci_read_config_dword(pdev, box_ctl, &config)) {
+		config |= SNBEP_PMON_BOX_CTL_FRZ;
+		pci_write_config_dword(pdev, box_ctl, config);
+	}
 }
 
 static void snbep_uncore_pci_enable_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = uncore_pci_box_ctl(box);
-	u32 config;
+	u32 config = 0;
 
-	pci_read_config_dword(pdev, box_ctl, &config);
-	config &= ~SNBEP_PMON_BOX_CTL_FRZ;
-	pci_write_config_dword(pdev, box_ctl, config);
+	if (!pci_read_config_dword(pdev, box_ctl, &config)) {
+		config &= ~SNBEP_PMON_BOX_CTL_FRZ;
+		pci_write_config_dword(pdev, box_ctl, config);
+	}
 }
 
 static void snbep_uncore_pci_enable_event(struct intel_uncore_box *box, struct perf_event *event)
@@ -156,7 +158,7 @@ static u64 snbep_uncore_pci_read_counter(struct intel_uncore_box *box, struct pe
 {
 	struct pci_dev *pdev = box->pci_dev;
 	struct hw_perf_event *hwc = &event->hw;
-	u64 count;
+	u64 count = 0;
 
 	pci_read_config_dword(pdev, hwc->event_base, (u32 *)&count);
 	pci_read_config_dword(pdev, hwc->event_base + 4, (u32 *)&count + 1);
@@ -603,11 +605,12 @@ static struct pci_driver snbep_uncore_pci_driver = {
 /*
  * build pci bus to socket mapping
  */
-static void snbep_pci2phy_map_init(void)
+static int snbep_pci2phy_map_init(void)
 {
 	struct pci_dev *ubox_dev = NULL;
 	int i, bus, nodeid;
-	u32 config;
+	int err = 0;
+	u32 config = 0;
 
 	while (1) {
 		/* find the UBOX device */
@@ -618,10 +621,14 @@ static void snbep_pci2phy_map_init(void)
 			break;
 		bus = ubox_dev->bus->number;
 		/* get the Node ID of the local register */
-		pci_read_config_dword(ubox_dev, 0x40, &config);
+		err = pci_read_config_dword(ubox_dev, 0x40, &config);
+		if (err)
+			break;
 		nodeid = config;
 		/* get the Node ID mapping */
-		pci_read_config_dword(ubox_dev, 0x54, &config);
+		err = pci_read_config_dword(ubox_dev, 0x54, &config);
+		if (err)
+			break;
 		/*
 		 * every three bits in the Node ID mapping register maps
 		 * to a particular node.
@@ -633,7 +640,11 @@ static void snbep_pci2phy_map_init(void)
 			}
 		}
 	};
-	return;
+
+	if (ubox_dev)
+		pci_dev_put(ubox_dev);
+
+	return err ? pcibios_err_to_errno(err) : 0;
 }
 /* end of Sandy Bridge-EP uncore support */
 
@@ -1547,7 +1558,6 @@ void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
-	int port;
 
 	/* adjust the main event selector and extra register index */
 	if (reg1->idx % 2) {
@@ -1559,7 +1569,6 @@ void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 	}
 
 	/* adjust extra register config */
-	port = reg1->idx / 6 + box->pmu->pmu_idx * 4;
 	switch (reg1->idx % 6) {
 	case 2:
 		/* shift the 8~15 bits to the 0~7 bits */
@@ -2578,9 +2587,11 @@ static int __init uncore_pci_init(void)
 
 	switch (boot_cpu_data.x86_model) {
 	case 45: /* Sandy Bridge-EP */
+		ret = snbep_pci2phy_map_init();
+		if (ret)
+			return ret;
 		pci_uncores = snbep_pci_uncores;
 		uncore_pci_driver = &snbep_uncore_pci_driver;
-		snbep_pci2phy_map_init();
 		break;
 	default:
 		return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 7c46bfd..4b7731b 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -3,6 +3,8 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
+#include <asm/hardirq.h>
+
 #include "perf_event.h"
 
 static const u64 knc_perfmon_event_map[] =
@@ -173,30 +175,100 @@ static void knc_pmu_enable_all(int added)
 static inline void
 knc_pmu_disable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+	val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
 }
 
 static void knc_pmu_enable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
+	val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
 }
 
+static inline u64 knc_pmu_get_status(void)
+{
+	u64 status;
+
+	rdmsrl(MSR_KNC_IA32_PERF_GLOBAL_STATUS, status);
+
+	return status;
+}
+
+static inline void knc_pmu_ack_status(u64 ack)
+{
+	wrmsrl(MSR_KNC_IA32_PERF_GLOBAL_OVF_CONTROL, ack);
+}
+
+static int knc_pmu_handle_irq(struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct cpu_hw_events *cpuc;
+	int handled = 0;
+	int bit, loops;
+	u64 status;
+
+	cpuc = &__get_cpu_var(cpu_hw_events);
+
+	knc_pmu_disable_all();
+
+	status = knc_pmu_get_status();
+	if (!status) {
+		knc_pmu_enable_all(0);
+		return handled;
+	}
+
+	loops = 0;
+again:
+	knc_pmu_ack_status(status);
+	if (++loops > 100) {
+		WARN_ONCE(1, "perf: irq loop stuck!\n");
+		perf_event_print_debug();
+		goto done;
+	}
+
+	inc_irq_stat(apic_perf_irqs);
+
+	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
+		struct perf_event *event = cpuc->events[bit];
+
+		handled++;
+
+		if (!test_bit(bit, cpuc->active_mask))
+			continue;
+
+		if (!intel_pmu_save_and_restart(event))
+			continue;
+
+		perf_sample_data_init(&data, 0, event->hw.last_period);
+
+		if (perf_event_overflow(event, &data, regs))
+			x86_pmu_stop(event, 0);
+	}
+
+	/*
+	 * Repeat if there is more work to be done:
+	 */
+	status = knc_pmu_get_status();
+	if (status)
+		goto again;
+
+done:
+	knc_pmu_enable_all(0);
+
+	return handled;
+}
+
+
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -214,7 +286,7 @@ static struct attribute *intel_knc_formats_attr[] = {
 
 static __initconst struct x86_pmu knc_pmu = {
 	.name			= "knc",
-	.handle_irq		= x86_pmu_handle_irq,
+	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
 	.enable_all		= knc_pmu_enable_all,
 	.enable			= knc_pmu_enable_event,
@@ -226,12 +298,11 @@ static __initconst struct x86_pmu knc_pmu = {
 	.event_map		= knc_pmu_event_map,
 	.max_events             = ARRAY_SIZE(knc_perfmon_event_map),
 	.apic			= 1,
-	.max_period		= (1ULL << 31) - 1,
+	.max_period		= (1ULL << 39) - 1,
 	.version		= 0,
 	.num_counters		= 2,
-	/* in theory 40 bits, early silicon is buggy though */
-	.cntval_bits		= 32,
-	.cntval_mask		= (1ULL << 32) - 1,
+	.cntval_bits		= 40,
+	.cntval_mask		= (1ULL << 40) - 1,
 	.get_event_constraints	= x86_get_event_constraints,
 	.event_constraints	= knc_event_constraints,
 	.format_attrs		= intel_knc_formats_attr,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index e4dd0f7..7d0270b 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -8,13 +8,106 @@
  */
 static const u64 p6_perfmon_event_map[] =
 {
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
-  [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,	/* CPU_CLK_UNHALTED */
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,	/* INST_RETIRED     */
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,	/* L2_RQSTS:M:E:S:I */
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,	/* L2_RQSTS:I       */
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,	/* BR_INST_RETIRED  */
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,	/* BR_MISS_PRED_RETIRED */
+  [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,	/* BUS_DRDY_CLOCKS  */
+  [PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x00a2,	/* RESOURCE_STALLS  */
+
+};
+
+static __initconst u64 p6_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0043,	/* DATA_MEM_REFS       */
+                [ C(RESULT_MISS)   ] = 0x0045,	/* DCU_LINES_IN        */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0x0f29,	/* L2_LD:M:E:S:I       */
+	},
+        [ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+        },
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080,	/* IFU_IFETCH         */
+		[ C(RESULT_MISS)   ] = 0x0f28,	/* L2_IFETCH:M:E:S:I  */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0x0025,	/* L2_M_LINES_INM     */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0043,	/* DATA_MEM_REFS      */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080,	/* IFU_IFETCH         */
+		[ C(RESULT_MISS)   ] = 0x0085,	/* ITLB_MISS          */
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
+		[ C(RESULT_ACCESS) ] = 0x00c4,	/* BR_INST_RETIRED      */
+		[ C(RESULT_MISS)   ] = 0x00c5,	/* BR_MISS_PRED_RETIRED */
+        },
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
 };
 
 static u64 p6_pmu_event_map(int hw_event)
@@ -34,7 +127,7 @@ static struct event_constraint p6_event_constraints[] =
 {
 	INTEL_EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
 	INTEL_EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
-	INTEL_EVENT_CONSTRAINT(0x11, 0x1),	/* FP_ASSIST */
+	INTEL_EVENT_CONSTRAINT(0x11, 0x2),	/* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
 	INTEL_EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
 	INTEL_EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
@@ -64,25 +157,25 @@ static void p6_pmu_enable_all(int added)
 static inline void
 p6_pmu_disable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val = P6_NOP_EVENT;
 
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
-
 	(void)wrmsrl_safe(hwc->config_base, val);
 }
 
 static void p6_pmu_enable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
+
+	/*
+	 * p6 only has a global event enable, set on PerfEvtSel0
+	 * We "disable" events by programming P6_NOP_EVENT
+	 * and we rely on p6_pmu_enable_all() being called
+	 * to actually enable the events.
+	 */
 
 	(void)wrmsrl_safe(hwc->config_base, val);
 }
@@ -158,5 +251,9 @@ __init int p6_pmu_init(void)
 
 	x86_pmu = p6_pmu;
 
+	memcpy(hw_cache_event_ids, p6_hw_cache_event_ids,
+		sizeof(hw_cache_event_ids));
+
+
 	return 0;
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e90235..6bfb2faa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -803,12 +803,16 @@ static inline void perf_event_task_tick(void)				{ }
 do {									\
 	static struct notifier_block fn##_nb __cpuinitdata =		\
 		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
+	unsigned long cpu = smp_processor_id();				\
+	unsigned long flags;						\
 	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
+	local_irq_save(flags);						\
 	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
+	local_irq_restore(flags);					\
 	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
 	register_cpu_notifier(&fn##_nb);				\
 } while (0)
 
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 411ee56..178b88a 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -414,7 +414,7 @@ static int show_html_page(const char *perf_cmd)
 int cmd_help(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	bool show_all = false;
-	enum help_format help_format = HELP_FORMAT_NONE;
+	enum help_format help_format = HELP_FORMAT_MAN;
 	struct option builtin_help_options[] = {
 	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
 	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dec8ced..7aaee39 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -56,6 +56,10 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 {
 	char tp_name[128];
 	struct syscall *sc;
+	const char *name = audit_syscall_to_name(id, trace->audit_machine);
+
+	if (name == NULL)
+		return -1;
 
 	if (id > trace->syscalls.max) {
 		struct syscall *nsyscalls = realloc(trace->syscalls.table, (id + 1) * sizeof(*sc));
@@ -75,11 +79,8 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	}
 
 	sc = trace->syscalls.table + id;
-	sc->name = audit_syscall_to_name(id, trace->audit_machine);
-	if (sc->name == NULL)
-		return -1;
-
-	sc->fmt = syscall_fmt__find(sc->name);
+	sc->name = name;
+	sc->fmt  = syscall_fmt__find(sc->name);
 
 	snprintf(tp_name, sizeof(tp_name), "sys_enter_%s", sc->name);
 	sc->tp_format = event_format__new("syscalls", tp_name);
@@ -267,6 +268,13 @@ again:
 			if (evlist->threads->map[0] == -1 || evlist->threads->nr > 1)
 				printf("%d ", sample.tid);
 
+			if (sample.raw_data == NULL) {
+				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
+				       perf_evsel__name(evsel), sample.tid,
+				       sample.cpu, sample.raw_size);
+				continue;
+			}
+
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
 		}
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 28c18d1..516ecd9 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -513,7 +513,8 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
@@ -599,7 +600,8 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 3);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
@@ -662,7 +664,8 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
@@ -676,7 +679,8 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..8b3e593 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -39,7 +39,6 @@ int thread__set_comm(struct thread *self, const char *comm)
 	err = self->comm == NULL ? -ENOMEM : 0;
 	if (!err) {
 		self->comm_set = true;
-		map_groups__flush(&self->mg);
 	}
 	return err;
 }
