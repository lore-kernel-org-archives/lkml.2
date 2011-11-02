Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab1KBOuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:50:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64630 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab1KBOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:49:38 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rdunlap@xenotime.net,
        dmitry.torokhov@gmail.com, jic23@cam.ac.uk, aghayal@codeaurora.org,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, saaguirre@ti.com,
        hemanthv@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv5 4/5] input/cma3000_d0x: Add CMA3000 spi support
Date: Wed,  2 Nov 2011 15:49:12 +0100
Message-Id: <1320245353-32125-5-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320245353-32125-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1320245353-32125-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for SPI communication.

v5: Fixes suggested by Grant Likely
	-Drop .bus line
	-Code Style
	-Use of_device_id table

v4: Add ACKs to patch

v3: Fixes suggested by Jonathan Cameron
	-Separate write/read commands
	-Do not check 1/0 mask
	-Use spi_w8r8 and spi_write_then_read functions

v2: Fixes suggested by Jonathan Cameron
	-Add filename to based on header
	-Rename set with write
	-Set spi buffers as cache aligned
	-Code Style

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/input/misc/Kconfig           |   14 +++-
 drivers/input/misc/Makefile          |    1 +
 drivers/input/misc/cma3000_d0x_spi.c |  153 ++++++++++++++++++++++++++++++++++
 3 files changed, 166 insertions(+), 2 deletions(-)
 create mode 100644 drivers/input/misc/cma3000_d0x_spi.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 56aa465..60a3fbf 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -503,8 +503,8 @@ config INPUT_CMA3000
 	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
 	  driver
 
-	  This driver currently only supports I2C interface to the
-	  controller. Also select the I2C method.
+	  This driver supports I2C and SPI interface to the
+	  controller. Also select the I2C method and/or the SPI method.
 
 	  If unsure, say N
 
@@ -521,6 +521,16 @@ config INPUT_CMA3000_I2C
 	  To compile this driver as a module, choose M here: the
 	  module will be called cma3000_d0x_i2c.
 
+config INPUT_CMA3000_SPI
+	tristate "Support SPI bus connection"
+	depends on INPUT_CMA3000 && SPI
+	help
+	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
+	  through SPI interface.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cma3000_d0x_spi.
+
 config INPUT_XEN_KBDDEV_FRONTEND
 	tristate "Xen virtual keyboard and mouse support"
 	depends on XEN_FBDEV_FRONTEND
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 62dcd79..de975c4 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_INPUT_BMA150)		+= bma150.o
 obj-$(CONFIG_INPUT_CM109)		+= cm109.o
 obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
 obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
+obj-$(CONFIG_INPUT_CMA3000_SPI)		+= cma3000_d0x_spi.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
diff --git a/drivers/input/misc/cma3000_d0x_spi.c b/drivers/input/misc/cma3000_d0x_spi.c
new file mode 100644
index 0000000..ab61861
--- /dev/null
+++ b/drivers/input/misc/cma3000_d0x_spi.c
@@ -0,0 +1,153 @@
+/*
+ * Implements SPI interface for VTI CMA300_D0x Accelerometer driver
+ *
+ * Copyright (C) 2011 Qtechnology
+ * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com.com>
+ * Based on:
+ *	drivers/input/misc/cma3000_d0x_i2c.c by Hemanth V
+ *	drivers/input/mis/adxl34x-spi.c	by Michael Hennerich
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/input/cma3000.h>
+#include "cma3000_d0x.h"
+
+static int cma3000_spi_write(struct device *dev, u8 reg, u8 val, char *msg)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	int ret;
+	u8 tmp[2];
+
+	tmp[0] = (reg << 2) | 2;
+	tmp[1] = val;
+
+	ret = spi_write_then_read(spi, tmp, sizeof(tmp), NULL, 0);
+	if (ret < 0) {
+		dev_err(dev, "%s failed (%s, %d)\n", __func__, msg, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int cma3000_spi_read(struct device *dev, u8 reg, char *msg)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	int ret;
+
+	ret = spi_w8r8(spi, reg << 2);
+	if (ret < 0)
+		dev_err(dev, "%s failed (%s, %d)\n", __func__, msg, ret);
+
+	return ret;
+}
+
+static const struct cma3000_bus_ops cma3000_spi_bops = {
+	.bustype = BUS_SPI,
+#define CMA3000_BUSSPI     (1 << 4)
+	.ctrl_mod = CMA3000_BUSSPI,
+	.read = cma3000_spi_read,
+	.write = cma3000_spi_write,
+};
+
+static int __devinit cma3000_spi_probe(struct spi_device *spi)
+{
+	struct cma3000_accl_data *data;
+
+	data = cma3000_init(&spi->dev, spi->irq, &cma3000_spi_bops);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	spi_set_drvdata(spi, data);
+
+	return 0;
+}
+
+static int __devexit cma3000_spi_remove(struct spi_device *spi)
+{
+	struct cma3000_accl_data *data = dev_get_drvdata(&spi->dev);
+
+	cma3000_exit(data);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int cma3000_spi_suspend(struct device *dev)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct cma3000_accl_data *data = dev_get_drvdata(&spi->dev);
+
+	cma3000_suspend(data);
+
+	return 0;
+}
+
+static int cma3000_spi_resume(struct device *dev)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct cma3000_accl_data *data = dev_get_drvdata(&spi->dev);
+
+	cma3000_resume(data);
+
+	return 0;
+}
+
+static const struct dev_pm_ops cma3000_spi_pm_ops = {
+	.suspend = cma3000_spi_suspend,
+	.resume = cma3000_spi_resume,
+};
+
+static SIMPLE_DEV_PM_OPS(cma3000_spi_pm, cma3000_spi_suspend,
+			 cma3000_spi_resume);
+#endif
+
+static const struct of_device_id cma3000_spi_dt_ids[] = {
+	{ .compatible = "vti,cma3000_d01", },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, cma3000_spi_dt_ids);
+
+static struct spi_driver cma3000_driver = {
+	.driver = {
+		   .name = "cma3000_d01",
+		   .owner = THIS_MODULE,
+		   .of_match_table = cma3000_spi_dt_ids,
+#ifdef CONFIG_PM
+		   .pm = &cma3000_spi_pm,
+#endif
+		   },
+	.probe = cma3000_spi_probe,
+	.remove = __devexit_p(cma3000_spi_remove),
+};
+
+static int __init cma3000_spi_init(void)
+{
+	return spi_register_driver(&cma3000_driver);
+}
+module_init(cma3000_spi_init);
+
+static void __exit cma3000_spi_exit(void)
+{
+	spi_unregister_driver(&cma3000_driver);
+}
+module_exit(cma3000_spi_exit);
+
+MODULE_DESCRIPTION("CMA3000-D0x Accelerometer SPI Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ricardo Ribalda <ricardo.ribalda@gmail.com>");
-- 
1.7.7.1

