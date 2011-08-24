Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1HXAuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:50:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:64483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1HXAtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:49:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41195057"
Message-Id: <20110824001456.386003047@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:22 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/8] iommu: cleanup ifdefs in detect_intel_iommu()
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=add_dmar_irq_remapping_disabled_routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/ia64/include/asm/iommu.h |    6 ++++--
 drivers/iommu/dmar.c          |   13 ++++++-------
 include/linux/dma_remapping.h |    3 ++-
 3 files changed, 12 insertions(+), 10 deletions(-)

Index: linux-2.6-tip/drivers/iommu/dmar.c
===================================================================
--- linux-2.6-tip.orig/drivers/iommu/dmar.c
+++ linux-2.6-tip/drivers/iommu/dmar.c
@@ -551,22 +551,21 @@ int __init detect_intel_iommu(void)
 	if (ret)
 		ret = check_zero_address();
 	{
-#ifdef CONFIG_INTR_REMAP
 		struct acpi_table_dmar *dmar;
 
 		dmar = (struct acpi_table_dmar *) dmar_tbl;
-		if (ret && cpu_has_x2apic && dmar->flags & 0x1)
+
+		if (ret && intr_remapping_enabled && cpu_has_x2apic &&
+		    dmar->flags & 0x1)
 			printk(KERN_INFO
-			       "Queued invalidation will be enabled to support "
-			       "x2apic and Intr-remapping.\n");
-#endif
-#ifdef CONFIG_DMAR
+			       "Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
+
 		if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
 			iommu_detected = 1;
 			/* Make sure ACS will be enabled */
 			pci_request_acs();
 		}
-#endif
+
 #ifdef CONFIG_X86
 		if (ret)
 			x86_init.iommu.iommu_init = intel_iommu_init;
Index: linux-2.6-tip/include/linux/dma_remapping.h
===================================================================
--- linux-2.6-tip.orig/include/linux/dma_remapping.h
+++ linux-2.6-tip/include/linux/dma_remapping.h
@@ -30,6 +30,7 @@ struct root_entry;
 extern void free_dmar_iommu(struct intel_iommu *iommu);
 extern int iommu_calculate_agaw(struct intel_iommu *iommu);
 extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
+extern int dmar_disabled;
 #else
 static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
 {
@@ -42,8 +43,8 @@ static inline int iommu_calculate_max_sa
 static inline void free_dmar_iommu(struct intel_iommu *iommu)
 {
 }
+#define dmar_disabled	(1)
 #endif
 
-extern int dmar_disabled;
 
 #endif
Index: linux-2.6-tip/arch/ia64/include/asm/iommu.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/iommu.h
+++ linux-2.6-tip/arch/ia64/include/asm/iommu.h
@@ -7,12 +7,14 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
-extern int force_iommu, no_iommu;
-extern int iommu_detected;
 #ifdef	CONFIG_DMAR
+extern int force_iommu, no_iommu;
 extern int iommu_pass_through;
+extern int iommu_detected;
 #else
 #define iommu_pass_through	(0)
+#define no_iommu		(1)
+#define iommu_detected		(0)
 #endif
 extern void iommu_dma_init(void);
 extern void machvec_init(const char *name);


