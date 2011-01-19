Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1ASVtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:07 -0500
Received: from www.tglx.de ([62.245.132.106]:33283 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1ASVtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:02 -0500
Message-Id: <20110119210839.262780775@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 09/37] m32r: Convert m32104ut irq handling
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-m32104ut.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/m32104ut/setup.c |   46 +++++++++++++++--------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/m32r/platforms/m32104ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32104ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32104ut/setup.c
@@ -39,39 +39,30 @@ static void enable_m32104ut_irq(unsigned
 	outl(data, port);
 }
 
-static void mask_and_ack_m32104ut(unsigned int irq)
+static void mask_m32104ut_irq(struct irq_data *data)
 {
-	disable_m32104ut_irq(irq);
+	disable_m32104ut_irq(data->irq);
 }
 
-static void end_m32104ut_irq(unsigned int irq)
+static void unmask_m32104ut_irq(struct irq_data *data)
 {
-	enable_m32104ut_irq(irq);
+	enable_m32104ut_irq(data->irq);
 }
 
-static unsigned int startup_m32104ut_irq(unsigned int irq)
+static void shutdown_m32104ut_irq(struct irq_data *data)
 {
-	enable_m32104ut_irq(irq);
-	return (0);
-}
-
-static void shutdown_m32104ut_irq(unsigned int irq)
-{
-	unsigned long port;
+	unsigned int irq = data->irq;
+	unsigned long port = irq2port(irq);
 
-	port = irq2port(irq);
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip m32104ut_irq_type =
 {
-	.name = "M32104UT-IRQ",
-	.startup = startup_m32104ut_irq,
-	.shutdown = shutdown_m32104ut_irq,
-	.enable = enable_m32104ut_irq,
-	.disable = disable_m32104ut_irq,
-	.ack = mask_and_ack_m32104ut,
-	.end = end_m32104ut_irq
+	.name		= "M32104UT-IRQ",
+	.irq_shutdown	= shutdown_m32104ut_irq,
+	.irq_unmask	= unmask_m32104ut_irq,
+	.irq_mask	= mask_m32104ut_irq,
 };
 
 void __init init_IRQ(void)
@@ -85,24 +76,29 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32104UT-LAN (SMC91C111)*/
-	set_irq_chip(M32R_IRQ_INT0, &m32104ut_irq_type);
-	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD11; /* "H" level sense */
+	set_irq_chip_and_handler(M32R_IRQ_INT0, &m32104ut_irq_type,
+				 handle_level_irq);
+	/* "H" level sense */
+	cu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD11;
 	disable_m32104ut_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &m32104ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &m32104ut_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &m32104ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &m32104ut_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &m32104ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &m32104ut_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */


