Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0HEFaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:30:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63198 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758318Ab0HEFaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=eSSlSneRo2q0bAtuOX9rSlCfzaSoBw96k1iK/61AuhD8/KBEaW5uCsS4QkmxeTpoDp
         1NOrNrinoY0vaEruUxQS7R7afshQJj4qc5gNFvomH0npLpNarDjjFPRS+H/PD3wqpJhp
         RB39Xz351raR0DLJavv8zEidlVtyhFGKvDAlg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/5] Input: hp-wmi - switch to using sparse keymap library
To: platform-driver-x86@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com
Date: Wed, 04 Aug 2010 22:30:13 -0700
Message-ID: <20100805053013.604.84229.stgit@localhost.localdomain>
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

Also make sure that we install notify handler only after we allocated
input device and that we remove notify handler before unregistering
input device.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/platform/x86/Kconfig  |    1 
 drivers/platform/x86/hp-wmi.c |  172 ++++++++++++-----------------------------
 2 files changed, 52 insertions(+), 121 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 22cec21..15d5374 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -141,6 +141,7 @@ config HP_WMI
 	depends on ACPI_WMI
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
+	select INPUT_SPARSEKMAP
 	help
 	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
 	 to read data from WMI such as docking or ambient light sensor state.
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index f155163..92a8c18 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
 #include <linux/platform_device.h>
 #include <linux/acpi.h>
 #include <linux/rfkill.h>
@@ -87,24 +88,16 @@ struct bios_return {
 	u32 return_code;
 };
 
-struct key_entry {
-	char type;		/* See KE_* below */
-	u16 code;
-	u16 keycode;
-};
-
-enum { KE_KEY, KE_END };
-
-static struct key_entry hp_wmi_keymap[] = {
-	{KE_KEY, 0x02, KEY_BRIGHTNESSUP},
-	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
-	{KE_KEY, 0x20e6, KEY_PROG1},
-	{KE_KEY, 0x20e8, KEY_MEDIA},
-	{KE_KEY, 0x2142, KEY_MEDIA},
-	{KE_KEY, 0x213b, KEY_INFO},
-	{KE_KEY, 0x2169, KEY_DIRECTION},
-	{KE_KEY, 0x231b, KEY_HELP},
-	{KE_END, 0}
+static const struct key_entry hp_wmi_keymap[] = {
+	{ KE_KEY, 0x02,   { KEY_BRIGHTNESSUP } },
+	{ KE_KEY, 0x03,   { KEY_BRIGHTNESSDOWN } },
+	{ KE_KEY, 0x20e6, { KEY_PROG1 } },
+	{ KE_KEY, 0x20e8, { KEY_MEDIA } },
+	{ KE_KEY, 0x2142, { KEY_MEDIA } },
+	{ KE_KEY, 0x213b, { KEY_INFO } },
+	{ KE_KEY, 0x2169, { KEY_DIRECTION } },
+	{ KE_KEY, 0x231b, { KEY_HELP } },
+	{ KE_END, 0 }
 };
 
 static struct input_dev *hp_wmi_input_dev;
@@ -361,64 +354,9 @@ static DEVICE_ATTR(als, S_IRUGO | S_IWUSR, show_als, set_als);
 static DEVICE_ATTR(dock, S_IRUGO, show_dock, NULL);
 static DEVICE_ATTR(tablet, S_IRUGO, show_tablet, NULL);
 
-static struct key_entry *hp_wmi_get_entry_by_scancode(unsigned int code)
-{
-	struct key_entry *key;
-
-	for (key = hp_wmi_keymap; key->type != KE_END; key++)
-		if (code == key->code)
-			return key;
-
-	return NULL;
-}
-
-static struct key_entry *hp_wmi_get_entry_by_keycode(unsigned int keycode)
-{
-	struct key_entry *key;
-
-	for (key = hp_wmi_keymap; key->type != KE_END; key++)
-		if (key->type == KE_KEY && keycode == key->keycode)
-			return key;
-
-	return NULL;
-}
-
-static int hp_wmi_getkeycode(struct input_dev *dev,
-			     unsigned int scancode, unsigned int *keycode)
-{
-	struct key_entry *key = hp_wmi_get_entry_by_scancode(scancode);
-
-	if (key && key->type == KE_KEY) {
-		*keycode = key->keycode;
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-static int hp_wmi_setkeycode(struct input_dev *dev,
-			     unsigned int scancode, unsigned int keycode)
-{
-	struct key_entry *key;
-	unsigned int old_keycode;
-
-	key = hp_wmi_get_entry_by_scancode(scancode);
-	if (key && key->type == KE_KEY) {
-		old_keycode = key->keycode;
-		key->keycode = keycode;
-		set_bit(keycode, dev->keybit);
-		if (!hp_wmi_get_entry_by_keycode(old_keycode))
-			clear_bit(old_keycode, dev->keybit);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static void hp_wmi_notify(u32 value, void *context)
 {
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
-	static struct key_entry *key;
 	union acpi_object *obj;
 	u32 event_id, event_data;
 	int key_code, ret;
@@ -479,19 +417,9 @@ static void hp_wmi_notify(u32 value, void *context)
 					   sizeof(key_code));
 		if (ret)
 			break;
-		key = hp_wmi_get_entry_by_scancode(key_code);
-		if (key) {
-			switch (key->type) {
-			case KE_KEY:
-				input_report_key(hp_wmi_input_dev,
-						 key->keycode, 1);
-				input_sync(hp_wmi_input_dev);
-				input_report_key(hp_wmi_input_dev,
-						 key->keycode, 0);
-				input_sync(hp_wmi_input_dev);
-				break;
-			}
-		} else
+
+		if (!sparse_keymap_report_event(hp_wmi_input_dev,
+						key_code, 1, true))
 			printk(KERN_INFO PREFIX "Unknown key code - 0x%x\n",
 			       key_code);
 		break;
@@ -524,7 +452,7 @@ static void hp_wmi_notify(u32 value, void *context)
 
 static int __init hp_wmi_input_setup(void)
 {
-	struct key_entry *key;
+	acpi_status status;
 	int err;
 
 	hp_wmi_input_dev = input_allocate_device();
@@ -534,21 +462,14 @@ static int __init hp_wmi_input_setup(void)
 	hp_wmi_input_dev->name = "HP WMI hotkeys";
 	hp_wmi_input_dev->phys = "wmi/input0";
 	hp_wmi_input_dev->id.bustype = BUS_HOST;
-	hp_wmi_input_dev->getkeycode = hp_wmi_getkeycode;
-	hp_wmi_input_dev->setkeycode = hp_wmi_setkeycode;
-
-	for (key = hp_wmi_keymap; key->type != KE_END; key++) {
-		switch (key->type) {
-		case KE_KEY:
-			set_bit(EV_KEY, hp_wmi_input_dev->evbit);
-			set_bit(key->keycode, hp_wmi_input_dev->keybit);
-			break;
-		}
-	}
 
-	set_bit(EV_SW, hp_wmi_input_dev->evbit);
-	set_bit(SW_DOCK, hp_wmi_input_dev->swbit);
-	set_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit);
+	__set_bit(EV_SW, hp_wmi_input_dev->evbit);
+	__set_bit(SW_DOCK, hp_wmi_input_dev->swbit);
+	__set_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit);
+
+	err = sparse_keymap_setup(hp_wmi_input_dev, hp_wmi_keymap, NULL);
+	if (err)
+		goto err_free_dev;
 
 	/* Set initial hardware state */
 	input_report_switch(hp_wmi_input_dev, SW_DOCK, hp_wmi_dock_state());
@@ -556,14 +477,32 @@ static int __init hp_wmi_input_setup(void)
 			    hp_wmi_tablet_state());
 	input_sync(hp_wmi_input_dev);
 
-	err = input_register_device(hp_wmi_input_dev);
-
-	if (err) {
-		input_free_device(hp_wmi_input_dev);
-		return err;
+	status = wmi_install_notify_handler(HPWMI_EVENT_GUID, hp_wmi_notify, NULL);
+	if (ACPI_FAILURE(status)) {
+		err = -EIO;
+		goto err_free_keymap;
 	}
 
+	err = input_register_device(hp_wmi_input_dev);
+	if (err)
+		goto err_uninstall_notifier;
+
 	return 0;
+
+ err_uninstall_notifier:
+	wmi_remove_notify_handler(HPWMI_EVENT_GUID);
+ err_free_keymap:
+	sparse_keymap_free(hp_wmi_input_dev);
+ err_free_dev:
+	input_free_device(hp_wmi_input_dev);
+	return err;
+}
+
+static void hp_wmi_input_destroy(void)
+{
+	wmi_remove_notify_handler(HPWMI_EVENT_GUID);
+	sparse_keymap_free(hp_wmi_input_dev);
+	input_unregister_device(hp_wmi_input_dev);
 }
 
 static void cleanup_sysfs(struct platform_device *device)
@@ -718,15 +657,9 @@ static int __init hp_wmi_init(void)
 	int bios_capable = wmi_has_guid(HPWMI_BIOS_GUID);
 
 	if (event_capable) {
-		err = wmi_install_notify_handler(HPWMI_EVENT_GUID,
-						 hp_wmi_notify, NULL);
-		if (ACPI_FAILURE(err))
-			return -EINVAL;
 		err = hp_wmi_input_setup();
-		if (err) {
-			wmi_remove_notify_handler(HPWMI_EVENT_GUID);
+		if (err)
 			return err;
-		}
 	}
 
 	if (bios_capable) {
@@ -753,20 +686,17 @@ err_device_add:
 err_device_alloc:
 	platform_driver_unregister(&hp_wmi_driver);
 err_driver_reg:
-	if (wmi_has_guid(HPWMI_EVENT_GUID)) {
-		input_unregister_device(hp_wmi_input_dev);
-		wmi_remove_notify_handler(HPWMI_EVENT_GUID);
-	}
+	if (event_capable)
+		hp_wmi_input_destroy();
 
 	return err;
 }
 
 static void __exit hp_wmi_exit(void)
 {
-	if (wmi_has_guid(HPWMI_EVENT_GUID)) {
-		wmi_remove_notify_handler(HPWMI_EVENT_GUID);
-		input_unregister_device(hp_wmi_input_dev);
-	}
+	if (wmi_has_guid(HPWMI_EVENT_GUID))
+		hp_wmi_input_destroy();
+
 	if (hp_wmi_platform_dev) {
 		platform_device_unregister(hp_wmi_platform_dev);
 		platform_driver_unregister(&hp_wmi_driver);

