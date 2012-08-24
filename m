Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2HXMAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:00:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35418 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2HXMAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:00:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Provide SMSC911x fixed-regulator when not booting DT
Date: Fri, 24 Aug 2012 13:00:12 +0100
Message-Id: <1345809612-30992-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMSC911x Ethernet chip requires a fixed-regulator in order to
function correctly. We have previously provided a means to obtain
this during a Device Tree boot, however nothing has been put into
place when booting with a non-DT kernel. This patch aims to change
that.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   17 +++++++++++++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
 arch/arm/mach-ux500/board-mop500.c            |   21 +++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.h            |    2 +-
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 52426a4..11ddda7 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -13,6 +13,23 @@
 #include <linux/regulator/ab8500.h>
 #include "board-mop500-regulators.h"
 
+#ifdef CONFIG_REGULATOR_FIXED_VOLTAGE
+static struct regulator_consumer_supply gpio_en_3v3_consumers[] = {
+       REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
+};
+
+struct regulator_init_data gpio_en_3v3_regulator = {
+       .constraints = {
+               .name = "EN-3V3",
+               .min_uV = 3300000,
+               .max_uV = 3300000,
+               .valid_ops_mask = REGULATOR_CHANGE_STATUS,
+       },
+       .num_consumer_supplies = ARRAY_SIZE(gpio_en_3v3_consumers),
+       .consumer_supplies = gpio_en_3v3_consumers,
+};
+#endif
+
 /*
  * TPS61052 regulator
  */
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 9499215..78a0642 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -18,5 +18,6 @@ extern struct ab8500_regulator_reg_init
 ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS];
 extern struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS];
 extern struct regulator_init_data tps61052_regulator;
+extern struct regulator_init_data gpio_en_3v3_regulator;
 
 #endif
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index de10f8f..0e904c8 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -23,6 +23,7 @@
 #include <linux/spi/spi.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
+#include <linux/regulator/fixed.h>
 #include <linux/mfd/tc3589x.h>
 #include <linux/mfd/tps6105x.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
@@ -75,6 +76,25 @@ static struct platform_device snowball_led_dev = {
 	},
 };
 
+#ifdef CONFIG_REGULATOR_FIXED_VOLTAGE
+static struct fixed_voltage_config snowball_gpio_en_3v3_data = {
+	.supply_name		= "EN-3V3",
+	.gpio			= SNOWBALL_EN_3V3_ETH_GPIO,
+	.microvolts		= 3300000,
+	.enable_high		= 1,
+	.init_data		= &gpio_en_3v3_regulator,
+	.startup_delay		= 5000, /* 1200us */
+};
+
+static struct platform_device snowball_gpio_en_3v3_regulator_dev = {
+	.name	= "reg-fixed-voltage",
+	.id	= 1,
+	.dev	= {
+		.platform_data	= &snowball_gpio_en_3v3_data,
+	},
+};
+#endif
+
 static struct ab8500_gpio_platform_data ab8500_gpio_pdata = {
 	.gpio_base		= MOP500_AB8500_PIN_GPIO(1),
 	.irq_base		= MOP500_AB8500_VIR_GPIO_IRQ_BASE,
@@ -585,6 +605,7 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
 	&snowball_led_dev,
 	&snowball_key_dev,
 	&snowball_sbnet_dev,
+	&snowball_gpio_en_3v3_regulator_dev,
 };
 
 static void __init mop500_init_machine(void)
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index a0f920d..4ace165 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -13,6 +13,7 @@
 #include <linux/amba/mmci.h>
 
 /* Snowball specific GPIO assignments, this board has no GPIO expander */
+#define SNOWBALL_EN_3V3_ETH_GPIO	26
 #define SNOWBALL_ACCEL_INT1_GPIO	163
 #define SNOWBALL_ACCEL_INT2_GPIO	164
 #define SNOWBALL_MAGNET_DRDY_GPIO	165
@@ -76,7 +77,6 @@
 #define SNOWBALL_PM_GPIO4_GPIO		MOP500_AB8500_PIN_GPIO(4)	/* SYSCLKREQ6/GPIO4 */
 #define SNOWBALL_EN_3V6_GPIO		MOP500_AB8500_PIN_GPIO(16)	/* PWMOUT3/GPIO16 */
 #define SNOWBALL_PME_ETH_GPIO		MOP500_AB8500_PIN_GPIO(24)	/* SYSCLKREQ7/GPIO24 */
-#define SNOWBALL_EN_3V3_ETH_GPIO	MOP500_AB8500_PIN_GPIO(26)	/* GPIO26 */
 
 struct device;
 struct i2c_board_info;
-- 
1.7.9.5

