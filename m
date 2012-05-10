Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140Ab2EJSYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:24:24 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:55823 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755548Ab2EJSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:24:21 -0400
From: Przemo Firszt <przemo@firszt.eu>
To: pinglinux@gmail.com, jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] HID: wacom: Add LED selector control for Wacom Intuos4 WL
Date: Thu, 10 May 2012 19:23:52 +0100
Message-Id: <1336674232-5410-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.10
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs attribute to control LED selector on Wacom Intuos4. There are 4
different LEDs on the tablet and they can be turned on by something like:

echo 50 > /sys/class/leds/(device # here)\:selector\:1/brightness

Only one can be lit at a time. The brightness range is 0 to 127. This patch
also contains short ABI description.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 Documentation/ABI/testing/sysfs-driver-wacom |    8 ++
 drivers/hid/Kconfig                          |    1 +
 drivers/hid/hid-wacom.c                      |  126 ++++++++++++++++++++++++++
 3 files changed, 135 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-wacom b/Documentation/ABI/testing/sysfs-driver-wacom
index 0130d66..56c5455 100644
--- a/Documentation/ABI/testing/sysfs-driver-wacom
+++ b/Documentation/ABI/testing/sysfs-driver-wacom
@@ -9,6 +9,14 @@ Description:
 		or 0 otherwise. Writing to this file one of these values
 		switches reporting speed.
 
+What:		/sys/class/leds/0005\:056A\:00BD.0001\:selector\:*/
+Date:		May 2012
+Kernel Version:	3.5
+Contact:	linux-bluetooth@vger.kernel.org
+Description:
+		LED selector for Intuos4 WL. There are 4 leds, but only one LED
+		can be lit at a time. Max brightness is 127.
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/led
 Date:		August 2011
 Contact:	linux-input@vger.kernel.org
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 9092ae1..a9647dd 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -596,6 +596,7 @@ config HID_WACOM
 	tristate "Wacom Bluetooth devices support"
 	depends on BT_HIDP
 	select POWER_SUPPLY
+	select LEDS_CLASS
 	---help---
 	Support for Wacom Graphire Bluetooth and Intuos4 WL tablets.
 
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index a66e1aa..29372ed 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -24,6 +24,7 @@
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/power_supply.h>
 
@@ -31,6 +32,8 @@
 
 #define PAD_DEVICE_ID	0x0F
 
+#define WAC_CMD_LED_CONTROL     0x20
+
 struct wacom_data {
 	__u16 tool;
 	__u16 butstate;
@@ -44,6 +47,8 @@ struct wacom_data {
 	__u8 ps_connected;
 	struct power_supply battery;
 	struct power_supply ac;
+	__u8 led_selector;
+	struct led_classdev *leds[4];
 };
 
 /*percent of battery capacity for Graphire
@@ -64,6 +69,117 @@ static enum power_supply_property wacom_ac_props[] = {
 	POWER_SUPPLY_PROP_SCOPE,
 };
 
+static void wacom_leds_set_brightness(struct led_classdev *led_dev,
+						enum led_brightness value)
+{
+	struct device *dev = led_dev->dev->parent;
+	struct hid_device *hdev;
+	struct wacom_data *wdata;
+	unsigned char *buf;
+	__u8 led = 0;
+	int i;
+
+	hdev = container_of(dev, struct hid_device, dev);
+	wdata = hid_get_drvdata(hdev);
+	for (i = 0; i < 4; ++i) {
+		if (wdata->leds[i] == led_dev)
+			wdata->led_selector = i;
+	}
+
+	led = wdata->led_selector | 0x04;
+	buf = kzalloc(9, GFP_KERNEL);
+	if (buf) {
+		buf[0] = WAC_CMD_LED_CONTROL;
+		buf[1] = led;
+		buf[2] = value;
+		hdev->hid_output_raw_report(hdev, buf, 9, HID_FEATURE_REPORT);
+		kfree(buf);
+	}
+
+	return;
+}
+
+static enum led_brightness wacom_leds_get_brightness(struct led_classdev *led_dev)
+{
+	struct wacom_data *wdata;
+	struct device *dev = led_dev->dev->parent;
+	int value = 0;
+	int i;
+
+	wdata = hid_get_drvdata(container_of(dev, struct hid_device, dev));
+
+	for (i = 0; i < 4; ++i) {
+		if (wdata->leds[i] == led_dev) {
+			value = wdata->leds[i]->brightness;
+			break;
+		}
+	}
+
+	return value;
+}
+
+
+static int wacom_initialize_leds(struct hid_device *hdev)
+{
+	struct wacom_data *wdata = hid_get_drvdata(hdev);
+	struct led_classdev *led;
+	struct device *dev = &hdev->dev;
+	size_t namesz = strlen(dev_name(dev)) + 12;
+	char *name;
+	int i, ret;
+
+	wdata->led_selector = 0;
+
+	for (i = 0; i < 4; i++) {
+		led = kzalloc(sizeof(struct led_classdev) + namesz, GFP_KERNEL);
+		if (!led) {
+			hid_warn(hdev,
+				 "can't allocate memory for LED selector\n");
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		name = (void *)&led[1];
+		snprintf(name, namesz, "%s:selector:%d", dev_name(dev), i);
+		led->name = name;
+		led->brightness = 0;
+		led->max_brightness = 127;
+		led->brightness_get = wacom_leds_get_brightness;
+		led->brightness_set = wacom_leds_set_brightness;
+
+		wdata->leds[i] = led;
+
+		ret = led_classdev_register(dev, wdata->leds[i]);
+
+		if (ret) {
+			wdata->leds[i] = NULL;
+			kfree(led);
+			hid_warn(hdev, "can't register LED\n");
+			goto err;
+		}
+	}
+
+err:
+	return ret;
+}
+
+static void wacom_destroy_leds(struct hid_device *hdev)
+{
+	struct wacom_data *wdata = hid_get_drvdata(hdev);
+	struct led_classdev *led;
+	int i;
+
+	for (i = 0; i < 4; ++i) {
+		if (wdata->leds[i]) {
+			led = wdata->leds[i];
+			wdata->leds[i] = NULL;
+			led_classdev_unregister(led);
+			kfree(led);
+		}
+	}
+
+}
+
 static int wacom_battery_get_property(struct power_supply *psy,
 				enum power_supply_property psp,
 				union power_supply_propval *val)
@@ -602,6 +718,12 @@ static int wacom_probe(struct hid_device *hdev,
 		sprintf(hdev->name, "%s", "Wacom Intuos4 WL");
 		wdata->features = 0;
 		wacom_set_features(hdev);
+		ret = wacom_initialize_leds(hdev);
+		if (ret) {
+			hid_warn(hdev,
+				 "can't create led attribute, err: %d\n", ret);
+			goto destroy_leds;
+		}
 		break;
 	}
 
@@ -644,6 +766,8 @@ err_ac:
 err_battery:
 	device_remove_file(&hdev->dev, &dev_attr_speed);
 	hid_hw_stop(hdev);
+destroy_leds:
+	wacom_destroy_leds(hdev);
 err_free:
 	kfree(wdata);
 	return ret;
@@ -652,6 +776,8 @@ err_free:
 static void wacom_remove(struct hid_device *hdev)
 {
 	struct wacom_data *wdata = hid_get_drvdata(hdev);
+
+	wacom_destroy_leds(hdev);
 	device_remove_file(&hdev->dev, &dev_attr_speed);
 	hid_hw_stop(hdev);
 
-- 
1.7.10

