Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1KPXhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 18:37:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44989 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1KPXhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 18:37:51 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] toshiba_acpi: Fix machines that don't support HCI_SYSTEM_EVENT
Date: Wed, 16 Nov 2011 17:37:45 -0600
Message-Id: <1321486665-12929-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Satellite C670-10V generates notifications for hotkeys but does
not support HCI_SYSTEM_EVENT. As a result when a hotkey is pressed
it gets stuck in an infinite loop in toshiba_acpi_notify. To fix
this, detect whether or not HCI_SYSTEM_EVENT is supported up-front
and don't try to read system events if it isn't supported. In
addition, limit the number of retries when reading HCI_SYSTEM_EVENT
fails so that this loop cannot run unbounded.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/toshiba_acpi.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 13ef8c3..dcdc1f4 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -121,6 +121,7 @@ struct toshiba_acpi_dev {
 	int illumination_supported:1;
 	int video_supported:1;
 	int fan_supported:1;
+	int system_event_supported:1;
 
 	struct mutex mutex;
 };
@@ -724,7 +725,7 @@ static int keys_proc_show(struct seq_file *m, void *v)
 	u32 hci_result;
 	u32 value;
 
-	if (!dev->key_event_valid) {
+	if (!dev->key_event_valid && dev->system_event_supported) {
 		hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
 		if (hci_result == HCI_SUCCESS) {
 			dev->key_event_valid = 1;
@@ -964,6 +965,8 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 
 	/* enable event fifo */
 	hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
+	if (hci_result == HCI_SUCCESS)
+		dev->system_event_supported = 1;
 
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
@@ -1032,12 +1035,15 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
 	u32 hci_result, value;
+	int retries = 3;
 
-	if (event != 0x80)
+	if (!dev->system_event_supported || event != 0x80)
 		return;
+
 	do {
 		hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
-		if (hci_result == HCI_SUCCESS) {
+		switch (hci_result) {
+		case HCI_SUCCESS:
 			if (value == 0x100)
 				continue;
 			/* act on key press; ignore key release */
@@ -1049,14 +1055,19 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 				pr_info("Unknown key %x\n",
 				       value);
 			}
-		} else if (hci_result == HCI_NOT_SUPPORTED) {
+			break;
+		case HCI_NOT_SUPPORTED:
 			/* This is a workaround for an unresolved issue on
 			 * some machines where system events sporadically
 			 * become disabled. */
 			hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
 			pr_notice("Re-enabled hotkeys\n");
+			/* fall through */
+		default:
+			retries--;
+			break;
 		}
-	} while (hci_result != HCI_EMPTY);
+	} while (retries && hci_result != HCI_EMPTY);
 }
 
 
-- 
1.7.5.4

