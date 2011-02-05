Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1BEUJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:09:07 -0500
Received: from www.tglx.de ([62.245.132.106]:44518 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab1BEUJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:09:04 -0500
Message-Id: <20110205200704.121667985@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 20:08:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 4/4] xen: Use IRQF_FORCE_RESUME
References: <20110205200108.921707839@linutronix.de>
Content-Disposition: inline; filename=xen-use-IRQF_FORCE_RESUME.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the IRQF_NO_SUSPEND interrupts IRQF_FORCE_RESUME and remove the extra
walk through the interrupt descriptors.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/events.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

Index: linux-next/drivers/xen/events.c
===================================================================
--- linux-next.orig/drivers/xen/events.c
+++ linux-next/drivers/xen/events.c
@@ -973,7 +973,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
@@ -1429,7 +1429,6 @@ void xen_poll_irq(int irq)
 void xen_irq_resume(void)
 {
 	unsigned int cpu, irq, evtchn;
-	struct irq_desc *desc;
 
 	init_evtchn_cpu_bindings();
 
@@ -1449,23 +1448,6 @@ void xen_irq_resume(void)
 		restore_cpu_ipis(cpu);
 	}
 
-	/*
-	 * Unmask any IRQF_NO_SUSPEND IRQs which are enabled. These
-	 * are not handled by the IRQ core.
-	 */
-	for_each_irq_desc(irq, desc) {
-		if (!desc->action || !(desc->action->flags & IRQF_NO_SUSPEND))
-			continue;
-		if (desc->status & IRQ_DISABLED)
-			continue;
-
-		evtchn = evtchn_from_irq(irq);
-		if (evtchn == -1)
-			continue;
-
-		unmask_evtchn(evtchn);
-	}
-
 	restore_cpu_pirqs();
 }
 


