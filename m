Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2FWMzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:55:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45501 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032Ab2FWMza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:55:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/7] mfd: arizona: SPI bus interface
Date: Sat, 23 Jun 2012 13:55:16 +0100
Message-Id: <1340456118-22366-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20120623125446.GX4037@opensource.wolfsonmicro.com>
 <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several forthcoming Wolfson devices are based on a common platform
known as Arizona allowing a great deal of reuse of driver code. This
patch adds SPI bus interface code for the devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-spi.c |   91 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 drivers/mfd/arizona-spi.c

diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
new file mode 100644
index 0000000..f4bedaf
--- /dev/null
+++ b/drivers/mfd/arizona-spi.c
@@ -0,0 +1,91 @@
+/*
+ * arizona-spi.c  --  Arizona SPI bus interface
+ *
+ * Copyright 2012 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+
+#include <linux/mfd/arizona/core.h>
+
+#include "arizona.h"
+
+static int __devinit arizona_spi_probe(struct spi_device *spi)
+{
+	const struct spi_device_id *id = spi_get_device_id(spi);
+	struct arizona *arizona;
+	const struct regmap_config *regmap_config;
+	int ret;
+
+	switch (id->driver_data) {
+#ifdef CONFIG_MFD_WM5102
+	case WM5102:
+		regmap_config = &wm5102_spi_regmap;
+		break;
+#endif
+	default:
+		dev_err(&spi->dev, "Unknown device type %ld\n",
+			id->driver_data);
+		return -EINVAL;
+	}
+
+	arizona = devm_kzalloc(&spi->dev, sizeof(*arizona), GFP_KERNEL);
+	if (arizona == NULL)
+		return -ENOMEM;
+
+	arizona->regmap = devm_regmap_init_spi(spi, regmap_config);
+	if (IS_ERR(arizona->regmap)) {
+		ret = PTR_ERR(arizona->regmap);
+		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	arizona->type = id->driver_data;
+	arizona->dev = &spi->dev;
+	arizona->irq = spi->irq;
+
+	return arizona_dev_init(arizona);
+}
+
+static int __devexit arizona_spi_remove(struct spi_device *spi)
+{
+	struct arizona *arizona = dev_get_drvdata(&spi->dev);
+	arizona_dev_exit(arizona);
+	return 0;
+}
+
+static const struct spi_device_id arizona_spi_ids[] = {
+	{ "wm5102", WM5102 },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, arizona_spi_ids);
+
+static struct spi_driver arizona_spi_driver = {
+	.driver = {
+		.name	= "arizona",
+		.owner	= THIS_MODULE,
+		.pm	= &arizona_pm_ops,
+	},
+	.probe		= arizona_spi_probe,
+	.remove		= __devexit_p(arizona_spi_remove),
+	.id_table	= arizona_spi_ids,
+};
+
+module_spi_driver(arizona_spi_driver);
+
+MODULE_DESCRIPTION("Arizona SPI bus interface");
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.10

