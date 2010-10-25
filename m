Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0JYN1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:27:51 -0400
Received: from smtp.nokia.com ([147.243.1.47]:63535 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0JYN1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:27:49 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Date: Mon, 25 Oct 2010 16:31:02 +0300
Message-Id: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides access to drive a vibrator connected
to SPI data line via Input layer's Force Feedback interface.

Client application provides samples (data streams) to be
played as CUSTOM_DATA. The samples are stored in driver's
internal buffers.

The driver is not able to mix the given samples. Instead, it
remembers the currently played sample and next one to be played.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/input/misc/Kconfig     |    5 +
 drivers/input/misc/Makefile    |    2 +-
 drivers/input/misc/vibra_spi.c |  429 ++++++++++++++++++++++++++++++++++++++++
 include/linux/spi/vibra.h      |   34 ++++
 4 files changed, 469 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/vibra_spi.c
 create mode 100644 include/linux/spi/vibra.h

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index b49e233..3441832 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -438,4 +438,9 @@ config INPUT_ADXL34X_SPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called adxl34x-spi.
 
+config INPUT_SPI_VIBRA
+	tristate "Support for SPI driven Vibra module"
+	help
+	  Support for Vibra module that is connected to OMAP SPI bus.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 19ccca7..cde272f 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -41,4 +41,4 @@ obj-$(CONFIG_INPUT_WINBOND_CIR)		+= winbond-cir.o
 obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
-
+obj-$(CONFIG_INPUT_SPI_VIBRA)          += vibra_spi.o
diff --git a/drivers/input/misc/vibra_spi.c b/drivers/input/misc/vibra_spi.c
new file mode 100644
index 0000000..551a3b8
--- /dev/null
+++ b/drivers/input/misc/vibra_spi.c
@@ -0,0 +1,429 @@
+/*
+ * This file implements a driver for SPI data driven vibrator.
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contact: Ilkka Koskinen <ilkka.koskinen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/spi/spi.h>
+#include <linux/input.h>
+#include <linux/spi/vibra.h>
+#include <linux/io.h>
+
+/* Number of effects handled with memoryless devices */
+#define VIBRA_EFFECTS		36
+#define MAX_EFFECT_SIZE		1024 /* In bytes */
+
+#define FF_EFFECT_QUEUED	0
+#define FF_EFFECT_PLAYING	1
+#define FF_EFFECT_ABORTING	2
+#define FF_EFFECT_UPLOADING	3
+
+enum vibra_status {
+	IDLE = 0,
+	STARTED,
+	PLAYING,
+	CLOSING,
+};
+
+struct effect_info {
+	char		*buf;
+	int		buflen;
+	unsigned long	flags;	/* effect state (STARTED, PLAYING, etc) */
+	unsigned long	stop_at;
+};
+
+struct vibra_data {
+	struct device		*dev;
+	struct input_dev	*input_dev;
+
+	struct workqueue_struct *workqueue;
+	struct work_struct	play_work;
+
+	struct spi_device	*spi_dev;
+	struct spi_transfer	t;
+	struct spi_message	msg;
+	u32			spi_max_speed_hz;
+
+	void (*set_power)(bool enable);
+
+	enum vibra_status	status;
+
+	struct effect_info	effects[VIBRA_EFFECTS];
+	int			next_effect;
+	int			current_effect;
+	unsigned long		stop_at;
+};
+
+static int vibra_spi_raw_write_effect(struct vibra_data *vibra)
+{
+	spi_message_init(&vibra->msg);
+	memset(&vibra->t, 0, sizeof(vibra->t));
+
+	vibra->t.tx_buf	= vibra->effects[vibra->current_effect].buf;
+	vibra->t.len	= vibra->effects[vibra->current_effect].buflen;
+	spi_message_add_tail(&vibra->t, &vibra->msg);
+
+	return spi_sync(vibra->spi_dev, &vibra->msg);
+}
+
+static void vibra_play_work(struct work_struct *work)
+{
+	struct vibra_data *vibra = container_of(work,
+						struct vibra_data, play_work);
+	struct effect_info *curr, *next;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&vibra->input_dev->event_lock, flags);
+		curr = &vibra->effects[vibra->current_effect];
+		next = &vibra->effects[vibra->next_effect];
+
+		if (vibra->status == CLOSING)
+			goto switch_off;
+
+		/* In the case of the first sample, just play it. */
+		if (vibra->status == STARTED) {
+			vibra->current_effect = vibra->next_effect;
+			vibra->status = PLAYING;
+
+			__set_bit(FF_EFFECT_PLAYING, &curr->flags);
+			spin_unlock_irqrestore(&vibra->input_dev->event_lock,
+					       flags);
+			if (vibra->set_power)
+				vibra->set_power(true);
+
+			vibra_spi_raw_write_effect(vibra);
+			clear_bit(FF_EFFECT_PLAYING, &curr->flags);
+			continue;
+
+		}
+
+		/* Shall we replay the current one? */
+		if (!test_bit(FF_EFFECT_ABORTING, &curr->flags) &&
+		    time_before(jiffies, curr->stop_at)) {
+			__set_bit(FF_EFFECT_PLAYING, &curr->flags);
+			spin_unlock_irqrestore(&vibra->input_dev->event_lock,
+					       flags);
+
+			vibra_spi_raw_write_effect(vibra);
+			clear_bit(FF_EFFECT_PLAYING, &curr->flags);
+			continue;
+		}
+
+		__clear_bit(FF_EFFECT_PLAYING, &curr->flags);
+
+		/* Or should we play the next one? */
+		if (test_bit(FF_EFFECT_QUEUED, &next->flags) &&
+		    time_before(jiffies, next->stop_at)) {
+			vibra->current_effect = vibra->next_effect;
+			__set_bit(FF_EFFECT_PLAYING, &next->flags);
+			spin_unlock_irqrestore(&vibra->input_dev->event_lock,
+					       flags);
+
+			vibra_spi_raw_write_effect(vibra);
+			clear_bit(FF_EFFECT_PLAYING, &next->flags);
+			continue;
+		}
+
+		/* Nothing to play, so switch off the power */
+
+switch_off:
+		if (vibra->set_power)
+			vibra->set_power(false);
+
+		vibra->status = IDLE;
+		spin_unlock_irqrestore(&vibra->input_dev->event_lock, flags);
+		return ;
+	}
+}
+
+/*
+ * Input/Force feedback guarantees that playback() is called with spinlock held
+ * and interrupts off.
+*/
+static int vibra_spi_playback(struct input_dev *input, int effect_id, int value)
+{
+	struct vibra_data *vibra = input_get_drvdata(input);
+	struct effect_info *einfo = &vibra->effects[effect_id];
+	struct ff_effect *ff_effect = &input->ff->effects[effect_id];
+
+	if (!vibra->workqueue)
+		return -ENODEV;
+
+	if (test_bit(FF_EFFECT_UPLOADING, &einfo->flags))
+		return -EBUSY;
+
+	if (value == 0) {
+		/* Abort the given effect */
+		if (test_bit(FF_EFFECT_PLAYING, &einfo->flags))
+			__set_bit(FF_EFFECT_ABORTING, &einfo->flags);
+
+		__clear_bit(FF_EFFECT_QUEUED, &einfo->flags);
+	} else {
+		/* Move the given effect as the next one */
+		__clear_bit(FF_EFFECT_QUEUED,
+			&vibra->effects[vibra->next_effect].flags);
+
+		vibra->next_effect = effect_id;
+		__set_bit(FF_EFFECT_QUEUED, &einfo->flags);
+		__clear_bit(FF_EFFECT_ABORTING, &einfo->flags);
+		einfo->stop_at = jiffies +
+			msecs_to_jiffies(ff_effect->replay.length);
+
+		if (vibra->status == IDLE) {
+			vibra->status = STARTED;
+			queue_work(vibra->workqueue, &vibra->play_work);
+		}
+	}
+
+	return 0;
+}
+
+static int vibra_spi_upload(struct input_dev *input, struct ff_effect *effect,
+			    struct ff_effect *old)
+{
+	struct vibra_data *vibra = input_get_drvdata(input);
+	struct effect_info *einfo = &vibra->effects[effect->id];
+	struct ff_periodic_effect *p = &effect->u.periodic;
+	int datalen, ret = 0;
+	unsigned long flags;
+
+	if (effect->type != FF_PERIODIC || p->waveform != FF_CUSTOM)
+		return -EINVAL;
+
+	spin_lock_irqsave(&vibra->input_dev->event_lock, flags);
+	if (test_bit(FF_EFFECT_QUEUED, &einfo->flags) ||
+	    test_bit(FF_EFFECT_PLAYING, &einfo->flags) ||
+	    test_bit(FF_EFFECT_UPLOADING, &einfo->flags)) {
+		spin_unlock_irqrestore(&vibra->input_dev->event_lock, flags);
+		return -EBUSY;
+
+	}
+	__set_bit(FF_EFFECT_UPLOADING, &einfo->flags);
+	spin_unlock_irqrestore(&vibra->input_dev->event_lock, flags);
+
+	datalen = p->custom_len * sizeof(p->custom_data[0]);
+	if (datalen > MAX_EFFECT_SIZE) {
+		ret = -ENOSPC;
+		goto exit;
+	}
+
+	if (einfo->buf && einfo->buflen != datalen) {
+		kfree(einfo->buf);
+		einfo->buf = NULL;
+	}
+
+	if (!einfo->buf) {
+		einfo->buf = kzalloc(datalen, GFP_KERNEL | GFP_DMA);
+		if (!einfo->buf) {
+			ret = -ENOMEM;
+			goto exit;
+		}
+	}
+
+	memcpy(einfo->buf, p->custom_data, datalen);
+	einfo->buflen = datalen;
+
+exit:
+	__clear_bit(FF_EFFECT_UPLOADING, &einfo->flags);
+	return ret;
+}
+
+static int vibra_spi_open(struct input_dev *input)
+{
+	struct vibra_data *vibra = input_get_drvdata(input);
+
+	vibra->workqueue = create_singlethread_workqueue("vibra");
+	if (!vibra->workqueue) {
+		dev_err(&input->dev, "couldn't create workqueue\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void vibra_spi_close(struct input_dev *input)
+{
+	struct vibra_data *vibra = input_get_drvdata(input);
+
+	vibra->status = CLOSING;
+
+	cancel_work_sync(&vibra->play_work);
+	destroy_workqueue(vibra->workqueue);
+	vibra->workqueue = NULL;
+
+	vibra->status = IDLE;
+}
+
+static ssize_t vibra_spi_show_spi_max_speed(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct vibra_data *vibra = dev_get_drvdata(dev);
+
+	return sprintf(buf, "spi_max_speed=%u\n", vibra->spi_max_speed_hz);
+}
+
+static DEVICE_ATTR(spi_max_speed, S_IRUGO, vibra_spi_show_spi_max_speed, NULL);
+
+static int __devinit vibra_spi_probe(struct spi_device *spi)
+{
+	struct vibra_data *vibra;
+	struct ff_device *ff;
+	struct vibra_spi_platform_data *pdata;
+	int ret = -ENOMEM;
+
+	vibra = kzalloc(sizeof(*vibra), GFP_KERNEL);
+	if (!vibra) {
+		dev_err(&spi->dev, "Not enough memory");
+		return -ENOMEM;
+	}
+
+	vibra->spi_max_speed_hz = spi->max_speed_hz;
+
+	pdata = spi->dev.platform_data;
+	if (pdata)
+		vibra->set_power = pdata->set_power;
+
+	INIT_WORK(&vibra->play_work, vibra_play_work);
+
+	vibra->dev = &spi->dev;
+	spi_set_drvdata(spi, vibra);
+	vibra->spi_dev = spi;
+
+	spi->bits_per_word = 32;
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		dev_err(&spi->dev, "spi_setup failed");
+		goto err_spi_setup;
+	}
+
+	vibra->input_dev = input_allocate_device();
+	if (!vibra->input_dev) {
+		dev_err(vibra->dev, "couldn't allocate input device\n");
+		ret = -ENOMEM;
+		goto err_input_alloc;
+	}
+
+	input_set_drvdata(vibra->input_dev, vibra);
+
+	vibra->input_dev->name		= "SPI vibrator";
+	vibra->input_dev->id.version	= 1;
+	vibra->input_dev->dev.parent	= spi->dev.parent;
+	vibra->input_dev->open		= vibra_spi_open;
+	vibra->input_dev->close		= vibra_spi_close;
+
+	set_bit(FF_PERIODIC, vibra->input_dev->ffbit);
+	set_bit(FF_CUSTOM, vibra->input_dev->ffbit);
+
+	ret = input_ff_create(vibra->input_dev, VIBRA_EFFECTS);
+	if (ret) {
+		dev_err(&spi->dev, "Couldn't create input feedback device");
+		goto err_input_ff_create;
+	}
+
+	ff		= vibra->input_dev->ff;
+	ff->private	= vibra;
+	ff->upload	= vibra_spi_upload;
+	ff->playback	= vibra_spi_playback;
+
+	ret = sysfs_create_file(&spi->dev.kobj, &dev_attr_spi_max_speed.attr);
+	if (ret) {
+		dev_err(&spi->dev, "Sysfs registration failed\n");
+		goto err_sysfs;
+	}
+
+	ret = input_register_device(vibra->input_dev);
+	if (ret < 0) {
+		dev_dbg(&spi->dev, "couldn't register input device\n");
+		goto err_input_register;
+	}
+
+	dev_dbg(&spi->dev, "SPI driven Vibra driver initialized\n");
+	return 0;
+
+err_input_register:
+	sysfs_remove_file(&spi->dev.kobj, &dev_attr_spi_max_speed.attr);
+err_sysfs:
+	input_ff_destroy(vibra->input_dev);
+err_input_ff_create:
+	input_free_device(vibra->input_dev);
+err_input_alloc:
+err_spi_setup:
+	kfree(vibra);
+	return ret;
+}
+
+static int __devexit vibra_spi_remove(struct spi_device *spi)
+{
+	struct vibra_data *vibra = dev_get_drvdata(&spi->dev);
+	int i;
+
+	for (i = 0; i < VIBRA_EFFECTS; i++)
+		kfree(vibra->effects[i].buf);
+
+	sysfs_remove_file(&spi->dev.kobj, &dev_attr_spi_max_speed.attr);
+	/* sysfs_remove_group(&spi->dev.kobj, &vibra_spi_attribute_group); */
+	input_unregister_device(vibra->input_dev);
+	kfree(vibra);
+	return 0;
+}
+
+static struct spi_driver vibra_spi_driver = {
+	.driver = {
+		.name		= "vibra_spi",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= vibra_spi_probe,
+	.remove		= __devexit_p(vibra_spi_remove),
+};
+
+static int __init vibra_spi_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&vibra_spi_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "failed to register spi driver: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void __exit vibra_spi_exit(void)
+{
+	spi_unregister_driver(&vibra_spi_driver);
+}
+
+module_init(vibra_spi_init);
+module_exit(vibra_spi_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ilkka Koskinen <ilkka.koskinen@nokia.com>");
diff --git a/include/linux/spi/vibra.h b/include/linux/spi/vibra.h
new file mode 100644
index 0000000..3c3af3e
--- /dev/null
+++ b/include/linux/spi/vibra.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contact: Ilkka Koskinen <ilkka.koskinen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef _LINUX_VIBRA_SPI_H
+#define _LINUX_VIBRA_SPI_H
+
+/**
+ * struct vibra_spi_platform_data
+ * @set_power: Called to switch on/off the power. Note that it may sleep when
+ *	switched on, but NOT when switched off
+ */
+struct vibra_spi_platform_data {
+	void (*set_power)(bool enable);
+};
+
+#endif
-- 
1.7.0.4

