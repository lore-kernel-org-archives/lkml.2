Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2LRTbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:31:41 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:45706 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2LRTbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:31:39 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: add ThingM blink(1) USB LED support
Date: Tue, 18 Dec 2012 14:31:08 -0500
Message-Id: <1355859068-29927-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ThingM blink(1) is an open source hardware USB RGB LED. It contains
an internal EEPROM, allowing to configure up to 12 light patterns. A
light pattern is a RGB color plus a fading time. This driver registers a
LED class instance with additional sysfs attributes to support basic
functions such as setting RGB colors, fading and playing. Other
functions are still accessible through the hidraw interface.

At this time, the only documentation for the device is the firmware
source code from ThingM, plus a few schematics. They are available at:

https://github.com/todbot/blink1

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ABI/testing/sysfs-driver-hid-blink1 |  25 ++
 MAINTAINERS                                       |   5 +
 drivers/hid/Kconfig                               |  10 +
 drivers/hid/Makefile                              |   1 +
 drivers/hid/hid-blink1.c                          | 275 ++++++++++++++++++++++
 drivers/hid/hid-core.c                            |   1 +
 drivers/hid/hid-ids.h                             |   3 +
 7 files changed, 320 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-blink1
 create mode 100644 drivers/hid/hid-blink1.c

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-blink1 b/Documentation/ABI/testing/sysfs-driver-hid-blink1
new file mode 100644
index 0000000..af3e1cd
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-blink1
@@ -0,0 +1,25 @@
+What:		/sys/class/leds/blink(1)::<serial>/rgb
+Date:		December 2012
+Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+Description:	The ThingM blink(1) is an USB RGB LED. The color notation is
+		3-byte hexadecimal. Read this attribute to get the last set
+		color. Write the 24-bit hexadecimal color to change the current
+		LED color. The default color is full white (0xFFFFFF).
+		For instance, set the color to green with:
+		echo 00FF00 > rgb
+
+What:		/sys/class/leds/blink(1)::<serial>/fade
+Date:		December 2012
+Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+Description:	This attribute allows to set a 16-bit fading time (which is a
+		multiple of 10ms) for the next color change. Read the attribute
+		to know the current fading time. The default value is set to 0
+		(no fading). For instance, set a fading of 2 seconds with:
+		echo 200 > fade
+
+What:		/sys/class/leds/blink(1)::<serial>/play
+Date:		December 2012
+Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+Description:	This attribute is used to play/pause the light patterns. Write 1
+		to start playing, 0 to stop. Reading this attribute returns the
+		current playing status.
diff --git a/MAINTAINERS b/MAINTAINERS
index 9386a63..78e1e08 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1592,6 +1592,11 @@ M:	Jan-Simon Moeller <jansimon.moeller@gmx.de>
 S:	Maintained
 F:	drivers/leds/leds-blinkm.c
 
+BLINK(1) USB RGB LED DRIVER
+M:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+S:	Maintained
+F:	drivers/hid/hid-blink1.c
+
 BLOCK LAYER
 M:	Jens Axboe <axboe@kernel.dk>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 1630150..76a15c9 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -135,6 +135,16 @@ config HID_BELKIN
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
+config HID_BLINK1
+	tristate "ThingM blink(1) USB LED"
+	depends on USB_HID
+	depends on LEDS_CLASS
+	---help---
+	Support for the ThingM blink(1) USB RGB LED. This driver registers a
+	Linux LED class instance, plus additional sysfs attributes to control
+	RGB colors, fading and playing. The device is exposed through hidraw to
+	access other functions.
+
 config HID_CHERRY
 	tristate "Cherry Cymotion keyboard" if EXPERT
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index cef68ca..f1eb590 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_HID_ACRUX)		+= hid-axff.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 obj-$(CONFIG_HID_AUREAL)        += hid-aureal.o
 obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
+obj-$(CONFIG_HID_BLINK1)	+= hid-blink1.o
 obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
diff --git a/drivers/hid/hid-blink1.c b/drivers/hid/hid-blink1.c
new file mode 100644
index 0000000..13025a8
--- /dev/null
+++ b/drivers/hid/hid-blink1.c
@@ -0,0 +1,275 @@
+/*
+ *  ThingM blink(1) USB LED Driver
+ *  Copyright (C) 2012  Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ *  This program is free software: you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation, either version 3 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/hid.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+
+#include "hid-ids.h"
+
+#define BLINK1_MSG_LENGTH	9
+
+#define blink1_rgb_to_r(rgb)	((rgb & 0xFF0000) >> 16)
+#define blink1_rgb_to_g(rgb)	((rgb & 0x00FF00) >> 8)
+#define blink1_rgb_to_b(rgb)	((rgb & 0x0000FF))
+
+struct blink1_data {
+	struct hid_device *hdev;
+	struct led_classdev led_cdev;
+	unsigned int rgb;
+	u8 brightness;
+	u16 fade;
+	bool play;
+};
+
+static void blink1_send_command(struct blink1_data *data,
+		u8 buf[BLINK1_MSG_LENGTH])
+{
+	hid_dbg(data->hdev, "command: %d%c%.2x%.2x%.2x%.2x%.2x%.2x%.2x\n",
+			buf[0], buf[1], buf[2], buf[3], buf[4],
+			buf[5], buf[6], buf[7], buf[8]);
+
+	if (data->hdev->hid_output_raw_report(data->hdev, buf,
+				BLINK1_MSG_LENGTH, HID_FEATURE_REPORT) < 0)
+		hid_err(data->hdev, "failed to send command\n");
+}
+
+static void blink1_update_color(struct blink1_data *data)
+{
+	u8 buf[BLINK1_MSG_LENGTH] = { 1, 'n', 0, 0, 0, 0, 0, 0, 0 };
+
+	if (data->brightness) {
+		unsigned int coef = DIV_ROUND_CLOSEST(255, data->brightness);
+
+		buf[2] = DIV_ROUND_CLOSEST(blink1_rgb_to_r(data->rgb), coef);
+		buf[3] = DIV_ROUND_CLOSEST(blink1_rgb_to_g(data->rgb), coef);
+		buf[4] = DIV_ROUND_CLOSEST(blink1_rgb_to_b(data->rgb), coef);
+	}
+
+	if (data->fade) {
+		buf[1] = 'c';
+		buf[5] = (data->fade & 0xFF00) >> 8;
+		buf[6] = (data->fade & 0x00FF);
+	}
+
+	blink1_send_command(data, buf);
+}
+
+static void blink1_led_set(struct led_classdev *led_cdev,
+		enum led_brightness brightness)
+{
+	struct blink1_data *data = dev_get_drvdata(led_cdev->dev->parent);
+
+	data->brightness = brightness;
+	blink1_update_color(data);
+}
+
+static enum led_brightness blink1_led_get(struct led_classdev *led_cdev)
+{
+	struct blink1_data *data = dev_get_drvdata(led_cdev->dev->parent);
+
+	return data->brightness;
+}
+
+static ssize_t blink1_show_rgb(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+
+	return sprintf(buf, "%.6X\n", data->rgb);
+}
+
+static ssize_t blink1_store_rgb(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+	long unsigned int rgb;
+	int ret;
+
+	ret = kstrtoul(buf, 16, &rgb);
+	if (ret)
+		return ret;
+
+	/* RGB value is in 24-bit hexadecimal format */
+	if (rgb > 0xFFFFFF)
+		return -EINVAL;
+
+	data->rgb = rgb;
+	blink1_update_color(data);
+
+	return count;
+}
+
+static DEVICE_ATTR(rgb, S_IRUGO | S_IWUSR, blink1_show_rgb, blink1_store_rgb);
+
+static ssize_t blink1_show_fade(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+
+	return sprintf(buf, "%d\n", data->fade);
+}
+
+static ssize_t blink1_store_fade(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+	long unsigned int fade;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &fade);
+	if (ret)
+		return ret;
+
+	/* blink(1) accepts 16-bit fade time */
+	if (fade > 65535)
+		return -EINVAL;
+
+	data->fade = fade;
+
+	return count;
+}
+
+static DEVICE_ATTR(fade, S_IRUGO | S_IWUSR,
+		blink1_show_fade, blink1_store_fade);
+
+static ssize_t blink1_show_play(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+
+	return sprintf(buf, "%d\n", data->play);
+}
+
+static ssize_t blink1_store_play(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+	u8 cmd[BLINK1_MSG_LENGTH] = { 1, 'p', 0, 0, 0, 0, 0, 0, 0 };
+	long unsigned int play;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &play);
+	if (ret)
+		return ret;
+
+	data->play = !!play;
+	cmd[2] = data->play;
+	blink1_send_command(data, cmd);
+
+	return count;
+}
+
+static DEVICE_ATTR(play, S_IRUGO | S_IWUSR,
+		blink1_show_play, blink1_store_play);
+
+static const struct attribute_group blink1_sysfs_group = {
+	.attrs = (struct attribute *[]) {
+		&dev_attr_rgb.attr,
+		&dev_attr_fade.attr,
+		&dev_attr_play.attr,
+		NULL
+	},
+};
+
+static int blink1_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	struct blink1_data *data;
+	struct led_classdev *led;
+	char led_name[15];
+	int ret;
+
+	data = devm_kzalloc(&hdev->dev, sizeof(struct blink1_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	hid_set_drvdata(hdev, data);
+	data->hdev = hdev;
+	data->rgb = 0xFFFFFF; /* set a default white color */
+
+	ret = hid_parse(hdev);
+	if (ret)
+		goto error;
+
+	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	if (ret)
+		goto error;
+
+	/* blink(1) serial numbers range is 0x1A001000 to 0x1A002FFF */
+	led = &data->led_cdev;
+	snprintf(led_name, sizeof(led_name), "blink(1)::%s", hdev->uniq + 4);
+	led->name = led_name;
+	led->brightness_set = blink1_led_set;
+	led->brightness_get = blink1_led_get;
+	ret = led_classdev_register(&hdev->dev, led);
+	if (ret)
+		goto stop;
+
+	ret = sysfs_create_group(&led->dev->kobj, &blink1_sysfs_group);
+	if (ret)
+		goto remove_led;
+
+	return 0;
+
+remove_led:
+	led_classdev_unregister(led);
+stop:
+	hid_hw_stop(hdev);
+error:
+	return ret;
+}
+
+static void blink1_remove(struct hid_device *hdev)
+{
+	struct blink1_data *data = hid_get_drvdata(hdev);
+	struct led_classdev *led = &data->led_cdev;
+
+	sysfs_remove_group(&led->dev->kobj, &blink1_sysfs_group);
+	led_classdev_unregister(led);
+	hid_hw_stop(hdev);
+}
+
+static const struct hid_device_id blink1_table[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THINGM, USB_DEVICE_ID_BLINK1) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, blink1_table);
+
+static struct hid_driver blink1_driver = {
+	.name = "blink(1)",
+	.probe = blink1_probe,
+	.remove = blink1_remove,
+	.id_table = blink1_table,
+};
+
+static int __init blink1_init(void)
+{
+	return hid_register_driver(&blink1_driver);
+}
+module_init(blink1_init);
+
+static void __exit blink1_exit(void)
+{
+	hid_unregister_driver(&blink1_driver);
+}
+module_exit(blink1_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vivien Didelot <vivien.didelot@savoirfairelinux.com>");
+MODULE_DESCRIPTION("ThingM blink(1) USB LED Driver");
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f4109fd..11ba357 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1673,6 +1673,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM, USB_DEVICE_ID_SENSOR_HUB_7014) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THINGM, USB_DEVICE_ID_BLINK1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 9d7a428..ee5670d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -740,6 +740,9 @@
 #define USB_DEVICE_ID_SYNAPTICS_WTP	0x0010
 #define USB_DEVICE_ID_SYNAPTICS_DPAD	0x0013
 
+#define USB_VENDOR_ID_THINGM		0x27b8
+#define USB_DEVICE_ID_BLINK1		0x01ed
+
 #define USB_VENDOR_ID_THRUSTMASTER	0x044f
 
 #define USB_VENDOR_ID_TIVO		0x150a
-- 
1.8.0.2

