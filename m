Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032071Ab2CORkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:40:12 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:44994
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030925Ab2CORkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:40:04 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zzea8Nzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0XT2M-01-13Q-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] iommu/vt-d: Convert IR set_affinity function to remap_ops
Date: Thu, 15 Mar 2012 18:39:48 +0100
Message-ID: <1331833191-25779-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
References: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function to set interrupt affinity with interrupt
remapping enabled is Intel specific too. So move it to the
irq_remap_ops too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
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
index 4746ba1..101090a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2288,71 +2288,6 @@ ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
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
@@ -2576,7 +2511,7 @@ static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_eoi = ir_ack_apic_level;
 
 #ifdef CONFIG_SMP
-	chip->irq_set_affinity = ir_ioapic_set_affinity;
+	chip->irq_set_affinity = intr_set_affinity;
 #endif
 }
 #endif /* CONFIG_IRQ_REMAP */
@@ -3766,7 +3701,7 @@ void __init setup_ioapic_dest(void)
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
1.7.5.4


