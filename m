Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196Ab1GOGXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:23:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51179 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964790Ab1GOGXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:23:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] regmap: Add SPI bus support
Date: Fri, 15 Jul 2011 15:23:11 +0900
Message-Id: <1310710992-24462-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
 <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We initialise at postcore_initcall() so that we are available before users
- some users such as PMICs initialise very early. We won't actually try to
use any of the bus until a device initialises a register map.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/spi/Kconfig      |    4 ++
 drivers/spi/Makefile     |    1 +
 drivers/spi/spi-regmap.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 0 deletions(-)
 create mode 100644 drivers/spi/spi-regmap.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index de35c3a..1c689a8 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -43,12 +43,16 @@ config SPI_MASTER
 #	boolean "SPI Master Support"
 	boolean
 	default SPI
+	select SPI_REGMAP if REGMAP
 	help
 	  If your system has an master-capable SPI controller (which
 	  provides the clock and chipselect), you can enable that
 	  controller and the protocol drivers for the SPI slave chips
 	  that are connected.
 
+config SPI_REGMAP
+	boolean
+
 if SPI_MASTER
 
 comment "SPI Master Controller Drivers"
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 0f8c69b..52dcf27 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -7,6 +7,7 @@ ccflags-$(CONFIG_SPI_DEBUG) := -DDEBUG
 # small core, mostly translating board-specific
 # config declarations into driver model code
 obj-$(CONFIG_SPI_MASTER)		+= spi.o
+obj-$(CONFIG_SPI_REGMAP)		+= spi-regmap.o
 
 # SPI master controller drivers (bus)
 obj-$(CONFIG_SPI_ALTERA)		+= spi_altera.o
diff --git a/drivers/spi/spi-regmap.c b/drivers/spi/spi-regmap.c
new file mode 100644
index 0000000..ea9072e
--- /dev/null
+++ b/drivers/spi/spi-regmap.c
@@ -0,0 +1,76 @@
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
+#include <linux/init.h>
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
+	spi_message_add_tail(&t[1], &m);
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

