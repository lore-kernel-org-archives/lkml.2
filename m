Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2LEQRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:17:19 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51591 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab2LEQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:37 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 24/44] metag: IRQ handling
Date: Wed, 5 Dec 2012 16:08:42 +0000
Message-ID: <1354723742-6195-25-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add core IRQ handling for metag. The code in irq.c exposes the TBX
signal numbers as Linux IRQs.

Meta core internal interrupts (from HWSTATMETA and friends) are vectored
onto the TR1 core trigger for the current thread. This is demultiplexed
in irq_internal.c to individual Linux IRQs for each internal interrupt.

External SoC interrupts (from HWSTATEXT and friends) are vectored onto
the TR2 core trigger for the current thread. This is demultiplexed in
irq_external.c to individual Linux IRQs for each external SoC interrupt.

TODO: make purer use of sparse IRQs
TODO: move IRQ drivers into drivers/irqchip

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 .../devicetree/bindings/metag/meta-intc.txt        |   92 ++
 arch/metag/include/asm/irq.h                       |   79 ++
 arch/metag/include/asm/irq_external.h              |   33 +
 arch/metag/include/asm/irq_internal.h              |   16 +
 arch/metag/include/asm/irqflags.h                  |   97 +++
 arch/metag/kernel/irq.c                            |  277 ++++++
 arch/metag/kernel/irq_external.c                   |  886 ++++++++++++++++++++
 arch/metag/kernel/irq_internal.c                   |  237 ++++++
 8 files changed, 1717 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta-intc.txt
 create mode 100644 arch/metag/include/asm/irq.h
 create mode 100644 arch/metag/include/asm/irq_external.h
 create mode 100644 arch/metag/include/asm/irq_internal.h
 create mode 100644 arch/metag/include/asm/irqflags.h
 create mode 100644 arch/metag/kernel/irq.c
 create mode 100644 arch/metag/kernel/irq_external.c
 create mode 100644 arch/metag/kernel/irq_internal.c

diff --git a/Documentation/devicetree/bindings/metag/meta-intc.txt b/Documentation/devicetree/bindings/metag/meta-intc.txt
new file mode 100644
index 0000000..b9bbe19
--- /dev/null
+++ b/Documentation/devicetree/bindings/metag/meta-intc.txt
@@ -0,0 +1,92 @@
+* Meta External Trigger Controller Binding
+
+This binding specifies what properties must be available in the device tree
+representation of a Meta external trigger controller.
+
+Required properties:
+
+    - compatible: Specifies the compatibility list for the interrupt controller.
+      The type shall be <string> and the value shall include "img,meta-intc".
+
+    - num-banks: Specifies the number of interrupt banks (each of which can
+      handle 32 interrupt sources).
+
+    - interrupt-controller: The presence of this property identifies the node
+      as an interupt controller. No property value shall be defined.
+
+    - #interrupt-cells: Specifies the number of cells needed to encode an
+      interrupt source. The type shall be a <u32> and the value shall be 2.
+
+    - #address-cells: Specifies the number of cells needed to encode an
+      address. The type shall be <u32> and the value shall be 0. As such,
+      'interrupt-map' nodes do not have to specify a parent unit address.
+
+Optional properties:
+
+    - no-mask: The controller doesn't have any mask registers.
+
+    - default-level: List of default level bitfields, one for each bank, where
+      each set bit indicates that the interrupt should be level sensitive by
+      default rather than edge. The purpose of this is mainly to ease the
+      transition to device tree from platform data. It should not be necessary
+      if all IRQ users are configured with devicetree as each one should set the
+      flow type in the interrupt specifier.
+
+* Interrupt Specifier Definition
+
+  Interrupt specifiers consists of 2 cells encoded as follows:
+
+    - <1st-cell>: The interrupt-number that identifies the interrupt source.
+
+    - <2nd-cell>: The Linux interrupt flags containing level-sense information,
+                  encoded as follows:
+                    1 = edge triggered
+                    4 = level-sensitive
+
+* Examples
+
+Example 1:
+
+	/*
+	 * Meta external trigger block
+	 */
+	intc: intc {
+		// This is an interrupt controller node.
+		interrupt-controller;
+
+		// No address cells so that 'interrupt-map' nodes which
+		// reference this interrupt controller node do not need a parent
+		// address specifier.
+		#address-cells = <0>;
+
+		// Two cells to encode interrupt sources.
+		#interrupt-cells = <2>;
+
+		// Number of interrupt banks
+		num-banks = <2>;
+
+		// IRQs 0-35 are level sensitive, except 16 and 34
+		default-level = <0xfffeffff 0xb>;
+
+		// No HWMASKEXT is available (specify on Chorus2 and Comet ES1)
+		no-mask;
+
+		// Compatible with Meta hardware trigger block.
+		compatible = "img,meta-intc";
+	};
+
+Example 2:
+
+	/*
+	 * An interrupt generating device that is wired to a Meta external
+	 * trigger block.
+	 */
+	uart1: uart@0x02004c00 {
+		// Interrupt source '5' that is level-sensitive.
+		// Note that there are only two cells as specified in the
+		// interrupt parent's '#interrupt-cells' property.
+		interrupts = <5 4 /* level */>;
+
+		// The interrupt controller that this device is wired to.
+		interrupt-parent = <&intc>;
+	};
diff --git a/arch/metag/include/asm/irq.h b/arch/metag/include/asm/irq.h
new file mode 100644
index 0000000..da24886
--- /dev/null
+++ b/arch/metag/include/asm/irq.h
@@ -0,0 +1,79 @@
+#ifndef __ASM_METAG_IRQ_H
+#define __ASM_METAG_IRQ_H
+
+#define HWSTATEXT_OFFSET_MAX	0
+#define HWSTATEXT2_OFFSET_MAX	0
+#define HWSTATEXT4_OFFSET_MAX	0
+#define HWSTATEXT6_OFFSET_MAX	0
+#define init_soc_IRQ NULL
+#include <asm/irq_internal.h>
+#ifndef HW_IRQS
+#define HW_IRQS  (HWSTATMETA_OFFSET_MAX + HWSTATEXT_OFFSET_MAX + \
+		HWSTATEXT2_OFFSET_MAX + HWSTATEXT4_OFFSET_MAX + \
+		HWSTATEXT6_OFFSET_MAX)
+#endif
+
+#define META_IRQS 32
+
+#define NR_IRQS (META_IRQS + HW_IRQS)
+
+/*
+ * Automatic IRQ numbering
+ *
+ * Maps triggers into IRQs depending on which triggers are used.
+ * HWSTATEXT*_OFFSET_MAX must be defined in SoC's irq.h file.
+ */
+#define HWSTATMETA_TO_IRQ(offset)	(META_IRQS+(offset))
+
+#define HWSTATEXT_TO_HWIRQ(offset)	(offset)
+#define HWSTATEXT2_TO_HWIRQ(offset)	(HWSTATEXT_TO_HWIRQ(HWSTATEXT_OFFSET_MAX)+(offset))
+#define HWSTATEXT4_TO_HWIRQ(offset)	(HWSTATEXT2_TO_HWIRQ(HWSTATEXT2_OFFSET_MAX)+(offset))
+#define HWSTATEXT6_TO_HWIRQ(offset)	(HWSTATEXT4_TO_HWIRQ(HWSTATEXT4_OFFSET_MAX)+(offset))
+
+#define HWSTATEXT_TO_IRQ(offset)	(HWSTATMETA_TO_IRQ(HWSTATMETA_OFFSET_MAX)+(offset))
+#define HWSTATEXT2_TO_IRQ(offset)	(HWSTATEXT_TO_IRQ(HWSTATEXT_OFFSET_MAX)+(offset))
+#define HWSTATEXT4_TO_IRQ(offset)	(HWSTATEXT2_TO_IRQ(HWSTATEXT2_OFFSET_MAX)+(offset))
+#define HWSTATEXT6_TO_IRQ(offset)	(HWSTATEXT4_TO_IRQ(HWSTATEXT4_OFFSET_MAX)+(offset))
+
+static inline unsigned int IRQ_TO_OFFSET(unsigned int irq)
+{
+	if (irq < HWSTATMETA_TO_IRQ(0))
+		return irq;
+	else if (irq < HWSTATEXT_TO_IRQ(0))
+		return irq - HWSTATMETA_TO_IRQ(0);
+	else if (irq < HWSTATEXT2_TO_IRQ(0))
+		return irq - HWSTATEXT_TO_IRQ(0);
+	else if (irq < HWSTATEXT4_TO_IRQ(0))
+		return irq - HWSTATEXT2_TO_IRQ(0);
+	else /* if (irq < HWSTATEXT6_TO_IRQ(0)) */
+		return irq - HWSTATEXT6_TO_IRQ(0);
+}
+
+#ifdef CONFIG_4KSTACKS
+extern void irq_ctx_init(int cpu);
+extern void irq_ctx_exit(int cpu);
+# define __ARCH_HAS_DO_SOFTIRQ
+#else
+# define irq_ctx_init(cpu) do { } while (0)
+# define irq_ctx_exit(cpu) do { } while (0)
+#endif
+
+void tbi_startup_interrupt(int);
+void tbi_shutdown_interrupt(int);
+
+struct pt_regs;
+
+extern void do_IRQ(int irq, struct pt_regs *regs);
+
+#ifdef CONFIG_METAG_SUSPEND_MEM
+int traps_save_context(void);
+int traps_restore_context(void);
+#endif
+
+#include <asm-generic/irq.h>
+
+#ifdef CONFIG_HOTPLUG_CPU
+extern void migrate_irqs(void);
+#endif
+
+#endif /* __ASM_METAG_IRQ_H */
diff --git a/arch/metag/include/asm/irq_external.h b/arch/metag/include/asm/irq_external.h
new file mode 100644
index 0000000..77ebc2a
--- /dev/null
+++ b/arch/metag/include/asm/irq_external.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2012 Imagination Technologies
+ */
+
+#ifndef _METAG_IRQ_EXTERNAL_H_
+#define _METAG_IRQ_EXTERNAL_H_
+
+struct irq_data;
+struct platform_device;
+
+/* called from core irq code at init */
+int init_external_IRQ(void);
+
+/*
+ * called from SoC init_irq() callback to dynamically indicate the lack of
+ * HWMASKEXT registers.
+ */
+void meta_intc_no_mask(void);
+
+/*
+ * These allow SoCs to specialise the interrupt controller from their init_irq
+ * callbacks.
+ */
+
+extern struct irq_chip meta_intc_edge_chip;
+extern struct irq_chip meta_intc_level_chip;
+
+/* this should be called in the mask callback */
+void meta_intc_mask_irq_simple(struct irq_data *data);
+/* this should be called in the unmask callback */
+void meta_intc_unmask_irq_simple(struct irq_data *data);
+
+#endif /* _METAG_IRQ_EXTERNAL_H_ */
diff --git a/arch/metag/include/asm/irq_internal.h b/arch/metag/include/asm/irq_internal.h
new file mode 100644
index 0000000..a38de66
--- /dev/null
+++ b/arch/metag/include/asm/irq_internal.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) 2011 Imagination Technologies
+ */
+
+#ifndef _METAG_IRQ_INTERNAL_H_
+#define _METAG_IRQ_INTERNAL_H_
+
+#define HWSTATMETA_OFFSET_MAX	32
+
+#ifdef CONFIG_METAG_PERFCOUNTER_IRQS
+extern void init_internal_IRQ(void);
+#else
+#define init_internal_IRQ() do {} while (0)
+#endif
+
+#endif /* _METAG_IRQ_INTERNAL_H_ */
diff --git a/arch/metag/include/asm/irqflags.h b/arch/metag/include/asm/irqflags.h
new file mode 100644
index 0000000..ab5df87
--- /dev/null
+++ b/arch/metag/include/asm/irqflags.h
@@ -0,0 +1,97 @@
+/*
+ * IRQ flags handling
+ *
+ * This file gets included from lowlevel asm headers too, to provide
+ * wrapped versions of the local_irq_*() APIs, based on the
+ * raw_local_irq_*() functions from the lowlevel headers.
+ */
+#ifndef _ASM_IRQFLAGS_H
+#define _ASM_IRQFLAGS_H
+
+#ifndef __ASSEMBLY__
+
+#include <asm/metag_regs.h>
+
+#define INTS_OFF_MASK TXSTATI_BGNDHALT_BIT
+
+#ifdef CONFIG_SMP
+extern unsigned int get_trigger_mask(void);
+#else
+
+extern unsigned int global_trigger_mask;
+
+static inline unsigned int get_trigger_mask(void)
+{
+	return global_trigger_mask;
+}
+#endif
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+
+	asm volatile("MOV %0,TXMASKI\n" : "=r" (flags));
+
+	return flags;
+}
+
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & ~INTS_OFF_MASK) == 0;
+}
+
+static inline int arch_irqs_disabled(void)
+{
+	unsigned long flags = arch_local_save_flags();
+
+	return arch_irqs_disabled_flags(flags);
+}
+
+static inline unsigned long __irqs_disabled(void)
+{
+	/*
+	 * We shouldn't enable exceptions if they are not already
+	 * enabled. This is required for chancalls to work correctly.
+	 */
+	return arch_local_save_flags() & INTS_OFF_MASK;
+}
+
+/*
+ * For spinlocks, etc:
+ */
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags = __irqs_disabled();
+
+	asm volatile("SWAP %0,TXMASKI\n" : "=r" (flags) : "0" (flags)
+		     : "memory");
+
+	return flags;
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile("MOV TXMASKI,%0\n" : : "r" (flags) : "memory");
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	unsigned long flags = __irqs_disabled();
+
+	asm volatile("MOV TXMASKI,%0\n" : : "r" (flags) : "memory");
+}
+
+static inline void arch_local_irq_enable(void)
+{
+#ifdef CONFIG_SMP
+	preempt_disable();
+	arch_local_irq_restore(get_trigger_mask());
+	preempt_enable_no_resched();
+#else
+	arch_local_irq_restore(get_trigger_mask());
+#endif
+}
+
+#endif /* (__ASSEMBLY__) */
+
+#endif /* !(_ASM_IRQFLAGS_H) */
diff --git a/arch/metag/kernel/irq.c b/arch/metag/kernel/irq.c
new file mode 100644
index 0000000..195fb12
--- /dev/null
+++ b/arch/metag/kernel/irq.c
@@ -0,0 +1,277 @@
+/*
+ * Linux/Meta general interrupt handling code
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/ratelimit.h>
+
+#include <asm/irq_external.h>
+#include <asm/mach/arch.h>
+#include <asm/uaccess.h>
+
+#ifdef CONFIG_4KSTACKS
+union irq_ctx {
+	struct thread_info      tinfo;
+	u32                     stack[THREAD_SIZE/sizeof(u32)];
+};
+
+static union irq_ctx *hardirq_ctx[NR_CPUS] __read_mostly;
+static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
+#endif
+
+static unsigned int startup_meta_irq(struct irq_data *data)
+{
+	tbi_startup_interrupt(data->irq);
+	return 0;
+}
+
+static void shutdown_meta_irq(struct irq_data *data)
+{
+	tbi_shutdown_interrupt(data->irq);
+}
+
+void do_IRQ(int irq, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+#ifdef CONFIG_4KSTACKS
+	struct irq_desc *desc;
+	union irq_ctx *curctx, *irqctx;
+	u32 *isp;
+#endif
+
+	irq_enter();
+
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	/* Debugging check for stack overflow: is there less than 1KB free? */
+	{
+		unsigned long sp;
+
+		__asm__ __volatile__("MOV %0,A0StP\n" : "=r"(sp));
+		sp &= THREAD_SIZE - 1;
+
+		if (unlikely(sp > (THREAD_SIZE - 1024)))
+			pr_err("Stack overflow in do_IRQ: %ld\n", sp);
+	}
+#endif
+
+
+#ifdef CONFIG_4KSTACKS
+	curctx = (union irq_ctx *) current_thread_info();
+	irqctx = hardirq_ctx[smp_processor_id()];
+
+	/*
+	 * this is where we switch to the IRQ stack. However, if we are
+	 * already using the IRQ stack (because we interrupted a hardirq
+	 * handler) we can't do that and just have to keep using the
+	 * current stack (which is the irq stack already after all)
+	 */
+	if (curctx != irqctx) {
+		/* build the stack frame on the IRQ stack */
+		isp = (u32 *) ((char *)irqctx + sizeof(struct thread_info));
+		irqctx->tinfo.task = curctx->tinfo.task;
+
+		/*
+		 * Copy the softirq bits in preempt_count so that the
+		 * softirq checks work in the hardirq context.
+		 */
+		irqctx->tinfo.preempt_count =
+			(irqctx->tinfo.preempt_count & ~SOFTIRQ_MASK) |
+			(curctx->tinfo.preempt_count & SOFTIRQ_MASK);
+
+		desc = irq_to_desc(irq);
+
+		asm volatile(
+			"MOV   D0.5,%0\n"
+			"MOV   D1Ar1,%1\n"
+			"MOV   D1RtP,%2\n"
+			"MOV   D0Ar2,%3\n"
+			"SWAP  A0StP,D0.5\n"
+			"SWAP  PC,D1RtP\n"
+			"MOV   A0StP,D0.5\n"
+			:
+			: "r" (isp), "r" (irq), "r" (desc->handle_irq),
+			  "r" (desc)
+			: "memory", "cc", "D1Ar1", "D0Ar2", "D1Ar3", "D0Ar4",
+			  "D1Ar5", "D0Ar6", "D0Re0", "D1Re0", "D0.4", "D1RtP",
+			  "D0.5"
+			);
+	} else
+#endif
+		generic_handle_irq(irq);
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
+#ifdef CONFIG_4KSTACKS
+
+static char softirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
+
+static char hardirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
+
+/*
+ * allocate per-cpu stacks for hardirq and for softirq processing
+ */
+void irq_ctx_init(int cpu)
+{
+	union irq_ctx *irqctx;
+
+	if (hardirq_ctx[cpu])
+		return;
+
+	irqctx = (union irq_ctx *) &hardirq_stack[cpu * THREAD_SIZE];
+	irqctx->tinfo.task              = NULL;
+	irqctx->tinfo.exec_domain       = NULL;
+	irqctx->tinfo.cpu               = cpu;
+	irqctx->tinfo.preempt_count     = HARDIRQ_OFFSET;
+	irqctx->tinfo.addr_limit        = MAKE_MM_SEG(0);
+
+	hardirq_ctx[cpu] = irqctx;
+
+	irqctx = (union irq_ctx *) &softirq_stack[cpu * THREAD_SIZE];
+	irqctx->tinfo.task              = NULL;
+	irqctx->tinfo.exec_domain       = NULL;
+	irqctx->tinfo.cpu               = cpu;
+	irqctx->tinfo.preempt_count     = 0;
+	irqctx->tinfo.addr_limit        = MAKE_MM_SEG(0);
+
+	softirq_ctx[cpu] = irqctx;
+
+	pr_info("CPU %u irqstacks, hard=%p soft=%p\n",
+		cpu, hardirq_ctx[cpu], softirq_ctx[cpu]);
+}
+
+void irq_ctx_exit(int cpu)
+{
+	hardirq_ctx[smp_processor_id()] = NULL;
+}
+
+extern asmlinkage void __do_softirq(void);
+
+asmlinkage void do_softirq(void)
+{
+	unsigned long flags;
+	struct thread_info *curctx;
+	union irq_ctx *irqctx;
+	u32 *isp;
+
+	if (in_interrupt())
+		return;
+
+	local_irq_save(flags);
+
+	if (local_softirq_pending()) {
+		curctx = current_thread_info();
+		irqctx = softirq_ctx[smp_processor_id()];
+		irqctx->tinfo.task = curctx->task;
+
+		/* build the stack frame on the softirq stack */
+		isp = (u32 *) ((char *)irqctx + sizeof(struct thread_info));
+
+		asm volatile(
+			"MOV   D0.5,%0\n"
+			"SWAP  A0StP,D0.5\n"
+			"CALLR D1RtP,___do_softirq\n"
+			"MOV   A0StP,D0.5\n"
+			:
+			: "r" (isp)
+			: "memory", "cc", "D1Ar1", "D0Ar2", "D1Ar3", "D0Ar4",
+			  "D1Ar5", "D0Ar6", "D0Re0", "D1Re0", "D0.4", "D1RtP",
+			  "D0.5"
+			);
+		/*
+		 * Shouldn't happen, we returned above if in_interrupt():
+		 */
+		WARN_ON_ONCE(softirq_count());
+	}
+
+	local_irq_restore(flags);
+}
+#endif
+
+static struct irq_chip meta_irq_type = {
+	.name = "META-IRQ",
+	.irq_startup = startup_meta_irq,
+	.irq_shutdown = shutdown_meta_irq,
+};
+
+/*
+ * void init_IRQ(void)
+ *
+ * Parameters:	None
+ *
+ * Returns:	Nothing
+ *
+ * This function should be called during kernel startup to initialize
+ * the IRQ handling routines.
+ */
+void __init init_IRQ(void)
+{
+	int i;
+
+	for (i = 0; i < META_IRQS; i++)
+#ifdef CONFIG_SMP
+		irq_set_chip_and_handler(i, &meta_irq_type, handle_percpu_irq);
+#else
+		irq_set_chip_and_handler(i, &meta_irq_type, handle_simple_irq);
+#endif
+
+	irq_ctx_init(smp_processor_id());
+
+	init_internal_IRQ();
+	init_external_IRQ();
+
+	if (machine_desc->init_irq)
+		machine_desc->init_irq();
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip = irq_data_get_irq_chip(data);
+
+	raw_spin_lock_irq(&desc->lock);
+	if (chip->irq_set_affinity)
+		chip->irq_set_affinity(data, cpumask_of(cpu), false);
+	raw_spin_unlock_irq(&desc->lock);
+}
+
+/*
+ * The CPU has been marked offline.  Migrate IRQs off this CPU.  If
+ * the affinity settings do not allow other CPUs, force them onto any
+ * available CPU.
+ */
+void migrate_irqs(void)
+{
+	unsigned int i, cpu = smp_processor_id();
+
+	for (i = 0; i < NR_IRQS; i++) {
+		struct irq_data *data = irq_get_irq_data(i);
+		unsigned int newcpu;
+
+		if (irqd_is_per_cpu(data))
+			continue;
+
+		if (!cpumask_test_cpu(cpu, data->affinity))
+			continue;
+
+		newcpu = cpumask_any_and(data->affinity, cpu_online_mask);
+
+		if (newcpu >= nr_cpu_ids) {
+			pr_info_ratelimited("IRQ%u no longer affine to CPU%u\n",
+					    i, cpu);
+
+			cpumask_setall(data->affinity);
+			newcpu = cpumask_any_and(data->affinity,
+						 cpu_online_mask);
+		}
+
+		route_irq(data, i, newcpu);
+	}
+}
+#endif /* CONFIG_HOTPLUG_CPU */
diff --git a/arch/metag/kernel/irq_external.c b/arch/metag/kernel/irq_external.c
new file mode 100644
index 0000000..5f8d2a5
--- /dev/null
+++ b/arch/metag/kernel/irq_external.c
@@ -0,0 +1,886 @@
+/*
+ * Meta External interrupt code.
+ *
+ * Copyright (C) 2005-2012 Imagination Technologies Ltd.
+ *
+ * External interrupts on Meta are configured at two-levels, in the CPU core and
+ * in the external trigger block. Interrupts from SoC peripherals are
+ * multiplexed onto a single Meta CPU "trigger" - traditionally it has always
+ * been trigger 2 (TR2). For info on how de-multiplexing happens check out
+ * meta_intc_irq_demux().
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/syscore_ops.h>
+
+#include <asm/irq.h>
+#include <asm/irq_external.h>
+#include <asm/hwthread.h>
+
+#define HWSTAT_STRIDE 8
+#define HWVEC_BLK_STRIDE 0x1000
+
+/**
+ * struct meta_intc_priv - private meta external interrupt data
+ * @nr_banks:		Number of interrupt banks
+ * @domain:		IRQ domain for all banks of external IRQs
+ * @unmasked:		Record of unmasked IRQs
+ * @levels_altered:	Record of altered level bits
+ */
+struct meta_intc_priv {
+	unsigned int		nr_banks;
+	struct irq_domain	*domain;
+
+	unsigned long		unmasked[4];
+
+#ifdef CONFIG_METAG_SUSPEND_MEM
+	unsigned long		levels_altered[4];
+#endif
+};
+
+/* Private data for the one and only external interrupt controller */
+static struct meta_intc_priv meta_intc_priv;
+
+/**
+ * meta_intc_offset() - Get the offset into the bank of a hardware IRQ number
+ * @hw:		Hardware IRQ number (within external trigger block)
+ *
+ * Returns:	Bit offset into the IRQ's bank registers
+ */
+static unsigned int meta_intc_offset(irq_hw_number_t hw)
+{
+	return hw & 0x1f;
+}
+
+/**
+ * meta_intc_bank() - Get the bank number of a hardware IRQ number
+ * @hw:		Hardware IRQ number (within external trigger block)
+ *
+ * Returns:	Bank number indicating which register the IRQ's bits are
+ */
+static unsigned int meta_intc_bank(irq_hw_number_t hw)
+{
+	return hw >> 5;
+}
+
+/**
+ * meta_intc_stat_addr() - Get the address of a HWSTATEXT register
+ * @hw:		Hardware IRQ number (within external trigger block)
+ *
+ * Returns:	Address of a HWSTATEXT register containing the status bit for
+ *		the specified hardware IRQ number
+ */
+static void __iomem *meta_intc_stat_addr(irq_hw_number_t hw)
+{
+	return (void __iomem *)(HWSTATEXT +
+				HWSTAT_STRIDE * meta_intc_bank(hw));
+}
+
+/**
+ * meta_intc_level_addr() - Get the address of a HWLEVELEXT register
+ * @hw:		Hardware IRQ number (within external trigger block)
+ *
+ * Returns:	Address of a HWLEVELEXT register containing the sense bit for
+ *		the specified hardware IRQ number
+ */
+static void __iomem *meta_intc_level_addr(irq_hw_number_t hw)
+{
+	return (void __iomem *)(HWLEVELEXT +
+				HWSTAT_STRIDE * meta_intc_bank(hw));
+}
+
+/**
+ * meta_intc_mask_addr() - Get the address of a HWMASKEXT register
+ * @hw:		Hardware IRQ number (within external trigger block)
+ *
+ * Returns:	Address of a HWMASKEXT register containing the mask bit for the
+ *		specified hardware IRQ number
+ */
+static void __iomem *meta_intc_mask_addr(irq_hw_number_t hw)
+{
+	return (void __iomem *)(HWMASKEXT +
+				HWSTAT_STRIDE * meta_intc_bank(hw));
+}
+
+/**
+ * meta_intc_vec_addr() - Get the vector address of a hardware interrupt
+ * @hw:		Hardware IRQ number (within external trigger block)
+ *
+ * Returns:	Address of a HWVECEXT register controlling the core trigger to
+ *		vector the IRQ onto
+ */
+static inline void __iomem *meta_intc_vec_addr(irq_hw_number_t hw)
+{
+	return (void __iomem *)(HWVEC0EXT +
+				HWVEC_BLK_STRIDE * meta_intc_bank(hw) +
+				HWVECnEXT_STRIDE * meta_intc_offset(hw));
+}
+
+/**
+ * meta_intc_startup_irq() - set up an external irq
+ * @data:	data for the external irq to start up
+ *
+ * Multiplex interrupts for irq onto TR2. Clear any pending interrupts and
+ * unmask irq, both using the appropriate callbacks.
+ */
+static unsigned int meta_intc_startup_irq(struct irq_data *data)
+{
+	irq_hw_number_t hw = data->hwirq;
+	void __iomem *vec_addr = meta_intc_vec_addr(hw);
+	int thread = hard_processor_id();
+
+	/* Perform any necessary acking. */
+	if (data->chip->irq_ack)
+		data->chip->irq_ack(data);
+
+	/* Wire up this interrupt to the core with HWVECxEXT. */
+	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR2(thread)), vec_addr);
+
+	/* Perform any necessary unmasking. */
+	data->chip->irq_unmask(data);
+
+	return 0;
+}
+
+/**
+ * meta_intc_shutdown_irq() - turn off an external irq
+ * @data:	data for the external irq to turn off
+ *
+ * Mask irq using the appropriate callback and stop muxing it onto TR2.
+ */
+static void meta_intc_shutdown_irq(struct irq_data *data)
+{
+	irq_hw_number_t hw = data->hwirq;
+	void __iomem *vec_addr = meta_intc_vec_addr(hw);
+
+	/* Mask the IRQ */
+	data->chip->irq_mask(data);
+
+	/*
+	 * Disable the IRQ at the core by removing the interrupt from
+	 * the HW vector mapping.
+	 */
+	metag_out32(0, vec_addr);
+}
+
+/**
+ * meta_intc_ack_irq() - acknowledge an external irq
+ * @data:	data for the external irq to ack
+ *
+ * Clear down an edge interrupt in the status register.
+ */
+static void meta_intc_ack_irq(struct irq_data *data)
+{
+	irq_hw_number_t hw = data->hwirq;
+	unsigned int bit = 1 << meta_intc_offset(hw);
+	void __iomem *stat_addr = meta_intc_stat_addr(hw);
+
+	/* Ack the int, if it is still 'on'.
+	 * NOTE - this only works for edge triggered interrupts.
+	 */
+	if (metag_in32(stat_addr) & bit)
+		metag_out32(bit, stat_addr);
+}
+
+/**
+ * record_irq_is_masked() - record the IRQ masked so it doesn't get handled
+ * @data:	data for the external irq to record
+ *
+ * This should get called whenever an external IRQ is masked (by whichever
+ * callback is used). It records the IRQ masked so that it doesn't get handled
+ * if it still shows up in the status register.
+ */
+static void record_irq_is_masked(struct irq_data *data)
+{
+	struct meta_intc_priv *priv = &meta_intc_priv;
+	irq_hw_number_t hw = data->hwirq;
+
+	clear_bit(meta_intc_offset(hw), &priv->unmasked[meta_intc_bank(hw)]);
+}
+
+/**
+ * record_irq_is_unmasked() - record the IRQ unmasked so it can be handled
+ * @data:	data for the external irq to record
+ *
+ * This should get called whenever an external IRQ is unmasked (by whichever
+ * callback is used). It records the IRQ unmasked so that it gets handled if it
+ * shows up in the status register.
+ */
+static void record_irq_is_unmasked(struct irq_data *data)
+{
+	struct meta_intc_priv *priv = &meta_intc_priv;
+	irq_hw_number_t hw = data->hwirq;
+
+	set_bit(meta_intc_offset(hw), &priv->unmasked[meta_intc_bank(hw)]);
+}
+
+/*
+ * For use by wrapper IRQ drivers
+ */
+
+/**
+ * meta_intc_mask_irq_simple() - minimal mask used by wrapper IRQ drivers
+ * @data:	data for the external irq being masked
+ *
+ * This should be called by any wrapper IRQ driver mask functions. it doesn't do
+ * any masking but records the IRQ as masked so that the core code knows the
+ * mask has taken place. It is the callers responsibility to ensure that the IRQ
+ * won't trigger an interrupt to the core.
+ */
+void meta_intc_mask_irq_simple(struct irq_data *data)
+{
+	record_irq_is_masked(data);
+}
+
+/**
+ * meta_intc_unmask_irq_simple() - minimal unmask used by wrapper IRQ drivers
+ * @data:	data for the external irq being unmasked
+ *
+ * This should be called by any wrapper IRQ driver unmask functions. it doesn't
+ * do any unmasking but records the IRQ as unmasked so that the core code knows
+ * the unmask has taken place. It is the callers responsibility to ensure that
+ * the IRQ can now trigger an interrupt to the core.
+ */
+void meta_intc_unmask_irq_simple(struct irq_data *data)
+{
+	record_irq_is_unmasked(data);
+}
+
+
+/**
+ * meta_intc_mask_irq() - mask an external irq using HWMASKEXT
+ * @data:	data for the external irq to mask
+ *
+ * This is a default implementation of a mask function which makes use of the
+ * HWMASKEXT registers available in newer versions.
+ *
+ * Earlier versions without these registers should use SoC level IRQ masking
+ * which call the meta_intc_*_simple() functions above, or if that isn't
+ * available should use the fallback meta_intc_*_nomask() functions below.
+ */
+static void meta_intc_mask_irq(struct irq_data *data)
+{
+	irq_hw_number_t hw = data->hwirq;
+	unsigned int bit = 1 << meta_intc_offset(hw);
+	void __iomem *mask_addr = meta_intc_mask_addr(hw);
+	unsigned long flags;
+
+	record_irq_is_masked(data);
+
+	/* update the interrupt mask */
+	__global_lock2(flags);
+	metag_out32(metag_in32(mask_addr) & ~bit, mask_addr);
+	__global_unlock2(flags);
+}
+
+/**
+ * meta_intc_unmask_irq() - unmask an external irq using HWMASKEXT
+ * @data:	data for the external irq to unmask
+ *
+ * This is a default implementation of an unmask function which makes use of the
+ * HWMASKEXT registers available on new versions. It should be paired with
+ * meta_intc_mask_irq() above.
+ */
+static void meta_intc_unmask_irq(struct irq_data *data)
+{
+	irq_hw_number_t hw = data->hwirq;
+	unsigned int bit = 1 << meta_intc_offset(hw);
+	void __iomem *mask_addr = meta_intc_mask_addr(hw);
+	unsigned long flags;
+
+	record_irq_is_unmasked(data);
+
+	/* update the interrupt mask */
+	__global_lock2(flags);
+	metag_out32(metag_in32(mask_addr) | bit, mask_addr);
+	__global_unlock2(flags);
+}
+
+/**
+ * meta_intc_mask_irq_nomask() - mask an external irq by unvectoring
+ * @data:	data for the external irq to mask
+ *
+ * This is the version of the mask function for older versions which don't have
+ * HWMASKEXT registers, or a SoC level means of masking IRQs. Instead the IRQ is
+ * unvectored from the core and retriggered if necessary later.
+ */
+static void meta_intc_mask_irq_nomask(struct irq_data *data)
+{
+	irq_hw_number_t hw = data->hwirq;
+	void __iomem *vec_addr = meta_intc_vec_addr(hw);
+
+	record_irq_is_masked(data);
+
+	/* there is no interrupt mask, so unvector the interrupt */
+	metag_out32(0, vec_addr);
+}
+
+/**
+ * meta_intc_unmask_edge_irq_nomask() - unmask an edge irq by revectoring
+ * @data:	data for the external irq to unmask
+ *
+ * This is the version of the unmask function for older versions which don't
+ * have HWMASKEXT registers, or a SoC level means of masking IRQs. Instead the
+ * IRQ is revectored back to the core and retriggered if necessary.
+ *
+ * The retriggering done by this function is specific to edge interrupts.
+ */
+static void meta_intc_unmask_edge_irq_nomask(struct irq_data *data)
+{
+	irq_hw_number_t hw = data->hwirq;
+	unsigned int bit = 1 << meta_intc_offset(hw);
+	void __iomem *stat_addr = meta_intc_stat_addr(hw);
+	void __iomem *vec_addr = meta_intc_vec_addr(hw);
+	unsigned int thread = hard_processor_id();
+
+	record_irq_is_unmasked(data);
+
+	/* there is no interrupt mask, so revector the interrupt */
+	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR2(thread)), vec_addr);
+
+	/*
+	 * Re-trigger interrupt
+	 *
+	 * Writing a 1 toggles, and a 0->1 transition triggers. We only
+	 * retrigger if the status bit is already set, which means we
+	 * need to clear it first. Retriggering is fundamentally racy
+	 * because if the interrupt fires again after we clear it we
+	 * could end up clearing it again and the interrupt handler
+	 * thinking it hasn't fired. Therefore we need to keep trying to
+	 * retrigger until the bit is set.
+	 */
+	if (metag_in32(stat_addr) & bit) {
+		metag_out32(bit, stat_addr);
+		while (!(metag_in32(stat_addr) & bit))
+			metag_out32(bit, stat_addr);
+	}
+}
+
+/**
+ * meta_intc_unmask_level_irq_nomask() - unmask a level irq by revectoring
+ * @data:	data for the external irq to unmask
+ *
+ * This is the version of the unmask function for older versions which don't
+ * have HWMASKEXT registers, or a SoC level means of masking IRQs. Instead the
+ * IRQ is revectored back to the core and retriggered if necessary.
+ *
+ * The retriggering done by this function is specific to level interrupts.
+ */
+static void meta_intc_unmask_level_irq_nomask(struct irq_data *data)
+{
+	irq_hw_number_t hw = data->hwirq;
+	unsigned int bit = 1 << meta_intc_offset(hw);
+	void __iomem *stat_addr = meta_intc_stat_addr(hw);
+	void __iomem *vec_addr = meta_intc_vec_addr(hw);
+	unsigned int thread = hard_processor_id();
+
+	record_irq_is_unmasked(data);
+
+	/* there is no interrupt mask, so revector the interrupt */
+	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR2(thread)), vec_addr);
+
+	/* Re-trigger interrupt */
+	/* Writing a 1 triggers interrupt */
+	if (metag_in32(stat_addr) & bit)
+		metag_out32(bit, stat_addr);
+}
+
+/**
+ * meta_intc_irq_set_type() - set the type of an external irq
+ * @data:	data for the external irq to set the type of
+ * @flow_type:	new irq flow type
+ *
+ * Set the flow type of an external interrupt. This updates the irq chip and irq
+ * handler depending on whether the irq is edge or level sensitive (the polarity
+ * is ignored), and also sets up the bit in HWLEVELEXT so the hardware knows
+ * when to trigger.
+ */
+static int meta_intc_irq_set_type(struct irq_data *data, unsigned int flow_type)
+{
+#ifdef CONFIG_METAG_SUSPEND_MEM
+	struct meta_intc_priv *priv = &meta_intc_priv;
+#endif
+	unsigned int irq = data->irq;
+	irq_hw_number_t hw = data->hwirq;
+	unsigned int bit = 1 << meta_intc_offset(hw);
+	void __iomem *level_addr = meta_intc_level_addr(hw);
+	unsigned long flags;
+	unsigned int level;
+
+	/* update the chip/handler */
+	if (flow_type & IRQ_TYPE_LEVEL_MASK)
+		__irq_set_chip_handler_name_locked(irq, &meta_intc_level_chip,
+						   handle_level_irq, NULL);
+	else
+		__irq_set_chip_handler_name_locked(irq, &meta_intc_edge_chip,
+						   handle_edge_irq, NULL);
+
+	/* and clear/set the bit in HWLEVELEXT */
+	__global_lock2(flags);
+	level = metag_in32(level_addr);
+	if (flow_type & IRQ_TYPE_LEVEL_MASK)
+		level |= bit;
+	else
+		level &= ~bit;
+	metag_out32(level, level_addr);
+#ifdef CONFIG_METAG_SUSPEND_MEM
+	priv->levels_altered[meta_intc_bank(hw)] |= bit;
+#endif
+	__global_unlock2(flags);
+
+	return 0;
+}
+
+/**
+ * meta_intc_irq_demux() - external irq de-multiplexer
+ * @irq:	the virtual interrupt number
+ * @desc:	the interrupt description structure for this irq
+ *
+ * The cpu receives an interrupt on TR2 when a SoC interrupt has occurred. It is
+ * this function's job to demux this irq and figure out exactly which external
+ * irq needs servicing.
+ *
+ * Whilst using TR2 to detect external interrupts is a software convention it is
+ * (hopefully) unlikely to change.
+ */
+static void meta_intc_irq_demux(unsigned int irq, struct irq_desc *desc)
+{
+	struct meta_intc_priv *priv = &meta_intc_priv;
+	unsigned int bank, irq_no, status;
+	void __iomem *stat_addr = meta_intc_stat_addr(0);
+
+	/*
+	 * Locate which interrupt has caused our handler to run.
+	 */
+	for (bank = 0; bank < priv->nr_banks; ++bank) {
+		/* Which interrupts are currently pending in this bank? */
+recalculate:
+		status = metag_in32(stat_addr) & priv->unmasked[bank];
+
+		irq_no = HWSTATEXT_TO_IRQ(bank * 32);
+		for (; status; status >>= 1, ++irq_no) {
+			if (status & 0x1) {
+				/*
+				 * Only fire off external interrupts that are
+				 * registered to be handled by the kernel.
+				 * Other external interrupts are probably being
+				 * handled by other Meta hardware threads.
+				 */
+				generic_handle_irq(irq_no);
+
+				/*
+				 * The handler may have re-enabled interrupts
+				 * which could have caused a nested invocation
+				 * of this code and make the copy of the
+				 * status register we are using invalid.
+				 */
+				goto recalculate;
+			}
+		}
+		stat_addr += HWSTAT_STRIDE;
+	}
+}
+
+#ifdef CONFIG_SMP
+/**
+ * meta_intc_set_affinity() - set the affinity for an interrupt
+ * @data:	data for the external irq to set the affinity of
+ * @cpumask:	cpu mask representing cpus which can handle the interrupt
+ * @force:	whether to force (ignored)
+ *
+ * Revector the specified external irq onto a specific cpu's TR2 trigger, so
+ * that that cpu tends to be the one who handles it.
+ */
+static int meta_intc_set_affinity(struct irq_data *data,
+				  const struct cpumask *cpumask, bool force)
+{
+	irq_hw_number_t hw = data->hwirq;
+	void __iomem *vec_addr = meta_intc_vec_addr(hw);
+	unsigned int cpu, thread;
+
+	/*
+	 * Wire up this interrupt from HWVECxEXT to the Meta core.
+	 *
+	 * Note that we can't wire up HWVECxEXT to interrupt more than
+	 * one cpu (the interrupt code doesn't support it), so we just
+	 * pick the first cpu we find in 'cpumask'.
+	 */
+	cpu = cpumask_any(cpumask);
+	thread = cpu_2_hwthread_id[cpu];
+
+	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR2(thread)), vec_addr);
+
+	return 0;
+}
+#else
+#define meta_intc_set_affinity	NULL
+#endif
+
+#ifdef CONFIG_PM_SLEEP
+#define META_INTC_CHIP_FLAGS	(IRQCHIP_MASK_ON_SUSPEND \
+				| IRQCHIP_SKIP_SET_WAKE)
+#else
+#define META_INTC_CHIP_FLAGS	0
+#endif
+
+/* public edge/level irq chips which SoCs can override */
+
+struct irq_chip meta_intc_edge_chip = {
+	.irq_startup		= meta_intc_startup_irq,
+	.irq_shutdown		= meta_intc_shutdown_irq,
+	.irq_ack		= meta_intc_ack_irq,
+	.irq_mask		= meta_intc_mask_irq,
+	.irq_unmask		= meta_intc_unmask_irq,
+	.irq_set_type		= meta_intc_irq_set_type,
+	.irq_set_affinity	= meta_intc_set_affinity,
+	.flags			= META_INTC_CHIP_FLAGS,
+};
+
+struct irq_chip meta_intc_level_chip = {
+	.irq_startup		= meta_intc_startup_irq,
+	.irq_shutdown		= meta_intc_shutdown_irq,
+	.irq_set_type		= meta_intc_irq_set_type,
+	.irq_mask		= meta_intc_mask_irq,
+	.irq_unmask		= meta_intc_unmask_irq,
+	.irq_set_affinity	= meta_intc_set_affinity,
+	.flags			= META_INTC_CHIP_FLAGS,
+};
+
+/**
+ * meta_intc_map() - map an external irq
+ * @d:		irq domain of external trigger block
+ * @irq:	virtual irq number
+ * @hw:		hardware irq number within external trigger block
+ *
+ * This sets up a virtual irq for a specified hardware interrupt. The irq chip
+ * and handler is configured, using the HWLEVELEXT registers to determine
+ * edge/level flow type. These registers will have been set when the irq type is
+ * set (or set to a default at init time).
+ */
+static int meta_intc_map(struct irq_domain *d, unsigned int irq,
+			 irq_hw_number_t hw)
+{
+	unsigned int bit = 1 << meta_intc_offset(hw);
+	void __iomem *level_addr = meta_intc_level_addr(hw);
+
+	/* Go by the current sense in the HWLEVELEXT register */
+	if (metag_in32(level_addr) & bit)
+		irq_set_chip_and_handler(irq, &meta_intc_level_chip,
+					 handle_level_irq);
+	else
+		irq_set_chip_and_handler(irq, &meta_intc_edge_chip,
+					 handle_edge_irq);
+	return 0;
+}
+
+static const struct irq_domain_ops meta_intc_domain_ops = {
+	.map = meta_intc_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
+#ifdef CONFIG_METAG_SUSPEND_MEM
+
+/**
+ * struct meta_intc_context - suspend context
+ * @levels:	State of HWLEVELEXT registers
+ * @masks:	State of HWMASKEXT registers
+ * @vectors:	State of HWVECEXT registers
+ * @txvecint:	State of TxVECINT registers
+ *
+ * This structure stores the IRQ state across suspend.
+ */
+struct meta_intc_context {
+	u32 levels[4];
+	u32 masks[4];
+	u8 vectors[4*32];
+
+	u8 txvecint[4][4];
+};
+
+/* suspend context */
+static struct meta_intc_context *meta_intc_context;
+
+/**
+ * meta_intc_suspend() - store irq state
+ *
+ * To avoid interfering with other threads we only save the IRQ state of IRQs in
+ * use by Linux.
+ */
+static int meta_intc_suspend(void)
+{
+	struct meta_intc_priv *priv = &meta_intc_priv;
+	int i, j;
+	irq_hw_number_t hw;
+	unsigned int bank;
+	unsigned long flags;
+	struct meta_intc_context *context;
+	void __iomem *level_addr, *mask_addr, *vec_addr;
+	u32 mask, bit;
+
+	context = kzalloc(sizeof(*context), GFP_ATOMIC);
+	if (!context)
+		return -ENOMEM;
+
+	hw = 0;
+	i = HWSTATEXT_TO_IRQ(0);
+	level_addr = meta_intc_level_addr(0);
+	mask_addr = meta_intc_mask_addr(0);
+	for (bank = 0; bank < priv->nr_banks; ++bank) {
+		vec_addr = meta_intc_vec_addr(hw);
+
+		/* create mask of interrupts in use */
+		mask = 0;
+		for (bit = 1; bit; bit <<= 1) {
+			/* save only enabled interrupts or those with actions */
+			if (!irqd_irq_disabled(irq_get_irq_data(i)) ||
+			    irq_has_action(i)) {
+				mask |= bit;
+
+				/* save trigger vector */
+				context->vectors[hw] = metag_in32(vec_addr);
+			}
+
+			++i;
+			++hw;
+			vec_addr += HWVECnEXT_STRIDE;
+		}
+
+		/* save level state if any IRQ levels altered */
+		if (priv->levels_altered[bank])
+			context->levels[bank] = metag_in32(level_addr);
+		/* save mask state if any IRQs in use */
+		if (mask)
+			context->masks[bank] = metag_in32(mask_addr);
+
+		level_addr += HWSTAT_STRIDE;
+		mask_addr += HWSTAT_STRIDE;
+	}
+
+	/* save trigger matrixing */
+	__global_lock2(flags);
+	for (i = 0; i < 4; ++i)
+		for (j = 0; j < 4; ++j)
+			context->txvecint[i][j] = metag_in32(T0VECINT_BHALT +
+							     TnVECINT_STRIDE*i +
+							     8*j);
+	__global_unlock2(flags);
+
+	meta_intc_context = context;
+	return 0;
+}
+
+/**
+ * meta_intc_resume() - restore saved irq state
+ *
+ * Restore the saved IRQ state and drop it.
+ */
+static void meta_intc_resume(void)
+{
+	struct meta_intc_priv *priv = &meta_intc_priv;
+	int i, j;
+	irq_hw_number_t hw;
+	unsigned int bank;
+	unsigned long flags;
+	struct meta_intc_context *context = meta_intc_context;
+	void __iomem *level_addr, *mask_addr, *vec_addr;
+	u32 mask, bit, tmp;
+
+	meta_intc_context = NULL;
+
+	hw = 0;
+	i = HWSTATEXT_TO_IRQ(0);
+	level_addr = meta_intc_level_addr(0);
+	mask_addr = meta_intc_mask_addr(0);
+	for (bank = 0; bank < priv->nr_banks; ++bank) {
+		vec_addr = meta_intc_vec_addr(hw);
+
+		/* create mask of interrupts in use */
+		mask = 0;
+		for (bit = 1; bit; bit <<= 1) {
+			/* restore enabled interrupts or those with actions */
+			if (!irqd_irq_disabled(irq_get_irq_data(i)) ||
+			    irq_has_action(i)) {
+				mask |= bit;
+
+				/* restore trigger vector */
+				metag_out32(context->vectors[hw], vec_addr);
+			}
+
+			++i;
+			++hw;
+			vec_addr += HWVECnEXT_STRIDE;
+		}
+
+		if (mask) {
+			/* restore mask state */
+			__global_lock2(flags);
+			tmp = metag_in32(mask_addr);
+			tmp = (tmp & ~mask) | (context->masks[bank] & mask);
+			metag_out32(tmp, mask_addr);
+			__global_unlock2(flags);
+		}
+
+		mask = priv->levels_altered[bank];
+		if (mask) {
+			/* restore level state */
+			__global_lock2(flags);
+			tmp = metag_in32(level_addr);
+			tmp = (tmp & ~mask) | (context->levels[bank] & mask);
+			metag_out32(tmp, level_addr);
+			__global_unlock2(flags);
+		}
+
+		level_addr += HWSTAT_STRIDE;
+		mask_addr += HWSTAT_STRIDE;
+	}
+
+	/* restore trigger matrixing */
+	__global_lock2(flags);
+	for (i = 0; i < 4; ++i) {
+		for (j = 0; j < 4; ++j) {
+			metag_out32(context->txvecint[i][j],
+				    T0VECINT_BHALT +
+				    TnVECINT_STRIDE*i +
+				    8*j);
+		}
+	}
+	__global_unlock2(flags);
+
+	kfree(context);
+}
+
+static struct syscore_ops meta_intc_syscore_ops = {
+	.suspend = meta_intc_suspend,
+	.resume = meta_intc_resume,
+};
+
+static void __init meta_intc_init_syscore_ops(struct meta_intc_priv *priv)
+{
+	register_syscore_ops(&meta_intc_syscore_ops);
+}
+#else
+#define meta_intc_init_syscore_ops(priv) do {} while (0)
+#endif
+
+/**
+ * meta_intc_init_cpu() - register with a Meta cpu
+ * @priv:	private interrupt controller data
+ * @cpu:	the CPU to register on
+ *
+ * Configure @cpu's TR2 irq so that we can demux external irqs.
+ */
+static void __init meta_intc_init_cpu(struct meta_intc_priv *priv, int cpu)
+{
+	unsigned int thread = cpu_2_hwthread_id[cpu];
+	unsigned int signum = TBID_SIGNUM_TR2(thread);
+
+	/* Register the multiplexed IRQ handler */
+	irq_set_chained_handler(signum, meta_intc_irq_demux);
+	irq_set_irq_type(signum, IRQ_TYPE_LEVEL_LOW);
+}
+
+/**
+ * meta_intc_no_mask() - indicate lack of HWMASKEXT registers
+ *
+ * Called from SoC code (or init code below) to dynamically indicate the lack of
+ * HWMASKEXT registers (for example depending on some SoC revision register).
+ * This alters the irq mask and unmask callbacks to use the fallback
+ * unvectoring/retriggering technique instead of using HWMASKEXT registers.
+ */
+void __init meta_intc_no_mask(void)
+{
+	meta_intc_edge_chip.irq_mask	= meta_intc_mask_irq_nomask;
+	meta_intc_edge_chip.irq_unmask	= meta_intc_unmask_edge_irq_nomask;
+	meta_intc_level_chip.irq_mask	= meta_intc_mask_irq_nomask;
+	meta_intc_level_chip.irq_unmask	= meta_intc_unmask_level_irq_nomask;
+}
+
+/**
+ * init_external_IRQ() - initialise the external irq controller
+ *
+ * Set up the external irq controller using device tree properties. This is
+ * called from init_IRQ().
+ */
+int __init init_external_IRQ(void)
+{
+	struct meta_intc_priv *priv = &meta_intc_priv;
+	struct device_node *node;
+	int ret, cpu;
+	u32 val;
+	u32 vals[4];
+	bool no_masks = false;
+	unsigned int i;
+	void __iomem *level_addr;
+
+	node = of_find_compatible_node(NULL, NULL, "img,meta-intc");
+	if (!node)
+		return -ENOENT;
+
+	/* Get number of banks */
+	ret = of_property_read_u32(node, "num-banks", &val);
+	if (ret) {
+		pr_err("meta-intc: No num-banks property found\n");
+		return ret;
+	}
+	if (val < 1 || val > 4) {
+		pr_err("meta-intc: num-banks (%u) out of range\n", val);
+		return -EINVAL;
+	}
+	priv->nr_banks = val;
+
+	/* Are any mask registers present? */
+	if (of_get_property(node, "no-mask", NULL))
+		no_masks = true;
+
+	/* Are any default edge/level senses available? */
+	ret = of_property_read_u32_array(node, "default-level", vals,
+					 priv->nr_banks);
+	if (!ret) {
+		/* valid, set HWLEVELEXT registers */
+		level_addr = (void __iomem *)HWLEVELEXT;
+		for (i = 0; i < priv->nr_banks; ++i,
+						level_addr += HWSTAT_STRIDE) {
+			metag_out32(vals[i], level_addr);
+#ifdef CONFIG_METAG_SUSPEND_MEM
+			priv->levels_altered[i] = 0xffffffff;
+#endif
+		}
+	} else if (ret != -EINVAL) {
+		/* invalid (rather than simply omitted) */
+		pr_err("meta-intc: default-level could not be read\n");
+		return ret;
+	}
+
+	/* No HWMASKEXT registers present? */
+	if (no_masks)
+		meta_intc_no_mask();
+
+	/* Set up an IRQ domain */
+	/*
+	 * This is a legacy IRQ domain for now until all the platform setup code
+	 * has been converted to devicetree.
+	 */
+	priv->domain = irq_domain_add_legacy(node, priv->nr_banks*32,
+					     HWSTATEXT_TO_IRQ(0), 0,
+					     &meta_intc_domain_ops, priv);
+	if (unlikely(!priv->domain)) {
+		pr_err("meta-intc: cannot add IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	/* Setup TR2 for all cpus. */
+	for_each_possible_cpu(cpu)
+		meta_intc_init_cpu(priv, cpu);
+
+	/* Set up system suspend/resume callbacks */
+	meta_intc_init_syscore_ops(priv);
+
+	pr_info("meta-intc: External IRQ controller initialised (%u IRQs)\n",
+		priv->nr_banks*32);
+
+	return 0;
+}
diff --git a/arch/metag/kernel/irq_internal.c b/arch/metag/kernel/irq_internal.c
new file mode 100644
index 0000000..7db6632
--- /dev/null
+++ b/arch/metag/kernel/irq_internal.c
@@ -0,0 +1,237 @@
+/*
+ * Meta internal (HWSTATMETA) interrupt code.
+ *
+ * Copyright (C) 2011 Imagination Technologies Ltd.
+ *
+ * This code is based on the code in SoC/common/irq.c and SoC/comet/irq.c
+ * The code base could be generalised/merged as a lot of the functionality is
+ * similar. Until this is done, we try to keep the code simple here.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+#include <asm/irq.h>
+#include <asm/hwthread.h>
+
+#define PERF0VECINT		0x04820580
+#define PERF1VECINT		0x04820588
+#define PERF0TRIG_OFFSET	16
+#define PERF1TRIG_OFFSET	17
+
+static unsigned int mapped; /* bit mask of mapped triggers */
+
+static unsigned int metag_internal_irq_startup_edge(struct irq_data *data);
+static void metag_internal_irq_shutdown(struct irq_data *data);
+static void metag_internal_irq_ack(struct irq_data *data);
+#ifdef CONFIG_SMP
+static int metag_internal_irq_set_affinity(struct irq_data *data,
+			const struct cpumask *cpumask, bool force);
+#endif
+
+static struct irq_chip internal_irq_edge_chip = {
+	.name = "HWSTATMETA-IRQ",
+	.irq_startup = metag_internal_irq_startup_edge,
+	.irq_shutdown = metag_internal_irq_shutdown,
+	.irq_ack = metag_internal_irq_ack,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = metag_internal_irq_set_affinity,
+#endif
+};
+
+/*
+ *	metag_hwvec_addr - get the address of *VECINT regs of irq
+ *
+ *	This function is a table of supported triggers on HWSTATMETA
+ *	Could do with a structure, but better keep it simple. Changes
+ *	in this code should be rare.
+ */
+static inline void __iomem *metag_hwvec_addr(unsigned int irq)
+{
+	void __iomem *addr;
+	unsigned int offset = IRQ_TO_OFFSET(irq);
+
+	switch (offset) {
+	case PERF0TRIG_OFFSET:
+		addr = (void __iomem *)PERF0VECINT;
+		break;
+	case PERF1TRIG_OFFSET:
+		addr = (void __iomem *)PERF1VECINT;
+		break;
+	default:
+		addr = NULL;
+		break;
+	}
+	return addr;
+}
+
+/*
+ *	metag_internal_startup_edge_irq - setup an edge-triggered irq
+ *	@irq:	the irq to startup
+ *
+ *	Multiplex interrupts for @irq onto TR1. Clear any pending
+ *	interrupts.
+ */
+static unsigned int metag_internal_irq_startup_edge(struct irq_data *data)
+{
+	unsigned int irq = data->irq;
+	int thread = hard_processor_id();
+
+	/* Enable the interrupt by vectoring it */
+	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR1(thread)),
+		    metag_hwvec_addr(irq));
+
+	/* Clear (toggle) the bit in HWSTATx for our interrupt. */
+	metag_internal_irq_ack(data);
+
+	return 0;
+}
+
+/*
+ *	metag_internal_irq_shutdown - turn off the irq
+ *	@irq:	the irq number to turn off
+ *
+ *	Mask @irq and clear any pending interrupts.
+ *	Stop muxing @irq onto TR1.
+ */
+static void metag_internal_irq_shutdown(struct irq_data *data)
+{
+	unsigned int irq = data->irq;
+	/*
+	 * Disable the IRQ at the core by removing the interrupt from
+	 * the HW vector mapping.
+	 */
+	metag_out32(0, metag_hwvec_addr(irq));
+
+	/* Clear (toggle) the bit in HWSTATx for our interrupt. */
+	metag_internal_irq_ack(data);
+}
+
+/*
+ *	metag_internal_irq_ack - acknowledge irq
+ *	@irq:	the irq to ack
+ */
+static void metag_internal_irq_ack(struct irq_data *data)
+{
+	unsigned int irq = data->irq;
+	unsigned int offset = IRQ_TO_OFFSET(irq);
+	if (metag_in32(HWSTATMETA) & (1 << offset))
+		metag_out32(1 << offset, HWSTATMETA);
+}
+
+/*
+ * metag_internal_irq_status - returns the status of the mapped triggers
+ *
+ */
+
+static inline u32 metag_internal_irq_status(void)
+{
+	return metag_in32(HWSTATMETA) & mapped;
+}
+
+#ifdef CONFIG_SMP
+/*
+ *	metag_internal_irq_set_affinity - set the affinity for an interrupt
+ */
+static int metag_internal_irq_set_affinity(struct irq_data *data,
+			const struct cpumask *cpumask, bool force)
+{
+	unsigned int cpu, thread;
+	unsigned int irq = data->irq;
+	/*
+	 * Wire up this interrupt from *VECINT to the Meta core.
+	 *
+	 * Note that we can't wire up *VECINT to interrupt more than
+	 * one cpu (the interrupt code doesn't support it), so we just
+	 * pick the first cpu we find in 'cpumask'.
+	 */
+	cpu = cpumask_any(cpumask);
+	thread = cpu_2_hwthread_id[cpu];
+
+	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR1(thread)),
+		    metag_hwvec_addr(irq));
+
+	return 0;
+}
+#endif
+
+/*
+ *	metag_internal_irq_demux - irq de-multiplexer
+ *	@irq:	the interrupt number
+ *	@desc:	the interrupt description structure for this irq (unused)
+ *
+ *	The cpu receives an interrupt on TR1 when an interrupt has
+ *	occurred. It is this function's job to demux this irq and
+ *	figure out exactly which trigger needs servicing.
+ */
+static void metag_internal_irq_demux(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned int irq_no;
+	u32 status;
+
+recalculate:
+	status = metag_internal_irq_status();
+
+	irq_no = HWSTATMETA_TO_IRQ(0);
+	while (status != 0) {
+		if (status & 0x1) {
+			/*
+			 * Only fire off interrupts that are
+			 * registered to be handled by the kernel.
+			 * Other interrupts are probably being
+			 * handled by other Meta hardware threads.
+			 */
+			generic_handle_irq(irq_no);
+
+			/*
+			 * The handler may have re-enabled interrupts
+			 * which could have caused a nested invocation
+			 * of this code and make the copy of the
+			 * status register we are using invalid.
+			 */
+			goto recalculate;
+		}
+		status >>= 1;
+		irq_no++;
+	}
+}
+
+/**
+ *	metag_internal_irq_init_cpu - regsister with the Meta cpu
+ *	@cpu:	the CPU to register on
+ *
+ *	Configure @cpu's TR1 irq so that we can demux irqs.
+ */
+static void metag_internal_irq_init_cpu(int cpu)
+{
+	unsigned int thread = cpu_2_hwthread_id[cpu];
+
+	/* Register the multiplexed IRQ handler */
+	irq_set_chained_handler(TBID_SIGNUM_TR1(thread),
+				metag_internal_irq_demux);
+	irq_set_irq_type(TBID_SIGNUM_TR1(thread), IRQ_TYPE_LEVEL_LOW);
+}
+
+/**
+ *	metag_internal_irq_register - register internal IRQs
+ *
+ *	Register the irq chip and handler function for all internal IRQs
+ */
+void __init init_internal_IRQ(void)
+{
+	unsigned int cpu;
+	unsigned int i;
+
+	for (i = HWSTATMETA_TO_IRQ(0); i < HWSTATEXT_TO_IRQ(0); i++) {
+		/* only register interrupt if it is mapped */
+		if (metag_hwvec_addr(i)) {
+			mapped |= (1 << IRQ_TO_OFFSET(i));
+			irq_set_chip_and_handler(i, &internal_irq_edge_chip,
+							handle_edge_irq);
+		}
+	}
+
+	/* Setup TR1 for all cpus. */
+	for_each_possible_cpu(cpu)
+		metag_internal_irq_init_cpu(cpu);
+};
-- 
1.7.7.6


