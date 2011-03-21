Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1CUKUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:20:16 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44316 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab1CUKTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:37 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 7/9] [media] vp702x: use preallocated buffer
Date: Mon, 21 Mar 2011 11:19:12 +0100
Message-Id: <1300702754-16376-8-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300702754-16376-1-git-send-email-florian@mickler.org>
References: <1300702754-16376-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: This change is tested to compile only as I don't have the
hardware.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp702x.c |   59 +++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index c82cb6b..6dd50bc 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -140,38 +140,44 @@ static int vp702x_usb_inout_cmd(struct dvb_usb_device *d, u8 cmd, u8 *o,
 static int vp702x_set_pld_mode(struct dvb_usb_adapter *adap, u8 bypass)
 {
 	int ret;
-	u8 *buf = kzalloc(16, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	struct vp702x_device_state *st = adap->dev->priv;
+	u8 *buf;
+
+	mutex_lock(&st->buf_mutex);
+
+	buf = st->buf;
+	memset(buf, 0, 16);
 
 	ret = vp702x_usb_in_op(adap->dev, 0xe0, (bypass << 8) | 0x0e,
 			0, buf, 16);
-	kfree(buf);
+	mutex_unlock(&st->buf_mutex);
 	return ret;
 }
 
 static int vp702x_set_pld_state(struct dvb_usb_adapter *adap, u8 state)
 {
 	int ret;
-	u8 *buf = kzalloc(16, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	struct vp702x_device_state *st = adap->dev->priv;
+	u8 *buf;
+
+	mutex_lock(&st->buf_mutex);
 
+	buf = st->buf;
+	memset(buf, 0, 16);
 	ret = vp702x_usb_in_op(adap->dev, 0xe0, (state << 8) | 0x0f,
 			0, buf, 16);
-	kfree(buf);
+
+	mutex_unlock(&st->buf_mutex);
+
 	return ret;
 }
 
 static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onoff)
 {
 	struct vp702x_adapter_state *st = adap->priv;
+	struct vp702x_device_state *dst = adap->dev->priv;
 	u8 *buf;
 
-	buf = kzalloc(16, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	if (onoff)
 		st->pid_filter_state |=  (1 << id);
 	else {
@@ -182,10 +188,16 @@ static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onof
 	id = 0x10 + id*2;
 
 	vp702x_set_pld_state(adap, st->pid_filter_state);
+
+	mutex_lock(&dst->buf_mutex);
+
+	buf = dst->buf;
+	memset(buf, 0, 16);
 	vp702x_usb_in_op(adap->dev, 0xe0, (((pid >> 8) & 0xff) << 8) | (id), 0, buf, 16);
 	vp702x_usb_in_op(adap->dev, 0xe0, (((pid     ) & 0xff) << 8) | (id+1), 0, buf, 16);
 
-	kfree(buf);
+	mutex_unlock(&dst->buf_mutex);
+
 	return 0;
 }
 
@@ -193,13 +205,10 @@ static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onof
 static int vp702x_init_pid_filter(struct dvb_usb_adapter *adap)
 {
 	struct vp702x_adapter_state *st = adap->priv;
+	struct vp702x_device_state *dst = adap->dev->priv;
 	int i;
 	u8 *b;
 
-	b = kzalloc(10, GFP_KERNEL);
-	if (!b)
-		return -ENOMEM;
-
 	st->pid_filter_count = 8;
 	st->pid_filter_can_bypass = 1;
 	st->pid_filter_state = 0x00;
@@ -209,12 +218,15 @@ static int vp702x_init_pid_filter(struct dvb_usb_adapter *adap)
 	for (i = 0; i < st->pid_filter_count; i++)
 		vp702x_set_pid(adap, 0xffff, i, 1);
 
+	mutex_lock(&dst->buf_mutex);
+	b = dst->buf;
+	memset(b, 0, 10);
 	vp702x_usb_in_op(adap->dev, 0xb5, 3, 0, b, 10);
 	vp702x_usb_in_op(adap->dev, 0xb5, 0, 0, b, 10);
 	vp702x_usb_in_op(adap->dev, 0xb5, 1, 0, b, 10);
+	mutex_unlock(&dst->buf_mutex);
+	/*vp702x_set_pld_mode(d, 0); // filter */
 
-	//vp702x_set_pld_mode(d, 0); // filter
-	kfree(b);
 	return 0;
 }
 
@@ -266,16 +278,15 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
 {
 	u8 i, *buf;
+	struct vp702x_device_state *st = d->priv;
 
-	buf = kmalloc(6, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
+	mutex_lock(&st->buf_mutex);
+	buf = st->buf;
 	for (i = 6; i < 12; i++)
 		vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1, &buf[i - 6], 1);
 
 	memcpy(mac, buf, 6);
-	kfree(buf);
+	mutex_unlock(&st->buf_mutex);
 	return 0;
 }
 
-- 
1.7.4.1

