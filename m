Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0I3XRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:15 -0400
Received: from www.tglx.de ([62.245.132.106]:52785 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab0I3XRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:11 -0400
Message-Id: <20100930221740.937343375@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:35 -0000
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
Subject: [patch 25/47] x86: Cleanup io_apic
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-cleanup-ioapic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanitize functions. Remove irq_desc pointer magic.
Preparatory patch for further cleanups.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |  109 +++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 67 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -572,11 +572,6 @@ static void __unmask_and_level_IO_APIC_i
 			     IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
 }
 
-static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
-{
-	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
-}
-
 static void io_apic_sync(struct irq_pin_list *entry)
 {
 	/*
@@ -588,44 +583,41 @@ static void io_apic_sync(struct irq_pin_
 	readl(&io_apic->data);
 }
 
-static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
+static void mask_ioapic(struct irq_cfg *cfg)
 {
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
+static void mask_ioapic_irq(unsigned int irq)
 {
-	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
-	unsigned long flags;
+	struct irq_cfg *cfg = get_irq_chip_data(irq);
 
-	BUG_ON(!cfg);
+	mask_ioapic(cfg);
+}
 
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	__mask_IO_APIC_irq(cfg);
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+static void __unmask_ioapic(struct irq_cfg *cfg)
+{
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
-static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
+static void unmask_ioapic(struct irq_cfg *cfg)
 {
-	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	__unmask_IO_APIC_irq(cfg);
+	__unmask_ioapic(cfg);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void mask_IO_APIC_irq(unsigned int irq)
+static void unmask_ioapic_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = get_irq_chip_data(irq);
 
-	mask_IO_APIC_irq_desc(desc);
-}
-static void unmask_IO_APIC_irq(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	unmask_IO_APIC_irq_desc(desc);
+	unmask_ioapic(cfg);
 }
 
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
@@ -2253,7 +2245,7 @@ static unsigned int startup_ioapic_irq(u
 			was_pending = 1;
 	}
 	cfg = irq_cfg(irq);
-	__unmask_IO_APIC_irq(cfg);
+	__unmask_ioapic(cfg);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
@@ -2512,10 +2504,8 @@ unlock:
 	irq_exit();
 }
 
-static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
+static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
 {
-	struct irq_desc *desc = *descp;
-	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
 	unsigned me;
 
 	if (likely(!cfg->move_in_progress))
@@ -2527,30 +2517,29 @@ static void __irq_complete_move(struct i
 		send_cleanup_vector(cfg);
 }
 
-static void irq_complete_move(struct irq_desc **descp)
+static void irq_complete_move(struct irq_cfg *cfg)
 {
-	__irq_complete_move(descp, ~get_irq_regs()->orig_ax);
+	__irq_complete_move(cfg, ~get_irq_regs()->orig_ax);
 }
 
 void irq_force_complete_move(int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
+	struct irq_cfg *cfg = get_irq_chip_data(irq);
 
 	if (!cfg)
 		return;
 
-	__irq_complete_move(&desc, cfg->vector);
+	__irq_complete_move(cfg, cfg->vector);
 }
 #else
-static inline void irq_complete_move(struct irq_desc **descp) {}
+static inline void irq_complete_move(struct irq_cfg *cfg) { }
 #endif
 
 static void ack_apic_edge(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = get_irq_chip_data(irq);
 
-	irq_complete_move(&desc);
+	irq_complete_move(cfg);
 	move_native_irq(irq);
 	ack_APIC_irq();
 }
@@ -2573,10 +2562,12 @@ atomic_t irq_mis_count;
  * Otherwise, we simulate the EOI message manually by changing the trigger
  * mode to edge and then back to level, with RTE being masked during this.
 */
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
+	unsigned long flags;
 
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		if (mp_ioapics[entry->apic].apicver >= 0x20) {
 			/*
@@ -2594,36 +2585,22 @@ static void __eoi_ioapic_irq(unsigned in
 			__unmask_and_level_IO_APIC_irq(entry);
 		}
 	}
-}
-
-static void eoi_ioapic_irq(struct irq_desc *desc)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int irq;
-
-	irq = desc->irq;
-	cfg = get_irq_desc_chip_data(desc);
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	__eoi_ioapic_irq(irq, cfg);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void ack_apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
+	int i, do_unmask_irq = 0;
 	unsigned long v;
-	int i;
-	struct irq_cfg *cfg;
-	int do_unmask_irq = 0;
 
-	irq_complete_move(&desc);
+	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
-		mask_IO_APIC_irq_desc(desc);
+		mask_ioapic(cfg);
 	}
 #endif
 
@@ -2659,7 +2636,6 @@ static void ack_apic_level(unsigned int 
 	 * we use the above logic (mask+edge followed by unmask+level) from
 	 * Manfred Spraul to clear the remote IRR.
 	 */
-	cfg = get_irq_desc_chip_data(desc);
 	i = cfg->vector;
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
 
@@ -2679,7 +2655,7 @@ static void ack_apic_level(unsigned int 
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 
-		eoi_ioapic_irq(desc);
+		eoi_ioapic_irq(irq, cfg);
 	}
 
 	/* Now we can move and renable the irq */
@@ -2710,10 +2686,9 @@ static void ack_apic_level(unsigned int 
 		 * accurate and is causing problems then it is a hardware bug
 		 * and you can go talk to the chipset vendor about it.
 		 */
-		cfg = get_irq_desc_chip_data(desc);
 		if (!io_apic_level_ack_pending(cfg))
 			move_masked_irq(irq);
-		unmask_IO_APIC_irq_desc(desc);
+		unmask_ioapic(cfg);
 	}
 }
 
@@ -2725,18 +2700,18 @@ static void ir_ack_apic_edge(unsigned in
 
 static void ir_ack_apic_level(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = get_irq_chip_data(irq);
 
 	ack_APIC_irq();
-	eoi_ioapic_irq(desc);
+	eoi_ioapic_irq(irq, cfg);
 }
 #endif /* CONFIG_INTR_REMAP */
 
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name		= "IO-APIC",
 	.startup	= startup_ioapic_irq,
-	.mask		= mask_IO_APIC_irq,
-	.unmask		= unmask_IO_APIC_irq,
+	.mask		= mask_ioapic_irq,
+	.unmask		= unmask_ioapic_irq,
 	.ack		= ack_apic_edge,
 	.eoi		= ack_apic_level,
 #ifdef CONFIG_SMP
@@ -2748,8 +2723,8 @@ static struct irq_chip ioapic_chip __rea
 static struct irq_chip ir_ioapic_chip __read_mostly = {
 	.name		= "IR-IO-APIC",
 	.startup	= startup_ioapic_irq,
-	.mask		= mask_IO_APIC_irq,
-	.unmask		= unmask_IO_APIC_irq,
+	.mask		= mask_ioapic_irq,
+	.unmask		= unmask_ioapic_irq,
 #ifdef CONFIG_INTR_REMAP
 	.ack		= ir_ack_apic_edge,
 	.eoi		= ir_ack_apic_level,
@@ -3010,7 +2985,7 @@ static inline void __init check_timer(vo
 			int idx;
 			idx = find_irq_entry(apic1, pin1, mp_INT);
 			if (idx != -1 && irq_trigger(idx))
-				unmask_IO_APIC_irq_desc(desc);
+				unmask_ioapic(cfg);
 		}
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {


