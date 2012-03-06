Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab2CFQ5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:57:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab2CFQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:57:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benjamin.tissoires@gmail.com designates 10.180.81.37 as permitted sender) smtp.mail=benjamin.tissoires@gmail.com; dkim=pass header.i=benjamin.tissoires@gmail.com
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] HID: multitouch: detect serial protocol
Date: Tue,  6 Mar 2012 17:57:06 +0100
Message-Id: <1331053026-21272-6-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Microsoft's documentation about multitouch protocols tells that
if a device presents one touch per report, then it should be treated
as a serial protocol.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index a61ba42..6fb46d7 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -81,6 +81,9 @@ struct mt_device {
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */
 	__u8 maxcontacts;
+	__u8 touches_by_report;	/* how many touches are present in one report:
+				* 1 means we should use a serial protocol
+				* > 1 means hybrid (multitouch) protocol */
 	bool curvalid;		/* is the current contact valid? */
 	struct mt_slot *slots;
 };
@@ -365,6 +368,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			input_mt_init_slots(hi->input, td->maxcontacts);
 			td->last_slot_field = usage->hid;
 			td->last_field_index = field->index;
+			td->touches_by_report++;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
@@ -670,6 +674,15 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto fail;
 
+	if (!id && td->touches_by_report == 1) {
+		/* the device has been sent by hid-generic */
+		mtclass = &td->mtclass;
+		mtclass->quirks |= MT_QUIRK_ALWAYS_VALID;
+		mtclass->quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
+		mtclass->quirks &= ~MT_QUIRK_VALID_IS_INRANGE;
+		mtclass->quirks &= ~MT_QUIRK_VALID_IS_CONFIDENCE;
+	}
+
 	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
 				GFP_KERNEL);
 	if (!td->slots) {
-- 
1.7.7.6

