Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1BEUJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:09:33 -0500
Received: from www.tglx.de ([62.245.132.106]:44516 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab1BEUJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:09:02 -0500
Message-Id: <20110205200704.022396717@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 20:08:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 3/4] genirq: Add IRQF_FORCE_RESUME
References: <20110205200108.921707839@linutronix.de>
Content-Disposition: inline; filename=genirq-add-force-enable-on-resume.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen needs to reenable interrupts which are marked IRQF_NO_SUSPEND in the
resume path. Add a flag to force the reenabling in the resume code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    3 ++-
 include/linux/irq.h       |    4 +++-
 kernel/irq/manage.c       |   11 ++++++++++-
 kernel/irq/pm.c           |    3 ---
 4 files changed, 15 insertions(+), 6 deletions(-)

Index: linux-next/include/linux/interrupt.h
===================================================================
--- linux-next.orig/include/linux/interrupt.h
+++ linux-next/include/linux/interrupt.h
@@ -57,7 +57,7 @@
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
- *
+ * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -69,6 +69,7 @@
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
+#define IRQF_FORCE_RESUME	0x00008000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
Index: linux-next/include/linux/irq.h
===================================================================
--- linux-next.orig/include/linux/irq.h
+++ linux-next/include/linux/irq.h
@@ -71,10 +71,12 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 #define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
+#define IRQ_FORCE_SUSPEND	0x20000000	/* Ignore IRQF_NO_SUSPEND */
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
-	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL)
+	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL \
+	 IRQ_FORCE_SUSPEND)
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
Index: linux-next/kernel/irq/manage.c
===================================================================
--- linux-next.orig/kernel/irq/manage.c
+++ linux-next/kernel/irq/manage.c
@@ -359,8 +359,17 @@ EXPORT_SYMBOL(disable_irq);
 
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
-	if (resume)
+	if (resume) {
+		if (!(desc->status & IRQ_SUSPENDED)) {
+			if (!desc->action)
+				return;
+			if (!(desc->action->flags & IRQF_FORCE_RESUME))
+				return;
+			/* Pretend that it got disabled ! */
+			desc->depth++;
+		}
 		desc->status &= ~IRQ_SUSPENDED;
+	}
 
 	switch (desc->depth) {
 	case 0:
Index: linux-next/kernel/irq/pm.c
===================================================================
--- linux-next.orig/kernel/irq/pm.c
+++ linux-next/kernel/irq/pm.c
@@ -53,9 +53,6 @@ void resume_device_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 
-		if (!(desc->status & IRQ_SUSPENDED))
-			continue;
-
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);


