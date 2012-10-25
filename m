Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946098Ab2JYOLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:11:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46798 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab2JYOLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:11:06 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] HID: hid-multitouch: get maxcontacts also from logical_max value
Date: Thu, 25 Oct 2012 16:09:43 +0200
Message-Id: <1351174189-24719-5-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win8 devices are required to present the feature "Maximum Contact Number".
Fortunately all win7 devices I've seen presents this feature.
If the current value is 0, then, the driver can get the actual supported
contact count by refering to the logical_max.
This win8 specification ensures that logical_max may not be above 250.
This also allows us to detect when devices like irtouch or stantum reports
an obviously wrong value of 255.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e96ecc3..38a4feb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -121,6 +121,7 @@ struct mt_device {
 #define MT_CLS_GENERALTOUCH_PWT_TENFINGERS	0x0109
 
 #define MT_DEFAULT_MAXCONTACT	10
+#define MT_MAX_MAXCONTACT	250
 
 #define MT_USB_DEVICE(v, p)	HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH, v, p)
 #define MT_BT_DEVICE(v, p)	HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH, v, p)
@@ -283,6 +284,9 @@ static void mt_feature_mapping(struct hid_device *hdev,
 	case HID_DG_CONTACTMAX:
 		td->maxcontact_report_id = field->report->id;
 		td->maxcontacts = field->value[0];
+		if (!td->maxcontacts &&
+		    field->logical_maximum <= MT_MAX_MAXCONTACT)
+			td->maxcontacts = field->logical_maximum;
 		if (td->mtclass.maxcontacts)
 			/* check if the maxcontacts is given by the class */
 			td->maxcontacts = td->mtclass.maxcontacts;
-- 
1.7.11.7

