Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1ASVtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:43 -0500
Received: from www.tglx.de ([62.245.132.106]:33446 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab1ASVtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:39 -0500
Message-Id: <20110119210839.942761592@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 22/37] m32r: Convert usrv platform irq handling
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-usrv.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/usrv/setup.c |   88 +++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 48 deletions(-)

Index: linux-2.6/arch/m32r/platforms/usrv/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/usrv/setup.c
+++ linux-2.6/arch/m32r/platforms/usrv/setup.c
@@ -37,39 +37,30 @@ static void enable_mappi_irq(unsigned in
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
-	enable_mappi_irq(irq);
+	enable_mappi_irq(data->irq);
 }
 
-static unsigned int startup_mappi_irq(unsigned int irq)
-{
-	enable_mappi_irq(irq);
-	return 0;
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
-	.name = "M32700-IRQ",
-	.startup = startup_mappi_irq,
-	.shutdown = shutdown_mappi_irq,
-	.enable = enable_mappi_irq,
-	.disable = disable_mappi_irq,
-	.ack = mask_and_ack_mappi,
-	.end = end_mappi_irq
+	.name		= "M32700-IRQ",
+	.irq_shutdown	= shutdown_mappi,
+	.irq_mask	= mask_mappi,
+	.irq_unmask	= unmask_mappi,
 };
 
 /*
@@ -107,42 +98,33 @@ static void enable_m32700ut_pld_irq(unsi
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_pld(unsigned int irq)
-{
-	disable_m32700ut_pld_irq(irq);
-}
-
-static void end_m32700ut_pld_irq(unsigned int irq)
+static void mask_m32700ut_pld(struct irq_data *data)
 {
-	enable_m32700ut_pld_irq(irq);
-	end_mappi_irq(M32R_IRQ_INT1);
+	disable_m32700ut_pld_irq(data->irq);
 }
 
-static unsigned int startup_m32700ut_pld_irq(unsigned int irq)
+static void unmask_m32700ut_pld(struct irq_data *data)
 {
-	enable_m32700ut_pld_irq(irq);
-	return 0;
+	enable_m32700ut_pld_irq(data->irq);
+	enable_mappi_irq(M32R_IRQ_INT1);
 }
 
-static void shutdown_m32700ut_pld_irq(unsigned int irq)
+static void shutdown_m32700ut_pld(struct irq_data *data)
 {
 	unsigned long port;
 	unsigned int pldirq;
 
-	pldirq = irq2pldirq(irq);
+	pldirq = irq2pldirq(data->irq);
 	port = pldirq2port(pldirq);
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip m32700ut_pld_irq_type =
 {
-	.name = "USRV-PLD-IRQ",
-	.startup = startup_m32700ut_pld_irq,
-	.shutdown = shutdown_m32700ut_pld_irq,
-	.enable = enable_m32700ut_pld_irq,
-	.disable = disable_m32700ut_pld_irq,
-	.ack = mask_and_ack_m32700ut_pld,
-	.end = end_m32700ut_pld_irq
+	.name		= "USRV-PLD-IRQ",
+	.irq_shutdown	= shutdown_m32700ut_pld,
+	.irq_mask	= mask_m32700ut_pld,
+	.irq_unmask	= unmask_m32700ut_pld,
 };
 
 void __init init_IRQ(void)
@@ -156,35 +138,42 @@ void __init init_IRQ(void)
 		once++;
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi_irq_type,
+				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #if defined(CONFIG_SERIAL_M32R_SIO)
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
 #endif  /* CONFIG_SERIAL_M32R_SIO */
 
 	/* INT#67-#71: CFC#0 IREQ on PLD */
 	for (i = 0 ; i < CONFIG_M32R_CFC_NUM ; i++ ) {
-		set_irq_chip(PLD_IRQ_CF0 + i, &m32700ut_pld_irq_type);
+		set_irq_chip_and_handler(PLD_IRQ_CF0 + i,
+					 &m32700ut_pld_irq_type,
+					 handle_level_irq);
 		pld_icu_data[irq2pldirq(PLD_IRQ_CF0 + i)].icucr
 			= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 		disable_m32700ut_pld_irq(PLD_IRQ_CF0 + i);
@@ -192,13 +181,15 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
 	/* INT#76: 16552D#0 IREQ on PLD */
-	set_irq_chip(PLD_IRQ_UART0, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_UART0, &m32700ut_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART0)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART0);
 
 	/* INT#77: 16552D#1 IREQ on PLD */
-	set_irq_chip(PLD_IRQ_UART1, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_UART1, &m32700ut_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART1)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART1);
@@ -206,7 +197,8 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_IDC_AK4524) || defined(CONFIG_IDC_AK4524_MODULE)
 	/* INT#80: AK4524 IREQ on PLD */
-	set_irq_chip(PLD_IRQ_SNDINT, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SNDINT, &m32700ut_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SNDINT)].icucr
 		= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_SNDINT);


