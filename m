Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1CJEeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:34:21 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:48018 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1CJEeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 23:34:16 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr, Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 2/2] hid-ntrig: init settle and mode check
Date: Wed,  9 Mar 2011 23:33:52 -0500
Message-Id: <1299731632-9814-2-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299731632-9814-1-git-send-email-rafi@seas.upenn.edu>
References: <1299731632-9814-1-git-send-email-rafi@seas.upenn.edu>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-10_03:2011-03-10,2011-03-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a wait before the wakeup signal.

As a precautionary measure sanity check the current sensor mode.  If
needed reset it to "dual".

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>

When the device is responding poorly and needs the wakeup call, it was
missing it.  Giving it a chance to settle first improves the chances
that signal gets through.

I was also seeing the device come up in strange modes where it did not
respond to physical stimulus.  Hopefully the quirk will fix that, but
even so it seems like a good idea to check.  It also makes me curious
what the "off" code is.
---
 drivers/hid/hid-ntrig.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 850ba14..fa862c5 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -110,6 +110,36 @@ static int ntrig_version_string(unsigned char *raw, char *buf)
 	return sprintf(buf, "%u.%u.%u.%u.%u", a, b, c, d, e);
 }
 
+static inline int ntrig_get_mode(struct hid_device *hdev)
+{
+	struct hid_report *report = hdev->report_enum[HID_FEATURE_REPORT].
+				    report_id_hash[0x0d];
+
+	if (!report)
+		return -EINVAL;
+
+	usbhid_submit_report(hdev, report, USB_DIR_IN);
+	usbhid_wait_io(hdev);
+	return (int)report->field[0]->value[0];
+}
+
+static inline void ntrig_set_mode(struct hid_device *hdev, const int mode)
+{
+	struct hid_report *report;
+	__u8 mode_commands[4] = { 0xe, 0xf, 0x1b, 0x10 };
+
+	if (mode < 0 || mode > 3)
+		return;
+
+	report = hdev->report_enum[HID_FEATURE_REPORT].
+		 report_id_hash[mode_commands[mode]];
+
+	if (!report)
+		return;
+
+	usbhid_submit_report(hdev, report, USB_DIR_IN);
+}
+
 static void ntrig_report_version(struct hid_device *hdev)
 {
 	int ret;
@@ -905,8 +935,19 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	/* This is needed for devices with more recent firmware versions */
 	report = hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0x0a];
-	if (report)
-		usbhid_submit_report(hdev, report, USB_DIR_OUT);
+	if (report) {
+		/* Let the device settle to ensure the wakeup message gets
+		 * through */
+		usbhid_wait_io(hdev);
+		usbhid_submit_report(hdev, report, USB_DIR_IN);
+
+		/*
+		 * Sanity check: if the current mode is invalid reset it to
+		 * something reasonable.
+		 */
+		if (ntrig_get_mode(hdev) >= 4)
+			ntrig_set_mode(hdev, 3);
+	}
 
 	ntrig_report_version(hdev);
 
-- 
1.7.4.1

