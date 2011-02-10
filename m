Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1BJXgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:07 -0500
Received: from www.tglx.de ([62.245.132.106]:43871 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab1BJXgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:05 -0500
Message-Id: <20110210223254.418150844@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:35:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 01/75] genirq: Namespace cleanup
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-namespace-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq namespace has become quite convoluted. My bad.  Clean it up
and deprecate the old functions. All new functions follow the scheme:

irq number based:
    irq_set/get/xxx/_xxx(unsigned int irq, ...)

irq_data based:
	 irq_data_set/get/xxx/_xxx(struct irq_data *d, ....)

irq_desc based:
	 irq_desc_get_xxx(struct irq_desc *desc)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h     |   72 +++++++++++++++++++++++++++++++++++++++++-------
 include/linux/irqdesc.h |   44 ++++++++++++++++++++++++++---
 kernel/irq/chip.c       |   28 +++++++++---------
 3 files changed, 116 insertions(+), 28 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -351,52 +351,104 @@ static inline void dynamic_irq_init(unsi
 }
 
 /* Set/get chip/data for an IRQ: */
-extern int set_irq_chip(unsigned int irq, struct irq_chip *chip);
-extern int set_irq_data(unsigned int irq, void *data);
-extern int set_irq_chip_data(unsigned int irq, void *data);
-extern int set_irq_type(unsigned int irq, unsigned int type);
-extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
+extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
+extern int irq_set_handler_data(unsigned int irq, void *data);
+extern int irq_set_chip_data(unsigned int irq, void *data);
+extern int irq_set_irq_type(unsigned int irq, unsigned int type);
+extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
 
-static inline struct irq_chip *get_irq_chip(unsigned int irq)
+static inline int __deprecated set_irq_chip(unsigned int irq,
+					    struct irq_chip *chip)
+{
+	return irq_set_chip(irq, chip);
+}
+
+static inline int __deprecated set_irq_data(unsigned int irq, void *data)
+{
+	return irq_set_handler_data(irq, data);
+}
+
+static inline int __deprecated set_irq_chip_data(unsigned int irq, void *data)
+{
+	return irq_set_chip_data(irq, data);
+}
+
+static inline int __deprecated set_irq_type(unsigned int irq, unsigned int type)
+{
+	return irq_set_irq_type(irq, type);
+}
+
+static inline int __deprecated set_irq_msi(unsigned int irq,
+					   struct msi_desc *entry)
+{
+	return irq_set_msi_desc(irq, entry);
+}
+
+static inline struct irq_chip *irq_get_chip(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
 	return d ? d->chip : NULL;
 }
 
+static inline __deprecated struct irq_chip *get_irq_chip(unsigned int irq)
+{
+	return irq_get_chip(irq);
+}
+
 static inline struct irq_chip *irq_data_get_irq_chip(struct irq_data *d)
 {
 	return d->chip;
 }
 
-static inline void *get_irq_chip_data(unsigned int irq)
+static inline void *irq_get_chip_data(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
 	return d ? d->chip_data : NULL;
 }
 
+static inline __deprecated void *get_irq_chip_data(unsigned int irq)
+{
+	return irq_get_chip_data(irq);
+}
+
 static inline void *irq_data_get_irq_chip_data(struct irq_data *d)
 {
 	return d->chip_data;
 }
 
-static inline void *get_irq_data(unsigned int irq)
+static inline void *irq_get_handler_data(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
 	return d ? d->handler_data : NULL;
 }
 
-static inline void *irq_data_get_irq_data(struct irq_data *d)
+static inline __deprecated void *get_irq_data(unsigned int irq)
+{
+	return irq_get_handler_data(irq);
+}
+
+static inline void *irq_data_get_irq_handler_data(struct irq_data *d)
 {
 	return d->handler_data;
 }
 
-static inline struct msi_desc *get_irq_msi(unsigned int irq)
+static inline __deprecated void *irq_data_get_irq_data(struct irq_data *d)
+{
+	return irq_data_get_irq_handler_data(d);
+}
+
+static inline struct msi_desc *irq_get_msi_desc(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
 	return d ? d->msi_desc : NULL;
 }
 
+static inline __deprecated struct msi_desc *get_irq_msi(unsigned int irq)
+{
+	return irq_get_msi_desc(irq);
+}
+
 static inline struct msi_desc *irq_data_get_msi(struct irq_data *d)
 {
 	return d->msi_desc;
Index: linux-2.6-tip/include/linux/irqdesc.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqdesc.h
+++ linux-2.6-tip/include/linux/irqdesc.h
@@ -98,10 +98,46 @@ static inline struct irq_desc *move_irq_
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
-#define get_irq_desc_chip(desc)		((desc)->irq_data.chip)
-#define get_irq_desc_chip_data(desc)	((desc)->irq_data.chip_data)
-#define get_irq_desc_data(desc)		((desc)->irq_data.handler_data)
-#define get_irq_desc_msi(desc)		((desc)->irq_data.msi_desc)
+static inline struct irq_chip *irq_desc_get_chip(struct irq_desc *desc)
+{
+	return desc->irq_data.chip;
+}
+
+static inline __deprecated struct irq_chip *
+get_irq_desc_chip(struct irq_desc *desc)
+{
+	return irq_desc_get_chip(desc);
+}
+
+static inline void *irq_desc_get_chip_data(struct irq_desc *desc)
+{
+	return desc->irq_data.chip_data;
+}
+
+static inline __deprecated void *get_irq_desc_chip_data(struct irq_desc *desc)
+{
+	return irq_desc_get_chip_data(desc);
+}
+
+static inline void *irq_desc_get_handler_data(struct irq_desc *desc)
+{
+	return desc->irq_data.handler_data;
+}
+
+static inline __deprecated void *get_irq_desc_data(struct irq_desc *desc)
+{
+	return irq_desc_get_handler_data(desc);
+}
+
+static inline struct msi_desc *irq_desc_get_msi_desc(struct irq_desc *desc)
+{
+	return desc->irq_data.msi_desc;
+}
+
+static inline __deprecated struct msi_desc *get_irq_desc_msi(struct irq_desc *desc)
+{
+	return irq_desc_get_msi_desc(desc);
+}
 
 /*
  * Architectures call this to let the generic IRQ layer
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -19,11 +19,11 @@
 #include "internals.h"
 
 /**
- *	set_irq_chip - set the irq chip for an irq
+ *	irq_set_chip - set the irq chip for an irq
  *	@irq:	irq number
  *	@chip:	pointer to irq chip description structure
  */
-int set_irq_chip(unsigned int irq, struct irq_chip *chip)
+int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -43,14 +43,14 @@ int set_irq_chip(unsigned int irq, struc
 
 	return 0;
 }
-EXPORT_SYMBOL(set_irq_chip);
+EXPORT_SYMBOL(irq_set_chip);
 
 /**
- *	set_irq_type - set the irq trigger type for an irq
+ *	irq_set_type - set the irq trigger type for an irq
  *	@irq:	irq number
  *	@type:	IRQ_TYPE_{LEVEL,EDGE}_* value - see include/linux/irq.h
  */
-int set_irq_type(unsigned int irq, unsigned int type)
+int irq_set_type(unsigned int irq, unsigned int type)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -70,16 +70,16 @@ int set_irq_type(unsigned int irq, unsig
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(set_irq_type);
+EXPORT_SYMBOL(irq_set_type);
 
 /**
- *	set_irq_data - set irq type data for an irq
+ *	irq_set_handler_data - set irq handler data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to interrupt specific data
  *
  *	Set the hardware irq controller data for an irq
  */
-int set_irq_data(unsigned int irq, void *data)
+int irq_set_handler_data(unsigned int irq, void *data)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -95,16 +95,16 @@ int set_irq_data(unsigned int irq, void 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
-EXPORT_SYMBOL(set_irq_data);
+EXPORT_SYMBOL(irq_set_handler_data);
 
 /**
- *	set_irq_msi - set MSI descriptor data for an irq
+ *	irq_set_msi_desc - set MSI descriptor data for an irq
  *	@irq:	Interrupt number
  *	@entry:	Pointer to MSI descriptor data
  *
  *	Set the MSI descriptor entry for an irq
  */
-int set_irq_msi(unsigned int irq, struct msi_desc *entry)
+int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -124,13 +124,13 @@ int set_irq_msi(unsigned int irq, struct
 }
 
 /**
- *	set_irq_chip_data - set irq chip data for an irq
+ *	irq_set_chip_data - set irq chip data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to chip specific data
  *
  *	Set the hardware irq chip data for an irq
  */
-int set_irq_chip_data(unsigned int irq, void *data)
+int irq_set_chip_data(unsigned int irq, void *data)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -152,7 +152,7 @@ int set_irq_chip_data(unsigned int irq, 
 
 	return 0;
 }
-EXPORT_SYMBOL(set_irq_chip_data);
+EXPORT_SYMBOL(irq_set_chip_data);
 
 struct irq_data *irq_get_irq_data(unsigned int irq)
 {


