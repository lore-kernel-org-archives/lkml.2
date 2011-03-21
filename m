Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1CUKTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:19:41 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44324 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1CUKTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:35 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 6/9] [media] vp702x: fix locking of usb operations
Date: Mon, 21 Mar 2011 11:19:11 +0100
Message-Id: <1300702754-16376-7-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300702754-16376-1-git-send-email-florian@mickler.org>
References: <1300702754-16376-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise it is not obvious that vp702x_usb_in_op or vp702x_usb_out_op
will not interfere with any vp702x_usb_inout_op.

Note: This change is tested to compile only, as I don't have the
hardware.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp702x.c |   37 +++++++++++++++++++++++++++++------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 35fe778..c82cb6b 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -30,8 +30,8 @@ struct vp702x_adapter_state {
 	u8  pid_filter_state;
 };
 
-/* check for mutex FIXME */
-int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
+static int vp702x_usb_in_op_unlocked(struct dvb_usb_device *d, u8 req,
+				     u16 value, u16 index, u8 *b, int blen)
 {
 	int ret;
 
@@ -55,8 +55,20 @@ int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
 	return ret;
 }
 
-static int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
-			     u16 index, u8 *b, int blen)
+int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value,
+			    u16 index, u8 *b, int blen)
+{
+	int ret;
+
+	mutex_lock(&d->usb_mutex);
+	ret = vp702x_usb_in_op_unlocked(d, req, value, index, b, blen);
+	mutex_unlock(&d->usb_mutex);
+
+	return ret;
+}
+
+int vp702x_usb_out_op_unlocked(struct dvb_usb_device *d, u8 req, u16 value,
+				      u16 index, u8 *b, int blen)
 {
 	int ret;
 	deb_xfer("out: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
@@ -74,6 +86,18 @@ static int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 		return 0;
 }
 
+int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
+			     u16 index, u8 *b, int blen)
+{
+	int ret;
+
+	mutex_lock(&d->usb_mutex);
+	ret = vp702x_usb_out_op_unlocked(d, req, value, index, b, blen);
+	mutex_unlock(&d->usb_mutex);
+
+	return ret;
+}
+
 int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int ilen, int msec)
 {
 	int ret;
@@ -81,12 +105,11 @@ int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int il
 	if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
 		return ret;
 
-	ret = vp702x_usb_out_op(d,REQUEST_OUT,0,0,o,olen);
+	ret = vp702x_usb_out_op_unlocked(d, REQUEST_OUT, 0, 0, o, olen);
 	msleep(msec);
-	ret = vp702x_usb_in_op(d,REQUEST_IN,0,0,i,ilen);
+	ret = vp702x_usb_in_op_unlocked(d, REQUEST_IN, 0, 0, i, ilen);
 
 	mutex_unlock(&d->usb_mutex);
-
 	return ret;
 }
 
-- 
1.7.4.1

