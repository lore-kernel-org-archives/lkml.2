Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2IQJf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:35:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49904 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab2IQJf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:35:26 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v6] iio: adc: add new lp8788 adc driver
Thread-Topic: [PATCH v6] iio: adc: add new lp8788 adc driver
Thread-Index: Ac2Ut7W2YNnADDLUS6OY8QxtPFo/jw==
Date: Mon, 17 Sep 2012 09:35:10 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF510C@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: GN9m G5eH LT8i NLBL NwL9 QN/C QsNH TEFm Ulev WVHI XSau
 Z/NO k7up xheu 2MI5
 4BH5;5;agBpAGMAMgAzAEAAYwBhAG0ALgBhAGMALgB1AGsAOwBqAGkAYwAyADMAQABrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABhAHIAcwBAAG0AZQB0AGEAZgBvAG8ALgBkAGUAOwBsAGkAbgB1AHgALQBpAGkAbwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{7E3BF5BA-8462-456A-BA44-F07327DAEC8D};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Mon,
 17 Sep 2012 09:35:01
 GMT;WwBQAEEAVABDAEgAIAB2ADYAXQAgAGkAaQBvADoAIABhAGQAYwA6ACAAYQBkAGQAIABuAGUAdwAgAGwAcAA4ADcAOAA4ACAAYQBkAGMAIABkAHIAaQB2AGUAcgA=
x-cr-puzzleid: {7E3BF5BA-8462-456A-BA44-F07327DAEC8D}
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

 The LP8788 ADC has several ADC input selection and supports 12bit resolution.
 Internal operation of getting ADC is access to registers of LP8788.
 The LP8788 ADC uses exported functions for accessing these registers.
 (exported by LP8788 MFD device driver)

 This driver supports IIO_CHAN_INFO_RAW and SCALE.
 So the IIO consumer can calculate the value with raw and scale.
 The unit of scale is micro.

 (ADC Input Selection)

 Voltage: battery voltage (MAX 5.0, 5.5 and 6.0V)
          charger input voltage
          four general ADC inputs
          coin cell voltage
 Current: battery charging current
 Temperature: IC temperature

 (The IIO map for the IIO consumer)

 The ADC input is configurable in the platform side.
 Even though this platform data is not defined,
 the default IIO map is created for supporting the power supply driver.
 The battery voltage and temperature are used inside this driver.

 (History)

 Patch v6.
 (a) Fix scale value for each ADC input selection
 Voltage and current type are mili unit and temperature is degree.
 To calculate the IC temperature,
 temp = raw * scaleint + (raw * scalepart)/ 1000000, scaleint is always 0.
      = raw * 0.061050, raw: 0 ~ 4095
 Then range of IC temperature(ADC result) is 0 ~ 250'C

 (b) Reorganization of the IIO channel Spec
 Remove address, scan_type and scan_index and rollback the datasheet name.
 The reason why 'address' field is unnecessary is no relation with each channel.
 Moreover, to get the raw ADC value, the address info is not only one register
 but also several registers.
 Therefore specific function(lp8788_get_adc_result) is called rather than
 using one 'address' field.

 (c) Fix coding style
 Remove duplicated checking routine while unregistering the IIO map.
 Fix code for space and parenthesis.

 Patch v5.
 Fix default consumer name as 'lp8788-charger'.
 Add mutex for ADC read operation.
 Reorganization on lp8788_adc_read_raw().

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
 drivers/iio/adc/Kconfig      |    6 +
 drivers/iio/adc/Makefile     |    1 +
 drivers/iio/adc/lp8788_adc.c |  264 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 271 insertions(+)
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
index 0000000..a93aaf0
--- /dev/null
+++ b/drivers/iio/adc/lp8788_adc.c
@@ -0,0 +1,264 @@
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
+#include <linux/mutex.h>
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
+	struct mutex lock;
+};
+
+static const int lp8788_scale[LPADC_MAX] = {
+	[LPADC_VBATT_5P5] = 1343101,
+	[LPADC_VIN_CHG]   = 3052503,
+	[LPADC_IBATT]     = 610500,
+	[LPADC_IC_TEMP]   = 61050,
+	[LPADC_VBATT_6P0] = 1465201,
+	[LPADC_VBATT_5P0] = 1221001,
+	[LPADC_ADC1]      = 610500,
+	[LPADC_ADC2]      = 610500,
+	[LPADC_VDD]       = 1025641,
+	[LPADC_VCOIN]     = 757020,
+	[LPADC_ADC3]      = 610500,
+	[LPADC_ADC4]      = 610500,
+};
+
+static int lp8788_get_adc_result(struct lp8788_adc *adc, enum lp8788_adc_id id,
+				int *val)
+{
+	unsigned int msb;
+	unsigned int lsb;
+	unsigned int result;
+	u8 data;
+	u8 rawdata[2];
+	int size = ARRAY_SIZE(rawdata);
+	int retry = 5;
+	int ret;
+
+	data = (id << 1) | ADC_CONV_START;
+	ret = lp8788_write_byte(adc->lp, LP8788_ADC_CONF, data);
+	if (ret)
+		goto err_io;
+
+	/* retry until adc conversion is done */
+	data = 0;
+	while (retry--) {
+		usleep_range(100, 200);
+
+		ret = lp8788_read_byte(adc->lp, LP8788_ADC_DONE, &data);
+		if (ret)
+			goto err_io;
+
+		/* conversion done */
+		if (data)
+			break;
+	}
+
+	ret = lp8788_read_multi_bytes(adc->lp, LP8788_ADC_RAW, rawdata, size);
+	if (ret)
+		goto err_io;
+
+	msb = (rawdata[0] << 4) & 0x00000ff0;
+	lsb = (rawdata[1] >> 4) & 0x0000000f;
+	result = msb | lsb;
+	*val = result;
+
+	return 0;
+
+err_io:
+	return ret;
+}
+
+static int lp8788_adc_read_raw(struct iio_dev *indio_dev,
+			struct iio_chan_spec const *chan,
+			int *val, int *val2, long mask)
+{
+	struct lp8788_adc *adc = iio_priv(indio_dev);
+	enum lp8788_adc_id id = chan->channel;
+	int ret;
+
+	mutex_lock(&adc->lock);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		ret = lp8788_get_adc_result(adc, id, val) ? -EIO : IIO_VAL_INT;
+		break;
+	case IIO_CHAN_INFO_SCALE:
+		*val = lp8788_scale[id] / 1000000;
+		*val2 = lp8788_scale[id] % 1000000;
+		ret = IIO_VAL_INT_PLUS_MICRO;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&adc->lock);
+
+	return ret;
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
+	[LPADC_ADC3]      = LP8788_CHAN(ADC3, IIO_VOLTAGE),
+	[LPADC_ADC4]      = LP8788_CHAN(ADC4, IIO_VOLTAGE),
+};
+
+/* default maps used by iio consumer (lp8788-charger driver) */
+static struct iio_map lp8788_default_iio_maps[] = {
+	{
+		.consumer_dev_name = "lp8788-charger",
+		.consumer_channel = "lp8788_vbatt_5p0",
+		.adc_channel_label = "VBATT_5P0",
+	},
+	{
+		.consumer_dev_name = "lp8788-charger",
+		.consumer_channel = "lp8788_adc1",
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
+	map = (!pdata || !pdata->adc_pdata) ?
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
+static inline void lp8788_iio_map_unregister(struct iio_dev *indio_dev,
+				struct lp8788_adc *adc)
+{
+	iio_map_array_unregister(indio_dev, adc->map);
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
+	mutex_init(&adc->lock);
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
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
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


