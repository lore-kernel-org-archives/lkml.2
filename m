Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab2FHJHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:07:24 -0400
Received: from mail.df.lth.se ([194.47.250.12]:9630 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075Ab2FHJHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:07:21 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: swarren@wwwdotorg.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] ARM: nomadik: configure Nomadik for pin control
Date: Fri,  8 Jun 2012 11:07:16 +0200
Message-Id: <1339146436-20735-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the Nomadik to using pin control using the
driver for the STN8815 ASIC.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/Kconfig                      |    1 +
 arch/arm/mach-nomadik/board-nhk8815.c |   35 +++++++++++++++++++++++++++++++++
 arch/arm/mach-nomadik/cpu-8815.c      |   13 ++++++++++++
 3 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e58bda6..e154bfd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -915,6 +915,7 @@ config ARCH_NOMADIK
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	select PINCTRL
+	select PINCTRL_STN8815
 	select MIGHT_HAVE_CACHE_L2X0
 	select ARCH_REQUIRE_GPIOLIB
 	help
diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index 1169a12..3eccef6 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -23,6 +23,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/i2c.h>
 #include <linux/io.h>
+#include <linux/pinctrl/machine.h>
 #include <asm/hardware/vic.h>
 #include <asm/sizes.h>
 #include <asm/mach-types.h>
@@ -292,8 +293,42 @@ static struct i2c_board_info __initdata nhk8815_i2c2_devices[] = {
 	},
 };
 
+static unsigned long out_low[] = { PIN_OUTPUT_LOW };
+static unsigned long out_high[] = { PIN_OUTPUT_HIGH };
+static unsigned long in_nopull[] = { PIN_INPUT_NOPULL };
+static unsigned long in_pullup[] = { PIN_INPUT_PULLUP };
+
+static struct pinctrl_map __initdata nhk8815_pinmap[] = {
+	PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-stn8815", "u0_a_1", "u0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("uart1", "pinctrl-stn8815", "u1_a_1", "u1"),
+	/* Hog in MMC/SD card mux */
+	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-stn8815", "mmcsd_a_1", "mmcsd"),
+	/* MCCLK */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO8_B10", out_low),
+	/* MCCMD */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO9_A10", in_pullup),
+	/* MCCMDDIR */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO10_C11", out_high),
+	/* MCDAT3-0 */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO11_B11", in_pullup),
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO12_A11", in_pullup),
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO13_C12", in_pullup),
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO14_B12", in_pullup),
+	/* MCDAT0DIR */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO15_A12", out_high),
+	/* MCDAT31DIR */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO16_C13", out_high),
+	/* MCMSFBCLK */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO24_C15", in_pullup),
+	/* CD input GPIO */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO111_H21", in_nopull),
+	/* CD bias drive */
+	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-stn8815", "GPIO112_J21", out_low),
+};
+
 static void __init nhk8815_platform_init(void)
 {
+	pinctrl_register_mappings(nhk8815_pinmap, ARRAY_SIZE(nhk8815_pinmap));
 	cpu8815_platform_init();
 	nhk8815_onenand_init();
 	platform_add_devices(nhk8815_platform_devices,
diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index 6fd8e46..b617eae 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -83,6 +83,18 @@ void cpu8815_add_gpios(resource_size_t *base, int num, int irq,
 	}
 }
 
+static inline void
+cpu8815_add_pinctrl(struct device *parent, const char *name)
+{
+	struct platform_device_info pdevinfo = {
+		.parent = parent,
+		.name = name,
+		.id = -1,
+	};
+
+	platform_device_register_full(&pdevinfo);
+}
+
 static int __init cpu8815_init(void)
 {
 	struct nmk_gpio_platform_data pdata = {
@@ -91,6 +103,7 @@ static int __init cpu8815_init(void)
 
 	cpu8815_add_gpios(cpu8815_gpio_base, ARRAY_SIZE(cpu8815_gpio_base),
 			  IRQ_GPIO0, &pdata);
+	cpu8815_add_pinctrl(NULL, "pinctrl-stn8815");
 	amba_apb_device_add(NULL, "rng", NOMADIK_RNG_BASE, SZ_4K, 0, 0, NULL, 0);
 	amba_apb_device_add(NULL, "rtc-pl031", NOMADIK_RTC_BASE, SZ_4K, IRQ_RTC_RTT, 0, NULL, 0);
 	return 0;
-- 
1.7.7.6

