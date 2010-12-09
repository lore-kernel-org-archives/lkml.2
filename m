Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0LINtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:49:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42239 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab0LINr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:47:29 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 6/9] ARM i.MX51: Add IPU device support
Date: Thu,  9 Dec 2010 14:47:18 +0100
Message-Id: <1291902441-24712-7-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-mx5/devices-imx51.h               |    4 ++
 arch/arm/plat-mxc/devices/Kconfig               |    4 ++
 arch/arm/plat-mxc/devices/Makefile              |    1 +
 arch/arm/plat-mxc/devices/platform-imx_ipuv3.c  |   47 +++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/devices-common.h |   10 +++++
 5 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-imx_ipuv3.c

diff --git a/arch/arm/mach-mx5/devices-imx51.h b/arch/arm/mach-mx5/devices-imx51.h
index 6302e46..851c114 100644
--- a/arch/arm/mach-mx5/devices-imx51.h
+++ b/arch/arm/mach-mx5/devices-imx51.h
@@ -47,3 +47,7 @@ extern const struct imx_spi_imx_data imx51_ecspi_data[] __initconst;
 extern const struct imx_imx2_wdt_data imx51_imx2_wdt_data[] __initconst;
 #define imx51_add_imx2_wdt(id, pdata)	\
 	imx_add_imx2_wdt(&imx51_imx2_wdt_data[id])
+
+extern const struct imx_ipuv3_data imx51_ipuv3_data __initconst;
+#define imx51_add_ipuv3(pdata)	\
+	imx_add_ipuv3(&imx51_ipuv3_data, pdata)
diff --git a/arch/arm/plat-mxc/devices/Kconfig b/arch/arm/plat-mxc/devices/Kconfig
index 2537166..262d9c5 100644
--- a/arch/arm/plat-mxc/devices/Kconfig
+++ b/arch/arm/plat-mxc/devices/Kconfig
@@ -71,3 +71,7 @@ config IMX_HAVE_PLATFORM_SDHCI_ESDHC_IMX
 
 config IMX_HAVE_PLATFORM_SPI_IMX
 	bool
+
+config IMX_HAVE_PLATFORM_IMX_IPUV3
+	bool
+
diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
index 75cd2ec..0a6be0a 100644
--- a/arch/arm/plat-mxc/devices/Makefile
+++ b/arch/arm/plat-mxc/devices/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_RNGA) += platform-mxc_rnga.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_W1) += platform-mxc_w1.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_SDHCI_ESDHC_IMX) += platform-sdhci-esdhc-imx.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_SPI_IMX) +=  platform-spi_imx.o
+obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_IPUV3) +=  platform-imx_ipuv3.o
diff --git a/arch/arm/plat-mxc/devices/platform-imx_ipuv3.c b/arch/arm/plat-mxc/devices/platform-imx_ipuv3.c
new file mode 100644
index 0000000..a470edb
--- /dev/null
+++ b/arch/arm/plat-mxc/devices/platform-imx_ipuv3.c
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2010 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#include <mach/hardware.h>
+#include <mach/devices-common.h>
+
+#define imx51_ipuv3_data_entry_single(soc)				\
+	{								\
+		.iobase = soc ## _IPU_CTRL_BASE_ADDR,			\
+		.irq_err = soc ## _INT_IPU_ERR,				\
+		.irq = soc ## _INT_IPU_SYN,				\
+	}
+
+#ifdef CONFIG_SOC_IMX51
+const struct imx_ipuv3_data imx51_ipuv3_data __initconst =
+	imx51_ipuv3_data_entry_single(MX51);
+#endif /* ifdef CONFIG_SOC_IMX35 */
+
+struct platform_device *__init imx_add_ipuv3(
+		const struct imx_ipuv3_data *data,
+		const struct imx_ipuv3_platform_data *pdata)
+{
+	struct resource res[] = {
+		{
+			.start = data->iobase,
+			.end = data->iobase + SZ_4K - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = data->irq_err,
+			.end = data->irq_err,
+			.flags = IORESOURCE_IRQ,
+		}, {
+			.start = data->irq,
+			.end = data->irq,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+
+	return imx_add_platform_device("imx-ipuv3", -1,
+			res, ARRAY_SIZE(res), pdata, sizeof(*pdata));
+}
+
diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
index 8658c9c..8f5197f 100644
--- a/arch/arm/plat-mxc/include/mach/devices-common.h
+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
@@ -264,3 +264,13 @@ struct imx_spi_imx_data {
 struct platform_device *__init imx_add_spi_imx(
 		const struct imx_spi_imx_data *data,
 		const struct spi_imx_master *pdata);
+
+#include <mach/ipu-v3.h>
+struct imx_ipuv3_data {
+	resource_size_t iobase;
+	resource_size_t irq_err;
+	resource_size_t irq;
+};
+struct platform_device *__init imx_add_ipuv3(
+		const struct imx_ipuv3_data *data,
+		const struct imx_ipuv3_platform_data *pdata);
-- 
1.7.2.3

