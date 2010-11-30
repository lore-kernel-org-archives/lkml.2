Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0K3Rj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:39:27 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:12526 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754606Ab0K3Ria (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:38:30 -0500
Date: Tue, 30 Nov 2010 20:16:58 +0300
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
Subject: [PATCH 1/8] ARM: SCU: Add common routines for secondary CPU bootup
Message-ID: <20101130171658.GA24034@oksana.dev.rtsoft.ru>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For CNS3xxx we want to reuse the original ARM approach of booting
secondary CPUs. This patch factors out VExpress' code into a common
file, so that now platform code can call these routines.

Note that this patch doesn't convert VExpress platform to the
generic routines. Plus, there are also a lot of other platforms
that might benefit from this change, but we'll convert them via
separate patches.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 arch/arm/include/asm/smp_scu.h |    9 +++
 arch/arm/kernel/Makefile       |    2 +-
 arch/arm/kernel/smp_scu_boot.c |  149 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/smp_scu_head.S |   40 +++++++++++
 4 files changed, 199 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/kernel/smp_scu_boot.c
 create mode 100644 arch/arm/kernel/smp_scu_head.S

diff --git a/arch/arm/include/asm/smp_scu.h b/arch/arm/include/asm/smp_scu.h
index 2376835..271b252 100644
--- a/arch/arm/include/asm/smp_scu.h
+++ b/arch/arm/include/asm/smp_scu.h
@@ -1,7 +1,16 @@
 #ifndef __ASMARM_ARCH_SCU_H
 #define __ASMARM_ARCH_SCU_H
 
+#include <linux/init.h>
+
 unsigned int scu_get_core_count(void __iomem *);
 void scu_enable(void __iomem *);
 
+extern volatile int __cpuinitdata scu_pen_release;
+void scu_secondary_startup(void);
+void __cpuinit scu_secondary_init(unsigned int cpu);
+int __cpuinit scu_boot_secondary(unsigned int cpu, struct task_struct *idle);
+void __init scu_init_cpus(void __iomem *scu_base);
+void __init scu_prepare_cpus(void __iomem *scu_base, unsigned int max_cpus);
+
 #endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 806d5e1..11d946a 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_ARTHUR)		+= arthur.o
 obj-$(CONFIG_ISA_DMA)		+= dma-isa.o
 obj-$(CONFIG_PCI)		+= bios32.o isa.o
 obj-$(CONFIG_SMP)		+= smp.o
-obj-$(CONFIG_HAVE_ARM_SCU)	+= smp_scu.o
+obj-$(CONFIG_HAVE_ARM_SCU)	+= smp_scu.o smp_scu_head.o smp_scu_boot.o
 obj-$(CONFIG_HAVE_ARM_TWD)	+= smp_twd.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
diff --git a/arch/arm/kernel/smp_scu_boot.c b/arch/arm/kernel/smp_scu_boot.c
new file mode 100644
index 0000000..32a1658
--- /dev/null
+++ b/arch/arm/kernel/smp_scu_boot.c
@@ -0,0 +1,149 @@
+/*
+ *  Copyright (C) 2002 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+
+#include <asm/smp_scu.h>
+#include <asm/localtimer.h>
+#include <asm/cacheflush.h>
+
+/*
+ * control for which core is the next to come out of the secondary
+ * boot "holding pen"
+ */
+volatile int __cpuinitdata scu_pen_release = -1;
+
+static DEFINE_SPINLOCK(boot_lock);
+
+void __cpuinit scu_secondary_init(unsigned int cpu)
+{
+	/*
+	 * let the primary processor know we're out of the
+	 * pen, then head off into the C entry point
+	 */
+	scu_pen_release = -1;
+	smp_wmb();
+
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+int __cpuinit scu_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long timeout;
+
+	/*
+	 * Set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+	spin_lock(&boot_lock);
+
+	/*
+	 * This is really belt and braces; we hold unintended secondary
+	 * CPUs in the holding pen until we're ready for them.  However,
+	 * since we haven't sent them a soft interrupt, they shouldn't
+	 * be there.
+	 */
+	scu_pen_release = cpu;
+	__cpuc_flush_dcache_area((void *)&scu_pen_release,
+				 sizeof(scu_pen_release));
+	outer_clean_range(__pa(&scu_pen_release), __pa(&scu_pen_release + 1));
+
+	/*
+	 * Send the secondary CPU a soft interrupt, thereby causing
+	 * the boot monitor to read the system wide flags register,
+	 * and branch to the address found there.
+	 */
+	smp_cross_call(cpumask_of(cpu), 1);
+
+	timeout = jiffies + (1 * HZ);
+	while (time_before(jiffies, timeout)) {
+		smp_rmb();
+		if (scu_pen_release == -1)
+			break;
+
+		udelay(10);
+	}
+
+	/*
+	 * now the secondary core is starting up let it run its
+	 * calibrations, then wait for it to finish
+	 */
+	spin_unlock(&boot_lock);
+
+	return scu_pen_release != -1 ? -ENOSYS : 0;
+}
+
+/*
+ * Initialise the CPU possible map early - this describes the CPUs
+ * which may be present or become present in the system.
+ */
+void __init scu_init_cpus(void __iomem *scu_base)
+{
+	unsigned int ncores = scu_base ? scu_get_core_count(scu_base) : 1;
+	unsigned int i;
+
+	/* sanity check */
+	if (ncores == 0) {
+		pr_err("%s: strange CM count of 0? Default to 1\n", __func__);
+		ncores = 1;
+	}
+
+	if (ncores > NR_CPUS) {
+		pr_warn("%s: no. of cores (%d) greater than configured "
+		       "maximum of %d - clipping\n", __func__, ncores, NR_CPUS);
+		ncores = NR_CPUS;
+	}
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
+}
+
+void __init scu_prepare_cpus(void __iomem *scu_base, unsigned int max_cpus)
+{
+	unsigned int ncores = num_possible_cpus();
+	unsigned int cpu = smp_processor_id();
+	int i;
+
+	smp_store_cpu_info(cpu);
+
+	/*
+	 * are we trying to boot more cores than exist?
+	 */
+	if (max_cpus > ncores)
+		max_cpus = ncores;
+
+	/*
+	 * Initialise the present map, which describes the set of CPUs
+	 * actually populated at the present time.
+	 */
+	for (i = 0; i < max_cpus; i++)
+		set_cpu_present(i, true);
+
+	/*
+	 * Initialise the SCU if there are more than one CPU and let
+	 * them know where to start.
+	 */
+	if (max_cpus > 1) {
+		/*
+		 * Enable the local timer or broadcast device for the
+		 * boot CPU, but only if we have more than one CPU.
+		 */
+		percpu_timer_setup();
+
+		scu_enable(scu_base);
+	}
+}
diff --git a/arch/arm/kernel/smp_scu_head.S b/arch/arm/kernel/smp_scu_head.S
new file mode 100644
index 0000000..e1ceb25
--- /dev/null
+++ b/arch/arm/kernel/smp_scu_head.S
@@ -0,0 +1,40 @@
+/*
+ *  Copyright (c) 2003 ARM Limited
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+	__INIT
+
+/*
+ * SCU specific entry point for secondary CPUs.  This provides
+ * a "holding pen" into which all secondary cores are held until we're
+ * ready for them to initialise.
+ */
+ENTRY(scu_secondary_startup)
+	mrc	p15, 0, r0, c0, c0, 5
+	and	r0, r0, #15
+	adr	r4, 1f
+	ldmia	r4, {r5, r6}
+	sub	r4, r4, r5
+	add	r6, r6, r4
+#if __LINUX_ARM_ARCH__ >= 7
+	dsb
+#endif
+pen:	ldr	r7, [r6]
+	cmp	r7, r0
+	bne	pen
+
+	/*
+	 * we've been released from the holding pen: secondary_stack
+	 * should now contain the SVC stack for this core
+	 */
+	b	secondary_startup
+
+1:	.long	.
+	.long	scu_pen_release
-- 
1.7.0.5

