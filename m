Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1ASVt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:28 -0500
Received: from www.tglx.de ([62.245.132.106]:33372 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab1ASVtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:25 -0500
Message-Id: <20110119210839.741953717@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 18/37] m32r: Convert opsput irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-opsput-opsput_irq_type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/opsput/setup.c |   58 +++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 31 deletions(-)
Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -46,39 +46,30 @@ static void enable_opsput_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_opsput(unsigned int irq)
+static void mask_opsput(struct irq_data *data)
 {
-	disable_opsput_irq(irq);
+	disable_opsput_irq(data->irq);
 }
 
-static void end_opsput_irq(unsigned int irq)
+static void unmask_opsput(struct irq_data *data)
 {
-	enable_opsput_irq(irq);
+	enable_opsput_irq(data->irq);
 }
 
-static unsigned int startup_opsput_irq(unsigned int irq)
-{
-	enable_opsput_irq(irq);
-	return (0);
-}
-
-static void shutdown_opsput_irq(unsigned int irq)
+static void shutdown_opsput(struct irq_data *data)
 {
 	unsigned long port;
 
-	port = irq2port(irq);
+	port = irq2port(data->irq);
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip opsput_irq_type =
 {
-	.name = "OPSPUT-IRQ",
-	.startup = startup_opsput_irq,
-	.shutdown = shutdown_opsput_irq,
-	.enable = enable_opsput_irq,
-	.disable = disable_opsput_irq,
-	.ack = mask_and_ack_opsput,
-	.end = end_opsput_irq
+	.name		= "OPSPUT-IRQ",
+	.irq_shutdown	= shutdown_opsput,
+	.irq_mask	= mask_opsput,
+	.irq_unmask	= unmask_opsput,
 };
 
 /*
@@ -100,7 +91,6 @@ static void disable_opsput_pld_irq(unsig
 	unsigned int pldirq;
 
 	pldirq = irq2pldirq(irq);
-//	disable_opsput_irq(M32R_IRQ_INT1);
 	port = pldirq2port(pldirq);
 	data = pld_icu_data[pldirq].icucr|PLD_ICUCR_ILEVEL7;
 	outw(data, port);
@@ -112,7 +102,6 @@ static void enable_opsput_pld_irq(unsign
 	unsigned int pldirq;
 
 	pldirq = irq2pldirq(irq);
-//	enable_opsput_irq(M32R_IRQ_INT1);
 	port = pldirq2port(pldirq);
 	data = pld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
@@ -127,7 +116,7 @@ static void mask_and_ack_opsput_pld(unsi
 static void end_opsput_pld_irq(unsigned int irq)
 {
 	enable_opsput_pld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT1);
+	enable_opsput_irq(M32R_IRQ_INT1);
 }
 
 static unsigned int startup_opsput_pld_irq(unsigned int irq)
@@ -197,7 +186,7 @@ static void mask_and_ack_opsput_lanpld(u
 static void end_opsput_lanpld_irq(unsigned int irq)
 {
 	enable_opsput_lanpld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT0);
+	enable_opsput_irq(M32R_IRQ_INT0);
 }
 
 static unsigned int startup_opsput_lanpld_irq(unsigned int irq)
@@ -266,7 +255,7 @@ static void mask_and_ack_opsput_lcdpld(u
 static void end_opsput_lcdpld_irq(unsigned int irq)
 {
 	enable_opsput_lcdpld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT2);
+	enable_opsput_irq(M32R_IRQ_INT2);
 }
 
 static unsigned int startup_opsput_lcdpld_irq(unsigned int irq)
@@ -306,32 +295,38 @@ void __init init_IRQ(void)
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &opsput_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_opsput_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	set_irq_chip(M32R_IRQ_SIO0_R, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &opsput_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	set_irq_chip(M32R_IRQ_SIO0_S, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &opsput_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	set_irq_chip(M32R_IRQ_SIO1_R, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &opsput_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	set_irq_chip(M32R_IRQ_SIO1_S, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &opsput_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	set_irq_chip(M32R_IRQ_DMA1, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_DMA1, &opsput_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_DMA1);
 
@@ -394,7 +389,8 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	set_irq_chip(M32R_IRQ_INT3, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT3, &opsput_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_opsput_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_VIDEO_M32R_AR */


