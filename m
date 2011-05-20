Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935576Ab1ETJvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:51:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54015 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935557Ab1ETJvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:51:05 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Date: Fri, 20 May 2011 17:57:25 +0800
Message-Id: <1305885446-27404-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-mxs/devices/Makefile            |    1 +
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c |   92 +++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mxs/devices/platform-gpio-mxs.c

diff --git a/arch/arm/mach-mxs/devices/Makefile b/arch/arm/mach-mxs/devices/Makefile
index 324f282..351915c 100644
--- a/arch/arm/mach-mxs/devices/Makefile
+++ b/arch/arm/mach-mxs/devices/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_MXS_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o
 obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_I2C) += platform-mxs-i2c.o
 obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_MMC) += platform-mxs-mmc.o
 obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_PWM) += platform-mxs-pwm.o
+obj-y += platform-gpio-mxs.o
 obj-$(CONFIG_MXS_HAVE_PLATFORM_MXSFB) += platform-mxsfb.o
diff --git a/arch/arm/mach-mxs/devices/platform-gpio-mxs.c b/arch/arm/mach-mxs/devices/platform-gpio-mxs.c
new file mode 100644
index 0000000..3840d8c
--- /dev/null
+++ b/arch/arm/mach-mxs/devices/platform-gpio-mxs.c
@@ -0,0 +1,92 @@
+/*
+ * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#include <linux/compiler.h>
+#include <linux/err.h>
+#include <linux/init.h>
+
+#include <mach/mx23.h>
+#include <mach/mx28.h>
+#include <mach/devices-common.h>
+
+struct mxs_gpio_data {
+	int id;
+	resource_size_t iobase;
+	resource_size_t iosize;
+	resource_size_t irq;
+};
+
+#define mxs_gpio_data_entry_single(soc, _id)				\
+	{								\
+		.id = _id,						\
+		.iobase = soc ## _PINCTRL ## _BASE_ADDR,		\
+		.irq = soc ## _INT_GPIO ## _id,				\
+	}
+
+#define mxs_gpio_data_entry(soc, _id)					\
+	[_id] = mxs_gpio_data_entry_single(soc, _id)
+
+#ifdef CONFIG_SOC_IMX23
+const struct mxs_gpio_data mx23_gpio_data[] __initconst = {
+#define mx23_gpio_data_entry(_id)					\
+	mxs_gpio_data_entry(MX23, _id)
+	mx23_gpio_data_entry(0),
+	mx23_gpio_data_entry(1),
+	mx23_gpio_data_entry(2),
+};
+#endif
+
+#ifdef CONFIG_SOC_IMX28
+const struct mxs_gpio_data mx28_gpio_data[] __initconst = {
+#define mx28_gpio_data_entry(_id)					\
+	mxs_gpio_data_entry(MX28, _id)
+	mx28_gpio_data_entry(0),
+	mx28_gpio_data_entry(1),
+	mx28_gpio_data_entry(2),
+	mx28_gpio_data_entry(3),
+	mx28_gpio_data_entry(4),
+};
+#endif
+
+struct platform_device *__init mxs_add_gpio(
+		const struct mxs_gpio_data *data)
+{
+	struct resource res[] = {
+		{
+			.start = data->iobase,
+			.end = data->iobase + SZ_8K - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = data->irq,
+			.end = data->irq,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+
+	return mxs_add_platform_device("mxs-gpio", data->id,
+					res, ARRAY_SIZE(res), NULL, 0);
+}
+
+static int __init mxs_add_mxs_gpio(void)
+{
+	int i;
+
+#ifdef CONFIG_SOC_IMX23
+	if (cpu_is_mx23())
+		for (i = 0; i < ARRAY_SIZE(mx23_gpio_data); i++)
+			mxs_add_gpio(&mx23_gpio_data[i]);
+#endif
+
+#ifdef CONFIG_SOC_IMX28
+	if (cpu_is_mx28())
+		for (i = 0; i < ARRAY_SIZE(mx28_gpio_data); i++)
+			mxs_add_gpio(&mx28_gpio_data[i]);
+#endif
+
+	return 0;
+}
+postcore_initcall(mxs_add_mxs_gpio);
-- 
1.7.4.1

