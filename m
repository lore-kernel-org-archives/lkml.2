Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0HKQqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:46:47 -0400
Received: from mail.logicpd.com ([66.162.60.3]:43783 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752478Ab0HKQqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:46:24 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 12:46:22 EDT
From: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
To: linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk@arm.linux.org.uk, tony@atomide.com,
        Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Subject: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and TORPEDO development kits
Date: Wed, 11 Aug 2010 12:31:34 -0400
Message-Id: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 11 Aug 2010 16:32:11.0074 (UTC) FILETIME=[BF6B8220:01CB3972]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Adding LogicPD OMAP3 board support

         Adding support for LogicPD's OMAP 3530 LV SOM and
         OMAP 35x Torpedo board.
	 
	 Tested against: linux-next 81e09f50c93edff607259cbe374a3006c9c5fa74
         Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
---
 arch/arm/configs/omap3_defconfig       |    2 +
 arch/arm/mach-omap2/Kconfig            |    8 ++
 arch/arm/mach-omap2/Makefile           |    4 +
 arch/arm/mach-omap2/board-omap3logic.c |  184 ++++++++++++++++++++++++++++++++
 4 files changed, 198 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3logic.c

diff --git a/arch/arm/configs/omap3_defconfig b/arch/arm/configs/omap3_defconfig
index 5db9a6b..f510dfd 100644
--- a/arch/arm/configs/omap3_defconfig
+++ b/arch/arm/configs/omap3_defconfig
@@ -37,6 +37,8 @@ CONFIG_MACH_OMAP_2430SDP=y
 CONFIG_MACH_OMAP3_BEAGLE=y
 CONFIG_MACH_DEVKIT8000=y
 CONFIG_MACH_OMAP_LDP=y
+CONFIG_MACH_OMAP3530_LV_SOM=y
+CONFIG_MACH_OMAP3_TORPEDO=y
 CONFIG_MACH_OVERO=y
 CONFIG_MACH_OMAP3EVM=y
 CONFIG_MACH_OMAP3517EVM=y
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index b48bacf..42e7d4a 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -135,6 +135,14 @@ config MACH_OMAP_LDP
 	default y
 	select OMAP_PACKAGE_CBB
 
+config MACH_OMAP3530_LV_SOM
+	bool "OMAP3 Logic 3530 LV SOM board"
+	depends on ARCH_OMAP3
+
+config MACH_OMAP3_TORPEDO
+	bool "OMAP3 Logic 35x Torpedo board"
+	depends on ARCH_OMAP3
+
 config MACH_OVERO
 	bool "Gumstix Overo board"
 	depends on ARCH_OMAP3
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 63b2d88..bc77d32 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -114,6 +114,10 @@ obj-$(CONFIG_MACH_DEVKIT8000)     	+= board-devkit8000.o \
 obj-$(CONFIG_MACH_OMAP_LDP)		+= board-ldp.o \
 					   board-flash.o \
 					   hsmmc.o
+obj-$(CONFIG_MACH_OMAP3530_LV_SOM)      += board-omap3logic.o \
+					   hsmmc.o
+obj-$(CONFIG_MACH_OMAP3_TORPEDO)        += board-omap3logic.o \
+					   hsmmc.o
 obj-$(CONFIG_MACH_OVERO)		+= board-overo.o \
 					   hsmmc.o
 obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o \
diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
new file mode 100644
index 0000000..b449f9e
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -0,0 +1,184 @@
+/*
+ * linux/arch/arm/mach-omap2/board-omap3logic.c
+ *
+ * Copyright (C) 2010 Li-Pro.Net
+ * Stephan Linz <linz@li-pro.net>
+ *
+ * Copyright (C) 2010 Logic Product Development, Inc.
+ * Peter Barada <peter.barada@logicpd.com>
+ *
+ * Modified from Beagle, EVM, and RX51
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#include <linux/regulator/machine.h>
+
+#include <linux/i2c/twl.h>
+
+#include <mach/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include "mux.h"
+
+#include <plat/mux.h>
+#include <plat/board.h>
+#include <plat/common.h>
+#include <plat/gpmc.h>
+#include <plat/timer-gp.h>
+#include <plat/sdrc.h>
+
+/* Micron MT46H32M32LF-6 */
+/* FIXME: borrowed from sdram-micron-mt46h32m32lf-6.h because on LogicPD
+ * boards we can't use the default values -- why? I suspect the reason
+ * lies in the boot strap code. We correct this part if we have ported
+ * U-Boot and X-Load. */
+
+static struct omap_sdrc_params mt46h32m32lf6_sdrc_params[] = {
+	[0] = {
+		.rate	     = 166000000,
+		.actim_ctrla = 0xaa9db4c6,
+		.actim_ctrlb = 0x00011517,
+		.rfr_ctrl    = 0x0004e201,
+		.mr	     = 0x00000032,
+	},
+	[1] = {
+		.rate	     = 165941176,
+		.actim_ctrla = 0xaa9db4c6,
+		.actim_ctrlb = 0x00011517,
+		.rfr_ctrl    = 0x0004e201,
+		.mr	     = 0x00000032,
+	},
+	[2] = {
+		.rate	     = 83000000,
+		.actim_ctrla = 0x8a99b481,
+		.actim_ctrlb = 0x00011312,
+		.rfr_ctrl    = 0x0003de01,
+		.mr	     = 0x00000032,
+	},
+	[3] = {
+		.rate	     = 82970588,
+		.actim_ctrla = 0x8a99b481,
+		.actim_ctrlb = 0x00011312,
+		.rfr_ctrl    = 0x0003de01,
+		.mr	     = 0x00000032,
+	},
+	[4] = {
+		.rate	     = 0
+	},
+};
+
+static int omap3logic_twl_gpio_setup(struct device *dev,
+				unsigned gpio, unsigned ngpio)
+{
+	return 0;
+}
+
+static struct twl4030_gpio_platform_data omap3logic_gpio_data = {
+	.gpio_base	= OMAP_MAX_GPIO_LINES,
+	.irq_base	= TWL4030_GPIO_IRQ_BASE,
+	.irq_end	= TWL4030_GPIO_IRQ_END,
+	.use_leds	= true,
+	.pullups	= BIT(1),
+	.pulldowns	= BIT(2)  | BIT(6)  | BIT(7)  | BIT(8)
+			| BIT(13) | BIT(15) | BIT(16) | BIT(17),
+	.setup		= omap3logic_twl_gpio_setup,
+};
+
+static struct twl4030_platform_data omap3logic_twldata = {
+	.irq_base	= TWL4030_IRQ_BASE,
+	.irq_end	= TWL4030_IRQ_END,
+
+	/* platform_data for children goes here */
+	.gpio		= &omap3logic_gpio_data,
+};
+
+static struct i2c_board_info __initdata omap3logic_i2c_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("twl4030", 0x48),
+		.flags = I2C_CLIENT_WAKE,
+		.irq = INT_34XX_SYS_NIRQ,
+		.platform_data = &omap3logic_twldata,
+	},
+};
+
+static int __init omap3logic_i2c_init(void)
+{
+	omap_register_i2c_bus(1, 2600, omap3logic_i2c_boardinfo,
+				ARRAY_SIZE(omap3logic_i2c_boardinfo));
+	return 0;
+}
+
+static struct omap_board_config_kernel omap3logic_config[] __initdata = {
+};
+
+static void __init omap3logic_init_irq(void)
+{
+	omap_board_config = omap3logic_config;
+	omap_board_config_size = ARRAY_SIZE(omap3logic_config);
+	omap2_init_common_hw(mt46h32m32lf6_sdrc_params,
+				mt46h32m32lf6_sdrc_params);
+	omap_init_irq();
+#ifdef CONFIG_OMAP_32K_TIMER
+	omap2_gp_clockevent_set_gptimer(12);
+#endif
+	omap_gpio_init();
+}
+
+
+
+static void __init omap3logic_init(void)
+{
+	omap3logic_i2c_init();
+	omap_serial_init();
+
+	/* Ensure SDRC pins are mux'd for self-refresh */
+/*	omap_cfg_reg(H16_34XX_SDRC_CKE0);
+	omap_cfg_reg(H17_34XX_SDRC_CKE1);
+	omap_cfg_reg(SDRC_CKE0);
+	omap_cfg_reg(SDRC_CKE1); */
+	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
+	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
+}
+
+static void __init omap3logic_map_io(void)
+{
+	omap2_set_globals_3xxx();
+	omap34xx_map_common_io();
+}
+#ifdef CONFIG_MACH_OMAP3_TORPEDO
+	MACHINE_START(OMAP3_TORPEDO, "Logic OMAP3 Torpedo board")
+		.phys_io	= 0x48000000,
+		.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
+		.boot_params	= 0x80000100,
+		.map_io		= omap3logic_map_io,
+		.init_irq	= omap3logic_init_irq,
+		.init_machine	= omap3logic_init,
+		.timer		= &omap_timer,
+	MACHINE_END
+#endif
+
+#ifdef CONFIG_MACH_OMAP3530_LV_SOM
+	MACHINE_START(OMAP3530_LV_SOM, "OMAP Logic 3530 LV SOM board")
+		.phys_io	= 0x48000000,
+		.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
+		.boot_params	= 0x80000100,
+		.map_io		= omap3logic_map_io,
+		.init_irq	= omap3logic_init_irq,
+		.init_machine	= omap3logic_init,
+		.timer		= &omap_timer,
+	MACHINE_END
+#endif
-- 
1.6.0.4

