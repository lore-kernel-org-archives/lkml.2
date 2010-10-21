Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab0JUNu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:50:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53824 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0JUNuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:50:55 -0400
Date: Thu, 21 Oct 2010 15:50:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/iommu for v2.6.37
Message-ID: <20101021135043.GA6670@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-iommu-for-linus


out-of-topic modifications in x86-iommu-for-linus:
--------------------------------------------------
arch/ia64/include/asm/iommu_table.h# fc6a2f3: ia64, iommu: Add a dummy iommu_ta
drivers/pci/dmar.c                 # 4db77ff: x86, VT-d: Make Intel VT-d IOMMU 
                                   # 480125b: x86, iommu: Make all IOMMU's dete
include/linux/dmar.h               # 480125b: x86, iommu: Make all IOMMU's dete

 Thanks,

	Ingo

------------------>
Konrad Rzeszutek Wilk (14):
      x86, iommu: Add IOMMU_INIT macros, .iommu_table section, and iommu_table_entry structure
      x86, iommu: Make all IOMMU's detection routines return a value.
      x86, iommu: Add proper dependency sort routine (and sanity check).
      x86, swiotlb: Simplify SWIOTLB pci_swiotlb_detect routine.
      x86, swiotlb: Make SWIOTLB use IOMMU_INIT_* macros.
      x86, xen-swiotlb: Make Xen-SWIOTLB use IOMMU_INIT_* macros.
      x86, calgary: Make Calgary IOMMU use IOMMU_INIT_* macros.
      x86, GART/AMD-VI: Make AMD GART and IOMMU use IOMMU_INIT_* macros.
      x86, VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_* macros.
      x86, iommu: Utilize the IOMMU_INIT macros functionality.
      x86, doc: Adding comments about .iommu_table and its neighbors.
      x86, iommu: Fix IOMMU_INIT alignment rules
      ia64, iommu: Add a dummy iommu_table.h file in IA64.
      x86, iommu: Update header comments with appropriate naming


 arch/ia64/include/asm/iommu_table.h |    6 ++
 arch/x86/include/asm/amd_iommu.h    |    4 +-
 arch/x86/include/asm/calgary.h      |    4 +-
 arch/x86/include/asm/gart.h         |    5 +-
 arch/x86/include/asm/iommu_table.h  |  100 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/swiotlb.h      |   13 ++++-
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/amd_iommu_init.c    |   15 ++++--
 arch/x86/kernel/aperture_64.c       |   11 +++--
 arch/x86/kernel/pci-calgary_64.c    |   18 ++++---
 arch/x86/kernel/pci-dma.c           |   44 +++++++--------
 arch/x86/kernel/pci-gart_64.c       |    2 +
 arch/x86/kernel/pci-iommu_table.c   |   89 +++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-swiotlb.c       |   44 +++++++++++++---
 arch/x86/kernel/vmlinux.lds.S       |   28 ++++++++++
 arch/x86/xen/pci-swiotlb-xen.c      |    5 ++
 drivers/pci/dmar.c                  |    6 ++-
 include/linux/dmar.h                |    6 +-
 18 files changed, 344 insertions(+), 57 deletions(-)
 create mode 100644 arch/ia64/include/asm/iommu_table.h
 create mode 100644 arch/x86/include/asm/iommu_table.h
 create mode 100644 arch/x86/kernel/pci-iommu_table.c

diff --git a/arch/ia64/include/asm/iommu_table.h b/arch/ia64/include/asm/iommu_table.h
new file mode 100644
index 0000000..92c8d36
--- /dev/null
+++ b/arch/ia64/include/asm/iommu_table.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_IA64_IOMMU_TABLE_H
+#define _ASM_IA64_IOMMU_TABLE_H
+
+#define IOMMU_INIT_POST(_detect)
+
+#endif /* _ASM_IA64_IOMMU_TABLE_H */
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
 
diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
new file mode 100644
index 0000000..f229b13
--- /dev/null
+++ b/arch/x86/include/asm/iommu_table.h
@@ -0,0 +1,100 @@
+#ifndef _ASM_X86_IOMMU_TABLE_H
+#define _ASM_X86_IOMMU_TABLE_H
+
+#include <asm/swiotlb.h>
+
+/*
+ * History lesson:
+ * The execution chain of IOMMUs in 2.6.36 looks as so:
+ *
+ *            [xen-swiotlb]
+ *                 |
+ *         +----[swiotlb *]--+
+ *        /         |         \
+ *       /          |          \
+ *    [GART]     [Calgary]  [Intel VT-d]
+ *     /
+ *    /
+ * [AMD-Vi]
+ *
+ * *: if SWIOTLB detected 'iommu=soft'/'swiotlb=force' it would skip
+ * over the rest of IOMMUs and unconditionally initialize the SWIOTLB.
+ * Also it would surreptitiously initialize set the swiotlb=1 if there were
+ * more than 4GB and if the user did not pass in 'iommu=off'. The swiotlb
+ * flag would be turned off by all IOMMUs except the Calgary one.
+ *
+ * The IOMMU_INIT* macros allow a similar tree (or more complex if desired)
+ * to be built by defining who we depend on.
+ *
+ * And all that needs to be done is to use one of the macros in the IOMMU
+ * and the pci-dma.c will take care of the rest.
+ */
+
+struct iommu_table_entry {
+	initcall_t	detect;
+	initcall_t	depend;
+	void		(*early_init)(void); /* No memory allocate available. */
+	void		(*late_init)(void); /* Yes, can allocate memory. */
+#define IOMMU_FINISH_IF_DETECTED (1<<0)
+#define IOMMU_DETECTED		 (1<<1)
+	int		flags;
+};
+/*
+ * Macro fills out an entry in the .iommu_table that is equivalent
+ * to the fields that 'struct iommu_table_entry' has. The entries
+ * that are put in the .iommu_table section are not put in any order
+ * hence during boot-time we will have to resort them based on
+ * dependency. */
+
+
+#define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
+	static const struct iommu_table_entry const			\
+		__iommu_entry_##_detect __used				\
+	__attribute__ ((unused, __section__(".iommu_table"),		\
+			aligned((sizeof(void *)))))	\
+	= {_detect, _depend, _early_init, _late_init,			\
+	   _finish ? IOMMU_FINISH_IF_DETECTED : 0}
+/*
+ * The simplest IOMMU definition. Provide the detection routine
+ * and it will be run after the SWIOTLB and the other IOMMUs
+ * that utilize this macro. If the IOMMU is detected (ie, the
+ * detect routine returns a positive value), the other IOMMUs
+ * are also checked. You can use IOMMU_INIT_POST_FINISH if you prefer
+ * to stop detecting the other IOMMUs after yours has been detected.
+ */
+#define IOMMU_INIT_POST(_detect)					\
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 0)
+
+#define IOMMU_INIT_POST_FINISH(detect)					\
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 1)
+
+/*
+ * A more sophisticated version of IOMMU_INIT. This variant requires:
+ *  a). A detection routine function.
+ *  b). The name of the detection routine we depend on to get called
+ *      before us.
+ *  c). The init routine which gets called if the detection routine
+ *      returns a positive value from the pci_iommu_alloc. This means
+ *      no presence of a memory allocator.
+ *  d). Similar to the 'init', except that this gets called from pci_iommu_init
+ *      where we do have a memory allocator.
+ *
+ * The standard vs the _FINISH differs in that the _FINISH variant will
+ * continue detecting other IOMMUs in the call list after the
+ * the detection routine returns a positive number. The _FINISH will
+ * stop the execution chain. Both will still call the 'init' and
+ * 'late_init' functions if they are set.
+ */
+#define IOMMU_INIT_FINISH(_detect, _depend, _init, _late_init)		\
+	__IOMMU_INIT(_detect, _depend, _init, _late_init, 1)
+
+#define IOMMU_INIT(_detect, _depend, _init, _late_init)			\
+	__IOMMU_INIT(_detect, _depend, _init, _late_init, 0)
+
+void sort_iommu_table(struct iommu_table_entry *start,
+		      struct iommu_table_entry *finish);
+
+void check_iommu_entries(struct iommu_table_entry *start,
+			 struct iommu_table_entry *finish);
+
+#endif /* _ASM_X86_IOMMU_TABLE_H */
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index 8085277..977f176 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -5,17 +5,26 @@
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
-extern int __init pci_swiotlb_detect(void);
+extern int __init pci_swiotlb_detect_override(void);
+extern int __init pci_swiotlb_detect_4gb(void);
 extern void __init pci_swiotlb_init(void);
+extern void __init pci_swiotlb_late_init(void);
 #else
 #define swiotlb 0
-static inline int pci_swiotlb_detect(void)
+static inline int pci_swiotlb_detect_override(void)
+{
+	return 0;
+}
+static inline int pci_swiotlb_detect_4gb(void)
 {
 	return 0;
 }
 static inline void pci_swiotlb_init(void)
 {
 }
+static inline void pci_swiotlb_late_init(void)
+{
+}
 #endif
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..6817546 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -42,6 +42,7 @@ obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
+obj-y			+= pci-iommu_table.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 3cc63e2..26a5e43 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -31,7 +31,7 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/x86_init.h>
-
+#include <asm/iommu_table.h>
 /*
  * definitions for the ACPI scanning code
  */
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
@@ -1428,3 +1430,8 @@ static int __init parse_amd_iommu_options(char *str)
 
 __setup("amd_iommu_dump", parse_amd_iommu_dump);
 __setup("amd_iommu=", parse_amd_iommu_options);
+
+IOMMU_INIT_FINISH(amd_iommu_detect,
+		  gart_iommu_hole_init,
+		  0,
+		  0);
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
index 078d4ec..f56a117 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -47,6 +47,7 @@
 #include <asm/rio.h>
 #include <asm/bios_ebda.h>
 #include <asm/x86_init.h>
+#include <asm/iommu_table.h>
 
 #ifdef CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT
 int use_calgary __read_mostly = 1;
@@ -1364,7 +1365,7 @@ static int __init calgary_iommu_init(void)
 	return 0;
 }
 
-void __init detect_calgary(void)
+int __init detect_calgary(void)
 {
 	int bus;
 	void *tbl;
@@ -1378,13 +1379,13 @@ void __init detect_calgary(void)
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
 
@@ -1410,13 +1411,13 @@ void __init detect_calgary(void)
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
@@ -1464,7 +1465,7 @@ void __init detect_calgary(void)
 
 		x86_init.iommu.iommu_init = calgary_iommu_init;
 	}
-	return;
+	return calgary_found;
 
 cleanup:
 	for (--bus; bus >= 0; --bus) {
@@ -1473,6 +1474,7 @@ cleanup:
 		if (info->tce_space)
 			free_tce_table(info->tce_space);
 	}
+	return -ENOMEM;
 }
 
 static int __init calgary_parse_options(char *p)
@@ -1594,3 +1596,5 @@ static int __init calgary_fixup_tce_spaces(void)
  * and before device_initcall.
  */
 rootfs_initcall(calgary_fixup_tce_spaces);
+
+IOMMU_INIT_POST(detect_calgary);
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 9f07cfc..9ea999a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -11,9 +11,8 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
-#include <asm/amd_iommu.h>
 #include <asm/x86_init.h>
-#include <asm/xen/swiotlb-xen.h>
+#include <asm/iommu_table.h>
 
 static int forbid_dac __read_mostly;
 
@@ -45,6 +44,8 @@ int iommu_detected __read_mostly = 0;
  */
 int iommu_pass_through __read_mostly;
 
+extern struct iommu_table_entry __iommu_table[], __iommu_table_end[];
+
 /* Dummy device used for NULL arguments (normally ISA). */
 struct device x86_dma_fallback_dev = {
 	.init_name = "fallback device",
@@ -130,26 +131,24 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
+	struct iommu_table_entry *p;
+
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 
-	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect())
-		goto out;
-
-	gart_iommu_hole_init();
-
-	detect_calgary();
-
-	detect_intel_iommu();
+	sort_iommu_table(__iommu_table, __iommu_table_end);
+	check_iommu_entries(__iommu_table, __iommu_table_end);
 
-	/* needs to be called after gart_iommu_hole_init */
-	amd_iommu_detect();
-out:
-	pci_xen_swiotlb_init();
-
-	pci_swiotlb_init();
+	for (p = __iommu_table; p < __iommu_table_end; p++) {
+		if (p && p->detect && p->detect() > 0) {
+			p->flags |= IOMMU_DETECTED;
+			if (p->early_init)
+				p->early_init();
+			if (p->flags & IOMMU_FINISH_IF_DETECTED)
+				break;
+		}
+	}
 }
-
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag)
 {
@@ -292,6 +291,7 @@ EXPORT_SYMBOL(dma_supported);
 
 static int __init pci_iommu_init(void)
 {
+	struct iommu_table_entry *p;
 	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
 
 #ifdef CONFIG_PCI
@@ -299,12 +299,10 @@ static int __init pci_iommu_init(void)
 #endif
 	x86_init.iommu.iommu_init();
 
-	if (swiotlb || xen_swiotlb) {
-		printk(KERN_INFO "PCI-DMA: "
-		       "Using software bounce buffering for IO (SWIOTLB)\n");
-		swiotlb_print_info();
-	} else
-		swiotlb_free();
+	for (p = __iommu_table; p < __iommu_table_end; p++) {
+		if (p && (p->flags & IOMMU_DETECTED) && p->late_init)
+			p->late_init();
+	}
 
 	return 0;
 }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0f7f130..de9734b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -41,6 +41,7 @@
 #include <asm/dma.h>
 #include <asm/k8.h>
 #include <asm/x86_init.h>
+#include <asm/iommu_table.h>
 
 static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size;	/* size of remapping area bytes */
@@ -896,3 +897,4 @@ void __init gart_parse_options(char *p)
 		}
 	}
 }
+IOMMU_INIT_POST(gart_iommu_hole_init);
diff --git a/arch/x86/kernel/pci-iommu_table.c b/arch/x86/kernel/pci-iommu_table.c
new file mode 100644
index 0000000..55d745e
--- /dev/null
+++ b/arch/x86/kernel/pci-iommu_table.c
@@ -0,0 +1,89 @@
+#include <linux/dma-mapping.h>
+#include <asm/iommu_table.h>
+#include <linux/string.h>
+#include <linux/kallsyms.h>
+
+
+#define DEBUG 1
+
+static struct iommu_table_entry * __init
+find_dependents_of(struct iommu_table_entry *start,
+		   struct iommu_table_entry *finish,
+		   struct iommu_table_entry *q)
+{
+	struct iommu_table_entry *p;
+
+	if (!q)
+		return NULL;
+
+	for (p = start; p < finish; p++)
+		if (p->detect == q->depend)
+			return p;
+
+	return NULL;
+}
+
+
+void __init sort_iommu_table(struct iommu_table_entry *start,
+			     struct iommu_table_entry *finish) {
+
+	struct iommu_table_entry *p, *q, tmp;
+
+	for (p = start; p < finish; p++) {
+again:
+		q = find_dependents_of(start, finish, p);
+		/* We are bit sneaky here. We use the memory address to figure
+		 * out if the node we depend on is past our point, if so, swap.
+		 */
+		if (q > p) {
+			tmp = *p;
+			memmove(p, q, sizeof(*p));
+			*q = tmp;
+			goto again;
+		}
+	}
+
+}
+
+#ifdef DEBUG
+void __init check_iommu_entries(struct iommu_table_entry *start,
+				struct iommu_table_entry *finish)
+{
+	struct iommu_table_entry *p, *q, *x;
+	char sym_p[KSYM_SYMBOL_LEN];
+	char sym_q[KSYM_SYMBOL_LEN];
+
+	/* Simple cyclic dependency checker. */
+	for (p = start; p < finish; p++) {
+		q = find_dependents_of(start, finish, p);
+		x = find_dependents_of(start, finish, q);
+		if (p == x) {
+			sprint_symbol(sym_p, (unsigned long)p->detect);
+			sprint_symbol(sym_q, (unsigned long)q->detect);
+
+			printk(KERN_ERR "CYCLIC DEPENDENCY FOUND! %s depends" \
+					" on %s and vice-versa. BREAKING IT.\n",
+					sym_p, sym_q);
+			/* Heavy handed way..*/
+			x->depend = 0;
+		}
+	}
+
+	for (p = start; p < finish; p++) {
+		q = find_dependents_of(p, finish, p);
+		if (q && q > p) {
+			sprint_symbol(sym_p, (unsigned long)p->detect);
+			sprint_symbol(sym_q, (unsigned long)q->detect);
+
+			printk(KERN_ERR "EXECUTION ORDER INVALID! %s "\
+					"should be called before %s!\n",
+					sym_p, sym_q);
+		}
+	}
+}
+#else
+inline void check_iommu_entries(struct iommu_table_entry *start,
+				       struct iommu_table_entry *finish)
+{
+}
+#endif
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index a5bc528..8f972cb 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -10,7 +10,8 @@
 #include <asm/iommu.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
-
+#include <asm/xen/swiotlb-xen.h>
+#include <asm/iommu_table.h>
 int swiotlb __read_mostly;
 
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -41,25 +42,42 @@ static struct dma_map_ops swiotlb_dma_ops = {
 };
 
 /*
- * pci_swiotlb_detect - set swiotlb to 1 if necessary
+ * pci_swiotlb_detect_override - set swiotlb to 1 if necessary
  *
  * This returns non-zero if we are forced to use swiotlb (by the boot
  * option).
  */
-int __init pci_swiotlb_detect(void)
+int __init pci_swiotlb_detect_override(void)
 {
 	int use_swiotlb = swiotlb | swiotlb_force;
 
+	if (swiotlb_force)
+		swiotlb = 1;
+
+	return use_swiotlb;
+}
+IOMMU_INIT_FINISH(pci_swiotlb_detect_override,
+		  pci_xen_swiotlb_detect,
+		  pci_swiotlb_init,
+		  pci_swiotlb_late_init);
+
+/*
+ * if 4GB or more detected (and iommu=off not set) return 1
+ * and set swiotlb to 1.
+ */
+int __init pci_swiotlb_detect_4gb(void)
+{
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
 	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
 		swiotlb = 1;
 #endif
-	if (swiotlb_force)
-		swiotlb = 1;
-
-	return use_swiotlb;
+	return swiotlb;
 }
+IOMMU_INIT(pci_swiotlb_detect_4gb,
+	   pci_swiotlb_detect_override,
+	   pci_swiotlb_init,
+	   pci_swiotlb_late_init);
 
 void __init pci_swiotlb_init(void)
 {
@@ -68,3 +86,15 @@ void __init pci_swiotlb_init(void)
 		dma_ops = &swiotlb_dma_ops;
 	}
 }
+
+void __init pci_swiotlb_late_init(void)
+{
+	/* An IOMMU turned us off. */
+	if (!swiotlb)
+		swiotlb_free();
+	else {
+		printk(KERN_INFO "PCI-DMA: "
+		       "Using software bounce buffering for IO (SWIOTLB)\n");
+		swiotlb_print_info();
+	}
+}
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index d0bb522..38e2b67 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -242,6 +242,12 @@ SECTIONS
 		__x86_cpu_dev_end = .;
 	}
 
+	/*
+	 * start address and size of operations which during runtime
+	 * can be patched with virtualization friendly instructions or
+	 * baremetal native ones. Think page table operations.
+	 * Details in paravirt_types.h
+	 */
 	. = ALIGN(8);
 	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
 		__parainstructions = .;
@@ -249,6 +255,11 @@ SECTIONS
 		__parainstructions_end = .;
 	}
 
+	/*
+	 * struct alt_inst entries. From the header (alternative.h):
+	 * "Alternative instructions for different CPU types or capabilities"
+	 * Think locking instructions on spinlocks.
+	 */
 	. = ALIGN(8);
 	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
 		__alt_instructions = .;
@@ -256,11 +267,28 @@ SECTIONS
 		__alt_instructions_end = .;
 	}
 
+	/*
+	 * And here are the replacement instructions. The linker sticks
+	 * them as binary blobs. The .altinstructions has enough data to
+	 * get the address and the length of them to patch the kernel safely.
+	 */
 	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
 		*(.altinstr_replacement)
 	}
 
 	/*
+	 * struct iommu_table_entry entries are injected in this section.
+	 * It is an array of IOMMUs which during run time gets sorted depending
+	 * on its dependency order. After rootfs_initcall is complete
+	 * this section can be safely removed.
+	 */
+	.iommu_table : AT(ADDR(.iommu_table) - LOAD_OFFSET) {
+		__iommu_table = .;
+		*(.iommu_table)
+		__iommu_table_end = .;
+	}
+	. = ALIGN(8);
+	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
 	 *  references from .altinstructions and .eh_frame
 	 */
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index a013ec9..2247100 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -5,6 +5,7 @@
 
 #include <asm/xen/hypervisor.h>
 #include <xen/xen.h>
+#include <asm/iommu_table.h>
 
 int xen_swiotlb __read_mostly;
 
@@ -56,3 +57,7 @@ void __init pci_xen_swiotlb_init(void)
 		dma_ops = &xen_swiotlb_dma_ops;
 	}
 }
+IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
+		  0,
+		  pci_xen_swiotlb_init,
+		  0);
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 0a19708..4ef56a0 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -36,6 +36,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <asm/iommu_table.h>
 
 #define PREFIX "DMAR: "
 
@@ -687,7 +688,7 @@ failed:
 	return 0;
 }
 
-void __init detect_intel_iommu(void)
+int __init detect_intel_iommu(void)
 {
 	int ret;
 
@@ -723,6 +724,8 @@ void __init detect_intel_iommu(void)
 	}
 	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
+
+	return ret ? 1 : -ENODEV;
 }
 
 
@@ -1455,3 +1458,4 @@ int __init dmar_ir_support(void)
 		return 0;
 	return dmar->flags & 0x1;
 }
+IOMMU_INIT_POST(detect_intel_iommu);
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
