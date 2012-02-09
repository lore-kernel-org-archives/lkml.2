Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2BICCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:02:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab2BICCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:02:01 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=rYfX9MgsDrgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=G5mlRFx8bqFMbdyekpYA:9 a=g6dIRhfFkwH_jhe_7G8A:7 a=Zh68SRI7RUMA:10 a=vC3kRYu6J5IA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120209020159.095037912@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 08 Feb 2012 20:59:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org,
        Lothar Wassmann <lw@karo-electronics.de>
Subject: [PATCH RT 1/8] genirq: Unmask oneshot irqs when thread was not woken
References: <20120209015926.851312665@goodmis.org>
Content-Disposition: inline; filename=0001-genirq-Unmask-oneshot-irqs-when-thread-was-not-woken.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

When the primary handler of an interrupt which is marked IRQ_ONESHOT
does not wake the thread (e.g. due to a spurious interrupt) then
nothing ever unmasks the interrupt line again. Handle it gracefully.

Cc: stable-rt@vger.kernel.org
Reported-by: Lothar Wassmann <lw@karo-electronics.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/irq/chip.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc5114b..3322a34 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -312,6 +312,24 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(handle_simple_irq);
 
+/*
+ * Called unconditionally from handle_level_irq() and only for oneshot
+ * interrupts from handle_fasteoi_irq()
+ */
+static void cond_unmask_irq(struct irq_desc *desc)
+{
+	/*
+	 * We need to unmask in the following cases:
+	 * - Standard level irq (IRQF_ONESHOT is not set)
+	 * - Oneshot irq which did not wake the thread (caused by a
+	 *   spurious interrupt or a primary handler handling it
+	 *   completely).
+	 */
+	if (!irqd_irq_disabled(&desc->irq_data) &&
+	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot)
+		unmask_irq(desc);
+}
+
 /**
  *	handle_level_irq - Level type irq handler
  *	@irq:	the interrupt number
@@ -344,8 +362,8 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 
 	handle_irq_event(desc);
 
-	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT))
-		unmask_irq(desc);
+	cond_unmask_irq(desc);
+
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -399,6 +417,9 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	preflow_handler(desc);
 	handle_irq_event(desc);
 
+	if (desc->istate & IRQS_ONESHOT)
+		cond_unmask_irq(desc);
+
 out_eoi:
 	desc->irq_data.chip->irq_eoi(&desc->irq_data);
 out_unlock:
-- 
1.7.8.3


