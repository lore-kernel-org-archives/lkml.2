Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab1CUKTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:19:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44324 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab1CUKTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:38 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 9/9] [media] vp702x: use preallocated buffer in the frontend
Date: Mon, 21 Mar 2011 11:19:14 +0100
Message-Id: <1300702754-16376-10-git-send-email-florian@mickler.org>
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
 drivers/media/dvb/dvb-usb/vp702x-fe.c |   69 +++++++++++++++++----------------
 1 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index 7468a38..2bb8d4c 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -41,14 +41,13 @@ struct vp702x_fe_state {
 
 static int vp702x_fe_refresh_state(struct vp702x_fe_state *st)
 {
+	struct vp702x_device_state *dst = st->d->priv;
 	u8 *buf;
 
 	if (time_after(jiffies, st->next_status_check)) {
-		buf = kmalloc(10, GFP_KERNEL);
-		if (!buf) {
-			deb_fe("%s: buffer alloc failed\n", __func__);
-			return -ENOMEM;
-		}
+		mutex_lock(&dst->buf_mutex);
+		buf = dst->buf;
+
 		vp702x_usb_in_op(st->d, READ_STATUS, 0, 0, buf, 10);
 		st->lock = buf[4];
 
@@ -58,9 +57,8 @@ static int vp702x_fe_refresh_state(struct vp702x_fe_state *st)
 		vp702x_usb_in_op(st->d, READ_TUNER_REG_REQ, 0x15, 0, buf, 1);
 		st->sig = buf[0];
 
-
+		mutex_unlock(&dst->buf_mutex);
 		st->next_status_check = jiffies + (st->status_check_interval*HZ)/1000;
-		kfree(buf);
 	}
 	return 0;
 }
@@ -141,15 +139,17 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 				  struct dvb_frontend_parameters *fep)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
+	struct vp702x_device_state *dst = st->d->priv;
 	u32 freq = fep->frequency/1000;
 	/*CalFrequency*/
 /*	u16 frequencyRef[16] = { 2, 4, 8, 16, 32, 64, 128, 256, 24, 5, 10, 20, 40, 80, 160, 320 }; */
 	u64 sr;
 	u8 *cmd;
 
-	cmd = kzalloc(10, GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
+	mutex_lock(&dst->buf_mutex);
+
+	cmd = dst->buf;
+	memset(cmd, 0, 10);
 
 	cmd[0] = (freq >> 8) & 0x7f;
 	cmd[1] =  freq       & 0xff;
@@ -192,7 +192,8 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 	else
 		deb_fe("tuning succeeded.\n");
 
-	kfree(cmd);
+	mutex_unlock(&dst->buf_mutex);
+
 	return 0;
 }
 
@@ -220,21 +221,18 @@ static int vp702x_fe_get_frontend(struct dvb_frontend* fe,
 static int vp702x_fe_send_diseqc_msg (struct dvb_frontend* fe,
 				    struct dvb_diseqc_master_cmd *m)
 {
-	int ret;
 	u8 *cmd;
 	struct vp702x_fe_state *st = fe->demodulator_priv;
-
-	cmd = kzalloc(10, GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
+	struct vp702x_device_state *dst = st->d->priv;
 
 	deb_fe("%s\n",__func__);
 
-	if (m->msg_len > 4) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (m->msg_len > 4)
+		return -EINVAL;
+
+	mutex_lock(&dst->buf_mutex);
 
+	cmd = dst->buf;
 	cmd[1] = SET_DISEQC_CMD;
 	cmd[2] = m->msg_len;
 	memcpy(&cmd[3], m->msg, m->msg_len);
@@ -246,10 +244,10 @@ static int vp702x_fe_send_diseqc_msg (struct dvb_frontend* fe,
 		deb_fe("diseqc cmd failed.\n");
 	else
 		deb_fe("diseqc cmd succeeded.\n");
-	ret = 0;
-out:
-	kfree(cmd);
-	return ret;
+
+	mutex_unlock(&dst->buf_mutex);
+
+	return 0;
 }
 
 static int vp702x_fe_send_diseqc_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t burst)
@@ -261,14 +259,11 @@ static int vp702x_fe_send_diseqc_burst (struct dvb_frontend* fe, fe_sec_mini_cmd
 static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
+	struct vp702x_device_state *dst = st->d->priv;
 	u8 *buf;
 
 	deb_fe("%s\n",__func__);
 
-	buf = kmalloc(10, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	st->tone_mode = tone;
 
 	if (tone == SEC_TONE_ON)
@@ -277,6 +272,10 @@ static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 		st->lnb_buf[2] = 0x00;
 
 	st->lnb_buf[7] = vp702x_chksum(st->lnb_buf, 0, 7);
+
+	mutex_lock(&dst->buf_mutex);
+
+	buf = dst->buf;
 	memcpy(buf, st->lnb_buf, 8);
 
 	vp702x_usb_inout_op(st->d, buf, 8, buf, 10, 100);
@@ -285,7 +284,8 @@ static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 	else
 		deb_fe("set_tone cmd succeeded.\n");
 
-	kfree(buf);
+	mutex_unlock(&dst->buf_mutex);
+
 	return 0;
 }
 
@@ -293,13 +293,10 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 		voltage)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
+	struct vp702x_device_state *dst = st->d->priv;
 	u8 *buf;
 	deb_fe("%s\n",__func__);
 
-	buf = kmalloc(10, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	st->voltage = voltage;
 
 	if (voltage != SEC_VOLTAGE_OFF)
@@ -308,6 +305,10 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 		st->lnb_buf[4] = 0x00;
 
 	st->lnb_buf[7] = vp702x_chksum(st->lnb_buf, 0, 7);
+
+	mutex_lock(&dst->buf_mutex);
+
+	buf = dst->buf;
 	memcpy(buf, st->lnb_buf, 8);
 
 	vp702x_usb_inout_op(st->d, buf, 8, buf, 10, 100);
@@ -316,7 +317,7 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 	else
 		deb_fe("set_voltage cmd succeeded.\n");
 
-	kfree(buf);
+	mutex_unlock(&dst->buf_mutex);
 	return 0;
 }
 
-- 
1.7.4.1

