Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2KGQiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:38:12 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56660 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab2KGQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:38:08 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/13] HID: hid-multitouch: fix Win 8 protocol
Date: Wed,  7 Nov 2012 17:37:33 +0100
Message-Id: <1352306256-12180-11-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win 8 specification is much more precise than the Win 7 one.
Moreover devices that need to take certification must be submitted
to Microsoft.

The result is a better protocol support and we can rely on that to
skip all the messy tests we used to do.

The protocol specify the fact that each valid touch must be reported
within a frame until it is released.
So we can use the always_valid quirk and dismiss reports when we see
duplicates contact ID.

We recognize Win8 certified devices from their vendor feature 0xff0000c5
where Microsoft put a signed blob in the report to check if the device
passed the certification.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 351c814..b393c6c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -53,6 +53,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
 #define MT_QUIRK_NO_AREA		(1 << 9)
 #define MT_QUIRK_IGNORE_DUPLICATES	(1 << 10)
+#define MT_QUIRK_WIN_8_CERTIFIED	(1 << 11)
 
 struct mt_slot {
 	__s32 x, y, cx, cy, p, w, h;
@@ -293,6 +294,10 @@ static void mt_feature_mapping(struct hid_device *hdev,
 			td->maxcontacts = td->mtclass.maxcontacts;
 
 		break;
+	case 0xff0000c5:
+		if (field->report_count == 256 && field->report_size == 8)
+			td->mtclass.quirks |= MT_QUIRK_WIN_8_CERTIFIED;
+		break;
 	}
 }
 
@@ -679,14 +684,17 @@ static void mt_post_parse_default_settings(struct mt_device *td)
 {
 	__s32 quirks = td->mtclass.quirks;
 
-	/* unknown serial device needs special quirks */
-	if (td->touches_by_report == 1) {
+	/* unknown serial devices or win8 ones need special quirks */
+	if (td->touches_by_report == 1 || (quirks & MT_QUIRK_WIN_8_CERTIFIED)) {
 		quirks |= MT_QUIRK_ALWAYS_VALID;
 		quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
 		quirks &= ~MT_QUIRK_VALID_IS_INRANGE;
 		quirks &= ~MT_QUIRK_VALID_IS_CONFIDENCE;
 	}
 
+	if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
+		quirks |= MT_QUIRK_IGNORE_DUPLICATES;
+
 	td->mtclass.quirks = quirks;
 }
 
-- 
1.7.11.7

