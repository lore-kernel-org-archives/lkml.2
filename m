Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2LEOEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:04:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44051 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2LEODJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:03:09 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] HID: i2c-hid: fix memory corruption due to missing hid declaration
Date: Wed,  5 Dec 2012 15:02:53 +0100
Message-Id: <1354716176-12558-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID descriptors contains 4 bytes of reserved field.
The previous implementation was overriding the next fields in struct i2c_hid.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 7062df2..34cca42 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -69,6 +69,7 @@ struct i2c_hid_desc {
 	__le16 wVendorID;
 	__le16 wProductID;
 	__le16 wVersionID;
+	__le32 reserved;
 } __packed;
 
 struct i2c_hid_cmd {
@@ -776,7 +777,13 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
 	}
 
 	dsize = le16_to_cpu(hdesc->wHIDDescLength);
-	if (!dsize || dsize > HID_MAX_DESCRIPTOR_SIZE) {
+	/*
+	 * the size of the HID descriptor should at least contain
+	 * its size and the bcdVersion (4 bytes), and should not be greater
+	 * than sizeof(struct i2c_hid_desc) as we directly fill this struct
+	 * through i2c_hid_command.
+	 */
+	if (dsize < 4 || dsize > sizeof(struct i2c_hid_desc)) {
 		dev_err(&client->dev, "weird size of HID descriptor (%u)\n",
 			dsize);
 		return -ENODEV;
-- 
1.8.0.1

