Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab2HWLGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:06:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49846 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566Ab2HWLGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:06:43 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
Date: Thu, 23 Aug 2012 16:20:21 +0530
Message-ID: <1345719021-22835-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for TI's ADC driver.
This is a multifunctional device.
Analog input lines are provided on which
voltage measurements can be carried out.
You can have upto 8 input lines.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/iio/adc/Kconfig              |    7 +
 drivers/iio/adc/Makefile             |    1 +
 drivers/iio/adc/ti_adc.c             |  218 ++++++++++++++++++++++++++++++++++
 drivers/mfd/ti_tscadc.c              |    6 +
 include/linux/mfd/ti_tscadc.h        |    7 +-
 include/linux/platform_data/ti_adc.h |    9 ++
 6 files changed, 247 insertions(+), 1 deletions(-)
 create mode 100644 drivers/iio/adc/ti_adc.c
 create mode 100644 include/linux/platform_data/ti_adc.h

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 8a78b4f..ad32df8 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -22,4 +22,11 @@ config AT91_ADC
 	help
 	  Say yes here to build support for Atmel AT91 ADC.
 
+config TI_ADC
+	tristate "TI's ADC driver"
+	depends on ARCH_OMAP2PLUS
+	help
+	  Say yes here to build support for Texas Instruments ADC
+	  driver which is also a MFD client.
+
 endmenu
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 52eec25..a930cee 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_AD7266) += ad7266.o
 obj-$(CONFIG_AT91_ADC) += at91_adc.o
+obj-$(CONFIG_TI_ADC) += ti_adc.o
diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c
new file mode 100644
index 0000000..a476859
--- /dev/null
+++ b/drivers/iio/adc/ti_adc.c
@@ -0,0 +1,218 @@
+/*
+ * TI ADC MFD driver
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/iio/iio.h>
+
+#include <linux/mfd/ti_tscadc.h>
+#include <linux/platform_data/ti_adc.h>
+
+struct adc_device {
+	struct ti_tscadc_dev *mfd_tscadc;
+	struct iio_dev *idev;
+	int adc_channels;
+};
+
+static unsigned int adc_readl(struct adc_device *adc, unsigned int reg)
+{
+	return readl(adc->mfd_tscadc->tscadc_base + reg);
+}
+
+static void adc_writel(struct adc_device *adc, unsigned int reg,
+					unsigned int val)
+{
+	writel(val, adc->mfd_tscadc->tscadc_base + reg);
+}
+
+static void adc_step_config(struct adc_device *adc_dev)
+{
+	unsigned int    stepconfig;
+	int i, channels = 0, steps;
+
+	steps = 16 - adc_dev->adc_channels;
+	channels = 8 - adc_dev->adc_channels;
+
+	/* Configure Step registers */
+	stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
+
+	/*
+	 * There are 16 congiurable steps availabe which are shared
+	 * between Touchscreen and ADC.
+	 * Steps backwards i.e. from 16 towards 0 are used by ADC
+	 * depending on number of input lines needed
+	 */
+
+	for (i = (steps + 1); i < 17; i++) {
+		adc_writel(adc_dev, REG_STEPCONFIG(i),
+				stepconfig | (channels << 19));
+		adc_writel(adc_dev, REG_STEPDELAY(i),
+				STEPCONFIG_OPENDLY);
+		channels++;
+	}
+	adc_writel(adc_dev, REG_SE, STPENB_STEPENB);
+}
+
+static int tiadc_channel_init(struct iio_dev *idev, struct adc_device *adc_dev)
+{
+	struct iio_chan_spec *chan_array;
+	int i, idx = 0;
+
+	idev->num_channels = adc_dev->adc_channels;
+	chan_array = kcalloc(idev->num_channels, sizeof(struct iio_chan_spec),
+					GFP_KERNEL);
+
+	if (chan_array == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < (idev->num_channels); i++) {
+		struct iio_chan_spec *chan = chan_array + idx;
+		chan->type = IIO_VOLTAGE;
+		chan->indexed = 1;
+		chan->channel = i;
+		chan->scan_type.sign = 'u';
+		chan->scan_type.realbits = 12;
+		chan->scan_type.storagebits = 32;
+		chan->scan_type.shift = 0;
+		idx++;
+	}
+
+	idev->channels = chan_array;
+	return idev->num_channels;
+}
+
+static void tiadc_channel_remove(struct iio_dev *idev)
+{
+	kfree(idev->channels);
+}
+
+static int tiadc_read_raw(struct iio_dev *idev,
+		struct iio_chan_spec const *chan,
+		int *val, int *val2, long mask)
+{
+	struct adc_device *adc_dev = iio_priv(idev);
+	int i;
+	unsigned int fifo1count, readx1;
+
+	fifo1count = adc_readl(adc_dev, REG_FIFO1CNT);
+	for (i = 0; i < fifo1count; i++) {
+		readx1 = adc_readl(adc_dev, REG_FIFO1);
+		if (i == chan->channel) {
+			readx1 = readx1 & 0xfff;
+			*val = readx1;
+		}
+	}
+	adc_writel(adc_dev, REG_SE, STPENB_STEPENB);
+	return IIO_VAL_INT;
+}
+
+static const struct iio_info tiadc_info = {
+	.read_raw = &tiadc_read_raw,
+};
+
+static int __devinit tiadc_probe(struct platform_device *pdev)
+{
+	struct iio_dev		*idev;
+	int			err;
+	struct adc_device	*adc_dev = NULL;
+	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
+	struct mfd_tscadc_board	*board_data;
+
+	board_data = (struct mfd_tscadc_board *)tscadc_dev->dev->platform_data;
+	if (!board_data) {
+		dev_err(tscadc_dev->dev, "Could not find platform data\n");
+		return -EINVAL;
+	}
+
+	idev = iio_device_alloc(sizeof(struct adc_device));
+	if (idev == NULL) {
+		dev_err(&pdev->dev, "failed to allocate iio device.\n");
+		err = -ENOMEM;
+		goto err_ret;
+	}
+	adc_dev = iio_priv(idev);
+
+	tscadc_dev->adc = adc_dev;
+	adc_dev->mfd_tscadc = tscadc_dev;
+	adc_dev->idev = idev;
+	adc_dev->adc_channels = board_data->adc_init->adc_channels;
+
+	idev->dev.parent = &pdev->dev;
+	idev->name = dev_name(&pdev->dev);
+	idev->modes = INDIO_DIRECT_MODE;
+	idev->info = &tiadc_info;
+
+	adc_step_config(adc_dev);
+
+	err = tiadc_channel_init(idev, adc_dev);
+	if (err < 0)
+		goto err_fail;
+
+	err = iio_device_register(idev);
+	if (err)
+		goto err_free_channels;
+
+	dev_info(&pdev->dev, "attached adc driver\n");
+	platform_set_drvdata(pdev, idev);
+
+	return 0;
+
+err_free_channels:
+	tiadc_channel_remove(idev);
+err_fail:
+	iio_device_unregister(idev);
+	iio_device_free(idev);
+err_ret:
+	platform_set_drvdata(pdev, NULL);
+	iio_device_free(idev);
+	return err;
+}
+
+static int __devexit tiadc_remove(struct platform_device *pdev)
+{
+	struct ti_tscadc_dev   *tscadc_dev = pdev->dev.platform_data;
+	struct adc_device	*adc_dev = tscadc_dev->adc;
+	struct iio_dev		*idev = adc_dev->idev;
+
+	iio_device_unregister(idev);
+	tiadc_channel_remove(idev);
+
+	tscadc_dev->adc = NULL;
+
+	iio_device_free(idev);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver tiadc_driver = {
+	.driver = {
+		.name   = "tiadc",
+		.owner = THIS_MODULE,
+	},
+	.probe	= tiadc_probe,
+	.remove	= __devexit_p(tiadc_remove),
+};
+
+module_platform_driver(tiadc_driver);
+
+MODULE_DESCRIPTION("TI ADC controller driver");
+MODULE_AUTHOR("Rachna Patil <rachna@ti.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/ti_tscadc.c b/drivers/mfd/ti_tscadc.c
index 4fe8a9a..bf2d488 100644
--- a/drivers/mfd/ti_tscadc.c
+++ b/drivers/mfd/ti_tscadc.c
@@ -138,6 +138,12 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	cell->platform_data = tscadc;
 	cell->pdata_size = sizeof(*tscadc);
 
+	/* ADC Cell */
+	cell = &tscadc->cells[ADC_CELL];
+	cell->name = "tiadc";
+	cell->platform_data = tscadc;
+	cell->pdata_size = sizeof(*tscadc);
+
 	err = mfd_add_devices(&pdev->dev, pdev->id, tscadc->cells,
 			TSCADC_CELLS, NULL, 0);
 	if (err < 0)
diff --git a/include/linux/mfd/ti_tscadc.h b/include/linux/mfd/ti_tscadc.h
index 74f07e7..ab51511 100644
--- a/include/linux/mfd/ti_tscadc.h
+++ b/include/linux/mfd/ti_tscadc.h
@@ -118,14 +118,16 @@
 #define ADC_CLK			3000000
 #define	MAX_CLK_DIV		7
 
-#define TSCADC_CELLS		1
+#define TSCADC_CELLS		2
 
 enum tscadc_cells {
 	TSC_CELL,
+	ADC_CELL,
 };
 
 struct mfd_tscadc_board {
 	struct tsc_data *tsc_init;
+	struct adc_data *adc_init;
 };
 
 struct ti_tscadc_dev {
@@ -136,6 +138,9 @@ struct ti_tscadc_dev {
 
 	/* tsc device */
 	struct tscadc *tsc;
+
+	/* adc device */
+	struct adc_device *adc;
 };
 
 #endif
diff --git a/include/linux/platform_data/ti_adc.h b/include/linux/platform_data/ti_adc.h
new file mode 100644
index 0000000..2fc9a6e
--- /dev/null
+++ b/include/linux/platform_data/ti_adc.h
@@ -0,0 +1,9 @@
+/**
+ * struct adc_data	ADC Input information
+ * @adc_channels:	Number of analog inputs
+ *			available for ADC.
+ */
+
+struct adc_data {
+	int adc_channels;
+};
-- 
1.7.1

