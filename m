Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab2JYOOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:14:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63311 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946072Ab2JYOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:11:04 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] HID: hid-multitouch: support arrays for the split of the touches in a report
Date: Thu, 25 Oct 2012 16:09:42 +0200
Message-Id: <1351174189-24719-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win8 certification introduced the ability to transmit two X and two Y per
touch. The specification precises that it must be in an array, with a
report count == 2.

This test guarantees that we split the touches on the last element
in this array.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1382554..e96ecc3 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -577,12 +577,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			return 0;
 		}
 
-		if (usage->hid == td->last_slot_field)
-			mt_complete_slot(td, field->hidinput->input);
-
-		if (field->index == td->last_field_index
-			&& td->num_received >= td->num_expected)
-			mt_sync_frame(td, field->hidinput->input);
+		if (usage_index + 1 == field->report_count) {
+			/* we only take into account the last report
+			 * of a field if report_count > 1 */
+			if (usage->hid == td->last_slot_field)
+				mt_complete_slot(td, field->hidinput->input);
+
+			if (field->index == td->last_field_index
+				&& td->num_received >= td->num_expected)
+				mt_sync_frame(td, field->hidinput->input);
+		}
 
 	}
 
-- 
1.7.11.7

