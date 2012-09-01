Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2IATnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:43:45 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:37001 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab2IATnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:43:43 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnxPAMRkQlBV5qoUPGdsb2JhbABEhRyFI7BfGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG6NxSSHAObR40R
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="180547917"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH 20/20] HID: hid-multitouch: Add missing contact count detection
Date: Sat,  1 Sep 2012 21:47:15 +0200
Message-Id: <1346528835-363-21-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346528835-363-1-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices report the number of contacts via the CONTACTCOUNT usage,
rather than using the CONTACTMAX feature. Without this patch, such
devices will be capped to ten fingers, the default maximum. Fixes a
long-standing regression on 3M and similar panels.

Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Since this patch looks like it could be backported as-is: In 3.6,
maxcontacts may be modified after the slots have been initialized,
leaving the patch harmless but ineffective.

 drivers/hid/hid-multitouch.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index eee19c9..2fc5335 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -388,6 +388,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
+			if (td->maxcontacts < field->logical_maximum + 1)
+				td->maxcontacts = field->logical_maximum + 1;
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
-- 
1.7.12

