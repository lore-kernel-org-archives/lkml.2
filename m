Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1BJXw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:52:57 -0500
Received: from www.tglx.de ([62.245.132.106]:43894 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab1BJXgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:09 -0500
Message-Id: <20110210223254.709922870@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:35:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 04/75] genirq: Always apply cpu online mask
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-truncate-mask-if-affinity-was-set.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the affinity had been set by the user, then a later request_irq()
will honour that setting. But online cpus can have changed. So apply
the online mask and for this case as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -256,6 +256,8 @@ EXPORT_SYMBOL_GPL(irq_set_affinity_notif
  */
 static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 {
+	struct cpumask *set = irq_default_affinity;
+
 	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
 		return 0;
@@ -265,15 +267,13 @@ static int setup_affinity(unsigned int i
 	 * one of the targets is online.
 	 */
 	if (desc->status & (IRQ_AFFINITY_SET)) {
-		if (cpumask_any_and(desc->irq_data.affinity, cpu_online_mask)
-		    < nr_cpu_ids)
-			goto set_affinity;
+		if (cpumask_intersects(desc->irq_data.affinity,
+				       cpu_online_mask))
+			set = desc->irq_data.affinity;
 		else
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
-
-	cpumask_and(desc->irq_data.affinity, cpu_online_mask, irq_default_affinity);
-set_affinity:
+	cpumask_and(desc->irq_data.affinity, cpu_online_mask, set);
 	desc->irq_data.chip->irq_set_affinity(&desc->irq_data, desc->irq_data.affinity, false);
 
 	return 0;


