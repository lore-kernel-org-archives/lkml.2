Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1GQPJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:09:36 -0400
Received: from mail.southpole.se ([193.12.106.18]:34885 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1GQPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:09:31 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v3 02/19] OpenRISC: Device tree
Date: Sun, 17 Jul 2011 17:08:12 +0200
Message-Id: <9d4c1c7ae28f027add68250cf804eaffad748f8c.1310913472.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The OpenRISC architecture uses the device tree infrastructure for the
platform description.  This is currently limited to having a device tree
built into the kernel, but work is underway within the OpenRISC project
to define how this device tree blob should be passed into the kernel from
an external resource.

Patch contains a single example DTS file to go with the defconfig for
or1ksim.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
Cc: devicetree-discuss@lists.ozlabs.org
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/openrisc/boot/dts/or1ksim.dts |   50 +++++++++++++++++
 arch/openrisc/include/asm/prom.h   |   77 +++++++++++++++++++++++++
 arch/openrisc/kernel/prom.c        |  108 ++++++++++++++++++++++++++++++++++++
 3 files changed, 235 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/boot/dts/or1ksim.dts
 create mode 100644 arch/openrisc/include/asm/prom.h
 create mode 100644 arch/openrisc/kernel/prom.c

diff --git a/arch/openrisc/boot/dts/or1ksim.dts b/arch/openrisc/boot/dts/or1ksim.dts
new file mode 100644
index 0000000..5d4f902
--- /dev/null
+++ b/arch/openrisc/boot/dts/or1ksim.dts
@@ -0,0 +1,50 @@
+/dts-v1/;
+/ {
+	compatible = "opencores,or1ksim";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&pic>;
+
+	chosen {
+		bootargs = "console=uart,mmio,0x90000000,115200";
+	};
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x02000000>;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		cpu@0 {
+			compatible = "opencores,or1200-rtlsvn481";
+			reg = <0>;
+			clock-frequency = <20000000>;
+		};
+	};
+
+	/*
+	 * OR1K PIC is built into CPU and accessed via special purpose
+	 * registers.  It is not addressable and, hence, has no 'reg'
+	 * property.
+	 */
+	pic: pic {
+		compatible = "opencores,or1k-pic";
+		#interrupt-cells = <1>;
+		interrupt-controller;
+	};
+
+	serial0: serial@90000000 {
+		compatible = "opencores,uart16550-rtlsvn105", "ns16550a";
+		reg = <0x90000000 0x100>;
+		interrupts = <2>;
+		clock-frequency = <20000000>;
+	};
+
+	enet0: ethoc@92000000 {
+		compatible = "opencores,ethmac-rtlsvn338";
+		reg = <0x92000000 0x100>;
+		interrupts = <4>;
+	};
+};
diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
new file mode 100644
index 0000000..e1f3fe2
--- /dev/null
+++ b/arch/openrisc/include/asm/prom.h
@@ -0,0 +1,77 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/of.h>	/* linux/of.h gets to determine #include ordering */
+
+#ifndef _ASM_OPENRISC_PROM_H
+#define _ASM_OPENRISC_PROM_H
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <asm/irq.h>
+#include <linux/atomic.h>
+#include <linux/of_irq.h>
+#include <linux/of_fdt.h>
+#include <linux/of_address.h>
+#include <linux/proc_fs.h>
+#include <linux/platform_device.h>
+#define HAVE_ARCH_DEVTREE_FIXUPS
+
+/* Other Prototypes */
+extern int early_uartlite_console(void);
+
+/* Parse the ibm,dma-window property of an OF node into the busno, phys and
+ * size parameters.
+ */
+void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
+		unsigned long *busno, unsigned long *phys, unsigned long *size);
+
+extern void kdump_move_device_tree(void);
+
+/* CPU OF node matching */
+struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
+
+/* Get the MAC address */
+extern const void *of_get_mac_address(struct device_node *np);
+
+/**
+ * of_irq_map_pci - Resolve the interrupt for a PCI device
+ * @pdev:	the device whose interrupt is to be resolved
+ * @out_irq:	structure of_irq filled by this function
+ *
+ * This function resolves the PCI interrupt for a given PCI device. If a
+ * device-node exists for a given pci_dev, it will use normal OF tree
+ * walking. If not, it will implement standard swizzling and walk up the
+ * PCI tree until an device-node is found, at which point it will finish
+ * resolving using the OF tree walking.
+ */
+struct pci_dev;
+extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
+
+/* This routine is here to provide compatibility with how powerpc
+ * handles IRQ mapping for OF device nodes.  We precompute and permanently
+ * register them in the platform_device objects, whereas powerpc computes them
+ * on request.
+ */
+static inline void irq_dispose_mapping(unsigned int virq)
+{
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+#endif /* _ASM_OPENRISC_PROM_H */
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
new file mode 100644
index 0000000..1bb58ba
--- /dev/null
+++ b/arch/openrisc/kernel/prom.c
@@ -0,0 +1,108 @@
+/*
+ * OpenRISC prom.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * Architecture specific procedures for creating, accessing and
+ * interpreting the device tree.
+ *
+ */
+
+#include <stdarg.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/threads.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/stringify.h>
+#include <linux/delay.h>
+#include <linux/initrd.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/kexec.h>
+#include <linux/debugfs.h>
+#include <linux/irq.h>
+#include <linux/memblock.h>
+#include <linux/of_fdt.h>
+
+#include <asm/prom.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/irq.h>
+#include <linux/io.h>
+#include <asm/system.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+
+extern char cmd_line[COMMAND_LINE_SIZE];
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	size &= PAGE_MASK;
+	memblock_add(base, size);
+}
+
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return __va(memblock_alloc(size, align));
+}
+
+void __init early_init_devtree(void *params)
+{
+	void *alloc;
+
+	/* Setup flat device-tree pointer */
+	initial_boot_params = params;
+
+
+	/* Retrieve various informations from the /chosen node of the
+	 * device-tree, including the platform type, initrd location and
+	 * size, TCE reserve, and more ...
+	 */
+	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
+
+	/* Scan memory nodes and rebuild MEMBLOCKs */
+	memblock_init();
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+
+	/* Save command line for /proc/cmdline and then parse parameters */
+	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
+
+	memblock_analyze();
+
+	/* We must copy the flattend device tree from init memory to regular
+	 * memory because the device tree references the strings in it
+	 * directly.
+	 */
+
+	alloc = __va(memblock_alloc(initial_boot_params->totalsize, PAGE_SIZE));
+
+	memcpy(alloc, initial_boot_params, initial_boot_params->totalsize);
+
+	initial_boot_params = alloc;
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void __init early_init_dt_setup_initrd_arch(unsigned long start,
+		unsigned long end)
+{
+	initrd_start = (unsigned long)__va(start);
+	initrd_end = (unsigned long)__va(end);
+	initrd_below_start_ok = 1;
+}
+#endif
-- 
1.7.4.1

