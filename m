Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170Ab0I0MpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:45:01 -0400
Received: from www.tglx.de ([62.245.132.106]:34541 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759138Ab0I0Mo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:44:59 -0400
Message-Id: <20100927121841.842536121@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 04/19] genirq;
	Provide compat handling for bus_lock/bus_sync_unlock
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline;
	filename=genirq-compat-handling-for-buslock-unlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip functions for bus_lock/bus_sync_unlock until the
migration is complete and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c      |   20 ++++++++++++++++++--
 kernel/irq/internals.h |   17 +++++++++++------
 kernel/irq/manage.c    |   22 +++++++++++-----------
 3 files changed, 40 insertions(+), 19 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -327,6 +327,17 @@ static void default_shutdown(unsigned in
 	desc->status |= IRQ_MASKED;
 }
 
+/* Temporary migration helpers */
+static void compat_bus_lock(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->bus_lock(data->irq);
+}
+
+static void compat_bus_sync_unlock(struct irq_data *data)
+{
+	irq_data_to_desc(data)->chip->bus_sync_unlock(data->irq);
+}
+
 /*
  * Fixup enable/disable function pointers
  */
@@ -349,6 +360,11 @@ void irq_chip_set_defaults(struct irq_ch
 			chip->disable : default_shutdown;
 	if (!chip->end)
 		chip->end = dummy_irq_chip.end;
+
+	if (chip->bus_lock)
+		chip->irq_bus_lock = compat_bus_lock;
+	if (chip->bus_sync_unlock)
+		chip->irq_bus_sync_unlock = compat_bus_sync_unlock;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
@@ -691,7 +707,7 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->irq_data.chip = &dummy_irq_chip;
 	}
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
@@ -711,7 +727,7 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->chip->startup(irq);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
 
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -41,16 +41,21 @@ extern int irq_select_affinity_usr(unsig
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
 /* Inline functions for support of irq chips on slow busses */
-static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_lock(struct irq_desc *desc)
 {
-	if (unlikely(desc->chip->bus_lock))
-		desc->chip->bus_lock(irq);
+	if (unlikely(desc->chip->irq_bus_lock))
+		desc->chip->irq_bus_lock(&desc->irq_data);
 }
 
-static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_sync_unlock(struct irq_desc *desc)
 {
-	if (unlikely(desc->chip->bus_sync_unlock))
-		desc->chip->bus_sync_unlock(irq);
+	if (unlikely(desc->chip->irq_bus_sync_unlock))
+		desc->chip->irq_bus_sync_unlock(&desc->irq_data);
+}
+
+static inline struct irq_desc *irq_data_to_desc(struct irq_data *data)
+{
+	return container_of(data, struct irq_desc, irq_data);
 }
 
 /*
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -246,11 +246,11 @@ void disable_irq_nosync(unsigned int irq
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	__disable_irq(desc, irq, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -323,11 +323,11 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	__enable_irq(desc, irq, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(enable_irq);
 
@@ -507,7 +507,7 @@ static int irq_wait_for_interrupt(struct
 static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
 {
 again:
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
 
 	/*
@@ -521,7 +521,7 @@ again:
 	 */
 	if (unlikely(desc->status & IRQ_INPROGRESS)) {
 		raw_spin_unlock_irq(&desc->lock);
-		chip_bus_sync_unlock(irq, desc);
+		chip_bus_sync_unlock(desc);
 		cpu_relax();
 		goto again;
 	}
@@ -531,7 +531,7 @@ again:
 		desc->chip->unmask(irq);
 	}
 	raw_spin_unlock_irq(&desc->lock);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 
 #ifdef CONFIG_SMP
@@ -997,9 +997,9 @@ void free_irq(unsigned int irq, void *de
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1086,9 +1086,9 @@ int request_threaded_irq(unsigned int ir
 	action->name = devname;
 	action->dev_id = dev_id;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 
 	if (retval)
 		kfree(action);


