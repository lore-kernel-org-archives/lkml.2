Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1LLPK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:10:59 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:40966
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab1LLPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:10:58 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 13,
Subject: [PATCH 03/06] MFD: DA9052/53 MFD core module add SPI support v2
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <arnd@arndb.de>, <linaro-dev@lists.linaro.org>, <eric.miao@linaro.org>,
        <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 20:37:41 +0530
Message-ID: <1323702461.1626.38.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add SPI support for DA9052/53 MFD core module.

This patch is functionally tested on Samsung SMDKV6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
Changes since v1:
- Remove spi_dev from struct da9052
- Move regmap_config due to added support of regmap cache
---
 drivers/mfd/Kconfig      |   12 +++++
 drivers/mfd/Makefile     |    1 +
 drivers/mfd/da9052-spi.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/da9052-spi.c
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index baced42..c8322ee 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -332,6 +332,18 @@ config PMIC_DA9052
 	bool
 	select MFD_CORE
 
+config MFD_DA9052_SPI
+	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with SPI"
+	select REGMAP_SPI
+	select REGMAP_IRQ
+	select PMIC_DA9052
+	depends on SPI_MASTER=y
+	help
+	  Support for the Dialog Semiconductor DA9052 PMIC
+	  when controlled using SPI. This driver provides common support
+	  for accessing the device, additional drivers must be enabled in
+	  order to use the functionality of the device.
+
 config MFD_DA9052_I2C
 	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with I2C"
 	select REGMAP_I2C
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 484f209..d5f5743 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 
 obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
+obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
 
 max8925-objs			:= max8925-core.o max8925-i2c.o
diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
new file mode 100644
index 0000000..cdbc7ca
--- /dev/null
+++ b/drivers/mfd/da9052-spi.c
@@ -0,0 +1,115 @@
+/*
+ * SPI access for Dialog DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/mfd/core.h>
+#include <linux/spi/spi.h>
+#include <linux/err.h>
+
+#include <linux/mfd/da9052/da9052.h>
+
+static int da9052_spi_probe(struct spi_device *spi)
+{
+	int ret;
+	const struct spi_device_id *id = spi_get_device_id(spi);
+	struct da9052 *da9052 = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+
+	if (!da9052)
+		return -ENOMEM;
+
+	spi->mode = SPI_MODE_0 | SPI_CPOL;
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	da9052->dev = &spi->dev;
+	da9052->chip_irq = spi->irq;
+
+	dev_set_drvdata(&spi->dev, da9052);
+
+	da9052_regmap_config.read_flag_mask = 1;
+	da9052_regmap_config.write_flag_mask = 0;
+
+	da9052->regmap = regmap_init_spi(spi, &da9052_regmap_config);
+	if (IS_ERR(da9052->regmap)) {
+		ret = PTR_ERR(da9052->regmap);
+		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
+			ret);
+		goto err;
+	}
+
+	ret = da9052_device_init(da9052, id->driver_data);
+	if (ret != 0)
+		goto err;
+
+	return 0;
+
+err:
+	kfree(da9052);
+	return ret;
+}
+
+static int da9052_spi_remove(struct spi_device *spi)
+{
+	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
+
+	da9052_device_exit(da9052);
+	kfree(da9052);
+
+	return 0;
+}
+
+static struct spi_device_id da9052_spi_id[] = {
+	{"da9052", DA9052},
+	{"da9053-aa", DA9053_AA},
+	{"da9053-ba", DA9053_BA},
+	{"da9053-bb", DA9053_BB},
+	{}
+};
+
+static struct spi_driver da9052_spi_driver = {
+	.probe = da9052_spi_probe,
+	.remove = __devexit_p(da9052_spi_remove),
+	.id_table = da9052_spi_id,
+	.driver = {
+		.name = "da9052",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9052_spi_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&da9052_spi_driver);
+	if (ret != 0) {
+		pr_err("Failed to register DA9052 SPI driver, %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+subsys_initcall(da9052_spi_init);
+
+static void __exit da9052_spi_exit(void)
+{
+	spi_unregister_driver(&da9052_spi_driver);
+}
+module_exit(da9052_spi_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("SPI driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL");


