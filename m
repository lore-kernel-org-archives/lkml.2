Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2LJLIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:08:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48168 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2LJLIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:08:13 -0500
Date: Mon, 10 Dec 2012 11:08:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: [PATCH 11/12 v2] ARM: ux500: Use the GPIO regulator framework for
 SDI0's 'en' and 'vsel'
Message-ID: <20121210110807.GF9362@gmail.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
 <1355129761-8088-12-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355129761-8088-12-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent lots of unnecessary call-backs into platform code, we're
now using the GPIO regulator framework to control the 'enable' (en)
and 'voltage select' (vsel) GPIO pins which in turn control the
MMCI's secondary regulator settings. This already works with Device
Tree, but when booting with ATAGs we need to register it as a
platform device.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   14 ++++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
 arch/arm/mach-ux500/board-mop500.c            |   44 +++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 2a17bc5..cb75405 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -28,6 +28,20 @@ struct regulator_init_data gpio_en_3v3_regulator = {
        .consumer_supplies = gpio_en_3v3_consumers,
 };
 
+static struct regulator_consumer_supply sdi0_reg_consumers[] = {
+        REGULATOR_SUPPLY("vqmmc", "sdi0"),
+};
+
+struct regulator_init_data sdi0_reg_init_data = {
+        .constraints = {
+                .min_uV         = 1800000,
+                .max_uV         = 2900000,
+                .valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|REGULATOR_CHANGE_STATUS,
+        },
+        .num_consumer_supplies  = ARRAY_SIZE(sdi0_reg_consumers),
+        .consumer_supplies      = sdi0_reg_consumers,
+};
+
 /*
  * TPS61052 regulator
  */
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 78a0642..0c79d90 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -19,5 +19,6 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS];
 extern struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS];
 extern struct regulator_init_data tps61052_regulator;
 extern struct regulator_init_data gpio_en_3v3_regulator;
+extern struct regulator_init_data sdi0_reg_init_data;
 
 #endif
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index daa4237..1d721ea 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -24,6 +24,8 @@
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
 #include <linux/regulator/fixed.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/gpio-regulator.h>
 #include <linux/mfd/tc3589x.h>
 #include <linux/mfd/tps6105x.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
@@ -91,6 +93,37 @@ static struct platform_device snowball_gpio_en_3v3_regulator_dev = {
        },
 };
 
+/* Dynamically populated. */
+static struct gpio sdi0_reg_gpios[] = {
+        { 0, GPIOF_OUT_INIT_LOW, "mmci_vsel" },
+};
+
+static struct gpio_regulator_state sdi0_reg_states[] = {
+        { .value = 2900000, .gpios = (0 << 0) },
+        { .value = 1800000, .gpios = (1 << 0) },
+};
+
+static struct gpio_regulator_config sdi0_reg_info = {
+	.supply_name           = "ab8500-ext-supply3",
+	.gpios                 = sdi0_reg_gpios,
+	.nr_gpios              = ARRAY_SIZE(sdi0_reg_gpios),
+	.states                = sdi0_reg_states,
+	.nr_states             = ARRAY_SIZE(sdi0_reg_states),
+	.type                  = REGULATOR_VOLTAGE,
+	.enable_high           = 1,
+	.enabled_at_boot       = 0,
+	.init_data             = &sdi0_reg_init_data,
+	.startup_delay         = 100,
+};
+
+static struct platform_device sdi0_regulator = {
+        .name = "gpio-regulator",
+        .id   = -1,
+        .dev  = {
+                .platform_data = &sdi0_reg_info,
+        },
+};
+
 static struct ab8500_gpio_platform_data ab8500_gpio_pdata = {
 	.gpio_base		= MOP500_AB8500_PIN_GPIO(1),
 	.irq_base		= MOP500_AB8500_VIR_GPIO_IRQ_BASE,
@@ -440,6 +473,7 @@ static struct hash_platform_data u8500_hash1_platform_data = {
 /* add any platform devices here - TODO */
 static struct platform_device *mop500_platform_devs[] __initdata = {
 	&mop500_gpio_keys_device,
+	&sdi0_regulator,
 };
 
 #ifdef CONFIG_STE_DMA40
@@ -581,6 +615,7 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
 	&snowball_key_dev,
 	&snowball_sbnet_dev,
 	&snowball_gpio_en_3v3_regulator_dev,
+	&sdi0_regulator,
 };
 
 static void __init mop500_init_machine(void)
@@ -591,6 +626,9 @@ static void __init mop500_init_machine(void)
 
 	mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
 
+	sdi0_reg_info.enable_gpio = GPIO_SDMMC_EN;
+	sdi0_reg_info.gpios[0].gpio = GPIO_SDMMC_1V8_3V_SEL;
+
 	mop500_pinmaps_init();
 	parent = u8500_init_devices(&ab8500_platdata);
 
@@ -623,6 +661,9 @@ static void __init snowball_init_machine(void)
 	struct device *parent = NULL;
 	int i;
 
+	sdi0_reg_info.enable_gpio = SNOWBALL_SDMMC_EN_GPIO;
+	sdi0_reg_info.gpios[0].gpio = SNOWBALL_SDMMC_1V8_3V_GPIO;
+
 	snowball_pinmaps_init();
 	parent = u8500_init_devices(&ab8500_platdata);
 
@@ -655,6 +696,9 @@ static void __init hrefv60_init_machine(void)
 	 */
 	mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
 
+	sdi0_reg_info.enable_gpio = HREFV60_SDMMC_EN_GPIO;
+	sdi0_reg_info.gpios[0].gpio = HREFV60_SDMMC_1V8_3V_GPIO;
+
 	hrefv60_pinmaps_init();
 	parent = u8500_init_devices(&ab8500_platdata);
 
-- 
1.7.9.5
