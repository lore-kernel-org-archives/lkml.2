Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2HGXju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:39:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2HGW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:28:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>,
        Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [ 027/122] HID: hid-multitouch: fix input mode feature command
Date: Tue,  7 Aug 2012 15:25:15 -0700
Message-Id: <20120807221950.667219464@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

commit 4aceed37e315e8eaa26cb4c8dfd619a32fa24669 upstream.

Zytronic panels shows a new way of setting the Input Mode feature.
This feature is put in the second usage in the HID feature, instead
of the first, as the majority of the multitouch devices.

This patch adds a detection step when the feature is presented to know
where the feature is located in the report. We can then trigger the right
command to the device. This removes the magic number "0" in the function
mt_set_input_mode.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-multitouch.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -83,6 +83,7 @@ struct mt_device {
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
+	__s8 inputmode_index;	/* InputMode HID feature index in the report */
 	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
 				   -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
@@ -260,10 +261,20 @@ static void mt_feature_mapping(struct hi
 		struct hid_field *field, struct hid_usage *usage)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
+	int i;
 
 	switch (usage->hid) {
 	case HID_DG_INPUTMODE:
 		td->inputmode = field->report->id;
+		td->inputmode_index = 0; /* has to be updated below */
+
+		for (i=0; i < field->maxusage; i++) {
+			if (field->usage[i].hid == usage->hid) {
+				td->inputmode_index = i;
+				break;
+			}
+		}
+
 		break;
 	case HID_DG_CONTACTMAX:
 		td->maxcontact_report_id = field->report->id;
@@ -618,7 +629,7 @@ static void mt_set_input_mode(struct hid
 	re = &(hdev->report_enum[HID_FEATURE_REPORT]);
 	r = re->report_id_hash[td->inputmode];
 	if (r) {
-		r->field[0]->value[0] = 0x02;
+		r->field[0]->value[td->inputmode_index] = 0x02;
 		usbhid_submit_report(hdev, r, USB_DIR_OUT);
 	}
 }


