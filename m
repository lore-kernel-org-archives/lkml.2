Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab0C2MZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:25:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53921 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0C2MZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:25:42 -0400
Message-Id: <20100329122138.848413757@chello.nl>
User-Agent: quilt/0.47-1
Date: Mon, 29 Mar 2010 14:20:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC,PATCH 2/2] perf, x86: Utilize the LBRs for machine/oops debugging
References: <20100329122021.765109681@chello.nl>
Content-Disposition: inline; filename=perf-lbr-debug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LBRs are relatively cheap to keep enabled and provide some history
to OOPSen, also some CPUs are reported to keep them over soft-reset,
which allows us to use them to debug things like tripple faults.

Therefore introduce a boot option: lbr_debug=on, which always enable
the LBRs and will print the LBRs on CPU init and die().

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/perf_event.h          |    7 ++
 arch/x86/kernel/cpu/perf_event_intel.c     |    5 -
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   86 +++++++++++++++++++++++++++--
 arch/x86/kernel/dumpstack.c                |    5 +
 4 files changed, 95 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_event.h
+++ linux-2.6/arch/x86/include/asm/perf_event.h
@@ -155,9 +155,14 @@ extern void perf_events_lapic_init(void)
 
 #define perf_instruction_pointer(regs)	((regs)->ip)
 
+void dump_lbr_state(void);
+void lbr_off(void);
+
 #else
 static inline void init_hw_perf_events(void)		{ }
-static inline void perf_events_lapic_init(void)	{ }
+static inline void perf_events_lapic_init(void)		{ }
+static inline void dump_lbr_state(void)			{ }
+static inline void lbr_off(void)			{ }
 #endif
 
 #endif /* _ASM_X86_PERF_EVENT_H */
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -804,10 +804,7 @@ static __initconst const struct x86_pmu 
 static void intel_pmu_cpu_starting(int cpu)
 {
 	init_debug_store_on_cpu(cpu);
-	/*
-	 * Deal with CPUs that don't clear their LBRs on power-up.
-	 */
-	intel_pmu_lbr_reset();
+	intel_pmu_lbr_starting();
 }
 
 static void intel_pmu_cpu_dying(int cpu)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -1,12 +1,32 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
 enum {
+	LBR_DEBUG_OFF		= 0,
+	LBR_DEBUG_ON		= 1,
+};
+
+static int lbr_debug_state __read_mostly;
+
+static int __init setup_lbr_debug(char *str)
+{
+	if (!strcmp(str, "on"))
+		lbr_debug_state = LBR_DEBUG_ON;
+	else
+		return 0;
+	return 1;
+}
+
+__setup("lbr_debug=", setup_lbr_debug);
+
+enum {
 	LBR_FORMAT_32		= 0x00,
 	LBR_FORMAT_LIP		= 0x01,
 	LBR_FORMAT_EIP		= 0x02,
 	LBR_FORMAT_EIP_FLAGS	= 0x03,
 };
 
+static DEFINE_PER_CPU(int, lbr_print_done);
+
 /*
  * We only support LBR implementations that have FREEZE_LBRS_ON_PMI
  * otherwise it becomes near impossible to get a reliable stack.
@@ -50,9 +70,6 @@ static void intel_pmu_lbr_reset_64(void)
 
 static void intel_pmu_lbr_reset(void)
 {
-	if (!x86_pmu.lbr_nr)
-		return;
-
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
 		intel_pmu_lbr_reset_32();
 	else
@@ -182,6 +199,8 @@ static void intel_pmu_lbr_read(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
+	cpuc->lbr_stack.nr = 0;
+
 	if (!cpuc->lbr_users)
 		return;
 
@@ -215,4 +234,65 @@ static void intel_pmu_lbr_init_atom(void
 	x86_pmu.lbr_to     = 0x60;
 }
 
+static void __dump_lbr_state(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int i;
+
+	intel_pmu_lbr_read();
+	for (i = 0; i < cpuc->lbr_stack.nr; i++) {
+		printk(KERN_DEBUG "CPU%d LBR%d: %pF -> %pF\n",
+				smp_processor_id(), i,
+				(void *)cpuc->lbr_entries[i].from,
+				(void *)cpuc->lbr_entries[i].to);
+	}
+}
+
+static void intel_pmu_lbr_starting(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!x86_pmu.lbr_nr)
+		return;
+
+	cpuc->lbr_users = 1;
+	if (lbr_debug_state && !__get_cpu_var(lbr_print_done)) {
+		__get_cpu_var(lbr_print_done) = 1;
+		__dump_lbr_state();
+	}
+
+	intel_pmu_lbr_reset();
+
+	if (lbr_debug_state)
+		__intel_pmu_lbr_enable();
+	else
+		cpuc->lbr_users = 0;
+}
+
+void dump_lbr_state(void)
+{
+	if (!lbr_debug_state)
+		return;
+
+	__dump_lbr_state();
+}
+
+void lbr_off(void)
+{
+	if (!lbr_debug_state)
+		return;
+
+	__intel_pmu_lbr_disable();
+}
+
+#else
+
+void dump_lbr_state(void)
+{
+}
+
+void lbr_off(void)
+{
+}
+
 #endif /* CONFIG_CPU_SUP_INTEL */
Index: linux-2.6/arch/x86/kernel/dumpstack.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/dumpstack.c
+++ linux-2.6/arch/x86/kernel/dumpstack.c
@@ -17,6 +17,7 @@
 #include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
+#include <asm/perf_event.h>
 
 #include "dumpstack.h"
 
@@ -224,6 +225,8 @@ unsigned __kprobes long oops_begin(void)
 	int cpu;
 	unsigned long flags;
 
+	lbr_off();
+
 	oops_enter();
 
 	/* racy, but better than risking deadlock. */
@@ -306,6 +309,7 @@ int __kprobes __die(const char *str, str
 	printk_address(regs->ip, 1);
 	printk(" RSP <%016lx>\n", regs->sp);
 #endif
+	dump_lbr_state();
 	return 0;
 }
 
@@ -343,6 +347,7 @@ die_nmi(char *str, struct pt_regs *regs,
 	printk(" on CPU%d, ip %08lx, registers:\n",
 		smp_processor_id(), regs->ip);
 	show_registers(regs);
+	dump_lbr_state();
 	oops_end(flags, regs, 0);
 	if (do_panic || panic_on_oops)
 		panic("Non maskable interrupt");


