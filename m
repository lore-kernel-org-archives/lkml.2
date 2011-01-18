Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1ARU3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:29:22 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61497 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab1ARU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:29:18 -0500
Subject: [PATCH 3/8] arm/dt: Allow CONFIG_OF on ARM
To: linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        John Linn <John.Linn@xilinx.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
Date: Tue, 18 Jan 2011 13:29:12 -0700
Message-ID: <20110118202912.13011.54485.stgit@localhost6.localdomain6>
In-Reply-To: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Add some basic empty infrastructure for DT support on ARM.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/Kconfig             |    7 ++++++
 arch/arm/include/asm/prom.h  |   25 ++++++++++++++++++++++
 arch/arm/include/asm/setup.h |    1 +
 arch/arm/kernel/Makefile     |    1 +
 arch/arm/kernel/devtree.c    |   47 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c      |    2 +-
 6 files changed, 82 insertions(+), 1 deletions(-)
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
index 0f3e0ac..0809235 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -222,6 +222,7 @@ extern struct meminfo meminfo;
 #define bank_phys_size(bank)	(bank)->size
 
 extern void arm_reserve_devtree(unsigned long start, unsigned long size);
+extern int arm_add_memory(unsigned long start, unsigned long size);
 
 #endif  /*  __KERNEL__  */
 
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
index 0000000..ac48da2
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
+	return __va(memblock_alloc(size, align));
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
index 420b8d6..d211609 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -443,7 +443,7 @@ static struct machine_desc * __init setup_machine(unsigned int nr)
 	return list;
 }
 
-static int __init arm_add_memory(unsigned long start, unsigned long size)
+int __init arm_add_memory(unsigned long start, unsigned long size)
 {
 	struct membank *bank = &meminfo.bank[meminfo.nr_banks];
 

