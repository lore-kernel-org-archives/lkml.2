Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0I3XRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:41 -0400
Received: from www.tglx.de ([62.245.132.106]:52898 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab0I3XRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:39 -0400
Message-Id: <20100930221741.621024765@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 32/47] x86: ioapic: Clean up the direct access to irq_desc
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-ioapic-fix-irq-desc-hackery.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of it is useless pseudo optimization.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |   81 ++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 52 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -150,10 +150,7 @@ static struct irq_cfg irq_cfgx[NR_IRQS];
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
-	int count;
-	int node;
-	int i;
+	int count, node, i;
 
 	if (!legacy_pic->nr_legacy_irqs) {
 		nr_irqs_gsi = 0;
@@ -162,11 +159,10 @@ int __init arch_early_irq_init(void)
 
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
-	node= cpu_to_node(boot_cpu_id);
+	node = cpu_to_node(boot_cpu_id);
 
 	for (i = 0; i < count; i++) {
-		desc = irq_to_desc(i);
-		set_irq_desc_chip_data(desc, &cfg[i]);
+		set_irq_chip_data(i, &cfg[i]);
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
 		/*
@@ -185,14 +181,7 @@ int __init arch_early_irq_init(void)
 #ifdef CONFIG_SPARSE_IRQ
 struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	struct irq_cfg *cfg = NULL;
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-	if (desc)
-		cfg = get_irq_desc_chip_data(desc);
-
-	return cfg;
+	return get_irq_chip_data(irq);
 }
 
 static struct irq_cfg *get_one_free_irq_cfg(int node)
@@ -1316,17 +1305,17 @@ static inline int IO_APIC_irq_trigger(in
 }
 #endif
 
-static void ioapic_register_intr(int irq, struct irq_desc *desc, unsigned long trigger)
+static void ioapic_register_intr(unsigned int irq, unsigned long trigger)
 {
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL)
-		desc->status |= IRQ_LEVEL;
+		irq_set_status_flags(irq, IRQ_LEVEL);
 	else
-		desc->status &= ~IRQ_LEVEL;
+		irq_clear_status_flags(irq, IRQ_LEVEL);
 
 	if (irq_remapped(irq)) {
-		desc->status |= IRQ_MOVE_PCNTXT;
+		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 		if (trigger)
 			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
 						      handle_fasteoi_irq,
@@ -1420,18 +1409,14 @@ int setup_ioapic_entry(int apic_id, int 
 	return 0;
 }
 
-static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq_desc *desc,
-			      int trigger, int polarity)
+static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
+			     struct irq_cfg *cfg, int trigger, int polarity)
 {
-	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
 	unsigned int dest;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
-
-	cfg = get_irq_desc_chip_data(desc);
-
 	/*
 	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
 	 * controllers like 8259. Now that IO-APIC can handle this irq, update
@@ -1460,7 +1445,7 @@ static void setup_IO_APIC_irq(int apic_i
 		return;
 	}
 
-	ioapic_register_intr(irq, desc, trigger);
+	ioapic_register_intr(irq, trigger);
 	if (irq < legacy_pic->nr_legacy_irqs)
 		legacy_pic->mask(irq);
 
@@ -1525,8 +1510,8 @@ static void __init setup_IO_APIC_irqs(vo
 		 * don't mark it in pin_programmed, so later acpi could
 		 * set it correctly when irq < 16
 		 */
-		setup_IO_APIC_irq(apic_id, pin, irq, desc,
-				irq_trigger(idx), irq_polarity(idx));
+		setup_ioapic_irq(apic_id, pin, irq, cfg, irq_trigger(idx),
+				  irq_polarity(idx));
 	}
 
 	if (notcon)
@@ -1580,7 +1565,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 	}
 	set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
 
-	setup_IO_APIC_irq(apic_id, pin, irq, desc,
+	setup_ioapic_irq(apic_id, pin, irq, cfg,
 			irq_trigger(idx), irq_polarity(idx));
 }
 
@@ -2790,9 +2775,9 @@ static struct irq_chip lapic_chip __read
 	.irq_ack	= ack_lapic_irq,
 };
 
-static void lapic_register_intr(int irq, struct irq_desc *desc)
+static void lapic_register_intr(int irq)
 {
-	desc->status &= ~IRQ_LEVEL;
+	irq_clear_status_flags(irq, IRQ_LEVEL);
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
 }
@@ -2895,8 +2880,7 @@ int timer_through_8259 __initdata;
  */
 static inline void __init check_timer(void)
 {
-	struct irq_desc *desc = irq_to_desc(0);
-	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
+	struct irq_cfg *cfg = get_irq_chip_data(0);
 	int node = cpu_to_node(boot_cpu_id);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -2966,7 +2950,7 @@ static inline void __init check_timer(vo
 			add_pin_to_irq_node(cfg, node, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		} else {
-			/* for edge trigger, setup_IO_APIC_irq already
+			/* for edge trigger, setup_ioapic_irq already
 			 * leave it unmasked.
 			 * so only need to unmask if it is level-trigger
 			 * do we really have level trigger timer?
@@ -3034,7 +3018,7 @@ static inline void __init check_timer(vo
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
-	lapic_register_intr(0, desc);
+	lapic_register_intr(0);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	legacy_pic->unmask(0);
 
@@ -3478,8 +3462,8 @@ static int msi_alloc_irte(struct pci_dev
 
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
-	int ret;
 	struct msi_msg msg;
+	int ret;
 
 	ret = msi_compose_msg(dev, irq, &msg, -1);
 	if (ret < 0)
@@ -3489,11 +3473,7 @@ static int setup_msi_irq(struct pci_dev 
 	write_msi_msg(irq, &msg);
 
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_to_desc(irq);
-		/*
-		 * irq migration in process context
-		 */
-		desc->status |= IRQ_MOVE_PCNTXT;
+		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
 	} else
 		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
@@ -3505,13 +3485,10 @@ static int setup_msi_irq(struct pci_dev 
 
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	unsigned int irq;
-	int ret, sub_handle;
+	int node, ret, sub_handle, index = 0;
+	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
-	unsigned int irq_want;
 	struct intel_iommu *iommu = NULL;
-	int index = 0;
-	int node;
 
 	/* x86 doesn't support multiple MSI yet */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
@@ -3697,7 +3674,7 @@ int arch_setup_hpet_msi(unsigned int irq
 		return ret;
 
 	hpet_msi_write(get_irq_data(irq), &msg);
-	irq_set_status_flags(irq,IRQ_MOVE_PCNTXT);
+	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 	if (irq_remapped(irq))
 		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
 					      handle_edge_irq, "edge");
@@ -3883,11 +3860,12 @@ static int __io_apic_set_pci_routing(str
 	trigger = irq_attr->trigger;
 	polarity = irq_attr->polarity;
 
+	cfg = get_irq_desc_chip_data(desc);
+
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
 	if (irq >= legacy_pic->nr_legacy_irqs) {
-		cfg = get_irq_desc_chip_data(desc);
 		if (add_pin_to_irq_node_nopanic(cfg, node, ioapic, pin)) {
 			printk(KERN_INFO "can not add pin %d for irq %d\n",
 				pin, irq);
@@ -3895,7 +3873,7 @@ static int __io_apic_set_pci_routing(str
 		}
 	}
 
-	setup_IO_APIC_irq(ioapic, pin, irq, desc, trigger, polarity);
+	setup_ioapic_irq(ioapic, pin, irq, cfg, trigger, polarity);
 
 	return 0;
 }
@@ -4279,13 +4257,12 @@ void __init mp_register_ioapic(int id, u
 void __init pre_init_apic_IRQ0(void)
 {
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 
 	printk(KERN_INFO "Early APIC setup for system timer0\n");
 #ifndef CONFIG_SMP
 	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
 #endif
-	desc = irq_to_desc_alloc_node(0, 0);
+	irq_to_desc_alloc_node(0, 0);
 
 	setup_local_APIC();
 
@@ -4293,5 +4270,5 @@ void __init pre_init_apic_IRQ0(void)
 	add_pin_to_irq_node(cfg, 0, 0, 0);
 	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
 
-	setup_IO_APIC_irq(0, 0, 0, desc, 0, 0);
+	setup_ioapic_irq(0, 0, 0, cfg, 0, 0);
 }


