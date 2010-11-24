Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0KXTRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:17:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60925 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab0KXTRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:17:16 -0500
Date: Wed, 24 Nov 2010 19:17:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: toshiba_acpi.c: Full TOS1900 device support
Message-ID: <20101124191711.GA6198@srcf.ucam.org>
References: <AANLkTikff5b9zhCLEmyoHZPTPaREuHE1qp21SLA0v=83@mail.gmail.com> <20101026192028.GA17880@srcf.ucam.org> <AANLkTinmsNzAkp_ZGcaNyVRVMu0Rc4-C+xPKuSOS5jRJ@mail.gmail.com> <20101027192913.GA14828@srcf.ucam.org> <AANLkTin94udpwFkH+yqH95fu9Q=WCu2u80_DaHHp+zyR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin94udpwFkH+yqH95fu9Q=WCu2u80_DaHHp+zyR@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you try this (entirely untested) patch and see if it works on your 
system? It's basically your code, but with some of the conditionals 
cleaned up when we already know that information.

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 4276da7..bd4a30e 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -51,6 +51,9 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/sysdev.h>
+#include <linux/workqueue.h>
+#include <linux/i8042.h>
 
 #include <asm/uaccess.h>
 
@@ -67,10 +70,9 @@ MODULE_LICENSE("GPL");
 
 /* Toshiba ACPI method paths */
 #define METHOD_LCD_BRIGHTNESS	"\\_SB_.PCI0.VGA_.LCD_._BCM"
-#define TOSH_INTERFACE_1	"\\_SB_.VALD"
-#define TOSH_INTERFACE_2	"\\_SB_.VALZ"
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
-#define GHCI_METHOD		".GHCI"
+
+#define TOSHIBA_FN_SCAN		0x6e
 
 /* Toshiba HCI interface definitions
  *
@@ -114,10 +116,45 @@ MODULE_LICENSE("GPL");
 #define HCI_WIRELESS_BT_ATTACH		0x40
 #define HCI_WIRELESS_BT_POWER		0x80
 
+struct acpi_ec {
+        acpi_handle handle;
+        unsigned long gpe;
+        unsigned long command_addr;
+        unsigned long data_addr;
+        unsigned long global_lock;
+        unsigned long flags;
+        struct mutex lock;
+        wait_queue_head_t wait;
+        struct list_head list;
+        struct transaction *curr;
+        spinlock_t curr_lock;
+        struct sys_device sysdev;
+};
+
+extern struct acpi_ec *first_ec;
+
+struct toshiba_acpi_dev {
+	struct platform_device *p_dev;
+	struct acpi_device *acpi_dev;
+	struct rfkill *bt_rfk;
+	struct input_dev *hotkey_dev;
+	struct work_struct hotkey_work;
+	int illumination_installed;
+	acpi_handle handle;
+
+	const char *bt_name;
+
+	struct mutex mutex;
+};
+
+static struct toshiba_acpi_dev toshiba_acpi = {
+	.bt_name = "Toshiba Bluetooth",
+};
+
 static const struct acpi_device_id toshiba_device_ids[] = {
 	{"TOS6200", 0},
 	{"TOS6208", 0},
-	{"TOS1900", 0},
+	{"TOS1900", 1},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
@@ -158,15 +195,6 @@ static __inline__ void _set_bit(u32 * word, u32 mask, int value)
 /* acpi interface wrappers
  */
 
-static int is_valid_acpi_path(const char *methodName)
-{
-	acpi_handle handle;
-	acpi_status status;
-
-	status = acpi_get_handle(NULL, (char *)methodName, &handle);
-	return !ACPI_FAILURE(status);
-}
-
 static int write_acpi_int(const char *methodName, int val)
 {
 	struct acpi_object_list params;
@@ -199,8 +227,6 @@ static int read_acpi_int(const char *methodName, int *pVal)
 }
 #endif
 
-static const char *method_hci /*= 0*/ ;
-
 /* Perform a raw HCI call.  Here we don't care about input or output buffer
  * format.
  */
@@ -223,8 +249,8 @@ static acpi_status hci_raw(const u32 in[HCI_WORDS], u32 out[HCI_WORDS])
 	results.length = sizeof(out_objs);
 	results.pointer = out_objs;
 
-	status = acpi_evaluate_object(NULL, (char *)method_hci, &params,
-				      &results);
+	status = acpi_evaluate_object(toshiba_acpi.acpi_dev->handle, "GHCI",
+				      &params, &results);
 	if ((status == AE_OK) && (out_objs->package.count <= HCI_WORDS)) {
 		for (i = 0; i < out_objs->package.count; ++i) {
 			out[i] = out_objs->package.elements[i].integer.value;
@@ -279,18 +305,6 @@ static acpi_status hci_read2(u32 reg, u32 *out1, u32 *out2, u32 *result)
 	return status;
 }
 
-struct toshiba_acpi_dev {
-	struct platform_device *p_dev;
-	struct rfkill *bt_rfk;
-	struct input_dev *hotkey_dev;
-	int illumination_installed;
-	acpi_handle handle;
-
-	const char *bt_name;
-
-	struct mutex mutex;
-};
-
 /* Illumination support */
 static int toshiba_illumination_available(void)
 {
@@ -395,10 +409,6 @@ static struct led_classdev toshiba_led = {
 	.brightness_get = toshiba_illumination_get,
 };
 
-static struct toshiba_acpi_dev toshiba_acpi = {
-	.bt_name = "Toshiba Bluetooth",
-};
-
 /* Bluetooth rfkill handlers */
 
 static u32 hci_get_bt_present(bool *present)
@@ -846,26 +856,118 @@ static struct backlight_ops toshiba_backlight_data = {
         .update_status  = set_lcd_status,
 };
 
-static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
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
+	} else {
+		args_list.count = 0;
+	}
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
+static bool toshiba_i8042_filter(unsigned char data, unsigned char str,
+				 struct serio *port)
+{
+	if (str & 0x20)
+		return false;
+
+	if (unlikely(data == 0xe0))
+		return false;
+
+	if ((data & 0x7f) == TOSHIBA_FN_SCAN)
+		schedule_work(&toshiba_acpi.hotkey_work);
+
+	return false;
+}
+
+static int toshiba_acpi_query_event(int *hotkey)
+{
+	acpi_status status;
+
+	if (!first_ec)
+		return -ENODEV;
+
+	status = execute_acpi_method(first_ec->handle, "NTFY", NULL, NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_ERR "Unable to query EC\n");
+		return -EIO;
+	}
+
+	status = execute_acpi_method(first_ec->handle, "INFO", NULL, hotkey);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_ERR "Unable to request hotkey from EC\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void toshiba_report_input_event(int value)
+{
+	if (value == 0x100)
+		return;
+	/* act on key press; ignore key release */
+	if (value & 0x80)
+		return;
+
+	if (!sparse_keymap_report_event(toshiba_acpi.hotkey_dev, value, 1,
+					true)) {
+		printk(MY_INFO "Unknown key %x\n", value);
+	}
+}
+
+static void toshiba_acpi_work(struct work_struct *work)
+{
+	int hotkey;
+
+	if (toshiba_acpi_query_event(&hotkey))
+		printk(MY_ERR "Failed to get hotkey events\n");
+	else
+		toshiba_report_input_event(hotkey);
+}
+
+static void toshiba_acpi_notify(struct acpi_device *device, u32 event)
 {
 	u32 hci_result, value;
 
 	if (event != 0x80)
 		return;
+
 	do {
 		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
 		if (hci_result == HCI_SUCCESS) {
-			if (value == 0x100)
-				continue;
-			/* act on key press; ignore key release */
-			if (value & 0x80)
-				continue;
-
-			if (!sparse_keymap_report_event(toshiba_acpi.hotkey_dev,
-							value, 1, true)) {
-				printk(MY_INFO "Unknown key %x\n",
-				       value);
-			}
+			toshiba_report_input_event(value);
 		} else if (hci_result == HCI_NOT_SUPPORTED) {
 			/* This is a workaround for an unresolved issue on
 			 * some machines where system events sporadically
@@ -874,19 +976,15 @@ static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 			printk(MY_NOTICE "Re-enabled hotkeys\n");
 		}
 	} while (hci_result != HCI_EMPTY);
+
+
 }
 
-static int __init toshiba_acpi_setup_keyboard(char *device)
+static int __init toshiba_acpi_setup_keyboard(int type)
 {
 	acpi_status status;
 	int error;
 
-	status = acpi_get_handle(NULL, device, &toshiba_acpi.handle);
-	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to get notification device\n");
-		return -ENODEV;
-	}
-
 	toshiba_acpi.hotkey_dev = input_allocate_device();
 	if (!toshiba_acpi.hotkey_dev) {
 		printk(MY_INFO "Unable to register input device\n");
@@ -894,7 +992,7 @@ static int __init toshiba_acpi_setup_keyboard(char *device)
 	}
 
 	toshiba_acpi.hotkey_dev->name = "Toshiba input device";
-	toshiba_acpi.hotkey_dev->phys = device;
+	toshiba_acpi.hotkey_dev->phys = "acpi/toshiba";
 	toshiba_acpi.hotkey_dev->id.bustype = BUS_HOST;
 
 	error = sparse_keymap_setup(toshiba_acpi.hotkey_dev,
@@ -902,33 +1000,35 @@ static int __init toshiba_acpi_setup_keyboard(char *device)
 	if (error)
 		goto err_free_dev;
 
-	status = acpi_install_notify_handler(toshiba_acpi.handle,
-				ACPI_DEVICE_NOTIFY, toshiba_acpi_notify, NULL);
-	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to install hotkey notification\n");
-		error = -ENODEV;
-		goto err_free_keymap;
+	if (type == 1) {
+		error = i8042_install_filter(toshiba_i8042_filter);
+		if (error) {
+			printk(MY_ERR "Unable to install key filter\n");
+			goto err_free_keymap;
+		}
+
+		INIT_WORK(&toshiba_acpi.hotkey_work, toshiba_acpi_work);
 	}
 
-	status = acpi_evaluate_object(toshiba_acpi.handle, "ENAB", NULL, NULL);
+	status = acpi_evaluate_object(toshiba_acpi.acpi_dev->handle, "ENAB",
+				      NULL, NULL);
 	if (ACPI_FAILURE(status)) {
 		printk(MY_INFO "Unable to enable hotkeys\n");
 		error = -ENODEV;
-		goto err_remove_notify;
+		goto err_free_keymap;
 	}
 
 	error = input_register_device(toshiba_acpi.hotkey_dev);
 	if (error) {
 		printk(MY_INFO "Unable to register input device\n");
-		goto err_remove_notify;
+		goto err_free_keymap;
 	}
 
 	return 0;
 
- err_remove_notify:
-	acpi_remove_notify_handler(toshiba_acpi.handle,
-				   ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
  err_free_keymap:
+	if (type == 1)
+		i8042_remove_filter(toshiba_i8042_filter);
 	sparse_keymap_free(toshiba_acpi.hotkey_dev);
  err_free_dev:
 	input_free_device(toshiba_acpi.hotkey_dev);
@@ -936,11 +1036,9 @@ static int __init toshiba_acpi_setup_keyboard(char *device)
 	return error;
 }
 
-static void toshiba_acpi_exit(void)
+static void toshiba_acpi_cleanup(void)
 {
 	if (toshiba_acpi.hotkey_dev) {
-		acpi_remove_notify_handler(toshiba_acpi.handle,
-				ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
 		sparse_keymap_free(toshiba_acpi.hotkey_dev);
 		input_unregister_device(toshiba_acpi.hotkey_dev);
 	}
@@ -966,54 +1064,44 @@ static void toshiba_acpi_exit(void)
 	return;
 }
 
-static int __init toshiba_acpi_init(void)
+static int toshiba_acpi_remove(struct acpi_device *device, int type)
+{
+	toshiba_acpi_cleanup();
+
+	return 0;
+}
+
+static int __devinit toshiba_acpi_add(struct acpi_device *device)
 {
 	u32 hci_result;
 	bool bt_present;
 	int ret = 0;
 	struct backlight_properties props;
 
-	if (acpi_disabled)
-		return -ENODEV;
-
-	/* simple device detection: look for HCI method */
-	if (is_valid_acpi_path(TOSH_INTERFACE_1 GHCI_METHOD)) {
-		method_hci = TOSH_INTERFACE_1 GHCI_METHOD;
-		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_1))
-			printk(MY_INFO "Unable to activate hotkeys\n");
-	} else if (is_valid_acpi_path(TOSH_INTERFACE_2 GHCI_METHOD)) {
-		method_hci = TOSH_INTERFACE_2 GHCI_METHOD;
-		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
-			printk(MY_INFO "Unable to activate hotkeys\n");
-	} else
-		return -ENODEV;
-
 	printk(MY_INFO "Toshiba Laptop ACPI Extras version %s\n",
 	       TOSHIBA_ACPI_VERSION);
-	printk(MY_INFO "    HCI method: %s\n", method_hci);
 
 	mutex_init(&toshiba_acpi.mutex);
 
-	toshiba_acpi.p_dev = platform_device_register_simple("toshiba_acpi",
-							      -1, NULL, 0);
-	if (IS_ERR(toshiba_acpi.p_dev)) {
-		ret = PTR_ERR(toshiba_acpi.p_dev);
-		printk(MY_ERR "unable to register platform device\n");
-		toshiba_acpi.p_dev = NULL;
-		toshiba_acpi_exit();
-		return ret;
-	}
-
 	force_fan = 0;
 	key_event_valid = 0;
 
+	toshiba_acpi.acpi_dev = device;
+
+	ret = toshiba_acpi_setup_keyboard(device->device_type);
+
+	if (ret) {
+		printk(MY_ERR "Unable to setup hotkeys\n");
+		return ret;
+	}
+
 	/* enable event fifo */
 	hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
 
 	toshiba_proc_dir = proc_mkdir(PROC_TOSHIBA, acpi_root_dir);
 	if (!toshiba_proc_dir) {
-		toshiba_acpi_exit();
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	} else {
 		create_toshiba_proc_entries();
 	}
@@ -1029,8 +1117,7 @@ static int __init toshiba_acpi_init(void)
 
 		printk(KERN_ERR "Could not register toshiba backlight device\n");
 		toshiba_backlight_device = NULL;
-		toshiba_acpi_exit();
-		return ret;
+		goto out;
 	}
 
 	/* Register rfkill switch for Bluetooth */
@@ -1042,16 +1129,15 @@ static int __init toshiba_acpi_init(void)
 						   &toshiba_acpi);
 		if (!toshiba_acpi.bt_rfk) {
 			printk(MY_ERR "unable to allocate rfkill device\n");
-			toshiba_acpi_exit();
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto out;
 		}
 
 		ret = rfkill_register(toshiba_acpi.bt_rfk);
 		if (ret) {
 			printk(MY_ERR "unable to register rfkill device\n");
 			rfkill_destroy(toshiba_acpi.bt_rfk);
-			toshiba_acpi_exit();
-			return ret;
+			goto out;
 		}
 	}
 
@@ -1062,7 +1148,49 @@ static int __init toshiba_acpi_init(void)
 			toshiba_acpi.illumination_installed = 1;
 	}
 
-	return 0;
+out:
+	if (ret)
+		toshiba_acpi_cleanup();
+	return ret;
+}
+
+static struct acpi_driver toshiba_acpi_driver = {
+	.name = "Toshiba ACPI driver",
+	.owner = THIS_MODULE,
+	.ids = toshiba_device_ids,
+	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
+	.ops = {
+		.add = toshiba_acpi_add,
+		.remove = toshiba_acpi_remove,
+		.notify = toshiba_acpi_notify,
+	}
+};
+
+static int __init toshiba_acpi_init(void)
+{
+	int ret;
+
+	toshiba_acpi.p_dev = platform_device_register_simple("toshiba_acpi",
+							      -1, NULL, 0);
+	if (IS_ERR(toshiba_acpi.p_dev)) {
+		printk(MY_ERR "unable to register platform device\n");
+		return PTR_ERR(toshiba_acpi.p_dev);
+	}
+
+	ret = acpi_bus_register_driver(&toshiba_acpi_driver);
+
+	if (ret) {
+		printk(MY_ERR "unable to register acpi driver\n");
+		platform_device_unregister(toshiba_acpi.p_dev);
+	}
+
+	return ret;
+}	
+
+static void __exit toshiba_acpi_exit(void)
+{
+	acpi_bus_unregister_driver(&toshiba_acpi_driver);
+	platform_device_unregister(toshiba_acpi.p_dev);
 }
 
 module_init(toshiba_acpi_init);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
