Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2IIUKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:10:15 -0400
Received: from wren.arvixe.com ([50.97.138.99]:37921 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab2IIUKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:10:12 -0400
X-Greylist: delayed 1936 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Sep 2012 16:10:11 EDT
From: Przemo Firszt <przemo@firszt.eu>
To: dmitry.torokhov@gmail.com, rob@landley.net, pinglinux@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] USB: input: wacom_sys.c: format OLED image in kernel
Date: Sun,  9 Sep 2012 15:37:18 -0400
Message-Id: <1347219438-2598-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.12
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

This patch adds a new way of handling Wacom Intuos4 family OLEDs.
Previously the images had to be 'scrambled' by userland application. Now
the 'scrambling' is done in the kernel module, so user space can send
simple 64x32 pixels 4-bit grayscale (2 pixels per byte) 0,0 in top left corner
images straight to a wacom OLED sysfs entry. An example:

dd bs=1024 if=image_file \
of=/sys/bus/usb/drivers/wacom/[DevNo]/wacom_led/button[No]_formattedimg \
count=1

This patch greatly simplifies user space preparation of the image.
The raw image sysfs enties are still present to avoid breaking API.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 Documentation/ABI/testing/sysfs-driver-wacom |  7 ++++
 drivers/input/tablet/wacom_sys.c             | 60 +++++++++++++++++++++++++---
 2 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-wacom b/Documentation/ABI/testing/sysfs-driver-wacom
index 7fc7810..5b369a3 100644
--- a/Documentation/ABI/testing/sysfs-driver-wacom
+++ b/Documentation/ABI/testing/sysfs-driver-wacom
@@ -93,3 +93,10 @@ Description:
 		byte chunk encodes the image data for two consecutive lines on
 		the display. The low nibble of each byte contains the first
 		line, and the high nibble contains the second line.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/button<n>_formattedimg
+Date:		September 2012
+Contact:	linux-input@vger.kernel.org
+Description:
+		A plain format entry to wacom OLED icons. 1024 byte, 64x32 pixel 4-bit gray image,
+		2 pixels per byte, 0,0 in top left corner.
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 0d3219f..19c668d 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -654,11 +654,30 @@ static int wacom_led_control(struct wacom *wacom)
 
 	return retval;
 }
+static void wacom_scramble(__u8 *image)
+{
+	__u8 buf[1024];
+	int x, y, i;
+
+	memcpy(buf, image , 1024);
+
+	for (y = 0; y < 16; y++) {
+		for (x = 0; x < 32; x++) {
+			i = (2 * x) + (64 * y);
+			image[i] = (buf[63 - x + 64 * y] << 4) |
+					 (0x0F & (buf[31 - x + 64 * y]));
+			image[i + 1] = (0xF0 & buf[63 - x + 64 * y]) |
+					 (buf[31 - x + 64 * y] >> 4);
+		}
+	}
+}
 
-static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *img)
+static int wacom_led_putimage(struct wacom *wacom, int button_id,
+				 const void *img, int f)
 {
 	unsigned char *buf;
 	int i, retval;
+	__u8 p[1024];
 
 	buf = kzalloc(259, GFP_KERNEL);
 	if (!buf)
@@ -672,11 +691,16 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *im
 	if (retval < 0)
 		goto out;
 
+	memcpy(p, img , 1024);
+
+	if (f)
+		wacom_scramble(p);
+
 	buf[0] = WAC_CMD_ICON_XFER;
 	buf[1] = button_id & 0x07;
 	for (i = 0; i < 4; i++) {
 		buf[2] = i;
-		memcpy(buf + 3, img + i * 256, 256);
+		memcpy(buf + 3, p + i * 256, 256);
 
 		retval = wacom_set_report(wacom->intf, 0x03, WAC_CMD_ICON_XFER,
 					  buf, 259, WAC_CMD_RETRIES);
@@ -772,7 +796,7 @@ DEVICE_LUMINANCE_ATTR(status1, hlv);
 DEVICE_LUMINANCE_ATTR(buttons, img_lum);
 
 static ssize_t wacom_button_image_store(struct device *dev, int button_id,
-					const char *buf, size_t count)
+					const char *buf, size_t count, int f)
 {
 	struct wacom *wacom = dev_get_drvdata(dev);
 	int err;
@@ -782,7 +806,7 @@ static ssize_t wacom_button_image_store(struct device *dev, int button_id,
 
 	mutex_lock(&wacom->lock);
 
-	err = wacom_led_putimage(wacom, button_id, buf);
+	err = wacom_led_putimage(wacom, button_id, buf, f);
 
 	mutex_unlock(&wacom->lock);
 
@@ -793,7 +817,7 @@ static ssize_t wacom_button_image_store(struct device *dev, int button_id,
 static ssize_t wacom_btnimg##BUTTON_ID##_store(struct device *dev,	\
 	struct device_attribute *attr, const char *buf, size_t count)	\
 {									\
-	return wacom_button_image_store(dev, BUTTON_ID, buf, count);	\
+	return wacom_button_image_store(dev, BUTTON_ID, buf, count, 0);	\
 }									\
 static DEVICE_ATTR(button##BUTTON_ID##_rawimg, S_IWUSR,			\
 		   NULL, wacom_btnimg##BUTTON_ID##_store)
@@ -807,6 +831,24 @@ DEVICE_BTNIMG_ATTR(5);
 DEVICE_BTNIMG_ATTR(6);
 DEVICE_BTNIMG_ATTR(7);
 
+#define DEVICE_BTNIMG_FORMATTED_ATTR(BUTTON_ID)				\
+static ssize_t wacom_btnimg##BUTTON_ID##_store_formatted(struct device *dev,\
+	struct device_attribute *attr, const char *buf, size_t count)	\
+{									\
+	return wacom_button_image_store(dev, BUTTON_ID, buf, count, 1);	\
+}									\
+static DEVICE_ATTR(button##BUTTON_ID##_formattedimg, S_IWUSR,		\
+		   NULL, wacom_btnimg##BUTTON_ID##_store_formatted)
+
+DEVICE_BTNIMG_FORMATTED_ATTR(0);
+DEVICE_BTNIMG_FORMATTED_ATTR(1);
+DEVICE_BTNIMG_FORMATTED_ATTR(2);
+DEVICE_BTNIMG_FORMATTED_ATTR(3);
+DEVICE_BTNIMG_FORMATTED_ATTR(4);
+DEVICE_BTNIMG_FORMATTED_ATTR(5);
+DEVICE_BTNIMG_FORMATTED_ATTR(6);
+DEVICE_BTNIMG_FORMATTED_ATTR(7);
+
 static struct attribute *cintiq_led_attrs[] = {
 	&dev_attr_status_led0_select.attr,
 	&dev_attr_status_led1_select.attr,
@@ -831,6 +873,14 @@ static struct attribute *intuos4_led_attrs[] = {
 	&dev_attr_button5_rawimg.attr,
 	&dev_attr_button6_rawimg.attr,
 	&dev_attr_button7_rawimg.attr,
+	&dev_attr_button0_formattedimg.attr,
+	&dev_attr_button1_formattedimg.attr,
+	&dev_attr_button2_formattedimg.attr,
+	&dev_attr_button3_formattedimg.attr,
+	&dev_attr_button4_formattedimg.attr,
+	&dev_attr_button5_formattedimg.attr,
+	&dev_attr_button6_formattedimg.attr,
+	&dev_attr_button7_formattedimg.attr,
 	NULL
 };
 
-- 
1.7.12

