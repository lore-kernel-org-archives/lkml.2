Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0LMXA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:00:56 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:50208 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab0LMXAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:00:13 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH v3 2/4] genirq: Inform handler about line sharing state
Date: Mon, 13 Dec 2010 23:59:44 +0100
Message-Id: <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1292281184.git.jan.kiszka@web.de>
References: <cover.1292281184.git.jan.kiszka@web.de>
In-Reply-To: <cover.1292281184.git.jan.kiszka@web.de>
References: <cover.1292281184.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX19Y97tMd6bE2Z+wJPh8OXNRIdlUouCI9dDUOW4a
	sSXX+q0Fz0I7U7U/4OtRhlen4z0PEJJnmUp02WYxzGajgekuCm
	WfmMF/LR0=
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
 include/linux/interrupt.h |   10 +++++++++
 kernel/irq/manage.c       |   47 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 4c1aa72..12e5fc0 100644
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
 extern unsigned long get_irq_status(unsigned int irq);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2ea0d30..2dd4eef 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -14,9 +14,12 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/mutex.h>
 
 #include "internals.h"
 
+static DEFINE_MUTEX(register_lock);
+
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -754,6 +757,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			old = *old_ptr;
 		} while (old);
 		shared = 1;
+
+		desc->irq_data.drv_status |= IRQS_SHARED;
 	}
 
 	if (!shared) {
@@ -883,6 +888,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
+	bool single_handler = false;
 	unsigned long flags;
 
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
@@ -928,7 +934,8 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 		else
 			desc->irq_data.chip->irq_disable(&desc->irq_data);
-	}
+	} else if (!desc->action->next)
+		single_handler = true;
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */
@@ -943,6 +950,9 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* Make sure it's not being used on another CPU: */
 	synchronize_irq(irq);
 
+	if (single_handler)
+		desc->irq_data.drv_status &= ~IRQS_SHARED;
+
 #ifdef CONFIG_DEBUG_SHIRQ
 	/*
 	 * It's a shared IRQ -- the driver ought to be prepared for an IRQ
@@ -1002,9 +1012,13 @@ void free_irq(unsigned int irq, void *dev_id)
 	if (!desc)
 		return;
 
+	mutex_lock(&register_lock);
+
 	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
 	chip_bus_sync_unlock(desc);
+
+	mutex_unlock(&register_lock);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1055,7 +1069,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 			 irq_handler_t thread_fn, unsigned long irqflags,
 			 const char *devname, void *dev_id)
 {
-	struct irqaction *action;
+	struct irqaction *action, *old_action;
 	struct irq_desc *desc;
 	int retval;
 
@@ -1091,12 +1105,39 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	action->name = devname;
 	action->dev_id = dev_id;
 
+	mutex_lock(&register_lock);
+
+	old_action = desc->action;
+	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
+	    !(desc->irq_data.drv_status & IRQS_SHARED)) {
+		/*
+		 * Signal the old handler that is has to switch to shareable
+		 * handling mode. Disable the line to avoid any conflict with
+		 * a real IRQ.
+		 */
+		disable_irq(irq);
+		local_irq_disable();
+
+		desc->irq_data.drv_status |= IRQS_SHARED | IRQS_MAKE_SHAREABLE;
+		old_action->handler(irq, old_action->dev_id);
+		desc->irq_data.drv_status &= ~IRQS_MAKE_SHAREABLE;
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
+			desc->irq_data.drv_status &= ~IRQS_SHARED;
 		kfree(action);
+	}
+
+	mutex_unlock(&register_lock);
 
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (!retval && (irqflags & IRQF_SHARED)) {
-- 
1.7.1

