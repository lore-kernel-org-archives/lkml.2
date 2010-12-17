Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0LQI3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:29:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37242 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0LQI3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:29:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67207086"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v6 5/5] msm: add SMP support for msm
Date: Fri, 17 Dec 2010 00:28:48 -0800
Message-Id: <1292574528-13310-6-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292574528-13310-1-git-send-email-johlstei@codeaurora.org>
References: <1292574528-13310-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig   |    1 +
 arch/arm/mach-msm/Makefile  |    1 +
 arch/arm/mach-msm/headsmp.S |   40 ++++++++++
 arch/arm/mach-msm/platsmp.c |  166 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/headsmp.S
 create mode 100644 arch/arm/mach-msm/platsmp.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index ab5338f..8c57425 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -40,6 +40,7 @@ config ARCH_MSM8X60
 	bool "MSM8X60"
 	select MACH_MSM8X60_SURF if (!MACH_MSM8X60_RUMI3 && !MACH_MSM8X60_SIM \
 				  && !MACH_MSM8X60_FFA)
+	select ARCH_MSM_SCORPIONMP
 	select ARM_GIC
 	select CPU_V7
 	select MSM_V2_TLMM
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 7a11b4a..1945f9c 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_MSM_SMD) += last_radio_log.o
 obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
 
 obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
+obj-$(CONFIG_SMP) += headsmp.o platsmp.o
 
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
diff --git a/arch/arm/mach-msm/headsmp.S b/arch/arm/mach-msm/headsmp.S
new file mode 100644
index 0000000..d0c2143
--- /dev/null
+++ b/arch/arm/mach-msm/headsmp.S
@@ -0,0 +1,40 @@
+/*
+ *  linux/arch/arm/mach-realview/headsmp.S
+ *
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
+ * MSM specific entry point for secondary CPUs.  This provides
+ * a "holding pen" into which all secondary cores are held until we're
+ * ready for them to initialise.
+ */
+ENTRY(msm_secondary_startup)
+	mrc	p15, 0, r0, c0, c0, 5
+	and	r0, r0, #15
+	adr	r4, 1f
+	ldmia	r4, {r5, r6}
+	sub	r4, r4, r5
+	add	r6, r6, r4
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
+	.align
+1:	.long	.
+	.long	pen_release
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
new file mode 100644
index 0000000..0f427bc
--- /dev/null
+++ b/arch/arm/mach-msm/platsmp.c
@@ -0,0 +1,166 @@
+/*
+ *  Copyright (C) 2002 ARM Ltd.
+ *  All Rights Reserved
+ *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+
+#include <asm/hardware/gic.h>
+#include <asm/cacheflush.h>
+#include <asm/mach-types.h>
+
+#include <mach/msm_iomap.h>
+
+#include "scm-boot.h"
+
+#define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
+#define SCSS_CPU1CORE_RESET 0xD80
+#define SCSS_DBG_STATUS_CORE_PWRDUP 0xE64
+
+/* Mask for edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
+#define GIC_PPI_EDGE_MASK 0xFFFFD7FF
+
+extern void msm_secondary_startup(void);
+/*
+ * control for which core is the next to come out of the secondary
+ * boot "holding pen".
+ */
+volatile int pen_release = -1;
+
+static DEFINE_SPINLOCK(boot_lock);
+
+void __cpuinit platform_secondary_init(unsigned int cpu)
+{
+	/* Configure edge-triggered PPIs */
+	writel(GIC_PPI_EDGE_MASK, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
+
+	/*
+	 * if any interrupts are already enabled for the primary
+	 * core (e.g. timer irq), then they will not have been enabled
+	 * for us: do so
+	 */
+	gic_secondary_init(0);
+
+	/*
+	 * let the primary processor know we're out of the
+	 * pen, then head off into the C entry point
+	 */
+	pen_release = -1;
+	smp_wmb();
+
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+static __cpuinit void prepare_cold_cpu(unsigned int cpu)
+{
+	int ret;
+	ret = scm_set_boot_addr(virt_to_phys(msm_secondary_startup),
+				SCM_FLAG_COLDBOOT_CPU1);
+	if (ret == 0) {
+		void *sc1_base_ptr;
+		sc1_base_ptr = ioremap_nocache(0x00902000, SZ_4K*2);
+		if (sc1_base_ptr) {
+			writel(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
+			writel(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
+			writel(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
+			iounmap(sc1_base_ptr);
+		}
+	} else
+		printk(KERN_DEBUG "Failed to set secondary core boot "
+				  "address\n");
+}
+
+int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long timeout;
+	static int cold_boot_done;
+
+	/* Only need to bring cpu out of reset this way once */
+	if (cold_boot_done == false) {
+		prepare_cold_cpu(cpu);
+		cold_boot_done = true;
+	}
+
+	/*
+	 * set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+	spin_lock(&boot_lock);
+
+	/*
+	 * The secondary processor is waiting to be released from
+	 * the holding pen - release it, then wait for it to flag
+	 * that it has been released by resetting pen_release.
+	 *
+	 * Note that "pen_release" is the hardware CPU ID, whereas
+	 * "cpu" is Linux's internal ID.
+	 */
+	pen_release = cpu;
+	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
+	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
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
+		if (pen_release == -1)
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
+	return pen_release != -1 ? -ENOSYS : 0;
+}
+
+/*
+ * Initialise the CPU possible map early - this describes the CPUs
+ * which may be present or become present in the system. The msm8x60
+ * does not support the ARM SCU, so just set the possible cpu mask to
+ * NR_CPUS.
+ */
+void __init smp_init_cpus(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_CPUS; i++)
+		set_cpu_possible(i, true);
+}
+
+void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+{
+	int i;
+
+	/*
+	 * Initialise the present map, which describes the set of CPUs
+	 * actually populated at the present time.
+	 */
+	for (i = 0; i < max_cpus; i++)
+		set_cpu_present(i, true);
+}
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

