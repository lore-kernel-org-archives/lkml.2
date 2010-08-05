Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab0HEFaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:30:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40792 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab0HEFaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=KEnkIlJB0afHHZbQri4kdIjk4owLZNObYSA8Te1W1saEMe8ooFzMJ12zkIHhLmJknH
         j5fUYssuQ9bYxrxiuBZa0WTnn8LOXFG8otTnHBd6JCHrbPsGAPrRWRlmiWhCvjRZvmyE
         NobzKoRiQ9A0TJiJAGKBSUKhf5rMS63rKv6Q0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/5] topstar-laptop - switch to using sparse keymap library
To: platform-driver-x86@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com
Date: Wed, 04 Aug 2010 22:29:57 -0700
Message-ID: <20100805052957.604.79075.stgit@localhost.localdomain>
In-Reply-To: <20100805052645.604.28606.stgit@localhost.localdomain>
References: <20100805052645.604.28606.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of implementing its own version of keymap hanlding switch over to
using sparse keymap library.

Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/platform/x86/Kconfig          |    1 
 drivers/platform/x86/topstar-laptop.c |  161 +++++++++++----------------------
 2 files changed, 55 insertions(+), 107 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 79baa63..63d68e7 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -471,6 +471,7 @@ config TOPSTAR_LAPTOP
 	tristate "Topstar Laptop Extras"
 	depends on ACPI
 	depends on INPUT
+	select INPUT_SPARSEKMAP
 	---help---
 	  This driver adds support for hotkeys found on Topstar laptops.
 
diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
index ff4b476..1d07d6d 100644
--- a/drivers/platform/x86/topstar-laptop.c
+++ b/drivers/platform/x86/topstar-laptop.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
 
 #define ACPI_TOPSTAR_CLASS "topstar"
 
@@ -26,52 +27,37 @@ struct topstar_hkey {
 	struct input_dev *inputdev;
 };
 
-struct tps_key_entry {
-	u8 code;
-	u16 keycode;
-};
-
-static struct tps_key_entry topstar_keymap[] = {
-	{ 0x80, KEY_BRIGHTNESSUP },
-	{ 0x81, KEY_BRIGHTNESSDOWN },
-	{ 0x83, KEY_VOLUMEUP },
-	{ 0x84, KEY_VOLUMEDOWN },
-	{ 0x85, KEY_MUTE },
-	{ 0x86, KEY_SWITCHVIDEOMODE },
-	{ 0x87, KEY_F13 }, /* touchpad enable/disable key */
-	{ 0x88, KEY_WLAN },
-	{ 0x8a, KEY_WWW },
-	{ 0x8b, KEY_MAIL },
-	{ 0x8c, KEY_MEDIA },
-	{ 0x96, KEY_F14 }, /* G key? */
-	{ }
-};
-
-static struct tps_key_entry *tps_get_key_by_scancode(unsigned int code)
-{
-	struct tps_key_entry *key;
-
-	for (key = topstar_keymap; key->code; key++)
-		if (code == key->code)
-			return key;
+static const struct key_entry topstar_keymap[] = {
+	{ KE_KEY, 0x80, { KEY_BRIGHTNESSUP } },
+	{ KE_KEY, 0x81, { KEY_BRIGHTNESSDOWN } },
+	{ KE_KEY, 0x83, { KEY_VOLUMEUP } },
+	{ KE_KEY, 0x84, { KEY_VOLUMEDOWN } },
+	{ KE_KEY, 0x85, { KEY_MUTE } },
+	{ KE_KEY, 0x86, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0x87, { KEY_F13 } }, /* touchpad enable/disable key */
+	{ KE_KEY, 0x88, { KEY_WLAN } },
+	{ KE_KEY, 0x8a, { KEY_WWW } },
+	{ KE_KEY, 0x8b, { KEY_MAIL } },
+	{ KE_KEY, 0x8c, { KEY_MEDIA } },
 
-	return NULL;
-}
-
-static struct tps_key_entry *tps_get_key_by_keycode(unsigned int code)
-{
-	struct tps_key_entry *key;
+	/* Known non hotkey events don't handled or that we don't care yet */
+	{ KE_IGNORE, 0x8e, },
+	{ KE_IGNORE, 0x8f, },
+	{ KE_IGNORE, 0x90, },
 
-	for (key = topstar_keymap; key->code; key++)
-		if (code == key->keycode)
-			return key;
+	/*
+	 * 'G key' generate two event codes, convert to only
+	 * one event/key code for now, consider replacing by
+	 * a switch (3G switch - SW_3G?)
+	 */
+	{ KE_KEY, 0x96, { KEY_F14 } },
+	{ KE_KEY, 0x97, { KEY_F14 } },
 
-	return NULL;
-}
+	{ KE_END, 0 }
+};
 
 static void acpi_topstar_notify(struct acpi_device *device, u32 event)
 {
-	struct tps_key_entry *key;
 	static bool dup_evnt[2];
 	bool *dup;
 	struct topstar_hkey *hkey = acpi_driver_data(device);
@@ -86,27 +72,8 @@ static void acpi_topstar_notify(struct acpi_device *device, u32 event)
 		*dup = true;
 	}
 
-	/*
-	 * 'G key' generate two event codes, convert to only
-	 * one event/key code for now (3G switch?)
-	 */
-	if (event == 0x97)
-		event = 0x96;
-
-	key = tps_get_key_by_scancode(event);
-	if (key) {
-		input_report_key(hkey->inputdev, key->keycode, 1);
-		input_sync(hkey->inputdev);
-		input_report_key(hkey->inputdev, key->keycode, 0);
-		input_sync(hkey->inputdev);
-		return;
-	}
-
-	/* Known non hotkey events don't handled or that we don't care yet */
-	if (event == 0x8e || event == 0x8f || event == 0x90)
-		return;
-
-	pr_info("unknown event = 0x%02x\n", event);
+	if (!sparse_keymap_report_event(hkey->inputdev, event, 1, true))
+		pr_info("unknown event = 0x%02x\n", event);
 }
 
 static int acpi_topstar_fncx_switch(struct acpi_device *device, bool state)
@@ -127,62 +94,41 @@ static int acpi_topstar_fncx_switch(struct acpi_device *device, bool state)
 	return 0;
 }
 
-static int topstar_getkeycode(struct input_dev *dev,
-				unsigned int scancode, unsigned int *keycode)
-{
-	struct tps_key_entry *key = tps_get_key_by_scancode(scancode);
-
-	if (!key)
-		return -EINVAL;
-
-	*keycode = key->keycode;
-	return 0;
-}
-
-static int topstar_setkeycode(struct input_dev *dev,
-				unsigned int scancode, unsigned int keycode)
-{
-	struct tps_key_entry *key;
-	int old_keycode;
-
-	key = tps_get_key_by_scancode(scancode);
-
-	if (!key)
-		return -EINVAL;
-
-	old_keycode = key->keycode;
-	key->keycode = keycode;
-	set_bit(keycode, dev->keybit);
-	if (!tps_get_key_by_keycode(old_keycode))
-		clear_bit(old_keycode, dev->keybit);
-	return 0;
-}
-
 static int acpi_topstar_init_hkey(struct topstar_hkey *hkey)
 {
-	struct tps_key_entry *key;
+	struct input_dev *input;
+	int error;
 
-	hkey->inputdev = input_allocate_device();
-	if (!hkey->inputdev) {
+	input = input_allocate_device();
+	if (!input) {
 		pr_err("Unable to allocate input device\n");
-		return -ENODEV;
+		return -ENOMEM;
 	}
-	hkey->inputdev->name = "Topstar Laptop extra buttons";
-	hkey->inputdev->phys = "topstar/input0";
-	hkey->inputdev->id.bustype = BUS_HOST;
-	hkey->inputdev->getkeycode = topstar_getkeycode;
-	hkey->inputdev->setkeycode = topstar_setkeycode;
-	for (key = topstar_keymap; key->code; key++) {
-		set_bit(EV_KEY, hkey->inputdev->evbit);
-		set_bit(key->keycode, hkey->inputdev->keybit);
+
+	input->name = "Topstar Laptop extra buttons";
+	input->phys = "topstar/input0";
+	input->id.bustype = BUS_HOST;
+
+	error = sparse_keymap_setup(input, topstar_keymap, NULL);
+	if (error) {
+		pr_err("Unable to setup input device keymap\n");
+		goto err_free_dev;
 	}
-	if (input_register_device(hkey->inputdev)) {
+
+	error = input_register_device(input);
+	if (error) {
 		pr_err("Unable to register input device\n");
-		input_free_device(hkey->inputdev);
-		return -ENODEV;
+		goto err_free_keymap;
 	}
 
+	hkey->inputdev = input;
 	return 0;
+
+ err_free_keymap:
+	sparse_keymap_free(input);
+ err_free_dev:
+	input_free_device(input);
+	return error;
 }
 
 static int acpi_topstar_add(struct acpi_device *device)
@@ -216,6 +162,7 @@ static int acpi_topstar_remove(struct acpi_device *device, int type)
 
 	acpi_topstar_fncx_switch(device, false);
 
+	sparse_keymap_free(tps_hkey->inputdev);
 	input_unregister_device(tps_hkey->inputdev);
 	kfree(tps_hkey);
 

