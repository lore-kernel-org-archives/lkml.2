Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab0I0Mqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:46:42 -0400
Received: from www.tglx.de ([62.245.132.106]:48906 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188Ab0I0Mqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:46:31 -0400
Message-Id: <20100927121843.025801092@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:45:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 16/19] genirq; Provide compat handling for chip->retrigger()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-retrigger.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function retrigger() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c   |    7 +++++++
 kernel/irq/resend.c |    3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -389,6 +389,11 @@ static int compat_irq_set_wake(struct ir
 	return irq_data_to_desc(data)->chip->set_wake(data->irq, on);
 }
 
+static int compat_irq_retrigger(struct irq_data *data)
+{
+	return irq_data_to_desc(data)->chip->retrigger(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -461,6 +466,8 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_set_type = compat_irq_set_type;
 	if (chip->set_wake)
 		chip->irq_set_wake = compat_irq_set_wake;
+	if (chip->retrigger)
+		chip->irq_retrigger = compat_irq_retrigger;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
Index: linux-2.6-tip/kernel/irq/resend.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/resend.c
+++ linux-2.6-tip/kernel/irq/resend.c
@@ -70,7 +70,8 @@ void check_irq_resend(struct irq_desc *d
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
+		if (!desc->chip->irq_retrigger ||
+		    !desc->chip->irq_retrigger(&desc->irq_data)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);


