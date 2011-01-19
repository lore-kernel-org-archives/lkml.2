Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1ASVta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:30 -0500
Received: from www.tglx.de ([62.245.132.106]:33386 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab1ASVt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:28 -0500
Message-Id: <20110119210839.798826900@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 19/37] m32r: Convert opsput pld irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-opsput-pld-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/opsput/setup.c |   46 ++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -107,44 +107,33 @@ static void enable_opsput_pld_irq(unsign
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_pld(unsigned int irq)
+static void mask_opsput_pld(struct irq_data *data)
 {
-	disable_opsput_pld_irq(irq);
-//	mask_and_ack_opsput(M32R_IRQ_INT1);
+	disable_opsput_pld_irq(data->irq);
 }
 
-static void end_opsput_pld_irq(unsigned int irq)
+static void unmask_opsput_pld(struct irq_data *data)
 {
-	enable_opsput_pld_irq(irq);
+	enable_opsput_pld_irq(data->irq);
 	enable_opsput_irq(M32R_IRQ_INT1);
 }
 
-static unsigned int startup_opsput_pld_irq(unsigned int irq)
-{
-	enable_opsput_pld_irq(irq);
-	return (0);
-}
-
-static void shutdown_opsput_pld_irq(unsigned int irq)
+static void shutdown_opsput_pld(struct irq_data *data)
 {
 	unsigned long port;
 	unsigned int pldirq;
 
-	pldirq = irq2pldirq(irq);
-//	shutdown_opsput_irq(M32R_IRQ_INT1);
+	pldirq = irq2pldirq(data->irq);
 	port = pldirq2port(pldirq);
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip opsput_pld_irq_type =
 {
-	.name = "OPSPUT-PLD-IRQ",
-	.startup = startup_opsput_pld_irq,
-	.shutdown = shutdown_opsput_pld_irq,
-	.enable = enable_opsput_pld_irq,
-	.disable = disable_opsput_pld_irq,
-	.ack = mask_and_ack_opsput_pld,
-	.end = end_opsput_pld_irq
+	.name		= "OPSPUT-PLD-IRQ",
+	.irq_shutdown	= shutdown_opsput_pld,
+	.irq_mask	= mask_opsput_pld,
+	.irq_unmask	= unmask_opsput_pld,
 };
 
 /*
@@ -332,28 +321,33 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	set_irq_chip(PLD_IRQ_SIO0_RCV, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SIO0_RCV, &opsput_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	set_irq_chip(PLD_IRQ_SIO0_SND, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SIO0_SND, &opsput_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	set_irq_chip(PLD_IRQ_CFIREQ, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &opsput_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	set_irq_chip(PLD_IRQ_CFC_INSERT, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &opsput_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	set_irq_chip(PLD_IRQ_CFC_EJECT, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &opsput_pld_irq_type,
+				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_EJECT);
 


