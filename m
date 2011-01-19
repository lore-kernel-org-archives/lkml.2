Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab1ASVte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:34 -0500
Received: from www.tglx.de ([62.245.132.106]:33410 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1ASVtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:32 -0500
Message-Id: <20110119210839.433082613@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 12/37] m32r: Convert m32700ut lanpld irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline;
 filename=m32r-convert-m32700ut-lanpld_irq_type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
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
@@ -166,42 +166,33 @@ static void enable_m32700ut_lanpld_irq(u
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_lanpld(unsigned int irq)
+static void mask_m32700ut_lanpld(struct irq_data *data)
 {
-	disable_m32700ut_lanpld_irq(irq);
+	disable_m32700ut_lanpld_irq(data->irq);
 }
 
-static void end_m32700ut_lanpld_irq(unsigned int irq)
+static void unmask_m32700ut_lanpld(struct irq_data *data)
 {
-	enable_m32700ut_lanpld_irq(irq);
+	enable_m32700ut_lanpld_irq(data->irq);
 	enable_m32700ut_irq(M32R_IRQ_INT0);
 }
 
-static unsigned int startup_m32700ut_lanpld_irq(unsigned int irq)
-{
-	enable_m32700ut_lanpld_irq(irq);
-	return (0);
-}
-
-static void shutdown_m32700ut_lanpld_irq(unsigned int irq)
+static void shutdown_m32700ut_lanpld(struct irq_data *data)
 {
 	unsigned long port;
 	unsigned int pldirq;
 
-	pldirq = irq2lanpldirq(irq);
+	pldirq = irq2lanpldirq(data->irq);
 	port = lanpldirq2port(pldirq);
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip m32700ut_lanpld_irq_type =
 {
-	.name = "M32700UT-PLD-LAN-IRQ",
-	.startup = startup_m32700ut_lanpld_irq,
-	.shutdown = shutdown_m32700ut_lanpld_irq,
-	.enable = enable_m32700ut_lanpld_irq,
-	.disable = disable_m32700ut_lanpld_irq,
-	.ack = mask_and_ack_m32700ut_lanpld,
-	.end = end_m32700ut_lanpld_irq
+	.name		= "M32700UT-PLD-LAN-IRQ",
+	.irq_shutdown	= shutdown_m32700ut_lanpld,
+	.irq_mask	= mask_m32700ut_lanpld,
+	.irq_unmask	= unmask_m32700ut_lanpld,
 };
 
 /*
@@ -277,7 +268,8 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32700UT-LAN (SMC91C111)*/
-	set_irq_chip(M32700UT_LAN_IRQ_LAN, &m32700ut_lanpld_irq_type);
+	set_irq_chip_and_handler(M32700UT_LAN_IRQ_LAN,
+				 &m32700ut_lanpld_irq_type, handle_level_irq);
 	lanpld_icu_data[irq2lanpldirq(M32700UT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_m32700ut_lanpld_irq(M32700UT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */


