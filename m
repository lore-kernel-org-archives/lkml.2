Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab2JYOMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:12:37 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33526 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2JYOLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:11:12 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] HID: hid-multitouch: fix Win 8 protocol
Date: Thu, 25 Oct 2012 16:09:46 +0200
Message-Id: <1351174189-24719-8-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win 8 specification is much more precise than the Win 7 one.
Moreover devices that need to take certification must be submitted
to Microsoft.

The result is a better protocol support and we can rely on that to
skip all the messy tests we used to do.

The protocol specify the fact that each valid touch must be reported
within a frame, and that the release touch coordinate must be the
same than the last known touch.
So we can use the always_valid quirk and dismiss reports when we
touch coordiante do not follow this rule.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c8290e2..6d4ad30 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -510,6 +510,18 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 		int slotnum = mt_compute_slot(td, input);
 		struct mt_slot *s = &td->curdata;
 
+		if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
+		    !s->touch_state) {
+			struct input_mt_slot *slot = &input->mt->slots[slotnum];
+			int prv_x = input_mt_get_value(slot, ABS_MT_POSITION_X);
+			int prv_y = input_mt_get_value(slot, ABS_MT_POSITION_Y);
+			/* valid releases occurs when the last x and y positions
+			 * are the same as the last known touch. */
+			if (!input_mt_is_active(slot) ||
+			    prv_x != s->x || prv_y != s->y)
+				return;
+		}
+
 		if (slotnum < 0 || slotnum >= td->maxcontacts)
 			return;
 
@@ -681,8 +693,8 @@ static void mt_post_parse_default_settings(struct mt_device *td)
 {
 	__s32 quirks = td->mtclass.quirks;
 
-	/* unknown serial device needs special quirks */
-	if (td->touches_by_report == 1) {
+	/* unknown serial devices or win8 ones need special quirks */
+	if (td->touches_by_report == 1 || quirks & MT_QUIRK_WIN_8_CERTIFIED) {
 		quirks |= MT_QUIRK_ALWAYS_VALID;
 		quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
 		quirks &= ~MT_QUIRK_VALID_IS_INRANGE;
-- 
1.7.11.7

