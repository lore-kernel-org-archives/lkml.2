Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1BJXxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:53:31 -0500
Received: from www.tglx.de ([62.245.132.106]:43893 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab1BJXgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:09 -0500
Message-Id: <20110210223254.803338426@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 05/75] genirq: Do not copy affinity before set
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-do-not-copy-affinity-before-set.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While rumaging through arch code I found that there are a few
workarounds which deal with the fact that the initial affinity setting
from request_irq() copies the mask into irq_data->affinity before the
chip code is called. In the normal path we unconditionally copy the
mask when the chip code returns 0.

Copy after the code is called and add a return code
IRQ_SET_MASK_OK_NOCOPY for the chip functions, which prevents the
copy. That way we see the real mask when the chip function decided to
truncate it further as some arches do. IRQ_SET_MASK_OK is 0, which is
the current behaviour.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |   11 +++++++++++
 kernel/irq/manage.c |   49 ++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 49 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -85,6 +85,17 @@ typedef	void (*irq_flow_handler_t)(unsig
 # define IRQ_NO_BALANCING_MASK	IRQ_NO_BALANCING
 #endif
 
+/*
+ * Return value for chip->irq_set_affinity()
+ *
+ * IRQ_SET_MASK_OK	- OK, core updates irq_data.affinity
+ * IRQ_SET_MASK_NOCPY	- OK, chip did update irq_data.affinity
+ */
+enum {
+	IRQ_SET_MASK_OK = 0,
+	IRQ_SET_MASK_OK_NOCOPY,
+};
+
 struct msi_desc;
 
 /**
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -148,9 +148,12 @@ int irq_set_affinity(unsigned int irq, c
 
 	if (irq_can_move_pcntxt(desc)) {
 		ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
-		if (!ret) {
+		switch (ret) {
+		case IRQ_SET_MASK_OK:
 			cpumask_copy(desc->irq_data.affinity, mask);
+		case IRQ_SET_MASK_OK_NOCOPY:
 			irq_set_thread_affinity(desc);
+			ret = 0;
 		}
 	} else {
 		desc->status |= IRQ_MOVE_PENDING;
@@ -254,9 +257,12 @@ EXPORT_SYMBOL_GPL(irq_set_affinity_notif
 /*
  * Generic version of the affinity autoselector.
  */
-static int setup_affinity(unsigned int irq, struct irq_desc *desc)
+static int
+setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
+	struct irq_chip *chip = get_irq_desc_chip(desc);
 	struct cpumask *set = irq_default_affinity;
+	int ret;
 
 	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
@@ -273,13 +279,20 @@ static int setup_affinity(unsigned int i
 		else
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
-	cpumask_and(desc->irq_data.affinity, cpu_online_mask, set);
-	desc->irq_data.chip->irq_set_affinity(&desc->irq_data, desc->irq_data.affinity, false);
 
+	cpumask_and(mask, cpu_online_mask, set);
+	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
+	switch (ret) {
+	case IRQ_SET_MASK_OK:
+		cpumask_copy(desc->irq_data.affinity, mask);
+	case IRQ_SET_MASK_OK_NOCOPY:
+		irq_set_thread_affinity(desc);
+	}
 	return 0;
 }
 #else
-static inline int setup_affinity(unsigned int irq, struct irq_desc *d)
+static inline int
+setup_affinity(unsigned int irq, struct irq_desc *d, struct cpumask *mask)
 {
 	return irq_select_affinity(irq);
 }
@@ -292,19 +305,25 @@ int irq_select_affinity_usr(unsigned int
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	cpumask_var_t mask;
 	int ret;
 
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret = setup_affinity(irq, desc);
+	ret = setup_affinity(irq, desc, mask);
 	if (!ret)
 		irq_set_thread_affinity(desc);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
+	free_cpumask_var(mask);
 	return ret;
 }
 
 #else
-static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
+static inline int
+setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
 	return 0;
 }
@@ -763,8 +782,8 @@ __setup_irq(unsigned int irq, struct irq
 	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
 	unsigned long flags;
-	int nested, shared = 0;
-	int ret;
+	int ret, nested, shared = 0;
+	cpumask_var_t mask;
 
 	if (!desc)
 		return -EINVAL;
@@ -829,6 +848,11 @@ __setup_irq(unsigned int irq, struct irq
 		new->thread = t;
 	}
 
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto out_thread;
+	}
+
 	/*
 	 * The following block of code has to be executed atomically
 	 */
@@ -874,7 +898,7 @@ __setup_irq(unsigned int irq, struct irq
 					new->flags & IRQF_TRIGGER_MASK);
 
 			if (ret)
-				goto out_thread;
+				goto out_mask;
 		} else
 			compat_irq_chip_set_default_handler(desc);
 #if defined(CONFIG_IRQ_PER_CPU)
@@ -901,7 +925,7 @@ __setup_irq(unsigned int irq, struct irq
 			desc->status |= IRQ_NO_BALANCING;
 
 		/* Set default affinity mask once everything is setup */
-		setup_affinity(irq, desc);
+		setup_affinity(irq, desc, mask);
 
 	} else if ((new->flags & IRQF_TRIGGER_MASK)
 			&& (new->flags & IRQF_TRIGGER_MASK)
@@ -954,6 +978,9 @@ mismatch:
 #endif
 	ret = -EBUSY;
 
+out_mask:
+	free_cpumask_var(mask);
+
 out_thread:
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	if (new->thread) {


