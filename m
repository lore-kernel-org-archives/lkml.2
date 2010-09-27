Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab0I0MpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:45:16 -0400
Received: from www.tglx.de ([62.245.132.106]:34574 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759209Ab0I0MpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:45:13 -0400
Message-Id: <20100927121842.339657617@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 09/19] genirq; Provide compat handling for chip->eoi()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-eoi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function eoi() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -348,6 +348,11 @@ static void compat_irq_mask_ack(struct i
 	irq_data_to_desc(data)->chip->mask_ack(data->irq);
 }
 
+static void compat_irq_eoi(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->eoi(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -393,6 +398,8 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_ack = compat_irq_ack;
 	if (chip->mask_ack)
 		chip->irq_mask_ack = compat_irq_mask_ack;
+	if (chip->eoi)
+		chip->irq_eoi = compat_irq_eoi;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
@@ -599,7 +606,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	desc->chip->eoi(irq);
+	desc->chip->irq_eoi(&desc->irq_data);
 
 	raw_spin_unlock(&desc->lock);
 }
@@ -701,8 +708,8 @@ handle_percpu_irq(unsigned int irq, stru
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi)
-		desc->chip->eoi(irq);
+	if (desc->chip->irq_eoi)
+		desc->chip->irq_eoi(&desc->irq_data);
 }
 
 void


