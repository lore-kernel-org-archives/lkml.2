Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1HOXpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:45:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36553 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1HOXpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:45:19 -0400
From: jeffbrown@android.com
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, rydberg@euromail.se,
        benjamin.tissoires@enac.fr, chatty@enac.fr,
        Jeff Brown <jeffbrown@android.com>
Subject: [PATCH] hid-multitouch: Filter collections by application usage.
Date: Mon, 15 Aug 2011 16:44:28 -0700
Message-Id: <1313451868-79836-1-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Brown <jeffbrown@android.com>

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

