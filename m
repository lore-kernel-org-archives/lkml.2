Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0JDUbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:31:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:53437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223Ab0JDUbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:31:15 -0400
Date: Mon, 4 Oct 2010 20:30:43 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121841.842536121@linutronix.de>
References: <20100927121841.842536121@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for bus_lock/bus_sync_unlock
Message-ID: <tip-3876ec9ef3775d062345b3760d3271ecb8cd3fea@git.kernel.org>
Git-Commit-ID: 3876ec9ef3775d062345b3760d3271ecb8cd3fea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:30:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3876ec9ef3775d062345b3760d3271ecb8cd3fea
Gitweb:     http://git.kernel.org/tip/3876ec9ef3775d062345b3760d3271ecb8cd3fea
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:35 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:35 +0200

genirq: Provide compat handling for bus_lock/bus_sync_unlock

Wrap the old chip functions for bus_lock/bus_sync_unlock until the
migration is complete and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121841.842536121@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c      |   20 ++++++++++++++++++--
 kernel/irq/internals.h |   12 ++++++------
 kernel/irq/manage.c    |   22 +++++++++++-----------
 3 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index e0e93ff..77e551d 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -324,6 +324,17 @@ static void default_shutdown(unsigned int irq)
 	desc->status |= IRQ_MASKED;
 }
 
+/* Temporary migration helpers */
+static void compat_bus_lock(struct irq_data *data)
+{
+	data->chip->bus_lock(data->irq);
+}
+
+static void compat_bus_sync_unlock(struct irq_data *data)
+{
+	data->chip->bus_sync_unlock(data->irq);
+}
+
 /*
  * Fixup enable/disable function pointers
  */
@@ -346,6 +357,11 @@ void irq_chip_set_defaults(struct irq_chip *chip)
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
@@ -687,7 +703,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->irq_data.chip = &dummy_irq_chip;
 	}
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
@@ -707,7 +723,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->irq_data.chip->startup(irq);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 562fc7e..ecafbfe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -43,16 +43,16 @@ extern int irq_select_affinity_usr(unsigned int irq);
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
 /* Inline functions for support of irq chips on slow busses */
-static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_lock(struct irq_desc *desc)
 {
-	if (unlikely(desc->irq_data.chip->bus_lock))
-		desc->irq_data.chip->bus_lock(irq);
+	if (unlikely(desc->irq_data.chip->irq_bus_lock))
+		desc->irq_data.chip->irq_bus_lock(&desc->irq_data);
 }
 
-static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_sync_unlock(struct irq_desc *desc)
 {
-	if (unlikely(desc->irq_data.chip->bus_sync_unlock))
-		desc->irq_data.chip->bus_sync_unlock(irq);
+	if (unlikely(desc->irq_data.chip->irq_bus_sync_unlock))
+		desc->irq_data.chip->irq_bus_sync_unlock(&desc->irq_data);
 }
 
 /*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4dfb195..dfb02ff 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -246,11 +246,11 @@ void disable_irq_nosync(unsigned int irq)
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
 
@@ -507,7 +507,7 @@ static int irq_wait_for_interrupt(struct irqaction *action)
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
 		desc->irq_data.chip->unmask(irq);
 	}
 	raw_spin_unlock_irq(&desc->lock);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 
 #ifdef CONFIG_SMP
@@ -997,9 +997,9 @@ void free_irq(unsigned int irq, void *dev_id)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1086,9 +1086,9 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	action->name = devname;
 	action->dev_id = dev_id;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 
 	if (retval)
 		kfree(action);
