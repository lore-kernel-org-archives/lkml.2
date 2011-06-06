Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1FFILt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:11:49 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:48001 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab1FFILr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:11:47 -0400
X-Auth-Info: /XdUkUIo2QLDeEMOBHRntu4B4t78zGJsfccUnGf5VHo=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jic23@cam.ac.uk, dzu@denx.de,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 2/2] misc/eeprom: add eeprom access driver for digsy_mtc board
Date: Mon,  6 Jun 2011 10:11:22 +0200
Message-Id: <1307347882-25301-2-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307347882-25301-1-git-send-email-agust@denx.de>
References: <1307347882-25301-1-git-send-email-agust@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both displays on digsy_mtc board obtain their configuration
from microwire EEPROMs which are connected to the SoC
over GPIO lines. We need an easy way to access the EEPROMs
to write the needed display configuration or to read out the
currently programmed configuration. The generic eeprom_93xx46
SPI driver added by previous patch allows EEPROM access over
sysfs. Using the simple driver added by this patch we provide
used GPIO interface and access control description on the board
for generic eeprom_93xx46 driver and spi_gpio driver.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/misc/eeprom/Kconfig            |   12 +++++
 drivers/misc/eeprom/Makefile           |    1 +
 drivers/misc/eeprom/digsy_mtc_eeprom.c |   85 ++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/eeprom/digsy_mtc_eeprom.c

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index 620de28..26cf12c 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -83,4 +83,16 @@ config EEPROM_93XX46
 
 	  If unsure, say N.
 
+config EEPROM_DIGSY_MTC_CFG
+	bool "DigsyMTC display configuration EEPROMs device"
+	depends on PPC_MPC5200_GPIO && GPIOLIB && SPI_GPIO
+	help
+	  This option enables access to display configuration EEPROMs
+	  on digsy_mtc board. You have to additionally select Microwire
+	  EEPROM 93XX46 driver. sysfs entries will be created for that
+	  EEPROM allowing to read/write the configuration data or to
+	  erase the whole EEPROM.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
index ec55aad..fc1e81d 100644
--- a/drivers/misc/eeprom/Makefile
+++ b/drivers/misc/eeprom/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
 obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
+obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
diff --git a/drivers/misc/eeprom/digsy_mtc_eeprom.c b/drivers/misc/eeprom/digsy_mtc_eeprom.c
new file mode 100644
index 0000000..66d9e1b
--- /dev/null
+++ b/drivers/misc/eeprom/digsy_mtc_eeprom.c
@@ -0,0 +1,85 @@
+/*
+ * EEPROMs access control driver for display configuration EEPROMs
+ * on DigsyMTC board.
+ *
+ * (C) 2011 DENX Software Engineering, Anatolij Gustschin <agust@denx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_gpio.h>
+#include <linux/eeprom_93xx46.h>
+
+#define GPIO_EEPROM_CLK		216
+#define GPIO_EEPROM_CS		210
+#define GPIO_EEPROM_DI		217
+#define GPIO_EEPROM_DO		249
+#define GPIO_EEPROM_OE		255
+#define EE_SPI_BUS_NUM	1
+
+static void digsy_mtc_op_prepare(void *p)
+{
+	/* enable */
+	gpio_set_value(GPIO_EEPROM_OE, 0);
+}
+
+static void digsy_mtc_op_finish(void *p)
+{
+	/* disable */
+	gpio_set_value(GPIO_EEPROM_OE, 1);
+}
+
+struct eeprom_93xx46_platform_data digsy_mtc_eeprom_data = {
+	.flags		= EE_ADDR8,
+	.prepare	= digsy_mtc_op_prepare,
+	.finish		= digsy_mtc_op_finish,
+};
+
+static struct spi_gpio_platform_data eeprom_spi_gpio_data = {
+	.sck		= GPIO_EEPROM_CLK,
+	.mosi		= GPIO_EEPROM_DI,
+	.miso		= GPIO_EEPROM_DO,
+	.num_chipselect	= 1,
+};
+
+static struct platform_device digsy_mtc_eeprom = {
+	.name	= "spi_gpio",
+	.id	= EE_SPI_BUS_NUM,
+	.dev	= {
+		.platform_data	= &eeprom_spi_gpio_data,
+	},
+};
+
+static struct spi_board_info digsy_mtc_eeprom_info[] __initdata = {
+	{
+		.modalias		= "93xx46",
+		.max_speed_hz		= 1000000,
+		.bus_num		= EE_SPI_BUS_NUM,
+		.chip_select		= 0,
+		.mode			= SPI_MODE_0,
+		.controller_data	= (void *)GPIO_EEPROM_CS,
+		.platform_data		= &digsy_mtc_eeprom_data,
+	},
+};
+
+static int __init digsy_mtc_eeprom_devices_init(void)
+{
+	int ret;
+
+	ret = gpio_request_one(GPIO_EEPROM_OE, GPIOF_OUT_INIT_HIGH,
+				"93xx46 EEPROMs OE");
+	if (ret) {
+		pr_err("can't request gpio %d\n", GPIO_EEPROM_OE);
+		return ret;
+	}
+	spi_register_board_info(digsy_mtc_eeprom_info,
+				ARRAY_SIZE(digsy_mtc_eeprom_info));
+	return platform_device_register(&digsy_mtc_eeprom);
+}
+device_initcall(digsy_mtc_eeprom_devices_init);
-- 
1.7.1

