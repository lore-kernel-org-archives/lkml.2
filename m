Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200Ab2CFDan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:30:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2CFDaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:30:39 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 1/3] toshiba_acpi: Support alternate hotkey interfaces
Date: Mon,  5 Mar 2012 21:30:31 -0600
Message-Id: <1331004633-11862-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
References: <20120305220407.GA16312@ubuntu-macmini>
 <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two types of problems that prevent hotkeys from working
on many of the machines supported by toshiba_acpi. The first of
these is the lack of a functioning SCI for hotkey events. For these
machines it is possible to filter the Fn keypresses from the
keyboard and generate a notification by executing the ACPI NTFY
method.

The second problem is a lack of support for HCI_SYSTEM_EVENT, which
is used for reading the hotkey scancodes. On these machines the
scancodes can be read by executing the ACPI NTFY method.

This patch fixes both problems by installing an i8042 filter when
the NTFY method is present to generate notifications and by
detecting which of INFO or HCI_SYSTEM_EVENT is supported for
reading scancodes. If neither method of reading scancodes is
supported, the hotkey input device is not registered.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/toshiba_acpi.c |  245 +++++++++++++++++++++++++++++-----
 1 files changed, 209 insertions(+), 36 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index dcdc1f4..f49330a 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -52,6 +52,8 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/i8042.h>
 
 #include <asm/uaccess.h>
 
@@ -61,6 +63,9 @@ MODULE_AUTHOR("John Belmonte");
 MODULE_DESCRIPTION("Toshiba Laptop ACPI Extras Driver");
 MODULE_LICENSE("GPL");
 
+/* Scan code for Fn key on TOS1900 models */
+#define TOS1900_FN_SCAN		0x6e
+
 /* Toshiba ACPI method paths */
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
 
@@ -95,6 +100,8 @@ MODULE_LICENSE("GPL");
 #define HCI_WIRELESS			0x0056
 
 /* field definitions */
+#define HCI_HOTKEY_DISABLE		0x0b
+#define HCI_HOTKEY_ENABLE		0x09
 #define HCI_LCD_BRIGHTNESS_BITS		3
 #define HCI_LCD_BRIGHTNESS_SHIFT	(16-HCI_LCD_BRIGHTNESS_BITS)
 #define HCI_LCD_BRIGHTNESS_LEVELS	(1 << HCI_LCD_BRIGHTNESS_BITS)
@@ -109,8 +116,11 @@ MODULE_LICENSE("GPL");
 struct toshiba_acpi_dev {
 	struct acpi_device *acpi_dev;
 	const char *method_hci;
+	acpi_handle ec_handle;
+
 	struct rfkill *bt_rfk;
 	struct input_dev *hotkey_dev;
+	struct work_struct hotkey_work;
 	struct backlight_device *backlight_dev;
 	struct led_classdev led_dev;
 
@@ -122,10 +132,14 @@ struct toshiba_acpi_dev {
 	int video_supported:1;
 	int fan_supported:1;
 	int system_event_supported:1;
+	int ntfy_supported:1;
+	int info_supported:1;
 
 	struct mutex mutex;
 };
 
+static struct toshiba_acpi_dev *toshiba_acpi;
+
 static const struct acpi_device_id toshiba_device_ids[] = {
 	{"TOS6200", 0},
 	{"TOS6208", 0},
@@ -847,10 +861,86 @@ static const struct backlight_ops toshiba_backlight_data = {
         .update_status  = set_lcd_status,
 };
 
+static bool toshiba_acpi_i8042_filter(unsigned char data, unsigned char str,
+				      struct serio *port)
+{
+	if (str & 0x20)
+		return false;
+
+	if (unlikely(data == 0xe0))
+		return false;
+
+	if ((data & 0x7f) == TOS1900_FN_SCAN) {
+		schedule_work(&toshiba_acpi->hotkey_work);
+		return true;
+	}
+
+	return false;
+}
+
+static void toshiba_acpi_hotkey_work(struct work_struct *work)
+{
+	struct toshiba_acpi_dev *dev = container_of(work,
+			struct toshiba_acpi_dev, hotkey_work);
+	acpi_status status;
+
+	if (!dev->ec_handle)
+		return;
+
+	status = acpi_evaluate_object(dev->ec_handle, "NTFY", NULL, NULL);
+	if (ACPI_FAILURE(status))
+		pr_err("ACPI NTFY method execution failed\n");
+}
+
+/*
+ * Returns hotkey scancode, or < 0 on failure.
+ */
+static int toshiba_acpi_query_hotkey(struct toshiba_acpi_dev *dev)
+{
+	struct acpi_buffer buf;
+	union acpi_object out_obj;
+	acpi_status status;
+
+	buf.pointer = &out_obj;
+	buf.length = sizeof(out_obj);
+
+	status = acpi_evaluate_object(dev->acpi_dev->handle, "INFO",
+				      NULL, &buf);
+	if (ACPI_FAILURE(status) || out_obj.type != ACPI_TYPE_INTEGER) {
+		pr_err("ACPI INFO method execution failed\n");
+		return -EIO;
+	}
+
+	return out_obj.integer.value;
+}
+
+static void toshiba_acpi_report_hotkey(struct toshiba_acpi_dev *dev,
+				       int scancode)
+{
+	if (scancode == 0x100)
+		return;
+
+	/* act on key press; ignore key release */
+	if (scancode & 0x80)
+		return;
+
+	if (!sparse_keymap_report_event(dev->hotkey_dev, scancode, 1, true))
+		pr_info("Unknown key %x\n", scancode);
+}
+
+static acpi_status __devinit toshiba_acpi_get_ec_callback(acpi_handle handle,
+				u32 level, void *context, void **return_value)
+{
+	*(acpi_handle *)return_value = handle;
+	return AE_CTRL_TERMINATE;
+}
+
 static int __devinit toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 {
 	acpi_status status;
+	acpi_handle handle;
 	int error;
+	u32 hci_result;
 
 	dev->hotkey_dev = input_allocate_device();
 	if (!dev->hotkey_dev) {
@@ -866,21 +956,71 @@ static int __devinit toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 	if (error)
 		goto err_free_dev;
 
+	/*
+	 * For some machines the SCI responsible for providing hotkey
+	 * notification doesn't fire. We can trigger the notification
+	 * whenever the Fn key is pressed using the NTFY method, if
+	 * supported, so if it's present set up an i8042 key filter
+	 * for this purpose.
+	 */
+	status = acpi_get_devices("PNP0C09", toshiba_acpi_get_ec_callback,
+				  NULL, &dev->ec_handle);
+	if (ACPI_SUCCESS(status) && dev->ec_handle) {
+		status = acpi_get_handle(dev->ec_handle, "NTFY", &handle);
+	} else {
+		pr_warn("no EC found, hotkeys may not function\n");
+		status = AE_ERROR;
+	}
+
+	if (ACPI_SUCCESS(status)) {
+		INIT_WORK(&dev->hotkey_work, toshiba_acpi_hotkey_work);
+
+		error = i8042_install_filter(toshiba_acpi_i8042_filter);
+		if (error) {
+			pr_err("Error installing key filter\n");
+			goto err_free_keymap;
+		}
+
+		dev->ntfy_supported = 1;
+	}
+
+	/*
+	 * Determine hotkey query interface. Prefer using the INFO
+	 * method when it is available.
+	 */
+	status = acpi_get_handle(dev->acpi_dev->handle, "INFO", &handle);
+	if (ACPI_SUCCESS(status)) {
+		dev->info_supported = 1;
+	} else {
+		hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
+		if (hci_result == HCI_SUCCESS)
+			dev->system_event_supported = 1;
+	}
+
+	if (!dev->info_supported && !dev->system_event_supported) {
+		pr_warn("No hotkey query interface found\n");
+		goto err_remove_filter;
+	}
+
 	status = acpi_evaluate_object(dev->acpi_dev->handle, "ENAB", NULL, NULL);
 	if (ACPI_FAILURE(status)) {
 		pr_info("Unable to enable hotkeys\n");
 		error = -ENODEV;
-		goto err_free_keymap;
+		goto err_remove_filter;
 	}
 
 	error = input_register_device(dev->hotkey_dev);
 	if (error) {
 		pr_info("Unable to register input device\n");
-		goto err_free_keymap;
+		goto err_remove_filter;
 	}
 
+	hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &hci_result);
 	return 0;
 
+ err_remove_filter:
+	if (dev->ntfy_supported)
+		i8042_remove_filter(toshiba_acpi_i8042_filter);
  err_free_keymap:
 	sparse_keymap_free(dev->hotkey_dev);
  err_free_dev:
@@ -895,6 +1035,11 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev, int type)
 
 	remove_toshiba_proc_entries(dev);
 
+	if (dev->ntfy_supported) {
+		i8042_remove_filter(toshiba_acpi_i8042_filter);
+		cancel_work_sync(&dev->hotkey_work);
+	}
+
 	if (dev->hotkey_dev) {
 		input_unregister_device(dev->hotkey_dev);
 		sparse_keymap_free(dev->hotkey_dev);
@@ -911,6 +1056,9 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev, int type)
 	if (dev->illumination_supported)
 		led_classdev_unregister(&dev->led_dev);
 
+	if (toshiba_acpi)
+		toshiba_acpi = NULL;
+
 	kfree(dev);
 
 	return 0;
@@ -936,12 +1084,14 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 {
 	struct toshiba_acpi_dev *dev;
 	const char *hci_method;
-	u32 hci_result;
 	u32 dummy;
 	bool bt_present;
 	int ret = 0;
 	struct backlight_properties props;
 
+	if (toshiba_acpi)
+		return -EBUSY;
+
 	pr_info("Toshiba Laptop ACPI Extras version %s\n",
 	       TOSHIBA_ACPI_VERSION);
 
@@ -963,11 +1113,6 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 
 	mutex_init(&dev->mutex);
 
-	/* enable event fifo */
-	hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
-	if (hci_result == HCI_SUCCESS)
-		dev->system_event_supported = 1;
-
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 	dev->backlight_dev = backlight_device_register("toshiba",
@@ -1024,6 +1169,8 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 
 	create_toshiba_proc_entries(dev);
 
+	toshiba_acpi = dev;
+
 	return 0;
 
 error:
@@ -1036,40 +1183,64 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
 	u32 hci_result, value;
 	int retries = 3;
+	int scancode;
 
-	if (!dev->system_event_supported || event != 0x80)
+	if (event != 0x80)
 		return;
 
-	do {
-		hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
-		switch (hci_result) {
-		case HCI_SUCCESS:
-			if (value == 0x100)
-				continue;
-			/* act on key press; ignore key release */
-			if (value & 0x80)
-				continue;
-
-			if (!sparse_keymap_report_event(dev->hotkey_dev,
-							value, 1, true)) {
-				pr_info("Unknown key %x\n",
-				       value);
+	if (dev->info_supported) {
+		scancode = toshiba_acpi_query_hotkey(dev);
+		if (scancode < 0)
+			pr_err("Failed to query hotkey event\n");
+		else if (scancode != 0)
+			toshiba_acpi_report_hotkey(dev, scancode);
+	} else if (dev->system_event_supported) {
+		do {
+			hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
+			switch (hci_result) {
+			case HCI_SUCCESS:
+				toshiba_acpi_report_hotkey(dev, (int)value);
+				break;
+			case HCI_NOT_SUPPORTED:
+				/*
+				 * This is a workaround for an unresolved
+				 * issue on some machines where system events
+				 * sporadically become disabled.
+				 */
+				hci_write1(dev, HCI_SYSTEM_EVENT, 1,
+					   &hci_result);
+				pr_notice("Re-enabled hotkeys\n");
+				/* fall through */
+			default:
+				retries--;
+				break;
 			}
-			break;
-		case HCI_NOT_SUPPORTED:
-			/* This is a workaround for an unresolved issue on
-			 * some machines where system events sporadically
-			 * become disabled. */
-			hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
-			pr_notice("Re-enabled hotkeys\n");
-			/* fall through */
-		default:
-			retries--;
-			break;
-		}
-	} while (retries && hci_result != HCI_EMPTY);
+		} while (retries && hci_result != HCI_EMPTY);
+	}
 }
 
+static int toshiba_acpi_suspend(struct acpi_device *acpi_dev,
+				pm_message_t state)
+{
+	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
+	u32 result;
+
+	if (dev->hotkey_dev)
+		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_DISABLE, &result);
+
+	return 0;
+}
+
+static int toshiba_acpi_resume(struct acpi_device *acpi_dev)
+{
+	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
+	u32 result;
+
+	if (dev->hotkey_dev)
+		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &result);
+
+	return 0;
+}
 
 static struct acpi_driver toshiba_acpi_driver = {
 	.name	= "Toshiba ACPI driver",
@@ -1080,6 +1251,8 @@ static struct acpi_driver toshiba_acpi_driver = {
 		.add		= toshiba_acpi_add,
 		.remove		= toshiba_acpi_remove,
 		.notify		= toshiba_acpi_notify,
+		.suspend	= toshiba_acpi_suspend,
+		.resume		= toshiba_acpi_resume,
 	},
 };
 
-- 
1.7.9

