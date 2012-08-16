Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2HPHkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:40:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42287 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2HPHkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:40:40 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH v3 3/3] iio: adc: add new lp8788 adc driver
Thread-Topic: [PATCH v3 3/3] iio: adc: add new lp8788 adc driver
Thread-Index: Ac17gk0xhpRJG5INRMuDkoeNRvmsTg==
Date: Thu, 16 Aug 2012 07:39:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEFD7E@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch v3.
(a) Delete unnecessary blank line of description
(b) Sort alphabetical order for header
(c) Replace udelay() with usleep_range()
(d) Change read_raw() in case of scale and offset
    : result can be calculated as raw * (scaleint + scalepart * 1000000) + offset.
      (scale: micro unit)
(e) Add 'const' for static constant iio_chan_spec
(f) Fix wrong size of allocating iio private data

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/adc/Kconfig      |    6 +
 drivers/iio/adc/Makefile     |    1 +
 drivers/iio/adc/lp8788_adc.c |  224 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+), 0 deletions(-)
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
index 0000000..1bd636a
--- /dev/null
+++ b/drivers/iio/adc/lp8788_adc.c
@@ -0,0 +1,224 @@
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
+#define START_ADC_CHANNEL		LPADC_VBATT_5P5
+#define END_ADC_CHANNEL			LPADC_MAX
+#define ADC_CONV_START			1
+
+struct lp8788_adc {
+	struct lp8788 *lp;
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
+	/* iio consumer: result = raw * scale + offset */
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		*val = result;
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		*val = lp8788_scale[id];
+		*val2 = 0;
+		return IIO_VAL_INT_PLUS_MICRO;
+	case IIO_CHAN_INFO_OFFSET:
+		*val = lp8788_scale[id] / 2;
+		return IIO_VAL_INT;
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
+		.scan_type = IIO_ST('u', 8, 12, 4),		\
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
+static int __devinit lp8788_adc_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	struct iio_dev *indio_dev;
+	struct iio_map *map;
+	struct lp8788_adc *adc;
+	int i, ret;
+
+	indio_dev = iio_device_alloc(sizeof(*adc));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	adc = iio_priv(indio_dev);
+	adc->lp = lp;
+	platform_set_drvdata(pdev, indio_dev);
+
+	if (lp->pdata) {
+		for (i = START_ADC_CHANNEL; i < END_ADC_CHANNEL ; i++) {
+			map = lp->pdata->adc_pdata[i];
+			ret = iio_map_array_register(indio_dev, map);
+			if (ret) {
+				dev_err(lp->dev, "iio map err: %d\n", ret);
+				goto err_iio_map_array;
+			}
+		}
+	}
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
+		goto err_iio_register;
+	}
+
+	return 0;
+
+err_iio_map_array:
+	while (--i >= START_ADC_CHANNEL) {
+		map = lp->pdata->adc_pdata[i];
+		iio_map_array_unregister(indio_dev, map);
+	}
+err_iio_register:
+	iio_device_free(indio_dev);
+	return ret;
+}
+
+static int __devexit lp8788_adc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev =  platform_get_drvdata(pdev);
+	struct lp8788_adc *adc = iio_priv(indio_dev);
+	struct lp8788 *lp = adc->lp;
+	struct iio_map *map;
+	int i;
+
+	if (lp->pdata) {
+		for (i = START_ADC_CHANNEL; i < END_ADC_CHANNEL ; i++) {
+			map = lp->pdata->adc_pdata[i];
+			iio_map_array_unregister(indio_dev, map);
+		}
+	}
+
+	iio_device_unregister(indio_dev);
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
1.7.2.5


Best Regards,
Milo


