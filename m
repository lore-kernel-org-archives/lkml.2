Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2LDP2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:28:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42161 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2LDP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:28:37 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] HID: i2c-hid: fix i2c_hid_get_raw_report count mismatches
Date: Tue,  4 Dec 2012 16:27:55 +0100
Message-Id: <1354634875-5182-15-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous memcpy implementation relied on the size advertized by the
device. There were no guarantees that buf was big enough.

Some gymnastic is also required with the +2/-2 to take into account
the first 2 bytes where the total length is supplied by the device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 62988f1..de3566f 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -503,13 +503,14 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 {
 	struct i2c_client *client = hid->driver_data;
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
+	size_t rcount;
 	int ret;
 
 	if (report_type == HID_OUTPUT_REPORT)
 		return -EINVAL;
 
-	if (count > ihid->bufsize)
-		count = ihid->bufsize;
+	if (count > ihid->bufsize - 2)
+		count = ihid->bufsize - 2;
 
 	ret = i2c_hid_get_report(client,
 			report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
@@ -518,7 +519,13 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 	if (ret < 0)
 		return ret;
 
-	count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
+	rcount = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
+
+	if (!rcount)
+		return 0;
+
+	if (count > rcount - 2)
+		count = rcount - 2;
 
 	memcpy(buf, ihid->inbuf + 2, count);
 
-- 
1.8.0.1

