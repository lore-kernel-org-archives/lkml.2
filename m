Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1ASVto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:44 -0500
Received: from www.tglx.de ([62.245.132.106]:33450 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab1ASVtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:40 -0500
Message-Id: <20110119210839.850567410@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 20/37] m32r: Convert opsput lanpld irq chip
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m32r-convert-opsput-lanpld-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new functions and use proper flow
handlers. handle_level_irq is appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/m32r/platforms/opsput/setup.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -167,42 +167,33 @@ static void enable_opsput_lanpld_irq(uns
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_lanpld(unsigned int irq)
+static void mask_opsput_lanpld(struct irq_data *data)
 {
-	disable_opsput_lanpld_irq(irq);
+	disable_opsput_lanpld_irq(data->irq);
 }
 
-static void end_opsput_lanpld_irq(unsigned int irq)
+static void unmask_opsput_lanpld(struct irq_data *data)
 {
-	enable_opsput_lanpld_irq(irq);
+	enable_opsput_lanpld_irq(data->irq);
 	enable_opsput_irq(M32R_IRQ_INT0);
 }
 
-static unsigned int startup_opsput_lanpld_irq(unsigned int irq)
-{
-	enable_opsput_lanpld_irq(irq);
-	return (0);
-}
-
-static void shutdown_opsput_lanpld_irq(unsigned int irq)
+static void shutdown_opsput_lanpld(struct irq_data *data)
 {
 	unsigned long port;
 	unsigned int pldirq;
 
-	pldirq = irq2lanpldirq(irq);
+	pldirq = irq2lanpldirq(data->irq);
 	port = lanpldirq2port(pldirq);
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
 static struct irq_chip opsput_lanpld_irq_type =
 {
-	.name = "OPSPUT-PLD-LAN-IRQ",
-	.startup = startup_opsput_lanpld_irq,
-	.shutdown = shutdown_opsput_lanpld_irq,
-	.enable = enable_opsput_lanpld_irq,
-	.disable = disable_opsput_lanpld_irq,
-	.ack = mask_and_ack_opsput_lanpld,
-	.end = end_opsput_lanpld_irq
+	.name		= "OPSPUT-PLD-LAN-IRQ",
+	.irq_shutdown	= shutdown_opsput_lanpld,
+	.irq_mask	= mask_opsput_lanpld,
+	.irq_unmask	= unmask_opsput_lanpld,
 };
 
 /*
@@ -278,7 +269,8 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on OPSPUT-LAN (SMC91C111)*/
-	set_irq_chip(OPSPUT_LAN_IRQ_LAN, &opsput_lanpld_irq_type);
+	set_irq_chip_and_handler(OPSPUT_LAN_IRQ_LAN, &opsput_lanpld_irq_type,
+				 handle_level_irq);
 	lanpld_icu_data[irq2lanpldirq(OPSPUT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_opsput_lanpld_irq(OPSPUT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */


