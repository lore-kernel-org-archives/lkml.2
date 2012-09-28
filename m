Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2I1HkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:40:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:23843 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab2I1HkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:40:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208,223";a="215198333"
Message-ID: <1348818043.10877.326.camel@rui.sh.intel.com>
Subject: [RFC PATCH 6/6] Introduce INT33B1 I2C controller driver
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Date: Fri, 28 Sep 2012 15:40:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 817d814ecae91862f42a0447f455dae7f74cba27 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Fri, 24 Aug 2012 15:20:38 +0800
Subject: [RFC PATCH 6/6] Introduce INT33B1 I2C controller driver

This is a dummy platform device driver to illustrate my idea about
how a really I2C controller should work on ACPI 5 platforms. 
It just probes the INT33B1 I2C controller which is enumerated by ACPI.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/i2c/busses/Kconfig    |    8 +++
 drivers/i2c/busses/Makefile   |    1 +
 drivers/i2c/busses/i2c-33b1.c |  117 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-33b1.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index b4aaa1b..536a19c 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -257,6 +257,14 @@ config I2C_SCMI
 	  To compile this driver as a module, choose M here:
 	  the module will be called i2c-scmi.
 
+config I2C_33B1
+	tristate "INT33B1 I2C controller"
+	help
+	  This driver supports the ACPI enumerated INT33B1 I2C controller.
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called i2c-scmi.
+
 endif # ACPI
 
 comment "Mac SMBus host controller drivers"
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index ce3c2be..8e478bd 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -4,6 +4,7 @@
 
 # ACPI drivers
 obj-$(CONFIG_I2C_SCMI)		+= i2c-scmi.o
+obj-$(CONFIG_I2C_33B1)		+= i2c-33b1.o
 
 # PC SMBus host controller drivers
 obj-$(CONFIG_I2C_ALI1535)	+= i2c-ali1535.o
diff --git a/drivers/i2c/busses/i2c-33b1.c b/drivers/i2c/busses/i2c-33b1.c
new file mode 100644
index 0000000..152c3e4
--- /dev/null
+++ b/drivers/i2c/busses/i2c-33b1.c
@@ -0,0 +1,117 @@
+/*
+ *  i2c_33b1.c -INT33B1 i2c Controller Driver
+ *
+ *  Copyright (c) 2012 Intel Corp
+ *  Copyright (c) 2012 Zhang Rui <rui.zhang@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+
+struct int33b1_i2c_private {
+        struct i2c_adapter adap;
+        void __iomem *iobase;
+};
+
+
+static int int33b1_i2c_xfer(struct i2c_adapter *adap,
+	struct i2c_msg *msgs, int num)
+{
+	return 0;
+}
+
+static u32 int33b1_func(struct i2c_adapter *adap)
+{
+	/* Emulate SMBUS over I2C */
+	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_I2C;
+}
+
+static struct i2c_algorithm int33b1_i2c_algo = {
+	.master_xfer	= int33b1_i2c_xfer,
+	.functionality	= int33b1_func,
+};
+
+static int __devinit int33b1_i2c_probe(struct platform_device *pdev)
+{
+	struct int33b1_i2c_private  *priv;
+	struct resource *res;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->iobase = devm_request_and_ioremap(&pdev->dev, res);
+	if (!priv->iobase) {
+		dev_err(&pdev->dev, "devm_request_and_ioremap failed\n");
+		return -EBUSY;
+	}
+
+	priv->adap.dev.parent = &pdev->dev;
+	priv->adap.owner	= THIS_MODULE;
+	priv->adap.algo_data	= priv;
+	priv->adap.algo		= &int33b1_i2c_algo;
+	priv->adap.nr		= pdev->id;
+	priv->adap.class	= I2C_CLASS_HWMON;
+	snprintf(priv->adap.name, sizeof(priv->adap.name), "int33b1-i2c");
+
+	i2c_set_adapdata(&priv->adap, priv);
+	ret = i2c_add_numbered_adapter(&priv->adap);
+	if (ret < 0) {
+		dev_err(&priv->adap.dev, "Failed to add i2c bus.\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, priv);
+	dev_info(&priv->adap.dev, "Added I2C Bus.\n");
+	return 0;
+}
+
+static int __devexit int33b1_i2c_remove(struct platform_device *pdev)
+{
+	struct int33b1_i2c_private *priv;
+
+	priv = platform_get_drvdata(pdev);
+	i2c_del_adapter(&priv->adap);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver int33b1_i2c_driver = {
+	.probe  = int33b1_i2c_probe,
+	.remove = __devexit_p(int33b1_i2c_remove),
+	.driver = {
+		.name   = "int33b1-i2cbus",
+		.owner  = THIS_MODULE,
+	},
+};
+
+module_platform_driver(int33b1_i2c_driver);
+
+MODULE_AUTHOR("Zhang Rui <rui.zhang@intel.com>");
+MODULE_DESCRIPTION("INT33B1 I2C Controller driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:INT33B1");
-- 
1.7.7.6



