Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422992Ab2KNP7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:59:50 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63070 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422874Ab2KNP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:59:48 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/14] HID: hid-multitouch: support arrays for the split of the touches in a report
Date: Wed, 14 Nov 2012 16:59:17 +0100
Message-Id: <1352908766-4492-6-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win8 certification introduced the ability to transmit two X and two Y per
touch. The specification precises that it must be used in an array.

This test guarantees that we split the touches on the last element
in this array.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-multitouch.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 9f64e36..a6a4e0a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -577,12 +577,15 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			return 0;
 		}
 
-		if (usage->hid == td->last_slot_field)
-			mt_complete_slot(td, field->hidinput->input);
-
-		if (field->index == td->last_field_index
-			&& td->num_received >= td->num_expected)
-			mt_sync_frame(td, field->hidinput->input);
+		if (usage->usage_index + 1 == field->report_count) {
+			/* we only take into account the last report. */
+			if (usage->hid == td->last_slot_field)
+				mt_complete_slot(td, field->hidinput->input);
+
+			if (field->index == td->last_field_index
+				&& td->num_received >= td->num_expected)
+				mt_sync_frame(td, field->hidinput->input);
+		}
 
 	}
 
-- 
1.8.0

