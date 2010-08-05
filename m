Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab0HEFbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:31:16 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63198 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab0HEFaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=gSWQNUoivFR9DozksjAGzhwRFdFVUhzhoafqtJKMQOafT+eCggkKb6UtMGWv1FP1iM
         6qgazoMMCyc1eOVXvBunMsatTXLI0zy/wKsgTVH24u1yBCPY6Cvbsn4B7l8v6VBt/TDQ
         L6cicMmTarsWuyQwdJFZ0Gm16yM7wM6/bVlO0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3/5] Input: dell-wmi - switch to using sparse keymap library
To: platform-driver-x86@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com
Date: Wed, 04 Aug 2010 22:30:08 -0700
Message-ID: <20100805053008.604.43823.stgit@localhost.localdomain>
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

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/platform/x86/Kconfig    |    1 
 drivers/platform/x86/dell-wmi.c |  256 +++++++++++++++------------------------
 2 files changed, 97 insertions(+), 160 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index a99d226..22cec21 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -92,6 +92,7 @@ config DELL_WMI
 	tristate "Dell WMI extras"
 	depends on ACPI_WMI
 	depends on INPUT
+	select INPUT_SPARSEKMAP
 	---help---
 	  Say Y here if you want to support WMI-based hotkeys on Dell laptops.
 
diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 08fb70f..77f1d55 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
 #include <acpi/acpi_drivers.h>
 #include <linux/acpi.h>
 #include <linux/string.h>
@@ -44,78 +45,70 @@ static int acpi_video;
 
 MODULE_ALIAS("wmi:"DELL_EVENT_GUID);
 
-struct key_entry {
-	char type;		/* See KE_* below */
-	u16 code;
-	u16 keycode;
-};
-
-enum { KE_KEY, KE_SW, KE_IGNORE, KE_END };
-
 /*
  * Certain keys are flagged as KE_IGNORE. All of these are either
  * notifications (rather than requests for change) or are also sent
  * via the keyboard controller so should not be sent again.
  */
 
-static struct key_entry dell_legacy_wmi_keymap[] = {
-	{KE_KEY, 0xe045, KEY_PROG1},
-	{KE_KEY, 0xe009, KEY_EJECTCD},
+static const struct key_entry dell_wmi_legacy_keymap[] __initconst = {
+	{ KE_KEY, 0xe045, { KEY_PROG1 } },
+	{ KE_KEY, 0xe009, { KEY_EJECTCD } },
 
 	/* These also contain the brightness level at offset 6 */
-	{KE_KEY, 0xe006, KEY_BRIGHTNESSUP},
-	{KE_KEY, 0xe005, KEY_BRIGHTNESSDOWN},
+	{ KE_KEY, 0xe006, { KEY_BRIGHTNESSUP } },
+	{ KE_KEY, 0xe005, { KEY_BRIGHTNESSDOWN } },
 
 	/* Battery health status button */
-	{KE_KEY, 0xe007, KEY_BATTERY},
+	{ KE_KEY, 0xe007, { KEY_BATTERY } },
 
 	/* This is actually for all radios. Although physically a
 	 * switch, the notification does not provide an indication of
 	 * state and so it should be reported as a key */
-	{KE_KEY, 0xe008, KEY_WLAN},
+	{ KE_KEY, 0xe008, { KEY_WLAN } },
 
 	/* The next device is at offset 6, the active devices are at
 	   offset 8 and the attached devices at offset 10 */
-	{KE_KEY, 0xe00b, KEY_SWITCHVIDEOMODE},
+	{ KE_KEY, 0xe00b, { KEY_SWITCHVIDEOMODE } },
 
-	{KE_IGNORE, 0xe00c, KEY_KBDILLUMTOGGLE},
+	{ KE_IGNORE, 0xe00c, { KEY_KBDILLUMTOGGLE } },
 
 	/* BIOS error detected */
-	{KE_IGNORE, 0xe00d, KEY_RESERVED},
+	{ KE_IGNORE, 0xe00d, { KEY_RESERVED } },
 
 	/* Wifi Catcher */
-	{KE_KEY, 0xe011, KEY_PROG2},
+	{ KE_KEY, 0xe011, {KEY_PROG2 } },
 
 	/* Ambient light sensor toggle */
-	{KE_IGNORE, 0xe013, KEY_RESERVED},
-
-	{KE_IGNORE, 0xe020, KEY_MUTE},
-	{KE_IGNORE, 0xe02e, KEY_VOLUMEDOWN},
-	{KE_IGNORE, 0xe030, KEY_VOLUMEUP},
-	{KE_IGNORE, 0xe033, KEY_KBDILLUMUP},
-	{KE_IGNORE, 0xe034, KEY_KBDILLUMDOWN},
-	{KE_IGNORE, 0xe03a, KEY_CAPSLOCK},
-	{KE_IGNORE, 0xe045, KEY_NUMLOCK},
-	{KE_IGNORE, 0xe046, KEY_SCROLLLOCK},
-	{KE_END, 0}
+	{ KE_IGNORE, 0xe013, { KEY_RESERVED } },
+
+	{ KE_IGNORE, 0xe020, { KEY_MUTE } },
+	{ KE_IGNORE, 0xe02e, { KEY_VOLUMEDOWN } },
+	{ KE_IGNORE, 0xe030, { KEY_VOLUMEUP } },
+	{ KE_IGNORE, 0xe033, { KEY_KBDILLUMUP } },
+	{ KE_IGNORE, 0xe034, { KEY_KBDILLUMDOWN } },
+	{ KE_IGNORE, 0xe03a, { KEY_CAPSLOCK } },
+	{ KE_IGNORE, 0xe045, { KEY_NUMLOCK } },
+	{ KE_IGNORE, 0xe046, { KEY_SCROLLLOCK } },
+	{ KE_END, 0 }
 };
 
 static bool dell_new_hk_type;
 
-struct dell_new_keymap_entry {
+struct dell_bios_keymap_entry {
 	u16 scancode;
 	u16 keycode;
 };
 
-struct dell_hotkey_table {
+struct dell_bios_hotkey_table {
 	struct dmi_header header;
-	struct dell_new_keymap_entry keymap[];
+	struct dell_bios_keymap_entry keymap[];
 
 };
 
-static struct key_entry *dell_new_wmi_keymap;
+static const struct dell_bios_hotkey_table *dell_bios_hotkey_table;
 
-static u16 bios_to_linux_keycode[256] = {
+static const u16 bios_to_linux_keycode[256] __initconst = {
 
 	KEY_MEDIA,	KEY_NEXTSONG,	KEY_PLAYPAUSE, KEY_PREVIOUSSONG,
 	KEY_STOPCD,	KEY_UNKNOWN,	KEY_UNKNOWN,	KEY_UNKNOWN,
@@ -138,68 +131,11 @@ static u16 bios_to_linux_keycode[256] = {
 	KEY_PROG3
 };
 
-
-static struct key_entry *dell_wmi_keymap = dell_legacy_wmi_keymap;
-
 static struct input_dev *dell_wmi_input_dev;
 
-static struct key_entry *dell_wmi_get_entry_by_scancode(unsigned int code)
-{
-	struct key_entry *key;
-
-	for (key = dell_wmi_keymap; key->type != KE_END; key++)
-		if (code == key->code)
-			return key;
-
-	return NULL;
-}
-
-static struct key_entry *dell_wmi_get_entry_by_keycode(unsigned int keycode)
-{
-	struct key_entry *key;
-
-	for (key = dell_wmi_keymap; key->type != KE_END; key++)
-		if (key->type == KE_KEY && keycode == key->keycode)
-			return key;
-
-	return NULL;
-}
-
-static int dell_wmi_getkeycode(struct input_dev *dev,
-				unsigned int scancode, unsigned int *keycode)
-{
-	struct key_entry *key = dell_wmi_get_entry_by_scancode(scancode);
-
-	if (key && key->type == KE_KEY) {
-		*keycode = key->keycode;
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-static int dell_wmi_setkeycode(struct input_dev *dev,
-				unsigned int scancode, unsigned int keycode)
-{
-	struct key_entry *key;
-	unsigned int old_keycode;
-
-	key = dell_wmi_get_entry_by_scancode(scancode);
-	if (key && key->type == KE_KEY) {
-		old_keycode = key->keycode;
-		key->keycode = keycode;
-		set_bit(keycode, dev->keybit);
-		if (!dell_wmi_get_entry_by_keycode(old_keycode))
-			clear_bit(old_keycode, dev->keybit);
-		return 0;
-	}
-	return -EINVAL;
-}
-
 static void dell_wmi_notify(u32 value, void *context)
 {
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
-	static struct key_entry *key;
 	union acpi_object *obj;
 	acpi_status status;
 
@@ -212,8 +148,10 @@ static void dell_wmi_notify(u32 value, void *context)
 	obj = (union acpi_object *)response.pointer;
 
 	if (obj && obj->type == ACPI_TYPE_BUFFER) {
+		const struct key_entry *key;
 		int reported_key;
 		u16 *buffer_entry = (u16 *)obj->buffer.pointer;
+
 		if (dell_new_hk_type && (buffer_entry[1] != 0x10)) {
 			printk(KERN_INFO "dell-wmi: Received unknown WMI event"
 					 " (0x%x)\n", buffer_entry[1]);
@@ -226,8 +164,8 @@ static void dell_wmi_notify(u32 value, void *context)
 		else
 			reported_key = (int)buffer_entry[1] & 0xffff;
 
-		key = dell_wmi_get_entry_by_scancode(reported_key);
-
+		key = sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
+							reported_key);
 		if (!key) {
 			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
 				reported_key);
@@ -237,92 +175,98 @@ static void dell_wmi_notify(u32 value, void *context)
 			 * come via ACPI */
 			;
 		} else {
-			input_report_key(dell_wmi_input_dev, key->keycode, 1);
-			input_sync(dell_wmi_input_dev);
-			input_report_key(dell_wmi_input_dev, key->keycode, 0);
-			input_sync(dell_wmi_input_dev);
+			sparse_keymap_report_entry(dell_wmi_input_dev, key,
+						   1, true);
 		}
 	}
 	kfree(obj);
 }
 
-
-static void setup_new_hk_map(const struct dmi_header *dm)
+static const struct key_entry * __init dell_wmi_prepare_new_keymap(void)
 {
-
+	int hotkey_num = (dell_bios_hotkey_table->header.length - 4) /
+				sizeof(struct dell_bios_keymap_entry);
+	struct key_entry *keymap;
 	int i;
-	int hotkey_num = (dm->length-4)/sizeof(struct dell_new_keymap_entry);
-	struct dell_hotkey_table *table =
-		container_of(dm, struct dell_hotkey_table, header);
 
-	dell_new_wmi_keymap = kzalloc((hotkey_num+1) *
-				      sizeof(struct key_entry), GFP_KERNEL);
+	keymap = kcalloc(hotkey_num + 1, sizeof(struct key_entry), GFP_KERNEL);
+	if (!keymap)
+		return NULL;
 
 	for (i = 0; i < hotkey_num; i++) {
-		dell_new_wmi_keymap[i].type = KE_KEY;
-		dell_new_wmi_keymap[i].code = table->keymap[i].scancode;
-		dell_new_wmi_keymap[i].keycode =
-			(table->keymap[i].keycode > 255) ? 0 :
-			bios_to_linux_keycode[table->keymap[i].keycode];
+		const struct dell_bios_keymap_entry *bios_entry =
+					&dell_bios_hotkey_table->keymap[i];
+		keymap[i].type = KE_KEY;
+		keymap[i].code = bios_entry->scancode;
+		keymap[i].keycode = bios_entry->keycode < 256 ?
+				    bios_to_linux_keycode[bios_entry->keycode] :
+				    KEY_RESERVED;
 	}
 
-	dell_new_wmi_keymap[i].type = KE_END;
-	dell_new_wmi_keymap[i].code = 0;
-	dell_new_wmi_keymap[i].keycode = 0;
-
-	dell_wmi_keymap = dell_new_wmi_keymap;
+	keymap[hotkey_num].type = KE_END;
 
+	return keymap;
 }
 
-
-static void find_hk_type(const struct dmi_header *dm, void *dummy)
-{
-
-	if ((dm->type == 0xb2) && (dm->length > 6)) {
-		dell_new_hk_type = true;
-		setup_new_hk_map(dm);
-	}
-
-}
-
-
 static int __init dell_wmi_input_setup(void)
 {
-	struct key_entry *key;
 	int err;
 
 	dell_wmi_input_dev = input_allocate_device();
-
 	if (!dell_wmi_input_dev)
 		return -ENOMEM;
 
 	dell_wmi_input_dev->name = "Dell WMI hotkeys";
 	dell_wmi_input_dev->phys = "wmi/input0";
 	dell_wmi_input_dev->id.bustype = BUS_HOST;
-	dell_wmi_input_dev->getkeycode = dell_wmi_getkeycode;
-	dell_wmi_input_dev->setkeycode = dell_wmi_setkeycode;
-
-	for (key = dell_wmi_keymap; key->type != KE_END; key++) {
-		switch (key->type) {
-		case KE_KEY:
-			set_bit(EV_KEY, dell_wmi_input_dev->evbit);
-			set_bit(key->keycode, dell_wmi_input_dev->keybit);
-			break;
-		case KE_SW:
-			set_bit(EV_SW, dell_wmi_input_dev->evbit);
-			set_bit(key->keycode, dell_wmi_input_dev->swbit);
-			break;
+
+	if (dell_new_hk_type) {
+		const struct key_entry *keymap = dell_wmi_prepare_new_keymap();
+		if (!keymap) {
+			err = -ENOMEM;
+			goto err_free_dev;
 		}
-	}
 
-	err = input_register_device(dell_wmi_input_dev);
+		err = sparse_keymap_setup(dell_wmi_input_dev, keymap, NULL);
 
-	if (err) {
-		input_free_device(dell_wmi_input_dev);
-		return err;
+		/*
+		 * Sparse keymap library makes a copy of keymap so we
+		 * don't need the original one that was allocated.
+		 */
+		kfree(keymap);
+	} else {
+		err = sparse_keymap_setup(dell_wmi_input_dev,
+					  dell_wmi_legacy_keymap, NULL);
 	}
+	if (err)
+		goto err_free_dev;
+
+	err = input_register_device(dell_wmi_input_dev);
+	if (err)
+		goto err_free_keymap;
 
 	return 0;
+
+ err_free_keymap:
+	sparse_keymap_free(dell_wmi_input_dev);
+ err_free_dev:
+	input_free_device(dell_wmi_input_dev);
+	return err;
+}
+
+static void dell_wmi_input_destroy(void)
+{
+	sparse_keymap_free(dell_wmi_input_dev);
+	input_unregister_device(dell_wmi_input_dev);
+}
+
+static void __init find_hk_type(const struct dmi_header *dm, void *dummy)
+{
+	if (dm->type == 0xb2 && dm->length > 6) {
+		dell_new_hk_type = true;
+		dell_bios_hotkey_table =
+			container_of(dm, struct dell_bios_hotkey_table, header);
+	}
 }
 
 static int __init dell_wmi_init(void)
@@ -339,18 +283,13 @@ static int __init dell_wmi_init(void)
 	acpi_video = acpi_video_backlight_support();
 
 	err = dell_wmi_input_setup();
-	if (err) {
-		if (dell_new_hk_type)
-			kfree(dell_wmi_keymap);
+	if (err)
 		return err;
-	}
 
 	status = wmi_install_notify_handler(DELL_EVENT_GUID,
 					 dell_wmi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
-		input_unregister_device(dell_wmi_input_dev);
-		if (dell_new_hk_type)
-			kfree(dell_wmi_keymap);
+		dell_wmi_input_destroy();
 		printk(KERN_ERR
 			"dell-wmi: Unable to register notify handler - %d\n",
 			status);
@@ -359,14 +298,11 @@ static int __init dell_wmi_init(void)
 
 	return 0;
 }
+module_init(dell_wmi_init);
 
 static void __exit dell_wmi_exit(void)
 {
 	wmi_remove_notify_handler(DELL_EVENT_GUID);
-	input_unregister_device(dell_wmi_input_dev);
-	if (dell_new_hk_type)
-		kfree(dell_wmi_keymap);
+	dell_wmi_input_destroy();
 }
-
-module_init(dell_wmi_init);
 module_exit(dell_wmi_exit);

