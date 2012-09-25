Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab2IYPKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:10:25 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41285 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2IYPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:10:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Fix initialisation order for UIBs
Date: Tue, 25 Sep 2012 16:10:12 +0100
Message-Id: <1348585812-32073-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An earlier change prevented User Interface Boards (UIBs) from being
initialised on boards which did not support them. This change had
the undesired effect of reordering the UIB initialisation calls with
I2C registration. Here we ensure UIBs are only setup after all
required infrastructure is already in place.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |   10 +---------
 arch/arm/mach-ux500/cpu.c          |    2 ++
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 5eb5ea1..4eedf1c 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -639,8 +639,6 @@ static void __init mop500_init_machine(void)
 
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
-
-	mop500_uib_init();
 }
 
 static void __init snowball_init_machine(void)
@@ -705,8 +703,6 @@ static void __init hrefv60_init_machine(void)
 
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
-
-	mop500_uib_init();
 }
 
 MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
@@ -739,7 +735,7 @@ MACHINE_START(SNOWBALL, "Calao Systems Snowball platform")
 	.timer		= &ux500_timer,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= snowball_init_machine,
-	.init_late	= ux500_init_late,
+	.init_late	= NULL,
 MACHINE_END
 
 #ifdef CONFIG_MACH_UX500_DT
@@ -829,8 +825,6 @@ static void __init u8500_init_machine(void)
 		i2c_register_board_info(2, mop500_i2c2_devices,
 					ARRAY_SIZE(mop500_i2c2_devices));
 
-		mop500_uib_init();
-
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		/*
 		 * The HREFv60 board removed a GPIO expander and routed
@@ -840,8 +834,6 @@ static void __init u8500_init_machine(void)
 		mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
 		platform_add_devices(mop500_platform_devs,
 				ARRAY_SIZE(mop500_platform_devs));
-
-		mop500_uib_init();
 	}
 
 	/* This board has full regulator constraints */
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index e2360e7..ab2ca7d 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -26,6 +26,7 @@
 #include <mach/devices.h>
 
 #include "clock.h"
+#include "board-mop500.h"
 
 void __iomem *_PRCMU_BASE;
 
@@ -77,6 +78,7 @@ void __init ux500_init_late(void)
 {
 	clk_debugfs_init();
 	clk_init_smp_twd_cpufreq();
+	mop500_uib_init();
 }
 
 static const char * __init ux500_get_machine(void)
-- 
1.7.9.5

