Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1GIEvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 00:51:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58900 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751790Ab1GIEvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 00:51:06 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] regmap: Add SPI bus support
Date: Sat,  9 Jul 2011 13:50:43 +0900
Message-Id: <1310187044-13269-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We initialise at postcore_initcall() so that we are available before users
- some users such as PMICs initialise very early. We won't actually try to
use any of the bus until a device initialises a register map.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
---
 drivers/base/regmap/Makefile     |    1 +
 drivers/base/regmap/regmap-spi.c |   75 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-spi.c

diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 641c20a..74c6680 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_REGMAP) += regmap.o
 obj-$(CONFIG_I2C) += regmap-i2c.o
+obj-$(CONFIG_SPI) += regmap-spi.o
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
new file mode 100644
index 0000000..04328c7
--- /dev/null
+++ b/drivers/base/regmap/regmap-spi.c
@@ -0,0 +1,75 @@
+/*
+ * Register map access API - SPI support
+ *
+ * Copyright 2011 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+
+static int regmap_spi_write(struct device *dev, const void *data, size_t count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+
+	return spi_write(spi, data, count);
+}
+
+static int regmap_spi_gather_write(struct device *dev,
+				   const void *reg, size_t reg_len,
+				   const void *val, size_t val_len)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct spi_message m;
+	struct spi_transfer t[2];
+
+	spi_message_init(&m);
+
+	memset(&t, 0, sizeof(t));
+
+	t[0].tx_buf = reg;
+	t[0].len = reg_len;
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].tx_buf = val;
+	t[1].len = val_len;
+	spi_message_add_tail(&t[0], &m);
+
+	return spi_sync(spi, &m);
+}
+
+static int regmap_spi_read(struct device *dev,
+			   const void *reg, size_t reg_size,
+			   void *val, size_t val_size)
+{
+	struct spi_device *spi = to_spi_device(dev);
+
+	return spi_write_then_read(spi, reg, reg_size, val, val_size);
+}
+
+static struct regmap_bus regmap_spi = {
+	.type = &spi_bus_type,
+	.write = regmap_spi_write,
+	.gather_write = regmap_spi_gather_write,
+	.read = regmap_spi_read,
+	.owner = THIS_MODULE,
+	.read_flag_mask = 0x80,
+};
+
+static int __init regmap_spi_init(void)
+{
+	regmap_add_bus(&regmap_spi);
+	return 0;
+}
+postcore_initcall(regmap_spi_init);
+
+static void __exit regmap_spi_exit(void)
+{
+	regmap_del_bus(&regmap_spi);
+}
+module_exit(regmap_spi_exit);
-- 
1.7.5.4

