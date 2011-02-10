Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1BJXkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:40:03 -0500
Received: from www.tglx.de ([62.245.132.106]:44573 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421Ab1BJXin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:43 -0500
Message-Id: <20110210223301.147770641@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 71/75] x86: ioapic: Use irq_data->state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=x86-ioapic-use-irqdata-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the state information in irq_data. That avoids a radix-tree lookup
from apic_ack_level() and simplifies setup_ioapic_dest().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -2462,7 +2462,7 @@ static void ack_apic_level(struct irq_da
 	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irqd_is_setaffinity_pending(data))) {
 		do_unmask_irq = 1;
 		mask_ioapic(cfg);
 	}
@@ -3868,8 +3868,8 @@ int acpi_get_override_irq(u32 gsi, int *
 void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
-	struct irq_desc *desc;
 	const struct cpumask *mask;
+	struct irq_data *idata;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -3884,21 +3884,20 @@ void __init setup_ioapic_dest(void)
 		if ((ioapic > 0) && (irq > 16))
 			continue;
 
-		desc = irq_to_desc(irq);
+		idata = irq_get_irq_data(irq);
 
 		/*
 		 * Honour affinities which have been set in early boot
 		 */
-		if (desc->status &
-		    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-			mask = desc->irq_data.affinity;
+		if (!irqd_can_balance(idata) || irqd_affinity_was_set(idata))
+			mask = idata->affinity;
 		else
 			mask = apic->target_cpus();
 
 		if (intr_remapping_enabled)
-			ir_ioapic_set_affinity(&desc->irq_data, mask, false);
+			ir_ioapic_set_affinity(idata, mask, false);
 		else
-			ioapic_set_affinity(&desc->irq_data, mask, false);
+			ioapic_set_affinity(idata, mask, false);
 	}
 
 }


