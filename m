Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1BFQaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:30:46 -0500
Received: from www.tglx.de ([62.245.132.106]:41507 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1BFQam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:30:42 -0500
Message-Id: <20110206163009.096308633@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 16:30:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [patch 2/4] avr32: at32ap: Convert intc irq_chip to new functions
References: <20110206162900.250401028@linutronix.de>
Content-Disposition: inline; filename=avr32-at32ap-intc-convert-irq-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also replace the open coded handler call with the proper wrapper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/avr32/mach-at32ap/intc.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-next/arch/avr32/mach-at32ap/intc.c
===================================================================
--- linux-next.orig/arch/avr32/mach-at32ap/intc.c
+++ linux-next/arch/avr32/mach-at32ap/intc.c
@@ -34,12 +34,12 @@ extern struct platform_device at32_intc0
  * TODO: We may be able to implement mask/unmask by setting IxM flags
  * in the status register.
  */
-static void intc_mask_irq(unsigned int irq)
+static void intc_mask_irq(struct irq_data *d)
 {
 
 }
 
-static void intc_unmask_irq(unsigned int irq)
+static void intc_unmask_irq(struct irq_data *d)
 {
 
 }
@@ -47,8 +47,8 @@ static void intc_unmask_irq(unsigned int
 static struct intc intc0 = {
 	.chip = {
 		.name		= "intc",
-		.mask		= intc_mask_irq,
-		.unmask		= intc_unmask_irq,
+		.irq_mask	= intc_mask_irq,
+		.irq_unmask	= intc_unmask_irq,
 	},
 };
 
@@ -57,7 +57,6 @@ static struct intc intc0 = {
  */
 asmlinkage void do_IRQ(int level, struct pt_regs *regs)
 {
-	struct irq_desc *desc;
 	struct pt_regs *old_regs;
 	unsigned int irq;
 	unsigned long status_reg;
@@ -69,8 +68,7 @@ asmlinkage void do_IRQ(int level, struct
 	irq_enter();
 
 	irq = intc_readl(&intc0, INTCAUSE0 - 4 * level);
-	desc = irq_desc + irq;
-	desc->handle_irq(irq, desc);
+	generic_handle_irq(irq);
 
 	/*
 	 * Clear all interrupt level masks so that we may handle


