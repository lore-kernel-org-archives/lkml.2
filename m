Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab0I3XRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:18 -0400
Received: from www.tglx.de ([62.245.132.106]:52787 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0I3XRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:12 -0400
Message-Id: <20100930221741.130620472@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:48 -0000
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
Subject: [patch 27/47] x86: ioapic: Convert mask to new irq_chip function
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-ioapic-convert-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |   95 ++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 52 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -592,11 +592,9 @@ static void mask_ioapic(struct irq_cfg *
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void mask_ioapic_irq(unsigned int irq)
+static void mask_ioapic_irq(struct irq_data *data)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
-
-	mask_ioapic(cfg);
+	mask_ioapic(data->chip_data);
 }
 
 static void __unmask_ioapic(struct irq_cfg *cfg)
@@ -613,11 +611,9 @@ static void unmask_ioapic(struct irq_cfg
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_ioapic_irq(unsigned int irq)
+static void unmask_ioapic_irq(struct irq_data *data)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
-
-	unmask_ioapic(cfg);
+	unmask_ioapic(data->chip_data);
 }
 
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
@@ -2249,10 +2245,9 @@ static unsigned int startup_ioapic_irq(s
 	return was_pending;
 }
 
-static int ioapic_retrigger_irq(unsigned int irq)
+static int ioapic_retrigger_irq(struct irq_data *data)
 {
-
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_cfg *cfg = data->chip_data;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
@@ -2533,12 +2528,10 @@ void irq_force_complete_move(int irq)
 static inline void irq_complete_move(struct irq_cfg *cfg) { }
 #endif
 
-static void ack_apic_edge(unsigned int irq)
+static void ack_apic_edge(struct irq_data *data)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
-
-	irq_complete_move(cfg);
-	move_native_irq(irq);
+	irq_complete_move(data->chip_data);
+	move_native_irq(data->irq);
 	ack_APIC_irq();
 }
 
@@ -2586,11 +2579,11 @@ static void eoi_ioapic_irq(unsigned int 
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void ack_apic_level(unsigned int irq)
+static void ack_apic_level(struct irq_data *data)
 {
+	struct irq_cfg *cfg = data->chip_data;
+	int i, do_unmask_irq = 0, irq = data->irq;
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
-	int i, do_unmask_irq = 0;
 	unsigned long v;
 
 	irq_complete_move(cfg);
@@ -2691,46 +2684,44 @@ static void ack_apic_level(unsigned int 
 }
 
 #ifdef CONFIG_INTR_REMAP
-static void ir_ack_apic_edge(unsigned int irq)
+static void ir_ack_apic_edge(struct irq_data *data)
 {
 	ack_APIC_irq();
 }
 
-static void ir_ack_apic_level(unsigned int irq)
+static void ir_ack_apic_level(struct irq_data *data)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
-
 	ack_APIC_irq();
-	eoi_ioapic_irq(irq, cfg);
+	eoi_ioapic_irq(data->irq, data->chip_data);
 }
 #endif /* CONFIG_INTR_REMAP */
 
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name		= "IO-APIC",
 	.irq_startup	= startup_ioapic_irq,
-	.mask		= mask_ioapic_irq,
-	.unmask		= unmask_ioapic_irq,
-	.ack		= ack_apic_edge,
-	.eoi		= ack_apic_level,
+	.irq_mask	= mask_ioapic_irq,
+	.irq_unmask	= unmask_ioapic_irq,
+	.irq_ack	= ack_apic_edge,
+	.irq_eoi	= ack_apic_level,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_ioapic_affinity_irq,
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger	= ioapic_retrigger_irq,
 };
 
 static struct irq_chip ir_ioapic_chip __read_mostly = {
 	.name		= "IR-IO-APIC",
 	.irq_startup	= startup_ioapic_irq,
-	.mask		= mask_ioapic_irq,
-	.unmask		= unmask_ioapic_irq,
+	.irq_mask	= mask_ioapic_irq,
+	.irq_unmask	= unmask_ioapic_irq,
 #ifdef CONFIG_INTR_REMAP
-	.ack		= ir_ack_apic_edge,
-	.eoi		= ir_ack_apic_level,
+	.irq_ack	= ir_ack_apic_edge,
+	.irq_eoi	= ir_ack_apic_level,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_ir_ioapic_affinity_irq,
 #endif
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger	= ioapic_retrigger_irq,
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -2771,7 +2762,7 @@ static inline void init_IO_APIC_traps(vo
  * The local APIC irq-chip implementation:
  */
 
-static void mask_lapic_irq(unsigned int irq)
+static void mask_lapic_irq(struct irq_data *data)
 {
 	unsigned long v;
 
@@ -2779,7 +2770,7 @@ static void mask_lapic_irq(unsigned int 
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+static void unmask_lapic_irq(struct irq_data *data)
 {
 	unsigned long v;
 
@@ -2787,16 +2778,16 @@ static void unmask_lapic_irq(unsigned in
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq(unsigned int irq)
+static void ack_lapic_irq(struct irq_data *data)
 {
 	ack_APIC_irq();
 }
 
 static struct irq_chip lapic_chip __read_mostly = {
 	.name		= "local-APIC",
-	.mask		= mask_lapic_irq,
-	.unmask		= unmask_lapic_irq,
-	.ack		= ack_lapic_irq,
+	.irq_mask	= mask_lapic_irq,
+	.irq_unmask	= unmask_lapic_irq,
+	.irq_ack	= ack_lapic_irq,
 };
 
 static void lapic_register_intr(int irq, struct irq_desc *desc)
@@ -3438,11 +3429,11 @@ static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
-	.ack		= ack_apic_edge,
+	.irq_ack	= ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_msi_irq_affinity,
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger	= ioapic_retrigger_irq,
 };
 
 static struct irq_chip msi_ir_chip = {
@@ -3450,12 +3441,12 @@ static struct irq_chip msi_ir_chip = {
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 #ifdef CONFIG_INTR_REMAP
-	.ack		= ir_ack_apic_edge,
+	.irq_ack	= ir_ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= ir_set_msi_irq_affinity,
 #endif
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger	= ioapic_retrigger_irq,
 };
 
 /*
@@ -3610,11 +3601,11 @@ static struct irq_chip dmar_msi_type = {
 	.name = "DMAR_MSI",
 	.unmask = dmar_msi_unmask,
 	.mask = dmar_msi_mask,
-	.ack = ack_apic_edge,
+	.irq_ack = ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity = dmar_msi_set_affinity,
 #endif
-	.retrigger = ioapic_retrigger_irq,
+	.irq_retrigger = ioapic_retrigger_irq,
 };
 
 int arch_setup_dmar_msi(unsigned int irq)
@@ -3666,23 +3657,23 @@ static struct irq_chip ir_hpet_msi_type 
 	.unmask = hpet_msi_unmask,
 	.mask = hpet_msi_mask,
 #ifdef CONFIG_INTR_REMAP
-	.ack = ir_ack_apic_edge,
+	.irq_ack = ir_ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity = ir_set_msi_irq_affinity,
 #endif
 #endif
-	.retrigger = ioapic_retrigger_irq,
+	.irq_retrigger = ioapic_retrigger_irq,
 };
 
 static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.unmask = hpet_msi_unmask,
 	.mask = hpet_msi_mask,
-	.ack = ack_apic_edge,
+	.irq_ack = ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity = hpet_msi_set_affinity,
 #endif
-	.retrigger = ioapic_retrigger_irq,
+	.irq_retrigger = ioapic_retrigger_irq,
 };
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3764,11 +3755,11 @@ static struct irq_chip ht_irq_chip = {
 	.name		= "PCI-HT",
 	.mask		= mask_ht_irq,
 	.unmask		= unmask_ht_irq,
-	.ack		= ack_apic_edge,
+	.irq_ack	= ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_ht_irq_affinity,
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger	= ioapic_retrigger_irq,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)


