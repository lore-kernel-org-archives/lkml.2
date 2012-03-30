Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296Ab2C3Sqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:46:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:39299 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761121Ab2C3Sq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792306"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 05/10] iommu/vt-d: Convert IR set_affinity function to remap_ops
Date: Fri, 30 Mar 2012 11:47:03 -0700
Message-Id: <1333133228-3134-6-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The function to set interrupt affinity with interrupt
remapping enabled is Intel specific too. So move it to the
irq_remap_ops too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/intr_remapping.h |    9 ++++
 arch/x86/kernel/apic/io_apic.c        |   69 +--------------------------------
 drivers/iommu/intel_intr_remapping.c  |   54 +++++++++++++++++++++++++
 drivers/iommu/intr_remapping.c        |    9 ++++
 drivers/iommu/intr_remapping.h        |    6 +++
 5 files changed, 80 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/intr_remapping.h b/arch/x86/include/asm/intr_remapping.h
index a22e1f1..ae933ec 100644
--- a/arch/x86/include/asm/intr_remapping.h
+++ b/arch/x86/include/asm/intr_remapping.h
@@ -40,6 +40,9 @@ extern int intr_setup_ioapic_entry(int irq,
 				   struct IO_APIC_route_entry *entry,
 				   unsigned int destination, int vector,
 				   struct io_apic_irq_attr *attr);
+extern int intr_set_affinity(struct irq_data *data,
+			     const struct cpumask *mask,
+			     bool force);
 
 #else  /* CONFIG_IRQ_REMAP */
 
@@ -59,6 +62,12 @@ static inline int intr_setup_ioapic_entry(int irq,
 {
 	return -ENODEV;
 }
+static inline int intr_set_affinity(struct irq_data *data,
+				    const struct cpumask *mask,
+				    bool force)
+{
+	return 0;
+}
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __X86_INTR_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e1ab625..a97c79a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2327,71 +2327,6 @@ ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
-#ifdef CONFIG_IRQ_REMAP
-
-/*
- * Migrate the IO-APIC irq in the presence of intr-remapping.
- *
- * For both level and edge triggered, irq migration is a simple atomic
- * update(of vector and cpu destination) of IRTE and flush the hardware cache.
- *
- * For level triggered, we eliminate the io-apic RTE modification (with the
- * updated vector information), by using a virtual vector (io-apic pin number).
- * Real vector that is used for interrupting cpu will be coming from
- * the interrupt-remapping table entry.
- *
- * As the migration is a simple atomic update of IRTE, the same mechanism
- * is used to migrate MSI irq's in the presence of interrupt-remapping.
- */
-static int
-ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		       bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int dest, irq = data->irq;
-	struct irte irte;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return -EINVAL;
-
-	if (get_irte(irq, &irte))
-		return -EBUSY;
-
-	if (assign_irq_vector(irq, cfg, mask))
-		return -EBUSY;
-
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
-
-	irte.vector = cfg->vector;
-	irte.dest_id = IRTE_DEST(dest);
-
-	/*
-	 * Atomically updates the IRTE with the new destination, vector
-	 * and flushes the interrupt entry cache.
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
-	cpumask_copy(data->affinity, mask);
-	return 0;
-}
-
-#else
-static inline int
-ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		       bool force)
-{
-	return 0;
-}
-#endif
-
 asmlinkage void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
@@ -2636,7 +2571,7 @@ static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_eoi = ir_ack_apic_level;
 
 #ifdef CONFIG_SMP
-	chip->irq_set_affinity = ir_ioapic_set_affinity;
+	chip->irq_set_affinity = intr_set_affinity;
 #endif
 }
 #endif /* CONFIG_IRQ_REMAP */
@@ -3826,7 +3761,7 @@ void __init setup_ioapic_dest(void)
 			mask = apic->target_cpus();
 
 		if (intr_remapping_enabled)
-			ir_ioapic_set_affinity(idata, mask, false);
+			intr_set_affinity(idata, mask, false);
 		else
 			ioapic_set_affinity(idata, mask, false);
 	}
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
index f495eba..25372c1 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -901,6 +901,59 @@ static int intel_setup_ioapic_entry(int irq,
 	return 0;
 }
 
+/*
+ * Migrate the IO-APIC irq in the presence of intr-remapping.
+ *
+ * For both level and edge triggered, irq migration is a simple atomic
+ * update(of vector and cpu destination) of IRTE and flush the hardware cache.
+ *
+ * For level triggered, we eliminate the io-apic RTE modification (with the
+ * updated vector information), by using a virtual vector (io-apic pin number).
+ * Real vector that is used for interrupting cpu will be coming from
+ * the interrupt-remapping table entry.
+ *
+ * As the migration is a simple atomic update of IRTE, the same mechanism
+ * is used to migrate MSI irq's in the presence of interrupt-remapping.
+ */
+static int
+intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			  bool force)
+{
+	struct irq_cfg *cfg = data->chip_data;
+	unsigned int dest, irq = data->irq;
+	struct irte irte;
+
+	if (!cpumask_intersects(mask, cpu_online_mask))
+		return -EINVAL;
+
+	if (get_irte(irq, &irte))
+		return -EBUSY;
+
+	if (assign_irq_vector(irq, cfg, mask))
+		return -EBUSY;
+
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
+
+	irte.vector = cfg->vector;
+	irte.dest_id = IRTE_DEST(dest);
+
+	/*
+	 * Atomically updates the IRTE with the new destination, vector
+	 * and flushes the interrupt entry cache.
+	 */
+	modify_irte(irq, &irte);
+
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
+	cpumask_copy(data->affinity, mask);
+	return 0;
+}
 
 struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_intr_remapping_supported,
@@ -910,4 +963,5 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.hardware_reenable	= reenable_intr_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
 	.setup_ioapic_entry	= intel_setup_ioapic_entry,
+	.set_affinity		= intel_ioapic_set_affinity,
 };
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 739148a..2f4f27f 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -110,3 +110,12 @@ int intr_setup_ioapic_entry(int irq,
 	return remap_ops->setup_ioapic_entry(irq, entry, destination,
 					     vector, attr);
 }
+
+int intr_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      bool force)
+{
+	if (!remap_ops || !remap_ops->set_affinity)
+		return 0;
+
+	return remap_ops->set_affinity(data, mask, force);
+}
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
index e8994f2..e0bc6e0 100644
--- a/drivers/iommu/intr_remapping.h
+++ b/drivers/iommu/intr_remapping.h
@@ -26,6 +26,8 @@
 
 struct IO_APIC_route_entry;
 struct io_apic_irq_attr;
+struct irq_data;
+struct cpumask;
 
 extern int disable_intremap;
 extern int disable_sourceid_checking;
@@ -54,6 +56,10 @@ struct irq_remap_ops {
 	int (*setup_ioapic_entry)(int irq, struct IO_APIC_route_entry *,
 				  unsigned int, int,
 				  struct io_apic_irq_attr *);
+
+	/* Set the CPU affinity of a remapped interrupt */
+	int (*set_affinity)(struct irq_data *data, const struct cpumask *mask,
+			    bool force);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
-- 
1.7.6.5

