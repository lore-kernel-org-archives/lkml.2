Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2LLRAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 12:00:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48323 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2LLRAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 12:00:16 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH v2] HID: i2c-hid: add mutex protecting open/close race
Date: Wed, 12 Dec 2012 18:00:02 +0100
Message-Id: <1355331602-1164-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not enter close function while someone else is in open.
This mutex prevents this race.

There is also no need to override the ret value with -EIO in case of
a failure of i2c_hid_set_power.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
---

Changes in v2:
* add mutex.h

Cheers,
Benjamin

 drivers/hid/i2c-hid/i2c-hid.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 6e1774c..9ef22244 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -33,6 +33,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/hid.h>
+#include <linux/mutex.h>
 
 #include <linux/i2c/i2c-hid.h>
 
@@ -117,6 +118,8 @@ static const struct i2c_hid_cmd hid_set_power_cmd =	{ I2C_HID_CMD(0x08) };
  * static const struct i2c_hid_cmd hid_set_protocol_cmd = { I2C_HID_CMD(0x07) };
  */
 
+static DEFINE_MUTEX(i2c_hid_open_mut);
+
 /* The main device structure */
 struct i2c_hid {
 	struct i2c_client	*client;	/* i2c client */
@@ -641,17 +644,20 @@ static int i2c_hid_open(struct hid_device *hid)
 {
 	struct i2c_client *client = hid->driver_data;
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
-	int ret;
+	int ret = 0;
 
+	mutex_lock(&i2c_hid_open_mut);
 	if (!hid->open++) {
 		ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
 		if (ret) {
 			hid->open--;
-			return -EIO;
+			goto done;
 		}
 		set_bit(I2C_HID_STARTED, &ihid->flags);
 	}
-	return 0;
+done:
+	mutex_unlock(&i2c_hid_open_mut);
+	return ret;
 }
 
 static void i2c_hid_close(struct hid_device *hid)
@@ -663,12 +669,14 @@ static void i2c_hid_close(struct hid_device *hid)
 	 * data acquistion due to a resumption we no longer
 	 * care about
 	 */
+	mutex_lock(&i2c_hid_open_mut);
 	if (!--hid->open) {
 		clear_bit(I2C_HID_STARTED, &ihid->flags);
 
 		/* Save some power */
 		i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
 	}
+	mutex_unlock(&i2c_hid_open_mut);
 }
 
 static int i2c_hid_power(struct hid_device *hid, int lvl)
-- 
1.8.0.2

