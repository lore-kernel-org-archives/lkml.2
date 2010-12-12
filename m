Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0LLLXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 06:23:03 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:56514 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab0LLLWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 06:22:50 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH v2 2/4] genirq: Inform handler about line sharing state
Date: Sun, 12 Dec 2010 12:22:42 +0100
Message-Id: <664535c6596c0c6bf7024f2608134c90e2093c19.1292152963.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1292152963.git.jan.kiszka@web.de>
References: <cover.1292152963.git.jan.kiszka@web.de>
In-Reply-To: <cover.1292152963.git.jan.kiszka@web.de>
References: <cover.1292152963.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX188UBNtS4pzCvyDkPBfhf3zu7KKrbBaZwwJOXms
	3u/Stgby3dSTlvggJXMIQG27tsgTep1fOqYjPEypi0jKnEMWGq
	Gv9azz2YM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This enabled interrupt handlers to retrieve the current line sharing state via
the new interrupt status word so that they can adapt to it.

The switch from shared to exclusive is generally uncritical and can thus be
performed on demand. However, preparing a line for shared mode may require
preparational steps of the currently registered handler. It can therefore
request an ahead-of-time notification via IRQF_ADAPTIVE. The notification
consists of an exceptional handler invocation with IRQS_MAKE_SHAREABLE set in
the status word.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 include/linux/interrupt.h |   10 ++++++++++
 include/linux/irqdesc.h   |    2 ++
 kernel/irq/irqdesc.c      |    2 ++
 kernel/irq/manage.c       |   44 +++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 16cdbbf..c6323a2 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -55,6 +55,7 @@
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
+ * IRQF_ADAPTIVE - Request notification about upcoming interrupt line sharing
  *
  */
 #define IRQF_DISABLED		0x00000020
@@ -67,6 +68,7 @@
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
+#define IRQF_ADAPTIVE		0x00008000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
@@ -126,6 +128,14 @@ struct irqaction {
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
 
+/*
+ * Driver-readable IRQ line status flags:
+ * IRQS_SHARED - line is shared between multiple handlers
+ * IRQS_MAKE_SHAREABLE - in the process of making an exclusive line shareable
+ */
+#define IRQS_SHARED		0x00000001
+#define IRQS_MAKE_SHAREABLE	0x00000002
+
 extern unsigned long get_irq_status(unsigned long irq);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 979c68c..c490e83 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -29,6 +29,7 @@ struct timer_rand_state;
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
  * @dir:		/proc/irq/ procfs entry
  * @name:		flow handler name for /proc/interrupts output
+ * @register_lock:	protects registration & release, for unshared->shared
  */
 struct irq_desc {
 
@@ -80,6 +81,7 @@ struct irq_desc {
 	struct proc_dir_entry	*dir;
 #endif
 	const char		*name;
+	struct mutex		register_lock;
 } ____cacheline_internodealigned_in_smp;
 
 #ifndef CONFIG_SPARSE_IRQ
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 9988d03..de69845 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -143,6 +143,7 @@ static struct irq_desc *alloc_desc(int irq, int node)
 
 	raw_spin_lock_init(&desc->lock);
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	mutex_init(&desc->register_lock);
 
 	desc_set_defaults(irq, desc, node);
 
@@ -254,6 +255,7 @@ int __init early_irq_init(void)
 		alloc_masks(desc + i, GFP_KERNEL, node);
 		desc_smp_init(desc + i, node);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
+		mutex_init(&desc[i].register_lock);
 	}
 	return arch_early_irq_init();
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index df51284..a4557eb 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -754,6 +754,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			old = *old_ptr;
 		} while (old);
 		shared = 1;
+
+		desc->irq_data.status |= IRQS_SHARED;
 	}
 
 	if (!shared) {
@@ -883,6 +885,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
+	bool single_handler = false;
 	unsigned long flags;
 
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
@@ -928,7 +931,8 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 		else
 			desc->irq_data.chip->irq_disable(&desc->irq_data);
-	}
+	} else if (!desc->action->next)
+		single_handler = true;
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */
@@ -943,6 +947,9 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* Make sure it's not being used on another CPU: */
 	synchronize_irq(irq);
 
+	if (single_handler)
+		desc->irq_data.status &= ~IRQS_SHARED;
+
 #ifdef CONFIG_DEBUG_SHIRQ
 	/*
 	 * It's a shared IRQ -- the driver ought to be prepared for an IRQ
@@ -1002,9 +1009,13 @@ void free_irq(unsigned int irq, void *dev_id)
 	if (!desc)
 		return;
 
+	mutex_lock(&desc->register_lock);
+
 	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
 	chip_bus_sync_unlock(desc);
+
+	mutex_unlock(&desc->register_lock);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1055,7 +1066,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 			 irq_handler_t thread_fn, unsigned long irqflags,
 			 const char *devname, void *dev_id)
 {
-	struct irqaction *action;
+	struct irqaction *action, *old_action;
 	struct irq_desc *desc;
 	int retval;
 
@@ -1091,12 +1102,39 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	action->name = devname;
 	action->dev_id = dev_id;
 
+	mutex_lock(&desc->register_lock);
+
+	old_action = desc->action;
+	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
+	    !(desc->irq_data.status & IRQS_SHARED)) {
+		/*
+		 * Signal the old handler that is has to switch to shareable
+		 * handling mode. Disable the line to avoid any conflict with
+		 * a real IRQ.
+		 */
+		disable_irq(irq);
+		local_irq_disable();
+
+		desc->irq_data.status |= IRQS_SHARED | IRQS_MAKE_SHAREABLE;
+		old_action->handler(irq, old_action->dev_id);
+		desc->irq_data.status &= ~IRQS_MAKE_SHAREABLE;
+
+		local_irq_enable();
+		enable_irq(irq);
+		
+	}
+
 	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
 	chip_bus_sync_unlock(desc);
 
-	if (retval)
+	if (retval) {
+		if (desc->action && !desc->action->next)
+			desc->irq_data.status &= ~IRQS_SHARED;
 		kfree(action);
+	}
+
+	mutex_unlock(&desc->register_lock);
 
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (!retval && (irqflags & IRQF_SHARED)) {
-- 
1.7.1

