Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333Ab2C3SsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:48:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:8977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761130Ab2C3Sq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792314"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 06/10] iommu/vt-d: Convert free_irte into a remap_ops callback
Date: Fri, 30 Mar 2012 11:47:04 -0700
Message-Id: <1333133228-3134-7-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The operation for releasing a remapping entry is iommu
specific too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/intr_remapping.h |    2 ++
 arch/x86/kernel/apic/io_apic.c        |    2 +-
 drivers/iommu/intel_intr_remapping.c  |    3 ++-
 drivers/iommu/intr_remapping.c        |    8 ++++++++
 drivers/iommu/intr_remapping.h        |    3 +++
 include/linux/dmar.h                  |    5 -----
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/intr_remapping.h b/arch/x86/include/asm/intr_remapping.h
index ae933ec..a195b7d 100644
--- a/arch/x86/include/asm/intr_remapping.h
+++ b/arch/x86/include/asm/intr_remapping.h
@@ -43,6 +43,7 @@ extern int intr_setup_ioapic_entry(int irq,
 extern int intr_set_affinity(struct irq_data *data,
 			     const struct cpumask *mask,
 			     bool force);
+extern void intr_free_irq(int irq);
 
 #else  /* CONFIG_IRQ_REMAP */
 
@@ -68,6 +69,7 @@ static inline int intr_set_affinity(struct irq_data *data,
 {
 	return 0;
 }
+static inline void intr_free_irq(int irq) { }
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __X86_INTR_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a97c79a..5690469 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3041,7 +3041,7 @@ void destroy_irq(unsigned int irq)
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
 	if (irq_remapped(cfg))
-		free_irte(irq);
+		intr_free_irq(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
index 25372c1..44a6e04 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -253,7 +253,7 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
 	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 }
 
-int free_irte(int irq)
+static int free_irte(int irq)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	unsigned long flags;
@@ -964,4 +964,5 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.enable_faulting	= enable_drhd_fault_handling,
 	.setup_ioapic_entry	= intel_setup_ioapic_entry,
 	.set_affinity		= intel_ioapic_set_affinity,
+	.free_irq		= free_irte,
 };
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 2f4f27f..a68d304 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -119,3 +119,11 @@ int intr_set_affinity(struct irq_data *data, const struct cpumask *mask,
 
 	return remap_ops->set_affinity(data, mask, force);
 }
+
+void intr_free_irq(int irq)
+{
+	if (!remap_ops || !remap_ops->free_irq)
+		return;
+
+	remap_ops->free_irq(irq);
+}
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
index e0bc6e0..5748553 100644
--- a/drivers/iommu/intr_remapping.h
+++ b/drivers/iommu/intr_remapping.h
@@ -60,6 +60,9 @@ struct irq_remap_ops {
 	/* Set the CPU affinity of a remapped interrupt */
 	int (*set_affinity)(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
+
+	/* Free an IRQ */
+	int (*free_irq)(int);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index f2bd87f..7a207a3 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -121,7 +121,6 @@ extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
 extern int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
    			u16 sub_handle);
 extern int map_irq_to_irte_handle(int irq, u16 *sub_handle);
-extern int free_irte(int irq);
 
 extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
 extern struct intel_iommu *map_ioapic_to_ir(int apic);
@@ -138,10 +137,6 @@ static inline int modify_irte(int irq, struct irte *irte_modified)
 {
 	return -1;
 }
-static inline int free_irte(int irq)
-{
-	return -1;
-}
 static inline int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 {
 	return -1;
-- 
1.7.6.5

