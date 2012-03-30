Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279Ab2C3Sqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:46:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:44484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761132Ab2C3Sq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792324"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 07/10] iommu/vt-d: Convert MSI remapping setup to remap_ops
Date: Fri, 30 Mar 2012 11:47:05 -0700
Message-Id: <1333133228-3134-8-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch introduces remapping-ops for setting ups MSI
interrupts.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/intr_remapping.h |   26 +++++++
 arch/x86/include/asm/irq_remapping.h  |   23 ------
 arch/x86/kernel/apic/io_apic.c        |  121 ++++++++-------------------------
 drivers/iommu/intel_intr_remapping.c  |   97 ++++++++++++++++++++++++++
 drivers/iommu/intr_remapping.c        |   35 ++++++++++
 drivers/iommu/intr_remapping.h        |   16 +++++
 6 files changed, 203 insertions(+), 115 deletions(-)

diff --git a/arch/x86/include/asm/intr_remapping.h b/arch/x86/include/asm/intr_remapping.h
index a195b7d..a6afd6e 100644
--- a/arch/x86/include/asm/intr_remapping.h
+++ b/arch/x86/include/asm/intr_remapping.h
@@ -26,6 +26,7 @@
 
 struct IO_APIC_route_entry;
 struct io_apic_irq_attr;
+struct pci_dev;
 
 extern int intr_remapping_enabled;
 
@@ -44,6 +45,13 @@ extern int intr_set_affinity(struct irq_data *data,
 			     const struct cpumask *mask,
 			     bool force);
 extern void intr_free_irq(int irq);
+extern void intr_compose_msi_msg(struct pci_dev *pdev,
+				 unsigned int irq, unsigned int dest,
+				 struct msi_msg *msg, u8 hpet_id);
+extern int intr_msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec);
+extern int intr_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
+			      int index, int sub_handle);
+extern int intr_setup_hpet_msi(unsigned int irq, unsigned int id);
 
 #else  /* CONFIG_IRQ_REMAP */
 
@@ -70,6 +78,24 @@ static inline int intr_set_affinity(struct irq_data *data,
 	return 0;
 }
 static inline void intr_free_irq(int irq) { }
+static inline void intr_compose_msi_msg(struct pci_dev *pdev,
+					unsigned int irq, unsigned int dest,
+					struct msi_msg *msg, u8 hpet_id)
+{
+}
+static inline int intr_msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
+{
+	return -ENODEV;
+}
+static inline int intr_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
+				     int index, int sub_handle)
+{
+	return -ENODEV;
+}
+static inline int intr_setup_hpet_msi(unsigned int irq, unsigned int id)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __X86_INTR_REMAPPING_H */
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 47d9993..0ddfc0b 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -5,34 +5,11 @@
 
 #ifdef CONFIG_IRQ_REMAP
 static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
-static inline void prepare_irte(struct irte *irte, int vector,
-			        unsigned int dest)
-{
-	memset(irte, 0, sizeof(*irte));
-
-	irte->present = 1;
-	irte->dst_mode = apic->irq_dest_mode;
-	/*
-	 * Trigger mode in the IRTE will always be edge, and for IO-APIC, the
-	 * actual level or edge trigger will be setup in the IO-APIC
-	 * RTE. This will help simplify level triggered irq migration.
-	 * For more details, see the comments (in io_apic.c) explainig IO-APIC
-	 * irq migration in the presence of interrupt-remapping.
-	*/
-	irte->trigger_mode = 0;
-	irte->dlvry_mode = apic->irq_delivery_mode;
-	irte->vector = vector;
-	irte->dest_id = IRTE_DEST(dest);
-	irte->redir_hint = 1;
-}
 static inline bool irq_remapped(struct irq_cfg *cfg)
 {
 	return cfg->irq_2_iommu.iommu != NULL;
 }
 #else
-static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
-{
-}
 static inline bool irq_remapped(struct irq_cfg *cfg)
 {
 	return false;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5690469..3db693b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3070,54 +3070,34 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
 	if (irq_remapped(cfg)) {
-		struct irte irte;
-		int ir_index;
-		u16 sub_handle;
-
-		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
-		BUG_ON(ir_index == -1);
-
-		prepare_irte(&irte, cfg->vector, dest);
-
-		/* Set source-id of interrupt request */
-		if (pdev)
-			set_msi_sid(&irte, pdev);
-		else
-			set_hpet_sid(&irte, hpet_id);
-
-		modify_irte(irq, &irte);
+		intr_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+		return err;
+	}
 
+	if (x2apic_enabled())
+		msg->address_hi = MSI_ADDR_BASE_HI |
+				  MSI_ADDR_EXT_DEST_ID(dest);
+	else
 		msg->address_hi = MSI_ADDR_BASE_HI;
-		msg->data = sub_handle;
-		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
-				  MSI_ADDR_IR_SHV |
-				  MSI_ADDR_IR_INDEX1(ir_index) |
-				  MSI_ADDR_IR_INDEX2(ir_index);
-	} else {
-		if (x2apic_enabled())
-			msg->address_hi = MSI_ADDR_BASE_HI |
-					  MSI_ADDR_EXT_DEST_ID(dest);
-		else
-			msg->address_hi = MSI_ADDR_BASE_HI;
 
-		msg->address_lo =
-			MSI_ADDR_BASE_LO |
-			((apic->irq_dest_mode == 0) ?
-				MSI_ADDR_DEST_MODE_PHYSICAL:
-				MSI_ADDR_DEST_MODE_LOGICAL) |
-			((apic->irq_delivery_mode != dest_LowestPrio) ?
-				MSI_ADDR_REDIRECTION_CPU:
-				MSI_ADDR_REDIRECTION_LOWPRI) |
-			MSI_ADDR_DEST_ID(dest);
+	msg->address_lo =
+		MSI_ADDR_BASE_LO |
+		((apic->irq_dest_mode == 0) ?
+			MSI_ADDR_DEST_MODE_PHYSICAL:
+			MSI_ADDR_DEST_MODE_LOGICAL) |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			MSI_ADDR_REDIRECTION_CPU:
+			MSI_ADDR_REDIRECTION_LOWPRI) |
+		MSI_ADDR_DEST_ID(dest);
+
+	msg->data =
+		MSI_DATA_TRIGGER_EDGE |
+		MSI_DATA_LEVEL_ASSERT |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			MSI_DATA_DELIVERY_FIXED:
+			MSI_DATA_DELIVERY_LOWPRI) |
+		MSI_DATA_VECTOR(cfg->vector);
 
-		msg->data =
-			MSI_DATA_TRIGGER_EDGE |
-			MSI_DATA_LEVEL_ASSERT |
-			((apic->irq_delivery_mode != dest_LowestPrio) ?
-				MSI_DATA_DELIVERY_FIXED:
-				MSI_DATA_DELIVERY_LOWPRI) |
-			MSI_DATA_VECTOR(cfg->vector);
-	}
 	return err;
 }
 
@@ -3160,33 +3140,6 @@ static struct irq_chip msi_chip = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-/*
- * Map the PCI dev to the corresponding remapping hardware unit
- * and allocate 'nvec' consecutive interrupt-remapping table entries
- * in it.
- */
-static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
-{
-	struct intel_iommu *iommu;
-	int index;
-
-	iommu = map_dev_to_ir(dev);
-	if (!iommu) {
-		printk(KERN_ERR
-		       "Unable to map PCI %s to iommu\n", pci_name(dev));
-		return -ENOENT;
-	}
-
-	index = alloc_irte(iommu, irq, nvec);
-	if (index < 0) {
-		printk(KERN_ERR
-		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
-		       pci_name(dev));
-		return -ENOSPC;
-	}
-	return index;
-}
-
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	struct irq_chip *chip = &msi_chip;
@@ -3217,7 +3170,6 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	int node, ret, sub_handle, index = 0;
 	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
-	struct intel_iommu *iommu = NULL;
 
 	/* x86 doesn't support multiple MSI yet */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
@@ -3239,23 +3191,15 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			 * allocate the consecutive block of IRTE's
 			 * for 'nvec'
 			 */
-			index = msi_alloc_irte(dev, irq, nvec);
+			index = intr_msi_alloc_irq(dev, irq, nvec);
 			if (index < 0) {
 				ret = index;
 				goto error;
 			}
 		} else {
-			iommu = map_dev_to_ir(dev);
-			if (!iommu) {
-				ret = -ENOENT;
+			ret = intr_msi_setup_irq(dev, irq, index, sub_handle);
+			if (ret < 0)
 				goto error;
-			}
-			/*
-			 * setup the mapping between the irq and the IRTE
-			 * base index, the sub_handle pointing to the
-			 * appropriate interrupt remap table entry.
-			 */
-			set_irte_irq(irq, iommu, index, sub_handle);
 		}
 no_ir:
 		ret = setup_msi_irq(dev, msidesc, irq);
@@ -3374,14 +3318,7 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 	int ret;
 
 	if (intr_remapping_enabled) {
-		struct intel_iommu *iommu = map_hpet_to_ir(id);
-		int index;
-
-		if (!iommu)
-			return -1;
-
-		index = alloc_irte(iommu, irq, 1);
-		if (index < 0)
+		if (!intr_setup_hpet_msi(irq, id))
 			return -1;
 	}
 
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
index 44a6e04..a3bae67 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -13,6 +13,7 @@
 #include <acpi/acpi.h>
 #include <asm/intr_remapping.h>
 #include <asm/pci-direct.h>
+#include <asm/msidef.h>
 
 #include "intr_remapping.h"
 
@@ -955,6 +956,98 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return 0;
 }
 
+static void intel_compose_msi_msg(struct pci_dev *pdev,
+				  unsigned int irq, unsigned int dest,
+				  struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_cfg *cfg;
+	struct irte irte;
+	u16 sub_handle;
+	int ir_index;
+
+	cfg = irq_get_chip_data(irq);
+
+	ir_index = map_irq_to_irte_handle(irq, &sub_handle);
+	BUG_ON(ir_index == -1);
+
+	prepare_irte(&irte, cfg->vector, dest);
+
+	/* Set source-id of interrupt request */
+	if (pdev)
+		set_msi_sid(&irte, pdev);
+	else
+		set_hpet_sid(&irte, hpet_id);
+
+	modify_irte(irq, &irte);
+
+	msg->address_hi = MSI_ADDR_BASE_HI;
+	msg->data = sub_handle;
+	msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+			  MSI_ADDR_IR_SHV |
+			  MSI_ADDR_IR_INDEX1(ir_index) |
+			  MSI_ADDR_IR_INDEX2(ir_index);
+}
+
+/*
+ * Map the PCI dev to the corresponding remapping hardware unit
+ * and allocate 'nvec' consecutive interrupt-remapping table entries
+ * in it.
+ */
+static int intel_msi_alloc_irq(struct pci_dev *dev, int irq, int nvec)
+{
+	struct intel_iommu *iommu;
+	int index;
+
+	iommu = map_dev_to_ir(dev);
+	if (!iommu) {
+		printk(KERN_ERR
+		       "Unable to map PCI %s to iommu\n", pci_name(dev));
+		return -ENOENT;
+	}
+
+	index = alloc_irte(iommu, irq, nvec);
+	if (index < 0) {
+		printk(KERN_ERR
+		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
+		       pci_name(dev));
+		return -ENOSPC;
+	}
+	return index;
+}
+
+static int intel_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
+			       int index, int sub_handle)
+{
+	struct intel_iommu *iommu;
+
+	iommu = map_dev_to_ir(pdev);
+	if (!iommu)
+		return -ENOENT;
+	/*
+	 * setup the mapping between the irq and the IRTE
+	 * base index, the sub_handle pointing to the
+	 * appropriate interrupt remap table entry.
+	 */
+	set_irte_irq(irq, iommu, index, sub_handle);
+
+	return 0;
+}
+
+static int intel_setup_hpet_msi(unsigned int irq, unsigned int id)
+{
+	struct intel_iommu *iommu = map_hpet_to_ir(id);
+	int index;
+
+	if (!iommu)
+		return -1;
+
+	index = alloc_irte(iommu, irq, 1);
+	if (index < 0)
+		return -1;
+
+	return 0;
+}
+
 struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_intr_remapping_supported,
 	.hardware_init		= dmar_table_init,
@@ -965,4 +1058,8 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.setup_ioapic_entry	= intel_setup_ioapic_entry,
 	.set_affinity		= intel_ioapic_set_affinity,
 	.free_irq		= free_irte,
+	.compose_msi_msg	= intel_compose_msi_msg,
+	.msi_alloc_irq		= intel_msi_alloc_irq,
+	.msi_setup_irq		= intel_msi_setup_irq,
+	.setup_hpet_msi		= intel_setup_hpet_msi,
 };
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index a68d304..9dc1793 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -127,3 +127,38 @@ void intr_free_irq(int irq)
 
 	remap_ops->free_irq(irq);
 }
+
+void intr_compose_msi_msg(struct pci_dev *pdev,
+			  unsigned int irq, unsigned int dest,
+			  struct msi_msg *msg, u8 hpet_id)
+{
+	if (!remap_ops || !remap_ops->compose_msi_msg)
+		return;
+
+	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+}
+
+int intr_msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
+{
+	if (!remap_ops || !remap_ops->msi_alloc_irq)
+		return -ENODEV;
+
+	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
+}
+
+int intr_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
+		       int index, int sub_handle)
+{
+	if (!remap_ops || !remap_ops->msi_setup_irq)
+		return -ENODEV;
+
+	return remap_ops->msi_setup_irq(pdev, irq, index, sub_handle);
+}
+
+int intr_setup_hpet_msi(unsigned int irq, unsigned int id)
+{
+	if (!remap_ops || !remap_ops->setup_hpet_msi)
+		return -ENODEV;
+
+	return remap_ops->setup_hpet_msi(irq, id);
+}
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
index 5748553..6f4ea0a 100644
--- a/drivers/iommu/intr_remapping.h
+++ b/drivers/iommu/intr_remapping.h
@@ -28,6 +28,8 @@ struct IO_APIC_route_entry;
 struct io_apic_irq_attr;
 struct irq_data;
 struct cpumask;
+struct pci_dev;
+struct msi_msg;
 
 extern int disable_intremap;
 extern int disable_sourceid_checking;
@@ -63,6 +65,20 @@ struct irq_remap_ops {
 
 	/* Free an IRQ */
 	int (*free_irq)(int);
+
+	/* Create MSI msg to use for interrupt remapping */
+	void (*compose_msi_msg)(struct pci_dev *,
+				unsigned int, unsigned int,
+				struct msi_msg *, u8);
+
+	/* Allocate remapping resources for MSI */
+	int (*msi_alloc_irq)(struct pci_dev *, int, int);
+
+	/* Setup the remapped MSI irq */
+	int (*msi_setup_irq)(struct pci_dev *, unsigned int, int, int);
+
+	/* Setup interrupt remapping for an HPET MSI */
+	int (*setup_hpet_msi)(unsigned int, unsigned int);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
-- 
1.7.6.5

