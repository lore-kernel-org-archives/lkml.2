Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2BMP1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:27:34 -0500
Received: from smtp.ispras.ru ([83.149.198.202]:53251 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905Ab2BMP1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:27:33 -0500
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Feb 2012 10:27:32 EST
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: go7007: fix mismatch in mutex lock-unlock in [read|write]_reg_fp
Date: Mon, 13 Feb 2012 16:01:32 +0100
Message-Id: <1329145292-5855-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If go7007_usb_vendor_request() fails in write_reg_fp()
or in read_reg_fp(), the usb->i2c_lock mutex left locked.

The patch moves mutex_unlock(&usb->i2c_lock) before check
for go7007_usb_vendor_request() returned value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/media/go7007/s2250-board.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index e7736a9..014d384 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -192,6 +192,7 @@ static int write_reg_fp(struct i2c_client *client, u16 addr, u16 val)
 {
 	struct go7007 *go = i2c_get_adapdata(client->adapter);
 	struct go7007_usb *usb;
+	int rc;
 	u8 *buf;
 	struct s2250 *dec = i2c_get_clientdata(client);
 
@@ -216,12 +217,13 @@ static int write_reg_fp(struct i2c_client *client, u16 addr, u16 val)
 		kfree(buf);
 		return -EINTR;
 	}
-	if (go7007_usb_vendor_request(go, 0x57, addr, val, buf, 16, 1) < 0) {
+	rc = go7007_usb_vendor_request(go, 0x57, addr, val, buf, 16, 1);
+	mutex_unlock(&usb->i2c_lock);
+	if (rc < 0) {
 		kfree(buf);
-		return -EFAULT;
+		return rc;
 	}
 
-	mutex_unlock(&usb->i2c_lock);
 	if (buf[0] == 0) {
 		unsigned int subaddr, val_read;
 
@@ -254,6 +256,7 @@ static int read_reg_fp(struct i2c_client *client, u16 addr, u16 *val)
 {
 	struct go7007 *go = i2c_get_adapdata(client->adapter);
 	struct go7007_usb *usb;
+	int rc;
 	u8 *buf;
 
 	if (go == NULL)
@@ -276,11 +279,12 @@ static int read_reg_fp(struct i2c_client *client, u16 addr, u16 *val)
 		kfree(buf);
 		return -EINTR;
 	}
-	if (go7007_usb_vendor_request(go, 0x58, addr, 0, buf, 16, 1) < 0) {
+	rc = go7007_usb_vendor_request(go, 0x58, addr, 0, buf, 16, 1);
+	mutex_unlock(&usb->i2c_lock);
+	if (rc < 0) {
 		kfree(buf);
-		return -EFAULT;
+		return rc;
 	}
-	mutex_unlock(&usb->i2c_lock);
 
 	*val = (buf[0] << 8) | buf[1];
 	kfree(buf);
-- 
1.7.4.1

