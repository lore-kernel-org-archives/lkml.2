Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1BWVtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:49:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:57017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab1BWVtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:49:49 -0500
Date: Wed, 23 Feb 2011 21:49:35 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1298405266-1624-3-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-3-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Add device tree support
Message-ID: <tip-da6b737b9ab768dd06bb4b0395131d10e524cf83@git.kernel.org>
Git-Commit-ID: da6b737b9ab768dd06bb4b0395131d10e524cf83
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 21:49:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da6b737b9ab768dd06bb4b0395131d10e524cf83
Gitweb:     http://git.kernel.org/tip/da6b737b9ab768dd06bb4b0395131d10e524cf83
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 22 Feb 2011 21:07:37 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Feb 2011 22:27:52 +0100

x86: Add device tree support

This patch adds minimal support for device tree on x86. The device
tree blob is passed to the kernel via setup_data which requires at
least boot protocol 2.09.

Memory size, restricted memory regions, boot arguments are gathered
the traditional way so things like cmd_line are just here to let the
code compile.

The current plan is use the device tree as an extension and to gather
information which can not be enumerated and would have to be hardcoded
otherwise. This includes things like 
   - which devices are on this I2C/SPI bus?
   - how are the interrupts wired to IO APIC?
   - where could my hpet be?

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: sodaville@linutronix.de
Cc: devicetree-discuss@lists.ozlabs.org
LKML-Reference: <1298405266-1624-3-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/devicetree/booting-without-of.txt |   20 +++++++++
 arch/x86/Kconfig                                |    2 +
 arch/x86/include/asm/bootparam.h                |    1 +
 arch/x86/include/asm/irq.h                      |    3 -
 arch/x86/include/asm/prom.h                     |   48 +++++++++++++++++++++-
 arch/x86/kernel/Makefile                        |    1 +
 arch/x86/kernel/devicetree.c                    |   51 +++++++++++++++++++++++
 arch/x86/kernel/irq.c                           |    9 ----
 arch/x86/kernel/setup.c                         |    4 ++
 9 files changed, 126 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 28b1c9d..55fd262 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -13,6 +13,7 @@ Table of Contents
 
   I - Introduction
     1) Entry point for arch/powerpc
+    2) Entry point for arch/x86
 
   II - The DT block format
     1) Header
@@ -225,6 +226,25 @@ it with special cases.
   cannot support both configurations with Book E and configurations
   with classic Powerpc architectures.
 
+2) Entry point for arch/x86
+-------------------------------
+
+  There is one single 32bit entry point to the kernel at code32_start,
+  the decompressor (the real mode entry point goes to the same  32bit
+  entry point once it switched into protected mode). That entry point
+  supports one calling convention which is documented in
+  Documentation/x86/boot.txt
+  The physical pointer to the device-tree block (defined in chapter II)
+  is passed via setup_data which requires at least boot protocol 2.09.
+  The type filed is defined as
+
+  #define SETUP_DTB                      2
+
+  This device-tree is used as an extension to the "boot page". As such it
+  does not parse / consider data which is already covered by the boot
+  page. This includes memory size, reserved ranges, command line arguments
+  or initrd address. It simply holds information which can not be retrieved
+  otherwise like interrupt routing or a list of devices behind an I2C bus.
 
 II - The DT block format
 ========================
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index efbae0c..b4c2e9c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -382,6 +382,8 @@ config X86_INTEL_CE
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
 	select X86_REBOOTFIXUPS
+	select OF
+	select OF_EARLY_FLATTREE
 	---help---
 	  Select for the Intel CE media processor (CE4100) SOC.
 	  This option compiles in support for the CE4100 SOC for settop
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index c8bfe63..e020d88 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -12,6 +12,7 @@
 /* setup data types */
 #define SETUP_NONE			0
 #define SETUP_E820_EXT			1
+#define SETUP_DTB			2
 
 /* extensible setup data list node */
 struct setup_data {
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index c704b38..ba870bb 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -10,9 +10,6 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
-/* Even though we don't support this, supply it to appease OF */
-static inline void irq_dispose_mapping(unsigned int virq) { }
-
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index b4ec95f..e46f2a2 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -1 +1,47 @@
-/* dummy prom.h; here to make linux/of.h's #includes happy */
+/*
+ * Definitions for Device tree / OpenFirmware handling on X86
+ *
+ * based on arch/powerpc/include/asm/prom.h which is
+ *         Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_X86_PROM_H
+#define _ASM_X86_PROM_H
+#ifndef __ASSEMBLY__
+
+#include <linux/of.h>
+#include <linux/types.h>
+
+#include <asm/irq.h>
+#include <asm/atomic.h>
+#include <asm/setup.h>
+
+#ifdef CONFIG_OF
+extern void add_dtb(u64 data);
+#else
+static inline void add_dtb(u64 data) { }
+#endif
+
+extern char cmd_line[COMMAND_LINE_SIZE];
+
+#define pci_address_to_pio pci_address_to_pio
+unsigned long pci_address_to_pio(phys_addr_t addr);
+
+/**
+ * irq_dispose_mapping - Unmap an interrupt
+ * @virq: linux virq number of the interrupt to unmap
+ *
+ * FIXME: We really should implement proper virq handling like power,
+ * but that's going to be major surgery.
+ */
+static inline void irq_dispose_mapping(unsigned int virq) { }
+
+#define HAVE_ARCH_DEVTREE_FIXUPS
+
+#endif /* __ASSEMBLY__ */
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34244b2..6ac5036 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
+obj-$(CONFIG_OF)			+= devicetree.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
new file mode 100644
index 0000000..0b8f0da
--- /dev/null
+++ b/arch/x86/kernel/devicetree.c
@@ -0,0 +1,51 @@
+/*
+ * Architecture specific OF callbacks.
+ */
+#include <linux/bootmem.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+
+char __initdata cmd_line[COMMAND_LINE_SIZE];
+
+unsigned int irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize)
+{
+	return intspec[0];
+
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
+unsigned long pci_address_to_pio(phys_addr_t address)
+{
+	/*
+	 * The ioport address can be directly used by inX / outX
+	 */
+	BUG_ON(address >= (1 << 16));
+	return (unsigned long)address;
+}
+EXPORT_SYMBOL_GPL(pci_address_to_pio);
+
+void __init early_init_dt_scan_chosen_arch(unsigned long node)
+{
+	BUG();
+}
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	BUG();
+}
+
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
+}
+
+void __init add_dtb(u64 data)
+{
+	initial_boot_params = phys_to_virt((u64) (u32) data +
+				offsetof(struct setup_data, data));
+}
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 387b6a0..7531360 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -276,15 +276,6 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
-#ifdef CONFIG_OF
-unsigned int irq_create_of_mapping(struct device_node *controller,
-		const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-#endif
-
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9521483..33dcbce 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,6 +113,7 @@
 #endif
 #include <asm/mce.h>
 #include <asm/alternative.h>
+#include <asm/prom.h>
 
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
@@ -445,6 +446,9 @@ static void __init parse_setup_data(void)
 		case SETUP_E820_EXT:
 			parse_e820_ext(data);
 			break;
+		case SETUP_DTB:
+			add_dtb(pa_data);
+			break;
 		default:
 			break;
 		}
