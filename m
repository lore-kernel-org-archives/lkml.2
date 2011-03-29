Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1C2WWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:30 -0400
Received: from mail.perches.com ([173.55.12.10]:4369 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab1C2WW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:28 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/23] hp-wmi: Convert printks to pr_<level>
Date: Tue, 29 Mar 2011 15:21:41 -0700
Message-Id: <a4062d14ef6deec739f881c73e703b9256f37a8f.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added pr_fmt and converted printks to pr_<level>.
Removed now unused PREFIX and UNIMPL #defines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/hp-wmi.c |   43 ++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 1bc4a75..f94017b 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -24,6 +24,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -54,9 +56,6 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 #define HPWMI_HOTKEY_QUERY 0xc
 #define HPWMI_WIRELESS2_QUERY 0x1b
 
-#define PREFIX "HP WMI: "
-#define UNIMP "Unimplemented "
-
 enum hp_wmi_radio {
 	HPWMI_WIFI = 0,
 	HPWMI_BLUETOOTH = 1,
@@ -228,9 +227,8 @@ static int hp_wmi_perform_query(int query, int write, void *buffer,
 
 	if (bios_return->return_code) {
 		if (bios_return->return_code != HPWMI_RET_UNKNOWN_CMDTYPE)
-			printk(KERN_WARNING PREFIX "query 0x%x returned "
-						   "error 0x%x\n",
-			       query, bios_return->return_code);
+			pr_warn("query 0x%x returned error 0x%x\n",
+				query, bios_return->return_code);
 		kfree(obj);
 		return bios_return->return_code;
 	}
@@ -384,8 +382,7 @@ static int hp_wmi_rfkill2_refresh(void)
 
 		if (num >= state.count ||
 		    devstate->rfkill_id != rfkill2[i].id) {
-			printk(KERN_WARNING PREFIX "power configuration of "
-			       "the wireless devices unexpectedly changed\n");
+			pr_warn("power configuration of the wireless devices unexpectedly changed\n");
 			continue;
 		}
 
@@ -471,7 +468,7 @@ static void hp_wmi_notify(u32 value, void *context)
 
 	status = wmi_get_event_data(value, &response);
 	if (status != AE_OK) {
-		printk(KERN_INFO PREFIX "bad event status 0x%x\n", status);
+		pr_info("bad event status 0x%x\n", status);
 		return;
 	}
 
@@ -480,8 +477,7 @@ static void hp_wmi_notify(u32 value, void *context)
 	if (!obj)
 		return;
 	if (obj->type != ACPI_TYPE_BUFFER) {
-		printk(KERN_INFO "hp-wmi: Unknown response received %d\n",
-		       obj->type);
+		pr_info("Unknown response received %d\n", obj->type);
 		kfree(obj);
 		return;
 	}
@@ -498,8 +494,7 @@ static void hp_wmi_notify(u32 value, void *context)
 		event_id = *location;
 		event_data = *(location + 2);
 	} else {
-		printk(KERN_INFO "hp-wmi: Unknown buffer length %d\n",
-		       obj->buffer.length);
+		pr_info("Unknown buffer length %d\n", obj->buffer.length);
 		kfree(obj);
 		return;
 	}
@@ -527,8 +522,7 @@ static void hp_wmi_notify(u32 value, void *context)
 
 		if (!sparse_keymap_report_event(hp_wmi_input_dev,
 						key_code, 1, true))
-			printk(KERN_INFO PREFIX "Unknown key code - 0x%x\n",
-			       key_code);
+			pr_info("Unknown key code - 0x%x\n", key_code);
 		break;
 	case HPWMI_WIRELESS:
 		if (rfkill2_count) {
@@ -550,14 +544,12 @@ static void hp_wmi_notify(u32 value, void *context)
 					  hp_wmi_get_hw_state(HPWMI_WWAN));
 		break;
 	case HPWMI_CPU_BATTERY_THROTTLE:
-		printk(KERN_INFO PREFIX UNIMP "CPU throttle because of 3 Cell"
-		       " battery event detected\n");
+		pr_info("Unimplemented CPU throttle because of 3 Cell battery event detected\n");
 		break;
 	case HPWMI_LOCK_SWITCH:
 		break;
 	default:
-		printk(KERN_INFO PREFIX "Unknown event_id - %d - 0x%x\n",
-		       event_id, event_data);
+		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
 	}
 }
@@ -705,7 +697,7 @@ static int __devinit hp_wmi_rfkill2_setup(struct platform_device *device)
 		return err;
 
 	if (state.count > HPWMI_MAX_RFKILL2_DEVICES) {
-		printk(KERN_WARNING PREFIX "unable to parse 0x1b query output\n");
+		pr_warn("unable to parse 0x1b query output\n");
 		return -EINVAL;
 	}
 
@@ -727,14 +719,14 @@ static int __devinit hp_wmi_rfkill2_setup(struct platform_device *device)
 			name = "hp-wwan";
 			break;
 		default:
-			printk(KERN_WARNING PREFIX "unknown device type 0x%x\n",
-				 state.device[i].radio_type);
+			pr_warn("unknown device type 0x%x\n",
+				state.device[i].radio_type);
 			continue;
 		}
 
 		if (!state.device[i].vendor_id) {
-			printk(KERN_WARNING PREFIX "zero device %d while %d "
-			       "reported\n", i, state.count);
+			pr_warn("zero device %d while %d reported\n",
+				i, state.count);
 			continue;
 		}
 
@@ -755,8 +747,7 @@ static int __devinit hp_wmi_rfkill2_setup(struct platform_device *device)
 				    IS_HWBLOCKED(state.device[i].power));
 
 		if (!(state.device[i].power & HPWMI_POWER_BIOS))
-			printk(KERN_INFO PREFIX "device %s blocked by BIOS\n",
-			       name);
+			pr_info("device %s blocked by BIOS\n", name);
 
 		err = rfkill_register(rfkill);
 		if (err) {
-- 
1.7.4.2.g597a6.dirty

