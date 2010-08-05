Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab0HEFaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:30:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63198 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab0HEFaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=eyTXVcmLCY7McwN+Yjvp+FGF2bE/Q6aur+X75Pd6ExEaF1YRpDHK4mJ24b5qy3OBnW
         we9Qdu8pzQWzHtAlcECQOfLreWvyDn1tThETmjcFz/PkAXikBIFC36ExHB3FEFODIf+m
         6LWn3Nr7i0qhF/UUqN3eDhbo0cbXRNC+g1uxI=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/5] panasonic-laptop - switch to using sparse keymap library
To: platform-driver-x86@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com
Date: Wed, 04 Aug 2010 22:30:02 -0700
Message-ID: <20100805053002.604.7478.stgit@localhost.localdomain>
In-Reply-To: <20100805052645.604.28606.stgit@localhost.localdomain>
References: <20100805052645.604.28606.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nstead of implementing its own version of keymap hanlding switch over to
using sparse keymap library.

Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/platform/x86/Kconfig            |    1 
 drivers/platform/x86/panasonic-laptop.c |  172 +++++++++++--------------------
 2 files changed, 62 insertions(+), 111 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 63d68e7..a99d226 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -171,6 +171,7 @@ config PANASONIC_LAPTOP
 	tristate "Panasonic Laptop Extras"
 	depends on INPUT && ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
+	select INPUT_SPARSEKMAP
 	---help---
 	  This driver adds support for access to backlight control and hotkeys
 	  on Panasonic Let's Note laptops.
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index ec01c3d..b3b9e04 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -128,6 +128,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
 
 
 #ifndef ACPI_HOTKEY_COMPONENT
@@ -200,30 +201,29 @@ static struct acpi_driver acpi_pcc_driver = {
 			},
 };
 
-#define KEYMAP_SIZE		11
-static const unsigned int initial_keymap[KEYMAP_SIZE] = {
-	/*  0 */ KEY_RESERVED,
-	/*  1 */ KEY_BRIGHTNESSDOWN,
-	/*  2 */ KEY_BRIGHTNESSUP,
-	/*  3 */ KEY_DISPLAYTOGGLE,
-	/*  4 */ KEY_MUTE,
-	/*  5 */ KEY_VOLUMEDOWN,
-	/*  6 */ KEY_VOLUMEUP,
-	/*  7 */ KEY_SLEEP,
-	/*  8 */ KEY_PROG1, /* Change CPU boost */
-	/*  9 */ KEY_BATTERY,
-	/* 10 */ KEY_SUSPEND,
+static const struct key_entry panasonic_keymap[] = {
+	{ KE_KEY, 0, { KEY_RESERVED } },
+	{ KE_KEY, 1, { KEY_BRIGHTNESSDOWN } },
+	{ KE_KEY, 2, { KEY_BRIGHTNESSUP } },
+	{ KE_KEY, 3, { KEY_DISPLAYTOGGLE } },
+	{ KE_KEY, 4, { KEY_MUTE } },
+	{ KE_KEY, 5, { KEY_VOLUMEDOWN } },
+	{ KE_KEY, 6, { KEY_VOLUMEUP } },
+	{ KE_KEY, 7, { KEY_SLEEP } },
+	{ KE_KEY, 8, { KEY_PROG1 } }, /* Change CPU boost */
+	{ KE_KEY, 9, { KEY_BATTERY } },
+	{ KE_KEY, 10, { KEY_SUSPEND } },
+	{ KE_END, 0 }
 };
 
 struct pcc_acpi {
 	acpi_handle		handle;
 	unsigned long		num_sifr;
 	int			sticky_mode;
-	u32 			*sinf;
+	u32			*sinf;
 	struct acpi_device	*device;
 	struct input_dev	*input_dev;
 	struct backlight_device	*backlight;
-	unsigned int		keymap[KEYMAP_SIZE];
 };
 
 struct pcc_keyinput {
@@ -446,56 +446,10 @@ static struct attribute_group pcc_attr_group = {
 
 /* hotkey input device driver */
 
-static int pcc_getkeycode(struct input_dev *dev,
-			  unsigned int scancode, unsigned int *keycode)
-{
-	struct pcc_acpi *pcc = input_get_drvdata(dev);
-
-	if (scancode >= ARRAY_SIZE(pcc->keymap))
-		return -EINVAL;
-
-	*keycode = pcc->keymap[scancode];
-
-	return 0;
-}
-
-static int keymap_get_by_keycode(struct pcc_acpi *pcc, unsigned int keycode)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(pcc->keymap); i++) {
-		if (pcc->keymap[i] == keycode)
-			return i+1;
-	}
-
-	return 0;
-}
-
-static int pcc_setkeycode(struct input_dev *dev,
-			  unsigned int scancode, unsigned int keycode)
-{
-	struct pcc_acpi *pcc = input_get_drvdata(dev);
-	int oldkeycode;
-
-	if (scancode >= ARRAY_SIZE(pcc->keymap))
-		return -EINVAL;
-
-	oldkeycode = pcc->keymap[scancode];
-	pcc->keymap[scancode] = keycode;
-
-	set_bit(keycode, dev->keybit);
-
-	if (!keymap_get_by_keycode(pcc, oldkeycode))
-		clear_bit(oldkeycode, dev->keybit);
-
-	return 0;
-}
-
 static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 {
 	struct input_dev *hotk_input_dev = pcc->input_dev;
 	int rc;
-	int key_code, hkey_num;
 	unsigned long long result;
 
 	rc = acpi_evaluate_integer(pcc->handle, METHOD_HKEY_QUERY,
@@ -508,25 +462,10 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 
 	acpi_bus_generate_proc_event(pcc->device, HKEY_NOTIFY, result);
 
-	hkey_num = result & 0xf;
-
-	if (hkey_num < 0 || hkey_num >= ARRAY_SIZE(pcc->keymap)) {
+	if (!sparse_keymap_report_event(hotk_input_dev,
+					result & 0xf, result & 0x80, false))
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-				  "hotkey number out of range: %d\n",
-				  hkey_num));
-		return;
-	}
-
-	key_code = pcc->keymap[hkey_num];
-
-	if (key_code != KEY_RESERVED) {
-		int pushed = (result & 0x80) ? TRUE : FALSE;
-
-		input_report_key(hotk_input_dev, key_code, pushed);
-		input_sync(hotk_input_dev);
-	}
-
-	return;
+				  "Unknown hotkey event: %d\n", result));
 }
 
 static void acpi_pcc_hotkey_notify(struct acpi_device *device, u32 event)
@@ -545,40 +484,55 @@ static void acpi_pcc_hotkey_notify(struct acpi_device *device, u32 event)
 
 static int acpi_pcc_init_input(struct pcc_acpi *pcc)
 {
-	int i, rc;
+	struct input_dev *input_dev;
+	int error;
 
-	pcc->input_dev = input_allocate_device();
-	if (!pcc->input_dev) {
+	input_dev = input_allocate_device();
+	if (!input_dev) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
 				  "Couldn't allocate input device for hotkey"));
 		return -ENOMEM;
 	}
 
-	pcc->input_dev->evbit[0] = BIT(EV_KEY);
-
-	pcc->input_dev->name = ACPI_PCC_DRIVER_NAME;
-	pcc->input_dev->phys = ACPI_PCC_INPUT_PHYS;
-	pcc->input_dev->id.bustype = BUS_HOST;
-	pcc->input_dev->id.vendor = 0x0001;
-	pcc->input_dev->id.product = 0x0001;
-	pcc->input_dev->id.version = 0x0100;
-	pcc->input_dev->getkeycode = pcc_getkeycode;
-	pcc->input_dev->setkeycode = pcc_setkeycode;
+	input_dev->name = ACPI_PCC_DRIVER_NAME;
+	input_dev->phys = ACPI_PCC_INPUT_PHYS;
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->id.vendor = 0x0001;
+	input_dev->id.product = 0x0001;
+	input_dev->id.version = 0x0100;
 
-	/* load initial keymap */
-	memcpy(pcc->keymap, initial_keymap, sizeof(pcc->keymap));
+	error = sparse_keymap_setup(input_dev, panasonic_keymap, NULL);
+	if (error) {
+		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
+				  "Unable to setup input device keymap\n"));
+		goto err_free_dev;
+	}
 
-	for (i = 0; i < ARRAY_SIZE(pcc->keymap); i++)
-		__set_bit(pcc->keymap[i], pcc->input_dev->keybit);
-	__clear_bit(KEY_RESERVED, pcc->input_dev->keybit);
+	error = input_register_device(input_dev);
+	if (error) {
+		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
+				  "Unable to register input device\n"));
+		goto err_free_keymap;
+	}
 
-	input_set_drvdata(pcc->input_dev, pcc);
+	pcc->input_dev = input_dev;
+	return 0;
 
-	rc = input_register_device(pcc->input_dev);
-	if (rc < 0)
-		input_free_device(pcc->input_dev);
+ err_free_keymap:
+	sparse_keymap_free(input_dev);
+ err_free_dev:
+	input_free_device(input_dev);
+	return error;
+}
 
-	return rc;
+static void acpi_pcc_destroy_input(struct pcc_acpi *pcc)
+{
+	sparse_keymap_free(pcc->input_dev);
+	input_unregister_device(pcc->input_dev);
+	/*
+	 * No need to input_free_device() since core input API refcounts
+	 * and free()s the device.
+	 */
 }
 
 /* kernel module interface */
@@ -636,7 +590,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	if (result) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
 				  "Error installing keyinput handler\n"));
-		goto out_hotkey;
+		goto out_sinf;
 	}
 
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf)) {
@@ -651,7 +605,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 						   &pcc_backlight_ops, &props);
 	if (IS_ERR(pcc->backlight)) {
 		result = PTR_ERR(pcc->backlight);
-		goto out_sinf;
+		goto out_input;
 	}
 
 	/* read the initial brightness setting from the hardware */
@@ -669,12 +623,10 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 
 out_backlight:
 	backlight_device_unregister(pcc->backlight);
+out_input:
+	acpi_pcc_destroy_input(pcc);
 out_sinf:
 	kfree(pcc->sinf);
-out_input:
-	input_unregister_device(pcc->input_dev);
-	/* no need to input_free_device() since core input API refcount and
-	 * free()s the device */
 out_hotkey:
 	kfree(pcc);
 
@@ -709,9 +661,7 @@ static int acpi_pcc_hotkey_remove(struct acpi_device *device, int type)
 
 	backlight_device_unregister(pcc->backlight);
 
-	input_unregister_device(pcc->input_dev);
-	/* no need to input_free_device() since core input API refcount and
-	 * free()s the device */
+	acpi_pcc_destroy_input(pcc);
 
 	kfree(pcc->sinf);
 	kfree(pcc);

