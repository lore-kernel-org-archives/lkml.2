Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2GXBKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:10:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37401 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab2GXBKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:30 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [RFC 22/23] ARM: keystone: enable SMP on Keystone machines
Date: Mon, 23 Jul 2012 21:09:24 -0400
Message-ID: <1343092165-9470-23-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic SMP support for Keystone machines.  Nothing very fancy
here, just enough to get 4 CPUs booted up.  This does not include support for
hotplug, etc.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/Kconfig                    |    1 +
 arch/arm/configs/keystone_defconfig |    2 +
 arch/arm/mach-keystone/Makefile     |    1 +
 arch/arm/mach-keystone/keystone.c   |    3 ++
 arch/arm/mach-keystone/platsmp.c    |   73 +++++++++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+)
 create mode 100644 arch/arm/mach-keystone/platsmp.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 04c846b..5b82879 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -372,6 +372,7 @@ config ARCH_KEYSTONE
 	select SPARSE_IRQ
 	select NEED_MACH_MEMORY_H
 	select HAVE_SCHED_CLOCK
+	select HAVE_SMP
 	help
 	  Support for boards based on the Texas Instruments Keystone family of
 	  SoCs.
diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index 7f2a04b..5f71e66 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -1,7 +1,9 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_ARCH_KEYSTONE=y
+CONFIG_SMP=y
 CONFIG_ARM_ARCH_TIMER=y
+CONFIG_NR_CPUS=4
 CONFIG_AEABI=y
 CONFIG_HIGHMEM=y
 CONFIG_VFP=y
diff --git a/arch/arm/mach-keystone/Makefile b/arch/arm/mach-keystone/Makefile
index d4671d5..3f6b8ab 100644
--- a/arch/arm/mach-keystone/Makefile
+++ b/arch/arm/mach-keystone/Makefile
@@ -1 +1,2 @@
 obj-y					:= keystone.o
+obj-$(CONFIG_SMP)			+= platsmp.o
diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
index 9583dc4..650e202 100644
--- a/arch/arm/mach-keystone/keystone.c
+++ b/arch/arm/mach-keystone/keystone.c
@@ -26,6 +26,8 @@
 #include <asm/mach/time.h>
 #include <asm/hardware/gic.h>
 
+extern struct smp_ops keystone_smp_ops;
+
 static struct map_desc io_desc[] = {
 	{
 		.virtual        = 0xfe800000UL,
@@ -73,6 +75,7 @@ static const char *keystone_match[] __initconst = {
 };
 
 DT_MACHINE_START(KEYSTONE, "Keystone")
+	smp_ops(keystone_smp_ops)
 	.map_io		= keystone_map_io,
 	.init_irq	= keystone_init_irq,
 	.timer		= &keystone_timer,
diff --git a/arch/arm/mach-keystone/platsmp.c b/arch/arm/mach-keystone/platsmp.c
new file mode 100644
index 0000000..437659a
--- /dev/null
+++ b/arch/arm/mach-keystone/platsmp.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright 2012 Texas Instruments, Inc.
+ *
+ * Based on platsmp.c, Copyright 2010-2011 Calxeda, Inc.
+ * Based on platsmp.c, Copyright (C) 2002 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+
+#include <asm/smp_plat.h>
+#include <asm/smp_ops.h>
+#include <asm/hardware/gic.h>
+#include <asm/cacheflush.h>
+#include <asm/memory.h>
+
+extern void secondary_startup(void);
+
+static void __init keystone_smp_init_cpus(void)
+{
+	unsigned int i, ncores;
+
+	ncores = 4;
+
+	/* sanity check */
+	if (ncores > NR_CPUS) {
+		pr_warn("restricted to %d cpus\n", NR_CPUS);
+		ncores = NR_CPUS;
+	}
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
+
+	set_smp_cross_call(gic_raise_softirq);
+}
+
+static void __init keystone_smp_prepare_cpus(unsigned int max_cpus)
+{
+	/* nothing for now */
+}
+
+static void __cpuinit keystone_secondary_init(unsigned int cpu)
+{
+	gic_secondary_init(0);
+}
+
+static int __cpuinit
+keystone_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long *jump_ptr = phys_to_virt(0x800001f0);
+
+	jump_ptr[cpu] = virt_to_idmap(&secondary_startup);
+	__cpuc_flush_dcache_area(jump_ptr, sizeof(jump_ptr) * 4);
+
+	return 0;
+}
+
+struct smp_ops keystone_smp_ops __initdata = {
+	smp_init_ops(keystone)
+	smp_secondary_ops(keystone)
+};
-- 
1.7.9.5

