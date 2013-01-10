Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3AJPjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:39:03 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55618 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab3AJPcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:51 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v3 23/44] metag: IRQ handling
Date: Thu, 10 Jan 2013 15:30:51 +0000
Message-ID: <1357831872-29451-24-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add core IRQ handling for metag. The code in irq.c exposes the TBX
signal numbers as Linux IRQs.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/irq.h      |   32 ++++
 arch/metag/include/asm/irqflags.h |   97 +++++++++++
 arch/metag/kernel/irq.c           |  317 +++++++++++++++++++++++++++++++++++++
 3 files changed, 446 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/irq.h
 create mode 100644 arch/metag/include/asm/irqflags.h
 create mode 100644 arch/metag/kernel/irq.c

diff --git a/arch/metag/include/asm/irq.h b/arch/metag/include/asm/irq.h
new file mode 100644
index 0000000..be0c8f3
--- /dev/null
+++ b/arch/metag/include/asm/irq.h
@@ -0,0 +1,32 @@
+#ifndef __ASM_METAG_IRQ_H
+#define __ASM_METAG_IRQ_H
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
+int tbisig_map(unsigned int hw);
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
index 0000000..769bd74
--- /dev/null
+++ b/arch/metag/kernel/irq.c
@@ -0,0 +1,317 @@
+/*
+ * Linux/Meta general interrupt handling code
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/irqdomain.h>
+#include <linux/ratelimit.h>
+
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
+struct irq_domain *root_domain;
+
+static unsigned int startup_meta_irq(struct irq_data *data)
+{
+	tbi_startup_interrupt(data->hwirq);
+	return 0;
+}
+
+static void shutdown_meta_irq(struct irq_data *data)
+{
+	tbi_shutdown_interrupt(data->hwirq);
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
+	irq = irq_linear_revmap(root_domain, irq);
+
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	/* Debugging check for stack overflow: is there less than 1KB free? */
+	{
+		unsigned long sp;
+
+		asm volatile ("MOV %0,A0StP\n" : "=r"(sp));
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
+		asm volatile (
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
+		asm volatile (
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
+/**
+ * tbisig_map() - Map a TBI signal number to a virtual IRQ number.
+ * @hw:		Number of the TBI signal. Must be in range.
+ *
+ * Returns:	The virtual IRQ number of the TBI signal number IRQ specified by
+ *		@hw.
+ */
+int tbisig_map(unsigned int hw)
+{
+	return irq_create_mapping(root_domain, hw);
+}
+
+/**
+ * metag_tbisig_map() - map a tbi signal to a Linux virtual IRQ number
+ * @d:		root irq domain
+ * @irq:	virtual irq number
+ * @hw:		hardware irq number (TBI signal number)
+ *
+ * This sets up a virtual irq for a specified TBI signal number.
+ */
+static int metag_tbisig_map(struct irq_domain *d, unsigned int irq,
+			    irq_hw_number_t hw)
+{
+#ifdef CONFIG_SMP
+	irq_set_chip_and_handler(irq, &meta_irq_type, handle_percpu_irq);
+#else
+	irq_set_chip_and_handler(irq, &meta_irq_type, handle_simple_irq);
+#endif
+	return 0;
+}
+
+static const struct irq_domain_ops metag_tbisig_domain_ops = {
+	.map = metag_tbisig_map,
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
+	root_domain = irq_domain_add_linear(NULL, 32,
+					    &metag_tbisig_domain_ops, NULL);
+	if (unlikely(!root_domain))
+		panic("init_IRQ: cannot add root IRQ domain");
+
+	irq_ctx_init(smp_processor_id());
+
+	if (machine_desc->init_irq)
+		machine_desc->init_irq();
+}
+
+int __init arch_probe_nr_irqs(void)
+{
+	if (machine_desc->nr_irqs)
+		nr_irqs = machine_desc->nr_irqs;
+	return 0;
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
+	struct irq_desc *desc;
+
+	for_each_irq_desc(i, desc) {
+		struct irq_data *data = irq_desc_get_irq_data(desc);
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
-- 
1.7.7.6


