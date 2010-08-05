Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab0HEFac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:30:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61565 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab0HEFaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=nDO7HG03tbM4774u+6LPa2o2dHwVTlZWayjEIIzO35uxkY5HX4deY+Vd/gyaowdB9B
         7w7lWi4H77UmXLCzFGvejhA7vsxq3fXHYRQVe9vexnM5/X1sdQnggy10D9/OTXi3LLjQ
         tnG1DerA4SaOmqWofyKCFY0bpR8i4Q0qSZjgc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5/5] toshiba-acpi - switch to using sparse keymap
To: platform-driver-x86@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com
Date: Wed, 04 Aug 2010 22:30:19 -0700
Message-ID: <20100805053018.604.78180.stgit@localhost.localdomain>
In-Reply-To: <20100805052645.604.28606.stgit@localhost.localdomain>
References: <20100805052645.604.28606.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of implementing its own version of keymap hanlding switch over
to using sparse keymap library.

Also, install notify handler only after we allocated input device,
otherwise we may risk getting event too early and crash. Similarly,
notify handler should be removed before we unregister input device.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/platform/x86/Kconfig        |    2 
 drivers/platform/x86/toshiba_acpi.c |  191 ++++++++++++-----------------------
 2 files changed, 65 insertions(+), 128 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 15d5374..b40c15c 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -485,7 +485,7 @@ config ACPI_TOSHIBA
 	depends on ACPI
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
-	select INPUT_POLLDEV
+	select INPUT_SPARSEKMAP
 	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver adds support for access to certain system settings
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 7d67a45..06f304f 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -48,6 +48,7 @@
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
 #include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
 
@@ -121,36 +122,28 @@ static const struct acpi_device_id toshiba_device_ids[] = {
 };
 MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
 
-struct key_entry {
-	char type;
-	u16 code;
-	u16 keycode;
-};
-
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
+static const struct key_entry toshiba_acpi_keymap[] __initconst = {
+	{ KE_KEY, 0x101, { KEY_MUTE } },
+	{ KE_KEY, 0x102, { KEY_ZOOMOUT } },
+	{ KE_KEY, 0x103, { KEY_ZOOMIN } },
+	{ KE_KEY, 0x13b, { KEY_COFFEE } },
+	{ KE_KEY, 0x13c, { KEY_BATTERY } },
+	{ KE_KEY, 0x13d, { KEY_SLEEP } },
+	{ KE_KEY, 0x13e, { KEY_SUSPEND } },
+	{ KE_KEY, 0x13f, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0x140, { KEY_BRIGHTNESSDOWN } },
+	{ KE_KEY, 0x141, { KEY_BRIGHTNESSUP } },
+	{ KE_KEY, 0x142, { KEY_WLAN } },
+	{ KE_KEY, 0x143, { KEY_PROG1 } },
+	{ KE_KEY, 0xb05, { KEY_PROG2 } },
+	{ KE_KEY, 0xb06, { KEY_WWW } },
+	{ KE_KEY, 0xb07, { KEY_MAIL } },
+	{ KE_KEY, 0xb30, { KEY_STOP } },
+	{ KE_KEY, 0xb31, { KEY_PREVIOUSSONG } },
+	{ KE_KEY, 0xb32, { KEY_NEXTSONG } },
+	{ KE_KEY, 0xb33, { KEY_PLAYPAUSE } },
+	{ KE_KEY, 0xb5a, { KEY_MEDIA } },
+	{ KE_END, 0 },
 };
 
 /* utility
@@ -852,64 +845,9 @@ static struct backlight_ops toshiba_backlight_data = {
         .update_status  = set_lcd_status,
 };
 
-static struct key_entry *toshiba_acpi_get_entry_by_scancode(unsigned int code)
-{
-	struct key_entry *key;
-
-	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
-		if (code == key->code)
-			return key;
-
-	return NULL;
-}
-
-static struct key_entry *toshiba_acpi_get_entry_by_keycode(unsigned int code)
-{
-	struct key_entry *key;
-
-	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
-		if (code == key->keycode && key->type == KE_KEY)
-			return key;
-
-	return NULL;
-}
-
-static int toshiba_acpi_getkeycode(struct input_dev *dev,
-				   unsigned int scancode, unsigned int *keycode)
-{
-	struct key_entry *key = toshiba_acpi_get_entry_by_scancode(scancode);
-
-	if (key && key->type == KE_KEY) {
-		*keycode = key->keycode;
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-static int toshiba_acpi_setkeycode(struct input_dev *dev,
-				   unsigned int scancode, unsigned int keycode)
-{
-	struct key_entry *key;
-	unsigned int old_keycode;
-
-	key = toshiba_acpi_get_entry_by_scancode(scancode);
-	if (key && key->type == KE_KEY) {
-		old_keycode = key->keycode;
-		key->keycode = keycode;
-		set_bit(keycode, dev->keybit);
-		if (!toshiba_acpi_get_entry_by_keycode(old_keycode))
-			clear_bit(old_keycode, dev->keybit);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 {
 	u32 hci_result, value;
-	struct key_entry *key;
 
 	if (event != 0x80)
 		return;
@@ -922,19 +860,11 @@ static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 			if (value & 0x80)
 				continue;
 
-			key = toshiba_acpi_get_entry_by_scancode
-				(value);
-			if (!key) {
+			if (!sparse_keymap_report_event(toshiba_acpi.hotkey_dev,
+							value, 1, true)) {
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
@@ -945,34 +875,17 @@ static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
 	} while (hci_result != HCI_EMPTY);
 }
 
-static int toshiba_acpi_setup_keyboard(char *device)
+static int __init toshiba_acpi_setup_keyboard(char *device)
 {
 	acpi_status status;
-	acpi_handle handle;
-	int result;
-	const struct key_entry *key;
+	int error;
 
-	status = acpi_get_handle(NULL, device, &handle);
+	status = acpi_get_handle(NULL, device, &toshiba_acpi.handle);
 	if (ACPI_FAILURE(status)) {
 		printk(MY_INFO "Unable to get notification device\n");
 		return -ENODEV;
 	}
 
-	toshiba_acpi.handle = handle;
-
-	status = acpi_evaluate_object(handle, "ENAB", NULL, NULL);
-	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to enable hotkeys\n");
-		return -ENODEV;
-	}
-
-	status = acpi_install_notify_handler(handle, ACPI_DEVICE_NOTIFY,
-					      toshiba_acpi_notify, NULL);
-	if (ACPI_FAILURE(status)) {
-		printk(MY_INFO "Unable to install hotkey notification\n");
-		return -ENODEV;
-	}
-
 	toshiba_acpi.hotkey_dev = input_allocate_device();
 	if (!toshiba_acpi.hotkey_dev) {
 		printk(MY_INFO "Unable to register input device\n");
@@ -982,27 +895,54 @@ static int toshiba_acpi_setup_keyboard(char *device)
 	toshiba_acpi.hotkey_dev->name = "Toshiba input device";
 	toshiba_acpi.hotkey_dev->phys = device;
 	toshiba_acpi.hotkey_dev->id.bustype = BUS_HOST;
-	toshiba_acpi.hotkey_dev->getkeycode = toshiba_acpi_getkeycode;
-	toshiba_acpi.hotkey_dev->setkeycode = toshiba_acpi_setkeycode;
 
-	for (key = toshiba_acpi_keymap; key->type != KE_END; key++) {
-		set_bit(EV_KEY, toshiba_acpi.hotkey_dev->evbit);
-		set_bit(key->keycode, toshiba_acpi.hotkey_dev->keybit);
+	error = sparse_keymap_setup(toshiba_acpi.hotkey_dev,
+				    toshiba_acpi_keymap, NULL);
+	if (error)
+		goto err_free_dev;
+
+	status = acpi_install_notify_handler(toshiba_acpi.handle,
+				ACPI_DEVICE_NOTIFY, toshiba_acpi_notify, NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_INFO "Unable to install hotkey notification\n");
+		error = -ENODEV;
+		goto err_free_keymap;
+	}
+
+	status = acpi_evaluate_object(toshiba_acpi.handle, "ENAB", NULL, NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_INFO "Unable to enable hotkeys\n");
+		error = -ENODEV;
+		goto err_remove_notify;
 	}
 
-	result = input_register_device(toshiba_acpi.hotkey_dev);
-	if (result) {
+	error = input_register_device(toshiba_acpi.hotkey_dev);
+	if (error) {
 		printk(MY_INFO "Unable to register input device\n");
-		return result;
+		goto err_remove_notify;
 	}
 
 	return 0;
+
+ err_remove_notify:
+	acpi_remove_notify_handler(toshiba_acpi.handle,
+				   ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
+ err_free_keymap:
+	sparse_keymap_free(toshiba_acpi.hotkey_dev);
+ err_free_dev:
+	input_free_device(toshiba_acpi.hotkey_dev);
+	toshiba_acpi.hotkey_dev = NULL;
+	return error;
 }
 
 static void toshiba_acpi_exit(void)
 {
-	if (toshiba_acpi.hotkey_dev)
+	if (toshiba_acpi.hotkey_dev) {
+		acpi_remove_notify_handler(toshiba_acpi.handle,
+				ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
+		sparse_keymap_free(toshiba_acpi.hotkey_dev);
 		input_unregister_device(toshiba_acpi.hotkey_dev);
+	}
 
 	if (toshiba_acpi.bt_rfk) {
 		rfkill_unregister(toshiba_acpi.bt_rfk);
@@ -1017,9 +957,6 @@ static void toshiba_acpi_exit(void)
 	if (toshiba_proc_dir)
 		remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);
 
-	acpi_remove_notify_handler(toshiba_acpi.handle, ACPI_DEVICE_NOTIFY,
-				   toshiba_acpi_notify);
-
 	if (toshiba_acpi.illumination_installed)
 		led_classdev_unregister(&toshiba_led);
 

