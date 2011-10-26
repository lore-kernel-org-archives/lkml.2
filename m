Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab1JZNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:16:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab1JZNQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:16:56 -0400
Date: Wed, 26 Oct 2011 15:15:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core/iommu changes for v3.2
Message-ID: <20111026131514.GA22792@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-iommu-for-linus

 Thanks,

	Ingo

------------------>
Suresh Siddha (11):
      x86, x2apic: Enable the bios request for x2apic optout
      intr_remap: Call dmar_dev_scope_init() explicitly
      iommu: Move IOMMU specific code to intel-iommu.c
      iommu: No need to set dmar_disabled in check_zero_address()
      iommu: Cleanup ifdefs in detect_intel_iommu()
      x86, msi, intr-remap: Use the ioapic set affinity routine
      x86, ioapic: Define irq_remap_modify_chip_defaults()
      iommu: Rename the DMAR and INTR_REMAP config options
      x86, kdump, ioapic: Reset remote-IRR in clear_IO_APIC
      x86, ioapic: Restore the mask bit correctly in eoi_ioapic_irq()
      x86, ioapic: Consolidate the explicit EOI code


 Documentation/kernel-parameters.txt  |    3 +-
 arch/ia64/configs/generic_defconfig  |    2 +-
 arch/ia64/dig/Makefile               |    2 +-
 arch/ia64/include/asm/device.h       |    2 +-
 arch/ia64/include/asm/iommu.h        |    6 +-
 arch/ia64/include/asm/pci.h          |    2 +-
 arch/ia64/kernel/Makefile            |    2 +-
 arch/ia64/kernel/acpi.c              |    4 +-
 arch/ia64/kernel/msi_ia64.c          |    4 +-
 arch/ia64/kernel/pci-dma.c           |    2 +-
 arch/x86/Kconfig                     |    6 +-
 arch/x86/configs/x86_64_defconfig    |    4 +-
 arch/x86/include/asm/device.h        |    2 +-
 arch/x86/include/asm/hw_irq.h        |    2 +-
 arch/x86/include/asm/irq_remapping.h |    6 +-
 arch/x86/kernel/apic/apic.c          |   33 ++--
 arch/x86/kernel/apic/io_apic.c       |  284 ++++++++++++++++-----------------
 drivers/char/agp/intel-gtt.c         |    4 +-
 drivers/iommu/Kconfig                |   25 ++--
 drivers/iommu/Makefile               |    5 +-
 drivers/iommu/dmar.c                 |  198 +++---------------------
 drivers/iommu/intel-iommu.c          |  167 +++++++++++++++++++--
 drivers/iommu/intr_remapping.c       |   53 ++++++-
 drivers/pci/quirks.c                 |    2 +-
 include/linux/dma_remapping.h        |   10 +-
 include/linux/dmar.h                 |   43 ++++-
 include/linux/intel-iommu.h          |    6 +-
 27 files changed, 474 insertions(+), 405 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 854ed5ca..1386556 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1014,10 +1014,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			has the capability. With this option, super page will
 			not be supported.
 	intremap=	[X86-64, Intel-IOMMU]
-			Format: { on (default) | off | nosid }
 			on	enable Interrupt Remapping (default)
 			off	disable Interrupt Remapping
 			nosid	disable Source ID checking
+			no_x2apic_optout
+				BIOS x2APIC opt-out request will be ignored
 
 	inttest=	[IA-64]
 
diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 0e5cd14..43ab1cd 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -234,4 +234,4 @@ CONFIG_CRYPTO_MD5=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
 CONFIG_MISC_DEVICES=y
-CONFIG_DMAR=y
+CONFIG_INTEL_IOMMU=y
diff --git a/arch/ia64/dig/Makefile b/arch/ia64/dig/Makefile
index 2f7cadd..ae16ec4 100644
--- a/arch/ia64/dig/Makefile
+++ b/arch/ia64/dig/Makefile
@@ -6,7 +6,7 @@
 #
 
 obj-y := setup.o
-ifeq ($(CONFIG_DMAR), y)
+ifeq ($(CONFIG_INTEL_IOMMU), y)
 obj-$(CONFIG_IA64_GENERIC) += machvec.o machvec_vtd.o
 else
 obj-$(CONFIG_IA64_GENERIC) += machvec.o
diff --git a/arch/ia64/include/asm/device.h b/arch/ia64/include/asm/device.h
index d66d446..d05e78f 100644
--- a/arch/ia64/include/asm/device.h
+++ b/arch/ia64/include/asm/device.h
@@ -10,7 +10,7 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
 };
diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
index 745e095..105c93b 100644
--- a/arch/ia64/include/asm/iommu.h
+++ b/arch/ia64/include/asm/iommu.h
@@ -7,12 +7,14 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
+#ifdef	CONFIG_INTEL_IOMMU
 extern int force_iommu, no_iommu;
-extern int iommu_detected;
-#ifdef	CONFIG_DMAR
 extern int iommu_pass_through;
+extern int iommu_detected;
 #else
 #define iommu_pass_through	(0)
+#define no_iommu		(1)
+#define iommu_detected		(0)
 #endif
 extern void iommu_dma_init(void);
 extern void machvec_init(const char *name);
diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index 73b5f78..127dd7b 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -139,7 +139,7 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 	return channel ? isa_irq_to_vector(15) : isa_irq_to_vector(14);
 }
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 extern void pci_iommu_alloc(void);
 #endif
 #endif /* _ASM_IA64_PCI_H */
diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index 395c2f2..d959c84 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_IA64_ESI)		+= esi.o
 ifneq ($(CONFIG_IA64_ESI),)
 obj-y				+= esi_stub.o	# must be in kernel proper
 endif
-obj-$(CONFIG_DMAR)		+= pci-dma.o
+obj-$(CONFIG_INTEL_IOMMU)	+= pci-dma.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
 
 obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 3be485a..bfb4d01 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
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
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 009df54..94e0db7 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -131,7 +131,7 @@ void arch_teardown_msi_irq(unsigned int irq)
 	return ia64_teardown_msi_irq(irq);
 }
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 #ifdef CONFIG_SMP
 static int dmar_msi_set_affinity(struct irq_data *data,
 				 const struct cpumask *mask, bool force)
@@ -210,5 +210,5 @@ int arch_setup_dmar_msi(unsigned int irq)
 				      "edge");
 	return 0;
 }
-#endif /* CONFIG_DMAR */
+#endif /* CONFIG_INTEL_IOMMU */
 
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index f6b1ff0..c16162c 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -14,7 +14,7 @@
 
 #include <asm/system.h>
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 
 #include <linux/kernel.h>
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..b8cd544 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
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
 
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 22a0dc8..058a35b 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
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
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 029f230..63a2a03 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -8,7 +8,7 @@ struct dev_archdata {
 #ifdef CONFIG_X86_64
 struct dma_map_ops *dma_ops;
 #endif
-#if defined(CONFIG_DMAR) || defined(CONFIG_AMD_IOMMU)
+#if defined(CONFIG_INTEL_IOMMU) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
 };
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 0919905..eb92a6e 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -119,7 +119,7 @@ struct irq_cfg {
 	cpumask_var_t		old_domain;
 	u8			vector;
 	u8			move_in_progress : 1;
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 	struct irq_2_iommu	irq_2_iommu;
 #endif
 };
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 1c23360..47d9993 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -3,7 +3,8 @@
 
 #define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
+static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 static inline void prepare_irte(struct irte *irte, int vector,
 			        unsigned int dest)
 {
@@ -36,6 +37,9 @@ static inline bool irq_remapped(struct irq_cfg *cfg)
 {
 	return false;
 }
+static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+{
+}
 #endif
 
 #endif	/* _ASM_X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 52fa563..a2fd72e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1437,27 +1437,21 @@ void enable_x2apic(void)
 
 int __init enable_IR(void)
 {
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 	if (!intr_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
-		return 0;
+		return -1;
 	}
 
 	if (!x2apic_preenabled && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
-		return 0;
+		return -1;
 	}
 
-	if (enable_intr_remapping(x2apic_supported()))
-		return 0;
-
-	pr_info("Enabled Interrupt-remapping\n");
-
-	return 1;
-
+	return enable_intr_remapping();
 #endif
-	return 0;
+	return -1;
 }
 
 void __init enable_IR_x2apic(void)
@@ -1481,11 +1475,11 @@ void __init enable_IR_x2apic(void)
 	mask_ioapic_entries();
 
 	if (dmar_table_init_ret)
-		ret = 0;
+		ret = -1;
 	else
 		ret = enable_IR();
 
-	if (!ret) {
+	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
@@ -1499,6 +1493,9 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
+	if (ret == IRQ_REMAP_XAPIC_MODE)
+		goto nox2apic;
+
 	x2apic_enabled = 1;
 
 	if (x2apic_supported() && !x2apic_mode) {
@@ -1508,19 +1505,21 @@ void __init enable_IR_x2apic(void)
 	}
 
 nox2apic:
-	if (!ret) /* IR enabling failed */
+	if (ret < 0) /* IR enabling failed */
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
 
 out:
-	if (x2apic_enabled)
+	if (x2apic_enabled || !x2apic_supported())
 		return;
 
 	if (x2apic_preenabled)
 		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (cpu_has_x2apic)
-		pr_info("Not enabling x2apic, Intr-remapping init failed.\n");
+	else if (ret == IRQ_REMAP_XAPIC_MODE)
+		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
+	else if (ret < 0)
+		pr_info("x2apic not enabled, IRQ remapping init failed\n");
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8eb863e..229e19f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -394,13 +394,21 @@ union entry_union {
 	struct IO_APIC_route_entry entry;
 };
 
+static struct IO_APIC_route_entry __ioapic_read_entry(int apic, int pin)
+{
+	union entry_union eu;
+
+	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
+	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
+	return eu.entry;
+}
+
 static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 {
 	union entry_union eu;
 	unsigned long flags;
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
-	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
+	eu.entry = __ioapic_read_entry(apic, pin);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	return eu.entry;
 }
@@ -529,18 +537,6 @@ static void io_apic_modify_irq(struct irq_cfg *cfg,
 		__io_apic_modify_irq(entry, mask_and, mask_or, final);
 }
 
-static void __mask_and_edge_IO_APIC_irq(struct irq_pin_list *entry)
-{
-	__io_apic_modify_irq(entry, ~IO_APIC_REDIR_LEVEL_TRIGGER,
-			     IO_APIC_REDIR_MASKED, NULL);
-}
-
-static void __unmask_and_level_IO_APIC_irq(struct irq_pin_list *entry)
-{
-	__io_apic_modify_irq(entry, ~IO_APIC_REDIR_MASKED,
-			     IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
-}
-
 static void io_apic_sync(struct irq_pin_list *entry)
 {
 	/*
@@ -585,6 +581,66 @@ static void unmask_ioapic_irq(struct irq_data *data)
 	unmask_ioapic(data->chip_data);
 }
 
+/*
+ * IO-APIC versions below 0x20 don't support EOI register.
+ * For the record, here is the information about various versions:
+ *     0Xh     82489DX
+ *     1Xh     I/OAPIC or I/O(x)APIC which are not PCI 2.2 Compliant
+ *     2Xh     I/O(x)APIC which is PCI 2.2 Compliant
+ *     30h-FFh Reserved
+ *
+ * Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
+ * version as 0x2. This is an error with documentation and these ICH chips
+ * use io-apic's of version 0x20.
+ *
+ * For IO-APIC's with EOI register, we use that to do an explicit EOI.
+ * Otherwise, we simulate the EOI message manually by changing the trigger
+ * mode to edge and then back to level, with RTE being masked during this.
+ */
+static void __eoi_ioapic_pin(int apic, int pin, int vector, struct irq_cfg *cfg)
+{
+	if (mpc_ioapic_ver(apic) >= 0x20) {
+		/*
+		 * Intr-remapping uses pin number as the virtual vector
+		 * in the RTE. Actual vector is programmed in
+		 * intr-remapping table entry. Hence for the io-apic
+		 * EOI we use the pin number.
+		 */
+		if (cfg && irq_remapped(cfg))
+			io_apic_eoi(apic, pin);
+		else
+			io_apic_eoi(apic, vector);
+	} else {
+		struct IO_APIC_route_entry entry, entry1;
+
+		entry = entry1 = __ioapic_read_entry(apic, pin);
+
+		/*
+		 * Mask the entry and change the trigger mode to edge.
+		 */
+		entry1.mask = 1;
+		entry1.trigger = IOAPIC_EDGE;
+
+		__ioapic_write_entry(apic, pin, entry1);
+
+		/*
+		 * Restore the previous level triggered entry.
+		 */
+		__ioapic_write_entry(apic, pin, entry);
+	}
+}
+
+static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		__eoi_ioapic_pin(entry->apic, entry->pin, cfg->vector, cfg);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
@@ -593,10 +649,44 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 	entry = ioapic_read_entry(apic, pin);
 	if (entry.delivery_mode == dest_SMI)
 		return;
+
+	/*
+	 * Make sure the entry is masked and re-read the contents to check
+	 * if it is a level triggered pin and if the remote-IRR is set.
+	 */
+	if (!entry.mask) {
+		entry.mask = 1;
+		ioapic_write_entry(apic, pin, entry);
+		entry = ioapic_read_entry(apic, pin);
+	}
+
+	if (entry.irr) {
+		unsigned long flags;
+
+		/*
+		 * Make sure the trigger mode is set to level. Explicit EOI
+		 * doesn't clear the remote-IRR if the trigger mode is not
+		 * set to level.
+		 */
+		if (!entry.trigger) {
+			entry.trigger = IOAPIC_LEVEL;
+			ioapic_write_entry(apic, pin, entry);
+		}
+
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
+		__eoi_ioapic_pin(apic, pin, entry.vector, NULL);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+	}
+
 	/*
-	 * Disable it in the IO-APIC irq-routing table:
+	 * Clear the rest of the bits in the IO-APIC RTE except for the mask
+	 * bit.
 	 */
 	ioapic_mask_entry(apic, pin);
+	entry = ioapic_read_entry(apic, pin);
+	if (entry.irr)
+		printk(KERN_ERR "Unable to reset IRR for apic: %d, pin :%d\n",
+		       mpc_ioapic_id(apic), pin);
 }
 
 static void clear_IO_APIC (void)
@@ -1202,7 +1292,6 @@ void __setup_vector_irq(int cpu)
 }
 
 static struct irq_chip ioapic_chip;
-static struct irq_chip ir_ioapic_chip;
 
 #ifdef CONFIG_X86_32
 static inline int IO_APIC_irq_trigger(int irq)
@@ -1246,7 +1335,7 @@ static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
 
 	if (irq_remapped(cfg)) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		chip = &ir_ioapic_chip;
+		irq_remap_modify_chip_defaults(chip);
 		fasteoi = trigger != 0;
 	}
 
@@ -2255,7 +2344,7 @@ ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 
 /*
  * Migrate the IO-APIC irq in the presence of intr-remapping.
@@ -2267,6 +2356,9 @@ ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
  * updated vector information), by using a virtual vector (io-apic pin number).
  * Real vector that is used for interrupting cpu will be coming from
  * the interrupt-remapping table entry.
+ *
+ * As the migration is a simple atomic update of IRTE, the same mechanism
+ * is used to migrate MSI irq's in the presence of interrupt-remapping.
  */
 static int
 ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
@@ -2291,10 +2383,16 @@ ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	irte.dest_id = IRTE_DEST(dest);
 
 	/*
-	 * Modified the IRTE and flushes the Interrupt entry cache.
+	 * Atomically updates the IRTE with the new destination, vector
+	 * and flushes the interrupt entry cache.
 	 */
 	modify_irte(irq, &irte);
 
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
@@ -2407,48 +2505,6 @@ static void ack_apic_edge(struct irq_data *data)
 
 atomic_t irq_mis_count;
 
-/*
- * IO-APIC versions below 0x20 don't support EOI register.
- * For the record, here is the information about various versions:
- *     0Xh     82489DX
- *     1Xh     I/OAPIC or I/O(x)APIC which are not PCI 2.2 Compliant
- *     2Xh     I/O(x)APIC which is PCI 2.2 Compliant
- *     30h-FFh Reserved
- *
- * Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
- * version as 0x2. This is an error with documentation and these ICH chips
- * use io-apic's of version 0x20.
- *
- * For IO-APIC's with EOI register, we use that to do an explicit EOI.
- * Otherwise, we simulate the EOI message manually by changing the trigger
- * mode to edge and then back to level, with RTE being masked during this.
-*/
-static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		if (mpc_ioapic_ver(entry->apic) >= 0x20) {
-			/*
-			 * Intr-remapping uses pin number as the virtual vector
-			 * in the RTE. Actual vector is programmed in
-			 * intr-remapping table entry. Hence for the io-apic
-			 * EOI we use the pin number.
-			 */
-			if (irq_remapped(cfg))
-				io_apic_eoi(entry->apic, entry->pin);
-			else
-				io_apic_eoi(entry->apic, cfg->vector);
-		} else {
-			__mask_and_edge_IO_APIC_irq(entry);
-			__unmask_and_level_IO_APIC_irq(entry);
-		}
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
 static void ack_apic_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
@@ -2552,7 +2608,7 @@ static void ack_apic_level(struct irq_data *data)
 	}
 }
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 static void ir_ack_apic_edge(struct irq_data *data)
 {
 	ack_APIC_irq();
@@ -2563,7 +2619,23 @@ static void ir_ack_apic_level(struct irq_data *data)
 	ack_APIC_irq();
 	eoi_ioapic_irq(data->irq, data->chip_data);
 }
-#endif /* CONFIG_INTR_REMAP */
+
+static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
+{
+	seq_printf(p, " IR-%s", data->chip->name);
+}
+
+static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+{
+	chip->irq_print_chip = ir_print_prefix;
+	chip->irq_ack = ir_ack_apic_edge;
+	chip->irq_eoi = ir_ack_apic_level;
+
+#ifdef CONFIG_SMP
+	chip->irq_set_affinity = ir_ioapic_set_affinity;
+#endif
+}
+#endif /* CONFIG_IRQ_REMAP */
 
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name			= "IO-APIC",
@@ -2578,21 +2650,6 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-static struct irq_chip ir_ioapic_chip __read_mostly = {
-	.name			= "IR-IO-APIC",
-	.irq_startup		= startup_ioapic_irq,
-	.irq_mask		= mask_ioapic_irq,
-	.irq_unmask		= unmask_ioapic_irq,
-#ifdef CONFIG_INTR_REMAP
-	.irq_ack		= ir_ack_apic_edge,
-	.irq_eoi		= ir_ack_apic_level,
-#ifdef CONFIG_SMP
-	.irq_set_affinity	= ir_ioapic_set_affinity,
-#endif
-#endif
-	.irq_retrigger		= ioapic_retrigger_irq,
-};
-
 static inline void init_IO_APIC_traps(void)
 {
 	struct irq_cfg *cfg;
@@ -3144,45 +3201,6 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 
 	return 0;
 }
-#ifdef CONFIG_INTR_REMAP
-/*
- * Migrate the MSI irq to another cpumask. This migration is
- * done in the process context using interrupt-remapping hardware.
- */
-static int
-ir_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		    bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int dest, irq = data->irq;
-	struct irte irte;
-
-	if (get_irte(irq, &irte))
-		return -1;
-
-	if (__ioapic_set_affinity(data, mask, &dest))
-		return -1;
-
-	irte.vector = cfg->vector;
-	irte.dest_id = IRTE_DEST(dest);
-
-	/*
-	 * atomically update the IRTE with the new destination and vector.
-	 */
-	modify_irte(irq, &irte);
-
-	/*
-	 * After this point, all the interrupts will start arriving
-	 * at the new destination. So, time to cleanup the previous
-	 * vector allocation.
-	 */
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
-
-	return 0;
-}
-
-#endif
 #endif /* CONFIG_SMP */
 
 /*
@@ -3200,19 +3218,6 @@ static struct irq_chip msi_chip = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-static struct irq_chip msi_ir_chip = {
-	.name			= "IR-PCI-MSI",
-	.irq_unmask		= unmask_msi_irq,
-	.irq_mask		= mask_msi_irq,
-#ifdef CONFIG_INTR_REMAP
-	.irq_ack		= ir_ack_apic_edge,
-#ifdef CONFIG_SMP
-	.irq_set_affinity	= ir_msi_set_affinity,
-#endif
-#endif
-	.irq_retrigger		= ioapic_retrigger_irq,
-};
-
 /*
  * Map the PCI dev to the corresponding remapping hardware unit
  * and allocate 'nvec' consecutive interrupt-remapping table entries
@@ -3255,7 +3260,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 
 	if (irq_remapped(irq_get_chip_data(irq))) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		chip = &msi_ir_chip;
+		irq_remap_modify_chip_defaults(chip);
 	}
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
@@ -3328,7 +3333,7 @@ void native_teardown_msi_irq(unsigned int irq)
 	destroy_irq(irq);
 }
 
-#if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
+#ifdef CONFIG_DMAR_TABLE
 #ifdef CONFIG_SMP
 static int
 dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
@@ -3409,19 +3414,6 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 
 #endif /* CONFIG_SMP */
 
-static struct irq_chip ir_hpet_msi_type = {
-	.name			= "IR-HPET_MSI",
-	.irq_unmask		= hpet_msi_unmask,
-	.irq_mask		= hpet_msi_mask,
-#ifdef CONFIG_INTR_REMAP
-	.irq_ack		= ir_ack_apic_edge,
-#ifdef CONFIG_SMP
-	.irq_set_affinity	= ir_msi_set_affinity,
-#endif
-#endif
-	.irq_retrigger		= ioapic_retrigger_irq,
-};
-
 static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.irq_unmask = hpet_msi_unmask,
@@ -3458,7 +3450,7 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 	if (irq_remapped(irq_get_chip_data(irq)))
-		chip = &ir_hpet_msi_type;
+		irq_remap_modify_chip_defaults(chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 8515101..2774ac1 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
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
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index b57b3fa..7d7eaa1 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
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
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 4d4d77d..6394994 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
-obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
-obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
+obj-$(CONFIG_DMAR_TABLE) += dmar.o
+obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
+obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 6dcc7e2..587e8f2 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -46,7 +46,7 @@
  */
 LIST_HEAD(dmar_drhd_units);
 
-static struct acpi_table_header * __initdata dmar_tbl;
+struct acpi_table_header * __initdata dmar_tbl;
 static acpi_size dmar_tbl_size;
 
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
@@ -118,8 +118,8 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 	return 0;
 }
 
-static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				       struct pci_dev ***devices, u16 segment)
+int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
+				struct pci_dev ***devices, u16 segment)
 {
 	struct acpi_dmar_device_scope *scope;
 	void * tmp = start;
@@ -217,133 +217,6 @@ static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
 	return ret;
 }
 
-#ifdef CONFIG_DMAR
-LIST_HEAD(dmar_rmrr_units);
-
-static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
-{
-	list_add(&rmrr->list, &dmar_rmrr_units);
-}
-
-
-static int __init
-dmar_parse_one_rmrr(struct acpi_dmar_header *header)
-{
-	struct acpi_dmar_reserved_memory *rmrr;
-	struct dmar_rmrr_unit *rmrru;
-
-	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
-	if (!rmrru)
-		return -ENOMEM;
-
-	rmrru->hdr = header;
-	rmrr = (struct acpi_dmar_reserved_memory *)header;
-	rmrru->base_address = rmrr->base_address;
-	rmrru->end_address = rmrr->end_address;
-
-	dmar_register_rmrr_unit(rmrru);
-	return 0;
-}
-
-static int __init
-rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
-{
-	struct acpi_dmar_reserved_memory *rmrr;
-	int ret;
-
-	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
-	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
-		((void *)rmrr) + rmrr->header.length,
-		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
-
-	if (ret || (rmrru->devices_cnt == 0)) {
-		list_del(&rmrru->list);
-		kfree(rmrru);
-	}
-	return ret;
-}
-
-static LIST_HEAD(dmar_atsr_units);
-
-static int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
-{
-	struct acpi_dmar_atsr *atsr;
-	struct dmar_atsr_unit *atsru;
-
-	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
-	atsru = kzalloc(sizeof(*atsru), GFP_KERNEL);
-	if (!atsru)
-		return -ENOMEM;
-
-	atsru->hdr = hdr;
-	atsru->include_all = atsr->flags & 0x1;
-
-	list_add(&atsru->list, &dmar_atsr_units);
-
-	return 0;
-}
-
-static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
-{
-	int rc;
-	struct acpi_dmar_atsr *atsr;
-
-	if (atsru->include_all)
-		return 0;
-
-	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-	rc = dmar_parse_dev_scope((void *)(atsr + 1),
-				(void *)atsr + atsr->header.length,
-				&atsru->devices_cnt, &atsru->devices,
-				atsr->segment);
-	if (rc || !atsru->devices_cnt) {
-		list_del(&atsru->list);
-		kfree(atsru);
-	}
-
-	return rc;
-}
-
-int dmar_find_matched_atsr_unit(struct pci_dev *dev)
-{
-	int i;
-	struct pci_bus *bus;
-	struct acpi_dmar_atsr *atsr;
-	struct dmar_atsr_unit *atsru;
-
-	dev = pci_physfn(dev);
-
-	list_for_each_entry(atsru, &dmar_atsr_units, list) {
-		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-		if (atsr->segment == pci_domain_nr(dev->bus))
-			goto found;
-	}
-
-	return 0;
-
-found:
-	for (bus = dev->bus; bus; bus = bus->parent) {
-		struct pci_dev *bridge = bus->self;
-
-		if (!bridge || !pci_is_pcie(bridge) ||
-		    bridge->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE)
-			return 0;
-
-		if (bridge->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
-			for (i = 0; i < atsru->devices_cnt; i++)
-				if (atsru->devices[i] == bridge)
-					return 1;
-			break;
-		}
-	}
-
-	if (atsru->include_all)
-		return 1;
-
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_ACPI_NUMA
 static int __init
 dmar_parse_one_rhsa(struct acpi_dmar_header *header)
@@ -484,14 +357,10 @@ parse_dmar_table(void)
 			ret = dmar_parse_one_drhd(entry_header);
 			break;
 		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
-#ifdef CONFIG_DMAR
 			ret = dmar_parse_one_rmrr(entry_header);
-#endif
 			break;
 		case ACPI_DMAR_TYPE_ATSR:
-#ifdef CONFIG_DMAR
 			ret = dmar_parse_one_atsr(entry_header);
-#endif
 			break;
 		case ACPI_DMAR_HARDWARE_AFFINITY:
 #ifdef CONFIG_ACPI_NUMA
@@ -557,34 +426,31 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
 
 int __init dmar_dev_scope_init(void)
 {
+	static int dmar_dev_scope_initialized;
 	struct dmar_drhd_unit *drhd, *drhd_n;
 	int ret = -ENODEV;
 
+	if (dmar_dev_scope_initialized)
+		return dmar_dev_scope_initialized;
+
+	if (list_empty(&dmar_drhd_units))
+		goto fail;
+
 	list_for_each_entry_safe(drhd, drhd_n, &dmar_drhd_units, list) {
 		ret = dmar_parse_dev(drhd);
 		if (ret)
-			return ret;
+			goto fail;
 	}
 
-#ifdef CONFIG_DMAR
-	{
-		struct dmar_rmrr_unit *rmrr, *rmrr_n;
-		struct dmar_atsr_unit *atsr, *atsr_n;
-
-		list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
-			ret = rmrr_parse_dev(rmrr);
-			if (ret)
-				return ret;
-		}
+	ret = dmar_parse_rmrr_atsr_dev();
+	if (ret)
+		goto fail;
 
-		list_for_each_entry_safe(atsr, atsr_n, &dmar_atsr_units, list) {
-			ret = atsr_parse_dev(atsr);
-			if (ret)
-				return ret;
-		}
-	}
-#endif
+	dmar_dev_scope_initialized = 1;
+	return 0;
 
+fail:
+	dmar_dev_scope_initialized = ret;
 	return ret;
 }
 
@@ -611,14 +477,6 @@ int __init dmar_table_init(void)
 		return -ENODEV;
 	}
 
-#ifdef CONFIG_DMAR
-	if (list_empty(&dmar_rmrr_units))
-		printk(KERN_INFO PREFIX "No RMRR found\n");
-
-	if (list_empty(&dmar_atsr_units))
-		printk(KERN_INFO PREFIX "No ATSR found\n");
-#endif
-
 	return 0;
 }
 
@@ -682,9 +540,6 @@ int __init check_zero_address(void)
 	return 1;
 
 failed:
-#ifdef CONFIG_DMAR
-	dmar_disabled = 1;
-#endif
 	return 0;
 }
 
@@ -696,22 +551,21 @@ int __init detect_intel_iommu(void)
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
@@ -758,7 +612,6 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 		goto err_unmap;
 	}
 
-#ifdef CONFIG_DMAR
 	agaw = iommu_calculate_agaw(iommu);
 	if (agaw < 0) {
 		printk(KERN_ERR
@@ -773,7 +626,6 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 			iommu->seq_id);
 		goto err_unmap;
 	}
-#endif
 	iommu->agaw = agaw;
 	iommu->msagaw = msagaw;
 
@@ -817,9 +669,7 @@ void free_iommu(struct intel_iommu *iommu)
 	if (!iommu)
 		return;
 
-#ifdef CONFIG_DMAR
 	free_dmar_iommu(iommu);
-#endif
 
 	if (iommu->reg)
 		iounmap(iommu->reg);
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c621c98..4e249ed 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
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
@@ -2150,7 +2150,7 @@ static inline int iommu_prepare_rmrr_dev(struct dmar_rmrr_unit *rmrr,
 		rmrr->end_address);
 }
 
-#ifdef CONFIG_DMAR_FLOPPY_WA
+#ifdef CONFIG_INTEL_IOMMU_FLOPPY_WA
 static inline void iommu_prepare_isa(void)
 {
 	struct pci_dev *pdev;
@@ -2173,7 +2173,7 @@ static inline void iommu_prepare_isa(void)
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
 
@@ -3390,6 +3390,151 @@ static void __init init_iommu_pm_ops(void)
 static inline void init_iommu_pm_ops(void) {}
 #endif	/* CONFIG_PM */
 
+LIST_HEAD(dmar_rmrr_units);
+
+static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
+{
+	list_add(&rmrr->list, &dmar_rmrr_units);
+}
+
+
+int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
+{
+	struct acpi_dmar_reserved_memory *rmrr;
+	struct dmar_rmrr_unit *rmrru;
+
+	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
+	if (!rmrru)
+		return -ENOMEM;
+
+	rmrru->hdr = header;
+	rmrr = (struct acpi_dmar_reserved_memory *)header;
+	rmrru->base_address = rmrr->base_address;
+	rmrru->end_address = rmrr->end_address;
+
+	dmar_register_rmrr_unit(rmrru);
+	return 0;
+}
+
+static int __init
+rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
+{
+	struct acpi_dmar_reserved_memory *rmrr;
+	int ret;
+
+	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
+	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
+		((void *)rmrr) + rmrr->header.length,
+		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
+
+	if (ret || (rmrru->devices_cnt == 0)) {
+		list_del(&rmrru->list);
+		kfree(rmrru);
+	}
+	return ret;
+}
+
+static LIST_HEAD(dmar_atsr_units);
+
+int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
+{
+	struct acpi_dmar_atsr *atsr;
+	struct dmar_atsr_unit *atsru;
+
+	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
+	atsru = kzalloc(sizeof(*atsru), GFP_KERNEL);
+	if (!atsru)
+		return -ENOMEM;
+
+	atsru->hdr = hdr;
+	atsru->include_all = atsr->flags & 0x1;
+
+	list_add(&atsru->list, &dmar_atsr_units);
+
+	return 0;
+}
+
+static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
+{
+	int rc;
+	struct acpi_dmar_atsr *atsr;
+
+	if (atsru->include_all)
+		return 0;
+
+	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
+	rc = dmar_parse_dev_scope((void *)(atsr + 1),
+				(void *)atsr + atsr->header.length,
+				&atsru->devices_cnt, &atsru->devices,
+				atsr->segment);
+	if (rc || !atsru->devices_cnt) {
+		list_del(&atsru->list);
+		kfree(atsru);
+	}
+
+	return rc;
+}
+
+int dmar_find_matched_atsr_unit(struct pci_dev *dev)
+{
+	int i;
+	struct pci_bus *bus;
+	struct acpi_dmar_atsr *atsr;
+	struct dmar_atsr_unit *atsru;
+
+	dev = pci_physfn(dev);
+
+	list_for_each_entry(atsru, &dmar_atsr_units, list) {
+		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
+		if (atsr->segment == pci_domain_nr(dev->bus))
+			goto found;
+	}
+
+	return 0;
+
+found:
+	for (bus = dev->bus; bus; bus = bus->parent) {
+		struct pci_dev *bridge = bus->self;
+
+		if (!bridge || !pci_is_pcie(bridge) ||
+		    bridge->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE)
+			return 0;
+
+		if (bridge->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
+			for (i = 0; i < atsru->devices_cnt; i++)
+				if (atsru->devices[i] == bridge)
+					return 1;
+			break;
+		}
+	}
+
+	if (atsru->include_all)
+		return 1;
+
+	return 0;
+}
+
+int dmar_parse_rmrr_atsr_dev(void)
+{
+	struct dmar_rmrr_unit *rmrr, *rmrr_n;
+	struct dmar_atsr_unit *atsr, *atsr_n;
+	int ret = 0;
+
+	list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
+		ret = rmrr_parse_dev(rmrr);
+		if (ret)
+			return ret;
+	}
+
+	list_for_each_entry_safe(atsr, atsr_n, &dmar_atsr_units, list) {
+		ret = atsr_parse_dev(atsr);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 /*
  * Here we only respond to action of unbound device from driver.
  *
@@ -3439,16 +3584,12 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
-	if (dmar_dev_scope_init()) {
+	if (dmar_dev_scope_init() < 0) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR device scope\n");
 		return 	-ENODEV;
 	}
 
-	/*
-	 * Check the need for DMA-remapping initialization now.
-	 * Above initialization will also be used by Interrupt-remapping.
-	 */
 	if (no_iommu || dmar_disabled)
 		return -ENODEV;
 
@@ -3458,6 +3599,12 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
+	if (list_empty(&dmar_rmrr_units))
+		printk(KERN_INFO "DMAR: No RMRR found\n");
+
+	if (list_empty(&dmar_atsr_units))
+		printk(KERN_INFO "DMAR: No ATSR found\n");
+
 	if (dmar_init_reserved_ranges()) {
 		if (force_on)
 			panic("tboot: Failed to reserve iommu ranges\n");
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 1a89d4a..cfb0dd4 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -21,6 +21,7 @@ int intr_remapping_enabled;
 
 static int disable_intremap;
 static int disable_sourceid_checking;
+static int no_x2apic_optout;
 
 static __init int setup_nointremap(char *str)
 {
@@ -34,12 +35,20 @@ static __init int setup_intremap(char *str)
 	if (!str)
 		return -EINVAL;
 
-	if (!strncmp(str, "on", 2))
-		disable_intremap = 0;
-	else if (!strncmp(str, "off", 3))
-		disable_intremap = 1;
-	else if (!strncmp(str, "nosid", 5))
-		disable_sourceid_checking = 1;
+	while (*str) {
+		if (!strncmp(str, "on", 2))
+			disable_intremap = 0;
+		else if (!strncmp(str, "off", 3))
+			disable_intremap = 1;
+		else if (!strncmp(str, "nosid", 5))
+			disable_sourceid_checking = 1;
+		else if (!strncmp(str, "no_x2apic_optout", 16))
+			no_x2apic_optout = 1;
+
+		str += strcspn(str, ",");
+		while (*str == ',')
+			str++;
+	}
 
 	return 0;
 }
@@ -501,6 +510,15 @@ end:
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
+static int __init dmar_x2apic_optout(void)
+{
+	struct acpi_table_dmar *dmar;
+	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	if (!dmar || no_x2apic_optout)
+		return 0;
+	return dmar->flags & DMAR_X2APIC_OPT_OUT;
+}
+
 int __init intr_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -521,16 +539,25 @@ int __init intr_remapping_supported(void)
 	return 1;
 }
 
-int __init enable_intr_remapping(int eim)
+int __init enable_intr_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
+	int eim = 0;
 
 	if (parse_ioapics_under_ir() != 1) {
 		printk(KERN_INFO "Not enable interrupt remapping\n");
 		return -1;
 	}
 
+	if (x2apic_supported()) {
+		eim = !dmar_x2apic_optout();
+		WARN(!eim, KERN_WARNING
+			   "Your BIOS is broken and requested that x2apic be disabled\n"
+			   "This will leave your machine vulnerable to irq-injection attacks\n"
+			   "Use 'intremap=no_x2apic_optout' to override BIOS request\n");
+	}
+
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
 
@@ -606,8 +633,9 @@ int __init enable_intr_remapping(int eim)
 		goto error;
 
 	intr_remapping_enabled = 1;
+	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
-	return 0;
+	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
 
 error:
 	/*
@@ -745,6 +773,15 @@ int __init parse_ioapics_under_ir(void)
 	return ir_supported;
 }
 
+int ir_dev_scope_init(void)
+{
+	if (!intr_remapping_enabled)
+		return 0;
+
+	return dmar_dev_scope_init();
+}
+rootfs_initcall(ir_dev_scope_init);
+
 void disable_intr_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1196f61..b23856a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2788,7 +2788,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
-#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+#ifdef CONFIG_DMAR_TABLE
 #define VTUNCERRMSK_REG	0x1ac
 #define VTD_MSK_SPEC_ERRORS	(1 << 31)
 /*
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index bbd8661..ef90cbd 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -25,11 +25,12 @@ struct intel_iommu;
 struct dmar_domain;
 struct root_entry;
 
-extern void free_dmar_iommu(struct intel_iommu *iommu);
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
+extern void free_dmar_iommu(struct intel_iommu *iommu);
 extern int iommu_calculate_agaw(struct intel_iommu *iommu);
 extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
+extern int dmar_disabled;
 #else
 static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
 {
@@ -39,8 +40,11 @@ static inline int iommu_calculate_max_sagaw(struct intel_iommu *iommu)
 {
 	return 0;
 }
+static inline void free_dmar_iommu(struct intel_iommu *iommu)
+{
+}
+#define dmar_disabled	(1)
 #endif
 
-extern int dmar_disabled;
 
 #endif
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 7b776d7..a8b1a84 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -26,8 +26,13 @@
 #include <linux/msi.h>
 #include <linux/irqreturn.h>
 
+/* DMAR Flags */
+#define DMAR_INTR_REMAP		0x1
+#define DMAR_X2APIC_OPT_OUT	0x2
+
 struct intel_iommu;
-#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+#ifdef CONFIG_DMAR_TABLE
+extern struct acpi_table_header *dmar_tbl;
 struct dmar_drhd_unit {
 	struct list_head list;		/* list of drhd units	*/
 	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
@@ -76,7 +81,7 @@ static inline int enable_drhd_fault_handling(void)
 {
 	return -1;
 }
-#endif /* !CONFIG_DMAR && !CONFIG_INTR_REMAP */
+#endif /* !CONFIG_DMAR_TABLE */
 
 struct irte {
 	union {
@@ -107,10 +112,10 @@ struct irte {
 	};
 };
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_IRQ_REMAP
 extern int intr_remapping_enabled;
 extern int intr_remapping_supported(void);
-extern int enable_intr_remapping(int);
+extern int enable_intr_remapping(void);
 extern void disable_intr_remapping(void);
 extern int reenable_intr_remapping(int);
 
@@ -177,7 +182,7 @@ static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 
 #define intr_remapping_enabled		(0)
 
-static inline int enable_intr_remapping(int eim)
+static inline int enable_intr_remapping(void)
 {
 	return -1;
 }
@@ -192,6 +197,11 @@ static inline int reenable_intr_remapping(int eim)
 }
 #endif
 
+enum {
+	IRQ_REMAP_XAPIC_MODE,
+	IRQ_REMAP_X2APIC_MODE,
+};
+
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
  */
@@ -204,7 +214,7 @@ extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_INTEL_IOMMU
 extern int iommu_detected, no_iommu;
 extern struct list_head dmar_rmrr_units;
 struct dmar_rmrr_unit {
@@ -227,9 +237,26 @@ struct dmar_atsr_unit {
 	u8 include_all:1;		/* include all ports */
 };
 
+int dmar_parse_rmrr_atsr_dev(void);
+extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
+extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
+extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
+				struct pci_dev ***devices, u16 segment);
 extern int intel_iommu_init(void);
-#else /* !CONFIG_DMAR: */
+#else /* !CONFIG_INTEL_IOMMU: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
-#endif /* CONFIG_DMAR */
+static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
+{
+	return 0;
+}
+static inline int dmar_parse_one_atsr(struct acpi_dmar_header *header)
+{
+	return 0;
+}
+static inline int dmar_parse_rmrr_atsr_dev(void)
+{
+	return 0;
+}
+#endif /* CONFIG_INTEL_IOMMU */
 
 #endif /* __DMAR_H__ */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 9310c69..235b887 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
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
