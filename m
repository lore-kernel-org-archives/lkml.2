Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2EWXwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:52:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39568 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2EWXwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:52:17 -0400
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org
Subject: [PATCH 2/3] pinctrl: add exynos4210 specific driver data for samsung pinctrl driver
Date: Thu, 24 May 2012 05:17:36 +0530
Message-Id: <1337816857-14694-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
References: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information about the Exynos4210 pin banks, SoC specific configuration
callbacks and driver data which is used by the Samsung pinctrl driver.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/pinctrl/Kconfig           |    7 ++
 drivers/pinctrl/Makefile          |    1 +
 drivers/pinctrl/pinctrl-exynos4.c |  211 +++++++++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-exynos4.c

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index a6198c1..5acb90e 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -131,6 +131,13 @@ config PINCTRL_SAMSUNG
 	bool "Samsung pinctrl driver"
 	depends on OF
 
+config PINCTRL_EXYNOS4
+	bool "Pinctrl driver data for Exynos4 SoC"
+	depends on ARCH_EXYNOS4 && OF
+	depends on PINCTRL_SAMSUNG
+	select PINMUX
+	select PINCONF
+
 endmenu
 
 endif
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 35986ed..589498e 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -27,3 +27,4 @@ obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
 obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
+obj-$(CONFIG_PINCTRL_EXYNOS4)	+= pinctrl-exynos4.o
diff --git a/drivers/pinctrl/pinctrl-exynos4.c b/drivers/pinctrl/pinctrl-exynos4.c
new file mode 100644
index 0000000..ed419b2
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-exynos4.c
@@ -0,0 +1,211 @@
+/*
+ * Exynos4 specific driver data for Samsung pinctrl and gpiolib driver.
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Copyright (c) 2012 Linaro Ltd
+ *		http://www.linaro.org
+ *
+ * This file contains the Exynos4 specific driver data for the Samsung
+ * pinctrl/gpiolib interface drivers.
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
+#include "pinctrl-samsung.h"
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
+	},
+};
-- 
1.6.6.rc2

