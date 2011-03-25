Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1CYNd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:33:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:33066 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752062Ab1CYNc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:32:57 -0400
Message-Id: <20110325133202.943843371@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:32:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [patch 1/2] bfin: Final irq cleanup
References: <20110325133039.521553268@linutronix.de>
Content-Disposition: inline; filename=bfin-cleanup.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the trigger type in irq_data and check level type instead of
looking at desc->handle_irq.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
 arch/blackfin/mach-bf561/smp.c            |    6 +++---
 arch/blackfin/mach-common/ints-priority.c |    9 +++------
 2 files changed, 6 insertions(+), 9 deletions(-)
Index: linux-2.6-tip/arch/blackfin/mach-bf561/smp.c
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/mach-bf561/smp.c
+++ linux-2.6-tip/arch/blackfin/mach-bf561/smp.c
@@ -154,13 +154,13 @@ void platform_clear_ipi(unsigned int cpu
 void __cpuinit bfin_local_timer_setup(void)
 {
 #if defined(CONFIG_TICKSOURCE_CORETMR)
-	struct irq_chip *chip = get_irq_chip(IRQ_CORETMR);
-	struct irq_desc *desc = irq_to_desc(IRQ_CORETMR);
+	struct irq_data *data = irq_get_irq_data(IRQ_CORETMR);
+	struct irq_chip *chip = irq_data_get_chip(data);
 
 	bfin_coretmr_init();
 	bfin_coretmr_clockevent_init();
 
-	chip->irq_unmask(&desc->irq_data);
+	chip->irq_unmask(data);
 #else
 	/* Power down the core timer, just to play safe. */
 	bfin_write_TCNTL(0);
Index: linux-2.6-tip/arch/blackfin/mach-common/ints-priority.c
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/mach-common/ints-priority.c
+++ linux-2.6-tip/arch/blackfin/mach-common/ints-priority.c
@@ -578,10 +578,9 @@ static void bfin_gpio_ack_irq(struct irq
 static void bfin_gpio_mask_ack_irq(struct irq_data *d)
 {
 	unsigned int irq = d->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	u32 gpionr = irq_to_gpio(irq);
 
-	if (desc->handle_irq == handle_edge_irq)
+	if (!irqd_is_level_type(d))
 		set_gpio_data(gpionr, 0);
 
 	set_gpio_maska(gpionr, 0);
@@ -837,12 +836,11 @@ void init_pint_lut(void)
 
 static void bfin_gpio_ack_irq(struct irq_data *d)
 {
-	struct irq_desc *desc = irq_to_desc(d->irq);
 	u32 pint_val = irq2pint_lut[d->irq - SYS_IRQS];
 	u32 pintbit = PINT_BIT(pint_val);
 	u32 bank = PINT_2_BANK(pint_val);
 
-	if ((desc->status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
+	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
 		if (pint[bank]->invert_set & pintbit)
 			pint[bank]->invert_clear = pintbit;
 		else
@@ -854,12 +852,11 @@ static void bfin_gpio_ack_irq(struct irq
 
 static void bfin_gpio_mask_ack_irq(struct irq_data *d)
 {
-	struct irq_desc *desc = irq_to_desc(d->irq);
 	u32 pint_val = irq2pint_lut[d->irq - SYS_IRQS];
 	u32 pintbit = PINT_BIT(pint_val);
 	u32 bank = PINT_2_BANK(pint_val);
 
-	if ((desc->status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
+	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
 		if (pint[bank]->invert_set & pintbit)
 			pint[bank]->invert_clear = pintbit;
 		else


