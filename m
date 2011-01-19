Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1ASVyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:54:39 -0500
Received: from www.tglx.de ([62.245.132.106]:33452 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab1ASVtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:40 -0500
Message-Id: <20110119210839.482865497@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 13/37] m32r: Convert m32700ut lcdpld irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline;
 filename=m32r-convert-m32700ut-lcdpld_irq_type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chip to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/m32700ut/setup.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/m32r/platforms/m32700ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32700ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32700ut/setup.c
@@ -226,42 +226,33 @@ static void enable_m32700ut_lcdpld_irq(u
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_lcdpld(unsigned int irq)
+static void mask_m32700ut_lcdpld(struct irq_data *data)
 {
-	disable_m32700ut_lcdpld_irq(irq);
+	disable_m32700ut_lcdpld_irq(data->irq);
 }
 
-static void end_m32700ut_lcdpld_irq(unsigned int irq)
+static void unmask_m32700ut_lcdpld(struct irq_data *data)
 {
-	enable_m32700ut_lcdpld_irq(irq);
+	enable_m32700ut_lcdpld_irq(data->irq);
 	enable_m32700ut_irq(M32R_IRQ_INT2);
 }
 
-static unsigned int startup_m32700ut_lcdpld_irq(unsigned int irq)
-{
-	enable_m32700ut_lcdpld_irq(irq);
-	return (0);
-}
-
-static void shutdown_m32700ut_lcdpld_irq(unsigned int irq)
+static void shutdown_m32700ut_lcdpld(struct irq_data *data)
 {
 	unsigned long port;
 	unsigned int pldirq;
 
-	pldirq = irq2lcdpldirq(irq);
+	pldirq = irq2lcdpldirq(data->irq);
 	port = lcdpldirq2port(pldirq);
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip m32700ut_lcdpld_irq_type =
 {
-	.name = "M32700UT-PLD-LCD-IRQ",
-	.startup = startup_m32700ut_lcdpld_irq,
-	.shutdown = shutdown_m32700ut_lcdpld_irq,
-	.enable = enable_m32700ut_lcdpld_irq,
-	.disable = disable_m32700ut_lcdpld_irq,
-	.ack = mask_and_ack_m32700ut_lcdpld,
-	.end = end_m32700ut_lcdpld_irq
+	.name		= "M32700UT-PLD-LCD-IRQ",
+	.irq_shutdown	= shutdown_m32700ut_lcdpld,
+	.irq_mask	= mask_m32700ut_lcdpld,
+	.irq_unmask	= unmask_m32700ut_lcdpld,
 };
 
 void __init init_IRQ(void)
@@ -358,7 +349,8 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
-	set_irq_chip(M32700UT_LCD_IRQ_USB_INT1, &m32700ut_lcdpld_irq_type);
+	set_irq_chip_and_handler(M32700UT_LCD_IRQ_USB_INT1,
+				 &m32700ut_lcdpld_irq_type, handle_level_irq);
 
 	lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
 	disable_m32700ut_lcdpld_irq(M32700UT_LCD_IRQ_USB_INT1);


