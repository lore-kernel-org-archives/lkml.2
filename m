Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab1AERgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:36:14 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:38908 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1AEReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:34:36 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [RFC v2 06/10] hid-multitouch: added support for Cypress TrueTouch panels
Date: Wed,  5 Jan 2011 18:27:44 +0100
Message-Id: <1294248468-19979-7-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for Cypress TrueTouch panels, which detect up to 10 fingers

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Stéphane Chatty <chatty@enac.fr>
---
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |   15 +++++++++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9f1ab80..1dcb4b0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1299,6 +1299,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, 0x0006) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 70dd0fd..d8b0b3f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -181,6 +181,7 @@
 #define USB_DEVICE_ID_CYPRESS_BARCODE_1	0xde61
 #define USB_DEVICE_ID_CYPRESS_BARCODE_2	0xde64
 #define USB_DEVICE_ID_CYPRESS_BARCODE_3	0xbca1
+#define USB_DEVICE_ID_CYPRESS_TRUETOUCH	0xc001
 
 #define USB_VENDOR_ID_DEALEXTREAME	0x10c5
 #define USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701	0x819a
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 9edbf5d..f9d537e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -65,6 +65,7 @@ struct mt_class {
 #define MT_CLS_DEFAULT 0
 #define MT_CLS_DUAL1 1
 #define MT_CLS_DUAL2 2
+#define MT_CLS_CYPRESS 3
 
 /*
  * these device-dependent functions determine what slot corresponds
@@ -81,6 +82,14 @@ static int slot_is_contactnumber(struct mt_device *td)
 	return td->num_received;
 }
 
+static int cypress_compute_slot(struct mt_device *td)
+{
+	if (td->curdata.contactid != 0 || td->num_received == 0)
+		return td->curdata.contactid;
+	else
+		return -1;
+}
+
 static int find_slot_from_contactid(struct mt_device *td)
 {
 	int i;
@@ -100,6 +109,7 @@ struct mt_class mt_classes[] = {
 	{ find_slot_from_contactid, 10 },     /* MT_CLS_DEFAULT */
 	{ slot_is_contactid, 2 },             /* MT_CLS_DUAL1 */
 	{ slot_is_contactnumber, 2 },         /* MT_CLS_DUAL2 */
+	{ cypress_compute_slot, 10 },         /* MT_CLS_CYPRESS */
 };
 
 static void mt_feature_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -414,6 +424,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 
+	/* Cypress panel */
+	{ .driver_data = MT_CLS_CYPRESS,
+		HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
+			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
+
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mt_devices);
-- 
1.7.3.4

