Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1CUKUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:20:32 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44320 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1CUKTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:37 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 8/9] [media] vp702x: use preallocated buffer in vp702x_usb_inout_cmd
Date: Mon, 21 Mar 2011 11:19:13 +0100
Message-Id: <1300702754-16376-9-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300702754-16376-1-git-send-email-florian@mickler.org>
References: <1300702754-16376-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we need a bigger buffer, we reallocte a new buffer and free the old
one.

Note: This change is tested to compile only as I don't have the
hardware.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp702x.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 6dd50bc..54355f8 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -116,13 +116,28 @@ int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int il
 static int vp702x_usb_inout_cmd(struct dvb_usb_device *d, u8 cmd, u8 *o,
 				int olen, u8 *i, int ilen, int msec)
 {
+	struct vp702x_device_state *st = d->priv;
 	int ret = 0;
 	u8 *buf;
 	int buflen = max(olen + 2, ilen + 1);
 
-	buf = kmalloc(buflen, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	ret = mutex_lock_interruptible(&st->buf_mutex);
+	if (ret < 0)
+		return ret;
+
+	if (buflen > st->buf_len) {
+		buf = kmalloc(buflen, GFP_KERNEL);
+		if (!buf) {
+			mutex_unlock(&st->buf_mutex);
+			return -ENOMEM;
+		}
+		info("successfully reallocated a bigger buffer");
+		kfree(st->buf);
+		st->buf = buf;
+		st->buf_len = buflen;
+	} else {
+		buf = st->buf;
+	}
 
 	buf[0] = 0x00;
 	buf[1] = cmd;
@@ -132,8 +147,8 @@ static int vp702x_usb_inout_cmd(struct dvb_usb_device *d, u8 cmd, u8 *o,
 
 	if (ret == 0)
 		memcpy(i, &buf[1], ilen);
+	mutex_unlock(&st->buf_mutex);
 
-	kfree(buf);
 	return ret;
 }
 
-- 
1.7.4.1

