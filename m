Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0JWOLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 10:11:38 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:54162
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756115Ab0JWOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 10:11:37 -0400
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1202hzz8275bhz2dh2a8h63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 0,
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <amit.kucheria@canonical.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv7 1/3] ARM: imx: Add gpio-keys to plat-mxc
Date: Sat, 23 Oct 2010 09:12:46 -0500
Message-ID: <1287843168-18164-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add imx_add_gpio_keys function to add gpio-keys in plat-mxc

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/plat-mxc/devices/Kconfig               |    4 +++
 arch/arm/plat-mxc/devices/Makefile              |    1 +
 arch/arm/plat-mxc/devices/platform-gpio_keys.c  |   27 +++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/devices-common.h |    4 +++
 arch/arm/plat-mxc/include/mach/iomux-mx51.h     |    2 +
 5 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-gpio_keys.c

diff --git a/arch/arm/plat-mxc/devices/Kconfig b/arch/arm/plat-mxc/devices/Kconfig
index 4047994..f4772e7 100644
--- a/arch/arm/plat-mxc/devices/Kconfig
+++ b/arch/arm/plat-mxc/devices/Kconfig
@@ -9,6 +9,10 @@ config IMX_HAVE_PLATFORM_FLEXCAN
 	select HAVE_CAN_FLEXCAN
 	bool
 
+config IMX_HAVE_PLATFORM_GPIO_KEYS
+	bool
+	default y if ARCH_MX51
+	
 config IMX_HAVE_PLATFORM_IMX_I2C
 	bool
 
diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
index 0a3c1f0..45aefeb 100644
--- a/arch/arm/plat-mxc/devices/Makefile
+++ b/arch/arm/plat-mxc/devices/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_IMX_HAVE_PLATFORM_ESDHC) += platform-esdhc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_FEC) += platform-fec.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o
+obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_KEYS) += platform-gpio_keys.o
 obj-y += platform-imx-dma.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_I2C) += platform-imx-i2c.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_SSI) += platform-imx-ssi.o
diff --git a/arch/arm/plat-mxc/devices/platform-gpio_keys.c b/arch/arm/plat-mxc/devices/platform-gpio_keys.c
new file mode 100644
index 0000000..1c53a53
--- /dev/null
+++ b/arch/arm/plat-mxc/devices/platform-gpio_keys.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor,
+ * Boston, MA  02110-1301, USA.
+ */
+#include <asm/sizes.h>
+#include <mach/hardware.h>
+#include <mach/devices-common.h>
+
+struct platform_device *__init imx_add_gpio_keys(
+		const struct gpio_keys_platform_data *pdata)
+{
+	return imx_add_platform_device("gpio-keys", -1, NULL,
+		 0, pdata, sizeof(*pdata));
+}
diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
index 86d7575..8c6896f 100644
--- a/arch/arm/plat-mxc/include/mach/devices-common.h
+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
@@ -29,6 +29,10 @@ struct platform_device *__init imx_add_flexcan(int id,
 		resource_size_t irq,
 		const struct flexcan_platform_data *pdata);
 
+#include <linux/gpio_keys.h>
+struct platform_device *__init imx_add_gpio_keys(
+		const struct gpio_keys_platform_data *pdata);
+
 #include <mach/i2c.h>
 struct imx_imx_i2c_data {
 	int id;
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
index e46b1c2..d7a41e9 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
@@ -45,6 +45,8 @@ typedef enum iomux_config {
 				PAD_CTL_PKE | PAD_CTL_HYS)
 #define MX51_GPIO_PAD_CTRL		(PAD_CTL_DSE_HIGH | PAD_CTL_PKE | \
 				PAD_CTL_SRE_FAST)
+#define MX51_GPIO_PAD_CTRL_2	(PAD_CTL_SRE_FAST | PAD_CTL_DSE_HIGH | \
+					PAD_CTL_PUS_100K_UP)
 #define MX51_ECSPI_PAD_CTRL	(PAD_CTL_HYS | PAD_CTL_PKE | PAD_CTL_DSE_HIGH | \
 				PAD_CTL_SRE_FAST)
 #define MX51_SDHCI_PAD_CTRL	(PAD_CTL_DSE_HIGH | PAD_CTL_PUS_47K_UP | \
-- 
1.6.0.4


