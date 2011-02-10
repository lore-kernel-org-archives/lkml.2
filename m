Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab1BJXhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:13 -0500
Received: from www.tglx.de ([62.245.132.106]:44121 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422Ab1BJXhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:02 -0500
Message-Id: <20110210223256.914758232@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 27/75] genirq: Use handle_perpcu_event() in handle_percpu_irq()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-convert-percpu-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -616,19 +616,17 @@ out_unlock:
 void
 handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
-	irqreturn_t action_ret;
+	struct irq_chip *chip = get_irq_desc_chip(desc);
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (desc->irq_data.chip->irq_ack)
-		desc->irq_data.chip->irq_ack(&desc->irq_data);
+	if (chip->irq_ack)
+		chip->irq_ack(&desc->irq_data);
 
-	action_ret = handle_IRQ_event(irq, desc->action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	handle_irq_event_percpu(desc, desc->action);
 
-	if (desc->irq_data.chip->irq_eoi)
-		desc->irq_data.chip->irq_eoi(&desc->irq_data);
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
 }
 
 void


