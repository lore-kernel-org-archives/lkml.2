Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0DYUQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 16:16:33 -0400
Received: from legolas.restena.lu ([158.64.1.34]:59786 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab0DYUPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 16:15:47 -0400
Date: Sun, 25 Apr 2010 21:29:16 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [PATCH] hid: split picolcd's operation_mode sysfs attribute
Message-ID: <20100425212916.2b9af33b@neptune.home>
In-Reply-To: <201004011858.45859.oliver@neukum.org>
References: <20100324233707.7243b04d@neptune.home>
	<20100330223224.18fe4f3e@neptune.home>
	<20100330223350.32044891@neptune.home>
	<201004011858.45859.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original operation_mode sysfs attribute accepts the operation mode
as main value with an option delay as second value to change
the start-up delay on mode change.

As it is preferred to have exactly one value per sysfs attribute,
extract this delay into a separate sysfs attribute called
operation_mode_delay.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 Documentation/ABI/testing/sysfs-driver-hid-picolcd |   17 ++++-
 drivers/hid/hid-picolcd.c                          |   62 ++++++++++++++-----
 2 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-picolcd b/Documentation/ABI/testing/sysfs-driver-hid-picolcd
index 14f52d7..08579e7 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-picolcd
+++ b/Documentation/ABI/testing/sysfs-driver-hid-picolcd
@@ -8,12 +8,21 @@ Description:	Make it possible to switch the PicoLCD device between LCD
 		enclosed in brackets ('[' and ']')
 
 		Writing: causes operation mode switch. Permitted values are
-		the non-active mode names listed when read, optionally followed
-		by a delay value expressed in ms.
+		the non-active mode names listed when read.
 
 		Note: when switching mode the current PicoLCD HID device gets
-		disconnected and reconnects after above delay (default value
-		is 5 seconds though this default should not be relied on).
+		disconnected and reconnects after above delay (see attribute
+		operation_mode_delay for its value).
+
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/operation_mode_delay
+Date:		April 2010
+Contact:	Bruno Prémont <bonbons@linux-vserver.org>
+Description:	Delay PicoLCD waits before restarting in new mode when
+		operation_mode has changed.
+
+		Reading/Writing: It is expressed in ms and permitted range is
+		0..30000ms.
 
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/fb_update_rate
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 6f71c60..aa6f2e1 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -177,6 +177,7 @@ struct picolcd_data {
 	int addr_sz;
 #endif
 	u8 version[2];
+	unsigned short opmode_delay;
 	/* input stuff */
 	u8 pressed_keys[2];
 	struct input_dev *input_keys;
@@ -1270,8 +1271,7 @@ static ssize_t picolcd_operation_mode_store(struct device *dev,
 	struct picolcd_data *data = dev_get_drvdata(dev);
 	struct hid_report *report = NULL;
 	size_t cnt = count;
-	int timeout = 5000;
-	unsigned u;
+	int timeout = data->opmode_delay;
 	unsigned long flags;
 
 	if (cnt >= 3 && strncmp("lcd", buf, 3) == 0) {
@@ -1288,20 +1288,10 @@ static ssize_t picolcd_operation_mode_store(struct device *dev,
 	if (!report)
 		return -EINVAL;
 
-	while (cnt > 0 && (*buf == ' ' || *buf == '\t')) {
-		buf++;
-		cnt--;
-	}
 	while (cnt > 0 && (buf[cnt-1] == '\n' || buf[cnt-1] == '\r'))
 		cnt--;
-	if (cnt > 0) {
-		if (sscanf(buf, "%u", &u) != 1)
-			return -EINVAL;
-		if (u > 30000)
-			return -EINVAL;
-		else
-			timeout = u;
-	}
+	if (cnt != 0)
+		return -EINVAL;
 
 	spin_lock_irqsave(&data->lock, flags);
 	hid_set_field(report->field[0], 0, timeout & 0xff);
@@ -1314,6 +1304,34 @@ static ssize_t picolcd_operation_mode_store(struct device *dev,
 static DEVICE_ATTR(operation_mode, 0644, picolcd_operation_mode_show,
 		picolcd_operation_mode_store);
 
+/*
+ * The "operation_mode_delay" sysfs attribute
+ */
+static ssize_t picolcd_operation_mode_delay_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct picolcd_data *data = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%hu\n", data->opmode_delay);
+}
+
+static ssize_t picolcd_operation_mode_delay_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct picolcd_data *data = dev_get_drvdata(dev);
+	unsigned u;
+	if (sscanf(buf, "%u", &u) != 1)
+		return -EINVAL;
+	if (u > 30000)
+		return -EINVAL;
+	else
+		data->opmode_delay = u;
+	return count;
+}
+
+static DEVICE_ATTR(operation_mode_delay, 0644, picolcd_operation_mode_delay_show,
+		picolcd_operation_mode_delay_store);
+
 
 #ifdef CONFIG_DEBUG_FS
 /*
@@ -2409,6 +2427,7 @@ static int picolcd_probe(struct hid_device *hdev,
 	spin_lock_init(&data->lock);
 	mutex_init(&data->mutex);
 	data->hdev = hdev;
+	data->opmode_delay = 5000;
 	if (hdev->product == USB_DEVICE_ID_PICOLCD_BOOTLOADER)
 		data->status |= PICOLCD_BOOTLOADER;
 	hid_set_drvdata(hdev, data);
@@ -2436,24 +2455,32 @@ static int picolcd_probe(struct hid_device *hdev,
 		goto err_cleanup_hid_hw;
 	}
 
-	error = device_create_file(&hdev->dev, &dev_attr_operation_mode);
+	error = device_create_file(&hdev->dev, &dev_attr_operation_mode_delay);
 	if (error) {
 		dev_err(&hdev->dev, "failed to create sysfs attributes\n");
 		goto err_cleanup_hid_ll;
 	}
 
+	error = device_create_file(&hdev->dev, &dev_attr_operation_mode);
+	if (error) {
+		dev_err(&hdev->dev, "failed to create sysfs attributes\n");
+		goto err_cleanup_sysfs1;
+	}
+
 	if (data->status & PICOLCD_BOOTLOADER)
 		error = picolcd_probe_bootloader(hdev, data);
 	else
 		error = picolcd_probe_lcd(hdev, data);
 	if (error)
-		goto err_cleanup_sysfs;
+		goto err_cleanup_sysfs2;
 
 	dbg_hid(PICOLCD_NAME " activated and initialized\n");
 	return 0;
 
-err_cleanup_sysfs:
+err_cleanup_sysfs2:
 	device_remove_file(&hdev->dev, &dev_attr_operation_mode);
+err_cleanup_sysfs1:
+	device_remove_file(&hdev->dev, &dev_attr_operation_mode_delay);
 err_cleanup_hid_ll:
 	hdev->ll_driver->close(hdev);
 err_cleanup_hid_hw:
@@ -2478,6 +2505,7 @@ static void picolcd_remove(struct hid_device *hdev)
 
 	picolcd_exit_devfs(data);
 	device_remove_file(&hdev->dev, &dev_attr_operation_mode);
+	device_remove_file(&hdev->dev, &dev_attr_operation_mode_delay);
 	hdev->ll_driver->close(hdev);
 	hid_hw_stop(hdev);
 	hid_set_drvdata(hdev, NULL);
-- 
1.6.4.4

