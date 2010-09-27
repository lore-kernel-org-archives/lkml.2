Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab0I0QGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:06:42 -0400
Received: from mail.logicpd.com ([66.162.60.3]:29868 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759629Ab0I0QFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:05:49 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH v4 1/4] Adding LogicPD OMAP3 board support
Date: Mon, 27 Sep 2010 11:05:47 -0500
Message-Id: <1285603550-6382-2-git-send-email-tim.nordell@logicpd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
References: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
X-OriginalArrivalTime: 27 Sep 2010 16:05:47.0351 (UTC) FILETIME=[D8DCCE70:01CB5E5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for LogicPD's OMAP 3530 LV SOM and
OMAP 35x Torpedo board.

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 arch/arm/mach-omap2/Kconfig                  |   20 ++++
 arch/arm/mach-omap2/Makefile                 |    4 +
 arch/arm/mach-omap2/board-omap3logic.c       |  143 ++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/uncompress.h |    2 +
 4 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3logic.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index b48bacf..5403443 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -135,6 +135,26 @@ config MACH_OMAP_LDP
 	default y
 	select OMAP_PACKAGE_CBB
 
+config MACH_OMAP3530_LV_SOM
+	bool "OMAP3 Logic 3530 LV SOM board"
+	depends on ARCH_OMAP3
+	select OMAP_PACKAGE_CBB
+	default y
+	help
+	 Support for the LogicPD OMAP3530 SOM Development kit
+	 for full description please see the products webpage at
+	 http://www.logicpd.com/products/development-kits/texas-instruments-zoom%E2%84%A2-omap35x-development-kit
+
+config MACH_OMAP3_TORPEDO
+	bool "OMAP3 Logic 35x Torpedo board"
+	depends on ARCH_OMAP3
+	select OMAP_PACKAGE_CBB
+	default y
+	help
+	 Support for the LogicPD OMAP35x Torpedo Development kit
+	 for full description please see the products webpage at
+	 http://www.logicpd.com/products/development-kits/zoom-omap35x-torpedo-development-kit
+
 config MACH_OVERO
 	bool "Gumstix Overo board"
 	depends on ARCH_OMAP3
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 88d3a1e..9feadd8 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -115,6 +115,10 @@ obj-$(CONFIG_MACH_DEVKIT8000)     	+= board-devkit8000.o \
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
index 0000000..ac3b0f7
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -0,0 +1,143 @@
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
+#include <plat/control.h>
+
+#define OMAP3LOGIC_SMSC911X_CS			1
+
+#define OMAP3530_LV_SOM_MMC_GPIO_CD		110
+#define OMAP3530_LV_SOM_MMC_GPIO_WP		126
+#define OMAP3530_LV_SOM_SMSC911X_GPIO_IRQ	152
+
+#define OMAP3_TORPEDO_MMC_GPIO_CD		127
+#define OMAP3_TORPEDO_SMSC911X_GPIO_IRQ		129
+
+static struct regulator_consumer_supply omap3logic_vmmc1_supply = {
+	.supply			= "vmmc",
+};
+
+/* VMMC1 for MMC1 pins CMD, CLK, DAT0..DAT3 (20 mA, plus card == max 220 mA) */
+static struct regulator_init_data omap3logic_vmmc1 = {
+	.constraints = {
+		.name			= "VMMC1",
+		.min_uV			= 1850000,
+		.max_uV			= 3150000,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = 1,
+	.consumer_supplies      = &omap3logic_vmmc1_supply,
+};
+
+static struct twl4030_gpio_platform_data omap3logic_gpio_data = {
+	.gpio_base	= OMAP_MAX_GPIO_LINES,
+	.irq_base	= TWL4030_GPIO_IRQ_BASE,
+	.irq_end	= TWL4030_GPIO_IRQ_END,
+	.use_leds	= true,
+	.pullups	= BIT(1),
+	.pulldowns	= BIT(2)  | BIT(6)  | BIT(7)  | BIT(8)
+			| BIT(13) | BIT(15) | BIT(16) | BIT(17),
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
+static void __init omap3logic_init_irq(void)
+{
+	omap2_init_common_hw(NULL, NULL);
+	omap_init_irq();
+	omap_gpio_init();
+}
+
+static void __init omap3logic_init(void)
+{
+	omap3logic_i2c_init();
+	omap_serial_init();
+
+	/* Ensure SDRC pins are mux'd for self-refresh */
+	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
+	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
+}
+
+MACHINE_START(OMAP3_TORPEDO, "Logic OMAP3 Torpedo board")
+	.phys_io	= 0x48000000,
+	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
+	.boot_params	= 0x80000100,
+	.map_io		= omap3_map_io,
+	.init_irq	= omap3logic_init_irq,
+	.init_machine	= omap3logic_init,
+	.timer		= &omap_timer,
+MACHINE_END
+
+MACHINE_START(OMAP3530_LV_SOM, "OMAP Logic 3530 LV SOM board")
+	.phys_io	= 0x48000000,
+	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
+	.boot_params	= 0x80000100,
+	.map_io		= omap3_map_io,
+	.init_irq	= omap3logic_init_irq,
+	.init_machine	= omap3logic_init,
+	.timer		= &omap_timer,
+MACHINE_END
diff --git a/arch/arm/plat-omap/include/plat/uncompress.h b/arch/arm/plat-omap/include/plat/uncompress.h
index ddf723b..ff9f3a2 100644
--- a/arch/arm/plat-omap/include/plat/uncompress.h
+++ b/arch/arm/plat-omap/include/plat/uncompress.h
@@ -139,6 +139,8 @@ static inline void __arch_decomp_setup(unsigned long arch_id)
 		DEBUG_LL_OMAP2(1, omap3evm);
 		DEBUG_LL_OMAP3(1, omap_3430sdp);
 		DEBUG_LL_OMAP3(1, omap_3630sdp);
+		DEBUG_LL_OMAP3(1, omap3530_lv_som);
+		DEBUG_LL_OMAP3(1, omap3_torpedo);
 
 		/* omap3 based boards using UART3 */
 		DEBUG_LL_OMAP3(3, cm_t35);
-- 
1.7.1

