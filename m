Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2KGQjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:39:51 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56660 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGQiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:38:05 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/13] HID: hid-multitouch: move ALWAYS_VALID quirk check
Date: Wed,  7 Nov 2012 17:37:31 +0100
Message-Id: <1352306256-12180-9-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win 8 device specification changed the requirements for the hid usages
of the multitouch devices. Now InRange is optional and must be only
used when the device supports hovering.

This ensures that the quirk ALWAYS_VALID is taken into account and
also ensures its precedence over the other VALID* quirks.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 54367f4..2352770 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -503,7 +503,7 @@ static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
  */
 static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 {
-	if (td->curvalid) {
+	if (td->curvalid || (td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID)) {
 		int slotnum = mt_compute_slot(td, input);
 		struct mt_slot *s = &td->curdata;
 
@@ -554,9 +554,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
-			if (quirks & MT_QUIRK_ALWAYS_VALID)
-				td->curvalid = true;
-			else if (quirks & MT_QUIRK_VALID_IS_INRANGE)
+			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
 				td->curvalid = value;
 			break;
 		case HID_DG_TIPSWITCH:
-- 
1.7.11.7

