Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab2ILQ7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40226 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab2ILQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521457"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 15/24] ARM: msm: Make 8660 a DT only target
Date: Wed, 12 Sep 2012 09:58:51 -0700
Message-Id: <1347469140-25069-16-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

We don't plan to support anything besides devicetree on these
targets so remove all other machine support.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |  27 +---------
 arch/arm/mach-msm/board-msm8x60.c | 106 ++------------------------------------
 arch/arm/mach-msm/common.h        |   1 -
 arch/arm/mach-msm/timer.c         |  12 -----
 4 files changed, 6 insertions(+), 140 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 1cd40ad..cd78427 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -38,8 +38,6 @@ config ARCH_QSD8X50
 
 config ARCH_MSM8X60
 	bool "MSM8X60"
-	select MACH_MSM8X60_SURF if (!MACH_MSM8X60_RUMI3 && !MACH_MSM8X60_SIM \
-				  && !MACH_MSM8X60_FFA)
 	select ARCH_MSM_SCORPIONMP
 	select ARM_GIC
 	select CPU_V7
@@ -47,6 +45,7 @@ config ARCH_MSM8X60
 	select GPIO_MSM_V2
 	select MSM_GPIOMUX
 	select MSM_SCM if SMP
+	select USE_OF
 
 config ARCH_MSM8960
 	bool "MSM8960"
@@ -112,30 +111,6 @@ config MACH_QSD8X50A_ST1_5
 	help
 	  Support for the Qualcomm ST1.5.
 
-config MACH_MSM8X60_RUMI3
-	depends on ARCH_MSM8X60
-	bool "MSM8x60 RUMI3"
-	help
-	  Support for the Qualcomm MSM8x60 RUMI3 emulator.
-
-config MACH_MSM8X60_SURF
-	depends on ARCH_MSM8X60
-	bool "MSM8x60 SURF"
-	help
-	  Support for the Qualcomm MSM8x60 SURF eval board.
-
-config MACH_MSM8X60_SIM
-	depends on ARCH_MSM8X60
-	bool "MSM8x60 Simulator"
-	help
-	  Support for the Qualcomm MSM8x60 simulator.
-
-config MACH_MSM8X60_FFA
-	depends on ARCH_MSM8X60
-	bool "MSM8x60 FFA"
-	help
-	  Support for the Qualcomm MSM8x60 FFA eval board.
-
 config MACH_MSM8960_SIM
 	depends on ARCH_MSM8960
 	bool "MSM8960 Simulator"
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 64c981d..0d32464 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, 2011, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -10,73 +10,26 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
+#include <linux/init.h>
 #include <linux/of.h>
-#include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
-#include <linux/memblock.h>
 
-#include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
-#include <asm/setup.h>
 
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
 #include "common.h"
 
-static void __init msm8x60_fixup(struct tag *tag, char **cmdline,
-		struct meminfo *mi)
-{
-	for (; tag->hdr.size; tag = tag_next(tag))
-		if (tag->hdr.tag == ATAG_MEM &&
-				tag->u.mem.start == 0x40200000) {
-			tag->u.mem.start = 0x40000000;
-			tag->u.mem.size += SZ_2M;
-		}
-}
-
-static void __init msm8x60_reserve(void)
-{
-	memblock_remove(0x40000000, SZ_2M);
-}
-
-static void __init msm8x60_map_io(void)
-{
-	msm_map_msm8x60_io();
-}
-
-#ifdef CONFIG_OF
-static struct of_device_id msm_dt_gic_match[] __initdata = {
+static const struct of_device_id msm_dt_gic_match[] __initconst = {
 	{ .compatible = "qcom,msm-8660-qgic", .data = gic_of_init },
 	{}
 };
-#endif
 
 static void __init msm8x60_init_irq(void)
 {
-	if (!of_have_populated_dt())
-		gic_init(0, GIC_PPI_START, MSM_QGIC_DIST_BASE,
-			 (void *)MSM_QGIC_CPU_BASE);
-#ifdef CONFIG_OF
-	else
-		of_irq_init(msm_dt_gic_match);
-#endif
-
-	/* RUMI does not adhere to GIC spec by enabling STIs by default.
-	 * Enable/clear is supposed to be RO for STIs, but is RW on RUMI.
-	 */
-	if (!machine_is_msm8x60_sim())
-		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
-}
-
-static void __init msm8x60_init(void)
-{
+	of_irq_init(msm_dt_gic_match);
 }
 
 static void __init msm8x60_init_late(void)
@@ -84,7 +37,6 @@ static void __init msm8x60_init_late(void)
 	smd_debugfs_init();
 }
 
-#ifdef CONFIG_OF
 static struct of_dev_auxdata msm_auxdata_lookup[] __initdata = {
 	{}
 };
@@ -100,56 +52,9 @@ static const char *msm8x60_fluid_match[] __initdata = {
 	"qcom,msm8660-surf",
 	NULL
 };
-#endif /* CONFIG_OF */
-
-MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
-	.fixup = msm8x60_fixup,
-	.reserve = msm8x60_reserve,
-	.map_io = msm8x60_map_io,
-	.init_irq = msm8x60_init_irq,
-	.handle_irq = gic_handle_irq,
-	.init_machine = msm8x60_init,
-	.init_late = msm8x60_init_late,
-	.timer = &msm8x60_timer,
-MACHINE_END
-
-MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
-	.fixup = msm8x60_fixup,
-	.reserve = msm8x60_reserve,
-	.map_io = msm8x60_map_io,
-	.init_irq = msm8x60_init_irq,
-	.handle_irq = gic_handle_irq,
-	.init_machine = msm8x60_init,
-	.init_late = msm8x60_init_late,
-	.timer = &msm8x60_timer,
-MACHINE_END
-
-MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
-	.fixup = msm8x60_fixup,
-	.reserve = msm8x60_reserve,
-	.map_io = msm8x60_map_io,
-	.init_irq = msm8x60_init_irq,
-	.handle_irq = gic_handle_irq,
-	.init_machine = msm8x60_init,
-	.init_late = msm8x60_init_late,
-	.timer = &msm8x60_timer,
-MACHINE_END
-
-MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
-	.fixup = msm8x60_fixup,
-	.reserve = msm8x60_reserve,
-	.map_io = msm8x60_map_io,
-	.init_irq = msm8x60_init_irq,
-	.handle_irq = gic_handle_irq,
-	.init_machine = msm8x60_init,
-	.init_late = msm8x60_init_late,
-	.timer = &msm8x60_timer,
-MACHINE_END
 
-#ifdef CONFIG_OF
-/* TODO: General device tree support for all MSM. */
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
-	.map_io = msm8x60_map_io,
+	.map_io = msm_map_msm8x60_io,
 	.init_irq = msm8x60_init_irq,
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8x60_dt_init,
@@ -157,4 +62,3 @@ DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.timer = &msm_dt_timer,
 	.dt_compat = msm8x60_fluid_match,
 MACHINE_END
-#endif /* CONFIG_OF */
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index 7d57fb0..a20e78e 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -14,7 +14,6 @@
 
 extern struct sys_timer msm7x01_timer;
 extern struct sys_timer msm7x30_timer;
-extern struct sys_timer msm8x60_timer;
 extern struct sys_timer msm8960_timer;
 extern struct sys_timer msm_dt_timer;
 extern struct sys_timer qsd8x50_timer;
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 9f9157a..ac1276c 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -346,18 +346,6 @@ struct sys_timer msm7x30_timer = {
 	.init = msm7x30_timer_init
 };
 
-static void __init msm8x60_timer_init(void)
-{
-	if (msm_timer_map(0x02000004, 0x02040024))
-		return;
-	writel_relaxed(DGT_CLK_CTL_DIV_4, event_base + DGT_CLK_CTL);
-	msm_timer_init(27000000 / 4, 32, 17, true);
-}
-
-struct sys_timer msm8x60_timer = {
-	.init = msm8x60_timer_init
-};
-
 static void __init msm8960_timer_init(void)
 {
 	if (msm_timer_map(0x0200A004, 0x0208A024))
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

