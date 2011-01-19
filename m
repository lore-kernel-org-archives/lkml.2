Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1ASVyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:54:02 -0500
Received: from www.tglx.de ([62.245.132.106]:33460 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1ASVtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:43 -0500
Message-Id: <20110119210839.580848521@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 15/37] m32r: Convert mappi2 irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-mappi2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
---
 arch/m32r/platforms/mappi2/setup.c |   59 ++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

Index: linux-2.6/arch/m32r/platforms/mappi2/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi2/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi2/setup.c
@@ -46,96 +46,97 @@ static void enable_mappi2_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi2(unsigned int irq)
+static void mask_mappi2(struct irq_data *data)
 {
-	disable_mappi2_irq(irq);
+	disable_mappi2_irq(data->irq);
 }
 
-static void end_mappi2_irq(unsigned int irq)
+static void unmask_mappi2(struct irq_data *data)
 {
-	enable_mappi2_irq(irq);
+	enable_mappi2_irq(data->irq);
 }
 
-static unsigned int startup_mappi2_irq(unsigned int irq)
-{
-	enable_mappi2_irq(irq);
-	return (0);
-}
-
-static void shutdown_mappi2_irq(unsigned int irq)
+static void shutdown_mappi2(struct irq_data *data)
 {
 	unsigned long port;
 
-	port = irq2port(irq);
+	port = irq2port(data->irq);
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip mappi2_irq_type =
 {
-	.name = "MAPPI2-IRQ",
-	.startup = startup_mappi2_irq,
-	.shutdown = shutdown_mappi2_irq,
-	.enable = enable_mappi2_irq,
-	.disable = disable_mappi2_irq,
-	.ack = mask_and_ack_mappi2,
-	.end = end_mappi2_irq
+	.name		= "MAPPI2-IRQ",
+	.irq_shutdown	= shutdown_mappi2,
+	.irq_mask	= mask_mappi2,
+	.irq_unmask	= unmask_mappi2,
 };
 
 void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	set_irq_chip(M32R_IRQ_INT0, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi2_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	set_irq_chip(M32R_IRQ_INT1, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* ICUCR40: CFC IREQ */
-	set_irq_chip(PLD_IRQ_CFIREQ, &mappi2_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert */
-	set_irq_chip(PLD_IRQ_CFC_INSERT, &mappi2_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi2_irq(PLD_IRQ_CFC_INSERT);
 
 	/* ICUCR42: CFC Eject */
-	set_irq_chip(PLD_IRQ_CFC_EJECT, &mappi2_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &mappi2_irq_type,
+				 handle_level_irq);
 	icu_data[PLD_IRQ_CFC_EJECT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(PLD_IRQ_CFC_EJECT);
 #endif /* CONFIG_MAPPI2_CFC */


