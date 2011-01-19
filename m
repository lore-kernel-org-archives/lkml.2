Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1ASVxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:53:38 -0500
Received: from www.tglx.de ([62.245.132.106]:33519 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab1ASVtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:55 -0500
Message-Id: <20110119210839.691117182@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 17/37] m32r: Convert oaks32r irq chips
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-oaks32r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/oaks32r/setup.c |   47 ++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/m32r/platforms/oaks32r/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/oaks32r/setup.c
+++ linux-2.6/arch/m32r/platforms/oaks32r/setup.c
@@ -37,39 +37,30 @@ static void enable_oaks32r_irq(unsigned 
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
+static void mask_oaks32r(struct irq_data *data)
 {
-	disable_oaks32r_irq(irq);
+	disable_oaks32r_irq(data->irq);
 }
 
-static void end_oaks32r_irq(unsigned int irq)
+static void unmask_oaks32r(struct irq_data *data)
 {
-	enable_oaks32r_irq(irq);
+	enable_oaks32r_irq(data->irq);
 }
 
-static unsigned int startup_oaks32r_irq(unsigned int irq)
-{
-	enable_oaks32r_irq(irq);
-	return (0);
-}
-
-static void shutdown_oaks32r_irq(unsigned int irq)
+static void shutdown_oaks32r(struct irq_data *data)
 {
 	unsigned long port;
 
-	port = irq2port(irq);
+	port = irq2port(data->irq);
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip oaks32r_irq_type =
 {
-	.name = "OAKS32R-IRQ",
-	.startup = startup_oaks32r_irq,
-	.shutdown = shutdown_oaks32r_irq,
-	.enable = enable_oaks32r_irq,
-	.disable = disable_oaks32r_irq,
-	.ack = mask_and_ack_mappi,
-	.end = end_oaks32r_irq
+	.name		= "OAKS32R-IRQ",
+	.irq_shutdown	= shutdown_oaks32r,
+	.irq_mask	= mask_oaks32r,
+	.irq_unmask	= unmask_oaks32r,
 };
 
 void __init init_IRQ(void)
@@ -83,34 +74,40 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT3 : LAN controller (RTL8019AS) */
-	set_irq_chip(M32R_IRQ_INT3, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT3, &oaks32r_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_oaks32r_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &oaks32r_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_oaks32r_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &oaks32r_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &oaks32r_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &oaks32r_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &oaks32r_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */


