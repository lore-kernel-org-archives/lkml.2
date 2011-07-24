Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1GXWH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 18:07:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35913 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1GXWHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 18:07:55 -0400
From: jeffbrown@android.com
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, chatty@enac.fr, benjamin.tissoires@enac.fr,
        Jeff Brown <jeffbrown@google.com>, jeffbrown@android.com
Subject: [PATCH 2/3] hid-multitouch: Filter collections by application usage.
Date: Sun, 24 Jul 2011 15:07:40 -0700
Message-Id: <1311545261-34067-2-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1311545261-34067-1-git-send-email-jeffbrown@android.com>
References: <1311545261-34067-1-git-send-email-jeffbrown@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Brown <jeffbrown@google.com>

This change fixes two problems.

First, it ensures that the hid-multitouch driver does not incorrectly
map GenericDesktop usages that are intended for other applications,
such as a Mouse.

Second, it sets the appropriate input properties so that user-space
can distinguish TouchScreen devices (INPUT_PROP_DIRECT) from
TouchPad devices (INPUT_PROP_POINTER) and configure them accordingly.

Signed-off-by: jeffbrown@android.com
---
 drivers/hid/hid-multitouch.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 58d0e7a..4ee21ac 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -213,6 +213,16 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	struct mt_class *cls = td->mtclass;
 	__s32 quirks = cls->quirks;
 
+	/* Only map fields from TouchScreen or TouchPad collections.
+         * We need to ignore fields that belong to other collections
+         * such as Mouse that might have the same GenericDesktop usages. */
+	if (field->application == HID_DG_TOUCHSCREEN)
+		set_bit(INPUT_PROP_DIRECT, hi->input->propbit);
+	else if (field->application == HID_DG_TOUCHPAD)
+		set_bit(INPUT_PROP_POINTER, hi->input->propbit);
+	else
+		return 0;
+
 	switch (usage->hid & HID_USAGE_PAGE) {
 
 	case HID_UP_GENDESK:
-- 
1.7.0.4

