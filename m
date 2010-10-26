Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab0JZTO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:14:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48853 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab0JZTO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:14:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k25qRoqIxM7/SiA8lzBohL5ZNF3CEU3vdxogrBSKgejFBA4NZ2OQ8oS163JoHQ2mdJ
         /eIAMBVt4SL0C14lzEYL7mPC6rEDQQe7T1CQ6Y9l0Ty2wBAM/4/xhgW0r2lZcGL9X9vT
         nvxJQ0/cXm7AScneQoeYm4MWnskEhXmqA4ypo=
MIME-Version: 1.0
Date: Tue, 26 Oct 2010 13:14:25 -0600
Message-ID: <AANLkTikff5b9zhCLEmyoHZPTPaREuHE1qp21SLA0v=83@mail.gmail.com>
Subject: toshiba_acpi.c: Full TOS1900 device support
From: Azael Avalos <coproscefalo@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a long patch that adds full hotkey support to TOS1900 laptop devices,
converting toshiba_acpi to use sparse keymap in the process and also bumping
its version to 0.20.

Please review the code, and when all the needed changes are done and/or
corrections are made, I'll submit the code using all the appropriate procedures.


Saludos
Azael Avalos


--- toshiba_acpi.c	2010-10-26 12:54:00.868913701 -0600
+++ toshiba_new/toshiba_acpi.c	2010-10-26 12:50:04.164913701 -0600
@@ -35,7 +35,7 @@
  *
  */

-#define TOSHIBA_ACPI_VERSION	"0.19"
+#define TOSHIBA_ACPI_VERSION	"0.20"
 #define PROC_INTERFACE_VERSION	1

 #include <linux/kernel.h>
@@ -48,8 +48,11 @@
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
 #include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/workqueue.h>

 #include <asm/uaccess.h>

@@ -65,11 +68,23 @@
 #define MY_INFO KERN_INFO MY_LOGPREFIX

 /* Toshiba ACPI method paths */
-#define METHOD_LCD_BRIGHTNESS	"\\_SB_.PCI0.VGA_.LCD_._BCM"
 #define TOSH_INTERFACE_1	"\\_SB_.VALD"
 #define TOSH_INTERFACE_2	"\\_SB_.VALZ"
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
+#define TOSH_VIDEO_INTERFACE_1	"\\_SB.PCI0.PEGP.VGA.LCD"
+#define TOSH_VIDEO_INTERFACE_2	"\\_SB.PCI0.GFX0.LCD"
 #define GHCI_METHOD		".GHCI"
+#define SPFC_METHOD		".SPFC"
+#define EVENTS_METHOD		"INFO"
+#define EC_INTERFACE_1		"\\_SB.PCI0.LPC.EC0"
+#define EC_INTERFACE_2		"\\_SB.PCI0.LPC0.EC0"
+#define EC_INTERFACE_3		"\\_SB.PCI0.LPCB.EC0"
+#define NOTIFY_METHOD		"NTFY"
+
+#define TOSHIBA_FN_SCAN         0x6e	/* Fn key scancode */
+
+/* copied from drivers/input/serio/i8042-io.h */
+#define I8042_KBD_PHYS_DESC "isa0060/serio0"

 /* Toshiba HCI interface definitions
  *
@@ -108,6 +123,7 @@
 #define HCI_VIDEO_OUT_LCD		0x1
 #define HCI_VIDEO_OUT_CRT		0x2
 #define HCI_VIDEO_OUT_TV		0x4
+#define HCI_VIDEO_OUT_DVI		0x8
 #define HCI_WIRELESS_KILL_SWITCH	0x01
 #define HCI_WIRELESS_BT_PRESENT		0x0f
 #define HCI_WIRELESS_BT_ATTACH		0x40
@@ -121,36 +137,45 @@
 };
 MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);

-struct key_entry {
-	char type;
-	u16 code;
-	u16 keycode;
+static struct key_entry toshiba_acpi_keymap[]  = {
+	{KE_KEY, 0x100, { KEY_FN } },
+	{KE_KEY, 0x101, { KEY_MUTE } },
+	{KE_KEY, 0x102, { KEY_ZOOMOUT } },
+	{KE_KEY, 0x103, { KEY_ZOOMIN } },
+	{KE_KEY, 0x139, { KEY_ZOOMRESET } },
+	{KE_KEY, 0x13b, { KEY_COFFEE } },
+	{KE_KEY, 0x13c, { KEY_BATTERY } },
+	{KE_KEY, 0x13d, { KEY_SLEEP } },
+	{KE_KEY, 0x13e, { KEY_SUSPEND } },
+	{KE_KEY, 0x13f, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x140, { KEY_BRIGHTNESSDOWN } },
+	{KE_KEY, 0x141, { KEY_BRIGHTNESSUP } },
+	{KE_KEY, 0x142, { KEY_WLAN } },
+	{KE_KEY, 0x143, { KEY_PROG1 } },
+	{KE_KEY, 0x17f, { KEY_FN } },
+	{KE_KEY, 0xb05, { KEY_PROG2 } },
+	{KE_KEY, 0xb06, { KEY_WWW } },
+	{KE_KEY, 0xb07, { KEY_MAIL } },
+	{KE_KEY, 0xb30, { KEY_STOP } },
+	{KE_KEY, 0xb31, { KEY_PREVIOUSSONG } },
+	{KE_KEY, 0xb32, { KEY_NEXTSONG } },
+	{KE_KEY, 0xb33, { KEY_PLAYPAUSE } },
+	{KE_KEY, 0xb5a, { KEY_MEDIA } },
+	{KE_END, 0},
 };

-enum {KE_KEY, KE_END};
-
-static struct key_entry toshiba_acpi_keymap[]  = {
-	{KE_KEY, 0x101, KEY_MUTE},
-	{KE_KEY, 0x102, KEY_ZOOMOUT},
-	{KE_KEY, 0x103, KEY_ZOOMIN},
-	{KE_KEY, 0x13b, KEY_COFFEE},
-	{KE_KEY, 0x13c, KEY_BATTERY},
-	{KE_KEY, 0x13d, KEY_SLEEP},
-	{KE_KEY, 0x13e, KEY_SUSPEND},
-	{KE_KEY, 0x13f, KEY_SWITCHVIDEOMODE},
-	{KE_KEY, 0x140, KEY_BRIGHTNESSDOWN},
-	{KE_KEY, 0x141, KEY_BRIGHTNESSUP},
-	{KE_KEY, 0x142, KEY_WLAN},
-	{KE_KEY, 0x143, KEY_PROG1},
-	{KE_KEY, 0xb05, KEY_PROG2},
-	{KE_KEY, 0xb06, KEY_WWW},
-	{KE_KEY, 0xb07, KEY_MAIL},
-	{KE_KEY, 0xb30, KEY_STOP},
-	{KE_KEY, 0xb31, KEY_PREVIOUSSONG},
-	{KE_KEY, 0xb32, KEY_NEXTSONG},
-	{KE_KEY, 0xb33, KEY_PLAYPAUSE},
-	{KE_KEY, 0xb5a, KEY_MEDIA},
-	{KE_END, 0, 0},
+static const struct input_device_id toshiba_acpi_ids[] = {
+	{
+		.bustype = BUS_I8042,
+		.vendor = 0x0001,
+		.product = 0x1,
+		.evbit = { BIT(EV_KEY) },
+		.flags = INPUT_DEVICE_ID_MATCH_BUS |
+			 INPUT_DEVICE_ID_MATCH_VENDOR |
+			 INPUT_DEVICE_ID_MATCH_PRODUCT |
+			 INPUT_DEVICE_ID_MATCH_EVBIT,
+	},
+	{ },
 };

 /* utility
@@ -163,7 +188,6 @@

 /* acpi interface wrappers
  */
-
 static int is_valid_acpi_path(const char *methodName)
 {
 	acpi_handle handle;
@@ -173,6 +197,45 @@
 	return !ACPI_FAILURE(status);
 }

+static acpi_status execute_acpi_method(acpi_handle handle, char *method,
+				       const int *param, int *result)
+{
+	struct acpi_object_list args_list;
+	struct acpi_buffer buff;
+	union acpi_object in_obj, out_obj;
+	acpi_status status;
+
+	if (param) {
+		args_list.count = 1;
+		args_list.pointer = &in_obj;
+		in_obj.type = ACPI_TYPE_INTEGER;
+		in_obj.integer.value = *param;
+	} else
+		args_list.count = 0;
+
+	buff.length = sizeof(out_obj);
+	buff.pointer = &out_obj;
+
+	status = acpi_evaluate_object(handle, method, &args_list, &buff);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_ERR
+		       "ACPI method (%s) execution failed\n", method);
+		return -EINVAL;
+	}
+
+	if (!result)
+		return status;
+
+	if (out_obj.type != ACPI_TYPE_INTEGER) {
+		printk(MY_ERR
+		       "ACPI method result is not a number\n");
+		return -EINVAL;
+	}
+
+	*result = out_obj.integer.value;
+	return status;
+}
+
 static int write_acpi_int(const char *methodName, int val)
 {
 	struct acpi_object_list params;
@@ -289,8 +352,12 @@
 	struct platform_device *p_dev;
 	struct rfkill *bt_rfk;
 	struct input_dev *hotkey_dev;
+	struct work_struct hotkey_work;
 	int illumination_installed;
 	acpi_handle handle;
+	acpi_handle ec_handle;
+	acpi_handle video_handle;
+	bool spfc;

 	const char *bt_name;

@@ -366,7 +433,7 @@
 	acpi_status status;
 	enum led_brightness result;

-	/*Â First request : initialize communication. */
+	/* First request : initialize communication. */
 	in[0] = 0xf100;
 	status = hci_raw(in, out);
 	if (ACPI_FAILURE(status)) {
@@ -504,14 +571,23 @@

 static int get_lcd(struct backlight_device *bd)
 {
+	acpi_status status;
+	acpi_integer val;
 	u32 hci_result;
 	u32 value;

-	hci_read1(HCI_LCD_BRIGHTNESS, &value, &hci_result);
-	if (hci_result == HCI_SUCCESS) {
-		return (value >> HCI_LCD_BRIGHTNESS_SHIFT);
-	} else
-		return -EFAULT;
+	if (toshiba_acpi.spfc && toshiba_acpi.video_handle) {
+		status = acpi_evaluate_integer(toshiba_acpi.video_handle,
+					       "_BQC", NULL, &val);
+		if (ACPI_SUCCESS(status))
+			return val;
+	} else {
+		hci_read1(HCI_LCD_BRIGHTNESS, &value, &hci_result);
+		if (hci_result == HCI_SUCCESS)
+			return (value >> HCI_LCD_BRIGHTNESS_SHIFT);
+	}
+
+	return -EFAULT;
 }

 static int lcd_proc_show(struct seq_file *m, void *v)
@@ -536,14 +612,29 @@

 static int set_lcd(int value)
 {
+	struct acpi_object_list param;
+	union acpi_object in_obj;
+	acpi_status status;
 	u32 hci_result;

-	value = value << HCI_LCD_BRIGHTNESS_SHIFT;
-	hci_write1(HCI_LCD_BRIGHTNESS, value, &hci_result);
-	if (hci_result != HCI_SUCCESS)
-		return -EFAULT;
+	if (toshiba_acpi.spfc && toshiba_acpi.video_handle) {
+		param.count = 1;
+		param.pointer = &in_obj;
+		in_obj.type = ACPI_TYPE_INTEGER;
+		in_obj.integer.value = value;

-	return 0;
+		status = acpi_evaluate_integer(toshiba_acpi.video_handle,
+					       "_BCM", &param, NULL);
+		if (ACPI_FAILURE(status))
+			return -EFAULT;
+	} else {
+		value = value << HCI_LCD_BRIGHTNESS_SHIFT;
+		hci_write1(HCI_LCD_BRIGHTNESS, value, &hci_result);
+		if (hci_result != HCI_SUCCESS)
+			return -EFAULT;
+	}
+
+	return 0;
 }

 static int set_lcd_status(struct backlight_device *bd)
@@ -852,89 +943,147 @@
         .update_status  = set_lcd_status,
 };

-static struct key_entry *toshiba_acpi_get_entry_by_scancode(unsigned int code)
+static void toshiba_input_event(struct input_handle *handle, unsigned int type,
+			     unsigned int code, int value)
 {
-	struct key_entry *key;
-
-	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
-		if (code == key->code)
-			return key;
-
-	return NULL;
+	if (type == EV_MSC && code == MSC_SCAN && value == TOSHIBA_FN_SCAN)
+		schedule_work(&((struct toshiba_acpi_dev *)handle->private)->hotkey_work);
 }

-static struct key_entry *toshiba_acpi_get_entry_by_keycode(unsigned int code)
+static int toshiba_input_connect(struct input_handler *handler,
+				 struct input_dev *dev,
+				 const struct input_device_id *id)
 {
-	struct key_entry *key;
+	struct input_handle *handle;
+	int error;

-	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
-		if (code == key->keycode && key->type == KE_KEY)
-			return key;
+	if (!strcmp(dev->phys, I8042_KBD_PHYS_DESC))
+		return -ENODEV;

-	return NULL;
+	if (dev->grab)
+		printk(MY_ERR
+		       "Input device id grabbed by %s, Fn hotkeys will not work\n",
+		       dev->grab->name);
+
+	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "toshiba_acpi";
+	handle->private = handler->private;
+
+	error = input_register_handle(handle);
+	if (error) {
+		printk(MY_ERR
+		       "Failed to register input handle\n");
+		goto free_handle;
+	}
+
+	error = input_open_device(handle);
+	if (error) {
+		printk(MY_ERR
+		       "Failed to open input device handle\n");
+		goto unregister_handle;
+	}
+
+	return 0;
+
+unregister_handle:
+	input_unregister_handle(handle);
+free_handle:
+	kfree(handle);
+
+	return error;
 }

-static int toshiba_acpi_getkeycode(struct input_dev *dev,
-				   unsigned int scancode, unsigned int *keycode)
+static void toshiba_input_disconnect(struct input_handle * handle)
 {
-	struct key_entry *key = toshiba_acpi_get_entry_by_scancode(scancode);
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(handle);
+}

-	if (key && key->type == KE_KEY) {
-		*keycode = key->keycode;
-		return 0;
+static struct input_handler toshiba_input_handler = {
+	.name = "toshiba_acpi",
+	.event = toshiba_input_event,
+	.connect = toshiba_input_connect,
+	.disconnect = toshiba_input_disconnect,
+	.id_table = toshiba_acpi_ids,
+};
+
+static acpi_status get_spfc_events(int *hotkey)
+{
+	acpi_status status;
+
+	/* Some models (Satellite X205, A135, NB600, among others) need
+	 * to call the NTFY method first in order to get the hotkey events.
+	 * But not all (TOS1900) models implement this.
+	 */
+	if (toshiba_acpi.ec_handle != NULL) {
+		status = execute_acpi_method(toshiba_acpi.ec_handle,
+			  NOTIFY_METHOD, NULL, NULL);
+		if (ACPI_FAILURE(status)) {
+			printk(MY_ERR "ACPI method (%s) execution failed\n",
+				  NOTIFY_METHOD);
+			return -EIO;
+		}
 	}

-	return -EINVAL;
+	/* Now we can poll the INFO method to get last pressed hotkey */
+	status = execute_acpi_method(toshiba_acpi.handle,
+			  EVENTS_METHOD, NULL, hotkey);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_ERR "ACPI method (%s) execution failed\n",
+			  EVENTS_METHOD);
+		return -EIO;
+	}
+
+	return status;
 }

-static int toshiba_acpi_setkeycode(struct input_dev *dev,
-				   unsigned int scancode, unsigned int keycode)
+static void handle_spfc_hotkeys(struct work_struct *work)
 {
-	struct key_entry *key;
-	unsigned int old_keycode;
+	acpi_status status;
+	struct input_dev *input_dev;
+	int hotkey;

-	key = toshiba_acpi_get_entry_by_scancode(scancode);
-	if (key && key->type == KE_KEY) {
-		old_keycode = key->keycode;
-		key->keycode = keycode;
-		set_bit(keycode, dev->keybit);
-		if (!toshiba_acpi_get_entry_by_keycode(old_keycode))
-			clear_bit(old_keycode, dev->keybit);
-		return 0;
+	status = get_spfc_events(&hotkey);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_ERR "Failed to get hotkey event\n");
+		return;
 	}

-	return -EINVAL;
+	/* We only care about a key press */
+	if ((hotkey == 0x100) || (hotkey & 0x80))
+		return;
+
+	input_dev = container_of(work, struct toshiba_acpi_dev,
+				 hotkey_work)->hotkey_dev;
+	if (!sparse_keymap_report_event(input_dev,
+				  hotkey, 1, true))
+		printk(MY_INFO "Unknown key %x\n", hotkey);
 }

 static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 {
 	u32 hci_result, value;
-	struct key_entry *key;

 	if (event != 0x80)
 		return;
 	do {
 		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
 		if (hci_result == HCI_SUCCESS) {
-			if (value == 0x100)
-				continue;
 			/* act on key press; ignore key release */
-			if (value & 0x80)
+			if ((value == 0x100) || (value & 0x80))
 				continue;

-			key = toshiba_acpi_get_entry_by_scancode
-				(value);
-			if (!key) {
+			if (!sparse_keymap_report_event(toshiba_acpi.hotkey_dev,
+					     value, 1, true)) {
 				printk(MY_INFO "Unknown key %x\n",
 				       value);
-				continue;
 			}
-			input_report_key(toshiba_acpi.hotkey_dev,
-					 key->keycode, 1);
-			input_sync(toshiba_acpi.hotkey_dev);
-			input_report_key(toshiba_acpi.hotkey_dev,
-					 key->keycode, 0);
-			input_sync(toshiba_acpi.hotkey_dev);
 		} else if (hci_result == HCI_NOT_SUPPORTED) {
 			/* This is a workaround for an unresolved issue on
 			 * some machines where system events sporadically
@@ -943,33 +1092,67 @@
 			printk(MY_NOTICE "Re-enabled hotkeys\n");
 		}
 	} while (hci_result != HCI_EMPTY);
+	
 }

-static int toshiba_acpi_setup_keyboard(char *device)
+static int set_ec_handle(void)
 {
 	acpi_status status;
-	acpi_handle handle;
-	int result;
-	const struct key_entry *key;
+	char *ec_device;

-	status = acpi_get_handle(NULL, device, &handle);
+	if (is_valid_acpi_path(EC_INTERFACE_1 "." NOTIFY_METHOD))
+		ec_device = EC_INTERFACE_1;
+	else if (is_valid_acpi_path(EC_INTERFACE_2 "." NOTIFY_METHOD))
+		ec_device = EC_INTERFACE_2;
+	else if (is_valid_acpi_path(EC_INTERFACE_3 "." NOTIFY_METHOD))
+		ec_device = EC_INTERFACE_3;
+	else {
+		printk(MY_NOTICE "No known EC interface found.\n");
+		return -ENODEV;
+	}
+
+	status = acpi_get_handle(NULL, ec_device, &toshiba_acpi.ec_handle);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to get notification device\n");
+		printk(MY_INFO "Unable to get EC device handle\n");
 		return -ENODEV;
 	}
+	printk(MY_INFO "    EC device handle: %s\n", ec_device);

-	toshiba_acpi.handle = handle;
+	return 0;
+}

-	status = acpi_evaluate_object(handle, "ENAB", NULL, NULL);
+static int set_spfc_video(void)
+{
+	acpi_status status;
+	char *video_device;
+
+	if (is_valid_acpi_path(TOSH_VIDEO_INTERFACE_1))
+		video_device = TOSH_VIDEO_INTERFACE_1;
+	else if (is_valid_acpi_path(TOSH_VIDEO_INTERFACE_2))
+		video_device = TOSH_VIDEO_INTERFACE_2;
+	else {
+		printk(MY_NOTICE "No known SPFC video interface found.\n");
+		return -ENODEV;
+	}
+
+	status = acpi_get_handle(NULL, video_device, &toshiba_acpi.video_handle);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to enable hotkeys\n");
+		printk(MY_INFO "Unable to get SPFC video device handle\n");
 		return -ENODEV;
 	}
+	printk(MY_INFO "    Video device handle: %s\n", video_device);

-	status = acpi_install_notify_handler(handle, ACPI_DEVICE_NOTIFY,
-					      toshiba_acpi_notify, NULL);
+	return 0;
+}
+
+static int __init toshiba_acpi_setup_keyboard(char *device)
+{
+	acpi_status status;
+	int error;
+
+	status = acpi_get_handle(NULL, device, &toshiba_acpi.handle);
 	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to install hotkey notification\n");
+		printk(MY_INFO "Unable to get notification device\n");
 		return -ENODEV;
 	}

@@ -982,27 +1165,78 @@
 	toshiba_acpi.hotkey_dev->name = "Toshiba input device";
 	toshiba_acpi.hotkey_dev->phys = device;
 	toshiba_acpi.hotkey_dev->id.bustype = BUS_HOST;
-	toshiba_acpi.hotkey_dev->getkeycode = toshiba_acpi_getkeycode;
-	toshiba_acpi.hotkey_dev->setkeycode = toshiba_acpi_setkeycode;
+	toshiba_acpi.hotkey_dev->id.vendor = PCI_VENDOR_ID_TOSHIBA;

-	for (key = toshiba_acpi_keymap; key->type != KE_END; key++) {
-		set_bit(EV_KEY, toshiba_acpi.hotkey_dev->evbit);
-		set_bit(key->keycode, toshiba_acpi.hotkey_dev->keybit);
-	}
+	error = sparse_keymap_setup(toshiba_acpi.hotkey_dev,
+			  toshiba_acpi_keymap, NULL);
+	if (error)
+		goto err_free_dev;

-	result = input_register_device(toshiba_acpi.hotkey_dev);
-	if (result) {
-		printk(MY_INFO "Unable to register input device\n");
-		return result;
+	if (toshiba_acpi.spfc) {
+		status = acpi_evaluate_object(toshiba_acpi.handle, "ENAB", NULL, NULL);
+		if (ACPI_FAILURE(status)) {
+			printk(MY_INFO "Unable to enable hotkeys\n");
+			error = -ENODEV;
+			goto err_free_keymap;
+		}
+
+		error = input_register_device(toshiba_acpi.hotkey_dev);
+		if (error) {
+			printk(MY_ERR "Unable to register input device\n");
+			goto err_free_dev;
+		}
+	
+		INIT_WORK(&toshiba_acpi.hotkey_work, handle_spfc_hotkeys);
+
+		toshiba_input_handler.private = &toshiba_acpi;
+
+		error = input_register_handler(&toshiba_input_handler);
+		if (error) {
+			printk(MY_ERR "Failed to register input device handler\n");
+			goto err_free_keymap;
+		}
+	} else {
+		status = acpi_install_notify_handler(toshiba_acpi.handle,
+				  ACPI_DEVICE_NOTIFY, toshiba_acpi_notify, NULL);
+		if (ACPI_FAILURE(status)) {
+			printk(MY_INFO "Unable to install hotkey notification\n");
+			error = -ENODEV;
+			goto err_free_keymap;
+		}
+
+		error = input_register_device(toshiba_acpi.hotkey_dev);
+		if (error) {
+			printk(MY_INFO "Unable to register input device\n");
+			goto err_remove_notify;
+		}
 	}

 	return 0;
+
+err_remove_notify:
+	acpi_remove_notify_handler(toshiba_acpi.handle,
+		  ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
+err_free_keymap:
+	sparse_keymap_free(toshiba_acpi.hotkey_dev);
+err_free_dev:
+	input_free_device(toshiba_acpi.hotkey_dev);
+	toshiba_acpi.hotkey_dev = NULL;
+	return error;
 }

 static void toshiba_acpi_exit(void)
 {
-	if (toshiba_acpi.hotkey_dev)
+	if (toshiba_acpi.hotkey_dev) {
+		if (toshiba_acpi.spfc) {
+			flush_scheduled_work();
+			input_unregister_handler(&toshiba_input_handler);
+		} else {
+			acpi_remove_notify_handler(toshiba_acpi.handle,
+				  ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
+		}
+		sparse_keymap_free(toshiba_acpi.hotkey_dev);
 		input_unregister_device(toshiba_acpi.hotkey_dev);
+	}

 	if (toshiba_acpi.bt_rfk) {
 		rfkill_unregister(toshiba_acpi.bt_rfk);
@@ -1017,13 +1251,11 @@
 	if (toshiba_proc_dir)
 		remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);

-	acpi_remove_notify_handler(toshiba_acpi.handle, ACPI_DEVICE_NOTIFY,
-				   toshiba_acpi_notify);
-
 	if (toshiba_acpi.illumination_installed)
 		led_classdev_unregister(&toshiba_led);

-	platform_device_unregister(toshiba_acpi.p_dev);
+	if (toshiba_acpi.p_dev)
+		platform_device_unregister(toshiba_acpi.p_dev);

 	return;
 }
@@ -1041,10 +1273,17 @@
 	/* simple device detection: look for HCI method */
 	if (is_valid_acpi_path(TOSH_INTERFACE_1 GHCI_METHOD)) {
 		method_hci = TOSH_INTERFACE_1 GHCI_METHOD;
+		toshiba_acpi.spfc = false;
 		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_1))
 			printk(MY_INFO "Unable to activate hotkeys\n");
 	} else if (is_valid_acpi_path(TOSH_INTERFACE_2 GHCI_METHOD)) {
 		method_hci = TOSH_INTERFACE_2 GHCI_METHOD;
+		toshiba_acpi.spfc = false;
+		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
+			printk(MY_INFO "Unable to activate hotkeys\n");
+	} else if (is_valid_acpi_path(TOSH_INTERFACE_2 SPFC_METHOD)) {
+		method_hci = TOSH_INTERFACE_2 SPFC_METHOD;
+		toshiba_acpi.spfc = true;
 		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
 			printk(MY_INFO "Unable to activate hotkeys\n");
 	} else
@@ -1072,6 +1311,26 @@
 	/* enable event fifo */
 	hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);

+	/* TOS1900 models hotkey activation */
+	if (toshiba_acpi.spfc) {
+		/* Some TOS1900 models don't implement the ENAB method,
+		 * and hotkeys activation goes by calling HCI_HOTKEY_EVENT
+		 */
+		hci_write1(HCI_HOTKEY_EVENT, 1, &hci_result);
+		/* The EC handle must be set for models without
+		 * the ENAB method so they can access the NOTIFY method,
+		 * and thus, access the INFO method...
+		 */
+		if (set_ec_handle())
+			toshiba_acpi.ec_handle = NULL;
+		/* Now we set the video handle for known TOS1900 devices */
+		if (set_spfc_video())
+			toshiba_acpi.video_handle = NULL;
+	} else {
+		toshiba_acpi.ec_handle = NULL;
+		toshiba_acpi.video_handle = NULL;
+	}
+
 	toshiba_proc_dir = proc_mkdir(PROC_TOSHIBA, acpi_root_dir);
 	if (!toshiba_proc_dir) {
 		toshiba_acpi_exit();
@@ -1082,11 +1341,11 @@

 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 	toshiba_backlight_device = backlight_device_register("toshiba",
-							     &toshiba_acpi.p_dev->dev,
-							     NULL,
-							     &toshiba_backlight_data,
-							     &props);
-        if (IS_ERR(toshiba_backlight_device)) {
+						     &toshiba_acpi.p_dev->dev,
+						     NULL,
+						     &toshiba_backlight_data,
+						     &props);
+	if (IS_ERR(toshiba_backlight_device)) {
 		ret = PTR_ERR(toshiba_backlight_device);

 		printk(KERN_ERR "Could not register toshiba backlight device\n");


-- 
-- El mundo apesta y vosotros apestais tambien --
