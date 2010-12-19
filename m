Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0LSPa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 10:30:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab0LSPa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 10:30:57 -0500
Date: Sun, 19 Dec 2010 16:30:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20101219153048.GA20533@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/pci/dmar.c                 # 7f99d94: x86, vt-d: Handle previous faults
drivers/pci/quirks.c               # 254e420: x86, vt-d: Quirk for masking vtd 
include/linux/bootmem.h            # 53dde5f: bootmem: Add alloc_bootmem_align(

 Thanks,

	Ingo

------------------>
H. Peter Anvin (2):
      x86, gcc-4.6: Use gcc -m options when building vdso
      x86-32: Make sure we can map all of lowmem if we need to

Kenji Kaneshige (2):
      x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode
      x86: Enable the intr-remap fault handling after local APIC setup

Suresh Siddha (4):
      bootmem: Add alloc_bootmem_align()
      x86, xsave: Use alloc_bootmem_align() instead of alloc_bootmem()
      x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic
      x86, vt-d: Handle previous faults after enabling fault handling

Thomas Gleixner (2):
      x86: io_apic: Avoid unused variable warning when CONFIG_GENERIC_PENDING_IRQ=n
      x86: HPET: Chose a paranoid safe value for the ETIME check


 arch/x86/boot/compressed/misc.c |    2 +-
 arch/x86/kernel/apic/apic.c     |    8 ++++++++
 arch/x86/kernel/apic/io_apic.c  |    4 ++--
 arch/x86/kernel/apic/probe_64.c |    7 -------
 arch/x86/kernel/head_32.S       |   12 +++++++-----
 arch/x86/kernel/hpet.c          |   26 ++++++++++++++++----------
 arch/x86/kernel/xsave.c         |    3 ++-
 arch/x86/vdso/Makefile          |    4 ++--
 drivers/pci/dmar.c              |    5 +++++
 drivers/pci/quirks.c            |   23 +++++++++++++++++++++++
 include/linux/bootmem.h         |    2 ++
 11 files changed, 68 insertions(+), 28 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 23f315c..325c052 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -355,7 +355,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	if (heap > 0x3fffffffffffUL)
 		error("Destination address too large");
 #else
-	if (heap > ((-__PAGE_OFFSET-(512<<20)-1) & 0x7fffffff))
+	if (heap > ((-__PAGE_OFFSET-(128<<20)-1) & 0x7fffffff))
 		error("Destination address too large");
 #endif
 #ifndef CONFIG_RELOCATABLE
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3f838d5..7821813 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1389,6 +1389,14 @@ void __cpuinit end_local_APIC_setup(void)
 
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
+
+	/*
+	 * Now that local APIC setup is completed for BP, configure the fault
+	 * handling for interrupt remapping.
+	 */
+	if (!smp_processor_id() && intr_remapping_enabled)
+		enable_drhd_fault_handling();
+
 }
 
 #ifdef CONFIG_X86_X2APIC
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7cc0a72..fadcd74 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2430,13 +2430,12 @@ static void ack_apic_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	int i, do_unmask_irq = 0, irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 
 	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_ioapic(cfg);
 	}
@@ -3413,6 +3412,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
 
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index f9e4e6a..d8c4a6f 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -79,13 +79,6 @@ void __init default_setup_apic_routing(void)
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
 	}
-
-	/*
-	 * Now that apic routing model is selected, configure the
-	 * fault handling for intr remapping.
-	 */
-	if (intr_remapping_enabled)
-		enable_drhd_fault_handling();
 }
 
 /* Same for both flat and physical. */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index bcece91..d7cdf5b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -60,16 +60,18 @@
 #define PAGE_TABLE_SIZE(pages) ((pages) / PTRS_PER_PGD)
 #endif
 
+/* Number of possible pages in the lowmem region */
+LOWMEM_PAGES = (((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT)
+	
 /* Enough space to fit pagetables for the low memory linear map */
-MAPPING_BEYOND_END = \
-	PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
+MAPPING_BEYOND_END = PAGE_TABLE_SIZE(LOWMEM_PAGES) << PAGE_SHIFT
 
 /*
  * Worst-case size of the kernel mapping we need to make:
- * the worst-case size of the kernel itself, plus the extra we need
- * to map for the linear map.
+ * a relocatable kernel can live anywhere in lowmem, so we need to be able
+ * to map all of lowmem.
  */
-KERNEL_PAGES = (KERNEL_IMAGE_SIZE + MAPPING_BEYOND_END)>>PAGE_SHIFT
+KERNEL_PAGES = LOWMEM_PAGES
 
 INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE_asm
 RESERVE_BRK(pagetables, INIT_MAP_SIZE)
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ae03cab..4ff5968 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -27,6 +27,9 @@
 #define HPET_DEV_FSB_CAP		0x1000
 #define HPET_DEV_PERI_CAP		0x2000
 
+#define HPET_MIN_CYCLES			128
+#define HPET_MIN_PROG_DELTA		(HPET_MIN_CYCLES + (HPET_MIN_CYCLES >> 1))
+
 #define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
 
 /*
@@ -299,8 +302,9 @@ static void hpet_legacy_clockevent_register(void)
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
-	/* 5 usec minimum reprogramming delta. */
-	hpet_clockevent.min_delta_ns = 5000;
+	/* Setup minimum reprogramming delta. */
+	hpet_clockevent.min_delta_ns = clockevent_delta2ns(HPET_MIN_PROG_DELTA,
+							   &hpet_clockevent);
 
 	/*
 	 * Start hpet with the boot cpu mask and make it
@@ -393,22 +397,24 @@ static int hpet_next_event(unsigned long delta,
 	 * the wraparound into account) nor a simple count down event
 	 * mode. Further the write to the comparator register is
 	 * delayed internally up to two HPET clock cycles in certain
-	 * chipsets (ATI, ICH9,10). We worked around that by reading
-	 * back the compare register, but that required another
-	 * workaround for ICH9,10 chips where the first readout after
-	 * write can return the old stale value. We already have a
-	 * minimum delta of 5us enforced, but a NMI or SMI hitting
+	 * chipsets (ATI, ICH9,10). Some newer AMD chipsets have even
+	 * longer delays. We worked around that by reading back the
+	 * compare register, but that required another workaround for
+	 * ICH9,10 chips where the first readout after write can
+	 * return the old stale value. We already had a minimum
+	 * programming delta of 5us enforced, but a NMI or SMI hitting
 	 * between the counter readout and the comparator write can
 	 * move us behind that point easily. Now instead of reading
 	 * the compare register back several times, we make the ETIME
 	 * decision based on the following: Return ETIME if the
-	 * counter value after the write is less than 8 HPET cycles
+	 * counter value after the write is less than HPET_MIN_CYCLES
 	 * away from the event or if the counter is already ahead of
-	 * the event.
+	 * the event. The minimum programming delta for the generic
+	 * clockevents code is set to 1.5 * HPET_MIN_CYCLES.
 	 */
 	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 
-	return res < 8 ? -ETIME : 0;
+	return res < HPET_MIN_CYCLES ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9c253bd..5471285 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -394,7 +394,8 @@ static void __init setup_xstate_init(void)
 	 * Setup init_xstate_buf to represent the init state of
 	 * all the features managed by the xsave
 	 */
-	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf = alloc_bootmem_align(xstate_size,
+					      __alignof__(struct xsave_struct));
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
 
 	clts();
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 4a2afa1..b6552b1 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -25,7 +25,7 @@ targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 
 export CPPFLAGS_vdso.lds += -P -C
 
-VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
+VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
@@ -69,7 +69,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
 vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
+VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
 # is not a kbuild sub-make subdirectory.
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 0157708..09933eb 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1417,6 +1417,11 @@ int __init enable_drhd_fault_handling(void)
 			       (unsigned long long)drhd->reg_base_addr, ret);
 			return -1;
 		}
+
+		/*
+		 * Clear any previous faults.
+		 */
+		dmar_fault(iommu->irq, iommu);
 	}
 
 	return 0;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6f9350c..36191ed 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2764,6 +2764,29 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_m
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
+#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+#define VTUNCERRMSK_REG	0x1ac
+#define VTD_MSK_SPEC_ERRORS	(1 << 31)
+/*
+ * This is a quirk for masking vt-d spec defined errors to platform error
+ * handling logic. With out this, platforms using Intel 7500, 5500 chipsets
+ * (and the derivative chipsets like X58 etc) seem to generate NMI/SMI (based
+ * on the RAS config settings of the platform) when a vt-d fault happens.
+ * The resulting SMI caused the system to hang.
+ *
+ * VT-d spec related errors are already handled by the VT-d OS code, so no
+ * need to report the same error through other channels.
+ */
+static void vtd_mask_spec_errors(struct pci_dev *dev)
+{
+	u32 word;
+
+	pci_read_config_dword(dev, VTUNCERRMSK_REG, &word);
+	pci_write_config_dword(dev, VTUNCERRMSK_REG, word | VTD_MSK_SPEC_ERRORS);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, vtd_mask_spec_errors);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
+#endif
 
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 266ab92..499dfe9 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -105,6 +105,8 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_align(x, align) \
+	__alloc_bootmem(x, align, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_nopanic(x) \
 	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages(x) \
