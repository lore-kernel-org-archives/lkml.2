Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651Ab2ILQ75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40226 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2ILQ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521468"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 19/24] ARM: msm: Remove non-DT targets from 8960
Date: Wed, 12 Sep 2012 09:58:55 -0700
Message-Id: <1347469140-25069-20-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Remove the non-DT targets supported by 8960. This makes 8960 a
device tree only target.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig           |  13 -----
 arch/arm/mach-msm/Makefile          |   1 -
 arch/arm/mach-msm/board-msm8960.c   | 110 ------------------------------------
 arch/arm/mach-msm/common.h          |   1 -
 arch/arm/mach-msm/devices-msm8960.c |  85 ----------------------------
 arch/arm/mach-msm/timer.c           |  13 -----
 6 files changed, 223 deletions(-)
 delete mode 100644 arch/arm/mach-msm/board-msm8960.c
 delete mode 100644 arch/arm/mach-msm/devices-msm8960.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 2e5a27e..b2740c8 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -50,7 +50,6 @@ config ARCH_MSM8X60
 config ARCH_MSM8960
 	bool "MSM8960"
 	select ARCH_MSM_SCORPIONMP
-	select MACH_MSM8960_SIM if (!MACH_MSM8960_RUMI3)
 	select ARM_GIC
 	select CPU_V7
 	select MSM_V2_TLMM
@@ -112,18 +111,6 @@ config MACH_QSD8X50A_ST1_5
 	help
 	  Support for the Qualcomm ST1.5.
 
-config MACH_MSM8960_SIM
-	depends on ARCH_MSM8960
-	bool "MSM8960 Simulator"
-	help
-	  Support for the Qualcomm MSM8960 simulator.
-
-config MACH_MSM8960_RUMI3
-	depends on ARCH_MSM8960
-	bool "MSM8960 RUMI3"
-	help
-	  Support for the Qualcomm MSM8960 RUMI3 emulator.
-
 endmenu
 
 config MSM_SMD_PKG3
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index cef0ad4..9709766 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
-obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
 obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
deleted file mode 100644
index fafead2..0000000
--- a/arch/arm/mach-msm/board-msm8960.c
+++ /dev/null
@@ -1,110 +0,0 @@
-/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
- */
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/clkdev.h>
-#include <linux/memblock.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/hardware/gic.h>
-#include <asm/setup.h>
-
-#include <mach/board.h>
-#include <mach/msm_iomap.h>
-
-#include "devices.h"
-#include "common.h"
-
-static void __init msm8960_fixup(struct tag *tag, char **cmdline,
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
-static void __init msm8960_reserve(void)
-{
-	memblock_remove(0x40000000, SZ_2M);
-}
-
-static void __init msm8960_map_io(void)
-{
-	msm_map_msm8960_io();
-}
-
-static void __init msm8960_init_irq(void)
-{
-	gic_init(0, GIC_PPI_START, MSM_QGIC_DIST_BASE,
-		 (void *)MSM_QGIC_CPU_BASE);
-
-	if (machine_is_msm8960_rumi3())
-		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
-}
-
-static struct platform_device *sim_devices[] __initdata = {
-	&msm8960_device_uart_gsbi2,
-};
-
-static struct platform_device *rumi3_devices[] __initdata = {
-	&msm8960_device_uart_gsbi5,
-};
-
-static void __init msm8960_sim_init(void)
-{
-	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
-}
-
-static void __init msm8960_rumi3_init(void)
-{
-	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
-}
-
-static void __init msm8960_init_late(void)
-{
-	smd_debugfs_init();
-}
-
-MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
-	.fixup = msm8960_fixup,
-	.reserve = msm8960_reserve,
-	.map_io = msm8960_map_io,
-	.init_irq = msm8960_init_irq,
-	.timer = &msm8960_timer,
-	.handle_irq = gic_handle_irq,
-	.init_machine = msm8960_sim_init,
-	.init_late = msm8960_init_late,
-MACHINE_END
-
-MACHINE_START(MSM8960_RUMI3, "QCT MSM8960 RUMI3")
-	.fixup = msm8960_fixup,
-	.reserve = msm8960_reserve,
-	.map_io = msm8960_map_io,
-	.init_irq = msm8960_init_irq,
-	.timer = &msm8960_timer,
-	.handle_irq = gic_handle_irq,
-	.init_machine = msm8960_rumi3_init,
-	.init_late = msm8960_init_late,
-MACHINE_END
-
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index 9975575..d68e5d7 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -14,7 +14,6 @@
 
 extern struct sys_timer msm7x01_timer;
 extern struct sys_timer msm7x30_timer;
-extern struct sys_timer msm8960_timer;
 extern struct sys_timer msm_dt_timer;
 extern struct sys_timer qsd8x50_timer;
 
diff --git a/arch/arm/mach-msm/devices-msm8960.c b/arch/arm/mach-msm/devices-msm8960.c
deleted file mode 100644
index d9e1f26..0000000
--- a/arch/arm/mach-msm/devices-msm8960.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-
-#include <linux/dma-mapping.h>
-#include <mach/irqs-8960.h>
-#include <mach/board.h>
-
-#include "devices.h"
-
-#define MSM_GSBI2_PHYS		0x16100000
-#define MSM_UART2DM_PHYS	(MSM_GSBI2_PHYS + 0x40000)
-
-#define MSM_GSBI5_PHYS		0x16400000
-#define MSM_UART5DM_PHYS	(MSM_GSBI5_PHYS + 0x40000)
-
-static struct resource resources_uart_gsbi2[] = {
-	{
-		.start	= GSBI2_UARTDM_IRQ,
-		.end	= GSBI2_UARTDM_IRQ,
-		.flags	= IORESOURCE_IRQ,
-	},
-	{
-		.start	= MSM_UART2DM_PHYS,
-		.end	= MSM_UART2DM_PHYS + PAGE_SIZE - 1,
-		.name	= "uart_resource",
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.start	= MSM_GSBI2_PHYS,
-		.end	= MSM_GSBI2_PHYS + PAGE_SIZE - 1,
-		.name	= "gsbi_resource",
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-struct platform_device msm8960_device_uart_gsbi2 = {
-	.name	= "msm_serial",
-	.id	= 0,
-	.num_resources	= ARRAY_SIZE(resources_uart_gsbi2),
-	.resource	= resources_uart_gsbi2,
-};
-
-static struct resource resources_uart_gsbi5[] = {
-	{
-		.start	= GSBI5_UARTDM_IRQ,
-		.end	= GSBI5_UARTDM_IRQ,
-		.flags	= IORESOURCE_IRQ,
-	},
-	{
-		.start	= MSM_UART5DM_PHYS,
-		.end	= MSM_UART5DM_PHYS + PAGE_SIZE - 1,
-		.name	= "uart_resource",
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.start	= MSM_GSBI5_PHYS,
-		.end	= MSM_GSBI5_PHYS + PAGE_SIZE - 1,
-		.name	= "gsbi_resource",
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-struct platform_device msm8960_device_uart_gsbi5 = {
-	.name	= "msm_serial",
-	.id	= 0,
-	.num_resources	= ARRAY_SIZE(resources_uart_gsbi5),
-	.resource	= resources_uart_gsbi5,
-};
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index ac1276c..476549a 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -37,7 +37,6 @@
 #define TIMER_ENABLE_CLR_ON_MATCH_EN    BIT(1)
 #define TIMER_ENABLE_EN                 BIT(0)
 #define TIMER_CLEAR             0x000C
-#define DGT_CLK_CTL             0x0030
 #define DGT_CLK_CTL_DIV_4	0x3
 
 #define GPT_HZ 32768
@@ -346,18 +345,6 @@ struct sys_timer msm7x30_timer = {
 	.init = msm7x30_timer_init
 };
 
-static void __init msm8960_timer_init(void)
-{
-	if (msm_timer_map(0x0200A004, 0x0208A024))
-		return;
-	writel_relaxed(DGT_CLK_CTL_DIV_4, event_base + DGT_CLK_CTL);
-	msm_timer_init(27000000 / 4, 32, 17, true);
-}
-
-struct sys_timer msm8960_timer = {
-	.init = msm8960_timer_init
-};
-
 static void __init qsd8x50_timer_init(void)
 {
 	if (msm_timer_map(0xAC100000, 0xAC100010))
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

