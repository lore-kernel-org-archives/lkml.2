Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab1HXAuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:50:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:64483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab1HXAtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:49:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41195068"
Message-Id: <20110824001456.558630224@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:25 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 8/8] iommu: rename the DMAR and INTR_REMAP config options
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=change_dmar_intr_remap_config_options.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the CONFIG_DMAR to CONFIG_INTEL_IOMMU to be consistent with the other
IOMMU options.

Rename the CONFIG_INTR_REMAP to CONFIG_IRQ_REMAP to match the irq
subsystem name.

And define the CONFIG_DMAR_TABLE for the common ACPI DMAR routines
shared by both CONFIG_INTEL_IOMMU and CONFIG_IRQ_REMAP.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/ia64/configs/generic_defconfig  |    2 +-
 arch/ia64/dig/Makefile               |    2 +-
 arch/ia64/include/asm/device.h       |    2 +-
 arch/ia64/include/asm/iommu.h        |    2 +-
 arch/ia64/include/asm/pci.h          |    2 +-
 arch/ia64/kernel/Makefile            |    2 +-
 arch/ia64/kernel/acpi.c              |    4 ++--
 arch/ia64/kernel/msi_ia64.c          |    4 ++--
 arch/ia64/kernel/pci-dma.c           |    2 +-
 arch/x86/Kconfig                     |    6 +++---
 arch/x86/configs/x86_64_defconfig    |    4 ++--
 arch/x86/include/asm/device.h        |    2 +-
 arch/x86/include/asm/hw_irq.h        |    2 +-
 arch/x86/include/asm/irq_remapping.h |    2 +-
 arch/x86/kernel/apic/apic.c          |    2 +-
 arch/x86/kernel/apic/io_apic.c       |    8 ++++----
 drivers/char/agp/intel-gtt.c         |    4 ++--
 drivers/iommu/Kconfig                |   25 +++++++++++++++----------
 drivers/iommu/Makefile               |    5 +++--
 drivers/iommu/intel-iommu.c          |   10 +++++-----
 drivers/pci/quirks.c                 |    2 +-
 include/linux/dma_remapping.h        |    2 +-
 include/linux/dmar.h                 |   12 ++++++------
 include/linux/intel-iommu.h          |    6 +++---
 24 files changed, 60 insertions(+), 54 deletions(-)

Index: tree/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tree.orig/arch/x86/kernel/apic/io_apic.c
+++ tree/arch/x86/kernel/apic/io_apic.c
@@ -2254,7 +2254,7 @@ ioapic_set_affinity(struct irq_data *dat
 	return ret;
 }
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 
 /*
  * Migrate the IO-APIC irq in the presence of intr-remapping.
@@ -2560,7 +2560,7 @@ static void ack_apic_level(struct irq_da
 	}
 }
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 static void ir_ack_apic_edge(struct irq_data *data)
 {
 	ack_APIC_irq();
@@ -2587,7 +2587,7 @@ static void irq_remap_modify_chip_defaul
 	chip->irq_set_affinity = ir_ioapic_set_affinity;
 #endif
 }
-#endif /* CONFIG_INTR_REMAP */
+#endif /* CONFIG_IRQ_REMAP */
 
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name			= "IO-APIC",
@@ -3285,7 +3285,7 @@ void native_teardown_msi_irq(unsigned in
 	destroy_irq(irq);
 }
 
-#if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
+#ifdef CONFIG_DMAR_TABLE
 #ifdef CONFIG_SMP
 static int
 dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
Index: tree/drivers/iommu/Kconfig
===================================================================
--- tree.orig/drivers/iommu/Kconfig
+++ tree/drivers/iommu/Kconfig
@@ -59,10 +59,14 @@ config AMD_IOMMU_STATS
 	  If unsure, say N.
 
 # Intel IOMMU support
-config DMAR
-	bool "Support for DMA Remapping Devices"
+config DMAR_TABLE
+	bool
+
+config INTEL_IOMMU
+	bool "Support for Intel IOMMU using DMA Remapping Devices"
 	depends on PCI_MSI && ACPI && (X86 || IA64_GENERIC)
 	select IOMMU_API
+	select DMAR_TABLE
 	help
 	  DMA remapping (DMAR) devices support enables independent address
 	  translations for Direct Memory Access (DMA) from devices.
@@ -70,18 +74,18 @@ config DMAR
 	  and include PCI device scope covered by these DMA
 	  remapping devices.
 
-config DMAR_DEFAULT_ON
+config INTEL_IOMMU_DEFAULT_ON
 	def_bool y
-	prompt "Enable DMA Remapping Devices by default"
-	depends on DMAR
+	prompt "Enable Intel DMA Remapping Devices by default"
+	depends on INTEL_IOMMU
 	help
 	  Selecting this option will enable a DMAR device at boot time if
 	  one is found. If this option is not selected, DMAR support can
 	  be enabled by passing intel_iommu=on to the kernel.
 
-config DMAR_BROKEN_GFX_WA
+config INTEL_IOMMU_BROKEN_GFX_WA
 	bool "Workaround broken graphics drivers (going away soon)"
-	depends on DMAR && BROKEN && X86
+	depends on INTEL_IOMMU && BROKEN && X86
 	---help---
 	  Current Graphics drivers tend to use physical address
 	  for DMA and avoid using DMA APIs. Setting this config
@@ -90,18 +94,19 @@ config DMAR_BROKEN_GFX_WA
 	  to use physical addresses for DMA, at least until this
 	  option is removed in the 2.6.32 kernel.
 
-config DMAR_FLOPPY_WA
+config INTEL_IOMMU_FLOPPY_WA
 	def_bool y
-	depends on DMAR && X86
+	depends on INTEL_IOMMU && X86
 	---help---
 	  Floppy disk drivers are known to bypass DMA API calls
 	  thereby failing to work when IOMMU is enabled. This
 	  workaround will setup a 1:1 mapping for the first
 	  16MiB to make floppy (an ISA device) work.
 
-config INTR_REMAP
+config IRQ_REMAP
 	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
 	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	select DMAR_TABLE
 	---help---
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
 	  To use x2apic mode in the CPU's which support x2APIC enhancements or
Index: tree/drivers/iommu/Makefile
===================================================================
--- tree.orig/drivers/iommu/Makefile
+++ tree/drivers/iommu/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
-obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
-obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
+obj-$(CONFIG_DMAR_TABLE) += dmar.o
+obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
+obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
Index: tree/include/linux/dmar.h
===================================================================
--- tree.orig/include/linux/dmar.h
+++ tree/include/linux/dmar.h
@@ -31,7 +31,7 @@
 #define DMAR_X2APIC_OPT_OUT	0x2
 
 struct intel_iommu;
-#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+#ifdef CONFIG_DMAR_TABLE
 extern struct acpi_table_header *dmar_tbl;
 struct dmar_drhd_unit {
 	struct list_head list;		/* list of drhd units	*/
@@ -81,7 +81,7 @@ static inline int enable_drhd_fault_hand
 {
 	return -1;
 }
-#endif /* !CONFIG_DMAR && !CONFIG_INTR_REMAP */
+#endif /* !CONFIG_DMAR_TABLE */
 
 struct irte {
 	union {
@@ -112,7 +112,7 @@ struct irte {
 	};
 };
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 extern int intr_remapping_enabled;
 extern int intr_remapping_supported(void);
 extern int enable_intr_remapping(void);
@@ -214,7 +214,7 @@ extern int dmar_set_interrupt(struct int
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 extern int iommu_detected, no_iommu;
 extern struct list_head dmar_rmrr_units;
 struct dmar_rmrr_unit {
@@ -243,7 +243,7 @@ extern int dmar_parse_one_atsr(struct ac
 extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
 				struct pci_dev ***devices, u16 segment);
 extern int intel_iommu_init(void);
-#else /* !CONFIG_DMAR: */
+#else /* !CONFIG_INTEL_IOMMU: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
 static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 {
@@ -257,6 +257,6 @@ static inline int dmar_parse_rmrr_atsr_d
 {
 	return 0;
 }
-#endif /* CONFIG_DMAR */
+#endif /* CONFIG_INTEL_IOMMU */
 
 #endif /* __DMAR_H__ */
Index: tree/arch/x86/include/asm/device.h
===================================================================
--- tree.orig/arch/x86/include/asm/device.h
+++ tree/arch/x86/include/asm/device.h
@@ -8,7 +8,7 @@ struct dev_archdata {
 #ifdef CONFIG_X86_64
 struct dma_map_ops *dma_ops;
 #endif
-#if defined(CONFIG_DMAR) || defined(CONFIG_AMD_IOMMU)
+#if defined(CONFIG_INTEL_IOMMU) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
 };
Index: tree/drivers/iommu/intel-iommu.c
===================================================================
--- tree.orig/drivers/iommu/intel-iommu.c
+++ tree/drivers/iommu/intel-iommu.c
@@ -393,11 +393,11 @@ static long list_size;
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
-#ifdef CONFIG_DMAR_DEFAULT_ON
+#ifdef CONFIG_INTEL_IOMMU_DEFAULT_ON
 int dmar_disabled = 0;
 #else
 int dmar_disabled = 1;
-#endif /*CONFIG_DMAR_DEFAULT_ON*/
+#endif /*CONFIG_INTEL_IOMMU_DEFAULT_ON*/
 
 static int dmar_map_gfx = 1;
 static int dmar_forcedac;
@@ -2150,7 +2150,7 @@ static inline int iommu_prepare_rmrr_dev
 		rmrr->end_address);
 }
 
-#ifdef CONFIG_DMAR_FLOPPY_WA
+#ifdef CONFIG_INTEL_IOMMU_FLOPPY_WA
 static inline void iommu_prepare_isa(void)
 {
 	struct pci_dev *pdev;
@@ -2173,7 +2173,7 @@ static inline void iommu_prepare_isa(voi
 {
 	return;
 }
-#endif /* !CONFIG_DMAR_FLPY_WA */
+#endif /* !CONFIG_INTEL_IOMMU_FLPY_WA */
 
 static int md_domain_init(struct dmar_domain *domain, int guest_width);
 
@@ -2484,7 +2484,7 @@ static int __init init_dmars(void)
 	if (iommu_pass_through)
 		iommu_identity_mapping |= IDENTMAP_ALL;
 
-#ifdef CONFIG_DMAR_BROKEN_GFX_WA
+#ifdef CONFIG_INTEL_IOMMU_BROKEN_GFX_WA
 	iommu_identity_mapping |= IDENTMAP_GFX;
 #endif
 
Index: tree/include/linux/dma_remapping.h
===================================================================
--- tree.orig/include/linux/dma_remapping.h
+++ tree/include/linux/dma_remapping.h
@@ -26,7 +26,7 @@ struct dmar_domain;
 struct root_entry;
 
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 extern void free_dmar_iommu(struct intel_iommu *iommu);
 extern int iommu_calculate_agaw(struct intel_iommu *iommu);
 extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
Index: tree/include/linux/intel-iommu.h
===================================================================
--- tree.orig/include/linux/intel-iommu.h
+++ tree/include/linux/intel-iommu.h
@@ -279,7 +279,7 @@ struct q_inval {
 	int             free_cnt;
 };
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 /* 1MB - maximum possible interrupt remapping table size */
 #define INTR_REMAP_PAGE_ORDER	8
 #define INTR_REMAP_TABLE_REG_SIZE	0xf
@@ -318,7 +318,7 @@ struct intel_iommu {
 	unsigned int 	irq;
 	unsigned char 	name[13];    /* Device Name */
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 	unsigned long 	*domain_ids; /* bitmap of domains */
 	struct dmar_domain **domains; /* ptr to domains */
 	spinlock_t	lock; /* protect context, domain ids */
@@ -329,7 +329,7 @@ struct intel_iommu {
 	struct q_inval  *qi;            /* Queued invalidation info */
 	u32 *iommu_state; /* Store iommu states between suspend and resume.*/
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 	struct ir_table *ir_table;	/* Interrupt remapping info */
 #endif
 	int		node;
Index: tree/arch/x86/include/asm/hw_irq.h
===================================================================
--- tree.orig/arch/x86/include/asm/hw_irq.h
+++ tree/arch/x86/include/asm/hw_irq.h
@@ -119,7 +119,7 @@ struct irq_cfg {
 	cpumask_var_t		old_domain;
 	u8			vector;
 	u8			move_in_progress : 1;
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 	struct irq_2_iommu	irq_2_iommu;
 #endif
 };
Index: tree/arch/x86/include/asm/irq_remapping.h
===================================================================
--- tree.orig/arch/x86/include/asm/irq_remapping.h
+++ tree/arch/x86/include/asm/irq_remapping.h
@@ -3,7 +3,7 @@
 
 #define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 static inline void prepare_irte(struct irte *irte, int vector,
 			        unsigned int dest)
Index: tree/drivers/char/agp/intel-gtt.c
===================================================================
--- tree.orig/drivers/char/agp/intel-gtt.c
+++ tree/drivers/char/agp/intel-gtt.c
@@ -30,10 +30,10 @@
 /*
  * If we have Intel graphics, we're not going to have anything other than
  * an Intel IOMMU. So make the correct use of the PCI DMA API contingent
- * on the Intel IOMMU support (CONFIG_DMAR).
+ * on the Intel IOMMU support (CONFIG_INTEL_IOMMU).
  * Only newer chipsets need to bother with this, of course.
  */
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 #define USE_PCI_DMA_API 1
 #else
 #define USE_PCI_DMA_API 0
Index: tree/drivers/pci/quirks.c
===================================================================
--- tree.orig/drivers/pci/quirks.c
+++ tree/drivers/pci/quirks.c
@@ -2788,7 +2788,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RI
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
-#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+#ifdef CONFIG_DMAR_TABLE
 #define VTUNCERRMSK_REG	0x1ac
 #define VTD_MSK_SPEC_ERRORS	(1 << 31)
 /*
Index: tree/arch/x86/kernel/apic/apic.c
===================================================================
--- tree.orig/arch/x86/kernel/apic/apic.c
+++ tree/arch/x86/kernel/apic/apic.c
@@ -1437,7 +1437,7 @@ void enable_x2apic(void)
 
 int __init enable_IR(void)
 {
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 	if (!intr_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
 		return -1;
Index: tree/arch/ia64/configs/generic_defconfig
===================================================================
--- tree.orig/arch/ia64/configs/generic_defconfig
+++ tree/arch/ia64/configs/generic_defconfig
@@ -234,4 +234,4 @@ CONFIG_CRYPTO_MD5=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
 CONFIG_MISC_DEVICES=y
-CONFIG_DMAR=y
+CONFIG_INTEL_IOMMU=y
Index: tree/arch/ia64/dig/Makefile
===================================================================
--- tree.orig/arch/ia64/dig/Makefile
+++ tree/arch/ia64/dig/Makefile
@@ -6,7 +6,7 @@
 #
 
 obj-y := setup.o
-ifeq ($(CONFIG_DMAR), y)
+ifeq ($(CONFIG_INTEL_IOMMU), y)
 obj-$(CONFIG_IA64_GENERIC) += machvec.o machvec_vtd.o
 else
 obj-$(CONFIG_IA64_GENERIC) += machvec.o
Index: tree/arch/ia64/include/asm/device.h
===================================================================
--- tree.orig/arch/ia64/include/asm/device.h
+++ tree/arch/ia64/include/asm/device.h
@@ -10,7 +10,7 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
 };
Index: tree/arch/ia64/include/asm/iommu.h
===================================================================
--- tree.orig/arch/ia64/include/asm/iommu.h
+++ tree/arch/ia64/include/asm/iommu.h
@@ -7,7 +7,7 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
-#ifdef	CONFIG_DMAR
+#ifdef	CONFIG_INTEL_IOMMU
 extern int force_iommu, no_iommu;
 extern int iommu_pass_through;
 extern int iommu_detected;
Index: tree/arch/ia64/include/asm/pci.h
===================================================================
--- tree.orig/arch/ia64/include/asm/pci.h
+++ tree/arch/ia64/include/asm/pci.h
@@ -139,7 +139,7 @@ static inline int pci_get_legacy_ide_irq
 	return channel ? isa_irq_to_vector(15) : isa_irq_to_vector(14);
 }
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 extern void pci_iommu_alloc(void);
 #endif
 #endif /* _ASM_IA64_PCI_H */
Index: tree/arch/ia64/kernel/Makefile
===================================================================
--- tree.orig/arch/ia64/kernel/Makefile
+++ tree/arch/ia64/kernel/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_IA64_ESI)		+= esi.o
 ifneq ($(CONFIG_IA64_ESI),)
 obj-y				+= esi_stub.o	# must be in kernel proper
 endif
-obj-$(CONFIG_DMAR)		+= pci-dma.o
+obj-$(CONFIG_INTEL_IOMMU)	+= pci-dma.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
 
 obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
Index: tree/arch/ia64/kernel/acpi.c
===================================================================
--- tree.orig/arch/ia64/kernel/acpi.c
+++ tree/arch/ia64/kernel/acpi.c
@@ -88,7 +88,7 @@ acpi_get_sysname(void)
 	struct acpi_table_rsdp *rsdp;
 	struct acpi_table_xsdt *xsdt;
 	struct acpi_table_header *hdr;
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 	u64 i, nentries;
 #endif
 
@@ -125,7 +125,7 @@ acpi_get_sysname(void)
 		return "xen";
 	}
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 	/* Look for Intel IOMMU */
 	nentries = (hdr->length - sizeof(*hdr)) /
 			 sizeof(xsdt->table_offset_entry[0]);
Index: tree/arch/ia64/kernel/msi_ia64.c
===================================================================
--- tree.orig/arch/ia64/kernel/msi_ia64.c
+++ tree/arch/ia64/kernel/msi_ia64.c
@@ -131,7 +131,7 @@ void arch_teardown_msi_irq(unsigned int 
 	return ia64_teardown_msi_irq(irq);
 }
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 #ifdef CONFIG_SMP
 static int dmar_msi_set_affinity(struct irq_data *data,
 				 const struct cpumask *mask, bool force)
@@ -210,5 +210,5 @@ int arch_setup_dmar_msi(unsigned int irq
 				      "edge");
 	return 0;
 }
-#endif /* CONFIG_DMAR */
+#endif /* CONFIG_INTEL_IOMMU */
 
Index: tree/arch/ia64/kernel/pci-dma.c
===================================================================
--- tree.orig/arch/ia64/kernel/pci-dma.c
+++ tree/arch/ia64/kernel/pci-dma.c
@@ -14,7 +14,7 @@
 
 #include <asm/system.h>
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 
 #include <linux/kernel.h>
 
Index: tree/arch/x86/configs/x86_64_defconfig
===================================================================
--- tree.orig/arch/x86/configs/x86_64_defconfig
+++ tree/arch/x86/configs/x86_64_defconfig
@@ -67,8 +67,8 @@ CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
 CONFIG_CPU_FREQ_GOV_ONDEMAND=y
 CONFIG_X86_ACPI_CPUFREQ=y
 CONFIG_PCI_MMCONFIG=y
-CONFIG_DMAR=y
-# CONFIG_DMAR_DEFAULT_ON is not set
+CONFIG_INTEL_IOMMU=y
+# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
 CONFIG_PCIEPORTBUS=y
 CONFIG_PCCARD=y
 CONFIG_YENTA=y
Index: tree/arch/x86/Kconfig
===================================================================
--- tree.orig/arch/x86/Kconfig
+++ tree/arch/x86/Kconfig
@@ -130,7 +130,7 @@ config SBUS
 	bool
 
 config NEED_DMA_MAP_STATE
-       def_bool (X86_64 || DMAR || DMA_API_DEBUG)
+       def_bool (X86_64 || INTEL_IOMMU || DMA_API_DEBUG)
 
 config NEED_SG_DMA_LENGTH
 	def_bool y
@@ -220,7 +220,7 @@ config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 
 config HAVE_INTEL_TXT
 	def_bool y
-	depends on EXPERIMENTAL && DMAR && ACPI
+	depends on EXPERIMENTAL && INTEL_IOMMU && ACPI
 
 config X86_32_SMP
 	def_bool y
@@ -287,7 +287,7 @@ config SMP
 
 config X86_X2APIC
 	bool "Support x2apic"
-	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
+	depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 


