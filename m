Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab0I0MqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:46:09 -0400
Received: from www.tglx.de ([62.245.132.106]:48864 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759238Ab0I0MqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:46:05 -0400
Message-Id: <20100927121842.832261548@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:45:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 14/19] genirq; Provide compat handling for chip->set_type()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-set-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function set_type() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/autoprobe.c |    5 +++--
 kernel/irq/chip.c      |    7 +++++++
 kernel/irq/manage.c    |   10 +++++-----
 3 files changed, 15 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -57,8 +57,9 @@ unsigned long probe_irq_on(void)
 			 * Some chips need to know about probing in
 			 * progress:
 			 */
-			if (desc->chip->set_type)
-				desc->chip->set_type(i, IRQ_TYPE_PROBE);
+			if (desc->chip->irq_set_type)
+				desc->chip->irq_set_type(&desc->irq_data,
+							 IRQ_TYPE_PROBE);
 			desc->chip->irq_startup(&desc->irq_data);
 		}
 		raw_spin_unlock_irq(&desc->lock);
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -379,6 +379,11 @@ static int compat_irq_set_affinity(struc
 	return irq_data_to_desc(data)->chip->set_affinity(data->irq, dest);
 }
 
+static int compat_irq_set_type(struct irq_data *data, unsigned int type)
+{
+	return irq_data_to_desc(data)->chip->set_type(data->irq, type);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -447,6 +452,8 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_eoi = compat_irq_eoi;
 	if (chip->set_affinity)
 		chip->irq_set_affinity = compat_irq_set_affinity;
+	if (chip->set_type)
+		chip->irq_set_type = compat_irq_set_type;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -429,12 +429,12 @@ void compat_irq_chip_set_default_handler
 }
 
 int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
-		unsigned long flags)
+		      unsigned long flags)
 {
 	int ret;
 	struct irq_chip *chip = desc->chip;
 
-	if (!chip || !chip->set_type) {
+	if (!chip || !chip->irq_set_type) {
 		/*
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
@@ -445,11 +445,11 @@ int __irq_set_trigger(struct irq_desc *d
 	}
 
 	/* caller masked out all except trigger mode flags */
-	ret = chip->set_type(irq, flags);
+	ret = chip->irq_set_type(&desc->irq_data, flags);
 
 	if (ret)
-		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
-				(int)flags, irq, chip->set_type);
+		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
+		       flags, irq, chip->irq_set_type);
 	else {
 		if (flags & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
 			flags |= IRQ_LEVEL;


