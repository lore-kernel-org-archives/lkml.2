Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1ASVtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:11 -0500
Received: from www.tglx.de ([62.245.132.106]:33310 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1ASVtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:09 -0500
Message-Id: <20110119210839.111407986@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mikael Starvik <starvik@axis.com>
Subject: [patch 06/37] cris: Convert V32 interrupt handling
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=cris-cleanup-v32-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chip functions and install handle_simple_irq for each
interrupt to get rid of __do_IRQ()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Starvik <starvik@axis.com>
---
 arch/cris/arch-v32/kernel/irq.c |   50 ++++++++++++----------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

Index: linux-2.6/arch/cris/arch-v32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v32/kernel/irq.c
@@ -291,54 +291,33 @@ void crisv32_unmask_irq(int irq)
 }
 
 
-static unsigned int startup_crisv32_irq(unsigned int irq)
+static void enable_crisv32_irq(struct irq_data *data)
 {
-	crisv32_unmask_irq(irq);
-	return 0;
-}
-
-static void shutdown_crisv32_irq(unsigned int irq)
-{
-	crisv32_mask_irq(irq);
+	crisv32_unmask_irq(data->irq);
 }
 
-static void enable_crisv32_irq(unsigned int irq)
+static void disable_crisv32_irq(struct irq_data *data)
 {
-	crisv32_unmask_irq(irq);
+	crisv32_mask_irq(data->irq);
 }
 
-static void disable_crisv32_irq(unsigned int irq)
-{
-	crisv32_mask_irq(irq);
-}
-
-static void ack_crisv32_irq(unsigned int irq)
-{
-}
-
-static void end_crisv32_irq(unsigned int irq)
-{
-}
-
-int set_affinity_crisv32_irq(unsigned int irq, const struct cpumask *dest)
+static int set_affinity_crisv32_irq(struct irq_data *data,
+				    const struct cpumask *dest, bool force)
 {
 	unsigned long flags;
+
 	spin_lock_irqsave(&irq_lock, flags);
-	irq_allocations[irq - FIRST_IRQ].mask = *dest;
+	irq_allocations[data->irq - FIRST_IRQ].mask = *dest;
 	spin_unlock_irqrestore(&irq_lock, flags);
-
 	return 0;
 }
 
 static struct irq_chip crisv32_irq_type = {
-	.name =        "CRISv32",
-	.startup =     startup_crisv32_irq,
-	.shutdown =    shutdown_crisv32_irq,
-	.enable =      enable_crisv32_irq,
-	.disable =     disable_crisv32_irq,
-	.ack =         ack_crisv32_irq,
-	.end =         end_crisv32_irq,
-	.set_affinity = set_affinity_crisv32_irq
+	.name			= "CRISv32",
+	.irq_shutdown		= disable_crisv32_irq,
+	.irq_enable		= enable_crisv32_irq,
+	.irq_disable		= disable_crisv32_irq,
+	.irq_set_affinity	= set_affinity_crisv32_irq,
 };
 
 void
@@ -472,7 +451,8 @@ init_IRQ(void)
 
 	/* Point all IRQ's to bad handlers. */
 	for (i = FIRST_IRQ, j = 0; j < NR_IRQS; i++, j++) {
-		irq_desc[j].chip = &crisv32_irq_type;
+		set_irq_chip_and_handler(j, &crisv32_irq_type,
+					 handle_simple_irq);
 		set_exception_vector(i, interrupt[j]);
 	}
 


