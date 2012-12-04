Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2LDP2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:28:24 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50038 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2LDP2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:28:18 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] HID: i2c-hid: fix memory corruption due to missing hid declaration
Date: Tue,  4 Dec 2012 16:27:43 +0100
Message-Id: <1354634875-5182-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID descriptors contains 4 bytes of reserved field.
The previous implementation was overriding the next fields in struct i2c_hid.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 0fbb229..ad771a7 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -68,6 +68,7 @@ struct i2c_hid_desc {
 	__le16 wVendorID;
 	__le16 wProductID;
 	__le16 wVersionID;
+	__le32 reserved;
 } __packed;
 
 struct i2c_hid_cmd {
@@ -778,7 +779,7 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
 	}
 
 	dsize = le16_to_cpu(hdesc->wHIDDescLength);
-	if (!dsize || dsize > HID_MAX_DESCRIPTOR_SIZE) {
+	if (!dsize || dsize > sizeof(struct i2c_hid_desc)) {
 		dev_err(&client->dev, "weird size of HID descriptor (%u)\n",
 			dsize);
 		return -ENODEV;
-- 
1.8.0.1

