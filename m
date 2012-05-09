Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab2EISne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:43:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:18662 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760002Ab2EISnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98208729"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@kernel.org, tglx@linutronix.de
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joerg.roedel@amd.com,
        paul.gortmaker@windriver.com
Subject: [PATCH 2/2] irq: use config_enabled(SMP) checks to cleanup irq_set_affinity() for UP
Date: Wed,  9 May 2012 11:46:36 -0700
Message-Id: <1336589196-14498-2-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
References: <20120509093001.GD8585@gmail.com>
 <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use config_enabled(SMP) checks for cleaning up the ifdef CONFIG_SMP around
irq_set_affinity routines in io_apic and irq_remapping subsystems.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c      |  173 +++++++++++++++++------------------
 drivers/iommu/intel_irq_remapping.c |    7 +-
 drivers/iommu/irq_remapping.c       |    5 +-
 drivers/iommu/irq_remapping.h       |    2 -
 include/linux/irq.h                 |    2 -
 5 files changed, 89 insertions(+), 100 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ffdc152..f8f3469 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2221,71 +2221,6 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 	cfg->move_in_progress = 0;
 }
 
-static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
-{
-	int apic, pin;
-	struct irq_pin_list *entry;
-	u8 vector = cfg->vector;
-
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		unsigned int reg;
-
-		apic = entry->apic;
-		pin = entry->pin;
-		/*
-		 * With interrupt-remapping, destination information comes
-		 * from interrupt-remapping table entry.
-		 */
-		if (!irq_remapped(cfg))
-			io_apic_write(apic, 0x11 + pin*2, dest);
-		reg = io_apic_read(apic, 0x10 + pin*2);
-		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
-		reg |= vector;
-		io_apic_modify(apic, 0x10 + pin*2, reg);
-	}
-}
-
-/*
- * Either sets data->affinity to a valid value, and returns
- * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
- * leaves data->affinity untouched.
- */
-int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			  unsigned int *dest_id)
-{
-	struct irq_cfg *cfg = data->chip_data;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return -1;
-
-	if (assign_irq_vector(data->irq, data->chip_data, mask))
-		return -1;
-
-	cpumask_copy(data->affinity, mask);
-
-	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
-	return 0;
-}
-
-static int
-ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		    bool force)
-{
-	unsigned int dest, irq = data->irq;
-	unsigned long flags;
-	int ret;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	ret = __ioapic_set_affinity(data, mask, &dest);
-	if (!ret) {
-		/* Only the high 8 bits are valid. */
-		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, data->chip_data);
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-	return ret;
-}
-
 asmlinkage void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
@@ -2373,6 +2308,78 @@ void irq_force_complete_move(int irq)
 static inline void irq_complete_move(struct irq_cfg *cfg) { }
 #endif
 
+static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
+{
+	int apic, pin;
+	struct irq_pin_list *entry;
+	u8 vector = cfg->vector;
+
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
+		unsigned int reg;
+
+		apic = entry->apic;
+		pin = entry->pin;
+		/*
+		 * With interrupt-remapping, destination information comes
+		 * from interrupt-remapping table entry.
+		 */
+		if (!irq_remapped(cfg))
+			io_apic_write(apic, 0x11 + pin*2, dest);
+		reg = io_apic_read(apic, 0x10 + pin*2);
+		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
+		reg |= vector;
+		io_apic_modify(apic, 0x10 + pin*2, reg);
+	}
+}
+
+/*
+ * Either sets data->affinity to a valid value, and returns
+ * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
+ * leaves data->affinity untouched.
+ */
+int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			  unsigned int *dest_id)
+{
+	struct irq_cfg *cfg = data->chip_data;
+
+	if (!config_enabled(SMP))
+		return -1;
+
+	if (!cpumask_intersects(mask, cpu_online_mask))
+		return -1;
+
+	if (assign_irq_vector(data->irq, data->chip_data, mask))
+		return -1;
+
+	cpumask_copy(data->affinity, mask);
+
+	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
+	return 0;
+}
+
+static int
+ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		    bool force)
+{
+	unsigned int dest, irq = data->irq;
+	unsigned long flags;
+	int ret;
+
+	if (!config_enabled(SMP))
+		return -1;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	ret = __ioapic_set_affinity(data, mask, &dest);
+	if (!ret) {
+		/* Only the high 8 bits are valid. */
+		dest = SET_APIC_LOGICAL_ID(dest);
+		__target_IO_APIC_irq(irq, dest, data->chip_data);
+	}
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+	return ret;
+}
+
+
 static void ack_apic_edge(struct irq_data *data)
 {
 	irq_complete_move(data->chip_data);
@@ -2552,9 +2559,7 @@ static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_ack = ir_ack_apic_edge;
 	chip->irq_eoi = ir_ack_apic_level;
 
-#ifdef CONFIG_SMP
 	chip->irq_set_affinity = set_remapped_irq_affinity;
-#endif
 }
 #endif /* CONFIG_IRQ_REMAP */
 
@@ -2565,9 +2570,7 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_unmask		= unmask_ioapic_irq,
 	.irq_ack		= ack_apic_edge,
 	.irq_eoi		= ack_apic_level,
-#ifdef CONFIG_SMP
 	.irq_set_affinity	= ioapic_set_affinity,
-#endif
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
@@ -3083,7 +3086,6 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	return err;
 }
 
-#ifdef CONFIG_SMP
 static int
 msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 {
@@ -3091,6 +3093,9 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	struct msi_msg msg;
 	unsigned int dest;
 
+	if (!config_enabled(SMP))
+		return -1;
+
 	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
@@ -3105,7 +3110,6 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 
 	return 0;
 }
-#endif /* CONFIG_SMP */
 
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
@@ -3116,9 +3120,7 @@ static struct irq_chip msi_chip = {
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
 	.irq_ack		= ack_apic_edge,
-#ifdef CONFIG_SMP
 	.irq_set_affinity	= msi_set_affinity,
-#endif
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
@@ -3203,7 +3205,6 @@ void native_teardown_msi_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_DMAR_TABLE
-#ifdef CONFIG_SMP
 static int
 dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		      bool force)
@@ -3212,6 +3213,9 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	unsigned int dest, irq = data->irq;
 	struct msi_msg msg;
 
+	if (!config_enabled(SMP))
+		return -1;
+
 	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
@@ -3228,16 +3232,12 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return 0;
 }
 
-#endif /* CONFIG_SMP */
-
 static struct irq_chip dmar_msi_type = {
 	.name			= "DMAR_MSI",
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
 	.irq_ack		= ack_apic_edge,
-#ifdef CONFIG_SMP
 	.irq_set_affinity	= dmar_msi_set_affinity,
-#endif
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
@@ -3258,7 +3258,6 @@ int arch_setup_dmar_msi(unsigned int irq)
 
 #ifdef CONFIG_HPET_TIMER
 
-#ifdef CONFIG_SMP
 static int hpet_msi_set_affinity(struct irq_data *data,
 				 const struct cpumask *mask, bool force)
 {
@@ -3266,6 +3265,9 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	struct msi_msg msg;
 	unsigned int dest;
 
+	if (!config_enabled(SMP))
+		return -1;
+
 	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
@@ -3281,16 +3283,12 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	return 0;
 }
 
-#endif /* CONFIG_SMP */
-
 static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
 	.irq_ack = ack_apic_edge,
-#ifdef CONFIG_SMP
 	.irq_set_affinity = hpet_msi_set_affinity,
-#endif
 	.irq_retrigger = ioapic_retrigger_irq,
 };
 
@@ -3325,8 +3323,6 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
  */
 #ifdef CONFIG_HT_IRQ
 
-#ifdef CONFIG_SMP
-
 static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 {
 	struct ht_irq_msg msg;
@@ -3347,6 +3343,9 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned int dest;
 
+	if (!config_enabled(SMP))
+		return -1;
+
 	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
@@ -3354,16 +3353,12 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	return 0;
 }
 
-#endif
-
 static struct irq_chip ht_irq_chip = {
 	.name			= "PCI-HT",
 	.irq_mask		= mask_ht_irq,
 	.irq_unmask		= unmask_ht_irq,
 	.irq_ack		= ack_apic_edge,
-#ifdef CONFIG_SMP
 	.irq_set_affinity	= ht_set_affinity,
-#endif
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 6d34706..b3481cf 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -902,7 +902,6 @@ static int intel_setup_ioapic_entry(int irq,
 	return 0;
 }
 
-#ifdef CONFIG_SMP
 /*
  * Migrate the IO-APIC irq in the presence of intr-remapping.
  *
@@ -925,6 +924,9 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	unsigned int dest, irq = data->irq;
 	struct irte irte;
 
+	if (!config_enabled(CONFIG_SMP))
+		return -EINVAL;
+
 	if (!cpumask_intersects(mask, cpu_online_mask))
 		return -EINVAL;
 
@@ -956,7 +958,6 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	cpumask_copy(data->affinity, mask);
 	return 0;
 }
-#endif
 
 static void intel_compose_msi_msg(struct pci_dev *pdev,
 				  unsigned int irq, unsigned int dest,
@@ -1058,9 +1059,7 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.reenable		= reenable_irq_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
 	.setup_ioapic_entry	= intel_setup_ioapic_entry,
-#ifdef CONFIG_SMP
 	.set_affinity		= intel_ioapic_set_affinity,
-#endif
 	.free_irq		= free_irte,
 	.compose_msi_msg	= intel_compose_msi_msg,
 	.msi_alloc_irq		= intel_msi_alloc_irq,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 40cda8e..1d29b1c 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -111,16 +111,15 @@ int setup_ioapic_remapped_entry(int irq,
 					     vector, attr);
 }
 
-#ifdef CONFIG_SMP
 int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 			      bool force)
 {
-	if (!remap_ops || !remap_ops->set_affinity)
+	if (!config_enabled(CONFIG_SMP) || !remap_ops ||
+	    !remap_ops->set_affinity)
 		return 0;
 
 	return remap_ops->set_affinity(data, mask, force);
 }
-#endif
 
 void free_remapped_irq(int irq)
 {
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index be9d729..b12974c 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -59,11 +59,9 @@ struct irq_remap_ops {
 				  unsigned int, int,
 				  struct io_apic_irq_attr *);
 
-#ifdef CONFIG_SMP
 	/* Set the CPU affinity of a remapped interrupt */
 	int (*set_affinity)(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
-#endif
 
 	/* Free an IRQ */
 	int (*free_irq)(int);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index b27cfcf..008d4ec 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -150,9 +150,7 @@ struct irq_data {
 	void			*handler_data;
 	void			*chip_data;
 	struct msi_desc		*msi_desc;
-#ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
-#endif
 };
 
 /*
-- 
1.7.6.5

