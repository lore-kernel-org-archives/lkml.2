Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab2EWIta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:49:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57992 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2EWItW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:49:22 -0400
Date: Wed, 23 May 2012 10:49:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.5
Message-ID: <20120523084913.GA18834@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   HEAD: ead91d4b8c3b1fb08a73aaa4a191230ecf717ee0 x86/vsmp: Fix number of CPUs when vsmp is disabled

This tree includes assorted platform driver updates and a 
preparatory series for a platform with custom DMA remapping 
semantics (sta2x11 I/O hub).

out-of-topic modifications in x86-platform-for-linus:
-----------------------------------------------------
arch/parisc/include/asm/kbdleds.h  # b2d0b7a: keyboard: Use BIOS Keyboard varia
drivers/tty/vt/keyboard.c          # b2d0b7a: keyboard: Use BIOS Keyboard varia
include/linux/cs5535.h             # c2c21e9: x86/olpc/xo1/sci: Report RTC wake

 Thanks,

	Ingo

------------------>
Alessandro Rubini (3):
      x86-32: Introduce CONFIG_X86_DEV_DMA_OPS
      x86: Introduce CONFIG_X86_DMA_REMAP
      x86, platform: Initial support for sta2x11 I/O hub

Daniel Drake (2):
      x86/olpc/xo1/sci: Produce wakeup events for buttons and switches
      x86/olpc/xo1/sci: Report RTC wakeup events

Joshua Cov (1):
      keyboard: Use BIOS Keyboard variable to set Numlock

Shai Fultheim (1):
      x86/vsmp: Fix number of CPUs when vsmp is disabled


 arch/parisc/include/asm/kbdleds.h     |  19 ++
 arch/x86/Kconfig                      |  35 +++-
 arch/x86/boot/main.c                  |  18 +-
 arch/x86/include/asm/bootparam.h      |   3 +-
 arch/x86/include/asm/device.h         |   4 +-
 arch/x86/include/asm/dma-mapping.h    |   9 +-
 arch/x86/include/asm/kbdleds.h        |  17 ++
 arch/x86/kernel/vsmp_64.c             |  40 ++++
 arch/x86/pci/Makefile                 |   2 +
 arch/x86/pci/sta2x11-fixup.c          | 366 ++++++++++++++++++++++++++++++++++
 arch/x86/platform/olpc/olpc-xo1-sci.c |  43 +++-
 drivers/tty/vt/keyboard.c             |  20 +-
 include/linux/cs5535.h                |   1 +
 13 files changed, 544 insertions(+), 33 deletions(-)
 create mode 100644 arch/parisc/include/asm/kbdleds.h
 create mode 100644 arch/x86/include/asm/kbdleds.h
 create mode 100644 arch/x86/pci/sta2x11-fixup.c

diff --git a/arch/parisc/include/asm/kbdleds.h b/arch/parisc/include/asm/kbdleds.h
new file mode 100644
index 0000000..2e2e75a
--- /dev/null
+++ b/arch/parisc/include/asm/kbdleds.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_PARISC_KBDLEDS_H
+#define _ASM_PARISC_KBDLEDS_H
+
+/*
+ * On HIL keyboards of PARISC machines there is no NumLock key and
+ * everyone expects the keypad to be used for numbers. That's why
+ * we can safely turn on the NUMLOCK bit.
+ */
+
+static inline int kbd_defleds(void)
+{
+#if defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD)
+	return 1 << VC_NUMLOCK;
+#else
+	return 0;
+#endif
+}
+
+#endif /* _ASM_PARISC_KBDLEDS_H */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..d2599a0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -12,6 +12,7 @@ config X86_32
 
 config X86_64
 	def_bool 64BIT
+	select X86_DEV_DMA_OPS
 
 ### Arch settings
 config X86
@@ -328,6 +329,7 @@ config X86_EXTENDED_PLATFORM
 		NUMAQ (IBM/Sequent)
 		RDC R-321x SoC
 		SGI 320/540 (Visual Workstation)
+		STA2X11-based (e.g. Northville)
 		Summit/EXA (IBM x440)
 		Unisys ES7000 IA32 series
 		Moorestown MID devices
@@ -374,6 +376,7 @@ config X86_VSMP
 	select PARAVIRT
 	depends on X86_64 && PCI
 	depends on X86_EXTENDED_PLATFORM
+	depends on SMP
 	---help---
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
@@ -460,10 +463,10 @@ config X86_32_NON_STANDARD
 	depends on X86_32 && SMP
 	depends on X86_EXTENDED_PLATFORM
 	---help---
-	  This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
-	  subarchitectures.  It is intended for a generic binary kernel.
-	  if you select them all, kernel will probe it one by one. and will
-	  fallback to default.
+	  This option compiles in the NUMAQ, Summit, bigsmp, ES7000,
+	  STA2X11, default subarchitectures.  It is intended for a generic
+	  binary kernel. If you select them all, kernel will probe it
+	  one by one and will fallback to default.
 
 # Alphabetically sorted list of Non standard 32 bit platforms
 
@@ -503,6 +506,22 @@ config X86_VISWS
 	  A kernel compiled for the Visual Workstation will run on general
 	  PCs as well. See <file:Documentation/sgi-visws.txt> for details.
 
+config STA2X11
+	bool "STA2X11 Companion Chip Support"
+	depends on X86_32_NON_STANDARD && PCI
+	select X86_DEV_DMA_OPS
+	select X86_DMA_REMAP
+	select SWIOTLB
+	select MFD_STA2X11
+	select ARCH_REQUIRE_GPIOLIB
+	default n
+	---help---
+	  This adds support for boards based on the STA2X11 IO-Hub,
+	  a.k.a. "ConneXt". The chip is used in place of the standard
+	  PC chipset, so all "standard" peripherals are missing. If this
+	  option is selected the kernel will still be able to boot on
+	  standard PC machines.
+
 config X86_SUMMIT
 	bool "Summit/EXA (IBM x440)"
 	depends on X86_32_NON_STANDARD
@@ -2215,6 +2234,14 @@ config HAVE_TEXT_POKE_SMP
 	bool
 	select STOP_MACHINE if SMP
 
+config X86_DEV_DMA_OPS
+	bool
+	depends on X86_64 || STA2X11
+
+config X86_DMA_REMAP
+	bool
+	depends on STA2X11
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 40358c8..cf6083d 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -57,14 +57,20 @@ static void copy_boot_params(void)
 }
 
 /*
- * Set the keyboard repeat rate to maximum.  Unclear why this
+ * Query the keyboard lock status as given by the BIOS, and
+ * set the keyboard repeat rate to maximum.  Unclear why the latter
  * is done here; this might be possible to kill off as stale code.
  */
-static void keyboard_set_repeat(void)
+static void keyboard_init(void)
 {
-	struct biosregs ireg;
+	struct biosregs ireg, oreg;
 	initregs(&ireg);
-	ireg.ax = 0x0305;
+
+	ireg.ah = 0x02;		/* Get keyboard status */
+	intcall(0x16, &ireg, &oreg);
+	boot_params.kbd_status = oreg.al;
+
+	ireg.ax = 0x0305;	/* Set keyboard repeat rate */
 	intcall(0x16, &ireg, NULL);
 }
 
@@ -151,8 +157,8 @@ void main(void)
 	/* Detect memory layout */
 	detect_memory();
 
-	/* Set keyboard repeat rate (why?) */
-	keyboard_set_repeat();
+	/* Set keyboard repeat rate (why?) and query the lock flags */
+	keyboard_init();
 
 	/* Query MCA information */
 	query_mca();
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 2f90c51..eb45aa6 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -112,7 +112,8 @@ struct boot_params {
 	__u8  e820_entries;				/* 0x1e8 */
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
-	__u8  _pad6[6];					/* 0x1eb */
+	__u8  kbd_status;				/* 0x1eb */
+	__u8  _pad6[5];					/* 0x1ec */
 	struct setup_header hdr;    /* setup header */	/* 0x1f1 */
 	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
 	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 63a2a03..93e1c55 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -5,8 +5,8 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
-#ifdef CONFIG_X86_64
-struct dma_map_ops *dma_ops;
+#ifdef CONFIG_X86_DEV_DMA_OPS
+	struct dma_map_ops *dma_ops;
 #endif
 #if defined(CONFIG_INTEL_IOMMU) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 4b4331d..61c0bd2 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -30,7 +30,7 @@ extern struct dma_map_ops *dma_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-#ifdef CONFIG_X86_32
+#ifndef CONFIG_X86_DEV_DMA_OPS
 	return dma_ops;
 #else
 	if (unlikely(!dev) || !dev->archdata.dma_ops)
@@ -62,6 +62,12 @@ extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
 					struct dma_attrs *attrs);
 
+#ifdef CONFIG_X86_DMA_REMAP /* Platform code defines bridge-specific code */
+extern bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);
+extern dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr);
+extern phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr);
+#else
+
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
@@ -79,6 +85,7 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 {
 	return daddr;
 }
+#endif /* CONFIG_X86_DMA_REMAP */
 
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
diff --git a/arch/x86/include/asm/kbdleds.h b/arch/x86/include/asm/kbdleds.h
new file mode 100644
index 0000000..f27ac5f
--- /dev/null
+++ b/arch/x86/include/asm/kbdleds.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_X86_KBDLEDS_H
+#define _ASM_X86_KBDLEDS_H
+
+/*
+ * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
+ * This seems a good reason to start with NumLock off. That's why on X86 we
+ * ask the bios for the correct state.
+ */
+
+#include <asm/setup.h>
+
+static inline int kbd_defleds(void)
+{
+	return boot_params.kbd_status & 0x20 ? (1 << VC_NUMLOCK) : 0;
+}
+
+#endif /* _ASM_X86_KBDLEDS_H */
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index a1d804b..8eeb55a 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/pci_ids.h>
 #include <linux/pci_regs.h>
+#include <linux/smp.h>
 
 #include <asm/apic.h>
 #include <asm/pci-direct.h>
@@ -22,6 +23,8 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 
+#define TOPOLOGY_REGISTER_OFFSET 0x10
+
 #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
 /*
  * Interrupt control on vSMPowered systems:
@@ -149,12 +152,49 @@ int is_vsmp_box(void)
 	return 0;
 }
 #endif
+
+static void __init vsmp_cap_cpus(void)
+{
+#if !defined(CONFIG_X86_VSMP) && defined(CONFIG_SMP)
+	void __iomem *address;
+	unsigned int cfg, topology, node_shift, maxcpus;
+
+	/*
+	 * CONFIG_X86_VSMP is not configured, so limit the number CPUs to the
+	 * ones present in the first board, unless explicitly overridden by
+	 * setup_max_cpus
+	 */
+	if (setup_max_cpus != NR_CPUS)
+		return;
+
+	/* Read the vSMP Foundation topology register */
+	cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
+	address = early_ioremap(cfg + TOPOLOGY_REGISTER_OFFSET, 4);
+	if (WARN_ON(!address))
+		return;
+
+	topology = readl(address);
+	node_shift = (topology >> 16) & 0x7;
+	if (!node_shift)
+		/* The value 0 should be decoded as 8 */
+		node_shift = 8;
+	maxcpus = (topology & ((1 << node_shift) - 1)) + 1;
+
+	pr_info("vSMP CTL: Capping CPUs to %d (CONFIG_X86_VSMP is unset)\n",
+		maxcpus);
+	setup_max_cpus = maxcpus;
+	early_iounmap(address, 4);
+#endif
+}
+
 void __init vsmp_init(void)
 {
 	detect_vsmp_box();
 	if (!is_vsmp_box())
 		return;
 
+	vsmp_cap_cpus();
+
 	set_vsmp_pv_ops();
 	return;
 }
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index e76e18c..3af5a1e 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_X86_INTEL_CE)      += ce4100.o
 obj-$(CONFIG_ACPI)		+= acpi.o
 obj-y				+= legacy.o irq.o
 
+obj-$(CONFIG_STA2X11)           += sta2x11-fixup.o
+
 obj-$(CONFIG_X86_VISWS)		+= visws.o
 
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
new file mode 100644
index 0000000..9d8a509
--- /dev/null
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -0,0 +1,366 @@
+/*
+ * arch/x86/pci/sta2x11-fixup.c
+ * glue code for lib/swiotlb.c and DMA translation between STA2x11
+ * AMBA memory mapping and the X86 memory mapping
+ *
+ * ST Microelectronics ConneXt (STA2X11/STA2X10)
+ *
+ * Copyright (c) 2010-2011 Wind River Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/export.h>
+#include <linux/list.h>
+
+#define STA2X11_SWIOTLB_SIZE (4*1024*1024)
+extern int swiotlb_late_init_with_default_size(size_t default_size);
+
+/*
+ * We build a list of bus numbers that are under the ConneXt. The
+ * main bridge hosts 4 busses, which are the 4 endpoints, in order.
+ */
+#define STA2X11_NR_EP		4	/* 0..3 included */
+#define STA2X11_NR_FUNCS	8	/* 0..7 included */
+#define STA2X11_AMBA_SIZE	(512 << 20)
+
+struct sta2x11_ahb_regs { /* saved during suspend */
+	u32 base, pexlbase, pexhbase, crw;
+};
+
+struct sta2x11_mapping {
+	u32 amba_base;
+	int is_suspended;
+	struct sta2x11_ahb_regs regs[STA2X11_NR_FUNCS];
+};
+
+struct sta2x11_instance {
+	struct list_head list;
+	int bus0;
+	struct sta2x11_mapping map[STA2X11_NR_EP];
+};
+
+static LIST_HEAD(sta2x11_instance_list);
+
+/* At probe time, record new instances of this bridge (likely one only) */
+static void sta2x11_new_instance(struct pci_dev *pdev)
+{
+	struct sta2x11_instance *instance;
+
+	instance = kzalloc(sizeof(*instance), GFP_ATOMIC);
+	if (!instance)
+		return;
+	/* This has a subordinate bridge, with 4 more-subordinate ones */
+	instance->bus0 = pdev->subordinate->number + 1;
+
+	if (list_empty(&sta2x11_instance_list)) {
+		int size = STA2X11_SWIOTLB_SIZE;
+		/* First instance: register your own swiotlb area */
+		dev_info(&pdev->dev, "Using SWIOTLB (size %i)\n", size);
+		if (swiotlb_late_init_with_default_size(size))
+			dev_emerg(&pdev->dev, "init swiotlb failed\n");
+	}
+	list_add(&instance->list, &sta2x11_instance_list);
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, 0xcc17, sta2x11_new_instance);
+
+/*
+ * Utility functions used in this file from below
+ */
+static struct sta2x11_instance *sta2x11_pdev_to_instance(struct pci_dev *pdev)
+{
+	struct sta2x11_instance *instance;
+	int ep;
+
+	list_for_each_entry(instance, &sta2x11_instance_list, list) {
+		ep = pdev->bus->number - instance->bus0;
+		if (ep >= 0 && ep < STA2X11_NR_EP)
+			return instance;
+	}
+	return NULL;
+}
+
+static int sta2x11_pdev_to_ep(struct pci_dev *pdev)
+{
+	struct sta2x11_instance *instance;
+
+	instance = sta2x11_pdev_to_instance(pdev);
+	if (!instance)
+		return -1;
+
+	return pdev->bus->number - instance->bus0;
+}
+
+static struct sta2x11_mapping *sta2x11_pdev_to_mapping(struct pci_dev *pdev)
+{
+	struct sta2x11_instance *instance;
+	int ep;
+
+	instance = sta2x11_pdev_to_instance(pdev);
+	if (!instance)
+		return NULL;
+	ep = sta2x11_pdev_to_ep(pdev);
+	return instance->map + ep;
+}
+
+/* This is exported, as some devices need to access the MFD registers */
+struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev)
+{
+	return sta2x11_pdev_to_instance(pdev);
+}
+EXPORT_SYMBOL(sta2x11_get_instance);
+
+
+/**
+ * p2a - Translate physical address to STA2x11 AMBA address,
+ *       used for DMA transfers to STA2x11
+ * @p: Physical address
+ * @pdev: PCI device (must be hosted within the connext)
+ */
+static dma_addr_t p2a(dma_addr_t p, struct pci_dev *pdev)
+{
+	struct sta2x11_mapping *map;
+	dma_addr_t a;
+
+	map = sta2x11_pdev_to_mapping(pdev);
+	a = p + map->amba_base;
+	return a;
+}
+
+/**
+ * a2p - Translate STA2x11 AMBA address to physical address
+ *       used for DMA transfers from STA2x11
+ * @a: STA2x11 AMBA address
+ * @pdev: PCI device (must be hosted within the connext)
+ */
+static dma_addr_t a2p(dma_addr_t a, struct pci_dev *pdev)
+{
+	struct sta2x11_mapping *map;
+	dma_addr_t p;
+
+	map = sta2x11_pdev_to_mapping(pdev);
+	p = a - map->amba_base;
+	return p;
+}
+
+/**
+ * sta2x11_swiotlb_alloc_coherent - Allocate swiotlb bounce buffers
+ *     returns virtual address. This is the only "special" function here.
+ * @dev: PCI device
+ * @size: Size of the buffer
+ * @dma_handle: DMA address
+ * @flags: memory flags
+ */
+static void *sta2x11_swiotlb_alloc_coherent(struct device *dev,
+					    size_t size,
+					    dma_addr_t *dma_handle,
+					    gfp_t flags,
+					    struct dma_attrs *attrs)
+{
+	void *vaddr;
+
+	vaddr = dma_generic_alloc_coherent(dev, size, dma_handle, flags, attrs);
+	if (!vaddr)
+		vaddr = swiotlb_alloc_coherent(dev, size, dma_handle, flags);
+	*dma_handle = p2a(*dma_handle, to_pci_dev(dev));
+	return vaddr;
+}
+
+/* We have our own dma_ops: the same as swiotlb but from alloc (above) */
+static struct dma_map_ops sta2x11_dma_ops = {
+	.alloc = sta2x11_swiotlb_alloc_coherent,
+	.free = swiotlb_free_coherent,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
+	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = swiotlb_sync_sg_for_device,
+	.mapping_error = swiotlb_dma_mapping_error,
+	.dma_supported = NULL, /* FIXME: we should use this instead! */
+};
+
+/* At setup time, we use our own ops if the device is a ConneXt one */
+static void sta2x11_setup_pdev(struct pci_dev *pdev)
+{
+	struct sta2x11_instance *instance = sta2x11_pdev_to_instance(pdev);
+
+	if (!instance) /* either a sta2x11 bridge or another ST device */
+		return;
+	pci_set_consistent_dma_mask(pdev, STA2X11_AMBA_SIZE - 1);
+	pci_set_dma_mask(pdev, STA2X11_AMBA_SIZE - 1);
+	pdev->dev.archdata.dma_ops = &sta2x11_dma_ops;
+
+	/* We must enable all devices as master, for audio DMA to work */
+	pci_set_master(pdev);
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, sta2x11_setup_pdev);
+
+/*
+ * The following three functions are exported (used in swiotlb: FIXME)
+ */
+/**
+ * dma_capable - Check if device can manage DMA transfers (FIXME: kill it)
+ * @dev: device for a PCI device
+ * @addr: DMA address
+ * @size: DMA size
+ */
+bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	struct sta2x11_mapping *map;
+
+	if (dev->archdata.dma_ops != &sta2x11_dma_ops) {
+		if (!dev->dma_mask)
+			return false;
+		return addr + size - 1 <= *dev->dma_mask;
+	}
+
+	map = sta2x11_pdev_to_mapping(to_pci_dev(dev));
+
+	if (!map || (addr < map->amba_base))
+		return false;
+	if (addr + size >= map->amba_base + STA2X11_AMBA_SIZE) {
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * phys_to_dma - Return the DMA AMBA address used for this STA2x11 device
+ * @dev: device for a PCI device
+ * @paddr: Physical address
+ */
+dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	if (dev->archdata.dma_ops != &sta2x11_dma_ops)
+		return paddr;
+	return p2a(paddr, to_pci_dev(dev));
+}
+
+/**
+ * dma_to_phys - Return the physical address used for this STA2x11 DMA address
+ * @dev: device for a PCI device
+ * @daddr: STA2x11 AMBA DMA address
+ */
+phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	if (dev->archdata.dma_ops != &sta2x11_dma_ops)
+		return daddr;
+	return a2p(daddr, to_pci_dev(dev));
+}
+
+
+/*
+ * At boot we must set up the mappings for the pcie-to-amba bridge.
+ * It involves device access, and the same happens at suspend/resume time
+ */
+
+#define AHB_MAPB		0xCA4
+#define AHB_CRW(i)		(AHB_MAPB + 0  + (i) * 0x10)
+#define AHB_CRW_SZMASK			0xfffffc00UL
+#define AHB_CRW_ENABLE			(1 << 0)
+#define AHB_CRW_WTYPE_MEM		(2 << 1)
+#define AHB_CRW_ROE			(1UL << 3)	/* Relax Order Ena */
+#define AHB_CRW_NSE			(1UL << 4)	/* No Snoop Enable */
+#define AHB_BASE(i)		(AHB_MAPB + 4  + (i) * 0x10)
+#define AHB_PEXLBASE(i)		(AHB_MAPB + 8  + (i) * 0x10)
+#define AHB_PEXHBASE(i)		(AHB_MAPB + 12 + (i) * 0x10)
+
+/* At probe time, enable mapping for each endpoint, using the pdev */
+static void sta2x11_map_ep(struct pci_dev *pdev)
+{
+	struct sta2x11_mapping *map = sta2x11_pdev_to_mapping(pdev);
+	int i;
+
+	if (!map)
+		return;
+	pci_read_config_dword(pdev, AHB_BASE(0), &map->amba_base);
+
+	/* Configure AHB mapping */
+	pci_write_config_dword(pdev, AHB_PEXLBASE(0), 0);
+	pci_write_config_dword(pdev, AHB_PEXHBASE(0), 0);
+	pci_write_config_dword(pdev, AHB_CRW(0), STA2X11_AMBA_SIZE |
+			       AHB_CRW_WTYPE_MEM | AHB_CRW_ENABLE);
+
+	/* Disable all the other windows */
+	for (i = 1; i < STA2X11_NR_FUNCS; i++)
+		pci_write_config_dword(pdev, AHB_CRW(i), 0);
+
+	dev_info(&pdev->dev,
+		 "sta2x11: Map EP %i: AMBA address %#8x-%#8x\n",
+		 sta2x11_pdev_to_ep(pdev),  map->amba_base,
+		 map->amba_base + STA2X11_AMBA_SIZE - 1);
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, sta2x11_map_ep);
+
+#ifdef CONFIG_PM /* Some register values must be saved and restored */
+
+static void suspend_mapping(struct pci_dev *pdev)
+{
+	struct sta2x11_mapping *map = sta2x11_pdev_to_mapping(pdev);
+	int i;
+
+	if (!map)
+		return;
+
+	if (map->is_suspended)
+		return;
+	map->is_suspended = 1;
+
+	/* Save all window configs */
+	for (i = 0; i < STA2X11_NR_FUNCS; i++) {
+		struct sta2x11_ahb_regs *regs = map->regs + i;
+
+		pci_read_config_dword(pdev, AHB_BASE(i), &regs->base);
+		pci_read_config_dword(pdev, AHB_PEXLBASE(i), &regs->pexlbase);
+		pci_read_config_dword(pdev, AHB_PEXHBASE(i), &regs->pexhbase);
+		pci_read_config_dword(pdev, AHB_CRW(i), &regs->crw);
+	}
+}
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, suspend_mapping);
+
+static void resume_mapping(struct pci_dev *pdev)
+{
+	struct sta2x11_mapping *map = sta2x11_pdev_to_mapping(pdev);
+	int i;
+
+	if (!map)
+		return;
+
+
+	if (!map->is_suspended)
+		goto out;
+	map->is_suspended = 0;
+
+	/* Restore all window configs */
+	for (i = 0; i < STA2X11_NR_FUNCS; i++) {
+		struct sta2x11_ahb_regs *regs = map->regs + i;
+
+		pci_write_config_dword(pdev, AHB_BASE(i), regs->base);
+		pci_write_config_dword(pdev, AHB_PEXLBASE(i), regs->pexlbase);
+		pci_write_config_dword(pdev, AHB_PEXHBASE(i), regs->pexhbase);
+		pci_write_config_dword(pdev, AHB_CRW(i), regs->crw);
+	}
+out:
+	pci_set_master(pdev); /* Like at boot, enable master on all devices */
+}
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, resume_mapping);
+
+#endif /* CONFIG_PM */
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index 1d4c783..04b8c73 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/pm_wakeup.h>
 #include <linux/mfd/core.h>
 #include <linux/power_supply.h>
 #include <linux/suspend.h>
@@ -83,8 +84,12 @@ static void send_ebook_state(void)
 		return;
 	}
 
+	if (!!test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == state)
+		return; /* Nothing new to report. */
+
 	input_report_switch(ebook_switch_idev, SW_TABLET_MODE, state);
 	input_sync(ebook_switch_idev);
+	pm_wakeup_event(&ebook_switch_idev->dev, 0);
 }
 
 static void flip_lid_inverter(void)
@@ -123,8 +128,12 @@ static void detect_lid_state(void)
 /* Report current lid switch state through input layer */
 static void send_lid_state(void)
 {
+	if (!!test_bit(SW_LID, lid_switch_idev->sw) == !lid_open)
+		return; /* Nothing new to report. */
+
 	input_report_switch(lid_switch_idev, SW_LID, !lid_open);
 	input_sync(lid_switch_idev);
+	pm_wakeup_event(&lid_switch_idev->dev, 0);
 }
 
 static ssize_t lid_wake_mode_show(struct device *dev,
@@ -213,11 +222,30 @@ static irqreturn_t xo1_sci_intr(int irq, void *dev_id)
 
 	dev_dbg(&pdev->dev, "sts %x gpe %x\n", sts, gpe);
 
-	if (sts & CS5536_PWRBTN_FLAG && !(sts & CS5536_WAK_FLAG)) {
-		input_report_key(power_button_idev, KEY_POWER, 1);
-		input_sync(power_button_idev);
-		input_report_key(power_button_idev, KEY_POWER, 0);
-		input_sync(power_button_idev);
+	if (sts & CS5536_PWRBTN_FLAG) {
+		if (!(sts & CS5536_WAK_FLAG)) {
+			/* Only report power button input when it was pressed
+			 * during regular operation (as opposed to when it
+			 * was used to wake the system). */
+			input_report_key(power_button_idev, KEY_POWER, 1);
+			input_sync(power_button_idev);
+			input_report_key(power_button_idev, KEY_POWER, 0);
+			input_sync(power_button_idev);
+		}
+		/* Report the wakeup event in all cases. */
+		pm_wakeup_event(&power_button_idev->dev, 0);
+	}
+
+	if ((sts & (CS5536_RTC_FLAG | CS5536_WAK_FLAG)) ==
+			(CS5536_RTC_FLAG | CS5536_WAK_FLAG)) {
+		/* When the system is woken by the RTC alarm, report the
+		 * event on the rtc device. */
+		struct device *rtc = bus_find_device_by_name(
+			&platform_bus_type, NULL, "rtc_cmos");
+		if (rtc) {
+			pm_wakeup_event(rtc, 0);
+			put_device(rtc);
+		}
 	}
 
 	if (gpe & CS5536_GPIOM7_PME_FLAG) { /* EC GPIO */
@@ -310,9 +338,10 @@ static int __devinit setup_sci_interrupt(struct platform_device *pdev)
 		outb(lo, CS5536_PIC_INT_SEL2);
 	}
 
-	/* Enable SCI from power button, and clear pending interrupts */
+	/* Enable interesting SCI events, and clear pending interrupts */
 	sts = inl(acpi_base + CS5536_PM1_STS);
-	outl((CS5536_PM_PWRBTN << 16) | 0xffff, acpi_base + CS5536_PM1_STS);
+	outl(((CS5536_PM_PWRBTN | CS5536_PM_RTC) << 16) | 0xffff,
+	     acpi_base + CS5536_PM1_STS);
 
 	r = request_irq(sci_irq, xo1_sci_intr, 0, DRV_NAME, pdev);
 	if (r)
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 86dd1e3..b021a18 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -53,17 +53,13 @@ extern void ctrl_alt_del(void);
 
 #define KBD_DEFMODE ((1 << VC_REPEAT) | (1 << VC_META))
 
-/*
- * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
- * This seems a good reason to start with NumLock off. On HIL keyboards
- * of PARISC machines however there is no NumLock key and everyone expects the
- * keypad to be used for numbers.
- */
-
-#if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD))
-#define KBD_DEFLEDS (1 << VC_NUMLOCK)
+#if defined(CONFIG_X86) || defined(CONFIG_PARISC)
+#include <asm/kbdleds.h>
 #else
-#define KBD_DEFLEDS 0
+static inline int kbd_defleds(void)
+{
+	return 0;
+}
 #endif
 
 #define KBD_DEFLOCK 0
@@ -1512,8 +1508,8 @@ int __init kbd_init(void)
 	int error;
 
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
-		kbd_table[i].ledflagstate = KBD_DEFLEDS;
-		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
+		kbd_table[i].ledflagstate = kbd_defleds();
+		kbd_table[i].default_ledflagstate = kbd_defleds();
 		kbd_table[i].ledmode = LED_SHOW_FLAGS;
 		kbd_table[i].lockstate = KBD_DEFLOCK;
 		kbd_table[i].slockstate = 0;
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index c077aec..cfe8323 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -95,6 +95,7 @@ static inline int cs5535_pic_unreqz_select_high(unsigned int group,
 
 /* CS5536_PM1_STS bits */
 #define CS5536_WAK_FLAG		(1 << 15)
+#define CS5536_RTC_FLAG		(1 << 10)
 #define CS5536_PWRBTN_FLAG	(1 << 8)
 
 /* CS5536_PM1_EN bits */
