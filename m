Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2GaSUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:20:21 -0400
Received: from 50.97.138.99-static.reverse.softlayer.com ([50.97.138.99]:41254
	"EHLO wren.arvixe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2GaSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:20:18 -0400
X-Greylist: delayed 3063 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2012 14:20:17 EDT
From: Przemo Firszt <przemo@firszt.eu>
To: pinglinux@gmail.com, jkosina@suse.cz, linux-doc@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 2/2] HID: wacom: OLEDs control over sysfs for Intuos4
Date: Tue, 31 Jul 2012 18:27:56 +0100
Message-Id: <1343755676-2999-2-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1343755676-2999-1-git-send-email-przemo@firszt.eu>
References: <1343755676-2999-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thsi patch adds ability to control OLED micro displays on Wacom Intuos4
Wireless. The OLEDS are exposed as
/sys/class/hidraw/hidraw*/device/oled{No]_img
where No. is 0 to 7

Setting an image:

dd bs=256 if=img_file of=/sys/class/hidraw/hidraw{No}/device/oled0_img

The image has to contain 256 bytes (64x32px 1 bit). More detailed
description in Documentation/ABI/testing/sysfs-driver-wacom

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 Documentation/ABI/testing/sysfs-driver-wacom |   13 +++
 drivers/hid/hid-wacom.c                      |  143 ++++++++++++++++++++++++++
 2 files changed, 156 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-wacom b/Documentation/ABI/testing/sysfs-driver-wacom
index 8d55a83..7fc7810 100644
--- a/Documentation/ABI/testing/sysfs-driver-wacom
+++ b/Documentation/ABI/testing/sysfs-driver-wacom
@@ -1,3 +1,16 @@
+WWhat:		/sys/class/hidraw/hidraw*/device/oled*_img
+Date:		June 2012
+Contact:	linux-bluetooth@vger.kernel.org
+Description:
+		The /sys/class/hidraw/hidraw*/device/oled*_img files control
+		OLED mocro displays on Intuos4 Wireless tablet. Accepted image
+		has to contain 256 bytes (64x32 px 1 bit colour). The format
+		is the same as PBM image 62x32px without header (64 bits per
+		horizontal line, 32 lines). An example of setting OLED No. 0:
+		dd bs=256 count=1 if=img_file of=[path to oled0_img]/oled0_img
+		The attribute is read only and no local copy of the image is
+		stored.
+
 What:		/sys/class/hidraw/hidraw*/device/speed
 Date:		April 2010
 Kernel Version:	2.6.35
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 848842e..8effb8b 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -33,6 +33,8 @@
 #define PAD_DEVICE_ID	0x0F
 
 #define WAC_CMD_LED_CONTROL     0x20
+#define WAC_CMD_ICON_START_STOP     0x21
+#define WAC_CMD_ICON_TRANSFER       0x26
 
 struct wacom_data {
 	__u16 tool;
@@ -69,6 +71,91 @@ static enum power_supply_property wacom_ac_props[] = {
 	POWER_SUPPLY_PROP_SCOPE,
 };
 
+static void wacom_scramble(__u8 *image)
+{
+	__u16 mask;
+	__u16 s1;
+	__u16 s2;
+	__u16 r1 ;
+	__u16 r2 ;
+	__u16 r;
+	__u8 buf[256];
+	int i, w, x, y, z;
+
+	for (x = 0; x < 32; x++) {
+		for (y = 0; y < 8; y++)
+			buf[(8 * x) + (7 - y)] = image[(8 * x) + y];
+	}
+
+	/* Change 76543210 into GECA6420 as required by Intuos4 WL
+	 *        HGFEDCBA      HFDB7531
+	 */
+	for (x = 0; x < 4; x++) {
+		for (y = 0; y < 4; y++) {
+			for (z = 0; z < 8; z++) {
+				mask = 0x0001;
+				r1 = 0;
+				r2 = 0;
+				i = (x << 6) + (y << 4) + z;
+				s1 = buf[i];
+				s2 = buf[i+8];
+				for (w = 0; w < 8; w++) {
+					r1 |= (s1 & mask);
+					r2 |= (s2 & mask);
+					s1 <<= 1;
+					s2 <<= 1;
+					mask <<= 2;
+				}
+				r = r1 | (r2 << 1);
+				i = (x << 6) + (y << 4) + (z << 1);
+				image[i] = 0xFF & r;
+				image[i+1] = (0xFF00 & r) >> 8;
+			}
+		}
+	}
+}
+
+static void wacom_set_image(struct hid_device *hdev, const char *image,
+						__u8 icon_no)
+{
+	__u8 rep_data[68];
+	__u8 p[256];
+	int ret, i, j;
+
+	for (i = 0; i < 256; i++)
+		p[i] = image[i];
+
+	rep_data[0] = WAC_CMD_ICON_START_STOP;
+	rep_data[1] = 0;
+	ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
+				HID_FEATURE_REPORT);
+	if (ret < 0)
+		goto err;
+
+	rep_data[0] = WAC_CMD_ICON_TRANSFER;
+	rep_data[1] = icon_no & 0x07;
+
+	wacom_scramble(p);
+
+	for (i = 0; i < 4; i++) {
+		for (j = 0; j < 64; j++)
+			rep_data[j + 3] = p[(i << 6) + j];
+
+		rep_data[2] = i;
+		ret = hdev->hid_output_raw_report(hdev, rep_data, 67,
+					HID_FEATURE_REPORT);
+	}
+
+	rep_data[0] = WAC_CMD_ICON_START_STOP;
+	rep_data[1] = 0;
+
+	ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
+				HID_FEATURE_REPORT);
+
+err:
+	return;
+}
+
 static void wacom_leds_set_brightness(struct led_classdev *led_dev,
 						enum led_brightness value)
 {
@@ -93,6 +180,8 @@ static void wacom_leds_set_brightness(struct led_classdev *led_dev,
 		buf[1] = led;
 		buf[2] = value >> 2;
 		buf[3] = value;
+		/* use fixed brightness for OLEDs */
+		buf[4] = 0x08;
 		hdev->hid_output_raw_report(hdev, buf, 9, HID_FEATURE_REPORT);
 		kfree(buf);
 	}
@@ -318,6 +407,34 @@ static ssize_t wacom_store_speed(struct device *dev,
 static DEVICE_ATTR(speed, S_IRUGO | S_IWUSR | S_IWGRP,
 		wacom_show_speed, wacom_store_speed);
 
+#define WACOM_STORE(OLED_ID)						\
+static ssize_t wacom_oled##OLED_ID##_store(struct device *dev,		\
+				struct device_attribute *attr,		\
+				const char *buf, size_t count)		\
+{									\
+	struct hid_device *hdev = container_of(dev, struct hid_device,	\
+				dev);					\
+									\
+	if (count != 256)						\
+		return -EINVAL;						\
+									\
+	wacom_set_image(hdev, buf, OLED_ID);				\
+									\
+	return count;							\
+}									\
+									\
+static DEVICE_ATTR(oled##OLED_ID##_img, S_IWUSR | S_IWGRP, NULL,	\
+				wacom_oled##OLED_ID##_store)
+
+WACOM_STORE(0);
+WACOM_STORE(1);
+WACOM_STORE(2);
+WACOM_STORE(3);
+WACOM_STORE(4);
+WACOM_STORE(5);
+WACOM_STORE(6);
+WACOM_STORE(7);
+
 static int wacom_gr_parse_report(struct hid_device *hdev,
 			struct wacom_data *wdata,
 			struct input_dev *input, unsigned char *data)
@@ -718,6 +835,24 @@ static int wacom_probe(struct hid_device *hdev,
 		hid_warn(hdev,
 			 "can't create sysfs speed attribute err: %d\n", ret);
 
+#define OLED_INIT(OLED_ID)						\
+	do {								\
+		ret = device_create_file(&hdev->dev,			\
+				&dev_attr_oled##OLED_ID##_img);		\
+		if (ret)						\
+			hid_warn(hdev,					\
+			 "can't create sysfs oled attribute, err: %d\n", ret);\
+	} while (0)
+
+OLED_INIT(0);
+OLED_INIT(1);
+OLED_INIT(2);
+OLED_INIT(3);
+OLED_INIT(4);
+OLED_INIT(5);
+OLED_INIT(6);
+OLED_INIT(7);
+
 	wdata->features = 0;
 	wacom_set_features(hdev, 1);
 
@@ -782,6 +917,14 @@ static void wacom_remove(struct hid_device *hdev)
 	struct wacom_data *wdata = hid_get_drvdata(hdev);
 
 	wacom_destroy_leds(hdev);
+	device_remove_file(&hdev->dev, &dev_attr_oled0_img);
+	device_remove_file(&hdev->dev, &dev_attr_oled1_img);
+	device_remove_file(&hdev->dev, &dev_attr_oled2_img);
+	device_remove_file(&hdev->dev, &dev_attr_oled3_img);
+	device_remove_file(&hdev->dev, &dev_attr_oled4_img);
+	device_remove_file(&hdev->dev, &dev_attr_oled5_img);
+	device_remove_file(&hdev->dev, &dev_attr_oled6_img);
+	device_remove_file(&hdev->dev, &dev_attr_oled7_img);
 	device_remove_file(&hdev->dev, &dev_attr_speed);
 	hid_hw_stop(hdev);
 
-- 
1.7.10.2

