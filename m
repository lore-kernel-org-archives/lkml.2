Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265Ab2C3Sqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:46:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:8977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760111Ab2C3SqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792297"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 03/10] iommu/vt-d: Convert missing apic.c intr-remapping call to remap_ops
Date: Fri, 30 Mar 2012 11:47:01 -0700
Message-Id: <1333133228-3134-4-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Convert these calls too:

	* Disable of remapping hardware
	* Reenable of remapping hardware
	* Enable fault handling

With that all of arch/x86/kernel/apic/apic.c is converted to
use the generic intr-remapping interface.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/intr_remapping.h |    6 ++++++
 arch/x86/kernel/apic/apic.c           |    6 +++---
 drivers/iommu/intel_intr_remapping.c  |    7 +++++--
 drivers/iommu/intr_remapping.c        |   24 ++++++++++++++++++++++++
 drivers/iommu/intr_remapping.h        |    9 +++++++++
 include/linux/dmar.h                  |   18 ------------------
 6 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/intr_remapping.h b/arch/x86/include/asm/intr_remapping.h
index 207c605..55aa892 100644
--- a/arch/x86/include/asm/intr_remapping.h
+++ b/arch/x86/include/asm/intr_remapping.h
@@ -30,6 +30,9 @@ extern void setup_intr_remapping(void);
 extern int intr_remapping_supported(void);
 extern int intr_hardware_init(void);
 extern int intr_hardware_enable(void);
+extern void intr_hardware_disable(void);
+extern int intr_hardware_reenable(int);
+extern int intr_enable_fault_handling(void);
 
 #else  /* CONFIG_IRQ_REMAP */
 
@@ -39,6 +42,9 @@ static inline void setup_intr_remapping(void) { }
 static inline int intr_remapping_supported(void) { return 0; }
 static inline int intr_hardware_init(void) { return -ENODEV; }
 static inline int intr_hardware_enable(void) { return -ENODEV; }
+static inline void intr_hardware_disable(void) { }
+static inline int intr_hardware_reenable(int eim) { return -ENODEV; }
+static inline int intr_enable_fault_handling(void) { return -ENODEV; }
 
 #endif /* CONFIG_IRQ_REMAP */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7fbeaa7..846f3b6 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1443,7 +1443,7 @@ void __init bsp_end_local_APIC_setup(void)
 	 * handling for interrupt remapping.
 	 */
 	if (intr_remapping_enabled)
-		enable_drhd_fault_handling();
+		intr_enable_fault_handling();
 
 }
 
@@ -2177,7 +2177,7 @@ static int lapic_suspend(void)
 	disable_local_APIC();
 
 	if (intr_remapping_enabled)
-		disable_intr_remapping();
+		intr_hardware_disable();
 
 	local_irq_restore(flags);
 	return 0;
@@ -2244,7 +2244,7 @@ static void lapic_resume(void)
 	apic_read(APIC_ESR);
 
 	if (intr_remapping_enabled)
-		reenable_intr_remapping(x2apic_mode);
+		intr_hardware_reenable(x2apic_mode);
 
 	local_irq_restore(flags);
 }
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
index 9c742fb..610b75b 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -764,7 +764,7 @@ int __init ir_dev_scope_init(void)
 }
 rootfs_initcall(ir_dev_scope_init);
 
-void disable_intr_remapping(void)
+static void disable_intr_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu = NULL;
@@ -780,7 +780,7 @@ void disable_intr_remapping(void)
 	}
 }
 
-int reenable_intr_remapping(int eim)
+static int reenable_intr_remapping(int eim)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
@@ -818,4 +818,7 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_intr_remapping_supported,
 	.hardware_init		= dmar_table_init,
 	.hardware_enable	= intel_enable_intr_remapping,
+	.hardware_disable	= disable_intr_remapping,
+	.hardware_reenable	= reenable_intr_remapping,
+	.enable_faulting	= enable_drhd_fault_handling,
 };
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 670c69a..9aabed7 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -74,3 +74,27 @@ int __init intr_hardware_enable(void)
 
 	return remap_ops->hardware_enable();
 }
+
+void intr_hardware_disable(void)
+{
+	if (!remap_ops || !remap_ops->hardware_disable)
+		return;
+
+	remap_ops->hardware_disable();
+}
+
+int intr_hardware_reenable(int mode)
+{
+	if (!remap_ops || !remap_ops->hardware_reenable)
+		return 0;
+
+	return remap_ops->hardware_reenable(mode);
+}
+
+int __init intr_enable_fault_handling(void)
+{
+	if (!remap_ops || !remap_ops->enable_faulting)
+		return -ENODEV;
+
+	return remap_ops->enable_faulting();
+}
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
index d6df732..2744c9a 100644
--- a/drivers/iommu/intr_remapping.h
+++ b/drivers/iommu/intr_remapping.h
@@ -37,6 +37,15 @@ struct irq_remap_ops {
 
 	/* Enables the remapping hardware */
 	int  (*hardware_enable)(void);
+
+	/* Disables the remapping hardware */
+	void (*hardware_disable)(void);
+
+	/* Reenables the remapping hardware */
+	int  (*hardware_reenable)(int);
+
+	/* Enable fault handling */
+	int  (*enable_faulting)(void);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 6d66c9c..f2bd87f 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -115,9 +115,6 @@ struct irte {
 };
 
 #ifdef CONFIG_IRQ_REMAP
-extern void disable_intr_remapping(void);
-extern int reenable_intr_remapping(int);
-
 extern int get_irte(int irq, struct irte *entry);
 extern int modify_irte(int irq, struct irte *irte_modified);
 extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
@@ -179,21 +176,6 @@ static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 	return 0;
 }
 
-#define intr_remapping_enabled		(0)
-
-static inline int enable_intr_remapping(void)
-{
-	return -1;
-}
-
-static inline void disable_intr_remapping(void)
-{
-}
-
-static inline int reenable_intr_remapping(int eim)
-{
-	return 0;
-}
 #endif
 
 enum {
-- 
1.7.6.5

