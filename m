Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1BFQal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:30:41 -0500
Received: from www.tglx.de ([62.245.132.106]:41498 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1BFQaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:30:39 -0500
Message-Id: <20110206163008.996220791@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 16:30:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [patch 1/4] avr32: at32ap: Convert extint irq_chip to new functions
References: <20110206162900.250401028@linutronix.de>
Content-Disposition: inline;
	filename=avr32-at32ap-extint-convert-irq-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/avr32/mach-at32ap/extint.c |   45 ++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

Index: linux-next/arch/avr32/mach-at32ap/extint.c
===================================================================
--- linux-next.orig/arch/avr32/mach-at32ap/extint.c
+++ linux-next/arch/avr32/mach-at32ap/extint.c
@@ -61,35 +61,36 @@ struct eic {
 static struct eic *nmi_eic;
 static bool nmi_enabled;
 
-static void eic_ack_irq(unsigned int irq)
+static void eic_ack_irq(struct irq_chip *d)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	eic_writel(eic, ICR, 1 << (irq - eic->first_irq));
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_irq(unsigned int irq)
+static void eic_mask_irq(struct irq_chip *d)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	eic_writel(eic, IDR, 1 << (irq - eic->first_irq));
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_ack_irq(unsigned int irq)
+static void eic_mask_ack_irq(struct irq_chip *d)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	eic_writel(eic, ICR, 1 << (irq - eic->first_irq));
-	eic_writel(eic, IDR, 1 << (irq - eic->first_irq));
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
+	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_unmask_irq(unsigned int irq)
+static void eic_unmask_irq(struct irq_chip *d)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	eic_writel(eic, IER, 1 << (irq - eic->first_irq));
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	eic_writel(eic, IER, 1 << (d->irq - eic->first_irq));
 }
 
-static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
+static int eic_set_irq_type(struct irq_chip *d, unsigned int flow_type)
 {
-	struct eic *eic = get_irq_chip_data(irq);
+	struct eic *eic = irq_data_get_irq_chip_data(data);
 	struct irq_desc *desc;
+	unsigned int irq = d->irq;
 	unsigned int i = irq - eic->first_irq;
 	u32 mode, edge, level;
 	int ret = 0;
@@ -98,7 +99,7 @@ static int eic_set_irq_type(unsigned int
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
-	desc = &irq_desc[irq];
+	desc = irq_to_desc(irq);
 
 	mode = eic_readl(eic, MODE);
 	edge = eic_readl(eic, EDGE);
@@ -145,16 +146,16 @@ static int eic_set_irq_type(unsigned int
 
 static struct irq_chip eic_chip = {
 	.name		= "eic",
-	.ack		= eic_ack_irq,
-	.mask		= eic_mask_irq,
-	.mask_ack	= eic_mask_ack_irq,
-	.unmask		= eic_unmask_irq,
-	.set_type	= eic_set_irq_type,
+	.irq_ack	= eic_ack_irq,
+	.irq_mask	= eic_mask_irq,
+	.irq_mask_ack	= eic_mask_ack_irq,
+	.irq_unmask	= eic_unmask_irq,
+	.irq_set_type	= eic_set_irq_type,
 };
 
 static void demux_eic_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct eic *eic = desc->handler_data;
+	struct eic *eic = get_irq_desc_data(desc);
 	unsigned long status, pending;
 	unsigned int i;
 


