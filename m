Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab0HXIz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:55:28 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:33800 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab0HXIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:55:25 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephane Chatty <chatty@enac.fr>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] hid: Add a hid quirk for input sync override
Date: Tue, 24 Aug 2010 10:54:44 +0200
Message-Id: <1282640084-19217-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OnpHX-0006Mk-61.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OnpHX-0006Mk-61 7d82cbfe46c51993d46e8c692e1fb1d1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Rydberg <rydberg@thabit.(none)>

As of lately, HID devices which send per-frame data split over several
HID reports have started to emerge. This patch adds a quirk which
allows the HID driver to take over the input layer synchronization,
and hence the control of the frame boundary.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Jiri, Dmitry, Stephane,

No doubt, this is not a final solution, but it serves the purpose of
being able to make existing drivers functional while a satisfactory
solution is being worked out.

Cheers,
Henrik

 drivers/hid/hid-input.c |    3 +++
 include/linux/hid.h     |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 69d152e..9d97934 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -656,6 +656,9 @@ void hidinput_report_event(struct hid_device *hid, struct hid_report *report)
 {
 	struct hid_input *hidinput;
 
+	if (hid->quirks & HID_QUIRK_NO_INPUT_SYNC)
+		return;
+
 	list_for_each_entry(hidinput, &hid->inputs, list)
 		input_sync(hidinput->input);
 }
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 895001f..8029883 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -315,6 +315,7 @@ struct hid_item {
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
 #define HID_QUIRK_NO_IGNORE			0x40000000
+#define HID_QUIRK_NO_INPUT_SYNC			0x80000000
 
 /*
  * This is the global environment of the parser. This information is
-- 
1.7.1

