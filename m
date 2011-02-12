Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1BLIOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 03:14:52 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:62675 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1BLIOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 03:14:43 -0500
Subject: [PATCH v3 2/6] arm/dt: Allow CONFIG_OF on ARM
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, john.linn@xilinx.com,
        buytenh@wantstofly.org
Date: Sat, 12 Feb 2011 01:14:37 -0700
Message-ID: <20110212081437.15682.77788.stgit@localhost6.localdomain6>
In-Reply-To: <20110212080634.15682.21141.stgit@localhost6.localdomain6>
References: <20110212080634.15682.21141.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Add some basic empty infrastructure for DT support on ARM.

v3: - moved cmd_line export and initrd setup to this patch to make the
      series bisectable.
    - switched to alloc_bootmem_align() for allocation when
      unflattening the device tree.  memblock_alloc() was not the
      right interface.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/Kconfig             |    7 ++++++
 arch/arm/include/asm/prom.h  |   25 ++++++++++++++++++++++
 arch/arm/include/asm/setup.h |    3 +++
 arch/arm/kernel/Makefile     |    1 +
 arch/arm/kernel/devtree.c    |   47 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c      |    4 ++--
 arch/arm/mm/init.c           |    9 ++++++++
 7 files changed, 94 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5cff165..d8a330f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1586,6 +1586,13 @@ endmenu
 
 menu "Boot options"
 
+config USE_OF
+	bool "Flattened Device Tree support"
+	select OF
+	select OF_EARLY_FLATTREE
+	help
+	  Include support for flattened device tree machine descriptions.
+
 # Compressed boot loader in ROM.  Yes, we really want to ask about
 # TEXT and BSS so we preserve their values in the config files.
 config ZBOOT_ROM_TEXT
diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
new file mode 100644
index 0000000..8f1037f
--- /dev/null
+++ b/arch/arm/include/asm/prom.h
@@ -0,0 +1,25 @@
+/*
+ *  arch/arm/include/asm/prom.h
+ *
+ *  Copyright (C) 2009 Canonical Ltd. <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __ASMARM_PROM_H
+#define __ASMARM_PROM_H
+
+#ifdef CONFIG_OF
+
+#include <asm/setup.h>
+#include <asm/irq.h>
+
+static inline void irq_dispose_mapping(unsigned int virq)
+{
+	return;
+}
+
+#endif /* CONFIG_OF */
+#endif /* ASMARM_PROM_H */
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index f1e5a9b..1cec82a 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -221,6 +221,9 @@ extern struct meminfo meminfo;
 #define bank_phys_end(bank)	((bank)->start + (bank)->size)
 #define bank_phys_size(bank)	(bank)->size
 
+extern int arm_add_memory(unsigned long start, unsigned long size);
+extern char cmd_line[COMMAND_LINE_SIZE];
+
 #endif  /*  __KERNEL__  */
 
 #endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 185ee82..8df05fd 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_ARM_UNWIND)	+= unwind.o
 obj-$(CONFIG_HAVE_TCM)		+= tcm.o
+obj-$(CONFIG_OF)		+= devtree.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_SWP_EMULATE)	+= swp_emulate.o
 CFLAGS_swp_emulate.o		:= -Wa,-march=armv7-a
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
new file mode 100644
index 0000000..75e3df8
--- /dev/null
+++ b/arch/arm/kernel/devtree.c
@@ -0,0 +1,47 @@
+/*
+ *  linux/arch/arm/kernel/devtree.c
+ *
+ *  Copyright (C) 2009 Canonical Ltd. <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/bootmem.h>
+#include <linux/memblock.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+
+#include <asm/setup.h>
+#include <asm/page.h>
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	arm_add_memory(base, size);
+}
+
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return alloc_bootmem_align(size, align);
+}
+
+/**
+ * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
+ *
+ * Currently the mapping mechanism is trivial; simple flat hwirq numbers are
+ * mapped 1:1 onto Linux irq numbers.  Cascaded irq controllers are not
+ * supported.
+ */
+unsigned int irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize)
+{
+	return intspec[0];
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 78678b0..0c692c7 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -125,7 +125,7 @@ EXPORT_SYMBOL(elf_platform);
 
 static const char *cpu_name;
 static const char *machine_name;
-static char __initdata cmd_line[COMMAND_LINE_SIZE];
+char cmd_line[COMMAND_LINE_SIZE];
 struct machine_desc *machine_desc __initdata;
 
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
@@ -480,7 +480,7 @@ static struct machine_desc * __init setup_machine(unsigned int nr)
 	return list;
 }
 
-static int __init arm_add_memory(unsigned long start, unsigned long size)
+int __init arm_add_memory(unsigned long start, unsigned long size)
 {
 	struct membank *bank = &meminfo.bank[meminfo.nr_banks];
 
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index cddd684..a2ba1d1 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -15,6 +15,7 @@
 #include <linux/mman.h>
 #include <linux/nodemask.h>
 #include <linux/initrd.h>
+#include <linux/of_fdt.h>
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
@@ -71,6 +72,14 @@ static int __init parse_tag_initrd2(const struct tag *tag)
 
 __tagtable(ATAG_INITRD2, parse_tag_initrd2);
 
+#ifdef CONFIG_OF_FLATTREE
+void __init early_init_dt_setup_initrd_arch(unsigned long start, unsigned long end)
+{
+	phys_initrd_start = start;
+	phys_initrd_size = end - start + 1;
+}
+#endif /* CONFIG_OF_FLATTREE */
+
 /*
  * This keeps memory configuration data used by a couple memory
  * initialization functions, as well as show_mem() for the skipping

