Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1ASVzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:55:07 -0500
Received: from www.tglx.de ([62.245.132.106]:33418 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab1ASVte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:34 -0500
Message-Id: <20110119210839.899681212@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 21/37] m32r: Convert opsput_lcdpld irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-opsput-lcdpld-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/opsput/setup.c |   42 ++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -227,42 +227,32 @@ static void enable_opsput_lcdpld_irq(uns
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_lcdpld(unsigned int irq)
+static void mask_opsput_lcdpld(struct irq_data *data)
 {
-	disable_opsput_lcdpld_irq(irq);
+	disable_opsput_lcdpld_irq(data->irq);
 }
 
-static void end_opsput_lcdpld_irq(unsigned int irq)
+static void unmask_opsput_lcdpld(struct irq_data *data)
 {
-	enable_opsput_lcdpld_irq(irq);
+	enable_opsput_lcdpld_irq(data->irq);
 	enable_opsput_irq(M32R_IRQ_INT2);
 }
 
-static unsigned int startup_opsput_lcdpld_irq(unsigned int irq)
-{
-	enable_opsput_lcdpld_irq(irq);
-	return (0);
-}
-
-static void shutdown_opsput_lcdpld_irq(unsigned int irq)
+static void shutdown_opsput_lcdpld(struct irq_data *data)
 {
 	unsigned long port;
 	unsigned int pldirq;
 
-	pldirq = irq2lcdpldirq(irq);
+	pldirq = irq2lcdpldirq(data->irq);
 	port = lcdpldirq2port(pldirq);
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct irq_chip opsput_lcdpld_irq_type =
-{
-	"OPSPUT-PLD-LCD-IRQ",
-	startup_opsput_lcdpld_irq,
-	shutdown_opsput_lcdpld_irq,
-	enable_opsput_lcdpld_irq,
-	disable_opsput_lcdpld_irq,
-	mask_and_ack_opsput_lcdpld,
-	end_opsput_lcdpld_irq
+static struct irq_chip opsput_lcdpld_irq_type = {
+	.name		= "OPSPUT-PLD-LCD-IRQ",
+	.irq_shutdown	= shutdown_opsput_lcdpld,
+	.irq_mask	= mask_opsput_lcdpld,
+	.irq_unmask	= unmask_opsput_lcdpld,
 };
 
 void __init init_IRQ(void)
@@ -358,11 +348,11 @@ void __init init_IRQ(void)
 	enable_opsput_irq(M32R_IRQ_INT1);
 
 #if defined(CONFIG_USB)
-	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
-
-    set_irq_chip(OPSPUT_LCD_IRQ_USB_INT1, &opsput_lcdpld_irq_type);
-    lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
-    disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
+	outw(USBCR_OTGS, USBCR);	/* USBCR: non-OTG */
+	set_irq_chip_and_handler(OPSPUT_LCD_IRQ_USB_INT1,
+				 &opsput_lcdpld_irq_type, handle_level_irq);
+	lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
+	disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
 #endif
 	/*
 	 * INT2# is used for BAT, USB, AUDIO


