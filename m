Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab2JLOgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:36:52 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:55042 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814Ab2JLOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:36:36 -0400
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH v2 4/4] iio: adc: add viperboard adc driver
Date: Fri, 12 Oct 2012 16:34:29 +0200
Message-Id: <1350052469-27802-4-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <20120925085559.GL28670@sortiz-mobl>
 <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This adds the mfd cell to use the adc part of the Nano River Technologies
viperboard.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/iio/adc/Kconfig          |    7 ++
 drivers/iio/adc/Makefile         |    1 +
 drivers/iio/adc/viperboard_adc.c |  185 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/viperboard.c         |    3 +
 4 files changed, 196 insertions(+)
 create mode 100644 drivers/iio/adc/viperboard_adc.c

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 4927581..35ad77d 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -60,4 +60,11 @@ config LP8788_ADC
 	help
 	  Say yes here to build support for TI LP8788 ADC.
 
+config VIPERBOARD_ADC
+	tristate "Viperboard ADC support"
+	depends on MFD_VIPERBOARD && USB
+	help
+	  Say yes here to access the ADC part of the Nano River
+	  Technologies Viperboard.
+
 endmenu
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 900995d..4852c2e 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_AD7476) += ad7476.o
 obj-$(CONFIG_AD7791) += ad7791.o
 obj-$(CONFIG_AT91_ADC) += at91_adc.o
 obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
+obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
diff --git a/drivers/iio/adc/viperboard_adc.c b/drivers/iio/adc/viperboard_adc.c
new file mode 100644
index 0000000..8ae6634
--- /dev/null
+++ b/drivers/iio/adc/viperboard_adc.c
@@ -0,0 +1,185 @@
+/*
+ *  Nano River Technologies viperboard iio ADC driver
+ *
+ *  (C) 2012 by Lemonage GmbH
+ *  Author: Lars Poeschel <poeschel@lemonage.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+
+#include <linux/usb.h>
+#include <linux/iio/iio.h>
+
+#include <linux/mfd/viperboard.h>
+
+#define VPRBRD_ADC_CMD_GET		0x00
+
+struct __packed vprbrd_adc_msg {
+	u8 cmd;
+	u8 chan;
+	u8 val;
+};
+
+struct vprbrd_adc {
+	struct vprbrd *vb;
+};
+
+#define VPRBRD_ADC_CHANNEL(_index) {			\
+	.type = IIO_VOLTAGE,				\
+	.indexed = 1,					\
+	.channel = _index,				\
+	.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,	\
+	.scan_index = _index,				\
+	.scan_type.sign = 'u',				\
+	.scan_type.realbits = 8,			\
+	.scan_type.storagebits = 8,			\
+}
+
+static struct iio_chan_spec vprbrd_adc_iio_channels[] = {
+	VPRBRD_ADC_CHANNEL(0),
+	VPRBRD_ADC_CHANNEL(1),
+	VPRBRD_ADC_CHANNEL(2),
+	VPRBRD_ADC_CHANNEL(3),
+};
+
+static int vprbrd_iio_read_raw(struct iio_dev *iio_dev,
+				struct iio_chan_spec const *chan,
+				int *val,
+				int *val2,
+				long mask)
+{
+	int ret, error = 0;
+	struct vprbrd_adc *adc = iio_priv(iio_dev);
+	struct vprbrd *vb = adc->vb;
+	struct vprbrd_adc_msg *admsg = (struct vprbrd_adc_msg *)vb->buf;
+
+	if (mask == IIO_CHAN_INFO_RAW) {
+
+		mutex_lock(&vb->lock);
+
+		admsg->cmd = VPRBRD_ADC_CMD_GET;
+		admsg->chan = chan->scan_index;
+		admsg->val = 0x00;
+
+		ret = usb_control_msg(vb->usb_dev,
+			usb_sndctrlpipe(vb->usb_dev, 0), 0xec, 0x40,
+			0x0000, 0x0000, admsg,
+			sizeof(struct vprbrd_adc_msg), 100);
+		if (ret != sizeof(struct vprbrd_adc_msg)) {
+			dev_err(&iio_dev->dev, "usb send error on adc read\n");
+			error = -EREMOTEIO;
+		}
+
+		ret = usb_control_msg(vb->usb_dev,
+			usb_rcvctrlpipe(vb->usb_dev, 0), 0xec, 0xc0,
+			0x0000, 0x0000, admsg,
+			sizeof(struct vprbrd_adc_msg), 100);
+
+		*val = admsg->val;
+
+		mutex_unlock(&vb->lock);
+
+		if (ret != sizeof(struct vprbrd_adc_msg)) {
+			dev_err(&iio_dev->dev, "usb recv error on adc read\n");
+			error = -EREMOTEIO;
+		}
+
+		if (error)
+			goto error;
+
+		return IIO_VAL_INT;
+	}
+	error =  -EINVAL;
+error:
+	return error;
+}
+
+static const struct iio_info vprbrd_adc_iio_info = {
+	.read_raw = &vprbrd_iio_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int __devinit vprbrd_adc_probe(struct platform_device *pdev)
+{
+	struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
+	struct vprbrd_adc *adc;
+	struct iio_dev *iodev;
+	int ret;
+
+	/* registering iio */
+	iodev = iio_device_alloc(sizeof(struct vprbrd_adc));
+	if (!iodev) {
+		dev_err(&pdev->dev, "failed allocating iio device\n");
+		return -ENOMEM;
+	}
+
+	adc = iio_priv(iodev);
+	adc->vb = vb;
+	iodev->name = "viperboard adc";
+	iodev->dev.parent = &pdev->dev;
+	iodev->info = &vprbrd_adc_iio_info;
+	iodev->modes = INDIO_DIRECT_MODE;
+	iodev->channels = vprbrd_adc_iio_channels;
+	iodev->num_channels = ARRAY_SIZE(vprbrd_adc_iio_channels);
+
+	ret = iio_device_register(iodev);
+	if (ret) {
+		dev_err(&pdev->dev, "could not register iio (adc)");
+		goto error;
+	}
+
+	platform_set_drvdata(pdev, iodev);
+
+	return 0;
+
+error:
+	iio_device_free(iodev);
+	return ret;
+}
+
+static int __devexit vprbrd_adc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *iodev = platform_get_drvdata(pdev);
+
+	iio_device_unregister(iodev);
+	iio_device_free(iodev);
+
+	return 0;
+}
+
+static struct platform_driver vprbrd_adc_driver = {
+	.driver.name	= "viperboard-adc",
+	.driver.owner	= THIS_MODULE,
+	.probe		= vprbrd_adc_probe,
+	.remove		= __devexit_p(vprbrd_adc_remove),
+};
+
+static int __init vprbrd_adc_init(void)
+{
+	return platform_driver_register(&vprbrd_adc_driver);
+}
+subsys_initcall(vprbrd_adc_init);
+
+static void __exit vprbrd_adc_exit(void)
+{
+	platform_driver_unregister(&vprbrd_adc_driver);
+}
+module_exit(vprbrd_adc_exit);
+
+MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
+MODULE_DESCRIPTION("IIO ADC driver for Nano River Techs Viperboard");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:viperboard-adc");
diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index a25e07e..eb1cf89 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -55,6 +55,9 @@ static struct mfd_cell vprbrd_devs[] = {
 	{
 		.name = "viperboard-i2c",
 	},
+	{
+		.name = "viperboard-adc",
+	},
 };
 
 static int vprbrd_probe(struct usb_interface *interface,
-- 
1.7.10.4

