Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0K3Rjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:39:41 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:12525 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754560Ab0K3Ria (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:38:30 -0500
Date: Tue, 30 Nov 2010 20:17:00 +0300
From: Anton Vorontsov <avorontsov@mvista.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Colin Cross <ccross@android.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Jamie Iles <jamie.iles@picochip.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH 2/8] ARM: cns3xxx: Add support for SMP
Message-ID: <20101130171700.GB24034@oksana.dev.rtsoft.ru>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing fancy needs to be done, just use generic SCU routines.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 arch/arm/Kconfig                         |    2 +-
 arch/arm/mach-cns3xxx/Kconfig            |    1 +
 arch/arm/mach-cns3xxx/Makefile           |    1 +
 arch/arm/mach-cns3xxx/include/mach/smp.h |   28 ++++++++++++
 arch/arm/mach-cns3xxx/platsmp.c          |   69 ++++++++++++++++++++++++++++++
 5 files changed, 100 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-cns3xxx/include/mach/smp.h
 create mode 100644 arch/arm/mach-cns3xxx/platsmp.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9aff0e8..38c1697 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1208,7 +1208,7 @@ config SMP
 	depends on REALVIEW_EB_ARM11MP || REALVIEW_EB_A9MP || \
 		 MACH_REALVIEW_PB11MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || \
 		 ARCH_S5PV310 || ARCH_TEGRA || ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || \
-		 ARCH_MSM_SCORPIONMP
+		 ARCH_MSM_SCORPIONMP || ARCH_CNS3XXX
 	select USE_GENERIC_SMP_HELPERS
 	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
 	help
diff --git a/arch/arm/mach-cns3xxx/Kconfig b/arch/arm/mach-cns3xxx/Kconfig
index 9ebfcc4..0ba82aa 100644
--- a/arch/arm/mach-cns3xxx/Kconfig
+++ b/arch/arm/mach-cns3xxx/Kconfig
@@ -3,6 +3,7 @@ menu "CNS3XXX platform type"
 
 config MACH_CNS3420VB
 	bool "Support for CNS3420 Validation Board"
+	select HAVE_ARM_SCU if SMP
 	help
 	  Include support for the Cavium Networks CNS3420 MPCore Platform
 	  Baseboard.
diff --git a/arch/arm/mach-cns3xxx/Makefile b/arch/arm/mach-cns3xxx/Makefile
index 11033f1..ba4ee7b 100644
--- a/arch/arm/mach-cns3xxx/Makefile
+++ b/arch/arm/mach-cns3xxx/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_ARCH_CNS3XXX)		+= core.o pm.o devices.o
+obj-$(CONFIG_SMP)			+= platsmp.o
 obj-$(CONFIG_PCI)			+= pcie.o
 obj-$(CONFIG_MACH_CNS3420VB)		+= cns3420vb.o
diff --git a/arch/arm/mach-cns3xxx/include/mach/smp.h b/arch/arm/mach-cns3xxx/include/mach/smp.h
new file mode 100644
index 0000000..44aa7ea
--- /dev/null
+++ b/arch/arm/mach-cns3xxx/include/mach/smp.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright 2002 ARM Ltd.
+ * Copyright 2008 Cavium Networks
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_SMP_H
+#define __MACH_SMP_H
+
+#include <asm/hardware/gic.h>
+
+#define hard_smp_processor_id()				\
+	({						\
+		unsigned int cpunum;			\
+		__asm__("mrc p15, 0, %0, c0, c0, 5"	\
+			: "=r" (cpunum));		\
+		cpunum &= 0x0F;				\
+	})
+
+static inline void smp_cross_call(const struct cpumask *mask, int ipi)
+{
+	gic_raise_softirq(mask, ipi);
+}
+
+#endif /* __MACH_SMP_H */
diff --git a/arch/arm/mach-cns3xxx/platsmp.c b/arch/arm/mach-cns3xxx/platsmp.c
new file mode 100644
index 0000000..fc1595c
--- /dev/null
+++ b/arch/arm/mach-cns3xxx/platsmp.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright 2002 ARM Ltd
+ * Copyright 2008 Cavium Networks
+ * Copyright 2010 MontaVista Software, LLC.
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+#include <asm/unified.h>
+#include <asm/smp_scu.h>
+#include <mach/cns3xxx.h>
+#include "core.h"
+
+static void __iomem *scu_base_addr(void)
+{
+	return (void __iomem *)CNS3XXX_TC11MP_SCU_BASE_VIRT;
+}
+
+void __cpuinit platform_secondary_init(unsigned int cpu)
+{
+	trace_hardirqs_off();
+
+	/*
+	 * if any interrupts are already enabled for the primary
+	 * core (e.g. timer irq), then they will not have been enabled
+	 * for us: do so
+	 */
+	gic_cpu_init(0, gic_cpu_base_addr);
+
+	scu_secondary_init(cpu);
+}
+
+int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	return scu_boot_secondary(cpu, idle);
+}
+
+void __init smp_init_cpus(void)
+{
+	scu_init_cpus(scu_base_addr());
+}
+
+static void __init poke_milo(void)
+{
+	if (num_present_cpus() <= 1)
+		return;
+	/*
+	 * Write the address of secondary startup into the system-wide flags
+	 * register. The BootMonitor waits for this register to become
+	 * non-zero.
+	 */
+	__raw_writel(BSYM(virt_to_phys(scu_secondary_startup)),
+		     (void __iomem *)(0xFFF07000 + 0x0600));
+
+	mb();
+}
+
+void __init smp_prepare_cpus(unsigned int max_cpus)
+{
+	scu_prepare_cpus(scu_base_addr(), max_cpus);
+	poke_milo();
+}
-- 
1.7.0.5

