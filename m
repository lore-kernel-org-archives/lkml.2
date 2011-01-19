Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1ASVtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:25 -0500
Received: from www.tglx.de ([62.245.132.106]:33353 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1ASVtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:18 -0500
Message-Id: <20110119210839.635501556@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 16/37] m32r: Convert mappi3 irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-mappi3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/mappi3/setup.c |   62 ++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/m32r/platforms/mappi3/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi3/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi3/setup.c
@@ -46,98 +46,98 @@ static void enable_mappi3_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi3(unsigned int irq)
+static void mask_mappi3(struct irq_data *data)
 {
-	disable_mappi3_irq(irq);
+	disable_mappi3_irq(data->irq);
 }
 
-static void end_mappi3_irq(unsigned int irq)
+static void unmask_mappi3(struct irq_data *data)
 {
-	enable_mappi3_irq(irq);
+	enable_mappi3_irq(data->irq);
 }
 
-static unsigned int startup_mappi3_irq(unsigned int irq)
-{
-	enable_mappi3_irq(irq);
-	return (0);
-}
-
-static void shutdown_mappi3_irq(unsigned int irq)
+static void shutdown_mappi3(struct irq_data *data)
 {
 	unsigned long port;
 
-	port = irq2port(irq);
+	port = irq2port(data->irq);
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct irq_chip mappi3_irq_type =
-{
-	.name = "MAPPI3-IRQ",
-	.startup = startup_mappi3_irq,
-	.shutdown = shutdown_mappi3_irq,
-	.enable = enable_mappi3_irq,
-	.disable = disable_mappi3_irq,
-	.ack = mask_and_ack_mappi3,
-	.end = end_mappi3_irq
+static struct irq_chip mappi3_irq_type = {
+	.name		= "MAPPI3-IRQ",
+	.irq_shutdown	= shutdown_mappi3,
+	.irq_mask	= mask_mappi3,
+	.irq_unmask	= unmask_mappi3,
 };
 
 void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	set_irq_chip(M32R_IRQ_INT0, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi3_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	set_irq_chip(M32R_IRQ_INT1, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* CFC IREQ */
-	set_irq_chip(PLD_IRQ_CFIREQ, &mappi3_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert & eject */
-	set_irq_chip(PLD_IRQ_CFC_INSERT, &mappi3_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi3_irq(PLD_IRQ_CFC_INSERT);
 
 #endif /* CONFIG_M32R_CFC */
 
 	/* IDE IREQ */
-	set_irq_chip(PLD_IRQ_IDEIREQ, &mappi3_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_IDEIREQ, &mappi3_irq_type,
+				 handle_level_irq);
 	icu_data[PLD_IRQ_IDEIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(PLD_IRQ_IDEIREQ);
 


