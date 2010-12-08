Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0LHE2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:28:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53039 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0LHE2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:28:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6190"; a="65899452"
X-IronPort-AV: E=Sophos;i="4.59,313,1288594800"; 
   d="scan'208";a="34584833"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: [PATCH v2 6/6] msm: add SMP support for msm
Date: Tue,  7 Dec 2010 20:28:21 -0800
Message-Id: <1291782501-3909-7-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org>
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig            |    1 +
 arch/arm/mach-msm/Makefile           |    1 +
 arch/arm/mach-msm/headsmp.S          |   43 ++++++++++
 arch/arm/mach-msm/include/mach/smp.h |    2 +
 arch/arm/mach-msm/platsmp.c          |  146 ++++++++++++++++++++++++++++++++++
 5 files changed, 193 insertions(+), 0 deletions(-)
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
index 0000000..438cfeb
--- /dev/null
+++ b/arch/arm/mach-msm/headsmp.S
@@ -0,0 +1,43 @@
+/*
+ *  Copyright (c) 2003 ARM Limited
+ *  All Rights Reserved
+ *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+/*
+ * MSM specific entry point for secondary CPUs.  This provides
+ * a "holding pen" into which all secondary cores are held until we're
+ * ready for them to initialise.
+ *
+ * This is executing in physical space with cache's off.
+ */
+ENTRY(msm_secondary_startup)
+	mrc	p15, 0, r0, c0, c0, 5 	@ MPIDR
+	and	r0, r0, #15		@ What CPU am I
+	adr	r4, 1f			@ address of
+	ldmia	r4, {r5, r6}		@ load curr addr and pen_rel addr
+	sub	r4, r4, r5		@ determine virtual/phys offsets
+	add	r6, r6, r4		@ apply
+pen:
+	wfe
+	dsb				@ ensure subsequent access is
+					@ after event
+
+	ldr	r7, [r6]		@ pen_rel has cpu to remove from reset
+	cmp	r7, r0			@ are we lucky?
+	bne	pen
+
+	/*
+	 * we've been released from the holding pen: secondary_stack
+	 * should now contain the SVC stack for this core
+	 */
+	b	secondary_startup
+
+1:	.long	.
+	.long	pen_release
diff --git a/arch/arm/mach-msm/include/mach/smp.h b/arch/arm/mach-msm/include/mach/smp.h
index 3ff7bf5..79f94b0 100644
--- a/arch/arm/mach-msm/include/mach/smp.h
+++ b/arch/arm/mach-msm/include/mach/smp.h
@@ -36,4 +36,6 @@ static inline void smp_cross_call(const struct cpumask *mask)
 	gic_raise_softirq(mask, 1);
 }
 
+extern int pen_release;
+extern void msm_secondary_startup(void);
 #endif
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
new file mode 100644
index 0000000..0ab2bba
--- /dev/null
+++ b/arch/arm/mach-msm/platsmp.c
@@ -0,0 +1,146 @@
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
+#include <linux/cpumask.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+#include <asm/hardware/gic.h>
+#include <asm/cacheflush.h>
+#include <asm/mach-types.h>
+
+#include <mach/smp.h>
+#include <mach/msm_iomap.h>
+
+#include "scm-boot.h"
+
+#define SECONDARY_CPU_WAIT_MS 10
+
+#define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
+#define SCSS_CPU1CORE_RESET 0xD80
+#define SCSS_DBG_STATUS_CORE_PWRDUP 0xE64
+
+int pen_release = -1;
+
+int get_core_count(void)
+{
+#ifdef CONFIG_NR_CPUS
+	return CONFIG_NR_CPUS;
+#else
+	return 1;
+#endif
+}
+
+/* Initialize the present map (set_cpu_present(i, true)). */
+void smp_prepare_cpus(unsigned int max_cpus)
+{
+	int i;
+	unsigned int cpu = smp_processor_id();
+
+	smp_store_cpu_info(cpu);
+
+	for (i = 0; i < max_cpus; i++)
+		set_cpu_present(i, true);
+}
+
+void smp_init_cpus(void)
+{
+	unsigned int i, ncores = get_core_count();
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
+}
+
+static void prepare_cold_cpu(unsigned int cpu)
+{
+	int ret;
+	ret = scm_set_boot_addr((void *)
+				virt_to_phys(msm_secondary_startup),
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
+/* Executed by primary CPU, brings other CPUs out of reset. Called at boot
+   as well as when a CPU is coming out of shutdown induced by echo 0 >
+   /sys/devices/.../cpuX.
+*/
+int boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	static int cold_boot_done;
+	int cnt = 0;
+	printk(KERN_DEBUG "Starting secondary CPU %d\n", cpu);
+
+	if (cold_boot_done == false) {
+		prepare_cold_cpu(cpu);
+		cold_boot_done = true;
+	}
+
+	pen_release = cpu;
+	dmac_flush_range((void *)&pen_release,
+			 (void *)(&pen_release + sizeof(pen_release)));
+	__asm__("sev");
+	dsb();
+
+	/* Use smp_cross_call() to send a soft interrupt to wake up
+	 * the other core.
+	 */
+	smp_cross_call(cpumask_of(cpu));
+
+	while (pen_release != 0xFFFFFFFF) {
+		smp_rmb();
+		msleep_interruptible(1);
+		if (cnt++ >= SECONDARY_CPU_WAIT_MS)
+			break;
+	}
+
+	return 0;
+}
+
+/* Mask for edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
+#define GIC_PPI_EDGE_MASK 0xFFFFD7FF
+
+/* Initialization routine for secondary CPUs after they are brought out of
+ * reset.
+*/
+void platform_secondary_init(unsigned int cpu)
+{
+	printk(KERN_DEBUG "%s: cpu:%d\n", __func__, cpu);
+
+	trace_hardirqs_off();
+
+	writel(GIC_PPI_EDGE_MASK, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
+
+	/* RUMI does not adhere to GIC spec by enabling STIs by default.
+	 * Enable/clear is supposed to be RO for STIs, but is RW on RUMI.
+	 */
+	if (!machine_is_msm8x60_sim())
+		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
+
+	/*
+	 * setup GIC (GIC number NOT CPU number and the base address of the
+	 * GIC CPU interface
+	 */
+	gic_cpu_init(0, MSM_QGIC_CPU_BASE);
+	pen_release = -1;
+	smp_wmb();
+}
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

