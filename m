Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2KSIVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:21:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2KSIVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:21:37 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: adc: Add Texas Instruments ADC081C021/027 support
Date: Mon, 19 Nov 2012 09:21:29 +0100
Message-Id: <1353313289-983-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:opXf32doBsdm9N7DGmXZjbSOadZoSLL4IYpxUqmLQRO
 g75WRygDiDjHqmvrT+kR/oDLndca/B7sl3wGI8MqOop3MUNHyC
 usIXWzW45uOZIxvc5rBgYhzgX1iCvjlWkbsMAMbAbjdF3ET3Qd
 tzI+urlCcbksK18Z8+S7pi2dCVP2jnBrFWNoTNy92dkmKoajbo
 AZv9CCaeYf3mWebjKre0el2ZDC55S+K+fOihdO4DGwuVuXVBaa
 gUHc7UyLaqfDoEtd7SYqQ2NdnH+j0L2KL5QTctAjEHWAx9luq3
 NFvH26Tz/s8Y732DCiZUgIWYqtcw9Jjh98Lf4V1DB86stQfeeQ
 qXkpwpHcU1w9ht1i2qeaIvnsv5VRSPkzctTR8Eno/bJOT1eL5k
 2pzjQrqa3kKyrpFscc3jD5DSe/JygVtTdOtJqQoYHNrpCm4B93
 lKVuq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for reading conversion results from the ADC and provide them
through a single IIO channel. A proper scaling factor is also exported
based on the reference voltage provided by a regulator.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/iio/adc/Kconfig      |  10 +++
 drivers/iio/adc/Makefile     |   1 +
 drivers/iio/adc/ti-adc081c.c | 162 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+)
 create mode 100644 drivers/iio/adc/ti-adc081c.c

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index b719f3b..e8be025 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -91,6 +91,16 @@ config MAX1363
 	  max11646, max11647) Provides direct access via sysfs and buffered
 	  data via the iio dev interface.
 
+config TI_ADC081C
+	tristate "Texas Instruments ADC081C021/027"
+	depends on I2C
+	help
+	  If you say yes here you get support for Texas Instruments ADC081C021
+	  and ADC081C027 ADC chips.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called ti-adc081c.
+
 config TI_AM335X_ADC
 	tristate "TI's ADC driver"
 	depends on MFD_TI_AM335X_TSCADC
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 19d709c..6ad20aa 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_AD7887) += ad7887.o
 obj-$(CONFIG_AT91_ADC) += at91_adc.o
 obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
 obj-$(CONFIG_MAX1363) += max1363.o
+obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
 obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
diff --git a/drivers/iio/adc/ti-adc081c.c b/drivers/iio/adc/ti-adc081c.c
new file mode 100644
index 0000000..26fb7a6
--- /dev/null
+++ b/drivers/iio/adc/ti-adc081c.c
@@ -0,0 +1,162 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+
+#include <linux/iio/iio.h>
+#include <linux/regulator/consumer.h>
+
+struct adc081c {
+	struct iio_chan_spec channel;
+	struct i2c_client *i2c;
+	struct regulator *ref;
+};
+
+#define REG_CONV_RES 0x00
+
+static int adc081c_read_raw(struct iio_dev *iio,
+			    struct iio_chan_spec const *channel, int *value,
+			    int *micro, long mask)
+{
+	struct adc081c *adc = iio_priv(iio);
+	int err, scale;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		err = i2c_smbus_read_word_swapped(adc->i2c, REG_CONV_RES);
+		if (err < 0)
+			return err;
+
+		*value = (err >> 4) & 0xff;
+		return IIO_VAL_INT;
+
+	case IIO_CHAN_INFO_SCALE:
+		err = regulator_get_voltage(adc->ref);
+		if (err < 0)
+			return err;
+
+		scale = err / 255;
+
+		*value = scale / 1000000;
+		*micro = scale % 1000000;
+
+		return IIO_VAL_INT_PLUS_MICRO;
+
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static const struct iio_info adc081c_info = {
+	.read_raw = adc081c_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int adc081c_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct iio_dev *iio;
+	struct adc081c *adc;
+	int err;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
+		return -ENODEV;
+
+	iio = iio_device_alloc(sizeof(*adc));
+	if (!iio)
+		return -ENOMEM;
+
+	adc = iio_priv(iio);
+	adc->i2c = client;
+
+	adc->ref = regulator_get(&client->dev, "vref");
+	if (IS_ERR(adc->ref)) {
+		err = PTR_ERR(adc->ref);
+		goto iio_free;
+	}
+
+	err = regulator_enable(adc->ref);
+	if (err < 0)
+		goto regulator_put;
+
+	iio->dev.parent = &client->dev;
+	iio->name = dev_name(&client->dev);
+	iio->modes = INDIO_DIRECT_MODE;
+	iio->info = &adc081c_info;
+
+	adc->channel.type = IIO_VOLTAGE;
+	adc->channel.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
+				 IIO_CHAN_INFO_RAW_SEPARATE_BIT;
+
+	iio->channels = &adc->channel;
+	iio->num_channels = 1;
+
+	err = iio_device_register(iio);
+	if (err < 0)
+		goto regulator_disable;
+
+	i2c_set_clientdata(client, iio);
+
+	return 0;
+
+regulator_disable:
+	regulator_disable(adc->ref);
+regulator_put:
+	regulator_put(adc->ref);
+iio_free:
+	iio_device_free(iio);
+
+	return err;
+}
+
+static int adc081c_remove(struct i2c_client *client)
+{
+	struct iio_dev *iio = i2c_get_clientdata(client);
+	struct adc081c *adc = iio_priv(iio);
+
+	iio_device_unregister(iio);
+	regulator_disable(adc->ref);
+	regulator_put(adc->ref);
+	iio_device_free(iio);
+
+	return 0;
+}
+
+static const struct i2c_device_id adc081c_id[] = {
+	{ "adc081c", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, adc081c_id);
+
+#ifdef CONFIG_OF
+static const struct of_device_id adc081c_of_match[] = {
+	{ .compatible = "ti,adc081c" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, adc081c_of_match);
+#endif
+
+static struct i2c_driver adc081c_driver = {
+	.driver = {
+		.name = "adc081c",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(adc081c_of_match),
+	},
+	.probe = adc081c_probe,
+	.remove = adc081c_remove,
+	.id_table = adc081c_id,
+};
+module_i2c_driver(adc081c_driver);
+
+MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
+MODULE_DESCRIPTION("Texas Instruments ADC081C021/027 driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.0

