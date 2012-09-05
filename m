Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2IEQF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:05:58 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:33670 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2IEQF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:05:56 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AixzALx3R1BV5qoUPGdsb2JhbABFij+vVwSBCRkBAQEBHhkNJ4IgAQEFJxMcEwEPEAgDDgMDAQIBLhQlCgwOE4gRunsUin03hWtgA5VYhW+NEQ
X-IronPort-AV: E=Sophos;i="4.80,375,1344204000"; 
   d="scan'208";a="182904982"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 5 Sep 2012 18:12:18 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: Re: [PATCH 2/2] HID: hid-multitouch: Add Flatfrog support
Message-ID: <20120905161218.GA270@polaris.bitmath.org>
References: <1346858857-281-1-git-send-email-rydberg@euromail.se>
 <1346858857-281-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346858857-281-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:27:37PM +0200, Henrik Rydberg wrote:
> Add support for the Flatfrog Multitouch 3200 panel. This panel
> advertises some fields that it does not use, hence the new quirks.
> 
> Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---

I sent the wrong version, the one below is the correct one. Sorry
about the fuzz.

Henrik

>From 74a60bb74176c658938e07da301396b6f1d3fbee Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Wed, 5 Sep 2012 18:06:58 +0200
Subject: [PATCH v2] HID: hid-multitouch: Add Flatfrog support

Add support for the Flatfrog Multitouch 3200 panel. This panel
advertises some fields that it does not use, hence the new quirks.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-ids.h        |  3 +++
 drivers/hid/hid-multitouch.c | 33 ++++++++++++++++++++++++++-------
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1dcb76f..c843db9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -283,6 +283,9 @@
 #define USB_VENDOR_ID_EMS		0x2006
 #define USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II 0x0118
 
+#define USB_VENDOR_ID_FLATFROG		0x25b5
+#define USB_DEVICE_ID_MULTITOUCH_3200	0x0002
+
 #define USB_VENDOR_ID_ESSENTIAL_REALITY	0x0d7f
 #define USB_DEVICE_ID_ESSENTIAL_REALITY_P5 0x0100
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 63f120b..3cfd376 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -51,6 +51,8 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_INRANGE	(1 << 5)
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
+#define MT_QUIRK_NO_AREA		(1 << 9)
+#define MT_QUIRK_NO_PRESSURE		(1 << 10)
 
 struct mt_slot {
 	__s32 x, y, p, w, h;
@@ -115,6 +117,7 @@ struct mt_device {
 #define MT_CLS_EGALAX_SERIAL			0x0104
 #define MT_CLS_TOPSEED				0x0105
 #define MT_CLS_PANASONIC			0x0106
+#define MT_CLS_FLATFROG				0x0107
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -199,6 +202,13 @@ static struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
 		.maxcontacts = 4 },
 
+	{ .name = MT_CLS_FLATFROG,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+			MT_QUIRK_NO_AREA |
+			MT_QUIRK_NO_PRESSURE,
+		.sn_move = 2048,
+		.maxcontacts = 40,
+	},
 	{ }
 };
 
@@ -366,26 +376,30 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MAJOR);
-			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
-				cls->sn_width);
+			if (!(cls->quirks & MT_QUIRK_NO_AREA))
+				set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
+					cls->sn_width);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
-			set_abs(hi->input, ABS_MT_TOUCH_MINOR, field,
-				cls->sn_height);
-			input_set_abs_params(hi->input,
+			if (!(cls->quirks & MT_QUIRK_NO_AREA)) {
+				set_abs(hi->input, ABS_MT_TOUCH_MINOR, field,
+					cls->sn_height);
+				input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
+			}
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_PRESSURE);
-			set_abs(hi->input, ABS_MT_PRESSURE, field,
-				cls->sn_pressure);
+			if (!(cls->quirks & MT_QUIRK_NO_PRESSURE))
+				set_abs(hi->input, ABS_MT_PRESSURE, field,
+					cls->sn_pressure);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -860,6 +874,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_ELO,
 			USB_DEVICE_ID_ELO_TS2515) },
 
+	/* Flatfrog Panels */
+	{ .driver_data = MT_CLS_FLATFROG,
+		MT_USB_DEVICE(USB_VENDOR_ID_FLATFROG,
+			USB_DEVICE_ID_MULTITOUCH_3200) },
+
 	/* GeneralTouch panel */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
-- 
1.7.12

