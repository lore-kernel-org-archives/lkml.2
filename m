Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab1DNHNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:13:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:35848 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612Ab1DNHN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:13:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,209,1301900400"; 
   d="scan'208";a="909382055"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org
Cc: david.woodhouse@intel.com, akpm@linux-foundation.org, mingo@elte.hu,
        tglx@linutronix.de, hpa@zytor.com, hpa@linux.intel.com,
        allen.m.kay@intel.com, suresh.b.siddha@intel.com, kent.liu@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH v2] x86, vt-d: enable x2apic opt out
Date: Thu, 14 Apr 2011 15:06:23 +0800
Message-Id: <1302764783-24491-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version of VT-d2 specification (http://download.intel.com/technology
/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf) includes a new feature that 
provide firmware a way to request system software to opt out of enable x2APIC
mode. DMAR ACPI table newly define flags.1 bit: x2APIC_OPT_OUT which is set to
request System software opt out xAPIC mode if flags.0 bit:INTR_REMAP is also
set.

This patch enable the feature. Also re-define x2apic_supported() to address
platform x2apic support needs 1)processor has x2apic capability 2)interrupt
remapping support 3)firmware does not request opt-out.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Reviewed-by: Kay, Allen M <allen.m.kay@intel.com>
---
 arch/x86/include/asm/apic.h |    2 --
 arch/x86/kernel/apic/apic.c |   13 +++++++++----
 drivers/pci/dmar.c          |   28 ++++++++++++++++++++++++++--
 include/linux/dmar.h        |    3 +++
 include/linux/intel-iommu.h |    4 ++++
 5 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3c89694..aa3fc82 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -192,7 +192,6 @@ static inline int x2apic_enabled(void)
 	return 0;
 }
 
-#define x2apic_supported()	(cpu_has_x2apic)
 static inline void x2apic_force_phys(void)
 {
 	x2apic_phys = 1;
@@ -213,7 +212,6 @@ static inline void x2apic_force_phys(void)
 }
 
 #define	x2apic_preenabled 0
-#define	x2apic_supported()	0
 #endif
 
 extern void enable_IR_x2apic(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 76b96d7..6c96c45 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1449,11 +1449,11 @@ void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
-	int ret, x2apic_enabled = 0;
+	int ret = 0, x2apic_enabled = 0;
 	int dmar_table_init_ret;
 
 	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret && !x2apic_supported())
+	if (dmar_table_init_ret && !cpu_has_x2apic)
 		return;
 
 	ioapic_entries = alloc_ioapic_entries();
@@ -1465,6 +1465,7 @@ void __init enable_IR_x2apic(void)
 	ret = save_IO_APIC_setup(ioapic_entries);
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
+		ret = 0;
 		goto out;
 	}
 
@@ -1491,7 +1492,8 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
-	x2apic_enabled = 1;
+	if (x2apic_supported())
+		x2apic_enabled = 1;
 
 	if (x2apic_supported() && !x2apic_mode) {
 		x2apic_mode = 1;
@@ -1514,8 +1516,11 @@ out:
 
 	if (x2apic_preenabled)
 		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (cpu_has_x2apic)
+	else if (!ret && cpu_has_x2apic) /* IR enabling failed */
 		pr_info("Not enabling x2apic, Intr-remapping init failed.\n");
+	else if (!x2apic_supported() && cpu_has_x2apic)
+		pr_info("Not enabling x2apic, firmware requests OS opt-out "
+			  "x2apic.\n");
 }
 
 #ifdef CONFIG_X86_64
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 09933eb..a35dca9 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -705,7 +705,7 @@ int __init detect_intel_iommu(void)
 		 * is added, we will not need this any more.
 		 */
 		dmar = (struct acpi_table_dmar *) dmar_tbl;
-		if (ret && cpu_has_x2apic && dmar->flags & 0x1)
+		if (ret && x2apic_supported() && dmar->flags & DMAR_INTR_REMAP)
 			printk(KERN_INFO
 			       "Queued invalidation will be enabled to support "
 			       "x2apic and Intr-remapping.\n");
@@ -1461,6 +1461,30 @@ int __init dmar_ir_support(void)
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
 	if (!dmar)
 		return 0;
-	return dmar->flags & 0x1;
+	return dmar->flags & DMAR_INTR_REMAP;
 }
+
+/*
+ * Check if the platform support x2apic
+ * three necessary conditions:
+ * a. processor support x2apic
+ * b. interrupt remapping support
+ * c. when interrupt reamapping support,bit of x2APIC_OPT_OUT at "DMAR flags"
+ *  is not set which means firmware does not tell OS opt out x2apic
+ */
+int __init x2apic_supported(void)
+{
+	struct acpi_table_dmar *dmar;
+	unsigned int flags = 0;
+
+	if (!cpu_has_x2apic)
+		return 0;
+
+	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	if (!dmar)
+		return 0;
+	flags = DMAR_INTR_REMAP | DMAR_X2APIC_OPT_OUT;
+	return ((dmar->flags & flags) == DMAR_INTR_REMAP);
+}
+
 IOMMU_INIT_POST(detect_intel_iommu);
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 7b776d7..73c9bff 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -228,8 +228,11 @@ struct dmar_atsr_unit {
 };
 
 extern int intel_iommu_init(void);
+extern int x2apic_supported(void);
+
 #else /* !CONFIG_DMAR: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
+static inline int x2apic_supported(void) { return 0; }
 #endif /* CONFIG_DMAR */
 
 #endif /* __DMAR_H__ */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 9310c69..2d086e5 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -29,6 +29,10 @@
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
+/* DMAR Flags bits */
+#define DMAR_INTR_REMAP 0x1
+#define DMAR_X2APIC_OPT_OUT 0x2
+
 /*
  * Intel IOMMU register specification per version 1.0 public spec.
  */
-- 
1.6.4.2

