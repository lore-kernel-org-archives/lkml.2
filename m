Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1C2WWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:38 -0400
Received: from mail.perches.com ([173.55.12.10]:4379 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab1C2WWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:36 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>, Anisse Astier <anisse@astier.eu>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/23] msi-wmi: Use pr_fmt and pr_<level>
Date: Tue, 29 Mar 2011 15:21:47 -0700
Message-Id: <03d9dcf405e4a12d137f1fea83bc920f0b8de923.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added pr_fmt.
Removed now unused #define DRV_PFX
Convert dprintk to pr_debug.
Convert printks to pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/msi-wmi.c |   45 +++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index d5419c9..c832e33 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -20,6 +20,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/input.h>
@@ -36,13 +37,10 @@ MODULE_ALIAS("wmi:551A1F84-FBDD-4125-91DB-3EA8F44F1D45");
 MODULE_ALIAS("wmi:B6F3EEF2-3D2F-49DC-9DE3-85BCE18C62F2");
 
 #define DRV_NAME "msi-wmi"
-#define DRV_PFX DRV_NAME ": "
 
 #define MSIWMI_BIOS_GUID "551A1F84-FBDD-4125-91DB-3EA8F44F1D45"
 #define MSIWMI_EVENT_GUID "B6F3EEF2-3D2F-49DC-9DE3-85BCE18C62F2"
 
-#define dprintk(msg...) pr_debug(DRV_PFX msg)
-
 #define SCANCODE_BASE 0xD0
 #define MSI_WMI_BRIGHTNESSUP   SCANCODE_BASE
 #define MSI_WMI_BRIGHTNESSDOWN (SCANCODE_BASE + 1)
@@ -78,7 +76,7 @@ static int msi_wmi_query_block(int instance, int *ret)
 
 	if (!obj || obj->type != ACPI_TYPE_INTEGER) {
 		if (obj) {
-			printk(KERN_ERR DRV_PFX "query block returned object "
+			pr_err("query block returned object "
 			       "type: %d - buffer length:%d\n", obj->type,
 			       obj->type == ACPI_TYPE_BUFFER ?
 			       obj->buffer.length : 0);
@@ -97,8 +95,8 @@ static int msi_wmi_set_block(int instance, int value)
 
 	struct acpi_buffer input = { sizeof(int), &value };
 
-	dprintk("Going to set block of instance: %d - value: %d\n",
-		instance, value);
+	pr_debug("Going to set block of instance: %d - value: %d\n",
+		 instance, value);
 
 	status = wmi_set_block(MSIWMI_BIOS_GUID, instance, &input);
 
@@ -112,20 +110,19 @@ static int bl_get(struct backlight_device *bd)
 	/* Instance 1 is "get backlight", cmp with DSDT */
 	err = msi_wmi_query_block(1, &ret);
 	if (err) {
-		printk(KERN_ERR DRV_PFX "Could not query backlight: %d\n", err);
+		pr_err("Could not query backlight: %d\n", err);
 		return -EINVAL;
 	}
-	dprintk("Get: Query block returned: %d\n", ret);
+	pr_debug("Get: Query block returned: %d\n", ret);
 	for (level = 0; level < ARRAY_SIZE(backlight_map); level++) {
 		if (backlight_map[level] == ret) {
-			dprintk("Current backlight level: 0x%X - index: %d\n",
-				backlight_map[level], level);
+			pr_debug("Current backlight level: 0x%X - index: %d\n",
+				 backlight_map[level], level);
 			break;
 		}
 	}
 	if (level == ARRAY_SIZE(backlight_map)) {
-		printk(KERN_ERR DRV_PFX "get: Invalid brightness value: 0x%X\n",
-		       ret);
+		pr_err("get: Invalid brightness value: 0x%X\n", ret);
 		return -EINVAL;
 	}
 	return level;
@@ -156,7 +153,7 @@ static void msi_wmi_notify(u32 value, void *context)
 
 	status = wmi_get_event_data(value, &response);
 	if (status != AE_OK) {
-		printk(KERN_INFO DRV_PFX "bad event status 0x%x\n", status);
+		pr_info("bad event status 0x%x\n", status);
 		return;
 	}
 
@@ -164,7 +161,7 @@ static void msi_wmi_notify(u32 value, void *context)
 
 	if (obj && obj->type == ACPI_TYPE_INTEGER) {
 		int eventcode = obj->integer.value;
-		dprintk("Eventcode: 0x%x\n", eventcode);
+		pr_debug("Eventcode: 0x%x\n", eventcode);
 		key = sparse_keymap_entry_from_scancode(msi_wmi_input_dev,
 				eventcode);
 		if (key) {
@@ -175,8 +172,8 @@ static void msi_wmi_notify(u32 value, void *context)
 			/* Ignore event if the same event happened in a 50 ms
 			   timeframe -> Key press may result in 10-20 GPEs */
 			if (ktime_to_us(diff) < 1000 * 50) {
-				dprintk("Suppressed key event 0x%X - "
-					"Last press was %lld us ago\n",
+				pr_debug("Suppressed key event 0x%X - "
+					 "Last press was %lld us ago\n",
 					 key->code, ktime_to_us(diff));
 				return;
 			}
@@ -187,17 +184,16 @@ static void msi_wmi_notify(u32 value, void *context)
 			(!acpi_video_backlight_support() ||
 			(key->code != MSI_WMI_BRIGHTNESSUP &&
 			key->code != MSI_WMI_BRIGHTNESSDOWN))) {
-				dprintk("Send key: 0x%X - "
-					"Input layer keycode: %d\n", key->code,
-					 key->keycode);
+				pr_debug("Send key: 0x%X - "
+					 "Input layer keycode: %d\n",
+					 key->code, key->keycode);
 				sparse_keymap_report_entry(msi_wmi_input_dev,
 						key, 1, true);
 			}
 		} else
-			printk(KERN_INFO "Unknown key pressed - %x\n",
-			       eventcode);
+			pr_info("Unknown key pressed - %x\n", eventcode);
 	} else
-		printk(KERN_INFO DRV_PFX "Unknown event received\n");
+		pr_info("Unknown event received\n");
 	kfree(response.pointer);
 }
 
@@ -238,8 +234,7 @@ static int __init msi_wmi_init(void)
 	int err;
 
 	if (!wmi_has_guid(MSIWMI_EVENT_GUID)) {
-		printk(KERN_ERR
-		       "This machine doesn't have MSI-hotkeys through WMI\n");
+		pr_err("This machine doesn't have MSI-hotkeys through WMI\n");
 		return -ENODEV;
 	}
 	err = wmi_install_notify_handler(MSIWMI_EVENT_GUID,
@@ -270,7 +265,7 @@ static int __init msi_wmi_init(void)
 
 		backlight->props.brightness = err;
 	}
-	dprintk("Event handler installed\n");
+	pr_debug("Event handler installed\n");
 
 	return 0;
 
-- 
1.7.4.2.g597a6.dirty

