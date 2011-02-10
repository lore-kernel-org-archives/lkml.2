Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab1BJXlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:41:13 -0500
Received: from www.tglx.de ([62.245.132.106]:44572 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab1BJXim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:42 -0500
Message-Id: <20110210223301.050789519@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 70/75] x86: Fixup deprecation warnings
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=x86-fixup-depr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the deprecated get/set_irq calls.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |   36 ++++++++++++++++++------------------
 arch/x86/kernel/hpet.c         |    2 +-
 2 files changed, 19 insertions(+), 19 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -181,7 +181,7 @@ int __init arch_early_irq_init(void)
 	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
 
 	for (i = 0; i < count; i++) {
-		set_irq_chip_data(i, &cfg[i]);
+		irq_set_chip_data(i, &cfg[i]);
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
 		/*
@@ -200,7 +200,7 @@ int __init arch_early_irq_init(void)
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	return get_irq_chip_data(irq);
+	return irq_get_chip_data(irq);
 }
 
 static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
@@ -256,14 +256,14 @@ static struct irq_cfg *alloc_irq_and_cfg
 	if (res < 0) {
 		if (res != -EEXIST)
 			return NULL;
-		cfg = get_irq_chip_data(at);
+		cfg = irq_get_chip_data(at);
 		if (cfg)
 			return cfg;
 	}
 
 	cfg = alloc_irq_cfg(at, node);
 	if (cfg)
-		set_irq_chip_data(at, cfg);
+		irq_set_chip_data(at, cfg);
 	else
 		irq_free_desc(at);
 	return cfg;
@@ -1189,7 +1189,7 @@ void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_active_irq(irq) {
-		cfg = get_irq_chip_data(irq);
+		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
 		/*
@@ -1257,7 +1257,7 @@ static void ioapic_register_intr(unsigne
 	else
 		irq_clear_status_flags(irq, IRQ_LEVEL);
 
-	if (irq_remapped(get_irq_chip_data(irq))) {
+	if (irq_remapped(irq_get_chip_data(irq))) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 		if (trigger)
 			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
@@ -1625,7 +1625,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
 
-		cfg = get_irq_chip_data(irq);
+		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
 		entry = cfg->irq_2_pin;
@@ -2391,7 +2391,7 @@ static void irq_complete_move(struct irq
 
 void irq_force_complete_move(int irq)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 
 	if (!cfg)
 		return;
@@ -2614,7 +2614,7 @@ static inline void init_IO_APIC_traps(vo
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for_each_active_irq(irq) {
-		cfg = get_irq_chip_data(irq);
+		cfg = irq_get_chip_data(irq);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2625,7 +2625,7 @@ static inline void init_IO_APIC_traps(vo
 				legacy_pic->make_irq(irq);
 			else
 				/* Strange. Oh, well.. */
-				set_irq_chip(irq, &no_irq_chip);
+				irq_set_chip(irq, &no_irq_chip);
 		}
 	}
 }
@@ -2749,7 +2749,7 @@ int timer_through_8259 __initdata;
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(0);
+	struct irq_cfg *cfg = irq_get_chip_data(0);
 	int node = cpu_to_node(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -3060,7 +3060,7 @@ unsigned int create_irq_nr(unsigned int 
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	if (ret) {
-		set_irq_chip_data(irq, cfg);
+		irq_set_chip_data(irq, cfg);
 		irq_clear_status_flags(irq, IRQ_NOREQUEST);
 	} else {
 		free_irq_at(irq, cfg);
@@ -3085,7 +3085,7 @@ int create_irq(void)
 
 void destroy_irq(unsigned int irq)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	unsigned long flags;
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
@@ -3119,7 +3119,7 @@ static int msi_compose_msg(struct pci_de
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
-	if (irq_remapped(get_irq_chip_data(irq))) {
+	if (irq_remapped(irq_get_chip_data(irq))) {
 		struct irte irte;
 		int ir_index;
 		u16 sub_handle;
@@ -3298,10 +3298,10 @@ static int setup_msi_irq(struct pci_dev 
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, msidesc);
+	irq_set_msi_desc(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
-	if (irq_remapped(get_irq_chip_data(irq))) {
+	if (irq_remapped(irq_get_chip_data(irq))) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
 	} else
@@ -3501,9 +3501,9 @@ int arch_setup_hpet_msi(unsigned int irq
 	if (ret < 0)
 		return ret;
 
-	hpet_msi_write(get_irq_data(irq), &msg);
+	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	if (irq_remapped(get_irq_chip_data(irq)))
+	if (irq_remapped(irq_get_chip_data(irq)))
 		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
 					      handle_edge_irq, "edge");
 	else
Index: linux-2.6-tip/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/hpet.c
+++ linux-2.6-tip/arch/x86/kernel/hpet.c
@@ -503,7 +503,7 @@ static int hpet_assign_irq(struct hpet_d
 	if (!irq)
 		return -EINVAL;
 
-	set_irq_data(irq, dev);
+	irq_set_handler_data(irq, dev);
 
 	if (hpet_setup_msi_irq(irq))
 		return -EINVAL;


