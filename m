Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253Ab2IGIw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:52:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57294 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab2IGIwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:52:06 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] iio: adc: add new lp8788 adc driver
Thread-Topic: [PATCH v4] iio: adc: add new lp8788 adc driver
Thread-Index: Ac2M1gb62Hi0SpH1Qr+n+1nySeVPYg==
Date: Fri, 7 Sep 2012 08:51:54 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF4509@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 TI LP8788 PMU provides regulators, battery charger, ADC,
 RTC, backlight driver and current sinks.

 This patch enables the LP8788 ADC functions.

 The LP8788 ADC has 13 ADC input selection and supports 12-bit resolution.
 Internal operation of getting ADC is access to registers of LP8788.
 The LP8788 ADC uses exported functions for accessing these registers.
 (exported by LP8788 MFD device driver)

 This driver supports IIO_CHAN_INFO_RAW and SCALE.
 The scale is micro unit.
 So the IIO consumer can get the result as following.

   result = ADC raw value * (scale_int + scale_part / 1000000)


 (The IIO map for the IIO consumer)

 The ADC input can be selective in the platform side.
 Even though this platform data is not defined,
 the default IIO map is created for supporting the power supply driver.
 The battery voltage and temperature are used inside this driver.

 (History)

 Patch v4.
 Fix adc_raw function: support RAW and SCALE channel info.
 Change LP8788 ADC platform data - iio map.
 Enables the default IIO map.
 
 Patch v3.
 Fix wrong size of allocating iio private data.
 Fix coding styles.

 Patch v2.
 Support RAW and SCALE interface for IIO consumer.
 Clean up the iio channel spec macro.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/adc/Kconfig      |    6 ++
 drivers/iio/adc/Makefile     |    1 +
 drivers/iio/adc/lp8788_adc.c |  242 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+)
 create mode 100644 drivers/iio/adc/lp8788_adc.c

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 8a78b4f..30c06ed 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -22,4 +22,10 @@ config AT91_ADC
 	help
 	  Say yes here to build support for Atmel AT91 ADC.
 
+config LP8788_ADC
+	bool "LP8788 ADC driver"
+	depends on MFD_LP8788
+	help
+	  Say yes here to build support for TI LP8788 ADC.
+
 endmenu
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 52eec25..72f9a76 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_AD7266) += ad7266.o
 obj-$(CONFIG_AT91_ADC) += at91_adc.o
+obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
diff --git a/drivers/iio/adc/lp8788_adc.c b/drivers/iio/adc/lp8788_adc.c
new file mode 100644
index 0000000..33d9aaf
--- /dev/null
+++ b/drivers/iio/adc/lp8788_adc.c
@@ -0,0 +1,242 @@
+/*
+ * TI LP8788 MFD - ADC driver
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/driver.h>
+#include <linux/iio/machine.h>
+#include <linux/mfd/lp8788.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/* register address */
+#define LP8788_ADC_CONF			0x60
+#define LP8788_ADC_RAW			0x61
+#define LP8788_ADC_DONE			0x63
+
+#define ADC_CONV_START			1
+
+struct lp8788_adc {
+	struct lp8788 *lp;
+	struct iio_map *map;
+};
+
+static const int lp8788_scale[LPADC_MAX] = {
+	[LPADC_VBATT_5P5] = 1343,
+	[LPADC_VIN_CHG]   = 3052,
+	[LPADC_IBATT]     = 610,
+	[LPADC_IC_TEMP]   = 610,
+	[LPADC_VBATT_6P0] = 1465,
+	[LPADC_VBATT_5P0] = 1221,
+	[LPADC_ADC1]      = 610,
+	[LPADC_ADC2]      = 610,
+	[LPADC_VDD]       = 1025,
+	[LPADC_VCOIN]     = 757,
+	[LPADC_VDD_LDO]   = 610,
+	[LPADC_ADC3]      = 610,
+	[LPADC_ADC4]      = 610,
+};
+
+static inline int lp8788_adc_read_raw(struct iio_dev *indio_dev,
+			struct iio_chan_spec const *chan,
+			int *val, int *val2, long mask)
+{
+	struct lp8788_adc *adc = iio_priv(indio_dev);
+	int retry = 5;
+	unsigned int msb, lsb, result;
+	u8 data, rawdata[2];
+	int size = ARRAY_SIZE(rawdata);
+	enum lp8788_adc_id id = chan->channel;
+
+	data = (id << 1) | ADC_CONV_START;
+	if (lp8788_write_byte(adc->lp, LP8788_ADC_CONF, data))
+		goto err;
+
+	/* retry until adc conversion is done */
+	data = 0;
+	while (retry--) {
+		usleep_range(100, 200);
+
+		if (lp8788_read_byte(adc->lp, LP8788_ADC_DONE, &data))
+			goto err;
+
+		/* conversion done */
+		if (data)
+			break;
+	}
+
+	if (lp8788_read_multi_bytes(adc->lp, LP8788_ADC_RAW, rawdata, size))
+		goto err;
+
+	msb = (rawdata[0] << 4) & 0x00000ff0;
+	lsb = (rawdata[1] >> 4) & 0x0000000f;
+	result = msb | lsb;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		*val = result;
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		*val = (lp8788_scale[id] / 1000) * 1000;
+		*val2 = (lp8788_scale[id] % 1000) * 1000000;
+		return IIO_VAL_INT_PLUS_MICRO;
+	default:
+		break;
+	}
+
+err:
+	return -EINVAL;
+}
+
+static const struct iio_info lp8788_adc_info = {
+	.read_raw = &lp8788_adc_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+#define LP8788_CHAN(_id, _type) {				\
+		.type = _type,					\
+		.indexed = 1,					\
+		.channel = LPADC_##_id,				\
+		.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT |	\
+			IIO_CHAN_INFO_SCALE_SEPARATE_BIT,	\
+		.address = LP8788_ADC_RAW,			\
+		.scan_type = IIO_ST('u', 12, 16, 0),		\
+		.scan_index = 1,				\
+		.datasheet_name = #_id,				\
+}
+
+static const struct iio_chan_spec lp8788_adc_channels[] = {
+	[LPADC_VBATT_5P5] = LP8788_CHAN(VBATT_5P5, IIO_VOLTAGE),
+	[LPADC_VIN_CHG]   = LP8788_CHAN(VIN_CHG, IIO_VOLTAGE),
+	[LPADC_IBATT]     = LP8788_CHAN(IBATT, IIO_CURRENT),
+	[LPADC_IC_TEMP]   = LP8788_CHAN(IC_TEMP, IIO_TEMP),
+	[LPADC_VBATT_6P0] = LP8788_CHAN(VBATT_6P0, IIO_VOLTAGE),
+	[LPADC_VBATT_5P0] = LP8788_CHAN(VBATT_5P0, IIO_VOLTAGE),
+	[LPADC_ADC1]      = LP8788_CHAN(ADC1, IIO_VOLTAGE),
+	[LPADC_ADC2]      = LP8788_CHAN(ADC2, IIO_VOLTAGE),
+	[LPADC_VDD]       = LP8788_CHAN(VDD, IIO_VOLTAGE),
+	[LPADC_VCOIN]     = LP8788_CHAN(VCOIN, IIO_VOLTAGE),
+	[LPADC_VDD_LDO]   = LP8788_CHAN(VDD_LDO, IIO_VOLTAGE),
+	[LPADC_ADC3]      = LP8788_CHAN(ADC3, IIO_VOLTAGE),
+	[LPADC_ADC4]      = LP8788_CHAN(ADC4, IIO_VOLTAGE),
+};
+
+/* default maps used by iio consumer (lp8788-charger driver) */
+static struct iio_map lp8788_default_iio_maps[] = {
+	{
+		.consumer_dev_name = "lp8788-adc",
+		.consumer_channel = "vbatt-5p0",
+		.adc_channel_label = "VBATT_5P0",
+	},
+	{
+		.consumer_dev_name = "lp8788-adc",
+		.consumer_channel = "adc1",
+		.adc_channel_label = "ADC1",
+	},
+	{ }
+};
+
+static int lp8788_iio_map_register(struct iio_dev *indio_dev,
+				struct lp8788_platform_data *pdata,
+				struct lp8788_adc *adc)
+{
+	struct iio_map *map;
+	int ret;
+
+	map = !pdata || !pdata->adc_pdata ?
+		lp8788_default_iio_maps : pdata->adc_pdata;
+
+	ret = iio_map_array_register(indio_dev, map);
+	if (ret) {
+		dev_err(adc->lp->dev, "iio map err: %d\n", ret);
+		return ret;
+	}
+
+	adc->map = map;
+	return 0;
+}
+
+static void lp8788_iio_map_unregister(struct iio_dev *indio_dev,
+				struct lp8788_adc *adc)
+{
+	if (adc->map)
+		iio_map_array_unregister(indio_dev, adc->map);
+}
+
+static int __devinit lp8788_adc_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	struct iio_dev *indio_dev;
+	struct lp8788_adc *adc;
+	int ret;
+
+	indio_dev = iio_device_alloc(sizeof(*adc));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	adc = iio_priv(indio_dev);
+	adc->lp = lp;
+	platform_set_drvdata(pdev, indio_dev);
+
+	ret = lp8788_iio_map_register(indio_dev, lp->pdata, adc);
+	if (ret)
+		goto err_iio_map;
+
+	indio_dev->dev.parent = lp->dev;
+	indio_dev->name = pdev->name;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->info = &lp8788_adc_info;
+	indio_dev->channels = lp8788_adc_channels;
+	indio_dev->num_channels = ARRAY_SIZE(lp8788_adc_channels);
+
+	ret = iio_device_register(indio_dev);
+	if (ret) {
+		dev_err(lp->dev, "iio dev register err: %d\n", ret);
+		goto err_iio_device;
+	}
+
+	return 0;
+
+err_iio_device:
+	lp8788_iio_map_unregister(indio_dev, adc);
+err_iio_map:
+	iio_device_free(indio_dev);
+	return ret;
+}
+
+static int __devexit lp8788_adc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev =  platform_get_drvdata(pdev);
+	struct lp8788_adc *adc = iio_priv(indio_dev);
+
+	iio_device_unregister(indio_dev);
+	lp8788_iio_map_unregister(indio_dev, adc);
+	iio_device_free(indio_dev);
+
+	return 0;
+}
+
+static struct platform_driver lp8788_adc_driver = {
+	.probe = lp8788_adc_probe,
+	.remove = __devexit_p(lp8788_adc_remove),
+	.driver = {
+		.name = LP8788_DEV_ADC,
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(lp8788_adc_driver);
+
+MODULE_DESCRIPTION("Texas Instruments LP8788 ADC Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lp8788-adc");
-- 
1.7.9.5


Best Regards,
Milo


