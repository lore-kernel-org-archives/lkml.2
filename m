Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1ASVtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:41 -0500
Received: from www.tglx.de ([62.245.132.106]:33445 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab1ASVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:38 -0500
Message-Id: <20110119210839.532424784@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 14/37] m32r: Convert mappi irq chips
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-mappi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/mappi/setup.c |   53 ++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/m32r/platforms/mappi/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi/setup.c
@@ -38,39 +38,30 @@ static void enable_mappi_irq(unsigned in
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
+static void mask_mappi(struct irq_data *data)
 {
-	disable_mappi_irq(irq);
+	disable_mappi_irq(data->irq);
 }
 
-static void end_mappi_irq(unsigned int irq)
+static void unmask_mappi(struct irq_data *data)
 {
-		enable_mappi_irq(irq);
+	enable_mappi_irq(data->irq);
 }
 
-static unsigned int startup_mappi_irq(unsigned int irq)
-{
-	enable_mappi_irq(irq);
-	return (0);
-}
-
-static void shutdown_mappi_irq(unsigned int irq)
+static void shutdown_mappi(struct irq_data *data)
 {
 	unsigned long port;
 
-	port = irq2port(irq);
+	port = irq2port(data->irq);
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip mappi_irq_type =
 {
-	.name = "MAPPI-IRQ",
-	.startup = startup_mappi_irq,
-	.shutdown = shutdown_mappi_irq,
-	.enable = enable_mappi_irq,
-	.disable = disable_mappi_irq,
-	.ack = mask_and_ack_mappi,
-	.end = end_mappi_irq
+	.name		= "MAPPI-IRQ",
+	.irq_shutdown	= shutdown_mappi,
+	.irq_mask	= mask_mappi,
+	.irq_unmask	= unmask_mappi,
 };
 
 void __init init_IRQ(void)
@@ -84,46 +75,54 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT0 : LAN controller (RTL8019AS) */
-	set_irq_chip(M32R_IRQ_INT0, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	disable_mappi_irq(M32R_IRQ_INT0);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
 
 #if defined(CONFIG_M32R_PCC)
 	/* INT1 : pccard0 interrupt */
-	set_irq_chip(M32R_IRQ_INT1, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT1);
 
 	/* INT2 : pccard1 interrupt */
-	set_irq_chip(M32R_IRQ_INT2, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT2, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT2].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT2);
 #endif /* CONFIG_M32RPCC */


