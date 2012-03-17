Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2CQRi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 13:38:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35631 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2CQRiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 13:38:25 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: mchehab@infradead.org
Cc: oliver@neukum.org, gregkh@linuxfoundation.org, khoroshilov@ispras.ru,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] [media] staging: use mutex_lock() in s2250_probe().
Date: Sat, 17 Mar 2012 23:06:57 +0530
Message-Id: <1332005817-10762-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Use uninterruptable sleep lock  'mutex_lock()'  in place of
mutex_lock_interruptible() because there is no userspace
for s2250_probe().

Return -ENOMEM   if kzalloc() fails to allocate and initialize.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/staging/media/go7007/s2250-board.c |   43 +++++++++++++++------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 014d384..1406a37 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -637,27 +637,32 @@ static int s2250_probe(struct i2c_client *client,
 	state->audio_input = 0;
 	write_reg(client, 0x08, 0x02); /* Line In */
 
-	if (mutex_lock_interruptible(&usb->i2c_lock) == 0) {
-		data = kzalloc(16, GFP_KERNEL);
-		if (data != NULL) {
-			int rc;
-			rc = go7007_usb_vendor_request(go, 0x41, 0, 0,
-						       data, 16, 1);
-			if (rc > 0) {
-				u8 mask;
-				data[0] = 0;
-				mask = 1<<5;
-				data[0] &= ~mask;
-				data[1] |= mask;
-				go7007_usb_vendor_request(go, 0x40, 0,
-							  (data[1]<<8)
-							  + data[1],
-							  data, 16, 0);
-			}
-			kfree(data);
-		}
+	mutex_lock(&usb->i2c_lock);
+	data = kzalloc(16, GFP_KERNEL);
+	if (data == NULL) {
+		i2c_unregister_device(audio);
+		kfree(state);
 		mutex_unlock(&usb->i2c_lock);
+		return -ENOMEM;
+	} else {
+		int rc;
+		rc = go7007_usb_vendor_request(go, 0x41, 0, 0,
+					       data, 16, 1);
+		if (rc > 0) {
+			u8 mask;
+			data[0] = 0;
+			mask = 1<<5;
+			data[0] &= ~mask;
+			data[1] |= mask;
+			go7007_usb_vendor_request(go, 0x40, 0,
+						  (data[1]<<8)
+						  + data[1],
+						  data, 16, 0);
+		}
+		kfree(data);
 	}
+	mutex_unlock(&usb->i2c_lock);
+
 
 	v4l2_info(sd, "initialized successfully\n");
 	return 0;
-- 
1.7.4.4

