Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1ASVtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:05 -0500
Received: from www.tglx.de ([62.245.132.106]:33284 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab1ASVtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:02 -0500
Message-Id: <20110119210839.371321778@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 11/37] m32r: Convert m32700ut pld irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-m32700ut-pld_irq_type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/m32700ut/setup.c |   48 ++++++++++++++---------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

Index: linux-2.6/arch/m32r/platforms/m32700ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32700ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32700ut/setup.c
@@ -90,7 +90,6 @@ static void disable_m32700ut_pld_irq(uns
 	unsigned int pldirq;
 
 	pldirq = irq2pldirq(irq);
-//	disable_m32700ut_irq(M32R_IRQ_INT1);
 	port = pldirq2port(pldirq);
 	data = pld_icu_data[pldirq].icucr|PLD_ICUCR_ILEVEL7;
 	outw(data, port);
@@ -102,50 +101,38 @@ static void enable_m32700ut_pld_irq(unsi
 	unsigned int pldirq;
 
 	pldirq = irq2pldirq(irq);
-//	enable_m32700ut_irq(M32R_IRQ_INT1);
 	port = pldirq2port(pldirq);
 	data = pld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_pld(unsigned int irq)
+static void mask_m32700ut_pld(struct irq_data *data)
 {
-	disable_m32700ut_pld_irq(irq);
-//	mask_and_ack_m32700ut(M32R_IRQ_INT1);
+	disable_m32700ut_pld_irq(data->irq);
 }
 
-static void end_m32700ut_pld_irq(unsigned int irq)
+static void unmask_m32700ut_pld(struct irq_data *data)
 {
-	enable_m32700ut_pld_irq(irq);
+	enable_m32700ut_pld_irq(data->irq);
 	enable_m32700ut_irq(M32R_IRQ_INT1);
 }
 
-static unsigned int startup_m32700ut_pld_irq(unsigned int irq)
-{
-	enable_m32700ut_pld_irq(irq);
-	return (0);
-}
-
-static void shutdown_m32700ut_pld_irq(unsigned int irq)
+static void shutdown_m32700ut_pld_irq(struct irq_data *data)
 {
 	unsigned long port;
 	unsigned int pldirq;
 
-	pldirq = irq2pldirq(irq);
-//	shutdown_m32700ut_irq(M32R_IRQ_INT1);
+	pldirq = irq2pldirq(data->irq);
 	port = pldirq2port(pldirq);
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip m32700ut_pld_irq_type =
 {
-	.name = "M32700UT-PLD-IRQ",
-	.startup = startup_m32700ut_pld_irq,
-	.shutdown = shutdown_m32700ut_pld_irq,
-	.enable = enable_m32700ut_pld_irq,
-	.disable = disable_m32700ut_pld_irq,
-	.ack = mask_and_ack_m32700ut_pld,
-	.end = end_m32700ut_pld_irq
+	.name		= "M32700UT-PLD-IRQ",
+	.irq_shutdown	= shutdown_m32700ut_pld_irq,
+	.irq_mask	= mask_m32700ut_pld,
+	.irq_unmask	= unmask_m32700ut_pld,
 };
 
 /*
@@ -333,28 +320,33 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	set_irq_chip(PLD_IRQ_SIO0_RCV, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SIO0_RCV, &m32700ut_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	set_irq_chip(PLD_IRQ_SIO0_SND, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SIO0_SND, &m32700ut_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	set_irq_chip(PLD_IRQ_CFIREQ, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &m32700ut_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	set_irq_chip(PLD_IRQ_CFC_INSERT, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &m32700ut_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	set_irq_chip(PLD_IRQ_CFC_EJECT, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &m32700ut_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_EJECT);
 


