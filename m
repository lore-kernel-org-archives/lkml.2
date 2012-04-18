Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2DRV6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:58:14 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:54761 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2DRV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:58:11 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqNgALc3j09V5qnhPGdsb2JhbABEiienGRkBAQEBNzSCCgEFJy8TAQ8QCBE4OQoUBhOIE7sbE5AiBJtxjSGBUhc
X-IronPort-AV: E=Sophos;i="4.75,444,1330902000"; 
   d="scan'208";a="20123730"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 5/5] hid-multitouch: Remove remnant quirk handling
Date: Thu, 19 Apr 2012 00:00:57 +0200
Message-Id: <1334786457-2124-6-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334786457-2124-1-git-send-email-rydberg@euromail.se>
References: <1334786457-2124-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With device groups in place, the temporary HID_QUIRK_MULTITOUCH quirk
is no longer used and can be removed.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c       |   15 ++-------------
 drivers/hid/hid-input.c      |    7 -------
 drivers/hid/hid-multitouch.c |    1 -
 include/linux/hid.h          |    1 -
 4 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 67d1470..2fbbdef 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1238,10 +1238,6 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	if ((connect_mask & HID_CONNECT_HIDINPUT) && !hidinput_connect(hdev,
 				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
 		hdev->claimed |= HID_CLAIMED_INPUT;
-	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
-		/* this device should be handled by hid-multitouch, skip it */
-		return -ENODEV;
-	}
 
 	if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
 			!hdev->hiddev_connect(hdev,
@@ -1626,10 +1622,6 @@ static int hid_bus_match(struct device *dev, struct device_driver *drv)
 	struct hid_driver *hdrv = container_of(drv, struct hid_driver, driver);
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 
-	if ((hdev->quirks & HID_QUIRK_MULTITOUCH) &&
-		!strncmp(hdrv->name, "hid-multitouch", 14))
-		return 1;
-
 	if (!hid_match_device(hdev, hdrv))
 		return 0;
 
@@ -1654,11 +1646,8 @@ static int hid_device_probe(struct device *dev)
 	if (!hdev->driver) {
 		id = hid_match_device(hdev, hdrv);
 		if (id == NULL) {
-			if (!((hdev->quirks & HID_QUIRK_MULTITOUCH) &&
-				!strncmp(hdrv->name, "hid-multitouch", 14))) {
-				ret = -ENODEV;
-				goto unlock;
-			}
+			ret = -ENODEV;
+			goto unlock;
 		}
 
 		hdev->driver = hdrv;
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 62d13ee..7b43186 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1204,13 +1204,6 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 		}
 	}
 
-	if (hid->quirks & HID_QUIRK_MULTITOUCH) {
-		/* generic hid does not know how to handle multitouch devices */
-		if (hidinput)
-			goto out_cleanup;
-		goto out_unwind;
-	}
-
 	if (hidinput && input_register_device(hidinput->input))
 		goto out_cleanup;
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e5749b3..14f3b51 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -657,7 +657,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * that emit events over several HID messages.
 	 */
 	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
-	hdev->quirks &= ~HID_QUIRK_MULTITOUCH;
 
 	td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
 	if (!td) {
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 4c5c3e4..8022068 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -323,7 +323,6 @@ struct hid_item {
 #define HID_QUIRK_BADPAD			0x00000020
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
-#define HID_QUIRK_MULTITOUCH			0x00000100
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
-- 
1.7.10

