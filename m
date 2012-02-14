Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab2BNLEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:04:00 -0500
Received: from skyrme.org ([193.175.80.135]:34716 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759664Ab2BNLDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:03:44 -0500
Date: 14 Feb 2012 10:34:27 +0000
Message-Id: <1329215672-15706-3-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: sameo@linux.intel.com
Cc: dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 2/7] mfd: split off mc13xxx SPI specifica from core
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1329215672-15706-1-git-send-email-oskar@scara.com>
References: <1329215672-15706-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13xxx-core.c includes handling SPI directly.
To be able to alternatively use mc13xxx with I2C,
split off SPI specific functionality into separate
file mc13xxx-spi.c, leaving mc13xxx-core.c independent
of the chosen wiring.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 drivers/mfd/Kconfig         |   12 ++-
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/mc13xxx-core.c  |  165 ++++++-----------------------------------
 drivers/mfd/mc13xxx-spi.c   |  172 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/mc13xxx.h |   13 +++-
 5 files changed, 218 insertions(+), 145 deletions(-)
 create mode 100644 drivers/mfd/mc13xxx-spi.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f147395..750b50c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -572,14 +572,18 @@ config MFD_MC13783
 	tristate
 
 config MFD_MC13XXX
-	tristate "Support Freescale MC13783 and MC13892"
-	depends on SPI_MASTER
+	tristate
 	select MFD_CORE
 	select MFD_MC13783
+
+config MFD_MC13XXX_SPI
+	tristate "Support Freescale MC13783 and MC13892 with SPI"
+	select MFD_MC13XXX
+	depends on SPI_MASTER
 	help
 	  Support for the Freescale (Atlas) PMIC and audio CODECs
-	  MC13783 and MC13892.
-	  This driver provides common support for accessing  the device,
+	  MC13783 and MC13892, wired for SPI use.
+	  This driver provides common support for accessing the device,
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b953bab..2dc66ed 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o twl6040-irq.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
+obj-$(CONFIG_MFD_MC13XXX_SPI)	+= mc13xxx-spi.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 94840c1..1102b77 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -15,7 +15,6 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/interrupt.h>
-#include <linux/spi/spi.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/mc13xxx.h>
 #include <linux/of.h>
@@ -132,29 +131,26 @@
 void mc13xxx_lock(struct mc13xxx *mc13xxx)
 {
 	if (!mutex_trylock(&mc13xxx->lock)) {
-		dev_dbg(&mc13xxx->spidev->dev, "wait for %s from %pf\n",
+		dev_dbg(mc13xxx->dev, "wait for %s from %pf\n",
 				__func__, __builtin_return_address(0));
 
 		mutex_lock(&mc13xxx->lock);
 	}
-	dev_dbg(&mc13xxx->spidev->dev, "%s from %pf\n",
+	dev_dbg(mc13xxx->dev, "%s from %pf\n",
 			__func__, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(mc13xxx_lock);
 
 void mc13xxx_unlock(struct mc13xxx *mc13xxx)
 {
-	dev_dbg(&mc13xxx->spidev->dev, "%s from %pf\n",
+	dev_dbg(mc13xxx->dev, "%s from %pf\n",
 			__func__, __builtin_return_address(0));
 	mutex_unlock(&mc13xxx->lock);
 }
 EXPORT_SYMBOL(mc13xxx_unlock);
 
-#define MC13XXX_REGOFFSET_SHIFT 25
 int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
 {
-	struct spi_transfer t;
-	struct spi_message m;
 	int ret;
 
 	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
@@ -162,66 +158,24 @@ int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
 	if (offset > MC13XXX_NUMREGS)
 		return -EINVAL;
 
-	*val = offset << MC13XXX_REGOFFSET_SHIFT;
+	ret = mc13xxx->read(mc13xxx, offset, val);
 
-	memset(&t, 0, sizeof(t));
-
-	t.tx_buf = val;
-	t.rx_buf = val;
-	t.len = sizeof(u32);
-
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-
-	ret = spi_sync(mc13xxx->spidev, &m);
-
-	/* error in message.status implies error return from spi_sync */
-	BUG_ON(!ret && m.status);
-
-	if (ret)
-		return ret;
-
-	*val &= 0xffffff;
-
-	dev_vdbg(&mc13xxx->spidev->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
-
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(mc13xxx_reg_read);
 
 int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
 {
-	u32 buf;
-	struct spi_transfer t;
-	struct spi_message m;
 	int ret;
 
 	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
 
-	dev_vdbg(&mc13xxx->spidev->dev, "[0x%02x] <- 0x%06x\n", offset, val);
-
 	if (offset > MC13XXX_NUMREGS || val > 0xffffff)
 		return -EINVAL;
 
-	buf = 1 << 31 | offset << MC13XXX_REGOFFSET_SHIFT | val;
-
-	memset(&t, 0, sizeof(t));
-
-	t.tx_buf = &buf;
-	t.rx_buf = &buf;
-	t.len = sizeof(u32);
-
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-
-	ret = spi_sync(mc13xxx->spidev, &m);
-
-	BUG_ON(!ret && m.status);
+	ret = mc13xxx->write(mc13xxx, offset, val);
 
-	if (ret)
-		return ret;
-
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(mc13xxx_reg_write);
 
@@ -427,7 +381,7 @@ static int mc13xxx_irq_handle(struct mc13xxx *mc13xxx,
 			if (handled == IRQ_HANDLED)
 				num_handled++;
 		} else {
-			dev_err(&mc13xxx->spidev->dev,
+			dev_err(mc13xxx->dev,
 					"BUG: irq %u but no handler\n",
 					baseirq + irq);
 
@@ -501,7 +455,7 @@ static int mc13xxx_identify(struct mc13xxx *mc13xxx, enum mc13xxx_id *id)
 		if (ret)
 			return ret;
 
-		dev_info(&mc13xxx->spidev->dev, "%s: rev: %d.%d, "
+		dev_info(mc13xxx->dev, "%s: rev: %d.%d, "
 				"fin: %d, fab: %d, icid: %d/%d\n",
 				mc13xxx_chipname[*id],
 				maskval(revision, MC13XXX_REVISION_REVFULL),
@@ -513,10 +467,8 @@ static int mc13xxx_identify(struct mc13xxx *mc13xxx, enum mc13xxx_id *id)
 	}
 
 	if (*id != MC13XXX_ID_INVALID) {
-		const struct spi_device_id *devid =
-			spi_get_device_id(mc13xxx->spidev);
-		if (!devid || devid->driver_data != *id)
-			dev_warn(&mc13xxx->spidev->dev, "device id doesn't "
+		if (!mc13xxx->driver_data || *mc13xxx->driver_data != *id)
+			dev_warn(mc13xxx->dev, "device id doesn't "
 					"match auto detection!\n");
 	}
 
@@ -525,13 +477,10 @@ static int mc13xxx_identify(struct mc13xxx *mc13xxx, enum mc13xxx_id *id)
 
 static const char *mc13xxx_get_chipname(struct mc13xxx *mc13xxx)
 {
-	const struct spi_device_id *devid =
-		spi_get_device_id(mc13xxx->spidev);
-
-	if (!devid)
+	if (!mc13xxx->driver_data)
 		return NULL;
 
-	return mc13xxx_chipname[devid->driver_data];
+	return mc13xxx_chipname[*mc13xxx->driver_data];
 }
 
 int mc13xxx_get_flags(struct mc13xxx *mc13xxx)
@@ -571,7 +520,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 	};
 	init_completion(&adcdone_data.done);
 
-	dev_dbg(&mc13xxx->spidev->dev, "%s\n", __func__);
+	dev_dbg(mc13xxx->dev, "%s\n", __func__);
 
 	mc13xxx_lock(mc13xxx);
 
@@ -613,7 +562,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 		return -EINVAL;
 	}
 
-	dev_dbg(&mc13xxx->spidev->dev, "%s: request irq\n", __func__);
+	dev_dbg(mc13xxx->dev, "%s: request irq\n", __func__);
 	mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
 			mc13xxx_handler_adcdone, __func__, &adcdone_data);
 	mc13xxx_irq_ack(mc13xxx, MC13XXX_IRQ_ADCDONE);
@@ -671,7 +620,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 	if (!cell.name)
 		return -ENOMEM;
 
-	return mfd_add_devices(&mc13xxx->spidev->dev, -1, &cell, 1, NULL, 0);
+	return mfd_add_devices(mc13xxx->dev, -1, &cell, 1, NULL, 0);
 }
 
 static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
@@ -682,7 +631,7 @@ static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
 #ifdef CONFIG_OF
 static int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
 {
-	struct device_node *np = mc13xxx->spidev->dev.of_node;
+	struct device_node *np = mc13xxx->dev.of_node;
 
 	if (!np)
 		return -ENODEV;
@@ -708,49 +657,13 @@ static inline int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
 }
 #endif
 
-static const struct spi_device_id mc13xxx_device_id[] = {
-	{
-		.name = "mc13783",
-		.driver_data = MC13XXX_ID_MC13783,
-	}, {
-		.name = "mc13892",
-		.driver_data = MC13XXX_ID_MC13892,
-	}, {
-		/* sentinel */
-	}
-};
-MODULE_DEVICE_TABLE(spi, mc13xxx_device_id);
-
-static const struct of_device_id mc13xxx_dt_ids[] = {
-	{ .compatible = "fsl,mc13783", .data = (void *) MC13XXX_ID_MC13783, },
-	{ .compatible = "fsl,mc13892", .data = (void *) MC13XXX_ID_MC13892, },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
-
-static int mc13xxx_probe(struct spi_device *spi)
+int mc13xxx_device_init(struct mc13xxx *mc13xxx)
 {
-	const struct of_device_id *of_id;
-	struct spi_driver *sdrv = to_spi_driver(spi->dev.driver);
-	struct mc13xxx *mc13xxx;
-	struct mc13xxx_platform_data *pdata = dev_get_platdata(&spi->dev);
+	struct mc13xxx_platform_data *pdata = dev_get_platdata(mc13xxx->dev);
 	enum mc13xxx_id id;
 	int ret;
 
-	of_id = of_match_device(mc13xxx_dt_ids, &spi->dev);
-	if (of_id)
-		sdrv->id_table = &mc13xxx_device_id[(enum mc13xxx_id) of_id->data];
-
-	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
-	if (!mc13xxx)
-		return -ENOMEM;
-
-	dev_set_drvdata(&spi->dev, mc13xxx);
-	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-	spi->bits_per_word = 32;
-	spi_setup(spi);
-
-	mc13xxx->spidev = spi;
+	dev_set_drvdata(mc13xxx->dev, mc13xxx);
 
 	mutex_init(&mc13xxx->lock);
 	mc13xxx_lock(mc13xxx);
@@ -768,14 +681,14 @@ static int mc13xxx_probe(struct spi_device *spi)
 	if (ret)
 		goto err_mask;
 
-	ret = request_threaded_irq(spi->irq, NULL, mc13xxx_irq_thread,
+	ret = request_threaded_irq(mc13xxx->irq, NULL, mc13xxx_irq_thread,
 			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
 
 	if (ret) {
 err_mask:
 err_revision:
 		mc13xxx_unlock(mc13xxx);
-		dev_set_drvdata(&spi->dev, NULL);
+		dev_set_drvdata(mc13xxx->dev, NULL);
 		kfree(mc13xxx);
 		return ret;
 	}
@@ -813,41 +726,13 @@ err_revision:
 	return 0;
 }
 
-static int __devexit mc13xxx_remove(struct spi_device *spi)
+void mc13xxx_device_exit(struct mc13xxx *mc13xxx)
 {
-	struct mc13xxx *mc13xxx = dev_get_drvdata(&spi->dev);
-
-	free_irq(mc13xxx->spidev->irq, mc13xxx);
-
-	mfd_remove_devices(&spi->dev);
+	free_irq(mc13xxx->irq, mc13xxx);
 
+	mfd_remove_devices(mc13xxx->dev);
 	kfree(mc13xxx);
-
-	return 0;
-}
-
-static struct spi_driver mc13xxx_driver = {
-	.id_table = mc13xxx_device_id,
-	.driver = {
-		.name = "mc13xxx",
-		.owner = THIS_MODULE,
-		.of_match_table = mc13xxx_dt_ids,
-	},
-	.probe = mc13xxx_probe,
-	.remove = __devexit_p(mc13xxx_remove),
-};
-
-static int __init mc13xxx_init(void)
-{
-	return spi_register_driver(&mc13xxx_driver);
-}
-subsys_initcall(mc13xxx_init);
-
-static void __exit mc13xxx_exit(void)
-{
-	spi_unregister_driver(&mc13xxx_driver);
 }
-module_exit(mc13xxx_exit);
 
 MODULE_DESCRIPTION("Core driver for Freescale MC13XXX PMIC");
 MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
new file mode 100644
index 0000000..37277c1
--- /dev/null
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -0,0 +1,172 @@
+/*
+ * Copyright 2009-2010 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
+ *
+ * loosely based on an earlier driver that has
+ * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+#include <linux/spi/spi.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/mc13xxx.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+
+#define MC13XXX_REGOFFSET_SHIFT 25
+static int mc13xxx_spi_read(struct mc13xxx *mc13xxx,
+			unsigned int offset, u32 *val)
+{
+	struct spi_transfer t;
+	struct spi_message m;
+	int ret;
+
+	*val = offset << MC13XXX_REGOFFSET_SHIFT;
+
+	memset(&t, 0, sizeof(t));
+
+	t.tx_buf = val;
+	t.rx_buf = val;
+	t.len = sizeof(u32);
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+
+	ret = spi_sync(mc13xxx->control.spidev, &m);
+
+	/* error in message.status implies error return from spi_sync */
+	BUG_ON(!ret && m.status);
+
+	if (ret)
+		return ret;
+
+	*val &= 0xffffff;
+
+	dev_vdbg(mc13xxx->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
+
+	return 0;
+}
+
+static int mc13xxx_spi_write(struct mc13xxx *mc13xxx,
+			unsigned int offset, u32 val)
+{
+	u32 buf;
+	struct spi_transfer t;
+	struct spi_message m;
+	int ret;
+
+	dev_vdbg(mc13xxx->dev, "[0x%02x] <- 0x%06x\n", offset, val);
+
+	buf = 1 << 31 | offset << MC13XXX_REGOFFSET_SHIFT | val;
+
+	memset(&t, 0, sizeof(t));
+
+	t.tx_buf = &buf;
+	t.rx_buf = &buf;
+	t.len = sizeof(u32);
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+
+	ret = spi_sync(mc13xxx->control.spidev, &m);
+
+	BUG_ON(!ret && m.status);
+
+	return ret;
+}
+
+static const struct spi_device_id mc13xxx_spi_device_id[] = {
+	{
+		.name = "mc13783",
+		.driver_data = MC13XXX_ID_MC13783,
+	}, {
+		.name = "mc13892",
+		.driver_data = MC13XXX_ID_MC13892,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(spi, mc13xxx_spi_device_id);
+
+static const struct of_device_id mc13xxx_dt_ids[] = {
+	{ .compatible = "fsl,mc13783", .data = (void *) MC13XXX_ID_MC13783, },
+	{ .compatible = "fsl,mc13892", .data = (void *) MC13XXX_ID_MC13892, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
+
+static int mc13xxx_spi_probe(struct spi_device *spi)
+{
+	const struct of_device_id *of_id;
+	struct spi_driver *sdrv = to_spi_driver(spi->dev.driver);
+	struct mc13xxx *mc13xxx;
+	const struct spi_device_id *devid;
+
+	of_id = of_match_device(mc13xxx_dt_ids, &spi->dev);
+	if (of_id)
+		sdrv->id_table =
+			&mc13xxx_spi_device_id[(enum mc13xxx_id) of_id->data];
+
+	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
+	if (!mc13xxx)
+		return -ENOMEM;
+
+	mc13xxx->dev = &spi->dev;
+	mc13xxx->control.spidev = spi;
+	mc13xxx->read = mc13xxx_spi_read;
+	mc13xxx->write = mc13xxx_spi_write;
+	mc13xxx->irq = spi->irq;
+
+	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
+	spi->bits_per_word = 32;
+	spi_setup(spi);
+
+	devid = spi_get_device_id(spi);
+	mc13xxx->driver_data = devid ? &devid->driver_data : NULL;
+
+	return mc13xxx_device_init(mc13xxx);
+}
+
+static int __devexit mc13xxx_spi_remove(struct spi_device *spi)
+{
+	struct mc13xxx *mc13xxx = spi_get_drvdata(spi);
+
+	mc13xxx_device_exit(mc13xxx);
+
+	return 0;
+}
+
+static struct spi_driver mc13xxx_spi_driver = {
+	.id_table = mc13xxx_spi_device_id,
+	.driver = {
+		.name = "mc13xxx",
+		.owner = THIS_MODULE,
+		.of_match_table = mc13xxx_dt_ids,
+	},
+	.probe = mc13xxx_spi_probe,
+	.remove = __devexit_p(mc13xxx_spi_remove),
+};
+
+static int __init mc13xxx_spi_init(void)
+{
+	return spi_register_driver(&mc13xxx_spi_driver);
+}
+subsys_initcall(mc13xxx_spi_init);
+
+static void __exit mc13xxx_spi_exit(void)
+{
+	spi_unregister_driver(&mc13xxx_spi_driver);
+}
+module_exit(mc13xxx_spi_exit);
+
+MODULE_DESCRIPTION("SPI support for Freescale MC13XXX PMIC");
+MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index df6654a..9929a8e 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -10,6 +10,7 @@
 #define __LINUX_MFD_MC13XXX_H
 
 #include <linux/interrupt.h>
+#include <linux/spi/spi.h>
 
 #define MC13XXX_IRQ_ADCDONE	0
 #define MC13XXX_IRQ_ADCBISDONE	1
@@ -42,15 +43,22 @@ enum mc13xxx_id {
 };
 
 struct mc13xxx {
-	struct spi_device *spidev;
+	struct device *dev;
+	union {
+		struct spi_device *spidev;
+	} control;
 	struct mutex lock;
 	int irq;
 	int flags;
 
+	int (*read)(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val);
+	int (*write)(struct mc13xxx *mc13xxx, unsigned int offset, u32 val);
+
 	irq_handler_t irqhandler[MC13XXX_NUM_IRQ];
 	void *irqdata[MC13XXX_NUM_IRQ];
 
 	int adcflags;
+	const kernel_ulong_t *driver_data;
 };
 
 void mc13xxx_lock(struct mc13xxx *mc13xxx);
@@ -80,6 +88,9 @@ int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
 int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx,
 		unsigned int mode, unsigned int channel, unsigned int *sample);
 
+int mc13xxx_device_init(struct mc13xxx *mc13xxx);
+void mc13xxx_device_exit(struct mc13xxx *mc13xxx);
+
 struct regulator_init_data;
 
 struct mc13xxx_regulator_init_data {
-- 
1.7.5.4

