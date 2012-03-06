Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2CFQ5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:57:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37405 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2CFQ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:57:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benjamin.tissoires@gmail.com designates 10.216.135.97 as permitted sender) smtp.mail=benjamin.tissoires@gmail.com; dkim=pass header.i=benjamin.tissoires@gmail.com
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] HID: handle all multitouch devices through hid-multitouch
Date: Tue,  6 Mar 2012 17:57:04 +0100
Message-Id: <1331053026-21272-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

When the quirk HID_QUIRK_MULTITOUCH is present and when hid-multitouch
is loaded, let's pass the device to hid-multitouch even if it has
not been registered in hid-multitouch.

If any other driver wants to take precedence over hid-multitouch,
the usual way of adding it to hid_have_special_driver will work as
the quirk HID_QUIRK_MULTITOUCH won't be set by the generic hid layer.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-core.c       |   12 +++++++++---
 drivers/hid/hid-multitouch.c |   11 +++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 171e6ed..2390e00 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1230,7 +1230,6 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 		hdev->claimed |= HID_CLAIMED_INPUT;
 	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
 		/* this device should be handled by hid-multitouch, skip it */
-		hdev->quirks &= ~HID_QUIRK_MULTITOUCH;
 		return -ENODEV;
 	}
 
@@ -1663,6 +1662,10 @@ static int hid_bus_match(struct device *dev, struct device_driver *drv)
 	struct hid_driver *hdrv = container_of(drv, struct hid_driver, driver);
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 
+	if ((hdev->quirks & HID_QUIRK_MULTITOUCH) &&
+		!strncmp(hdrv->name, "hid-multitouch", 14))
+		return 1;
+
 	if (!hid_match_device(hdev, hdrv))
 		return 0;
 
@@ -1687,8 +1690,11 @@ static int hid_device_probe(struct device *dev)
 	if (!hdev->driver) {
 		id = hid_match_device(hdev, hdrv);
 		if (id == NULL) {
-			ret = -ENODEV;
-			goto unlock;
+			if (!((hdev->quirks & HID_QUIRK_MULTITOUCH) &&
+				!strncmp(hdrv->name, "hid-multitouch", 14))) {
+				ret = -ENODEV;
+				goto unlock;
+			}
 		}
 
 		hdev->driver = hdrv;
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 2088ab4..a61ba42 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -637,10 +637,12 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct mt_device *td;
 	struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
 
-	for (i = 0; mt_classes[i].name ; i++) {
-		if (id->driver_data == mt_classes[i].name) {
-			mtclass = &(mt_classes[i]);
-			break;
+	if (id) {
+		for (i = 0; mt_classes[i].name ; i++) {
+			if (id->driver_data == mt_classes[i].name) {
+				mtclass = &(mt_classes[i]);
+				break;
+			}
 		}
 	}
 
@@ -648,6 +650,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * that emit events over several HID messages.
 	 */
 	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
+	hdev->quirks &= ~HID_QUIRK_MULTITOUCH;
 
 	td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
 	if (!td) {
-- 
1.7.7.6

