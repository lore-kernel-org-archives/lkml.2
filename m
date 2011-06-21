Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1FUNCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:02:05 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:48726 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab1FUNCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:02:00 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] hid-multitouch: ensure slots are initialized
Date: Tue, 21 Jun 2011 15:01:53 +0200
Message-Id: <1308661315-6240-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308661315-6240-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1308661315-6240-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case a device does not provide the feature "Maximum Contact Count",
or set it at 0, the maxcontacts field may be at 0 while calling
input_mt_init_slots.
This patch ensures that hid-multitouch will allways report
ABS_MT_SLOT and ABS_MT_TRACKING_ID to the user space.

This corrects a bug found with some Ilitek devices that has been
integrated in 3.0-rc0.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0b2dcd0..3867656 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -271,6 +271,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			}
 			return 1;
 		case HID_DG_CONTACTID:
+			if (!td->maxcontacts)
+				td->maxcontacts = MT_DEFAULT_MAXCONTACT;
 			input_mt_init_slots(hi->input, td->maxcontacts);
 			td->last_slot_field = usage->hid;
 			td->last_field_index = field->index;
@@ -547,9 +549,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto fail;
 
-	if (!td->maxcontacts)
-		td->maxcontacts = MT_DEFAULT_MAXCONTACT;
-
 	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
 				GFP_KERNEL);
 	if (!td->slots) {
-- 
1.7.4.4

