Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557Ab1CYLMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:12:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:38570 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934407Ab1CYLMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:30 -0400
Message-Id: <20110325111217.963062438@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 04/10] mfd: htc-egpio: Cleanup interrupt handling
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mff-htc-eg.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the open coded handler call with the prober accessor. Retrieve
the handler data from desc. That avoids a redundant lookup in the
sparse irq case.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/htc-egpio.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/drivers/mfd/htc-egpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/htc-egpio.c
+++ linux-2.6-tip/drivers/mfd/htc-egpio.c
@@ -100,7 +100,7 @@ static struct irq_chip egpio_muxed_chip 
 
 static void egpio_handler(unsigned int irq, struct irq_desc *desc)
 {
-	struct egpio_info *ei = get_irq_data(irq);
+	struct egpio_info *ei = irq_desc_get_handler_data(desc);
 	int irqpin;
 
 	/* Read current pins. */
@@ -113,9 +113,7 @@ static void egpio_handler(unsigned int i
 	for_each_set_bit(irqpin, &readval, ei->nirqs) {
 		/* Run irq handler */
 		pr_debug("got IRQ %d\n", irqpin);
-		irq = ei->irq_start + irqpin;
-		desc = irq_to_desc(irq);
-		desc->handle_irq(irq, desc);
+		generic_handle_irq(ei->irq_start + irqpin);
 	}
 }
 


