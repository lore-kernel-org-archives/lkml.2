Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab2CKMnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:43:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54735 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2CKMlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:41:55 -0400
X-AuditID: cbfee61b-b7c62ae000000989-78-4f5c9d91f710
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 2/5] pinctrl: add exynos4 specific pins, groups,
 functions and gpio chip data
Date: Sun, 11 Mar 2012 18:16:02 +0530
Message-id: <1331469965-28846-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Exynos4 specific information about pins, groups, functions and gpio
chip data that will be used as driver data by the Samsung pinctrl driver.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/pinctrl/Kconfig           |    7 +
 drivers/pinctrl/Makefile          |    1 +
 drivers/pinctrl/pinctrl-exynos4.c |  522 +++++++++++++++++++++++++++++++++++++
 3 files changed, 530 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-exynos4.c

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index a068d16..b798a52 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -82,6 +82,13 @@ config PINCTRL_COH901
 config PINCTRL_SAMSUNG
 	bool "Samsung pinctrl driver"
 
+config PINCTRL_EXYNOS4
+	bool "Pinctrl driver data for Exynos4 SoC"
+	depends on ARCH_EXYNOS4
+	select PINCTRL_SAMSUNG
+	select PINMUX
+	select PINCONF
+
 endmenu
 
 endif
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index eaccc1b..79b6cda 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
 obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
+obj-$(CONFIG_PINCTRL_EXYNOS4)	+= pinctrl-exynos4.o
diff --git a/drivers/pinctrl/pinctrl-exynos4.c b/drivers/pinctrl/pinctrl-exynos4.c
new file mode 100644
index 0000000..5eb6168
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-exynos4.c
@@ -0,0 +1,522 @@
+/*
+ * Exynos4 specific driver data for Samsung pinctrl and gpiolib driver.
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Copyright (c) 2011 Linaro Ltd
+ *		http://www.linaro.org
+ *
+ * This file contains the Exynos4 specific driver data for the Samsung
+ * pinctrl/gpiolib interface drivers.
+ *
+ * ToDo: Add additional pin functions and pin groups available on Exynos4210.
+ *
+ * Author: Thomas Abraham <thomas.ab@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/gpio.h>
+
+#include <plat/pinctrl.h>
+
+#include "pinctrl-samsung.h"
+
+/* Exynos4210 Pin-Controller 0 pin list */
+static unsigned int exynos4210_i2c2_pins[] = {
+	EXYNOS4_GPA0(6), EXYNOS4_GPA0(7),
+};
+
+static unsigned int exynos4210_i2c3_pins[] = {
+	EXYNOS4_GPA1(2), EXYNOS4_GPA1(3),
+};
+
+static unsigned int exynos4210_spi0_pins[] = {
+	EXYNOS4_GPB(0), EXYNOS4_GPB(1), EXYNOS4_GPB(2), EXYNOS4_GPB(3),
+};
+
+static unsigned int exynos4210_i2c4_pins[] = {
+	EXYNOS4_GPB(2), EXYNOS4_GPB(3),
+};
+
+static unsigned int exynos4210_spi1_pins[] = {
+	EXYNOS4_GPB(4), EXYNOS4_GPB(5), EXYNOS4_GPB(6), EXYNOS4_GPB(7),
+};
+
+static unsigned int exynos4210_i2c5_pins[] = {
+	EXYNOS4_GPB(6), EXYNOS4_GPB(7),
+};
+
+static unsigned int exynos4210_i2s1_pcm1_ac97_pins[] = {
+	EXYNOS4_GPC0(0), EXYNOS4_GPC0(1), EXYNOS4_GPC0(2), EXYNOS4_GPC0(3),
+	EXYNOS4_GPC0(4),
+};
+
+static unsigned int exynos4210_i2s2_pcm2_pins[] = {
+	EXYNOS4_GPC1(0), EXYNOS4_GPC1(1), EXYNOS4_GPC1(2), EXYNOS4_GPC1(3),
+	EXYNOS4_GPC1(4),
+};
+
+static unsigned int exynos4210_spdif_pins[] = {
+	EXYNOS4_GPC1(0), EXYNOS4_GPC1(1),
+};
+
+static unsigned int exynos4210_spi2_pins[] = {
+	EXYNOS4_GPC1(1), EXYNOS4_GPC1(2), EXYNOS4_GPC1(3), EXYNOS4_GPC1(4),
+};
+
+static unsigned int exynos4210_i2c6_pins[] = {
+	EXYNOS4_GPC1(3), EXYNOS4_GPC1(4),
+};
+
+static unsigned int exynos4210_i2c7_pins[] = {
+	EXYNOS4_GPD0(2), EXYNOS4_GPD0(3),
+};
+
+static unsigned int exynos4210_i2c0_pins[] = {
+	EXYNOS4_GPD1(0), EXYNOS4_GPD1(1),
+};
+
+static unsigned int exynos4210_cam_b_pins[] = {
+	EXYNOS4_GPE0(0), EXYNOS4_GPE0(1), EXYNOS4_GPE0(2), EXYNOS4_GPE0(3),
+	EXYNOS4_GPE0(4), EXYNOS4_GPE1(0), EXYNOS4_GPE1(1), EXYNOS4_GPE1(2),
+	EXYNOS4_GPE1(3), EXYNOS4_GPE1(4), EXYNOS4_GPE1(5), EXYNOS4_GPE1(6),
+	EXYNOS4_GPE1(7),
+};
+
+static unsigned int exynos4210_lcd_pins[] = {
+	EXYNOS4_GPF0(0), EXYNOS4_GPF0(1), EXYNOS4_GPF0(2), EXYNOS4_GPF0(3),
+	EXYNOS4_GPF0(4), EXYNOS4_GPF0(5), EXYNOS4_GPF0(6), EXYNOS4_GPF0(7),
+	EXYNOS4_GPF1(0), EXYNOS4_GPF1(1), EXYNOS4_GPF1(2), EXYNOS4_GPF1(3),
+	EXYNOS4_GPF1(4), EXYNOS4_GPF1(5), EXYNOS4_GPF1(6), EXYNOS4_GPF1(7),
+	EXYNOS4_GPF2(0), EXYNOS4_GPF2(1), EXYNOS4_GPF2(2), EXYNOS4_GPF2(3),
+	EXYNOS4_GPF2(4), EXYNOS4_GPF2(5), EXYNOS4_GPF2(6), EXYNOS4_GPF2(7),
+	EXYNOS4_GPF3(0), EXYNOS4_GPF3(1), EXYNOS4_GPF3(2), EXYNOS4_GPF3(3),
+};
+
+/* Exynos4210 Pin-Controller 1 pin list */
+static unsigned int exynos4210_cam_a_pins[] = {
+	EXYNOS4_GPJ0(0), EXYNOS4_GPJ0(1), EXYNOS4_GPJ0(2), EXYNOS4_GPJ0(3),
+	EXYNOS4_GPJ0(4), EXYNOS4_GPJ0(5), EXYNOS4_GPJ0(6), EXYNOS4_GPJ0(7),
+	EXYNOS4_GPJ1(0), EXYNOS4_GPJ1(1), EXYNOS4_GPJ1(2), EXYNOS4_GPJ1(3),
+	EXYNOS4_GPJ1(4),
+};
+
+static unsigned int exynos4210_sdhci0_4_ctrl_pins[] = {
+	EXYNOS4_GPK0(0), EXYNOS4_GPK0(1)
+};
+
+static unsigned int exynos4210_sdhci0_4_cd_pins[] = {
+	EXYNOS4_GPK0(2)
+};
+
+static unsigned int exynos4210_sdhci0_4_4bit_pins[] = {
+	EXYNOS4_GPK0(3), EXYNOS4_GPK0(4), EXYNOS4_GPK0(5), EXYNOS4_GPK0(6)
+};
+
+static unsigned int exynos4210_sdhci0_4_8bit_pins[] = {
+	EXYNOS4_GPK1(3), EXYNOS4_GPK1(4), EXYNOS4_GPK1(5), EXYNOS4_GPK1(6)
+};
+
+static unsigned int exynos4210_sdhci1_ctrl_pins[] = {
+	EXYNOS4_GPK1(0), EXYNOS4_GPK1(1)
+};
+
+static unsigned int exynos4210_sdhci1_cd_pins[] = {
+	EXYNOS4_GPK1(2)
+};
+
+static unsigned int exynos4210_sdhci1_4bit_pins[] = {
+	EXYNOS4_GPK1(3), EXYNOS4_GPK1(4), EXYNOS4_GPK1(5), EXYNOS4_GPK1(6)
+};
+
+static unsigned int exynos4210_sdhci2_ctrl_pins[] = {
+	EXYNOS4_GPK2(0), EXYNOS4_GPK2(1)
+};
+
+static unsigned int exynos4210_sdhci2_cd_pins[] = {
+	EXYNOS4_GPK2(2)
+};
+
+static unsigned int exynos4210_sdhci2_4bit_pins[] = {
+	EXYNOS4_GPK2(3), EXYNOS4_GPK2(4), EXYNOS4_GPK2(5), EXYNOS4_GPK2(6)
+};
+
+static unsigned int exynos4210_sdhci2_8bit_pins[] = {
+	EXYNOS4_GPK3(3), EXYNOS4_GPK3(4), EXYNOS4_GPK3(5), EXYNOS4_GPK3(6)
+};
+
+static unsigned int exynos4210_sdhci3_ctrl_pins[] = {
+	EXYNOS4_GPK3(0), EXYNOS4_GPK3(1)
+};
+
+static unsigned int exynos4210_sdhci3_cd_pins[] = {
+	EXYNOS4_GPK3(2)
+};
+
+static unsigned int exynos4210_sdhci3_4bit_pins[] = {
+	EXYNOS4_GPK3(3), EXYNOS4_GPK3(4), EXYNOS4_GPK3(5), EXYNOS4_GPK3(6)
+};
+
+/* Exynos4210 Pin-Controller 2 pin list */
+static unsigned int exynos4210_i2s0_pins[] = {
+	EXYNOS4_GPZ(0), EXYNOS4_GPZ(1), EXYNOS4_GPZ(2), EXYNOS4_GPZ(3),
+	EXYNOS4_GPZ(4), EXYNOS4_GPZ(5), EXYNOS4_GPZ(6), EXYNOS4_GPZ(7)
+};
+
+static unsigned int exynos4210_pcm0_pins[] = {
+	EXYNOS4_GPZ(0), EXYNOS4_GPZ(1), EXYNOS4_GPZ(2), EXYNOS4_GPZ(3),
+	EXYNOS4_GPZ(4), EXYNOS4_GPZ(5),
+};
+
+/*
+ * list of pin groups available for pin-controller[0] of Exynos4210.
+ */
+static const struct samsung_pin_group exynos4210_pin_groups0[] = {
+	PIN_GROUP("i2c2_grp", exynos4210_i2c2_pins, 3),
+	PIN_GROUP("i2c3_grp", exynos4210_i2c3_pins, 3),
+	PIN_GROUP("spi0_grp", exynos4210_spi0_pins, 2),
+	PIN_GROUP("i2c4_grp", exynos4210_i2c4_pins, 3),
+	PIN_GROUP("spi1_grp", exynos4210_spi1_pins, 2),
+	PIN_GROUP("i2c5_grp", exynos4210_i2c5_pins, 3),
+	PIN_GROUP("i2s1_grp", exynos4210_i2s1_pcm1_ac97_pins, 2),
+	PIN_GROUP("pcm1_grp", exynos4210_i2s1_pcm1_ac97_pins, 3),
+	PIN_GROUP("ac97_grp", exynos4210_i2s1_pcm1_ac97_pins, 4),
+	PIN_GROUP("i2s2_grp", exynos4210_i2s2_pcm2_pins, 2),
+	PIN_GROUP("pcm2_grp", exynos4210_i2s2_pcm2_pins, 3),
+	PIN_GROUP("spdif_grp", exynos4210_spdif_pins, 4),
+	PIN_GROUP("spi2_grp", exynos4210_spi2_pins, 5),
+	PIN_GROUP("i2c6_grp", exynos4210_i2c6_pins, 4),
+	PIN_GROUP("i2c7_grp", exynos4210_i2c7_pins, 3),
+	PIN_GROUP("i2c0_grp", exynos4210_i2c0_pins, 2),
+	PIN_GROUP("camb_grp", exynos4210_cam_b_pins, 3),
+	PIN_GROUP("lcd_grp", exynos4210_lcd_pins, 2),
+};
+
+/*
+ * list of pin groups available for pin-controller[1] of Exynos4210.
+ */
+static const struct samsung_pin_group exynos4210_pin_groups1[] = {
+	PIN_GROUP("cama_grp", exynos4210_cam_a_pins, 2),
+	PIN_GROUP("sdhci0_ctrl_grp", exynos4210_sdhci0_4_ctrl_pins, 2),
+	PIN_GROUP("sdhci0_cd_grp", exynos4210_sdhci0_4_cd_pins, 2),
+	PIN_GROUP("sdhci0_4bit_grp", exynos4210_sdhci0_4_4bit_pins, 2),
+	PIN_GROUP("sdhci0_8bit_grp", exynos4210_sdhci0_4_8bit_pins, 3),
+	PIN_GROUP("sdhci1_ctrl_grp", exynos4210_sdhci1_ctrl_pins, 2),
+	PIN_GROUP("sdhci1_cd_grp", exynos4210_sdhci1_cd_pins, 2),
+	PIN_GROUP("sdhci1_4bit_grp", exynos4210_sdhci1_4bit_pins, 2),
+	PIN_GROUP("sdhci2_ctrl_grp", exynos4210_sdhci2_ctrl_pins, 2),
+	PIN_GROUP("sdhci2_cd_grp", exynos4210_sdhci2_cd_pins, 2),
+	PIN_GROUP("sdhci2_4bit_grp", exynos4210_sdhci2_4bit_pins, 2),
+	PIN_GROUP("sdhci2_8bit_grp", exynos4210_sdhci2_8bit_pins, 3),
+	PIN_GROUP("sdhci3_ctrl_grp", exynos4210_sdhci3_ctrl_pins, 2),
+	PIN_GROUP("sdhci3_cd_grp", exynos4210_sdhci3_cd_pins, 2),
+	PIN_GROUP("sdhci3_4bit_grp", exynos4210_sdhci3_4bit_pins, 2),
+	PIN_GROUP("sdhci4_ctrl_grp", exynos4210_sdhci0_4_ctrl_pins, 3),
+	PIN_GROUP("sdhci4_cd_grp", exynos4210_sdhci0_4_cd_pins, 3),
+	PIN_GROUP("sdhci4_4bit_grp", exynos4210_sdhci0_4_4bit_pins, 3),
+	PIN_GROUP("sdhci4_8bit_grp", exynos4210_sdhci0_4_8bit_pins, 4),
+};
+
+/*
+ * list of pin groups available for pin-controller[2] of Exynos4210.
+ */
+static const struct samsung_pin_group exynos4210_pin_groups2[] = {
+	PIN_GROUP("i2s0_grp", exynos4210_i2s0_pins, 2),
+	PIN_GROUP("pcm0_grp", exynos4210_pcm0_pins, 3),
+};
+
+/*
+ * list of group names which are included per pin-function of Exynos4210
+ * pin controller 0
+ */
+static const char * const i2c2_groups[] = { "i2c2_grp" };
+static const char * const i2c3_groups[] = { "i2c3_grp" };
+static const char * const spi0_groups[] = { "spi0_grp" };
+static const char * const i2c4_groups[] = { "i2c4_grp" };
+static const char * const spi1_groups[] = { "spi1_grp" };
+static const char * const i2c5_groups[] = { "i2c5_grp" };
+static const char * const i2s1_groups[] = { "i2s1_grp" };
+static const char * const pcm1_groups[] = { "pcm1_grp" };
+static const char * const ac97_groups[] = { "ac97_grp" };
+static const char * const i2s2_groups[] = { "i2s2_grp" };
+static const char * const pcm2_groups[] = { "pcm2_grp" };
+static const char * const spdif_groups[] = { "spdif_grp" };
+static const char * const spi2_groups[] = { "spi2_grp" };
+static const char * const i2c6_groups[] = { "i2c6_grp" };
+static const char * const i2c7_groups[] = { "i2c7_grp" };
+static const char * const i2c0_groups[] = { "i2c0_grp" };
+static const char * const camb_groups[] = { "camb_grp" };
+static const char * const lcd_groups[] = { "lcd_grp" };
+
+/*
+ * list of group names which are included per pin-function of Exynos4210
+ * pin controller 1
+ */
+static const char * const cama_groups[] = { "cama_grp" };
+static const char * const sdhci0_groups[] = { "sdhci0_ctrl_grp",
+		"sdhci0_cd_grp", "sdhci0_4bit_grp", "sdhci0_8bit_grp" };
+static const char * const sdhci1_groups[] = { "sdhci1_ctrl_grp",
+		"sdhci1_cd_grp", "sdhci1_4bit_grp" };
+static const char * const sdhci2_groups[] = { "sdhci2_ctrl_grp",
+		"sdhci2_cd_grp", "sdhci2_4bit_grp", "sdhci2_8bit_grp" };
+static const char * const sdhci3_groups[] = { "sdhci3_ctrl_grp",
+		"sdhci3_cd_grp", "sdhci3_4bit_grp" };
+static const char * const sdhci4_groups[] = { "sdhci4_ctrl_grp",
+		"sdhci4_cd_grp", "sdhci4_4bit_grp", "sdhci4_8bit_grp" };
+
+/*
+ * list of group names which are included per pin-function of Exynos4210
+ * pin controller 2
+ */
+static const char * const i2s0_groups[] = { "i2s0_grp" };
+static const char * const pcm0_groups[] = { "pcm0_grp" };
+
+/*
+ * list of function names supported by the pinmux controller 0 of exynos4210.
+ */
+static const struct samsung_pmx_func exynos4210_pmx_functions0[] = {
+	PMX_FUNC("i2c2-mux", i2c2_groups),
+	PMX_FUNC("i2c3-mux", i2c3_groups),
+	PMX_FUNC("spi0-mux", i2c3_groups),
+	PMX_FUNC("spi0-mux", i2c3_groups),
+	PMX_FUNC("i2c4-mux", i2c4_groups),
+	PMX_FUNC("spi1-mux", spi1_groups),
+	PMX_FUNC("i2c5-mux", i2c5_groups),
+	PMX_FUNC("i2s1-mux", i2s1_groups),
+	PMX_FUNC("pcm1-mux", pcm1_groups),
+	PMX_FUNC("ac97-mux", ac97_groups),
+	PMX_FUNC("i2s2-mux", i2s2_groups),
+	PMX_FUNC("pcm2-mux", pcm2_groups),
+	PMX_FUNC("spdif-mux", spdif_groups),
+	PMX_FUNC("spi2-mux", spi2_groups),
+	PMX_FUNC("i2c6-mux", i2c6_groups),
+	PMX_FUNC("i2c7-mux", i2c7_groups),
+	PMX_FUNC("i2c0-mux", i2c0_groups),
+	PMX_FUNC("camb-mux", camb_groups),
+	PMX_FUNC("lcd-mux", lcd_groups),
+};
+
+/*
+ * list of function names supported by the pinmux controller 1 of exynos4210.
+ */
+static const struct samsung_pmx_func exynos4210_pmx_functions1[] = {
+	PMX_FUNC("cama-mux", cama_groups),
+	PMX_FUNC("sdhci0-mux", sdhci0_groups),
+	PMX_FUNC("sdhci1-mux", sdhci1_groups),
+	PMX_FUNC("sdhci2-mux", sdhci2_groups),
+	PMX_FUNC("sdhci3-mux", sdhci3_groups),
+	PMX_FUNC("sdhci4-mux", sdhci4_groups),
+};
+
+/*
+ * list of function names supported by the pinmux controller 1 of exynos4210.
+ */
+static const struct samsung_pmx_func exynos4210_pmx_functions2[] = {
+	PMX_FUNC("i2s0-mux", i2s0_groups),
+	PMX_FUNC("pcm0-mux", pcm0_groups),
+};
+
+#define EXYNOS4_PIN_BANK(offset, __gpio, id)		\
+	{						\
+		.reg_offset	= offset,		\
+		.pin_base	= (__gpio##_START),	\
+		.nr_pins	= (__gpio##_NR),	\
+		.func_width	= 4,			\
+		.pud_width	= 2,			\
+		.drv_width	= 2,			\
+		.name		= id			\
+	}
+
+/* pin banks of pin-controller 0 */
+static struct samsung_pin_bank exynos4210_pin_banks0[] = {
+	EXYNOS4_PIN_BANK(0x000, EXYNOS4_GPIO_A0, "gpa0"),
+	EXYNOS4_PIN_BANK(0x020, EXYNOS4_GPIO_A1, "gpa1"),
+	EXYNOS4_PIN_BANK(0x040, EXYNOS4_GPIO_B, "gpb"),
+	EXYNOS4_PIN_BANK(0x060, EXYNOS4_GPIO_C0, "gpc0"),
+	EXYNOS4_PIN_BANK(0x080, EXYNOS4_GPIO_C1, "gpc1"),
+	EXYNOS4_PIN_BANK(0x0A0, EXYNOS4_GPIO_D0, "gpd0"),
+	EXYNOS4_PIN_BANK(0x0C0, EXYNOS4_GPIO_D1, "gpd1"),
+	EXYNOS4_PIN_BANK(0x0E0, EXYNOS4_GPIO_E0, "gpe0"),
+	EXYNOS4_PIN_BANK(0x100, EXYNOS4_GPIO_E1, "gpe1"),
+	EXYNOS4_PIN_BANK(0x120, EXYNOS4_GPIO_E2, "gpe2"),
+	EXYNOS4_PIN_BANK(0x140, EXYNOS4_GPIO_E3, "gpe3"),
+	EXYNOS4_PIN_BANK(0x160, EXYNOS4_GPIO_E4, "gpe4"),
+	EXYNOS4_PIN_BANK(0x180, EXYNOS4_GPIO_F0, "gpf0"),
+	EXYNOS4_PIN_BANK(0x1A0, EXYNOS4_GPIO_F1, "gpf1"),
+	EXYNOS4_PIN_BANK(0x1C0, EXYNOS4_GPIO_F2, "gpf2"),
+	EXYNOS4_PIN_BANK(0x1E0, EXYNOS4_GPIO_F3, "gpf3"),
+};
+
+#define EXYNOS4_PIN_BANK1(offset, __gpio, id)		\
+	{						\
+		.reg_offset	= offset,		\
+		.pin_base	= (__gpio##_START) - EXYNOS4_GPIO_J0_START,\
+		.nr_pins	= (__gpio##_NR),	\
+		.func_width	= 4,			\
+		.pud_width	= 2,			\
+		.drv_width	= 2,			\
+		.name		= id,			\
+	}
+
+/* pin banks of pin-controller 1 */
+static struct samsung_pin_bank exynos4210_pin_banks1[] = {
+	EXYNOS4_PIN_BANK1(0x000, EXYNOS4_GPIO_J0, "gpj0"),
+	EXYNOS4_PIN_BANK1(0x020, EXYNOS4_GPIO_J1, "gpj1"),
+	EXYNOS4_PIN_BANK1(0x040, EXYNOS4_GPIO_K0, "gpk0"),
+	EXYNOS4_PIN_BANK1(0x060, EXYNOS4_GPIO_K1, "gpk1"),
+	EXYNOS4_PIN_BANK1(0x080, EXYNOS4_GPIO_K2, "gpk2"),
+	EXYNOS4_PIN_BANK1(0x0A0, EXYNOS4_GPIO_K3, "gpk3"),
+	EXYNOS4_PIN_BANK1(0x0C0, EXYNOS4_GPIO_L0, "gpl0"),
+	EXYNOS4_PIN_BANK1(0x0E0, EXYNOS4_GPIO_L1, "gpl1"),
+	EXYNOS4_PIN_BANK1(0x100, EXYNOS4_GPIO_L2, "gpl2"),
+	EXYNOS4_PIN_BANK1(0x120, EXYNOS4_GPIO_Y0, "gpy0"),
+	EXYNOS4_PIN_BANK1(0x140, EXYNOS4_GPIO_Y1, "gpy1"),
+	EXYNOS4_PIN_BANK1(0x160, EXYNOS4_GPIO_Y2, "gpy2"),
+	EXYNOS4_PIN_BANK1(0x180, EXYNOS4_GPIO_Y3, "gpy3"),
+	EXYNOS4_PIN_BANK1(0x1A0, EXYNOS4_GPIO_Y4, "gpy4"),
+	EXYNOS4_PIN_BANK1(0x1C0, EXYNOS4_GPIO_Y5, "gpy5"),
+	EXYNOS4_PIN_BANK1(0x1E0, EXYNOS4_GPIO_Y6, "gpy6"),
+	EXYNOS4_PIN_BANK1(0xC00, EXYNOS4_GPIO_X0, "gpx0"),
+	EXYNOS4_PIN_BANK1(0xC20, EXYNOS4_GPIO_X1, "gpx1"),
+	EXYNOS4_PIN_BANK1(0xC40, EXYNOS4_GPIO_X2, "gpx2"),
+	EXYNOS4_PIN_BANK1(0xC60, EXYNOS4_GPIO_X3, "gpx3"),
+};
+
+#define EXYNOS4_PIN_BANK2(offset, __gpio, id)		\
+	{						\
+		.reg_offset	= offset,		\
+		.pin_base	= (__gpio##_START) - EXYNOS4_GPIO_Z_START,\
+		.nr_pins	= (__gpio##_NR),	\
+		.func_width	= 4,			\
+		.pud_width	= 2,			\
+		.drv_width	= 2,			\
+		.name		= id,			\
+	}
+
+/* pin banks of pin-controller 2 */
+static struct samsung_pin_bank exynos4210_pin_banks2[] = {
+	EXYNOS4_PIN_BANK2(0x000, EXYNOS4_GPIO_Z, "gpz"),
+};
+
+/* gpio range instance for pinctrl 0 */
+static struct pinctrl_gpio_range exynos4210_pctrl0_gpio_range = {
+	.name		= "exynos4210_gpio_range0",
+	.id		= 0,
+};
+
+/* gpio range instance for pinctrl 1 */
+static struct pinctrl_gpio_range exynos4210_pctrl1_gpio_range = {
+	.name		= "exynos4210_gpio_range1",
+	.id		= 0,
+};
+
+/* gpio range instance for pinctrl 2 */
+static struct pinctrl_gpio_range exynos4210_pctrl2_gpio_range = {
+	.name		= "exynos4210_gpio_range2",
+	.id		= 0,
+};
+
+/*
+ * Exynos4210 specific callback to translate PUD_xxx values into Exynos4210
+ * specific register values.
+ */
+static int exynos4210_xlate_pud(unsigned int pud)
+{
+	if (pud == PUD_UP)
+		return 3;
+	else
+		return pud;
+}
+
+/*
+ * Exynos4210 specific callback to translate DRV_xxx values into Exynos4210
+ * specific register values.
+ */
+static int exynos4210_xlate_drv(unsigned int drv)
+{
+	switch (drv) {
+	case DRV_3X:
+		return 1;
+	case DRV_2X:
+		return 2;
+	default:
+		return drv;
+	}
+}
+
+/*
+ * Samsung pinctrl driver data for Exynos4210 SoC. Exynos4210 SoC includes
+ * three gpio/pin-mux/pinconfig controllers.
+ */
+struct samsung_pinctrl_drv_data exynos4210_pinctrl_drv_data[] = {
+	{
+		/* pin-controller instance 0 data */
+		.ctrl = &(struct samsung_pin_ctrl) {
+			.grange		= &exynos4210_pctrl0_gpio_range,
+			.pin_banks	= exynos4210_pin_banks0,
+			.nr_banks	= ARRAY_SIZE(exynos4210_pin_banks0),
+			.base		= EXYNOS4_GPIO_A0_START,
+			.nr_pins	= EXYNOS4_GPIO_J0_START - 1,
+			.xlate_pud	= exynos4210_xlate_pud,
+			.xlate_drv	= exynos4210_xlate_drv,
+			.label		= "exynos4210-gpio-ctrl0",
+		},
+		.pctl = &(struct pinctrl_desc) {
+			.name		= "exynos4210_pinctrl",
+			.owner		= THIS_MODULE,
+		},
+		.pin_groups = exynos4210_pin_groups0,
+		.nr_groups = ARRAY_SIZE(exynos4210_pin_groups0),
+		.pmx_functions = exynos4210_pmx_functions0,
+		.nr_functions = ARRAY_SIZE(exynos4210_pmx_functions0),
+	}, {
+		/* pin-controller instance 1 data */
+		.ctrl = &(struct samsung_pin_ctrl) {
+			.grange		= &exynos4210_pctrl1_gpio_range,
+			.pin_banks	= exynos4210_pin_banks1,
+			.nr_banks	= ARRAY_SIZE(exynos4210_pin_banks1),
+			.base		= EXYNOS4_GPIO_J0_START,
+			.nr_pins	= EXYNOS4_GPIO_Z_START -
+						EXYNOS4_GPIO_J0_START,
+			.xlate_pud	= exynos4210_xlate_pud,
+			.xlate_drv	= exynos4210_xlate_drv,
+			.label		= "exynos4210-gpio-ctrl1",
+		},
+		.pctl = &(struct pinctrl_desc) {
+			.name		= "exynos4210_pinctrl",
+			.owner		= THIS_MODULE,
+		},
+		.pin_groups = exynos4210_pin_groups1,
+		.nr_groups = ARRAY_SIZE(exynos4210_pin_groups1),
+		.pmx_functions = exynos4210_pmx_functions1,
+		.nr_functions = ARRAY_SIZE(exynos4210_pmx_functions1),
+	}, {
+		/* pin-controller instance 2 data */
+		.ctrl = &(struct samsung_pin_ctrl) {
+			.grange		= &exynos4210_pctrl2_gpio_range,
+			.pin_banks	= exynos4210_pin_banks2,
+			.nr_banks	= ARRAY_SIZE(exynos4210_pin_banks2),
+			.base		= EXYNOS4_GPIO_Z_START,
+			.nr_pins	= EXYNOS4_GPIO_Z_NR,
+			.xlate_pud	= exynos4210_xlate_pud,
+			.xlate_drv	= exynos4210_xlate_drv,
+			.label		= "exynos4210-gpio-ctrl2",
+		},
+		.pctl = &(struct pinctrl_desc) {
+			.name		= "exynos4210_pinctrl",
+			.owner		= THIS_MODULE,
+		},
+		.pin_groups = exynos4210_pin_groups2,
+		.nr_groups = ARRAY_SIZE(exynos4210_pin_groups2),
+		.pmx_functions = exynos4210_pmx_functions2,
+		.nr_functions = ARRAY_SIZE(exynos4210_pmx_functions2),
+	},
+};
-- 
1.6.6.rc2

