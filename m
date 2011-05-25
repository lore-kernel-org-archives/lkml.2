Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab1EYQib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:38:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:57877 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab1EYQia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:38:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,268,1304319600"; 
   d="scan'208";a="1531541"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: david.woodhouse@intel.com, akpm@linux-foundation.org, tglx@linutronix.de,
        hpa@zytor.com, hpa@linux.intel.com, allen.m.kay@intel.com,
        suresh.b.siddha@intel.com, rajesh.sankaran@intel.com,
        asit.k.mallick@intel.com, kent.liu@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH v4] x86, vt-d: enable x2apic opt out
Date: Thu, 26 May 2011 00:36:58 +0800
Message-Id: <1306341418-10645-1-git-send-email-youquan.song@intel.com>
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
remapping support 3)firmware does not request opt-out or ignore the request
by adding kernel option.

[dwmw2: This seems like a fundamentally broken approach, pandering to BIOSes
        which can't cope with x2apic being enabled. But aren't there code
        paths which will enable x2apic even if we don't *have* a DMAR table
        because the BIOS has disabled VT-d? But it's in the spec now,
        unfortunately, so I suppose we need to support it :( ]

Signed-off-by: Youquan Song <youquan.song@intel.com>
Reviewed-by: Kay, Allen M <allen.m.kay@intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 arch/x86/include/asm/apic.h         |    2 --
 arch/x86/kernel/apic/apic.c         |   16 ++++++++++++----
 drivers/pci/dmar.c                  |   29 +++++++++++++++++++++++++++--
 drivers/pci/intel-iommu.c           |    6 ++++++
 include/linux/dma_remapping.h       |    1 +
 include/linux/dmar.h                |    3 +++
 include/linux/intel-iommu.h         |    4 ++++
 8 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7c6624e..cea8fa2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -999,6 +999,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			With this option on every unmap_single operation will
 			result in a hardware IOTLB flush operation as opposed
 			to batching them for performance.
+		no_x2apic_optout [Default Off]
+			With this option BIOS x2APIC opt-out request will be
+			ignored.
 
 	intremap=	[X86-64, Intel-IOMMU]
 			Format: { on (default) | off | nosid }
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 4a0b7c7..ca779fb 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -191,7 +191,6 @@ static inline int x2apic_enabled(void)
 	return 0;
 }
 
-#define x2apic_supported()	(cpu_has_x2apic)
 static inline void x2apic_force_phys(void)
 {
 	x2apic_phys = 1;
@@ -212,7 +211,6 @@ static inline void x2apic_force_phys(void)
 }
 
 #define	x2apic_preenabled 0
-#define	x2apic_supported()	0
 #endif
 
 extern void enable_IR_x2apic(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b961af8..5b137c4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1461,16 +1461,17 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	int ret, x2apic_enabled = 0;
+	int ret = 0, x2apic_enabled = 0;
 	int dmar_table_init_ret;
 
 	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret && !x2apic_supported())
+	if (dmar_table_init_ret && !cpu_has_x2apic)
 		return;
 
 	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
+		ret = 0;
 		goto out;
 	}
 
@@ -1497,7 +1498,8 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
-	x2apic_enabled = 1;
+	if (x2apic_supported())
+		x2apic_enabled = 1;
 
 	if (x2apic_supported() && !x2apic_mode) {
 		x2apic_mode = 1;
@@ -1517,8 +1519,14 @@ out:
 
 	if (x2apic_preenabled)
 		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (cpu_has_x2apic)
+	else if (!ret && cpu_has_x2apic) /* IR enabling failed */
 		pr_info("Not enabling x2apic, Intr-remapping init failed.\n");
+	else if (!x2apic_supported() && cpu_has_x2apic)
+		WARN(1, "Your BIOS is broken and requested that x2apic be "
+			"disabled.\n This will leave your machine vulnerable to"
+			" irq-injection attacks\n"
+			"Use 'intel_iommu=no_x2apic_optout' to override BIOS "
+			"request\n");
 }
 
 #ifdef CONFIG_X86_64
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 12e02bf..9a64581 100644
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
@@ -1461,6 +1461,31 @@ int __init dmar_ir_support(void)
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
+ * c. when interrupt reamapping support,firmware does not request to opt out
+ *  x2apic by not set x2APIC_OPT_OUT bit at DMAR flags or ignore the request
+ *  by adding kernel option.
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
+	flags = DMAR_INTR_REMAP | (no_x2apic_optout ? 0 : DMAR_X2APIC_OPT_OUT);
+	return ((dmar->flags & flags) == DMAR_INTR_REMAP);
+}
+
 IOMMU_INIT_POST(detect_intel_iommu);
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 6af6b62..aa9c69f 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -383,6 +383,7 @@ int dmar_disabled = 0;
 #else
 int dmar_disabled = 1;
 #endif /*CONFIG_DMAR_DEFAULT_ON*/
+int no_x2apic_optout = 0;
 
 static int dmar_map_gfx = 1;
 static int dmar_forcedac;
@@ -417,6 +418,11 @@ static int __init intel_iommu_setup(char *str)
 			printk(KERN_INFO
 				"Intel-IOMMU: disable batched IOTLB flush\n");
 			intel_iommu_strict = 1;
+		} else if (!strncmp(str, "no_x2apic_optout", 16)) {
+			printk(KERN_INFO
+				"Intel-IOMMU: ignore BIOS x2apic opt out "
+				"request\n");
+			no_x2apic_optout = 1;
 		}
 
 		str += strcspn(str, ",");
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 5619f85..d2d93d4 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -38,5 +38,6 @@ static inline int iommu_calculate_max_sagaw(struct intel_iommu *iommu)
 #endif
 
 extern int dmar_disabled;
+extern int no_x2apic_optout;
 
 #endif
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index b862dac..3087ccb 100644
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

