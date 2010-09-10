Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0IJPt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:49:28 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:48750 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132Ab0IJPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:49:26 -0400
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 3/3] MFD: AB8500 register access via PRCMU I2C
Date: Fri, 10 Sep 2010 17:49:15 +0200
Message-ID: <1284133755-8631-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the choice of accessing the AB8500 registers
via prcmu I2C. Access either via SPI or I2C is supported.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/Kconfig      |   17 ++++++-
 drivers/mfd/Makefile     |    1 +
 drivers/mfd/ab8500-i2c.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/ab8500-spi.c |    2 +-
 4 files changed, 121 insertions(+), 4 deletions(-)
 create mode 100644 drivers/mfd/ab8500-i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index bfc80d6..16194a6 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -473,14 +473,25 @@ config EZX_PCAP
 
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
-	depends on SPI=y && GENERIC_HARDIRQS && ABX500_CORE
+	depends on GENERIC_HARDIRQS && ABX500_CORE
 	select MFD_CORE
 	help
 	  Select this option to enable access to AB8500 power management
-	  chip. This connects to U8500 on the SSP/SPI bus and exports
-	  read/write functions for the devices to get access to this chip.
+	  chip. This connects to U8500 either on the SSP/SPI bus
+	  or the I2C bus via PRCMU. It also adds the irq_chip
+	  parts for handling the Mixed Signal chip events.
 	  This chip embeds various other multimedia funtionalities as well.
 
+config AB8500_I2C_CORE
+	bool "AB8500 register access via PRCMU I2C"
+	depends on AB8500_CORE && UX500_SOC_DB8500
+	default y
+	help
+	  This enables register access to the AB8500 chip via PRCMU I2C.
+	  The AB8500 chip can be accessed via SPI or I2C. On DB8500 hardware
+	  the I2C bus is connected to the Power Reset
+	  and Mangagement Unit, PRCMU.
+
 config AB8500_DEBUG
 	bool "Enable debug info via debugfs"
 	depends on AB8500_CORE && DEBUG_FS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 610b074..9aa8a2d 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB3550_CORE)	+= ab3550-core.o
 obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-spi.o
+obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
 obj-$(CONFIG_AB8500_DEBUG)	+= ab8500-debugfs.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
diff --git a/drivers/mfd/ab8500-i2c.c b/drivers/mfd/ab8500-i2c.c
new file mode 100644
index 0000000..6820327
--- /dev/null
+++ b/drivers/mfd/ab8500-i2c.c
@@ -0,0 +1,105 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Mattias Wallin <mattias.wallin@stericsson.com> for ST-Ericsson.
+ * License Terms: GNU General Public License v2
+ * This file was based on drivers/mfd/ab8500-spi.c
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/ab8500.h>
+
+#include <mach/prcmu.h>
+
+static int ab8500_i2c_write(struct ab8500 *ab8500, u16 addr, u8 data)
+{
+	int ret;
+
+	ret = prcmu_abb_write((u8)(addr >> 8), (u8)(addr & 0xFF), &data, 1);
+	if (ret < 0)
+		dev_err(ab8500->dev, "prcmu i2c error %d\n", ret);
+	return ret;
+}
+
+static int ab8500_i2c_read(struct ab8500 *ab8500, u16 addr)
+{
+	int ret;
+	u8 data;
+
+	ret = prcmu_abb_read((u8)(addr >> 8), (u8)(addr & 0xFF), &data, 1);
+	if (ret < 0) {
+		dev_err(ab8500->dev, "prcmu i2c error %d\n", ret);
+		return ret;
+	}
+	return (int)data;
+}
+
+static int __devinit ab8500_i2c_probe(struct platform_device *plf)
+{
+	struct ab8500 *ab8500;
+	struct resource *resource;
+	int ret;
+
+	ab8500 = kzalloc(sizeof *ab8500, GFP_KERNEL);
+	if (!ab8500)
+		return -ENOMEM;
+
+	ab8500->dev = &plf->dev;
+
+	resource = platform_get_resource(plf, IORESOURCE_IRQ, 0);
+	if (!resource) {
+		kfree(ab8500);
+		return -ENODEV;
+	}
+
+	ab8500->irq = resource->start;
+
+	ab8500->read = ab8500_i2c_read;
+	ab8500->write = ab8500_i2c_write;
+
+	platform_set_drvdata(plf, ab8500);
+
+	ret = ab8500_init(ab8500);
+	if (ret)
+		kfree(ab8500);
+
+	return ret;
+}
+
+static int __devexit ab8500_i2c_remove(struct platform_device *plf)
+{
+	struct ab8500 *ab8500 = platform_get_drvdata(plf);
+
+	ab8500_exit(ab8500);
+	kfree(ab8500);
+
+	return 0;
+}
+
+static struct platform_driver ab8500_i2c_driver = {
+	.driver = {
+		.name = "ab8500-i2c",
+		.owner = THIS_MODULE,
+	},
+	.probe	= ab8500_i2c_probe,
+	.remove	= __devexit_p(ab8500_i2c_remove)
+};
+
+static int __init ab8500_i2c_init(void)
+{
+	return platform_driver_register(&ab8500_i2c_driver);
+}
+
+static void __exit ab8500_i2c_exit(void)
+{
+	platform_driver_unregister(&ab8500_i2c_driver);
+}
+subsys_initcall(ab8500_i2c_init);
+module_exit(ab8500_i2c_exit);
+
+MODULE_AUTHOR("Mattias WALLIN <mattias.wallin@stericsson.com");
+MODULE_DESCRIPTION("AB8500 Core access via PRCMU I2C");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/ab8500-spi.c b/drivers/mfd/ab8500-spi.c
index e1c8b62..9181db5 100644
--- a/drivers/mfd/ab8500-spi.c
+++ b/drivers/mfd/ab8500-spi.c
@@ -114,7 +114,7 @@ static int __devexit ab8500_spi_remove(struct spi_device *spi)
 
 static struct spi_driver ab8500_spi_driver = {
 	.driver = {
-		.name = "ab8500",
+		.name = "ab8500-spi",
 		.owner = THIS_MODULE,
 	},
 	.probe	= ab8500_spi_probe,
-- 
1.6.3.3

