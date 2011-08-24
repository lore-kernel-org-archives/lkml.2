Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab1HXAuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:50:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:62032 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab1HXAtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41195058"
Message-Id: <20110824001456.452760446@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:23 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 6/8] x86, msi, intr-remap: use the ioapic set affinity routine
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=remove_ir_msi_set_affinity.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ set affinity routine is same for the IO-APIC IRQ's aswell as the MSI
IRQ's in the presence of interrupt-remapping. This is because we modify
the interrupt-remapping table entry and doesn't touch the IO-APIC RTE or the
MSI entry.

So remove the ir_msi_set_affinity() and re-use the ir_ioapic_set_affinity()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   54 +++++++++--------------------------------
 1 file changed, 12 insertions(+), 42 deletions(-)

Index: tree/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tree.orig/arch/x86/kernel/apic/io_apic.c
+++ tree/arch/x86/kernel/apic/io_apic.c
@@ -2267,6 +2267,9 @@ ioapic_set_affinity(struct irq_data *dat
  * updated vector information), by using a virtual vector (io-apic pin number).
  * Real vector that is used for interrupting cpu will be coming from
  * the interrupt-remapping table entry.
+ *
+ * As the migration is a simple atomic update of IRTE, the same mechanism
+ * is used to migrate MSI irq's in the presence of interrupt-remapping.
  */
 static int
 ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
@@ -2291,10 +2294,16 @@ ir_ioapic_set_affinity(struct irq_data *
 	irte.dest_id = IRTE_DEST(dest);
 
 	/*
-	 * Modified the IRTE and flushes the Interrupt entry cache.
+	 * Atomically updates the IRTE with the new destination, vector
+	 * and flushes the interrupt entry cache.
 	 */
 	modify_irte(irq, &irte);
 
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
@@ -3144,45 +3153,6 @@ msi_set_affinity(struct irq_data *data, 
 
 	return 0;
 }
-#ifdef CONFIG_INTR_REMAP
-/*
- * Migrate the MSI irq to another cpumask. This migration is
- * done in the process context using interrupt-remapping hardware.
- */
-static int
-ir_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		    bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int dest, irq = data->irq;
-	struct irte irte;
-
-	if (get_irte(irq, &irte))
-		return -1;
-
-	if (__ioapic_set_affinity(data, mask, &dest))
-		return -1;
-
-	irte.vector = cfg->vector;
-	irte.dest_id = IRTE_DEST(dest);
-
-	/*
-	 * atomically update the IRTE with the new destination and vector.
-	 */
-	modify_irte(irq, &irte);
-
-	/*
-	 * After this point, all the interrupts will start arriving
-	 * at the new destination. So, time to cleanup the previous
-	 * vector allocation.
-	 */
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
-
-	return 0;
-}
-
-#endif
 #endif /* CONFIG_SMP */
 
 /*
@@ -3207,7 +3177,7 @@ static struct irq_chip msi_ir_chip = {
 #ifdef CONFIG_INTR_REMAP
 	.irq_ack		= ir_ack_apic_edge,
 #ifdef CONFIG_SMP
-	.irq_set_affinity	= ir_msi_set_affinity,
+	.irq_set_affinity	= ir_ioapic_set_affinity,
 #endif
 #endif
 	.irq_retrigger		= ioapic_retrigger_irq,
@@ -3416,7 +3386,7 @@ static struct irq_chip ir_hpet_msi_type 
 #ifdef CONFIG_INTR_REMAP
 	.irq_ack		= ir_ack_apic_edge,
 #ifdef CONFIG_SMP
-	.irq_set_affinity	= ir_msi_set_affinity,
+	.irq_set_affinity	= ir_ioapic_set_affinity,
 #endif
 #endif
 	.irq_retrigger		= ioapic_retrigger_irq,


