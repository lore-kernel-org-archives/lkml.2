Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736Ab2ILRCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:02:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40251 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab2ILQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521476"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 22/24] ARM: msm: Remove uncompiled board-msm7x27
Date: Wed, 12 Sep 2012 09:58:58 -0700
Message-Id: <1347469140-25069-23-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

This board file has never been compiled. Let's just remove it
along with the one Kconfig reference to it in io.c.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-msm7x27.c | 170 --------------------------------------
 arch/arm/mach-msm/io.c            |   3 +-
 2 files changed, 1 insertion(+), 172 deletions(-)
 delete mode 100644 arch/arm/mach-msm/board-msm7x27.c

diff --git a/arch/arm/mach-msm/board-msm7x27.c b/arch/arm/mach-msm/board-msm7x27.c
deleted file mode 100644
index 451ab1d..0000000
--- a/arch/arm/mach-msm/board-msm7x27.c
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2009, Code Aurora Forum. All rights reserved.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-#include <linux/gpio.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/input.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/power_supply.h>
-
-#include <mach/hardware.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/flash.h>
-#include <asm/setup.h>
-#ifdef CONFIG_CACHE_L2X0
-#include <asm/hardware/cache-l2x0.h>
-#endif
-
-#include <mach/vreg.h>
-#include <mach/mpp.h>
-#include <mach/board.h>
-#include <mach/msm_iomap.h>
-
-#include <linux/mtd/nand.h>
-#include <linux/mtd/partitions.h>
-
-#include "devices.h"
-#include "socinfo.h"
-#include "clock.h"
-
-static struct resource smc91x_resources[] = {
-	[0] = {
-		.start	= 0x9C004300,
-		.end	= 0x9C0043ff,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= MSM_GPIO_TO_INT(132),
-		.end	= MSM_GPIO_TO_INT(132),
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device smc91x_device = {
-	.name		= "smc91x",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(smc91x_resources),
-	.resource	= smc91x_resources,
-};
-
-static struct platform_device *devices[] __initdata = {
-	&msm_device_uart3,
-	&msm_device_smd,
-	&msm_device_dmov,
-	&msm_device_nand,
-	&smc91x_device,
-};
-
-extern struct sys_timer msm_timer;
-
-static void __init msm7x2x_init_irq(void)
-{
-	msm_init_irq();
-}
-
-static void __init msm7x2x_init(void)
-{
-	if (socinfo_init() < 0)
-		BUG();
-
-	if (machine_is_msm7x25_ffa() || machine_is_msm7x27_ffa()) {
-		smc91x_resources[0].start = 0x98000300;
-		smc91x_resources[0].end = 0x980003ff;
-		smc91x_resources[1].start = MSM_GPIO_TO_INT(85);
-		smc91x_resources[1].end = MSM_GPIO_TO_INT(85);
-		if (gpio_tlmm_config(GPIO_CFG(85, 0,
-					      GPIO_INPUT,
-					      GPIO_PULL_DOWN,
-					      GPIO_2MA),
-				     GPIO_ENABLE)) {
-			printk(KERN_ERR
-			       "%s: Err: Config GPIO-85 INT\n",
-				__func__);
-		}
-	}
-
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-}
-
-static void __init msm7x2x_map_io(void)
-{
-	msm_map_common_io();
-	/* Technically dependent on the SoC but using machine_is
-	 * macros since socinfo is not available this early and there
-	 * are plans to restructure the code which will eliminate the
-	 * need for socinfo.
-	 */
-	if (machine_is_msm7x27_surf() || machine_is_msm7x27_ffa())
-		msm_clock_init(msm_clocks_7x27, msm_num_clocks_7x27);
-
-	if (machine_is_msm7x25_surf() || machine_is_msm7x25_ffa())
-		msm_clock_init(msm_clocks_7x25, msm_num_clocks_7x25);
-
-#ifdef CONFIG_CACHE_L2X0
-	if (machine_is_msm7x27_surf() || machine_is_msm7x27_ffa()) {
-		/* 7x27 has 256KB L2 cache:
-			64Kb/Way and 4-Way Associativity;
-			R/W latency: 3 cycles;
-			evmon/parity/share disabled. */
-		l2x0_init(MSM_L2CC_BASE, 0x00068012, 0xfe000000);
-	}
-#endif
-}
-
-static void __init msm7x2x_init_late(void)
-{
-	smd_debugfs_init();
-}
-
-MACHINE_START(MSM7X27_SURF, "QCT MSM7x27 SURF")
-	.atag_offset	= 0x100,
-	.map_io		= msm7x2x_map_io,
-	.init_irq	= msm7x2x_init_irq,
-	.init_machine	= msm7x2x_init,
-	.init_late	= msm7x2x_init_late,
-	.timer		= &msm_timer,
-MACHINE_END
-
-MACHINE_START(MSM7X27_FFA, "QCT MSM7x27 FFA")
-	.atag_offset	= 0x100,
-	.map_io		= msm7x2x_map_io,
-	.init_irq	= msm7x2x_init_irq,
-	.init_machine	= msm7x2x_init,
-	.init_late	= msm7x2x_init_late,
-	.timer		= &msm_timer,
-MACHINE_END
-
-MACHINE_START(MSM7X25_SURF, "QCT MSM7x25 SURF")
-	.atag_offset	= 0x100,
-	.map_io		= msm7x2x_map_io,
-	.init_irq	= msm7x2x_init_irq,
-	.init_machine	= msm7x2x_init,
-	.init_late	= msm7x2x_init_late,
-	.timer		= &msm_timer,
-MACHINE_END
-
-MACHINE_START(MSM7X25_FFA, "QCT MSM7x25 FFA")
-	.atag_offset	= 0x100,
-	.map_io		= msm7x2x_map_io,
-	.init_irq	= msm7x2x_init_irq,
-	.init_machine	= msm7x2x_init,
-	.init_late	= msm7x2x_init_late,
-	.timer		= &msm_timer,
-MACHINE_END
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index d908a37..3854f6f 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -44,8 +44,7 @@
 		MSM_CHIP_DEVICE_TYPE(name, chip, MT_DEVICE)
 #define MSM_DEVICE(name) MSM_CHIP_DEVICE(name, MSM)
 
-#if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27) \
-	|| defined(CONFIG_ARCH_MSM7X25)
+#if defined(CONFIG_ARCH_MSM7X00A)
 static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE_TYPE(VIC, MT_DEVICE_NONSHARED),
 	MSM_CHIP_DEVICE_TYPE(CSR, MSM7X00, MT_DEVICE_NONSHARED),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

