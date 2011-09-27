Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1I0Uae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:30:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab1I0Ua1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:27 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 12/24] C6X: interrupt handling
Date: Tue, 27 Sep 2011 16:29:53 -0400
Message-Id: <1317155405-26235-13-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C6X core includes an interrupt controller with 12 inputs of fixed priority.
Each core is contained within a core "megamodule" which includes another
interrupt controller which cascades into the prioritized core controller. The
megamodule PIC has four interrupt combiners; each with up to 32 inputs which
are combined into one interrupt. The megamodule contains a set of MUX registers
which are used map megamodule interrupt sources to one of 12 core interrupts.
Any one of these 12 MUX outputs feeding into the core interrupt controller may
be the output from one of the four interrupt combiners or an individual
megamodule interrupt source. An individual megamodule interrupt source will
bypass the combiners if the MUX registers are set up such that the individual
interrupt feeds directly to one of the 12 core interrupts. This priority
mapping of interrupts is supported in the devicetree. For details, see

  Documentation/devicetree/bindings/c6x/interrupt.txt

The code in arch/c6x/kernel/irq.c which supports mapping of hardware to virtual
interrupts was taken as-is from powerpc. There is ongoing work to generalize
the virtual to hardware mapping and plans are to convert powerpc to use this.
C6X will also need to be converted over when the generic code is ready.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/hardirq.h     |   20 +
 arch/c6x/include/asm/irq.h         |  302 +++++++++++++++
 arch/c6x/include/asm/irqflags.h    |   72 ++++
 arch/c6x/include/asm/megamod-pic.h |    9 +
 arch/c6x/kernel/irq.c              |  730 ++++++++++++++++++++++++++++++++++++
 arch/c6x/platforms/megamod-pic.c   |  349 +++++++++++++++++
 6 files changed, 1482 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/hardirq.h
 create mode 100644 arch/c6x/include/asm/irq.h
 create mode 100644 arch/c6x/include/asm/irqflags.h
 create mode 100644 arch/c6x/include/asm/megamod-pic.h
 create mode 100644 arch/c6x/kernel/irq.c
 create mode 100644 arch/c6x/platforms/megamod-pic.c

diff --git a/arch/c6x/include/asm/hardirq.h b/arch/c6x/include/asm/hardirq.h
new file mode 100644
index 0000000..9621954
--- /dev/null
+++ b/arch/c6x/include/asm/hardirq.h
@@ -0,0 +1,20 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_C6X_HARDIRQ_H
+#define _ASM_C6X_HARDIRQ_H
+
+extern void ack_bad_irq(int irq);
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
+
+#endif /* _ASM_C6X_HARDIRQ_H */
diff --git a/arch/c6x/include/asm/irq.h b/arch/c6x/include/asm/irq.h
new file mode 100644
index 0000000..a6ae3c9
--- /dev/null
+++ b/arch/c6x/include/asm/irq.h
@@ -0,0 +1,302 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Large parts taken directly from powerpc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_IRQ_H
+#define _ASM_C6X_IRQ_H
+
+#include <linux/threads.h>
+#include <linux/list.h>
+#include <linux/radix-tree.h>
+#include <asm/percpu.h>
+
+#define irq_canonicalize(irq)  (irq)
+
+/*
+ * The C64X+ core has 16 IRQ vectors. One each is used by Reset and NMI. Two
+ * are reserved. The remaining 12 vectors are used to route SoC interrupts.
+ * These interrupt vectors are prioritized with IRQ 4 having the highest
+ * priority and IRQ 15 having the lowest.
+ *
+ * The C64x+ megamodule provides a PIC which combines SoC IRQ sources into a
+ * single core IRQ vector. There are four combined sources, each of which
+ * feed into one of the 12 general interrupt vectors. The remaining 8 vectors
+ * can each route a single SoC interrupt directly.
+ */
+#define NR_PRIORITY_IRQS 16
+
+#define NR_IRQS_LEGACY	NR_PRIORITY_IRQS
+
+/* Total number of virq in the platform */
+#define NR_IRQS		256
+
+/* This number is used when no interrupt has been assigned */
+#define NO_IRQ		0
+
+/* This type is the placeholder for a hardware interrupt number. It has to
+ * be big enough to enclose whatever representation is used by a given
+ * platform.
+ */
+typedef unsigned long irq_hw_number_t;
+
+/* Interrupt controller "host" data structure. This could be defined as a
+ * irq domain controller. That is, it handles the mapping between hardware
+ * and virtual interrupt numbers for a given interrupt domain. The host
+ * structure is generally created by the PIC code for a given PIC instance
+ * (though a host can cover more than one PIC if they have a flat number
+ * model). It's the host callbacks that are responsible for setting the
+ * irq_chip on a given irq_desc after it's been mapped.
+ *
+ * The host code and data structures are fairly agnostic to the fact that
+ * we use an open firmware device-tree. We do have references to struct
+ * device_node in two places: in irq_find_host() to find the host matching
+ * a given interrupt controller node, and of course as an argument to its
+ * counterpart host->ops->match() callback. However, those are treated as
+ * generic pointers by the core and the fact that it's actually a device-node
+ * pointer is purely a convention between callers and implementation. This
+ * code could thus be used on other architectures by replacing those two
+ * by some sort of arch-specific void * "token" used to identify interrupt
+ * controllers.
+ */
+struct irq_host;
+struct radix_tree_root;
+struct device_node;
+
+/* Functions below are provided by the host and called whenever a new mapping
+ * is created or an old mapping is disposed. The host can then proceed to
+ * whatever internal data structures management is required. It also needs
+ * to setup the irq_desc when returning from map().
+ */
+struct irq_host_ops {
+	/* Match an interrupt controller device node to a host, returns
+	 * 1 on a match
+	 */
+	int (*match)(struct irq_host *h, struct device_node *node);
+
+	/* Create or update a mapping between a virtual irq number and a hw
+	 * irq number. This is called only once for a given mapping.
+	 */
+	int (*map)(struct irq_host *h, unsigned int virq, irq_hw_number_t hw);
+
+	/* Dispose of such a mapping */
+	void (*unmap)(struct irq_host *h, unsigned int virq);
+
+	/* Translate device-tree interrupt specifier from raw format coming
+	 * from the firmware to a irq_hw_number_t (interrupt line number) and
+	 * type (sense) that can be passed to set_irq_type(). In the absence
+	 * of this callback, irq_create_of_mapping() and irq_of_parse_and_map()
+	 * will return the hw number in the first cell and IRQ_TYPE_NONE for
+	 * the type (which amount to keeping whatever default value the
+	 * interrupt controller has for that line)
+	 */
+	int (*xlate)(struct irq_host *h, struct device_node *ctrler,
+		     const u32 *intspec, unsigned int intsize,
+		     irq_hw_number_t *out_hwirq, unsigned int *out_type);
+};
+
+struct irq_host {
+	struct list_head	link;
+
+	/* type of reverse mapping technique */
+	unsigned int		revmap_type;
+#define IRQ_HOST_MAP_PRIORITY   0 /* core priority irqs, get irqs 1..15 */
+#define IRQ_HOST_MAP_NOMAP	1 /* no fast reverse mapping */
+#define IRQ_HOST_MAP_LINEAR	2 /* linear map of interrupts */
+#define IRQ_HOST_MAP_TREE	3 /* radix tree */
+	union {
+		struct {
+			unsigned int size;
+			unsigned int *revmap;
+		} linear;
+		struct radix_tree_root tree;
+	} revmap_data;
+	struct irq_host_ops	*ops;
+	void			*host_data;
+	irq_hw_number_t		inval_irq;
+
+	/* Optional device node pointer */
+	struct device_node	*of_node;
+};
+
+struct irq_data;
+extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
+extern irq_hw_number_t virq_to_hw(unsigned int virq);
+extern bool virq_is_host(unsigned int virq, struct irq_host *host);
+
+/**
+ * irq_alloc_host - Allocate a new irq_host data structure
+ * @of_node: optional device-tree node of the interrupt controller
+ * @revmap_type: type of reverse mapping to use
+ * @revmap_arg: for IRQ_HOST_MAP_LINEAR linear only: size of the map
+ * @ops: map/unmap host callbacks
+ * @inval_irq: provide a hw number in that host space that is always invalid
+ *
+ * Allocates and initialize and irq_host structure. Note that in the case of
+ * IRQ_HOST_MAP_LEGACY, the map() callback will be called before this returns
+ * for all legacy interrupts except 0 (which is always the invalid irq for
+ * a legacy controller). For a IRQ_HOST_MAP_LINEAR, the map is allocated by
+ * this call as well. For a IRQ_HOST_MAP_TREE, the radix tree will be allocated
+ * later during boot automatically (the reverse mapping will use the slow path
+ * until that happens).
+ */
+extern struct irq_host *irq_alloc_host(struct device_node *of_node,
+				       unsigned int revmap_type,
+				       unsigned int revmap_arg,
+				       struct irq_host_ops *ops,
+				       irq_hw_number_t inval_irq);
+
+
+/**
+ * irq_find_host - Locates a host for a given device node
+ * @node: device-tree node of the interrupt controller
+ */
+extern struct irq_host *irq_find_host(struct device_node *node);
+
+
+/**
+ * irq_set_default_host - Set a "default" host
+ * @host: default host pointer
+ *
+ * For convenience, it's possible to set a "default" host that will be used
+ * whenever NULL is passed to irq_create_mapping(). It makes life easier for
+ * platforms that want to manipulate a few hard coded interrupt numbers that
+ * aren't properly represented in the device-tree.
+ */
+extern void irq_set_default_host(struct irq_host *host);
+
+
+/**
+ * irq_set_virq_count - Set the maximum number of virt irqs
+ * @count: number of linux virtual irqs, capped with NR_IRQS
+ *
+ * This is mainly for use by platforms like iSeries who want to program
+ * the virtual irq number in the controller to avoid the reverse mapping
+ */
+extern void irq_set_virq_count(unsigned int count);
+
+
+/**
+ * irq_create_mapping - Map a hardware interrupt into linux virq space
+ * @host: host owning this hardware interrupt or NULL for default host
+ * @hwirq: hardware irq number in that host space
+ *
+ * Only one mapping per hardware interrupt is permitted. Returns a linux
+ * virq number.
+ * If the sense/trigger is to be specified, set_irq_type() should be called
+ * on the number returned from that call.
+ */
+extern unsigned int irq_create_mapping(struct irq_host *host,
+				       irq_hw_number_t hwirq);
+
+
+/**
+ * irq_dispose_mapping - Unmap an interrupt
+ * @virq: linux virq number of the interrupt to unmap
+ */
+extern void irq_dispose_mapping(unsigned int virq);
+
+/**
+ * irq_find_mapping - Find a linux virq from an hw irq number.
+ * @host: host owning this hardware interrupt
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is a slow path, for use by generic code. It's expected that an
+ * irq controller implementation directly calls the appropriate low level
+ * mapping function.
+ */
+extern unsigned int irq_find_mapping(struct irq_host *host,
+				     irq_hw_number_t hwirq);
+
+/**
+ * irq_create_direct_mapping - Allocate a virq for direct mapping
+ * @host: host to allocate the virq for or NULL for default host
+ *
+ * This routine is used for irq controllers which can choose the hardware
+ * interrupt numbers they generate. In such a case it's simplest to use
+ * the linux virq as the hardware interrupt number.
+ */
+extern unsigned int irq_create_direct_mapping(struct irq_host *host);
+
+/**
+ * irq_radix_revmap_insert - Insert a hw irq to linux virq number mapping.
+ * @host: host owning this hardware interrupt
+ * @virq: linux irq number
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is for use by irq controllers that use a radix tree reverse
+ * mapping for fast lookup.
+ */
+extern void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
+				    irq_hw_number_t hwirq);
+
+/**
+ * irq_radix_revmap_lookup - Find a linux virq from a hw irq number.
+ * @host: host owning this hardware interrupt
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is a fast path, for use by irq controller code that uses radix tree
+ * revmaps
+ */
+extern unsigned int irq_radix_revmap_lookup(struct irq_host *host,
+					    irq_hw_number_t hwirq);
+
+/**
+ * irq_linear_revmap - Find a linux virq from a hw irq number.
+ * @host: host owning this hardware interrupt
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is a fast path, for use by irq controller code that uses linear
+ * revmaps. It does fallback to the slow path if the revmap doesn't exist
+ * yet and will create the revmap entry with appropriate locking
+ */
+
+extern unsigned int irq_linear_revmap(struct irq_host *host,
+				      irq_hw_number_t hwirq);
+
+
+
+/**
+ * irq_alloc_virt - Allocate virtual irq numbers
+ * @host: host owning these new virtual irqs
+ * @count: number of consecutive numbers to allocate
+ * @hint: pass a hint number, the allocator will try to use a 1:1 mapping
+ *
+ * This is a low level function that is used internally by irq_create_mapping()
+ * and that can be used by some irq controllers implementations for things
+ * like allocating ranges of numbers for MSIs. The revmaps are left untouched.
+ */
+extern unsigned int irq_alloc_virt(struct irq_host *host,
+				   unsigned int count,
+				   unsigned int hint);
+
+/**
+ * irq_free_virt - Free virtual irq numbers
+ * @virq: virtual irq number of the first interrupt to free
+ * @count: number of interrupts to free
+ *
+ * This function is the opposite of irq_alloc_virt. It will not clear reverse
+ * maps, this should be done previously by unmap'ing the interrupt. In fact,
+ * all interrupts covered by the range being freed should have been unmapped
+ * prior to calling this.
+ */
+extern void irq_free_virt(unsigned int virq, unsigned int count);
+
+extern void __init init_pic_c64xplus(void);
+
+extern void init_IRQ(void);
+
+struct pt_regs;
+
+extern asmlinkage void c6x_do_IRQ(unsigned int prio, struct pt_regs *regs);
+
+extern unsigned long irq_err_count;
+
+#endif /* _ASM_C6X_IRQ_H */
diff --git a/arch/c6x/include/asm/irqflags.h b/arch/c6x/include/asm/irqflags.h
new file mode 100644
index 0000000..cf78e09
--- /dev/null
+++ b/arch/c6x/include/asm/irqflags.h
@@ -0,0 +1,72 @@
+/*
+ *  C6X IRQ flag handling
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Written by Mark Salter (msalter@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_IRQFLAGS_H
+#define _ASM_IRQFLAGS_H
+
+#ifndef __ASSEMBLY__
+
+/* read interrupt enabled status */
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+
+	asm volatile (" mvc .s2 CSR,%0\n" : "=b"(flags));
+	return flags;
+}
+
+/* set interrupt enabled status */
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile (" mvc .s2 %0,CSR\n" : : "b"(flags));
+}
+
+/* unconditionally enable interrupts */
+static inline void arch_local_irq_enable(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	flags |= 1;
+	arch_local_irq_restore(flags);
+}
+
+/* unconditionally disable interrupts */
+static inline void arch_local_irq_disable(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	flags &= ~1;
+	arch_local_irq_restore(flags);
+}
+
+/* get status and disable interrupts */
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+
+	flags = arch_local_save_flags();
+	arch_local_irq_restore(flags & ~1);
+	return flags;
+}
+
+/* test flags */
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & 1) == 0;
+}
+
+/* test hardware interrupt enable bit */
+static inline int arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_IRQFLAGS_H */
diff --git a/arch/c6x/include/asm/megamod-pic.h b/arch/c6x/include/asm/megamod-pic.h
new file mode 100644
index 0000000..eca0a86
--- /dev/null
+++ b/arch/c6x/include/asm/megamod-pic.h
@@ -0,0 +1,9 @@
+#ifndef _C6X_MEGAMOD_PIC_H
+#define _C6X_MEGAMOD_PIC_H
+
+#ifdef __KERNEL__
+
+extern void __init megamod_pic_init(void);
+
+#endif /* __KERNEL__ */
+#endif /* _C6X_MEGAMOD_PIC_H */
diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
new file mode 100644
index 0000000..832e02d
--- /dev/null
+++ b/arch/c6x/kernel/irq.c
@@ -0,0 +1,730 @@
+/*
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ *  This borrows heavily from powerpc version, which is:
+ *
+ *  Derived from arch/i386/kernel/irq.c
+ *    Copyright (C) 1992 Linus Torvalds
+ *  Adapted from arch/i386 by Gary Thomas
+ *    Copyright (C) 1995-1996 Gary Thomas (gdt@linuxppc.org)
+ *  Updated and modified by Cort Dougan <cort@fsmlabs.com>
+ *    Copyright (C) 1996-2001 Cort Dougan
+ *  Adapted for Power Macintosh by Paul Mackerras
+ *    Copyright (C) 1996 Paul Mackerras (paulus@cs.anu.edu.au)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <linux/radix-tree.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+
+#include <asm/megamod-pic.h>
+
+unsigned long irq_err_count;
+
+static raw_spinlock_t core_irq_lock;
+
+static void mask_core_irq(struct irq_data *data)
+{
+	unsigned int prio = data->irq;
+
+	BUG_ON(prio < 4 || prio >= NR_PRIORITY_IRQS);
+
+	raw_spin_lock(&core_irq_lock);
+	and_creg(IER, ~(1 << prio));
+	raw_spin_unlock(&core_irq_lock);
+}
+
+static void unmask_core_irq(struct irq_data *data)
+{
+	unsigned int prio = data->irq;
+
+	raw_spin_lock(&core_irq_lock);
+	or_creg(IER, 1 << prio);
+	raw_spin_unlock(&core_irq_lock);
+}
+
+static struct irq_chip core_chip = {
+	.name		= "core",
+	.irq_mask	= mask_core_irq,
+	.irq_unmask	= unmask_core_irq,
+};
+
+asmlinkage void c6x_do_IRQ(unsigned int prio, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+
+	BUG_ON(prio < 4 || prio >= NR_PRIORITY_IRQS);
+
+	generic_handle_irq(prio);
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
+static struct irq_host *core_host;
+
+static int core_host_map(struct irq_host *h, unsigned int virq,
+			 irq_hw_number_t hw)
+{
+	if (hw < 4 || hw >= NR_PRIORITY_IRQS)
+		return -1;
+
+	irq_set_status_flags(virq, IRQ_LEVEL);
+	irq_set_chip_and_handler(virq, &core_chip, handle_level_irq);
+	return 0;
+}
+
+static struct irq_host_ops core_host_ops = {
+	.map = core_host_map,
+};
+
+void __init init_IRQ(void)
+{
+	struct device_node *np;
+
+	raw_spin_lock_init(&core_irq_lock);
+
+	/* Mask all priority IRQs */
+	and_creg(IER, ~0xfff0);
+
+	np = of_find_compatible_node(NULL, NULL, "ti,c64x+core-pic");
+	if (np != NULL) {
+		/* create the core host */
+		core_host = irq_alloc_host(np, IRQ_HOST_MAP_PRIORITY, 0,
+					   &core_host_ops, 0);
+		if (core_host)
+			irq_set_default_host(core_host);
+		of_node_put(np);
+	}
+
+	printk(KERN_INFO "Core interrupt controller initialized\n");
+
+	/* now we're ready for other SoC controllers */
+	megamod_pic_init();
+
+	/* Clear all general IRQ flags */
+	set_creg(ICR, 0xfff0);
+}
+
+void ack_bad_irq(int irq)
+{
+	printk(KERN_ERR "IRQ: spurious interrupt %d\n", irq);
+	irq_err_count++;
+}
+
+int arch_show_interrupts(struct seq_file *p, int prec)
+{
+	seq_printf(p, "%*s: %10lu\n", prec, "Err", irq_err_count);
+	return 0;
+}
+
+/*
+ * IRQ controller and virtual interrupts
+ */
+
+/* The main irq map itself is an array of NR_IRQ entries containing the
+ * associate host and irq number. An entry with a host of NULL is free.
+ * An entry can be allocated if it's free, the allocator always then sets
+ * hwirq first to the host's invalid irq number and then fills ops.
+ */
+struct irq_map_entry {
+	irq_hw_number_t	hwirq;
+	struct irq_host	*host;
+};
+
+static LIST_HEAD(irq_hosts);
+static DEFINE_RAW_SPINLOCK(irq_big_lock);
+static DEFINE_MUTEX(revmap_trees_mutex);
+static struct irq_map_entry irq_map[NR_IRQS];
+static unsigned int irq_virq_count = NR_IRQS;
+static struct irq_host *irq_default_host;
+
+irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
+{
+	return irq_map[d->irq].hwirq;
+}
+EXPORT_SYMBOL_GPL(irqd_to_hwirq);
+
+irq_hw_number_t virq_to_hw(unsigned int virq)
+{
+	return irq_map[virq].hwirq;
+}
+EXPORT_SYMBOL_GPL(virq_to_hw);
+
+bool virq_is_host(unsigned int virq, struct irq_host *host)
+{
+	return irq_map[virq].host == host;
+}
+EXPORT_SYMBOL_GPL(virq_is_host);
+
+static int default_irq_host_match(struct irq_host *h, struct device_node *np)
+{
+	return h->of_node != NULL && h->of_node == np;
+}
+
+struct irq_host *irq_alloc_host(struct device_node *of_node,
+				unsigned int revmap_type,
+				unsigned int revmap_arg,
+				struct irq_host_ops *ops,
+				irq_hw_number_t inval_irq)
+{
+	struct irq_host *host;
+	unsigned int size = sizeof(struct irq_host);
+	unsigned int i;
+	unsigned int *rmap;
+	unsigned long flags;
+
+	/* Allocate structure and revmap table if using linear mapping */
+	if (revmap_type == IRQ_HOST_MAP_LINEAR)
+		size += revmap_arg * sizeof(unsigned int);
+	host = kzalloc(size, GFP_KERNEL);
+	if (host == NULL)
+		return NULL;
+
+	/* Fill structure */
+	host->revmap_type = revmap_type;
+	host->inval_irq = inval_irq;
+	host->ops = ops;
+	host->of_node = of_node_get(of_node);
+
+	if (host->ops->match == NULL)
+		host->ops->match = default_irq_host_match;
+
+	raw_spin_lock_irqsave(&irq_big_lock, flags);
+
+	/* Check for the priority controller. */
+	if (revmap_type == IRQ_HOST_MAP_PRIORITY) {
+		if (irq_map[0].host != NULL) {
+			raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+			of_node_put(host->of_node);
+			kfree(host);
+			return NULL;
+		}
+		irq_map[0].host = host;
+	}
+
+	list_add(&host->link, &irq_hosts);
+	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+
+	/* Additional setups per revmap type */
+	switch (revmap_type) {
+	case IRQ_HOST_MAP_PRIORITY:
+		/* 0 is always the invalid number for priority */
+		host->inval_irq = 0;
+		/* setup us as the host for all priority interrupts */
+		for (i = 1; i < NR_PRIORITY_IRQS; i++) {
+			irq_map[i].hwirq = i;
+			smp_wmb();
+			irq_map[i].host = host;
+			smp_wmb();
+
+			ops->map(host, i, i);
+		}
+		break;
+	case IRQ_HOST_MAP_LINEAR:
+		rmap = (unsigned int *)(host + 1);
+		for (i = 0; i < revmap_arg; i++)
+			rmap[i] = NO_IRQ;
+		host->revmap_data.linear.size = revmap_arg;
+		smp_wmb();
+		host->revmap_data.linear.revmap = rmap;
+		break;
+	case IRQ_HOST_MAP_TREE:
+		INIT_RADIX_TREE(&host->revmap_data.tree, GFP_KERNEL);
+		break;
+	default:
+		break;
+	}
+
+	pr_debug("irq: Allocated host of type %d @0x%p\n", revmap_type, host);
+
+	return host;
+}
+
+struct irq_host *irq_find_host(struct device_node *node)
+{
+	struct irq_host *h, *found = NULL;
+	unsigned long flags;
+
+	/* We might want to match the legacy controller last since
+	 * it might potentially be set to match all interrupts in
+	 * the absence of a device node. This isn't a problem so far
+	 * yet though...
+	 */
+	raw_spin_lock_irqsave(&irq_big_lock, flags);
+	list_for_each_entry(h, &irq_hosts, link)
+		if (h->ops->match(h, node)) {
+			found = h;
+			break;
+		}
+	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+	return found;
+}
+EXPORT_SYMBOL_GPL(irq_find_host);
+
+void irq_set_default_host(struct irq_host *host)
+{
+	pr_debug("irq: Default host set to @0x%p\n", host);
+
+	irq_default_host = host;
+}
+
+void irq_set_virq_count(unsigned int count)
+{
+	pr_debug("irq: Trying to set virq count to %d\n", count);
+
+	BUG_ON(count < NR_PRIORITY_IRQS);
+	if (count < NR_IRQS)
+		irq_virq_count = count;
+}
+
+static int irq_setup_virq(struct irq_host *host, unsigned int virq,
+			    irq_hw_number_t hwirq)
+{
+	int res;
+
+	res = irq_alloc_desc_at(virq, 0);
+	if (res != virq) {
+		pr_debug("irq: -> allocating desc failed\n");
+		goto error;
+	}
+
+	/* map it */
+	smp_wmb();
+	irq_map[virq].hwirq = hwirq;
+	smp_mb();
+
+	if (host->ops->map(host, virq, hwirq)) {
+		pr_debug("irq: -> mapping failed, freeing\n");
+		goto errdesc;
+	}
+
+	irq_clear_status_flags(virq, IRQ_NOREQUEST);
+
+	return 0;
+
+errdesc:
+	irq_free_descs(virq, 1);
+error:
+	irq_free_virt(virq, 1);
+	return -1;
+}
+
+unsigned int irq_create_direct_mapping(struct irq_host *host)
+{
+	unsigned int virq;
+
+	if (host == NULL)
+		host = irq_default_host;
+
+	BUG_ON(host == NULL);
+	WARN_ON(host->revmap_type != IRQ_HOST_MAP_NOMAP);
+
+	virq = irq_alloc_virt(host, 1, 0);
+	if (virq == NO_IRQ) {
+		pr_debug("irq: create_direct virq allocation failed\n");
+		return NO_IRQ;
+	}
+
+	pr_debug("irq: create_direct obtained virq %d\n", virq);
+
+	if (irq_setup_virq(host, virq, virq))
+		return NO_IRQ;
+
+	return virq;
+}
+
+unsigned int irq_create_mapping(struct irq_host *host,
+				irq_hw_number_t hwirq)
+{
+	unsigned int virq, hint;
+
+	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", host, hwirq);
+
+	/* Look for default host if nececssary */
+	if (host == NULL)
+		host = irq_default_host;
+	if (host == NULL) {
+		printk(KERN_WARNING "irq_create_mapping called for"
+		       " NULL host, hwirq=%lx\n", hwirq);
+		WARN_ON(1);
+		return NO_IRQ;
+	}
+	pr_debug("irq: -> using host @%p\n", host);
+
+	/* Check if mapping already exists */
+	virq = irq_find_mapping(host, hwirq);
+	if (virq != NO_IRQ) {
+		pr_debug("irq: -> existing mapping on virq %d\n", virq);
+		return virq;
+	}
+
+	/* Allocate a virtual interrupt number */
+	hint = hwirq % irq_virq_count;
+	virq = irq_alloc_virt(host, 1, hint);
+	if (virq == NO_IRQ) {
+		pr_debug("irq: -> virq allocation failed\n");
+		return NO_IRQ;
+	}
+
+	if (irq_setup_virq(host, virq, hwirq))
+		return NO_IRQ;
+
+	pr_debug("irq: irq %lu on host %s mapped to virtual irq %u\n",
+		hwirq, host->of_node ? host->of_node->full_name : "null", virq);
+
+	return virq;
+}
+EXPORT_SYMBOL_GPL(irq_create_mapping);
+
+unsigned int irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize)
+{
+	struct irq_host *host;
+	irq_hw_number_t hwirq;
+	unsigned int type = IRQ_TYPE_NONE;
+	unsigned int virq;
+
+	if (controller == NULL)
+		host = irq_default_host;
+	else
+		host = irq_find_host(controller);
+	if (host == NULL) {
+		printk(KERN_WARNING "irq: no irq host found for %s !\n",
+		       controller->full_name);
+		return NO_IRQ;
+	}
+
+	/* If host has no translation, then we assume interrupt line */
+	if (host->ops->xlate == NULL)
+		hwirq = intspec[0];
+	else {
+		if (host->ops->xlate(host, controller, intspec, intsize,
+				     &hwirq, &type))
+			return NO_IRQ;
+	}
+
+	/* Create mapping */
+	virq = irq_create_mapping(host, hwirq);
+	if (virq == NO_IRQ)
+		return virq;
+
+	/* Set type if specified and different than the current one */
+	if (type != IRQ_TYPE_NONE &&
+	    type != (irqd_get_trigger_type(irq_get_irq_data(virq))))
+		irq_set_irq_type(virq, type);
+	return virq;
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
+void irq_dispose_mapping(unsigned int virq)
+{
+	struct irq_host *host;
+	irq_hw_number_t hwirq;
+
+	if (virq == NO_IRQ)
+		return;
+
+	/* Never unmap priority interrupts */
+	if (virq < NR_PRIORITY_IRQS)
+		return;
+
+	host = irq_map[virq].host;
+	if (WARN_ON(host == NULL))
+		return;
+
+	irq_set_status_flags(virq, IRQ_NOREQUEST);
+
+	/* remove chip and handler */
+	irq_set_chip_and_handler(virq, NULL, NULL);
+
+	/* Make sure it's completed */
+	synchronize_irq(virq);
+
+	/* Tell the PIC about it */
+	if (host->ops->unmap)
+		host->ops->unmap(host, virq);
+	smp_mb();
+
+	/* Clear reverse map */
+	hwirq = irq_map[virq].hwirq;
+	switch (host->revmap_type) {
+	case IRQ_HOST_MAP_LINEAR:
+		if (hwirq < host->revmap_data.linear.size)
+			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
+		break;
+	case IRQ_HOST_MAP_TREE:
+		mutex_lock(&revmap_trees_mutex);
+		radix_tree_delete(&host->revmap_data.tree, hwirq);
+		mutex_unlock(&revmap_trees_mutex);
+		break;
+	}
+
+	/* Destroy map */
+	smp_mb();
+	irq_map[virq].hwirq = host->inval_irq;
+
+	irq_free_descs(virq, 1);
+	/* Free it */
+	irq_free_virt(virq, 1);
+}
+EXPORT_SYMBOL_GPL(irq_dispose_mapping);
+
+unsigned int irq_find_mapping(struct irq_host *host,
+			      irq_hw_number_t hwirq)
+{
+	unsigned int i;
+	unsigned int hint = hwirq % irq_virq_count;
+
+	/* Look for default host if nececssary */
+	if (host == NULL)
+		host = irq_default_host;
+	if (host == NULL)
+		return NO_IRQ;
+
+	/* Slow path does a linear search of the map */
+	i = hint;
+	do  {
+		if (irq_map[i].host == host &&
+		    irq_map[i].hwirq == hwirq)
+			return i;
+		i++;
+		if (i >= irq_virq_count)
+			i = 4;
+	} while (i != hint);
+	return NO_IRQ;
+}
+EXPORT_SYMBOL_GPL(irq_find_mapping);
+
+unsigned int irq_radix_revmap_lookup(struct irq_host *host,
+				     irq_hw_number_t hwirq)
+{
+	struct irq_map_entry *ptr;
+	unsigned int virq;
+
+	if (WARN_ON_ONCE(host->revmap_type != IRQ_HOST_MAP_TREE))
+		return irq_find_mapping(host, hwirq);
+
+	/*
+	 * The ptr returned references the static global irq_map.
+	 * but freeing an irq can delete nodes along the path to
+	 * do the lookup via call_rcu.
+	 */
+	rcu_read_lock();
+	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
+	rcu_read_unlock();
+
+	/*
+	 * If found in radix tree, then fine.
+	 * Else fallback to linear lookup - this should not happen in practice
+	 * as it means that we failed to insert the node in the radix tree.
+	 */
+	if (ptr)
+		virq = ptr - irq_map;
+	else
+		virq = irq_find_mapping(host, hwirq);
+
+	return virq;
+}
+
+void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
+			     irq_hw_number_t hwirq)
+{
+	if (WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE))
+		return;
+
+	if (virq != NO_IRQ) {
+		mutex_lock(&revmap_trees_mutex);
+		radix_tree_insert(&host->revmap_data.tree, hwirq,
+				  &irq_map[virq]);
+		mutex_unlock(&revmap_trees_mutex);
+	}
+}
+
+unsigned int irq_linear_revmap(struct irq_host *host,
+			       irq_hw_number_t hwirq)
+{
+	unsigned int *revmap;
+
+	if (WARN_ON_ONCE(host->revmap_type != IRQ_HOST_MAP_LINEAR))
+		return irq_find_mapping(host, hwirq);
+
+	/* Check revmap bounds */
+	if (unlikely(hwirq >= host->revmap_data.linear.size))
+		return irq_find_mapping(host, hwirq);
+
+	/* Check if revmap was allocated */
+	revmap = host->revmap_data.linear.revmap;
+	if (unlikely(revmap == NULL))
+		return irq_find_mapping(host, hwirq);
+
+	/* Fill up revmap with slow path if no mapping found */
+	if (unlikely(revmap[hwirq] == NO_IRQ))
+		revmap[hwirq] = irq_find_mapping(host, hwirq);
+
+	return revmap[hwirq];
+}
+
+unsigned int irq_alloc_virt(struct irq_host *host,
+			    unsigned int count,
+			    unsigned int hint)
+{
+	unsigned long flags;
+	unsigned int i, j, found = NO_IRQ;
+
+	if (count == 0 || count > (irq_virq_count - NR_PRIORITY_IRQS))
+		return NO_IRQ;
+
+	raw_spin_lock_irqsave(&irq_big_lock, flags);
+
+	/* Use hint for 1 interrupt if any */
+	if (count == 1 && hint >= NR_PRIORITY_IRQS &&
+	    hint < irq_virq_count && irq_map[hint].host == NULL) {
+		found = hint;
+		goto hint_found;
+	}
+
+	/* Look for count consecutive numbers in the allocatable
+	 * (non-legacy) space
+	 */
+	for (i = NR_PRIORITY_IRQS, j = 0; i < irq_virq_count; i++) {
+		if (irq_map[i].host != NULL)
+			j = 0;
+		else
+			j++;
+
+		if (j == count) {
+			found = i - count + 1;
+			break;
+		}
+	}
+	if (found == NO_IRQ) {
+		raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+		return NO_IRQ;
+	}
+ hint_found:
+	for (i = found; i < (found + count); i++) {
+		irq_map[i].hwirq = host->inval_irq;
+		smp_wmb();
+		irq_map[i].host = host;
+	}
+	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+	return found;
+}
+
+void irq_free_virt(unsigned int virq, unsigned int count)
+{
+	unsigned long flags;
+	unsigned int i;
+
+	WARN_ON(virq < NR_PRIORITY_IRQS);
+	WARN_ON(count == 0 || (virq + count) > irq_virq_count);
+
+	if (virq < NR_PRIORITY_IRQS) {
+		if (virq + count < NR_PRIORITY_IRQS)
+			return;
+		count  -= NR_PRIORITY_IRQS - virq;
+		virq = NR_PRIORITY_IRQS;
+	}
+
+	if (count > irq_virq_count || virq > irq_virq_count - count) {
+		if (virq > irq_virq_count)
+			return;
+		count = irq_virq_count - virq;
+	}
+
+	raw_spin_lock_irqsave(&irq_big_lock, flags);
+	for (i = virq; i < (virq + count); i++) {
+		struct irq_host *host;
+
+		host = irq_map[i].host;
+		irq_map[i].hwirq = host->inval_irq;
+		smp_wmb();
+		irq_map[i].host = NULL;
+	}
+	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+}
+
+#ifdef CONFIG_VIRQ_DEBUG
+static int virq_debug_show(struct seq_file *m, void *private)
+{
+	unsigned long flags;
+	struct irq_desc *desc;
+	const char *p;
+	static const char none[] = "none";
+	void *data;
+	int i;
+
+	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
+		      "chip name", "chip data", "host name");
+
+	for (i = 1; i < nr_irqs; i++) {
+		desc = irq_to_desc(i);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		if (desc->action && desc->action->handler) {
+			struct irq_chip *chip;
+
+			seq_printf(m, "%5d  ", i);
+			seq_printf(m, "0x%05lx  ", irq_map[i].hwirq);
+
+			chip = irq_desc_get_chip(desc);
+			if (chip && chip->name)
+				p = chip->name;
+			else
+				p = none;
+			seq_printf(m, "%-15s  ", p);
+
+			data = irq_desc_get_chip_data(desc);
+			seq_printf(m, "0x%16p  ", data);
+
+			if (irq_map[i].host && irq_map[i].host->of_node)
+				p = irq_map[i].host->of_node->full_name;
+			else
+				p = none;
+			seq_printf(m, "%s\n", p);
+		}
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	return 0;
+}
+
+static int virq_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, virq_debug_show, inode->i_private);
+}
+
+static const struct file_operations virq_debug_fops = {
+	.open = virq_debug_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init irq_debugfs_init(void)
+{
+	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
+				 NULL, &virq_debug_fops) == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+device_initcall(irq_debugfs_init);
+#endif /* CONFIG_VIRQ_DEBUG */
diff --git a/arch/c6x/platforms/megamod-pic.c b/arch/c6x/platforms/megamod-pic.c
new file mode 100644
index 0000000..7c37a94
--- /dev/null
+++ b/arch/c6x/platforms/megamod-pic.c
@@ -0,0 +1,349 @@
+/*
+ *  Support for C64x+ Megamodule Interrupt Controller
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Contributed by: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+#include <asm/soc.h>
+#include <asm/megamod-pic.h>
+
+#define NR_COMBINERS	4
+#define NR_MUX_OUTPUTS  12
+
+#define IRQ_UNMAPPED 0xffff
+
+/*
+ * Megamodule Interrupt Controller register layout
+ */
+struct megamod_regs {
+	u32	evtflag[8];
+	u32	evtset[8];
+	u32	evtclr[8];
+	u32	reserved0[8];
+	u32	evtmask[8];
+	u32	mevtflag[8];
+	u32	expmask[8];
+	u32	mexpflag[8];
+	u32	intmux_unused;
+	u32	intmux[7];
+	u32	reserved1[8];
+	u32	aegmux[2];
+	u32	reserved2[14];
+	u32	intxstat;
+	u32	intxclr;
+	u32	intdmask;
+	u32	reserved3[13];
+	u32	evtasrt;
+};
+
+struct megamod_pic {
+	struct irq_host	*irqhost;
+	struct megamod_regs __iomem *regs;
+	raw_spinlock_t lock;
+
+	/* hw mux mapping */
+	unsigned int output_to_irq[NR_MUX_OUTPUTS];
+};
+
+static struct megamod_pic *mm_pic;
+
+struct megamod_cascade_data {
+	struct megamod_pic *pic;
+	int index;
+};
+
+static struct megamod_cascade_data cascade_data[NR_COMBINERS];
+
+static void mask_megamod(struct irq_data *data)
+{
+	struct megamod_pic *pic = irq_data_get_irq_chip_data(data);
+	irq_hw_number_t src = irqd_to_hwirq(data);
+	u32 __iomem *evtmask = &pic->regs->evtmask[src / 32];
+
+	raw_spin_lock(&pic->lock);
+	soc_writel(soc_readl(evtmask) | (1 << (src & 31)), evtmask);
+	raw_spin_unlock(&pic->lock);
+}
+
+static void unmask_megamod(struct irq_data *data)
+{
+	struct megamod_pic *pic = irq_data_get_irq_chip_data(data);
+	irq_hw_number_t src = irqd_to_hwirq(data);
+	u32 __iomem *evtmask = &pic->regs->evtmask[src / 32];
+
+	raw_spin_lock(&pic->lock);
+	soc_writel(soc_readl(evtmask) & ~(1 << (src & 31)), evtmask);
+	raw_spin_unlock(&pic->lock);
+}
+
+static struct irq_chip megamod_chip = {
+	.name		= "megamod",
+	.irq_mask	= mask_megamod,
+	.irq_unmask	= unmask_megamod,
+};
+
+static void megamod_irq_cascade(unsigned int irq, struct irq_desc *desc)
+{
+	struct megamod_cascade_data *cascade;
+	struct megamod_pic *pic;
+	u32 events;
+	int n, idx;
+
+	cascade = irq_desc_get_handler_data(desc);
+
+	pic = cascade->pic;
+	idx = cascade->index;
+
+	while ((events = soc_readl(&pic->regs->mevtflag[idx])) != 0) {
+		n = __ffs(events);
+
+		irq = irq_linear_revmap(pic->irqhost, idx * 32 + n);
+
+		soc_writel(1 << n, &pic->regs->evtclr[idx]);
+
+		generic_handle_irq(irq);
+	}
+}
+
+static int megamod_map(struct irq_host *h, unsigned int virq,
+		       irq_hw_number_t hw)
+{
+	struct megamod_pic *pic = h->host_data;
+	int i;
+
+	/* We shouldn't see a hwirq which is muxed to core controller */
+	for (i = 0; i < NR_MUX_OUTPUTS; i++)
+		if (pic->output_to_irq[i] == hw)
+			return -1;
+
+	irq_set_chip_data(virq, pic);
+	irq_set_chip_and_handler(virq, &megamod_chip, handle_level_irq);
+
+	/* Set default irq type */
+	irq_set_irq_type(virq, IRQ_TYPE_NONE);
+
+	return 0;
+}
+
+static int megamod_xlate(struct irq_host *h, struct device_node *ct,
+			 const u32 *intspec, unsigned int intsize,
+			 irq_hw_number_t *out_hwirq, unsigned int *out_type)
+
+{
+	/* megamod intspecs must have 1 cell */
+	BUG_ON(intsize != 1);
+	*out_hwirq = intspec[0];
+	*out_type = IRQ_TYPE_NONE;
+	return 0;
+}
+
+static struct irq_host_ops megamod_host_ops = {
+	.map	= megamod_map,
+	.xlate	= megamod_xlate,
+};
+
+static void __init set_megamod_mux(struct megamod_pic *pic, int src, int output)
+{
+	int index, offset;
+	u32 val;
+
+	if (src < 0 || src >= (NR_COMBINERS * 32)) {
+		pic->output_to_irq[output] = IRQ_UNMAPPED;
+		return;
+	}
+
+	/* four mappings per mux register */
+	index = output / 4;
+	offset = (output & 3) * 8;
+
+	val = soc_readl(&pic->regs->intmux[index]);
+	val &= ~(0xff << offset);
+	val |= src << offset;
+	soc_writel(val, &pic->regs->intmux[index]);
+}
+
+/*
+ * Parse the MUX mapping, if one exists.
+ *
+ * The MUX map is an array of up to 12 cells; one for each usable core priority
+ * interrupt. The value of a given cell is the megamodule interrupt source
+ * which is to me MUXed to the output corresponding to the cell position
+ * withing the array. The first cell in the array corresponds to priority
+ * 4 and the last (12th) cell corresponds to priority 15. The allowed
+ * values are 4 - ((NR_COMBINERS * 32) - 1). Note that the combined interrupt
+ * sources (0 - 3) are not allowed to be mapped through this property. They
+ * are handled through the "interrupts" property. This allows us to use a
+ * value of zero as a "do not map" placeholder.
+ */
+static void __init parse_priority_map(struct megamod_pic *pic,
+				      int *mapping, int size)
+{
+	struct device_node *np = pic->irqhost->of_node;
+	const __be32 *map;
+	int i, maplen;
+	u32 val;
+
+	map = of_get_property(np, "ti,c64x+megamod-pic-mux", &maplen);
+	if (map) {
+		maplen /= 4;
+		if (maplen > size)
+			maplen = size;
+
+		for (i = 0; i < maplen; i++) {
+			val = be32_to_cpup(map);
+			if (val && val >= 4)
+				mapping[i] = val;
+			++map;
+		}
+	}
+}
+
+static struct megamod_pic * __init init_megamod_pic(struct device_node *np)
+{
+	struct megamod_pic *pic;
+	int i, irq;
+	int mapping[NR_MUX_OUTPUTS];
+
+	pr_info("Initializing C64x+ Megamodule PIC\n");
+
+	pic = kzalloc(sizeof(struct megamod_pic), GFP_KERNEL);
+	if (!pic) {
+		pr_err("%s: Could not alloc PIC structure.\n", np->full_name);
+		return NULL;
+	}
+
+	pic->irqhost = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
+				      NR_COMBINERS * 32, &megamod_host_ops,
+				      IRQ_UNMAPPED);
+	if (!pic->irqhost) {
+		pr_err("%s: Could not alloc host.\n", np->full_name);
+		goto error_free;
+	}
+
+	pic->irqhost->host_data = pic;
+
+	raw_spin_lock_init(&pic->lock);
+
+	pic->regs = of_iomap(np, 0);
+	if (!pic->regs) {
+		pr_err("%s: Could not map registers.\n", np->full_name);
+		goto error_free;
+	}
+
+	/* Initialize MUX map */
+	for (i = 0; i < ARRAY_SIZE(mapping); i++)
+		mapping[i] = IRQ_UNMAPPED;
+
+	parse_priority_map(pic, mapping, ARRAY_SIZE(mapping));
+
+	/*
+	 * We can have up to 12 interrupts cascading to the core controller.
+	 * These cascades can be from the combined interrupt sources or for
+	 * individual interrupt sources. The "interrupts" property only
+	 * deals with the cascaded combined interrupts. The individual
+	 * interrupts muxed to the core controller use the core controller
+	 * as their interrupt parent.
+	 */
+	for (i = 0; i < NR_COMBINERS; i++) {
+
+		irq = irq_of_parse_and_map(np, i);
+		if (irq == NO_IRQ)
+			continue;
+
+		/*
+		 * We count on the core priority interrupts (4 - 15) being
+		 * direct mapped. Check that device tree provided something
+		 * in that range.
+		 */
+		if (irq < 4 || irq >= NR_PRIORITY_IRQS) {
+			pr_err("%s: combiner-%d virq %d out of range!\n",
+				 np->full_name, i, irq);
+			continue;
+		}
+
+		/* record the mapping */
+		mapping[irq - 4] = i;
+
+		pr_debug("%s: combiner-%d cascading to virq %d\n",
+			 np->full_name, i, irq);
+
+		cascade_data[i].pic = pic;
+		cascade_data[i].index = i;
+
+		/* mask and clear all events in combiner */
+		soc_writel(~0, &pic->regs->evtmask[i]);
+		soc_writel(~0, &pic->regs->evtclr[i]);
+
+		irq_set_handler_data(irq, &cascade_data[i]);
+		irq_set_chained_handler(irq, megamod_irq_cascade);
+	}
+
+	/* Finally, set up the MUX registers */
+	for (i = 0; i < NR_MUX_OUTPUTS; i++) {
+		if (mapping[i] != IRQ_UNMAPPED) {
+			pr_debug("%s: setting mux %d to priority %d\n",
+				 np->full_name, mapping[i], i + 4);
+			set_megamod_mux(pic, mapping[i], i);
+		}
+	}
+
+	return pic;
+
+error_free:
+	kfree(pic);
+
+	return NULL;
+}
+
+/*
+ * Return next active event after ACK'ing it.
+ * Return -1 if no events active.
+ */
+static int get_exception(void)
+{
+	int i, bit;
+	u32 mask;
+
+	for (i = 0; i < NR_COMBINERS; i++) {
+		mask = soc_readl(&mm_pic->regs->mexpflag[i]);
+		if (mask) {
+			bit = __ffs(mask);
+			soc_writel(1 << bit, &mm_pic->regs->evtclr[i]);
+			return (i * 32) + bit;
+		}
+	}
+	return -1;
+}
+
+static void assert_event(unsigned int val)
+{
+	soc_writel(val, &mm_pic->regs->evtasrt);
+}
+
+void __init megamod_pic_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "ti,c64x+megamod-pic");
+	if (!np)
+		return;
+
+	mm_pic = init_megamod_pic(np);
+	of_node_put(np);
+
+	soc_ops.get_exception = get_exception;
+	soc_ops.assert_event = assert_event;
+
+	return;
+}
-- 
1.7.6.2

