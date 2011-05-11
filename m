Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1EKUOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:14:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab1EKUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:14:12 -0400
Subject: [PATCH v6 2/5] arm/dt: Allow CONFIG_OF on ARM
To: linaro-dev@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 May 2011 22:14:07 +0200
Message-ID: <20110511201407.21615.38296.stgit@localhost6.localdomain6>
In-Reply-To: <20110511201401.21615.38893.stgit@localhost6.localdomain6>
References: <20110511201401.21615.38893.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some basic empty infrastructure for DT support on ARM.

v5: - Fix off-by-one error in size calculation of initrd
    - Stop mucking with cmd_line, and load command line from dt into
      boot_command_line instead which matches the behaviour of ATAGS booting
v3: - moved cmd_line export and initrd setup to this patch to make the
      series bisectable.
    - switched to alloc_bootmem_align() for allocation when
      unflattening the device tree.  memblock_alloc() was not the
      right interface.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/Kconfig             |    7 ++++++
 arch/arm/include/asm/prom.h  |   25 ++++++++++++++++++++++
 arch/arm/include/asm/setup.h |    2 ++
 arch/arm/kernel/Makefile     |    1 +
 arch/arm/kernel/devtree.c    |   47 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c      |    2 +-
 arch/arm/mm/init.c           |    9 ++++++++
 7 files changed, 92 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 377a7a5..efc7f3c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1687,6 +1687,13 @@ endmenu
 
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
index 95176af..93b4702 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -217,6 +217,8 @@ extern struct meminfo meminfo;
 #define bank_phys_end(bank)	((bank)->start + (bank)->size)
 #define bank_phys_size(bank)	(bank)->size
 
+extern int arm_add_memory(phys_addr_t start, unsigned long size);
+
 #endif  /*  __KERNEL__  */
 
 #endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 8d95446..908c78c 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
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
index 006c1e8..109997e 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -466,7 +466,7 @@ static struct machine_desc * __init setup_machine(unsigned int nr)
 		/* can't use cpu_relax() here as it may require MMU setup */;
 }
 
-static int __init arm_add_memory(phys_addr_t start, unsigned long size)
+int __init arm_add_memory(phys_addr_t start, unsigned long size)
 {
 	struct membank *bank = &meminfo.bank[meminfo.nr_banks];
 
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index e5f6fc4..26c4054 100644
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
+	phys_initrd_size = end - start;
+}
+#endif /* CONFIG_OF_FLATTREE */
+
 /*
  * This keeps memory configuration data used by a couple memory
  * initialization functions, as well as show_mem() for the skipping

