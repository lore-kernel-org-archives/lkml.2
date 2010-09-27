Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab0I0Mtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:49:31 -0400
Received: from www.tglx.de ([62.245.132.106]:34533 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759105Ab0I0Mo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:44:57 -0400
Message-Id: <20100927121841.545485282@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 01/19] genirq: Cleanup access to irq_data
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-cleanup-access-to-irq-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup the open coded access to 
      irq_desc->[handler_data|chip_data|msi-desc]

Use the macros and inline functions for it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/plat-samsung/irq-uart.c             |    5 -
 arch/arm/plat-samsung/irq-vic-timer.c        |    7 --
 arch/avr32/mach-at32ap/extint.c              |    2 
 arch/powerpc/include/asm/qe_ic.h             |   10 +--
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    2 
 arch/powerpc/platforms/cell/interrupt.c      |    4 +
 arch/powerpc/platforms/cell/setup.c          |    2 
 arch/powerpc/platforms/cell/spider-pic.c     |    2 
 arch/powerpc/platforms/powermac/pic.c        |    2 
 arch/powerpc/platforms/pseries/xics.c        |    2 
 arch/powerpc/sysdev/mpic.c                   |    6 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c           |    2 
 arch/x86/kernel/apic/io_apic.c               |   71 +++++++++++++--------------
 arch/x86/kernel/uv_irq.c                     |    2 
 drivers/parisc/dino.c                        |    6 --
 drivers/parisc/gsc.c                         |   12 +---
 drivers/parisc/iosapic.c                     |    4 -
 include/linux/irq.h                          |    5 +
 18 files changed, 71 insertions(+), 75 deletions(-)

Index: linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-samsung/irq-uart.c
+++ linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
@@ -83,7 +83,7 @@ static void s3c_irq_uart_ack(unsigned in
 
 static void s3c_irq_demux_uart(unsigned int irq, struct irq_desc *desc)
 {
-	struct s3c_uart_irq *uirq = desc->handler_data;
+	struct s3c_uart_irq *uirq = get_irq_desc_data(desc);
 	u32 pend = __raw_readl(uirq->regs + S3C64XX_UINTP);
 	int base = uirq->base_irq;
 
@@ -107,7 +107,6 @@ static struct irq_chip s3c_irq_uart = {
 
 static void __init s3c_init_uart_irq(struct s3c_uart_irq *uirq)
 {
-	struct irq_desc *desc = irq_to_desc(uirq->parent_irq);
 	void __iomem *reg_base = uirq->regs;
 	unsigned int irq;
 	int offs;
@@ -124,7 +123,7 @@ static void __init s3c_init_uart_irq(str
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
-	desc->handler_data = uirq;
+	set_irq_data(uirq->parent_irq, uirq);
 	set_irq_chained_handler(uirq->parent_irq, s3c_irq_demux_uart);
 }
 
Index: linux-2.6-tip/arch/arm/plat-samsung/irq-vic-timer.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-samsung/irq-vic-timer.c
+++ linux-2.6-tip/arch/arm/plat-samsung/irq-vic-timer.c
@@ -24,7 +24,7 @@
 
 static void s3c_irq_demux_vic_timer(unsigned int irq, struct irq_desc *desc)
 {
-	generic_handle_irq((int)desc->handler_data);
+	generic_handle_irq((int)get_irq_desc_data(desc));
 }
 
 /* We assume the IRQ_TIMER0..IRQ_TIMER4 range is continuous. */
@@ -74,13 +74,10 @@ static struct irq_chip s3c_irq_timer = {
 void __init s3c_init_vic_timer_irq(unsigned int parent_irq,
 				   unsigned int timer_irq)
 {
-	struct irq_desc *desc = irq_to_desc(parent_irq);
-
 	set_irq_chained_handler(parent_irq, s3c_irq_demux_vic_timer);
 
 	set_irq_chip(timer_irq, &s3c_irq_timer);
 	set_irq_handler(timer_irq, handle_level_irq);
 	set_irq_flags(timer_irq, IRQF_VALID);
-
-	desc->handler_data = (void *)timer_irq;
+	set_irq_data(timer_irq, (void *)timer_irq;
 }
Index: linux-2.6-tip/arch/avr32/mach-at32ap/extint.c
===================================================================
--- linux-2.6-tip.orig/arch/avr32/mach-at32ap/extint.c
+++ linux-2.6-tip/arch/avr32/mach-at32ap/extint.c
@@ -154,7 +154,7 @@ static struct irq_chip eic_chip = {
 
 static void demux_eic_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct eic *eic = desc->handler_data;
+	struct eic *eic = get_irq_desc_data(desc);
 	unsigned long status, pending;
 	unsigned int i;
 
Index: linux-2.6-tip/arch/powerpc/include/asm/qe_ic.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/qe_ic.h
+++ linux-2.6-tip/arch/powerpc/include/asm/qe_ic.h
@@ -81,7 +81,7 @@ int qe_ic_set_high_priority(unsigned int
 static inline void qe_ic_cascade_low_ipic(unsigned int irq,
 					  struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = desc->handler_data;
+	struct qe_ic *qe_ic = get_irq_desc_data(desc);
 	unsigned int cascade_irq = qe_ic_get_low_irq(qe_ic);
 
 	if (cascade_irq != NO_IRQ)
@@ -91,7 +91,7 @@ static inline void qe_ic_cascade_low_ipi
 static inline void qe_ic_cascade_high_ipic(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = desc->handler_data;
+	struct qe_ic *qe_ic = get_irq_desc_data(desc);
 	unsigned int cascade_irq = qe_ic_get_high_irq(qe_ic);
 
 	if (cascade_irq != NO_IRQ)
@@ -101,7 +101,7 @@ static inline void qe_ic_cascade_high_ip
 static inline void qe_ic_cascade_low_mpic(unsigned int irq,
 					  struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = desc->handler_data;
+	struct qe_ic *qe_ic = get_irq_desc_data(desc);
 	unsigned int cascade_irq = qe_ic_get_low_irq(qe_ic);
 
 	if (cascade_irq != NO_IRQ)
@@ -113,7 +113,7 @@ static inline void qe_ic_cascade_low_mpi
 static inline void qe_ic_cascade_high_mpic(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = desc->handler_data;
+	struct qe_ic *qe_ic = get_irq_desc_data(desc);
 	unsigned int cascade_irq = qe_ic_get_high_irq(qe_ic);
 
 	if (cascade_irq != NO_IRQ)
@@ -125,7 +125,7 @@ static inline void qe_ic_cascade_high_mp
 static inline void qe_ic_cascade_muxed_mpic(unsigned int irq,
 					    struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = desc->handler_data;
+	struct qe_ic *qe_ic = get_irq_desc_data(desc);
 	unsigned int cascade_irq;
 
 	cascade_irq = qe_ic_get_high_irq(qe_ic);
Index: linux-2.6-tip/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -82,7 +82,7 @@ static struct irq_chip pq2ads_pci_ic = {
 
 static void pq2ads_pci_irq_demux(unsigned int irq, struct irq_desc *desc)
 {
-	struct pq2ads_pci_pic *priv = desc->handler_data;
+	struct pq2ads_pci_pic *priv = get_irq_desc_data(desc);
 	u32 stat, mask, pend;
 	int bit;
 
Index: linux-2.6-tip/arch/powerpc/platforms/cell/interrupt.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/interrupt.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/interrupt.c
@@ -101,11 +101,13 @@ static void iic_ioexc_eoi(unsigned int i
 
 static void iic_ioexc_cascade(unsigned int irq, struct irq_desc *desc)
 {
-	struct cbe_iic_regs __iomem *node_iic = (void __iomem *)desc->handler_data;
+	struct cbe_iic_regs __iomem *node_iic;
 	unsigned int base = (irq & 0xffffff00) | IIC_IRQ_TYPE_IOEXC;
 	unsigned long bits, ack;
 	int cascade;
 
+	node_iic = (void __iomem *)get_irq_desc_data(desc);
+
 	for (;;) {
 		bits = in_be64(&node_iic->iic_is);
 		if (bits == 0)
Index: linux-2.6-tip/arch/powerpc/platforms/cell/setup.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/setup.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/setup.c
@@ -187,7 +187,7 @@ machine_subsys_initcall(cell, cell_publi
 
 static void cell_mpic_cascade(unsigned int irq, struct irq_desc *desc)
 {
-	struct mpic *mpic = desc->handler_data;
+	struct mpic *mpic = get_irq_desc_data(desc);
 	unsigned int virq;
 
 	virq = mpic_get_one_irq(mpic);
Index: linux-2.6-tip/arch/powerpc/platforms/cell/spider-pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/spider-pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/spider-pic.c
@@ -207,7 +207,7 @@ static struct irq_host_ops spider_host_o
 
 static void spider_irq_cascade(unsigned int irq, struct irq_desc *desc)
 {
-	struct spider_pic *pic = desc->handler_data;
+	struct spider_pic *pic = get_irq_desc_data(desc);
 	unsigned int cs, virq;
 
 	cs = in_be32(pic->regs + TIR_CS) >> 24;
Index: linux-2.6-tip/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/powermac/pic.c
@@ -472,7 +472,7 @@ int of_irq_map_oldworld(struct device_no
 
 static void pmac_u3_cascade(unsigned int irq, struct irq_desc *desc)
 {
-	struct mpic *mpic = desc->handler_data;
+	struct mpic *mpic = get_irq_desc_data(desc);
 
 	unsigned int cascade_irq = mpic_get_one_irq(mpic);
 	if (cascade_irq != NO_IRQ)
Index: linux-2.6-tip/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6-tip/arch/powerpc/platforms/pseries/xics.c
@@ -242,7 +242,7 @@ static unsigned int xics_startup(unsigne
 	 * card, using the MSI mask bits. Firmware doesn't appear to unmask
 	 * at that level, so we do it here by hand.
 	 */
-	if (irq_to_desc(virq)->msi_desc)
+	if (get_irq_msi(virq))
 		unmask_msi_irq(virq);
 
 	/* unmask it */
Index: linux-2.6-tip/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/mpic.c
@@ -611,7 +611,7 @@ static struct mpic *mpic_find(unsigned i
 	if (irq < NUM_ISA_INTERRUPTS)
 		return NULL;
 
-	return irq_to_desc(irq)->chip_data;
+	return get_irq_chip_data(irq);
 }
 
 /* Determine if the linux irq is an IPI */
@@ -638,14 +638,14 @@ static inline u32 mpic_physmask(u32 cpum
 /* Get the mpic structure from the IPI number */
 static inline struct mpic * mpic_from_ipi(unsigned int ipi)
 {
-	return irq_to_desc(ipi)->chip_data;
+	return get_irq_chip_data(ipi);
 }
 #endif
 
 /* Get the mpic structure from the irq number */
 static inline struct mpic * mpic_from_irq(unsigned int irq)
 {
-	return irq_to_desc(irq)->chip_data;
+	return get_irq_chip_data(irq);
 }
 
 /* Send an EOI */
Index: linux-2.6-tip/arch/powerpc/sysdev/qe_lib/qe_ic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -189,7 +189,7 @@ static inline void qe_ic_write(volatile 
 
 static inline struct qe_ic *qe_ic_from_irq(unsigned int virq)
 {
-	return irq_to_desc(virq)->chip_data;
+	return get_irq_chip_data(virq);
 }
 
 #define virq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -166,7 +166,7 @@ int __init arch_early_irq_init(void)
 
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
-		desc->chip_data = &cfg[i];
+		set_irq_desc_chip_data(desc, &cfg[i]);
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
 		/*
@@ -190,7 +190,7 @@ struct irq_cfg *irq_cfg(unsigned int irq
 
 	desc = irq_to_desc(irq);
 	if (desc)
-		cfg = desc->chip_data;
+		cfg = get_irq_desc_chip_data(desc);
 
 	return cfg;
 }
@@ -219,10 +219,11 @@ int arch_init_chip_data(struct irq_desc 
 {
 	struct irq_cfg *cfg;
 
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 	if (!cfg) {
-		desc->chip_data = get_one_free_irq_cfg(node);
-		if (!desc->chip_data) {
+		cfg = get_one_free_irq_cfg(node);
+		set_irq_desc_chip_data(desc, cfg);
+		if (!cfg) {
 			printk(KERN_ERR "can not alloc irq_cfg\n");
 			BUG_ON(1);
 		}
@@ -302,9 +303,9 @@ void arch_init_copy_chip_data(struct irq
 	if (!cfg)
 		return;
 
-	desc->chip_data = cfg;
+	set_irq_desc_chip_data(desc, cfg);
 
-	old_cfg = old_desc->chip_data;
+	old_cfg = get_irq_desc_chip_data(old_desc);
 
 	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
 
@@ -320,8 +321,8 @@ void arch_free_chip_data(struct irq_desc
 {
 	struct irq_cfg *old_cfg, *cfg;
 
-	old_cfg = old_desc->chip_data;
-	cfg = desc->chip_data;
+	old_cfg = get_irq_desc_chip_data(old_desc);
+	cfg = get_irq_desc_chip_data(desc);
 
 	if (old_cfg == cfg)
 		return;
@@ -329,7 +330,7 @@ void arch_free_chip_data(struct irq_desc
 	if (old_cfg) {
 		free_irq_2_pin(old_cfg, cfg);
 		free_irq_cfg(old_cfg);
-		old_desc->chip_data = NULL;
+		set_irq_desc_chip_data(old_desc, NULL);
 	}
 }
 /* end for move_irq_desc */
@@ -589,7 +590,7 @@ static void __mask_IO_APIC_irq(struct ir
 
 static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
-	struct irq_cfg *cfg = desc->chip_data;
+	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	BUG_ON(!cfg);
@@ -601,7 +602,7 @@ static void mask_IO_APIC_irq_desc(struct
 
 static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
-	struct irq_cfg *cfg = desc->chip_data;
+	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
@@ -1264,7 +1265,7 @@ void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
-		cfg = desc->chip_data;
+		cfg = get_irq_desc_chip_data(desc);
 
 		/*
 		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
@@ -1436,7 +1437,7 @@ static void setup_IO_APIC_irq(int apic_i
 	if (!IO_APIC_IRQ(irq))
 		return;
 
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 
 	/*
 	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
@@ -1525,7 +1526,7 @@ static void __init setup_IO_APIC_irqs(vo
 			printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 			continue;
 		}
-		cfg = desc->chip_data;
+		cfg = get_irq_desc_chip_data(desc);
 		add_pin_to_irq_node(cfg, node, apic_id, pin);
 		/*
 		 * don't mark it in pin_programmed, so later acpi could
@@ -1576,7 +1577,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 	}
 
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 	add_pin_to_irq_node(cfg, node, apic_id, pin);
 
 	if (test_bit(pin, mp_ioapic_routing[apic_id].pin_programmed)) {
@@ -1727,7 +1728,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	for_each_irq_desc(irq, desc) {
 		struct irq_pin_list *entry;
 
-		cfg = desc->chip_data;
+		cfg = get_irq_desc_chip_data(desc);
 		if (!cfg)
 			continue;
 		entry = cfg->irq_2_pin;
@@ -2332,7 +2333,7 @@ set_desc_affinity(struct irq_desc *desc,
 		return -1;
 
 	irq = desc->irq;
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 	if (assign_irq_vector(irq, cfg, mask))
 		return -1;
 
@@ -2352,7 +2353,7 @@ set_ioapic_affinity_irq_desc(struct irq_
 	int ret = -1;
 
 	irq = desc->irq;
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	ret = set_desc_affinity(desc, mask, &dest);
@@ -2405,7 +2406,7 @@ migrate_ioapic_irq_desc(struct irq_desc 
 	if (get_irte(irq, &irte))
 		return ret;
 
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 	if (assign_irq_vector(irq, cfg, mask))
 		return ret;
 
@@ -2509,7 +2510,7 @@ unlock:
 static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
 {
 	struct irq_desc *desc = *descp;
-	struct irq_cfg *cfg = desc->chip_data;
+	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 	unsigned me;
 
 	if (likely(!cfg->move_in_progress))
@@ -2529,7 +2530,7 @@ static void irq_complete_move(struct irq
 void irq_force_complete_move(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = desc->chip_data;
+	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 
 	if (!cfg)
 		return;
@@ -2597,7 +2598,7 @@ static void eoi_ioapic_irq(struct irq_de
 	unsigned int irq;
 
 	irq = desc->irq;
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__eoi_ioapic_irq(irq, cfg);
@@ -2653,7 +2654,7 @@ static void ack_apic_level(unsigned int 
 	 * we use the above logic (mask+edge followed by unmask+level) from
 	 * Manfred Spraul to clear the remote IRR.
 	 */
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 	i = cfg->vector;
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
 
@@ -2704,7 +2705,7 @@ static void ack_apic_level(unsigned int 
 		 * accurate and is causing problems then it is a hardware bug
 		 * and you can go talk to the chipset vendor about it.
 		 */
-		cfg = desc->chip_data;
+		cfg = get_irq_desc_chip_data(desc);
 		if (!io_apic_level_ack_pending(cfg))
 			move_masked_irq(irq);
 		unmask_IO_APIC_irq_desc(desc);
@@ -2772,7 +2773,7 @@ static inline void init_IO_APIC_traps(vo
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for_each_irq_desc(irq, desc) {
-		cfg = desc->chip_data;
+		cfg = get_irq_desc_chip_data(desc);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2926,7 +2927,7 @@ int timer_through_8259 __initdata;
 static inline void __init check_timer(void)
 {
 	struct irq_desc *desc = irq_to_desc(0);
-	struct irq_cfg *cfg = desc->chip_data;
+	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 	int node = cpu_to_node(boot_cpu_id);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -3259,13 +3260,13 @@ unsigned int create_irq_nr(unsigned int 
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
 			continue;
 		}
-		cfg_new = desc_new->chip_data;
+		cfg_new = get_irq_desc_chip_data(desc_new);
 
 		if (cfg_new->vector != 0)
 			continue;
 
 		desc_new = move_irq_desc(desc_new, node);
-		cfg_new = desc_new->chip_data;
+		cfg_new = get_irq_desc_chip_data(desc_new);
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
@@ -3397,7 +3398,7 @@ static int set_msi_irq_affinity(unsigned
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 
 	get_cached_msi_msg_desc(desc, &msg);
 
@@ -3419,7 +3420,7 @@ static int
 ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = desc->chip_data;
+	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 	unsigned int dest;
 	struct irte irte;
 
@@ -3611,7 +3612,7 @@ static int dmar_msi_set_affinity(unsigne
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 
 	dmar_msi_read(irq, &msg);
 
@@ -3666,7 +3667,7 @@ static int hpet_msi_set_affinity(unsigne
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 
 	hpet_msi_read(irq, &msg);
 
@@ -3772,7 +3773,7 @@ static int set_ht_irq_affinity(unsigned 
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
-	cfg = desc->chip_data;
+	cfg = get_irq_desc_chip_data(desc);
 
 	target_ht_irq(irq, dest, cfg->vector);
 
@@ -3919,7 +3920,7 @@ static int __io_apic_set_pci_routing(str
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
 	if (irq >= legacy_pic->nr_legacy_irqs) {
-		cfg = desc->chip_data;
+		cfg = get_irq_desc_chip_data(desc);
 		if (add_pin_to_irq_node_nopanic(cfg, node, ioapic, pin)) {
 			printk(KERN_INFO "can not add pin %d for irq %d\n",
 				pin, irq);
Index: linux-2.6-tip/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6-tip/arch/x86/kernel/uv_irq.c
@@ -209,7 +209,7 @@ static void arch_disable_uv_irq(int mmr_
 static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = desc->chip_data;
+	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 	unsigned int dest;
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
Index: linux-2.6-tip/drivers/parisc/dino.c
===================================================================
--- linux-2.6-tip.orig/drivers/parisc/dino.c
+++ linux-2.6-tip/drivers/parisc/dino.c
@@ -298,8 +298,7 @@ static struct pci_port_ops dino_port_ops
 
 static void dino_disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct dino_device *dino_dev = desc->chip_data;
+	struct dino_device *dino_dev = get_irq_chip_data(irq);
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 
 	DBG(KERN_WARNING "%s(0x%p, %d)\n", __func__, dino_dev, irq);
@@ -311,8 +310,7 @@ static void dino_disable_irq(unsigned in
 
 static void dino_enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct dino_device *dino_dev = desc->chip_data;
+	struct dino_device *dino_dev = get_irq_chip_data(irq);
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 	u32 tmp;
 
Index: linux-2.6-tip/drivers/parisc/gsc.c
===================================================================
--- linux-2.6-tip.orig/drivers/parisc/gsc.c
+++ linux-2.6-tip/drivers/parisc/gsc.c
@@ -107,8 +107,7 @@ int gsc_find_local_irq(unsigned int irq,
 
 static void gsc_asic_disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct gsc_asic *irq_dev = desc->chip_data;
+	struct gsc_asic *irq_dev = get_irq_chip_data(irq);
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
@@ -123,8 +122,7 @@ static void gsc_asic_disable_irq(unsigne
 
 static void gsc_asic_enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct gsc_asic *irq_dev = desc->chip_data;
+	struct gsc_asic *irq_dev = get_irq_chip_data(irq);
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
@@ -160,14 +158,12 @@ static struct irq_chip gsc_asic_interrup
 int gsc_assign_irq(struct irq_chip *type, void *data)
 {
 	static int irq = GSC_IRQ_BASE;
-	struct irq_desc *desc;
 
 	if (irq > GSC_IRQ_MAX)
 		return NO_IRQ;
 
-	desc = irq_to_desc(irq);
-	desc->chip = type;
-	desc->chip_data = data;
+	set_irq_chip(irq, type);
+	set_irq_chip_data(irq, data);
 	return irq++;
 }
 
Index: linux-2.6-tip/drivers/parisc/iosapic.c
===================================================================
--- linux-2.6-tip.orig/drivers/parisc/iosapic.c
+++ linux-2.6-tip/drivers/parisc/iosapic.c
@@ -617,9 +617,7 @@ iosapic_set_irt_data( struct vector_info
 
 static struct vector_info *iosapic_get_vector(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	return desc->chip_data;
+	return get_irq_chip_data(irq);
 }
 
 static void iosapic_disable_irq(unsigned int irq)
Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -406,6 +406,11 @@ extern int set_irq_chip_data(unsigned in
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
+static inline void set_irq_desc_chip_data(struct irq_desc *desc, void *data)
+{
+	desc->chip_data = data;
+}
+
 #define get_irq_chip(irq)	(irq_to_desc(irq)->chip)
 #define get_irq_chip_data(irq)	(irq_to_desc(irq)->chip_data)
 #define get_irq_data(irq)	(irq_to_desc(irq)->handler_data)


