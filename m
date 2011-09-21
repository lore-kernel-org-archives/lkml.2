Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1IUPFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:05:54 -0400
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:53512 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1IUPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:04:46 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 11:04:46 EDT
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 1/2] HID: add autodetection of multitouch devices
Date: Wed, 21 Sep 2011 16:56:54 +0200
Message-Id: <1316617015-11648-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by http://www.microsoft.com/whdc/device/input/DigitizerDrvs_touch.mspx
multitouch devices are those that have the input report HID_CONTACTID.

This patch detects this and unload the generic-usb driver.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-core.c  |    6 ++++++
 drivers/hid/hid-input.c |   11 +++++++++++
 include/linux/hid.h     |    1 +
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index af58e9c..7feac97 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1212,6 +1212,12 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	if ((connect_mask & HID_CONNECT_HIDINPUT) && !hidinput_connect(hdev,
 				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
 		hdev->claimed |= HID_CLAIMED_INPUT;
+	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
+		/* this device should be handled by hid-multitouch, skip it */
+		hdev->quirks &= ~HID_QUIRK_MULTITOUCH;
+		return -ENODEV;
+	}
+
 	if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
 			!hdev->hiddev_connect(hdev,
 				connect_mask & HID_CONNECT_HIDDEV_FORCE))
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 6559e2e..f333139 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -474,6 +474,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			map_key_clear(BTN_STYLUS2);
 			break;
 
+		case 0x51: /* ContactID */
+			device->quirks |= HID_QUIRK_MULTITOUCH;
+			goto unknown;
+
 		default:  goto unknown;
 		}
 		break;
@@ -978,6 +982,13 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 		}
 	}
 
+	if (hid->quirks & HID_QUIRK_MULTITOUCH) {
+		/* generic hid does not know how to handle multitouch devices */
+		if (hidinput)
+			goto out_cleanup;
+		goto out_unwind;
+	}
+
 	if (hidinput && input_register_device(hidinput->input))
 		goto out_cleanup;
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 42f7e2f..e55a0f8 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -312,6 +312,7 @@ struct hid_item {
 #define HID_QUIRK_BADPAD			0x00000020
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
+#define HID_QUIRK_MULTITOUCH			0x00000100
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
-- 
1.7.4.4

