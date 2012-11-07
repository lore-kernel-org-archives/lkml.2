Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2KGQkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:40:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33927 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2KGQiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:38:02 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/13] HID: hid-multitouch: get maxcontacts also from logical_max value
Date: Wed,  7 Nov 2012 17:37:29 +0100
Message-Id: <1352306256-12180-7-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
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
Acked-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index a6a4e0a..ae57b8f 100644
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

