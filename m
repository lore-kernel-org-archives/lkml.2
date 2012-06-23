Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2FWMz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:55:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45495 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032Ab2FWMz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:55:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/7] mfd: arizona: I2C bus interface
Date: Sat, 23 Jun 2012 13:55:15 +0100
Message-Id: <1340456118-22366-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20120623125446.GX4037@opensource.wolfsonmicro.com>
 <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several forthcoming Wolfson devices are based on a common platform
known as Arizona allowing a great deal of reuse of driver code. This
patch adds I2C bus interface code for the devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-i2c.c |   89 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 drivers/mfd/arizona-i2c.c

diff --git a/drivers/mfd/arizona-i2c.c b/drivers/mfd/arizona-i2c.c
new file mode 100644
index 0000000..75fb110
--- /dev/null
+++ b/drivers/mfd/arizona-i2c.c
@@ -0,0 +1,89 @@
+/*
+ * Arizona-i2c.c  --  Arizona I2C bus interface
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
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/arizona/core.h>
+
+#include "arizona.h"
+
+static __devinit int arizona_i2c_probe(struct i2c_client *i2c,
+					  const struct i2c_device_id *id)
+{
+	struct arizona *arizona;
+	const struct regmap_config *regmap_config;
+	int ret;
+
+	switch (id->driver_data) {
+	case WM5102:
+		regmap_config = &wm5102_i2c_regmap;
+		break;
+	default:
+		dev_err(&i2c->dev, "Unknown device type %ld\n",
+			id->driver_data);
+		return -EINVAL;
+	}
+
+	arizona = devm_kzalloc(&i2c->dev, sizeof(*arizona), GFP_KERNEL);
+	if (arizona == NULL)
+		return -ENOMEM;
+
+	arizona->regmap = devm_regmap_init_i2c(i2c, regmap_config);
+	if (IS_ERR(arizona->regmap)) {
+		ret = PTR_ERR(arizona->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	arizona->type = id->driver_data;
+	arizona->dev = &i2c->dev;
+	arizona->irq = i2c->irq;
+
+	return arizona_dev_init(arizona);
+}
+
+static int __devexit arizona_i2c_remove(struct i2c_client *i2c)
+{
+	struct arizona *arizona = dev_get_drvdata(&i2c->dev);
+	arizona_dev_exit(arizona);
+	return 0;
+}
+
+static const struct i2c_device_id arizona_i2c_id[] = {
+	{ "wm5102", WM5102 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, arizona_i2c_id);
+
+static struct i2c_driver arizona_i2c_driver = {
+	.driver = {
+		.name	= "arizona",
+		.owner	= THIS_MODULE,
+		.pm	= &arizona_pm_ops,
+	},
+	.probe		= arizona_i2c_probe,
+	.remove		= __devexit_p(arizona_i2c_remove),
+	.id_table	= arizona_i2c_id,
+};
+
+module_i2c_driver(arizona_i2c_driver);
+
+MODULE_DESCRIPTION("Arizona I2C bus interface");
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.10

