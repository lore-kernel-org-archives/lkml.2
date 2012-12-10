Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2LJOxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:53:10 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:32999 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2LJOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:53:08 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
Date: Mon, 10 Dec 2012 15:51:59 +0100
Message-Id: <1355151119-2489-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <50C5DFCC.60203@ahsoftware.de>
References: <50C5DFCC.60203@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver makes the time from HID sensors (hubs) which are offering
such available like any other RTC does.

Currently the time can only be read. Setting the time must be done
through sending a report, which currently isn't supported by
hid-sensor-hub.

It is necessary that all values like year, month etc, are send as
8bit values (1 byte each) and all of them in 1 report. Also the
spec HUTRR39b doesn't define the range of the year field, we
tread it as 0 - 99 because that's what most RTCs I know about are
offering.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/iio/Kconfig                |    1 +
 drivers/iio/Makefile               |    1 +
 drivers/iio/time/Kconfig           |   14 ++
 drivers/iio/time/Makefile          |    5 +
 drivers/iio/time/hid-sensor-time.c |  346 ++++++++++++++++++++++++++++++++++++
 5 files changed, 367 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iio/time/Kconfig
 create mode 100644 drivers/iio/time/Makefile
 create mode 100644 drivers/iio/time/hid-sensor-time.c

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index fc937ac..78fa3ff 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -63,5 +63,6 @@ source "drivers/iio/dac/Kconfig"
 source "drivers/iio/common/Kconfig"
 source "drivers/iio/gyro/Kconfig"
 source "drivers/iio/magnetometer/Kconfig"
+source "drivers/iio/time/Kconfig"
 
 endif # IIO
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 761f2b6..6a6da31 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -19,3 +19,4 @@ obj-y += dac/
 obj-y += common/
 obj-y += gyro/
 obj-y += magnetometer/
+obj-y += time/
diff --git a/drivers/iio/time/Kconfig b/drivers/iio/time/Kconfig
new file mode 100644
index 0000000..0ca4682
--- /dev/null
+++ b/drivers/iio/time/Kconfig
@@ -0,0 +1,14 @@
+#
+# Time sensors
+#
+menu "Time sensors"
+
+config HID_SENSOR_TIME
+	depends on HID_SENSOR_HUB
+	select HID_SENSOR_IIO_COMMON
+	tristate "HID Time"
+	help
+	  Say yes here to build support for the HID SENSOR Time.
+	  This drivers makes such sensors available as RTCs.
+
+endmenu
diff --git a/drivers/iio/time/Makefile b/drivers/iio/time/Makefile
new file mode 100644
index 0000000..705fe0d
--- /dev/null
+++ b/drivers/iio/time/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for industrial I/O Time sensor driver
+#
+
+obj-$(CONFIG_HID_SENSOR_TIME) += hid-sensor-time.o
diff --git a/drivers/iio/time/hid-sensor-time.c b/drivers/iio/time/hid-sensor-time.c
new file mode 100644
index 0000000..556bac9
--- /dev/null
+++ b/drivers/iio/time/hid-sensor-time.c
@@ -0,0 +1,346 @@
+/*
+ * HID Sensor Time Driver
+ * Copyright (c) 2012, Alexander Holler.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/hid-sensor-hub.h>
+#include <linux/iio/iio.h>
+#include <linux/rtc.h>
+#include "../common/hid-sensors/hid-sensor-attributes.h"
+
+/* Format: HID-SENSOR-usage_id_in_hex */
+/* Usage ID from spec for Time: 0x2000A0 */
+#define DRIVER_NAME "HID-SENSOR-2000a0" /* must be lowercase */
+
+enum hid_time_channel {
+	CHANNEL_SCAN_INDEX_YEAR,
+	CHANNEL_SCAN_INDEX_MONTH,
+	CHANNEL_SCAN_INDEX_DAY,
+	CHANNEL_SCAN_INDEX_HOUR,
+	CHANNEL_SCAN_INDEX_MINUTE,
+	CHANNEL_SCAN_INDEX_SECOND,
+	TIME_RTC_CHANNEL_MAX,
+};
+
+struct hid_time_state {
+	struct hid_sensor_hub_callbacks callbacks;
+	struct hid_sensor_iio_common common_attributes;
+	struct hid_sensor_hub_attribute_info info[TIME_RTC_CHANNEL_MAX];
+	struct rtc_time last_time;
+	spinlock_t lock_last_time;
+	struct completion comp_last_time;
+	struct rtc_time time_buf;
+	struct rtc_device *rtc;
+};
+
+static const u32 hid_time_addresses[TIME_RTC_CHANNEL_MAX] = {
+	HID_USAGE_SENSOR_TIME_YEAR,
+	HID_USAGE_SENSOR_TIME_MONTH,
+	HID_USAGE_SENSOR_TIME_DAY,
+	HID_USAGE_SENSOR_TIME_HOUR,
+	HID_USAGE_SENSOR_TIME_MINUTE,
+	HID_USAGE_SENSOR_TIME_SECOND,
+};
+
+/* Channel definitions */
+static const struct iio_chan_spec hid_time_channels[TIME_RTC_CHANNEL_MAX] = {
+	{
+		.info_mask = IIO_CHAN_INFO_RAW,
+		.scan_index = CHANNEL_SCAN_INDEX_YEAR,
+		.extend_name = "year",
+	}, {
+		.info_mask = IIO_CHAN_INFO_RAW,
+		.scan_index = CHANNEL_SCAN_INDEX_MONTH,
+		.extend_name = "month",
+	}, {
+		.info_mask = IIO_CHAN_INFO_RAW,
+		.scan_index = CHANNEL_SCAN_INDEX_DAY,
+		.extend_name = "day",
+	}, {
+		.info_mask = IIO_CHAN_INFO_RAW,
+		.scan_index = CHANNEL_SCAN_INDEX_HOUR,
+		.extend_name = "hour",
+	}, {
+		.info_mask = IIO_CHAN_INFO_RAW,
+		.scan_index = CHANNEL_SCAN_INDEX_MINUTE,
+		.extend_name = "minute",
+	}, {
+		.info_mask = IIO_CHAN_INFO_RAW,
+		.scan_index = CHANNEL_SCAN_INDEX_SECOND,
+		.extend_name = "second",
+	}
+};
+
+static int hid_time_read_raw(struct hid_time_state *time_state,
+			      struct iio_chan_spec const *chan,
+			      int *val, int *val2,
+			      long mask)
+{
+	int report_id;
+	u32 address;
+
+	*val = 0;
+	*val2 = 0;
+	if (mask)
+		return -EINVAL;
+	report_id = time_state->info[chan->scan_index].report_id;
+	address = hid_time_addresses[chan->scan_index];
+	if (report_id >= 0) {
+		*val = sensor_hub_input_attr_get_raw_value(
+			time_state->common_attributes.hsdev,
+			HID_USAGE_SENSOR_TIME, address, report_id);
+		return IIO_VAL_INT;
+	}
+	*val = 0;
+	return -EINVAL;
+}
+
+/* Callback handler to send event after all samples are received and captured */
+static int hid_time_proc_event(struct hid_sensor_hub_device *hsdev,
+				unsigned usage_id, void *priv)
+{
+	unsigned long flags;
+	struct hid_time_state *time_state = platform_get_drvdata(priv);
+
+	spin_lock_irqsave(&time_state->lock_last_time, flags);
+	time_state->last_time = time_state->time_buf;
+	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
+	complete(&time_state->comp_last_time);
+	return 0;
+}
+
+static int hid_time_capture_sample(struct hid_sensor_hub_device *hsdev,
+				unsigned usage_id, size_t raw_len,
+				char *raw_data, void *priv)
+{
+	struct hid_time_state *time_state = platform_get_drvdata(priv);
+	struct rtc_time *time_buf = &time_state->time_buf;
+
+	switch (usage_id) {
+	case HID_USAGE_SENSOR_TIME_YEAR:
+		time_buf->tm_year = *(u8 *)raw_data;
+		if (time_buf->tm_year < 70)
+			/* assume we are in 1970...2069 */
+			time_buf->tm_year += 100;
+		break;
+	case HID_USAGE_SENSOR_TIME_MONTH:
+		time_buf->tm_mon = --*(u8 *)raw_data;
+		break;
+	case HID_USAGE_SENSOR_TIME_DAY:
+		time_buf->tm_mday = *(u8 *)raw_data;
+		break;
+	case HID_USAGE_SENSOR_TIME_HOUR:
+		time_buf->tm_hour = *(u8 *)raw_data;
+		break;
+	case HID_USAGE_SENSOR_TIME_MINUTE:
+		time_buf->tm_min = *(u8 *)raw_data;
+		break;
+	case HID_USAGE_SENSOR_TIME_SECOND:
+		time_buf->tm_sec = *(u8 *)raw_data;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* small helper, haven't found any other way */
+static const char *attrib_name(u32 attrib_id)
+{
+	unsigned i = 0;
+	static const char unknown[] = "unknown";
+
+	for (; i < TIME_RTC_CHANNEL_MAX; ++i) {
+		if (hid_time_addresses[i] == attrib_id)
+			return hid_time_channels[i].extend_name;
+	}
+	return unknown; /* should never happen */
+}
+
+static int hid_time_parse_report(struct platform_device *pdev,
+				struct hid_sensor_hub_device *hsdev,
+				unsigned usage_id,
+				struct hid_time_state *time_state)
+{
+	int ret, i = 0;
+
+	for (; i < TIME_RTC_CHANNEL_MAX; ++i) {
+		ret = sensor_hub_input_get_attribute_info(hsdev,
+				HID_INPUT_REPORT, usage_id,
+				hid_time_addresses[i], &time_state->info[i]);
+		if (ret < 0)
+			return ret;
+	}
+	/* Check the (needed) attributes for sanity */
+	ret = time_state->info[0].report_id; /* use ret as temp. */
+	if (ret < 0) {
+		dev_err(&pdev->dev, "bad report ID!\n");
+		return -EINVAL;
+	}
+	for (i = 0; i < TIME_RTC_CHANNEL_MAX; ++i) {
+		if (time_state->info[i].report_id != ret) {
+			dev_err(&pdev->dev,
+				"not all needed attributes inside the same report!\n");
+			return -EINVAL;
+		}
+		if (time_state->info[i].size != 1) {
+			dev_err(&pdev->dev,
+				"attribute '%s' not 8 bits wide!\n",
+				attrib_name(time_state->info[i].attrib_id));
+			return -EINVAL;
+		}
+		if (time_state->info[i].units !=
+				HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED &&
+				/* allow attribute seconds with unit seconds */
+				!(time_state->info[i].attrib_id ==
+				HID_USAGE_SENSOR_TIME_SECOND &&
+				time_state->info[i].units ==
+				HID_USAGE_SENSOR_UNITS_SECOND)) {
+			dev_err(&pdev->dev,
+				"attribute '%s' hasn't a unit of type 'none'!\n",
+				attrib_name(time_state->info[i].attrib_id));
+			return -EINVAL;
+		}
+		if (time_state->info[i].unit_expo) {
+			dev_err(&pdev->dev,
+				"attribute '%s' hasn't a unit exponent of 1!\n",
+				attrib_name(time_state->info[i].attrib_id));
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int hid_rtc_read_time(struct device *dev,
+	struct rtc_time *tm)
+{
+	int val;
+	unsigned long flags;
+	struct hid_time_state *time_state =
+		platform_get_drvdata(to_platform_device(dev));
+
+	init_completion(&time_state->comp_last_time);
+	/* start a read */
+	if (hid_time_read_raw(time_state,
+			&hid_time_channels[0], &val, &val, 0) == -EINVAL) {
+		dev_err(dev, "unable to read time!\n");
+		return -EIO;
+	}
+	/* wait for all values (event) */
+	wait_for_completion_interruptible_timeout(&time_state->comp_last_time,
+							HZ*6);
+	spin_lock_irqsave(&time_state->lock_last_time, flags);
+	*tm = time_state->last_time;
+	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
+
+	return 0;
+}
+
+static const struct rtc_class_ops rtc_ops = {
+	.read_time = hid_rtc_read_time,
+};
+
+static int __devinit hid_time_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_time_state *time_state =
+		kzalloc(sizeof(struct hid_time_state), GFP_KERNEL);
+
+	if (time_state == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	platform_set_drvdata(pdev, time_state);
+
+	time_state->common_attributes.hsdev = hsdev;
+	time_state->common_attributes.pdev = pdev;
+
+	ret = hid_sensor_parse_common_attributes(hsdev,
+				HID_USAGE_SENSOR_TIME,
+				&time_state->common_attributes);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to setup common attributes!\n");
+		goto error_free_drvdata;
+	}
+
+	ret = hid_time_parse_report(pdev, hsdev, /*channels,*/
+				HID_USAGE_SENSOR_TIME, time_state);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to setup attributes!\n");
+		goto error_free_drvdata;
+	}
+
+	time_state->callbacks.send_event = hid_time_proc_event;
+	time_state->callbacks.capture_sample = hid_time_capture_sample;
+	time_state->callbacks.pdev = pdev;
+	ret = sensor_hub_register_callback(hsdev, HID_USAGE_SENSOR_TIME,
+					&time_state->callbacks);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "register callback failed!\n");
+		goto error_free_drvdata;
+	}
+
+	time_state->rtc = rtc_device_register("hid-sensor-time",
+				&pdev->dev, &rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(time_state->rtc)) {
+		ret = PTR_ERR(time_state->rtc);
+		dev_err(&pdev->dev, "rtc device register failed!\n");
+		goto error_free_drvdata;
+	}
+
+	return ret;
+
+error_free_drvdata:
+	platform_set_drvdata(pdev, NULL);
+	kfree(time_state);
+error_ret:
+	return ret;
+}
+
+static int __devinit hid_time_remove(struct platform_device *pdev)
+{
+	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_time_state *time_state = platform_get_drvdata(pdev);
+
+	if (!IS_ERR(time_state->rtc))
+		rtc_device_unregister(time_state->rtc);
+	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
+	platform_set_drvdata(pdev, NULL);
+	kfree(time_state);
+
+	return 0;
+}
+
+static struct platform_driver hid_time_platform_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= hid_time_probe,
+	.remove		= hid_time_remove,
+};
+module_platform_driver(hid_time_platform_driver);
+
+MODULE_DESCRIPTION("HID Sensor Time");
+MODULE_AUTHOR("Alexander Holler <holler@ahsoftware.de>");
+MODULE_LICENSE("GPL");
-- 
1.7.8.6

