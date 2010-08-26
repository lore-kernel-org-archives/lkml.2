Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0HZSAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:00:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50164 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0HZSAM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 14:00:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Muli Ben-Yehuda <muli@il.ibm.com>, "Jon D. Mason" <jdmason@kudzu.us>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Chris Wright <chrisw@sous-sol.org>, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/10] x86/iommu: Make all IOMMU's detection routines return a value.
Date: Thu, 26 Aug 2010 13:57:57 -0400
Message-Id: <1282845485-8991-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We return 1 if the IOMMU has been detected. Zero or an error number
if we failed to find it. This is in preperation of using the IOMMU_INIT
so that we can detect whether an IOMMU is present. I have not
tested this for regression on Calgary, nor on AMD Vi chipsets as
I don't have that hardware.

CC: Muli Ben-Yehuda <muli@il.ibm.com>
CC: "Jon D. Mason" <jdmason@kudzu.us>
CC: "Darrick J. Wong" <djwong@us.ibm.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Woodhouse <David.Woodhouse@intel.com>
CC: Chris Wright <chrisw@sous-sol.org>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/amd_iommu.h |    4 ++--
 arch/x86/include/asm/calgary.h   |    4 ++--
 arch/x86/include/asm/gart.h      |    5 +++--
 arch/x86/kernel/amd_iommu_init.c |    8 +++++---
 arch/x86/kernel/aperture_64.c    |   11 +++++++----
 arch/x86/kernel/pci-calgary_64.c |   15 ++++++++-------
 drivers/pci/dmar.c               |    4 +++-
 include/linux/dmar.h             |    6 +++---
 8 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index 5af2982..2798142 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -24,11 +24,11 @@
 
 #ifdef CONFIG_AMD_IOMMU
 
-extern void amd_iommu_detect(void);
+extern int amd_iommu_detect(void);
 
 #else
 
-static inline void amd_iommu_detect(void) { }
+static inline int amd_iommu_detect(void) { return -ENODEV; }
 
 #endif
 
diff --git a/arch/x86/include/asm/calgary.h b/arch/x86/include/asm/calgary.h
index 0918654..0d467b3 100644
--- a/arch/x86/include/asm/calgary.h
+++ b/arch/x86/include/asm/calgary.h
@@ -62,9 +62,9 @@ struct cal_chipset_ops {
 extern int use_calgary;
 
 #ifdef CONFIG_CALGARY_IOMMU
-extern void detect_calgary(void);
+extern int detect_calgary(void);
 #else
-static inline void detect_calgary(void) { return; }
+static inline int detect_calgary(void) { return -ENODEV; }
 #endif
 
 #endif /* _ASM_X86_CALGARY_H */
diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 4ac5b0f..d7d1d4c 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -37,7 +37,7 @@ extern int gart_iommu_aperture_disabled;
 extern void early_gart_iommu_check(void);
 extern int gart_iommu_init(void);
 extern void __init gart_parse_options(char *);
-extern void gart_iommu_hole_init(void);
+extern int gart_iommu_hole_init(void);
 
 #else
 #define gart_iommu_aperture            0
@@ -50,8 +50,9 @@ static inline void early_gart_iommu_check(void)
 static inline void gart_parse_options(char *options)
 {
 }
-static inline void gart_iommu_hole_init(void)
+static inline int gart_iommu_hole_init(void)
 {
+	return -ENODEV;
 }
 #endif
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 3cc63e2..0b9e2dc 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1382,13 +1382,13 @@ static int __init early_amd_iommu_detect(struct acpi_table_header *table)
 	return 0;
 }
 
-void __init amd_iommu_detect(void)
+int __init amd_iommu_detect(void)
 {
 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
-		return;
+		return -ENODEV;
 
 	if (amd_iommu_disabled)
-		return;
+		return -ENODEV;
 
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
 		iommu_detected = 1;
@@ -1397,7 +1397,9 @@ void __init amd_iommu_detect(void)
 
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
+		return 1;
 	}
+	return -ENODEV;
 }
 
 /****************************************************************************
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index a2e0caf..afa0dab 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -371,7 +371,7 @@ void __init early_gart_iommu_check(void)
 
 static int __initdata printed_gart_size_msg;
 
-void __init gart_iommu_hole_init(void)
+int __init gart_iommu_hole_init(void)
 {
 	u32 agp_aper_base = 0, agp_aper_order = 0;
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
@@ -381,7 +381,7 @@ void __init gart_iommu_hole_init(void)
 
 	if (gart_iommu_aperture_disabled || !fix_aperture ||
 	    !early_pci_allowed())
-		return;
+		return -ENODEV;
 
 	printk(KERN_INFO  "Checking aperture...\n");
 
@@ -463,8 +463,9 @@ out:
 			unsigned long n = (32 * 1024 * 1024) << last_aper_order;
 
 			insert_aperture_resource((u32)last_aper_base, n);
+			return 1;
 		}
-		return;
+		return 0;
 	}
 
 	if (!fallback_aper_force) {
@@ -500,7 +501,7 @@ out:
 			panic("Not enough memory for aperture");
 		}
 	} else {
-		return;
+		return 0;
 	}
 
 	/* Fix up the north bridges */
@@ -524,4 +525,6 @@ out:
 	}
 
 	set_up_gart_resume(aper_order, aper_alloc);
+
+	return 1;
 }
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 078d4ec..28c6b38 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1364,7 +1364,7 @@ static int __init calgary_iommu_init(void)
 	return 0;
 }
 
-void __init detect_calgary(void)
+int __init detect_calgary(void)
 {
 	int bus;
 	void *tbl;
@@ -1378,13 +1378,13 @@ void __init detect_calgary(void)
 	 * another HW IOMMU already, bail out.
 	 */
 	if (no_iommu || iommu_detected)
-		return;
+		return -ENODEV;
 
 	if (!use_calgary)
-		return;
+		return -ENODEV;
 
 	if (!early_pci_allowed())
-		return;
+		return -ENODEV;
 
 	printk(KERN_DEBUG "Calgary: detecting Calgary via BIOS EBDA area\n");
 
@@ -1410,13 +1410,13 @@ void __init detect_calgary(void)
 	if (!rio_table_hdr) {
 		printk(KERN_DEBUG "Calgary: Unable to locate Rio Grande table "
 		       "in EBDA - bailing!\n");
-		return;
+		return -ENODEV;
 	}
 
 	ret = build_detail_arrays();
 	if (ret) {
 		printk(KERN_DEBUG "Calgary: build_detail_arrays ret %d\n", ret);
-		return;
+		return -ENOMEM;
 	}
 
 	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
@@ -1464,7 +1464,7 @@ void __init detect_calgary(void)
 
 		x86_init.iommu.iommu_init = calgary_iommu_init;
 	}
-	return;
+	return calgary_found;
 
 cleanup:
 	for (--bus; bus >= 0; --bus) {
@@ -1473,6 +1473,7 @@ cleanup:
 		if (info->tce_space)
 			free_tce_table(info->tce_space);
 	}
+	return -ENOMEM;
 }
 
 static int __init calgary_parse_options(char *p)
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 0a19708..5fa64ea 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -687,7 +687,7 @@ failed:
 	return 0;
 }
 
-void __init detect_intel_iommu(void)
+int __init detect_intel_iommu(void)
 {
 	int ret;
 
@@ -723,6 +723,8 @@ void __init detect_intel_iommu(void)
 	}
 	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
+
+	return (ret ? 1 : -ENODEV);
 }
 
 
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index d7cecc9..a206020 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -57,15 +57,15 @@ extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
 
 /* Intel IOMMU detection */
-extern void detect_intel_iommu(void);
+extern int detect_intel_iommu(void);
 extern int enable_drhd_fault_handling(void);
 
 extern int parse_ioapics_under_ir(void);
 extern int alloc_iommu(struct dmar_drhd_unit *);
 #else
-static inline void detect_intel_iommu(void)
+static inline int detect_intel_iommu(void)
 {
-	return;
+	return -ENODEV;
 }
 
 static inline int dmar_table_init(void)
-- 
1.7.0.1

