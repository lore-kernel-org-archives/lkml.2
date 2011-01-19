Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1ASVFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:05:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46130 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab1ASVFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:05:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V/eq0wjL9YKJX3EwAZJiAvye6wPVVsi97sXd7I38bYg4ffIYOCRhQAe6cGSbZo6BTY
         0Jgbew+i9Fj7x0JLSW15o2wdds7YI07wuWeWDf3eRw6pBPslMNehM2FnN8wOqdweAVhA
         fsbkCYTvIZ8h6p4L3lsc8Z77nMW7aTaXYgXHQ=
MIME-Version: 1.0
In-Reply-To: <20110117190849.GB27245@core.coreip.homeip.net>
References: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
	<20110117190849.GB27245@core.coreip.homeip.net>
Date: Wed, 19 Jan 2011 14:05:10 -0700
Message-ID: <AANLkTindwH2X79vZTBHU04oomxqV=RchRVEwrDEcntVX@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Additional TOS1900 devices support
From: Azael Avalos <coproscefalo@gmail.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's version 2 of the previous patch.

So far I've found 2 types of TOS1900 devices:

1 - The ones that need the EC handle to access the NTFY method
(Satellite X205 series, Satellite A135 series, NB600, among others)
and send events via KBC (called HCI type 2)

2 - Another kind sending events via ACPI (called HCI type 3)

Both TOS1900 kinds need the HCI_HOTKEY_EVENTS call to work,
however, HCI type 3 needs also the ENAB method executed.


>> -static const struct key_entry toshiba_acpi_keymap[] __initconst = {
>> +static struct key_entry toshiba_acpi_keymap[]  = {
>
> Why are we losing constness here?

Sorry, my bad, corrected on this one.



>From 2cb24b10e0d60d5ba31df88f49e984d7b6ccb720 Mon Sep 17 00:00:00 2001
From: Azael Avalos <coproscefalo@gmail.com>
Date: Wed, 19 Jan 2011 13:58:16 -0700
Subject: [PATCH] toshiba_acpi: Additional TOS1900 devices support

Some TOS1900 devices send keycodes via KBD, a filter was added
along with a cleanup made by Matthew Garrett, also functions
and registers were added for the Toshiba Software
Configuration Interface (SCI) used by Illumination.
Bumping its version to 0.20

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/Kconfig        |    1 +
 drivers/platform/x86/toshiba_acpi.c |  644 ++++++++++++++++++++++++-----------
 2 files changed, 440 insertions(+), 205 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index faec777..56d1c3f 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -515,6 +515,7 @@ config ACPI_TOSHIBA
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
+	depends on SERIO_I8042
 	select INPUT_POLLDEV
 	select INPUT_SPARSEKMAP
 	---help---
diff --git a/drivers/platform/x86/toshiba_acpi.c
b/drivers/platform/x86/toshiba_acpi.c
index 4276da7..4d74117 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 2002-2004 John Belmonte
  *  Copyright (C) 2008 Philip Langdale
  *  Copyright (C) 2010 Pierre Ducroquet
+ *  Copyright (C) 2010 Azael Avalos
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -35,14 +36,13 @@
  *
  */

-#define TOSHIBA_ACPI_VERSION	"0.19"
+#define TOSHIBA_ACPI_VERSION	"0.20"
 #define PROC_INTERFACE_VERSION	1

 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
@@ -51,6 +51,9 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/sysdev.h>
+#include <linux/workqueue.h>
+#include <linux/i8042.h>

 #include <asm/uaccess.h>

@@ -66,11 +69,9 @@ MODULE_LICENSE("GPL");
 #define MY_INFO KERN_INFO MY_LOGPREFIX

 /* Toshiba ACPI method paths */
-#define METHOD_LCD_BRIGHTNESS	"\\_SB_.PCI0.VGA_.LCD_._BCM"
-#define TOSH_INTERFACE_1	"\\_SB_.VALD"
-#define TOSH_INTERFACE_2	"\\_SB_.VALZ"
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
-#define GHCI_METHOD		".GHCI"
+
+#define TOSHIBA_FN_SCAN		0x6e

 /* Toshiba HCI interface definitions
  *
@@ -84,23 +85,39 @@ MODULE_LICENSE("GPL");

 #define HCI_WORDS			6

-/* operations */
+/* HCI operations */
 #define HCI_SET				0xff00
 #define HCI_GET				0xfe00
-
-/* return codes */
+/* SCI operations */
+#define SCI_SUPPORT_CHECK		0xf000
+#define SCI_OPEN			0xf100
+#define SCI_CLOSE			0xf200
+#define SCI_SET				0xf400
+#define SCI_GET				0xf300
+
+/* HCI return codes */
 #define HCI_SUCCESS			0x0000
 #define HCI_FAILURE			0x1000
 #define HCI_NOT_SUPPORTED		0x8000
 #define HCI_EMPTY			0x8c00
-
-/* registers */
+/* SCI return codes */
+#define SCI_NOT_SUPPORTED		HCI_NOT_SUPPORTED
+#define SCI_ALREADY_OPEN		0x8100
+#define SCI_NOT_OPENED			0x8200
+#define SCI_INPUT_DATA_ERROR		0x8300
+#define SCI_NOT_PRESENT			0x8600
+#define SCI_NOT_INSTALLED		0x8e00
+
+/* HCI registers */
 #define HCI_FAN				0x0004
 #define HCI_SYSTEM_EVENT		0x0016
 #define HCI_VIDEO_OUT			0x001c
 #define HCI_HOTKEY_EVENT		0x001e
 #define HCI_LCD_BRIGHTNESS		0x002a
 #define HCI_WIRELESS			0x0056
+/* SCI registers */
+#define SCI_ILLUMINATION		0x014e
+#define SCI_ILLUM_TIMER			0x015c

 /* field definitions */
 #define HCI_LCD_BRIGHTNESS_BITS		3
@@ -114,6 +131,44 @@ MODULE_LICENSE("GPL");
 #define HCI_WIRELESS_BT_ATTACH		0x40
 #define HCI_WIRELESS_BT_POWER		0x80

+struct acpi_ec {
+	acpi_handle handle;
+	unsigned long gpe;
+	unsigned long command_addr;
+	unsigned long data_addr;
+	unsigned long global_lock;
+	unsigned long flags;
+	struct mutex lock;
+	wait_queue_head_t wait;
+	struct list_head list;
+	struct transaction *curr;
+	spinlock_t curr_lock;
+	struct sys_device sysdev;
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
+	int ntfy_method_present;
+
+	int hci_type;
+	char *hci_method;
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
@@ -123,9 +178,12 @@ static const struct acpi_device_id toshiba_device_ids[] = {
 MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);

 static const struct key_entry toshiba_acpi_keymap[] __initconst = {
+	{ KE_KEY, 0x100, { KEY_FN } },
 	{ KE_KEY, 0x101, { KEY_MUTE } },
 	{ KE_KEY, 0x102, { KEY_ZOOMOUT } },
 	{ KE_KEY, 0x103, { KEY_ZOOMIN } },
+	{ KE_KEY, 0x12c, { KEY_KBDILLUMTOGGLE } },
+	{ KE_KEY, 0x139, { KEY_ZOOMRESET } },
 	{ KE_KEY, 0x13b, { KEY_COFFEE } },
 	{ KE_KEY, 0x13c, { KEY_BATTERY } },
 	{ KE_KEY, 0x13d, { KEY_SLEEP } },
@@ -158,15 +216,6 @@ static __inline__ void _set_bit(u32 * word, u32
mask, int value)
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
@@ -179,28 +228,9 @@ static int write_acpi_int(const char *methodName, int val)
 	in_objs[0].integer.value = val;

 	status = acpi_evaluate_object(NULL, (char *)methodName, &params, NULL);
-	return (status == AE_OK);
+	return ACPI_SUCCESS(status);
 }

-#if 0
-static int read_acpi_int(const char *methodName, int *pVal)
-{
-	struct acpi_buffer results;
-	union acpi_object out_objs[1];
-	acpi_status status;
-
-	results.length = sizeof(out_objs);
-	results.pointer = out_objs;
-
-	status = acpi_evaluate_object(0, (char *)methodName, 0, &results);
-	*pVal = out_objs[0].integer.value;
-
-	return (status == AE_OK) && (out_objs[0].type == ACPI_TYPE_INTEGER);
-}
-#endif
-
-static const char *method_hci /*= 0*/ ;
-
 /* Perform a raw HCI call.  Here we don't care about input or output buffer
  * format.
  */
@@ -223,9 +253,10 @@ static acpi_status hci_raw(const u32
in[HCI_WORDS], u32 out[HCI_WORDS])
 	results.length = sizeof(out_objs);
 	results.pointer = out_objs;

-	status = acpi_evaluate_object(NULL, (char *)method_hci, &params,
-				      &results);
-	if ((status == AE_OK) && (out_objs->package.count <= HCI_WORDS)) {
+	status = acpi_evaluate_object(toshiba_acpi.acpi_dev->handle,
+				      toshiba_acpi.hci_method,
+				      &params, &results);
+	if ((ACPI_SUCCESS(status)) && (out_objs->package.count <= HCI_WORDS)) {
 		for (i = 0; i < out_objs->package.count; ++i) {
 			out[i] = out_objs->package.elements[i].integer.value;
 		}
@@ -245,7 +276,7 @@ static acpi_status hci_write1(u32 reg, u32 in1,
u32 * result)
 	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = hci_raw(in, out);
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
 	return status;
 }

@@ -255,7 +286,7 @@ static acpi_status hci_read1(u32 reg, u32 * out1,
u32 * result)
 	u32 out[HCI_WORDS];
 	acpi_status status = hci_raw(in, out);
 	*out1 = out[2];
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
 	return status;
 }

@@ -264,7 +295,7 @@ static acpi_status hci_write2(u32 reg, u32 in1,
u32 in2, u32 *result)
 	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = hci_raw(in, out);
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
 	return status;
 }

@@ -275,21 +306,60 @@ static acpi_status hci_read2(u32 reg, u32 *out1,
u32 *out2, u32 *result)
 	acpi_status status = hci_raw(in, out);
 	*out1 = out[2];
 	*out2 = out[3];
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
 	return status;
 }

-struct toshiba_acpi_dev {
-	struct platform_device *p_dev;
-	struct rfkill *bt_rfk;
-	struct input_dev *hotkey_dev;
-	int illumination_installed;
-	acpi_handle handle;
+/* sci functions */
+static int sci_present(void)
+{
+	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];

-	const char *bt_name;
+	/* Check system for SCI support */
+	in[0] = SCI_SUPPORT_CHECK;
+	hci_raw(in, out);
+	if (out[0] == SCI_NOT_PRESENT) {
+		printk(MY_INFO "Toshiba SCI not available\n");
+		return 0;
+	}

-	struct mutex mutex;
-};
+	return 1;
+}
+
+static int sci_open(void)
+{
+	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];
+
+	if (!sci_present())
+		return HCI_FAILURE;
+
+	in[0] = SCI_OPEN;
+	hci_raw(in, out);
+	if (out[0] == SCI_ALREADY_OPEN) {
+		printk(MY_NOTICE "Toshiba SCI already opened\n");
+		return HCI_SUCCESS;
+	}
+
+	return out[0];
+}
+
+static int sci_close(void)
+{
+	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];
+
+	if (!sci_present())
+		return HCI_FAILURE;
+
+	in[0] = SCI_CLOSE;
+	hci_raw(in, out);
+	if (out[0] == SCI_NOT_OPENED)
+		printk(MY_INFO "Toshiba SCI not opened\n");
+
+	return out[0];
+}

 /* Illumination support */
 static int toshiba_illumination_available(void)
@@ -297,15 +367,22 @@ static int toshiba_illumination_available(void)
 	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status;
+	int ret;
+
+	ret = sci_open();
+	if (ret == HCI_FAILURE) {
+		printk(MY_INFO "Could not open Toshiba SCI\n");
+		return 0;
+	}

-	in[0] = 0xf100;
+	in[0] = SCI_GET;
+	in[1] = SCI_ILLUMINATION;
 	status = hci_raw(in, out);
-	if (ACPI_FAILURE(status)) {
+	if (ACPI_FAILURE(status) || out[0] != HCI_SUCCESS) {
 		printk(MY_INFO "Illumination device not available\n");
 		return 0;
 	}
-	in[0] = 0xf400;
-	status = hci_raw(in, out);
+
 	return 1;
 }

@@ -316,75 +393,41 @@ static void toshiba_illumination_set(struct
led_classdev *cdev,
 	u32 out[HCI_WORDS];
 	acpi_status status;

-	/* First request : initialize communication. */
-	in[0] = 0xf100;
+	in[0] = SCI_SET;
+	in[1] = SCI_ILLUMINATION;
+	/* Switch the illumination on/off */
+	in[2] = (brightness) ? 1 : 0;
 	status = hci_raw(in, out);
-	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Illumination device not available\n");
+	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
+		printk(MY_ERR "ACPI call for illumination failed.\n");
 		return;
-	}
-
-	if (brightness) {
-		/* Switch the illumination on */
-		in[0] = 0xf400;
-		in[1] = 0x14e;
-		in[2] = 1;
-		status = hci_raw(in, out);
-		if (ACPI_FAILURE(status)) {
-			printk(MY_INFO "ACPI call for illumination failed.\n");
-			return;
-		}
-	} else {
-		/* Switch the illumination off */
-		in[0] = 0xf400;
-		in[1] = 0x14e;
-		in[2] = 0;
-		status = hci_raw(in, out);
-		if (ACPI_FAILURE(status)) {
-			printk(MY_INFO "ACPI call for illumination failed.\n");
-			return;
-		}
-	}
+	} else if (out[0] == SCI_NOT_SUPPORTED)
+		printk(MY_INFO "Illumination not supported\n");

-	/* Last request : close communication. */
-	in[0] = 0xf200;
-	in[1] = 0;
-	in[2] = 0;
-	hci_raw(in, out);
+	return;
 }

 static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 {
 	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
-	acpi_status status;
 	enum led_brightness result;
+	acpi_status status;

-	/* First request : initialize communication. */
-	in[0] = 0xf100;
-	status = hci_raw(in, out);
-	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Illumination device not available\n");
-		return LED_OFF;
-	}
-
+	in[0] = SCI_GET;
+	in[1] = SCI_ILLUMINATION;
 	/* Check the illumination */
-	in[0] = 0xf300;
-	in[1] = 0x14e;
 	status = hci_raw(in, out);
-	if (ACPI_FAILURE(status)) {
+	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		printk(MY_INFO "ACPI call for illumination failed.\n");
 		return LED_OFF;
+	} else if (out[0] == SCI_NOT_SUPPORTED) {
+		printk(MY_INFO "Illumination not supported\n");
+		return LED_OFF;
 	}

 	result = out[2] ? LED_FULL : LED_OFF;

-	/* Last request : close communication. */
-	in[0] = 0xf200;
-	in[1] = 0;
-	in[2] = 0;
-	hci_raw(in, out);
-
 	return result;
 }

@@ -395,10 +438,6 @@ static struct led_classdev toshiba_led = {
 	.brightness_get = toshiba_illumination_get,
 };

-static struct toshiba_acpi_dev toshiba_acpi = {
-	.bt_name = "Toshiba Bluetooth",
-};
-
 /* Bluetooth rfkill handlers */

 static u32 hci_get_bt_present(bool *present)
@@ -842,51 +881,150 @@ static void remove_toshiba_proc_entries(void)
 }

 static struct backlight_ops toshiba_backlight_data = {
-        .get_brightness = get_lcd,
-        .update_status  = set_lcd_status,
+	  .get_brightness = get_lcd,
+	  .update_status  = set_lcd_status,
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
+			"ACPI method (%s) execution failed\n", method);
+		return -EINVAL;
+	}
+
+	if (!result)
+		return status;
+
+	if (out_obj.type != ACPI_TYPE_INTEGER) {
+		printk(MY_ERR
+			"ACPI method result is not a number\n");
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
+	if ((data & 0x7f) == TOSHIBA_FN_SCAN) {
+		schedule_work(&toshiba_acpi.hotkey_work);
+		return true;
+	}
+
+	return false;
+}
+
+static int toshiba_acpi_query_event(int *hotkey)
+{
+	acpi_status status;
+
+	/* Not all TOS1900 devices have a NTFY method */
+	if (toshiba_acpi.ntfy_method_present) {
+		status = execute_acpi_method(first_ec->handle, "NTFY",
+					     NULL, NULL);
+		if (ACPI_FAILURE(status)) {
+			printk(MY_ERR "Unable to query NTFY method\n");
+			toshiba_acpi.ntfy_method_present = 0;
+		}
+	}
+
+	status = execute_acpi_method(toshiba_acpi.acpi_dev->handle, "INFO",
+				    NULL, hotkey);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_ERR "Unable to request hotkey\n");
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
+
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

-	if (event != 0x80)
+	if (event != 0x80 || toshiba_acpi.hci_type == 2)
 		return;
-	do {
-		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
-		if (hci_result == HCI_SUCCESS) {
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
+
+	if (toshiba_acpi.hci_type == 1) {
+		do {
+			hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+			if (hci_result == HCI_SUCCESS) {
+				toshiba_report_input_event(value);
+			} else if (hci_result == HCI_NOT_SUPPORTED) {
+				/* This is a workaround for an unresolved
+				* issue on some machines where system events
+				* sporadically become disabled. */
+				hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+				printk(MY_NOTICE "Re-enabled hotkeys\n");
 			}
-		} else if (hci_result == HCI_NOT_SUPPORTED) {
-			/* This is a workaround for an unresolved issue on
-			 * some machines where system events sporadically
-			 * become disabled. */
-			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
-			printk(MY_NOTICE "Re-enabled hotkeys\n");
-		}
-	} while (hci_result != HCI_EMPTY);
+		} while (hci_result != HCI_EMPTY);
+	} else
+	if (toshiba_acpi.hci_type == 3) {
+		if (toshiba_acpi_query_event(&value))
+			printk(MY_ERR "Failed to get hotkey events\n");
+		else
+			toshiba_report_input_event(value);
+	}
 }

-static int __init toshiba_acpi_setup_keyboard(char *device)
+static int __init toshiba_acpi_setup_keyboard(void)
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
@@ -894,55 +1032,104 @@ static int __init
toshiba_acpi_setup_keyboard(char *device)
 	}

 	toshiba_acpi.hotkey_dev->name = "Toshiba input device";
-	toshiba_acpi.hotkey_dev->phys = device;
+	toshiba_acpi.hotkey_dev->phys = "acpi/toshiba";
 	toshiba_acpi.hotkey_dev->id.bustype = BUS_HOST;

 	error = sparse_keymap_setup(toshiba_acpi.hotkey_dev,
-				    toshiba_acpi_keymap, NULL);
+			  toshiba_acpi_keymap, NULL);
 	if (error)
 		goto err_free_dev;

-	status = acpi_install_notify_handler(toshiba_acpi.handle,
-				ACPI_DEVICE_NOTIFY, toshiba_acpi_notify, NULL);
-	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to install hotkey notification\n");
-		error = -ENODEV;
-		goto err_free_keymap;
+	if (toshiba_acpi.hci_type == 2) {
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
- err_free_keymap:
+err_free_keymap:
 	sparse_keymap_free(toshiba_acpi.hotkey_dev);
- err_free_dev:
+	if (toshiba_acpi.hci_type == 2) {
+		i8042_remove_filter(toshiba_i8042_filter);
+		cancel_work_sync(&toshiba_acpi.hotkey_work);
+	}
+err_free_dev:
 	input_free_device(toshiba_acpi.hotkey_dev);
 	toshiba_acpi.hotkey_dev = NULL;
 	return error;
 }

-static void toshiba_acpi_exit(void)
+static int find_hci_method(void)
+{
+	acpi_status status;
+	acpi_handle handle;
+
+	toshiba_acpi.ntfy_method_present = 0;
+
+	status = acpi_get_handle(toshiba_acpi.acpi_dev->handle,
+				 "GHCI", &handle);
+	if (ACPI_SUCCESS(status)) {
+		toshiba_acpi.hci_type = 1;
+		toshiba_acpi.hci_method = "GHCI";
+		printk(MY_INFO "HCI type %d (%s)",
+		       toshiba_acpi.hci_type, toshiba_acpi.hci_method);
+		return 0;
+	}
+
+	status = acpi_get_handle(toshiba_acpi.acpi_dev->handle,
+				 "SPFC", &handle);
+	if (ACPI_SUCCESS(status)) {
+		toshiba_acpi.hci_method = "SPFC";
+
+		if (!first_ec) {
+			printk(MY_ERR "No EC device available\n");
+			return -ENODEV;
+		}
+
+		status = acpi_get_handle(first_ec->handle,
+					 "NTFY", &handle);
+		if (ACPI_SUCCESS(status)) {
+			toshiba_acpi.hci_type = 2;
+			toshiba_acpi.ntfy_method_present = 1;
+		} else
+			toshiba_acpi.hci_type = 3;
+
+		printk(MY_INFO "HCI type %d (%s)",
+		       toshiba_acpi.hci_type, toshiba_acpi.hci_method);
+		return 0;
+	}
+
+	toshiba_acpi.hci_type = 0;
+	toshiba_acpi.hci_method = NULL;
+	toshiba_acpi.ntfy_method_present = 0;
+
+	return 1;
+}
+
+static void toshiba_acpi_cleanup(void)
 {
 	if (toshiba_acpi.hotkey_dev) {
-		acpi_remove_notify_handler(toshiba_acpi.handle,
-				ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
-		sparse_keymap_free(toshiba_acpi.hotkey_dev);
 		input_unregister_device(toshiba_acpi.hotkey_dev);
+		sparse_keymap_free(toshiba_acpi.hotkey_dev);
 	}

 	if (toshiba_acpi.bt_rfk) {
@@ -958,66 +1145,72 @@ static void toshiba_acpi_exit(void)
 	if (toshiba_proc_dir)
 		remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);

-	if (toshiba_acpi.illumination_installed)
+	if (toshiba_acpi.illumination_installed) {
 		led_classdev_unregister(&toshiba_led);
-
-	platform_device_unregister(toshiba_acpi.p_dev);
+		sci_close();
+	}

 	return;
 }

-static int __init toshiba_acpi_init(void)
+static int toshiba_acpi_remove(struct acpi_device *device, int type)
+{
+	if (toshiba_acpi.hci_type == 2) {
+		i8042_remove_filter(toshiba_i8042_filter);
+		cancel_work_sync(&toshiba_acpi.hotkey_work);
+	}
+
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
+	force_fan = 0;
+	key_event_valid = 0;
+
+	toshiba_acpi.acpi_dev = device;
+
+	ret = find_hci_method();
+	if (ret) {
+		printk(MY_INFO "HCI interface not found\n");
 		return ret;
 	}

-	force_fan = 0;
-	key_event_valid = 0;
+	ret = toshiba_acpi_setup_keyboard();
+	if (ret) {
+		printk(MY_ERR "Unable to setup hotkeys\n");
+		return ret;
+	}

-	/* enable event fifo */
-	hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+	if (toshiba_acpi.hci_type == 1) {
+		/* enable event fifo */
+		hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+	} else {
+		/* enable hotkey events */
+		hci_write1(HCI_HOTKEY_EVENT, 1, &hci_result);
+	}

 	toshiba_proc_dir = proc_mkdir(PROC_TOSHIBA, acpi_root_dir);
 	if (!toshiba_proc_dir) {
-		toshiba_acpi_exit();
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	} else {
 		create_toshiba_proc_entries();
 	}

+	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 	toshiba_backlight_device = backlight_device_register("toshiba",
 							     &toshiba_acpi.p_dev->dev,
@@ -1029,8 +1222,7 @@ static int __init toshiba_acpi_init(void)

 		printk(KERN_ERR "Could not register toshiba backlight device\n");
 		toshiba_backlight_device = NULL;
-		toshiba_acpi_exit();
-		return ret;
+		goto out;
 	}

 	/* Register rfkill switch for Bluetooth */
@@ -1042,16 +1234,15 @@ static int __init toshiba_acpi_init(void)
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

@@ -1063,6 +1254,49 @@ static int __init toshiba_acpi_init(void)
 	}

 	return 0;
+
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
+							     -1, NULL, 0);
+	if (IS_ERR(toshiba_acpi.p_dev)) {
+		printk(MY_ERR "unable to register platform device\n");
+		return PTR_ERR(toshiba_acpi.p_dev);
+	}
+
+	ret = acpi_bus_register_driver(&toshiba_acpi_driver);
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
1.7.1


-- 
-- El mundo apesta y vosotros apestais tambien --
