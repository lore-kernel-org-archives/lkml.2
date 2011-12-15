Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1LOH2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:28:19 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:42744 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614Ab1LOH2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:28:16 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] asus-laptop: control how BLED and WLED should be exposed
Date: Thu, 15 Dec 2011 08:27:34 +0100
Message-Id: <1323934059-1221-5-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
References: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

Let the user tells if BLED and WLED should be exposed as led or
rfkill (the old sysfs are still here, but this adds a standard
interface to control the device).

For example on my A6JC, with WAPF=1, I would do:

$ modprobe asus-laptop wled_type=led bluetooth_type=rfkill

There is still no known way to automatically guess what BLED
and WLED methods will control, it's why user information is needed.

A userspace database could do that automatically, and maybe some DMI
matching in the driver.

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |  149 ++++++++++++++++++++++++++++--------
 1 files changed, 116 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 3c07013..43c74ed 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -81,6 +81,19 @@ static uint wapf = 1;
 module_param(wapf, uint, 0444);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
+static char *wled_type = "unknown";
+static char *bled_type = "unknown";
+
+module_param(wled_type, charp, 0444);
+MODULE_PARM_DESC(wlan_status, "Set the wled type on boot "
+		 "(unknown, led or rfkill). "
+		 "default is unknown");
+
+module_param(bled_type, charp, 0444);
+MODULE_PARM_DESC(bled_type, "Set the bled type on boot "
+		 "(unknown, led or rfkill). "
+		 "default is unknown");
+
 static int wlan_status = 1;
 static int bluetooth_status = 1;
 static int wimax_status = -1;
@@ -137,6 +150,11 @@ MODULE_PARM_DESC(als_status, "Set the ALS status on boot "
 #define WM_RSTS		0x08    /* internal wimax */
 #define WW_RSTS		0x20    /* internal wwan */
 
+/* WLED and BLED type */
+#define TYPE_UNKNOWN	0
+#define TYPE_LED	1
+#define TYPE_RFKILL	2
+
 /* LED */
 #define METHOD_MLED		"MLED"
 #define METHOD_TLED		"TLED"
@@ -219,7 +237,8 @@ struct asus_led {
  * Same thing for rfkill
  */
 struct asus_rfkill {
-	int control_id;		/* type of control. Maps to PEGA_* values */
+	/* type of control. Maps to PEGA_* values or *_RSTS  */
+	int control_id;
 	struct rfkill *rfkill;
 	struct asus_laptop *asus;
 };
@@ -240,6 +259,8 @@ struct asus_laptop {
 	struct key_entry *keymap;
 	struct input_polled_dev *pega_accel_poll;
 
+	struct asus_led wled;
+	struct asus_led bled;
 	struct asus_led mled;
 	struct asus_led tled;
 	struct asus_led rled;
@@ -248,6 +269,8 @@ struct asus_laptop {
 	struct asus_led kled;
 	struct workqueue_struct *led_workqueue;
 
+	int wled_type;
+	int bled_type;
 	int wireless_status;
 	bool have_rsts;
 	bool is_pega_lucid;
@@ -600,6 +623,10 @@ static enum led_brightness asus_kled_cdev_get(struct led_classdev *led_cdev)
 
 static void asus_led_exit(struct asus_laptop *asus)
 {
+	if (!IS_ERR_OR_NULL(asus->wled.led.dev))
+		led_classdev_unregister(&asus->wled.led);
+	if (!IS_ERR_OR_NULL(asus->bled.led.dev))
+		led_classdev_unregister(&asus->bled.led);
 	if (!IS_ERR_OR_NULL(asus->mled.led.dev))
 		led_classdev_unregister(&asus->mled.led);
 	if (!IS_ERR_OR_NULL(asus->tled.led.dev))
@@ -641,7 +668,7 @@ static int asus_led_register(struct asus_laptop *asus,
 
 static int asus_led_init(struct asus_laptop *asus)
 {
-	int r;
+	int r = 0;
 
 	/*
 	 * The Pegatron Lucid has no physical leds, but all methods are
@@ -660,6 +687,16 @@ static int asus_led_init(struct asus_laptop *asus)
 	if (!asus->led_workqueue)
 		return -ENOMEM;
 
+	if (asus->wled_type == TYPE_LED)
+		r = asus_led_register(asus, &asus->wled, "asus::wlan",
+				      METHOD_WLAN);
+	if (r)
+		goto error;
+	if (asus->bled_type == TYPE_LED)
+		r = asus_led_register(asus, &asus->bled, "asus::bluetooth",
+				      METHOD_BLUETOOTH);
+	if (r)
+		goto error;
 	r = asus_led_register(asus, &asus->mled, "asus::mail", METHOD_MLED);
 	if (r)
 		goto error;
@@ -962,7 +999,7 @@ static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
 	return sysfs_acpi_set(asus, buf, count, METHOD_WLAN);
 }
 
-/*
+/*e
  * Bluetooth
  */
 static int asus_bluetooth_set(struct asus_laptop *asus, int status)
@@ -1245,6 +1282,23 @@ static const struct rfkill_ops asus_gps_rfkill_ops = {
 	.set_block = asus_gps_rfkill_set,
 };
 
+static int asus_rfkill_set(void *data, bool blocked)
+{
+	struct asus_rfkill *rfk = data;
+	struct asus_laptop *asus = rfk->asus;
+
+	if (rfk->control_id == WL_RSTS)
+		return asus_wlan_set(asus, !blocked);
+	else if (rfk->control_id == BT_RSTS)
+		return asus_bluetooth_set(asus, !blocked);
+
+	return -EINVAL;
+}
+
+static const struct rfkill_ops asus_rfkill_ops = {
+	.set_block = asus_rfkill_set,
+};
+
 static void asus_rfkill_terminate(struct asus_rfkill *rfk)
 {
 	if (!rfk->rfkill)
@@ -1263,30 +1317,64 @@ static void asus_rfkill_exit(struct asus_laptop *asus)
 	asus_rfkill_terminate(&asus->gps);
 }
 
-static int asus_rfkill_init(struct asus_laptop *asus)
+static int asus_rfkill_setup(struct asus_laptop *asus, struct asus_rfkill *rfk,
+			     const char *name, int control_id, int type,
+			     const struct rfkill_ops *ops)
 {
 	int result;
 
-	if (acpi_check_handle(asus->handle, METHOD_GPS_ON, NULL) ||
-	    acpi_check_handle(asus->handle, METHOD_GPS_OFF, NULL) ||
-	    acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL))
-		return 0;
-
-	asus->gps.rfkill = rfkill_alloc("asus-gps", &asus->platform_device->dev,
-					RFKILL_TYPE_GPS,
-					&asus_gps_rfkill_ops, asus);
-	if (!asus->gps.rfkill)
+	rfk->control_id = control_id;
+	rfk->asus = asus;
+	rfk->rfkill = rfkill_alloc(name, &asus->platform_device->dev,
+				   type, ops, rfk);
+	if (!rfk->rfkill)
 		return -EINVAL;
 
-	result = rfkill_register(asus->gps.rfkill);
+	result = rfkill_register(rfk->rfkill);
 	if (result) {
-		rfkill_destroy(asus->gps.rfkill);
-		asus->gps.rfkill = NULL;
+		rfkill_destroy(rfk->rfkill);
+		rfk->rfkill = NULL;
 	}
 
 	return result;
 }
 
+static int asus_rfkill_init(struct asus_laptop *asus)
+{
+	int result = 0;
+
+	if (!acpi_check_handle(asus->handle, METHOD_GPS_ON, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_GPS_OFF, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL))
+		result = asus_rfkill_setup(asus, &asus->gps, "asus-gps",
+					   -1, RFKILL_TYPE_GPS,
+					   &asus_gps_rfkill_ops);
+	if (result)
+		goto exit;
+
+
+	if (asus->wled_type == TYPE_RFKILL)
+		result = asus_rfkill_setup(asus, &asus->wlan, "asus-wlan",
+					   WL_RSTS, RFKILL_TYPE_WLAN,
+					   &asus_rfkill_ops);
+	if (result)
+		goto exit;
+
+	if (asus->bled_type == TYPE_RFKILL)
+		result = asus_rfkill_setup(asus, &asus->bluetooth,
+					   "asus-bluetooth", BT_RSTS,
+					   RFKILL_TYPE_BLUETOOTH,
+					   &asus_rfkill_ops);
+	if (result)
+		goto exit;
+
+exit:
+	if (result)
+		asus_rfkill_exit(asus);
+
+	return result;
+}
+
 static int pega_rfkill_set(void *data, bool blocked)
 {
 	struct asus_rfkill *rfk = data;
@@ -1302,22 +1390,8 @@ static const struct rfkill_ops pega_rfkill_ops = {
 static int pega_rfkill_setup(struct asus_laptop *asus, struct asus_rfkill *rfk,
 			     const char *name, int controlid, int rfkill_type)
 {
-	int result;
-
-	rfk->control_id = controlid;
-	rfk->asus = asus;
-	rfk->rfkill = rfkill_alloc(name, &asus->platform_device->dev,
-				   rfkill_type, &pega_rfkill_ops, rfk);
-	if (!rfk->rfkill)
-		return -EINVAL;
-
-	result = rfkill_register(rfk->rfkill);
-	if (result) {
-		rfkill_destroy(rfk->rfkill);
-		rfk->rfkill = NULL;
-	}
-
-	return result;
+	return asus_rfkill_setup(asus, rfk, name, controlid, rfkill_type,
+				 &pega_rfkill_ops);
 }
 
 static int pega_rfkill_init(struct asus_laptop *asus)
@@ -1678,7 +1752,16 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	if (result)
 		return result;
 
-	/* WLED and BLED are on by default */
+	if (!strcmp(bled_type, "led"))
+		asus->bled_type = TYPE_LED;
+	else if (!strcmp(bled_type, "rfkill"))
+		asus->bled_type = TYPE_RFKILL;
+
+	if (!strcmp(wled_type, "led"))
+		asus->wled_type = TYPE_LED;
+	else if (!strcmp(wled_type, "rfkill"))
+		asus->wled_type = TYPE_RFKILL;
+
 	if (bluetooth_status >= 0)
 		asus_bluetooth_set(asus, !!bluetooth_status);
 
-- 
1.7.5.4

