Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1BCArX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:47:23 -0500
Received: from www.tglx.de ([62.245.132.106]:37632 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1BCArU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:20 -0500
Message-Id: <20110203004210.337656623@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:46:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 4/8] mips: Remove stale irq_chip.end
References: <20110203003745.371989282@linutronix.de>
Content-Disposition: inline; filename=mips-remove-stale-irq_chip-end.pach
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the removal of __do_IRQ().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/dec/ioasic-irq.c            |    8 --------
 arch/mips/kernel/irq-msc01.c          |   11 -----------
 arch/mips/pnx833x/common/interrupts.c |   11 -----------
 arch/mips/sgi-ip32/ip32-irq.c         |   22 ----------------------
 arch/mips/sibyte/bcm1480/irq.c        |   12 ------------
 arch/mips/sibyte/sb1250/irq.c         |   12 ------------
 arch/mips/sni/a20r.c                  |    9 ---------
 arch/mips/sni/pcimt.c                 |    7 -------
 arch/mips/sni/pcit.c                  |    7 -------
 arch/mips/sni/rm200.c                 |    7 -------
 10 files changed, 106 deletions(-)

Index: linux-2.6-tip/arch/mips/dec/ioasic-irq.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/dec/ioasic-irq.c
+++ linux-2.6-tip/arch/mips/dec/ioasic-irq.c
@@ -74,20 +74,12 @@ static struct irq_chip ioasic_irq_type =
 
 #define ack_ioasic_dma_irq ack_ioasic_irq
 
-static inline void end_ioasic_dma_irq(unsigned int irq)
-{
-	clear_ioasic_irq(irq);
-	fast_iob();
-	end_ioasic_irq(irq);
-}
-
 static struct irq_chip ioasic_dma_irq_type = {
 	.name = "IO-ASIC-DMA",
 	.ack = ack_ioasic_dma_irq,
 	.mask = mask_ioasic_dma_irq,
 	.mask_ack = ack_ioasic_dma_irq,
 	.unmask = unmask_ioasic_dma_irq,
-	.end = end_ioasic_dma_irq,
 };
 
 
Index: linux-2.6-tip/arch/mips/kernel/irq-msc01.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/kernel/irq-msc01.c
+++ linux-2.6-tip/arch/mips/kernel/irq-msc01.c
@@ -75,15 +75,6 @@ static void edge_mask_and_ack_msc_irq(un
 }
 
 /*
- * End IRQ processing
- */
-static void end_msc_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		unmask_msc_irq(irq);
-}
-
-/*
  * Interrupt handler for interrupts coming from SOC-it.
  */
 void ll_msc_irq(void)
@@ -112,7 +103,6 @@ static struct irq_chip msc_levelirq_type
 	.mask_ack = level_mask_and_ack_msc_irq,
 	.unmask = unmask_msc_irq,
 	.eoi = unmask_msc_irq,
-	.end = end_msc_irq,
 };
 
 static struct irq_chip msc_edgeirq_type = {
@@ -122,7 +112,6 @@ static struct irq_chip msc_edgeirq_type 
 	.mask_ack = edge_mask_and_ack_msc_irq,
 	.unmask = unmask_msc_irq,
 	.eoi = unmask_msc_irq,
-	.end = end_msc_irq,
 };
 
 
Index: linux-2.6-tip/arch/mips/pnx833x/common/interrupts.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/pnx833x/common/interrupts.c
+++ linux-2.6-tip/arch/mips/pnx833x/common/interrupts.c
@@ -254,15 +254,6 @@ static void pnx833x_ack_gpio_irq(unsigne
 {
 }
 
-static void pnx833x_end_gpio_irq(unsigned int irq)
-{
-	int pin = irq - PNX833X_GPIO_IRQ_BASE;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&pnx833x_gpio_pnx833x_irq_lock, flags);
-	pnx833x_gpio_clear_irq(pin);
-	raw_spin_unlock_irqrestore(&pnx833x_gpio_pnx833x_irq_lock, flags);
-}
-
 static int pnx833x_set_type_gpio_irq(unsigned int irq, unsigned int flow_type)
 {
 	int pin = irq - PNX833X_GPIO_IRQ_BASE;
@@ -301,7 +292,6 @@ static struct irq_chip pnx833x_pic_irq_t
 	.enable = pnx833x_enable_pic_irq,
 	.disable = pnx833x_disable_pic_irq,
 	.ack = pnx833x_ack_pic_irq,
-	.end = pnx833x_end_pic_irq
 };
 
 static struct irq_chip pnx833x_gpio_irq_type = {
@@ -311,7 +301,6 @@ static struct irq_chip pnx833x_gpio_irq_
 	.enable = pnx833x_enable_gpio_irq,
 	.disable = pnx833x_disable_gpio_irq,
 	.ack = pnx833x_ack_gpio_irq,
-	.end = pnx833x_end_gpio_irq,
 	.set_type = pnx833x_set_type_gpio_irq
 };
 
Index: linux-2.6-tip/arch/mips/sgi-ip32/ip32-irq.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/sgi-ip32/ip32-irq.c
+++ linux-2.6-tip/arch/mips/sgi-ip32/ip32-irq.c
@@ -222,19 +222,12 @@ static void disable_macepci_irq(unsigned
 	flush_mace_bus();
 }
 
-static void end_macepci_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_macepci_irq(irq);
-}
-
 static struct irq_chip ip32_macepci_interrupt = {
 	.name = "IP32 MACE PCI",
 	.ack = disable_macepci_irq,
 	.mask = disable_macepci_irq,
 	.mask_ack = disable_macepci_irq,
 	.unmask = enable_macepci_irq,
-	.end = end_macepci_irq,
 };
 
 /* This is used for MACE ISA interrupts.  That means bits 4-6 in the
@@ -330,19 +323,12 @@ static void mask_and_ack_maceisa_irq(uns
 	disable_maceisa_irq(irq);
 }
 
-static void end_maceisa_irq(unsigned irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_maceisa_irq(irq);
-}
-
 static struct irq_chip ip32_maceisa_level_interrupt = {
 	.name		= "IP32 MACE ISA",
 	.ack		= disable_maceisa_irq,
 	.mask		= disable_maceisa_irq,
 	.mask_ack	= disable_maceisa_irq,
 	.unmask		= enable_maceisa_irq,
-	.end		= end_maceisa_irq,
 };
 
 static struct irq_chip ip32_maceisa_edge_interrupt = {
@@ -351,7 +337,6 @@ static struct irq_chip ip32_maceisa_edge
 	.mask		= disable_maceisa_irq,
 	.mask_ack	= mask_and_ack_maceisa_irq,
 	.unmask		= enable_maceisa_irq,
-	.end		= end_maceisa_irq,
 };
 
 /* This is used for regular non-ISA, non-PCI MACE interrupts.  That means
@@ -375,19 +360,12 @@ static void disable_mace_irq(unsigned in
 	flush_crime_bus();
 }
 
-static void end_mace_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_mace_irq(irq);
-}
-
 static struct irq_chip ip32_mace_interrupt = {
 	.name = "IP32 MACE",
 	.ack = disable_mace_irq,
 	.mask = disable_mace_irq,
 	.mask_ack = disable_mace_irq,
 	.unmask = enable_mace_irq,
-	.end = end_mace_irq,
 };
 
 static void ip32_unknown_interrupt(void)
Index: linux-2.6-tip/arch/mips/sibyte/bcm1480/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/sibyte/bcm1480/irq.c
+++ linux-2.6-tip/arch/mips/sibyte/bcm1480/irq.c
@@ -44,8 +44,6 @@
  * for interrupt lines
  */
 
-
-static void end_bcm1480_irq(unsigned int irq);
 static void enable_bcm1480_irq(unsigned int irq);
 static void disable_bcm1480_irq(unsigned int irq);
 static void ack_bcm1480_irq(unsigned int irq);
@@ -63,7 +61,6 @@ static struct irq_chip bcm1480_irq_type 
 	.mask = disable_bcm1480_irq,
 	.mask_ack = ack_bcm1480_irq,
 	.unmask = enable_bcm1480_irq,
-	.end = end_bcm1480_irq,
 #ifdef CONFIG_SMP
 	.set_affinity = bcm1480_set_affinity
 #endif
@@ -217,15 +214,6 @@ static void ack_bcm1480_irq(unsigned int
 	bcm1480_mask_irq(bcm1480_irq_owner[irq], irq);
 }
 
-
-static void end_bcm1480_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
-		bcm1480_unmask_irq(bcm1480_irq_owner[irq], irq);
-	}
-}
-
-
 void __init init_bcm1480_irqs(void)
 {
 	int i;
Index: linux-2.6-tip/arch/mips/sibyte/sb1250/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/sibyte/sb1250/irq.c
+++ linux-2.6-tip/arch/mips/sibyte/sb1250/irq.c
@@ -43,8 +43,6 @@
  * for interrupt lines
  */
 
-
-static void end_sb1250_irq(unsigned int irq);
 static void enable_sb1250_irq(unsigned int irq);
 static void disable_sb1250_irq(unsigned int irq);
 static void ack_sb1250_irq(unsigned int irq);
@@ -62,7 +60,6 @@ static struct irq_chip sb1250_irq_type =
 	.mask = disable_sb1250_irq,
 	.mask_ack = ack_sb1250_irq,
 	.unmask = enable_sb1250_irq,
-	.end = end_sb1250_irq,
 #ifdef CONFIG_SMP
 	.set_affinity = sb1250_set_affinity
 #endif
@@ -199,15 +196,6 @@ static void ack_sb1250_irq(unsigned int 
 	sb1250_mask_irq(sb1250_irq_owner[irq], irq);
 }
 
-
-static void end_sb1250_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
-		sb1250_unmask_irq(sb1250_irq_owner[irq], irq);
-	}
-}
-
-
 void __init init_sb1250_irqs(void)
 {
 	int i;
Index: linux-2.6-tip/arch/mips/sni/a20r.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/sni/a20r.c
+++ linux-2.6-tip/arch/mips/sni/a20r.c
@@ -180,21 +180,12 @@ static inline void mask_a20r_irq(unsigne
 	irq_disable_hazard();
 }
 
-static void end_a20r_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
-		a20r_ack_hwint();
-		unmask_a20r_irq(irq);
-	}
-}
-
 static struct irq_chip a20r_irq_type = {
 	.name		= "A20R",
 	.ack		= mask_a20r_irq,
 	.mask		= mask_a20r_irq,
 	.mask_ack	= mask_a20r_irq,
 	.unmask		= unmask_a20r_irq,
-	.end		= end_a20r_irq,
 };
 
 /*
Index: linux-2.6-tip/arch/mips/sni/pcimt.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/sni/pcimt.c
+++ linux-2.6-tip/arch/mips/sni/pcimt.c
@@ -208,19 +208,12 @@ void disable_pcimt_irq(unsigned int irq)
 	*(volatile u8 *) PCIMT_IRQSEL &= mask;
 }
 
-static void end_pcimt_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_pcimt_irq(irq);
-}
-
 static struct irq_chip pcimt_irq_type = {
 	.name = "PCIMT",
 	.ack = disable_pcimt_irq,
 	.mask = disable_pcimt_irq,
 	.mask_ack = disable_pcimt_irq,
 	.unmask = enable_pcimt_irq,
-	.end = end_pcimt_irq,
 };
 
 /*
Index: linux-2.6-tip/arch/mips/sni/pcit.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/sni/pcit.c
+++ linux-2.6-tip/arch/mips/sni/pcit.c
@@ -170,19 +170,12 @@ void disable_pcit_irq(unsigned int irq)
 	*(volatile u32 *)SNI_PCIT_INT_REG &= ~mask;
 }
 
-void end_pcit_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_pcit_irq(irq);
-}
-
 static struct irq_chip pcit_irq_type = {
 	.name = "PCIT",
 	.ack = disable_pcit_irq,
 	.mask = disable_pcit_irq,
 	.mask_ack = disable_pcit_irq,
 	.unmask = enable_pcit_irq,
-	.end = end_pcit_irq,
 };
 
 static void pcit_hwint1(void)
Index: linux-2.6-tip/arch/mips/sni/rm200.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/sni/rm200.c
+++ linux-2.6-tip/arch/mips/sni/rm200.c
@@ -443,19 +443,12 @@ void disable_rm200_irq(unsigned int irq)
 	*(volatile u8 *)SNI_RM200_INT_ENA_REG |= mask;
 }
 
-void end_rm200_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_rm200_irq(irq);
-}
-
 static struct irq_chip rm200_irq_type = {
 	.name = "RM200",
 	.ack = disable_rm200_irq,
 	.mask = disable_rm200_irq,
 	.mask_ack = disable_rm200_irq,
 	.unmask = enable_rm200_irq,
-	.end = end_rm200_irq,
 };
 
 static void sni_rm200_hwint(void)


