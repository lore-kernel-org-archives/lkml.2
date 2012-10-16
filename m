Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab2JPWIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:08:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab2JPWIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:08:00 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] genirq: provide means to retrigger parent
Date: Tue, 16 Oct 2012 15:07:49 -0700
Message-Id: <1350425269-11489-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Attempts to retrigger nested threaded IRQs currently fail because they
have no primary handler.  In order to support retrigger of nested
IRQs, the parent IRQ needs to be retriggered.

To fix, when an IRQ needs to be resent, if the interrupt has a parent
IRQ and runs in the context of the parent IRQ, then resend the parent.

Also, handle_nested_irq() needs to clear the replay flag like the
other handlers, otherwise check_irq_resend() will set it and it will
never be cleared.  Without clearing, it results in the first resend
working fine, but check_irq_resend() returning early on subsequent
resends because the replay flag is still set.

Problem discovered on ARM/OMAP platforms where a nested IRQ that's
also a wakeup IRQ happens late in suspend and needed to be retriggered
during the resume process.

Reported-by: Kevin Hilman <khilman@ti.com>
Tested-by: Kevin Hilman <khilman@ti.com>
[khilman@ti.com: changelog edits, clear IRQS_REPLAY in handle_nested_irq()]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
Applies on v3.7-rc1

 include/linux/irq.h     |    9 +++++++++
 include/linux/irqdesc.h |    3 +++
 kernel/irq/chip.c       |    1 +
 kernel/irq/manage.c     |   16 ++++++++++++++++
 kernel/irq/resend.c     |    8 ++++++++
 5 files changed, 37 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 216b0ba..526f10a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -392,6 +392,15 @@ static inline void irq_move_masked_irq(struct irq_data *data) { }
 
 extern int no_irq_affinity;
 
+#ifdef CONFIG_HARDIRQS_SW_RESEND
+int irq_set_parent(int irq, int parent_irq);
+#else
+static inline int irq_set_parent(int irq, int parent_irq)
+{
+	return 0;
+}
+#endif
+
 /*
  * Built-in IRQ handlers for various IRQ types,
  * callable via desc->handle_irq()
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 0ba014c..623325e 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -11,6 +11,8 @@
 struct irq_affinity_notify;
 struct proc_dir_entry;
 struct module;
+struct irq_desc;
+
 /**
  * struct irq_desc - interrupt descriptor
  * @irq_data:		per irq and chip data passed down to chip functions
@@ -65,6 +67,7 @@ struct irq_desc {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
+	int			parent_irq;
 	struct module		*owner;
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 57d86d0..3aca9f2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -272,6 +272,7 @@ void handle_nested_irq(unsigned int irq)
 
 	raw_spin_lock_irq(&desc->lock);
 
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..d06a396 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -616,6 +616,22 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	return ret;
 }
 
+#ifdef CONFIG_HARDIRQS_SW_RESEND
+int irq_set_parent(int irq, int parent_irq)
+{
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
+
+	if (!desc)
+		return -EINVAL;
+
+	desc->parent_irq = parent_irq;
+
+	irq_put_desc_unlock(desc, flags);
+	return 0;
+}
+#endif
+
 /*
  * Default primary interrupt handler for threaded interrupts. Is
  * assigned as primary handler when request_threaded_irq is called
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 6454db7..9065107 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -74,6 +74,14 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 		if (!desc->irq_data.chip->irq_retrigger ||
 		    !desc->irq_data.chip->irq_retrigger(&desc->irq_data)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
+			/*
+			 * If the interrupt has a parent irq and runs
+			 * in the thread context of the parent irq,
+			 * retrigger the parent.
+			 */
+			if (desc->parent_irq &&
+			    irq_settings_is_nested_thread(desc))
+				irq = desc->parent_irq;
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
-- 
1.7.9.2

