Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1CUKUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:20:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44320 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1CUKTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:35 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 5/9] [media] vp702x: get rid of on-stack dma buffers
Date: Mon, 21 Mar 2011 11:19:10 +0100
Message-Id: <1300702754-16376-6-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300702754-16376-1-git-send-email-florian@mickler.org>
References: <1300702754-16376-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_control_msg initiates (and waits for completion of) a dma transfer using
the supplied buffer. That buffer thus has to be seperately allocated on
the heap.

In lib/dma_debug.c the function check_for_stack even warns about it:
	WARNING: at lib/dma-debug.c:866 check_for_stack

Note: This change is tested to compile only, as I don't have the hardware.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp702x-fe.c |   89 +++++++++++++++++++++++----------
 drivers/media/dvb/dvb-usb/vp702x.c    |   78 ++++++++++++++++++++++------
 2 files changed, 124 insertions(+), 43 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index ccc7e44..7468a38 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -41,15 +41,26 @@ struct vp702x_fe_state {
 
 static int vp702x_fe_refresh_state(struct vp702x_fe_state *st)
 {
-	u8 buf[10];
-	if (time_after(jiffies,st->next_status_check)) {
-		vp702x_usb_in_op(st->d,READ_STATUS,0,0,buf,10);
-
+	u8 *buf;
+
+	if (time_after(jiffies, st->next_status_check)) {
+		buf = kmalloc(10, GFP_KERNEL);
+		if (!buf) {
+			deb_fe("%s: buffer alloc failed\n", __func__);
+			return -ENOMEM;
+		}
+		vp702x_usb_in_op(st->d, READ_STATUS, 0, 0, buf, 10);
 		st->lock = buf[4];
-		vp702x_usb_in_op(st->d,READ_TUNER_REG_REQ,0x11,0,&st->snr,1);
-		vp702x_usb_in_op(st->d,READ_TUNER_REG_REQ,0x15,0,&st->sig,1);
+
+		vp702x_usb_in_op(st->d, READ_TUNER_REG_REQ, 0x11, 0, buf, 1);
+		st->snr = buf[0];
+
+		vp702x_usb_in_op(st->d, READ_TUNER_REG_REQ, 0x15, 0, buf, 1);
+		st->sig = buf[0];
+
 
 		st->next_status_check = jiffies + (st->status_check_interval*HZ)/1000;
+		kfree(buf);
 	}
 	return 0;
 }
@@ -134,7 +145,11 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 	/*CalFrequency*/
 /*	u16 frequencyRef[16] = { 2, 4, 8, 16, 32, 64, 128, 256, 24, 5, 10, 20, 40, 80, 160, 320 }; */
 	u64 sr;
-	u8 cmd[8] = { 0 },ibuf[10];
+	u8 *cmd;
+
+	cmd = kzalloc(10, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
 
 	cmd[0] = (freq >> 8) & 0x7f;
 	cmd[1] =  freq       & 0xff;
@@ -170,13 +185,14 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 	st->status_check_interval = 250;
 	st->next_status_check = jiffies;
 
-	vp702x_usb_inout_op(st->d,cmd,8,ibuf,10,100);
+	vp702x_usb_inout_op(st->d, cmd, 8, cmd, 10, 100);
 
-	if (ibuf[2] == 0 && ibuf[3] == 0)
+	if (cmd[2] == 0 && cmd[3] == 0)
 		deb_fe("tuning failed.\n");
 	else
 		deb_fe("tuning succeeded.\n");
 
+	kfree(cmd);
 	return 0;
 }
 
@@ -204,28 +220,36 @@ static int vp702x_fe_get_frontend(struct dvb_frontend* fe,
 static int vp702x_fe_send_diseqc_msg (struct dvb_frontend* fe,
 				    struct dvb_diseqc_master_cmd *m)
 {
+	int ret;
+	u8 *cmd;
 	struct vp702x_fe_state *st = fe->demodulator_priv;
-	u8 cmd[8],ibuf[10];
-	memset(cmd,0,8);
+
+	cmd = kzalloc(10, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
 
 	deb_fe("%s\n",__func__);
 
-	if (m->msg_len > 4)
-		return -EINVAL;
+	if (m->msg_len > 4) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	cmd[1] = SET_DISEQC_CMD;
 	cmd[2] = m->msg_len;
 	memcpy(&cmd[3], m->msg, m->msg_len);
-	cmd[7] = vp702x_chksum(cmd,0,7);
+	cmd[7] = vp702x_chksum(cmd, 0, 7);
 
-	vp702x_usb_inout_op(st->d,cmd,8,ibuf,10,100);
+	vp702x_usb_inout_op(st->d, cmd, 8, cmd, 10, 100);
 
-	if (ibuf[2] == 0 && ibuf[3] == 0)
+	if (cmd[2] == 0 && cmd[3] == 0)
 		deb_fe("diseqc cmd failed.\n");
 	else
 		deb_fe("diseqc cmd succeeded.\n");
-
-	return 0;
+	ret = 0;
+out:
+	kfree(cmd);
+	return ret;
 }
 
 static int vp702x_fe_send_diseqc_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t burst)
@@ -237,9 +261,14 @@ static int vp702x_fe_send_diseqc_burst (struct dvb_frontend* fe, fe_sec_mini_cmd
 static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
-	u8 ibuf[10];
+	u8 *buf;
+
 	deb_fe("%s\n",__func__);
 
+	buf = kmalloc(10, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	st->tone_mode = tone;
 
 	if (tone == SEC_TONE_ON)
@@ -247,14 +276,16 @@ static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 	else
 		st->lnb_buf[2] = 0x00;
 
-	st->lnb_buf[7] = vp702x_chksum(st->lnb_buf,0,7);
+	st->lnb_buf[7] = vp702x_chksum(st->lnb_buf, 0, 7);
+	memcpy(buf, st->lnb_buf, 8);
 
-	vp702x_usb_inout_op(st->d,st->lnb_buf,8,ibuf,10,100);
-	if (ibuf[2] == 0 && ibuf[3] == 0)
+	vp702x_usb_inout_op(st->d, buf, 8, buf, 10, 100);
+	if (buf[2] == 0 && buf[3] == 0)
 		deb_fe("set_tone cmd failed.\n");
 	else
 		deb_fe("set_tone cmd succeeded.\n");
 
+	kfree(buf);
 	return 0;
 }
 
@@ -262,9 +293,13 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 		voltage)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
-	u8 ibuf[10];
+	u8 *buf;
 	deb_fe("%s\n",__func__);
 
+	buf = kmalloc(10, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	st->voltage = voltage;
 
 	if (voltage != SEC_VOLTAGE_OFF)
@@ -272,14 +307,16 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 	else
 		st->lnb_buf[4] = 0x00;
 
-	st->lnb_buf[7] = vp702x_chksum(st->lnb_buf,0,7);
+	st->lnb_buf[7] = vp702x_chksum(st->lnb_buf, 0, 7);
+	memcpy(buf, st->lnb_buf, 8);
 
-	vp702x_usb_inout_op(st->d,st->lnb_buf,8,ibuf,10,100);
-	if (ibuf[2] == 0 && ibuf[3] == 0)
+	vp702x_usb_inout_op(st->d, buf, 8, buf, 10, 100);
+	if (buf[2] == 0 && buf[3] == 0)
 		deb_fe("set_voltage cmd failed.\n");
 	else
 		deb_fe("set_voltage cmd succeeded.\n");
 
+	kfree(buf);
 	return 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 569c93f..35fe778 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -93,38 +93,61 @@ int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int il
 static int vp702x_usb_inout_cmd(struct dvb_usb_device *d, u8 cmd, u8 *o,
 				int olen, u8 *i, int ilen, int msec)
 {
-	u8 bout[olen+2];
-	u8 bin[ilen+1];
 	int ret = 0;
+	u8 *buf;
+	int buflen = max(olen + 2, ilen + 1);
 
-	bout[0] = 0x00;
-	bout[1] = cmd;
-	memcpy(&bout[2],o,olen);
+	buf = kmalloc(buflen, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
-	ret = vp702x_usb_inout_op(d, bout, olen+2, bin, ilen+1,msec);
+	buf[0] = 0x00;
+	buf[1] = cmd;
+	memcpy(&buf[2], o, olen);
+
+	ret = vp702x_usb_inout_op(d, buf, olen+2, buf, ilen+1, msec);
 
 	if (ret == 0)
-		memcpy(i,&bin[1],ilen);
+		memcpy(i, &buf[1], ilen);
 
+	kfree(buf);
 	return ret;
 }
 
 static int vp702x_set_pld_mode(struct dvb_usb_adapter *adap, u8 bypass)
 {
-	u8 buf[16] = { 0 };
-	return vp702x_usb_in_op(adap->dev, 0xe0, (bypass << 8) | 0x0e, 0, buf, 16);
+	int ret;
+	u8 *buf = kzalloc(16, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = vp702x_usb_in_op(adap->dev, 0xe0, (bypass << 8) | 0x0e,
+			0, buf, 16);
+	kfree(buf);
+	return ret;
 }
 
 static int vp702x_set_pld_state(struct dvb_usb_adapter *adap, u8 state)
 {
-	u8 buf[16] = { 0 };
-	return vp702x_usb_in_op(adap->dev, 0xe0, (state << 8) | 0x0f, 0, buf, 16);
+	int ret;
+	u8 *buf = kzalloc(16, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = vp702x_usb_in_op(adap->dev, 0xe0, (state << 8) | 0x0f,
+			0, buf, 16);
+	kfree(buf);
+	return ret;
 }
 
 static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onoff)
 {
 	struct vp702x_adapter_state *st = adap->priv;
-	u8 buf[16] = { 0 };
+	u8 *buf;
+
+	buf = kzalloc(16, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	if (onoff)
 		st->pid_filter_state |=  (1 << id);
@@ -138,6 +161,8 @@ static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onof
 	vp702x_set_pld_state(adap, st->pid_filter_state);
 	vp702x_usb_in_op(adap->dev, 0xe0, (((pid >> 8) & 0xff) << 8) | (id), 0, buf, 16);
 	vp702x_usb_in_op(adap->dev, 0xe0, (((pid     ) & 0xff) << 8) | (id+1), 0, buf, 16);
+
+	kfree(buf);
 	return 0;
 }
 
@@ -146,13 +171,17 @@ static int vp702x_init_pid_filter(struct dvb_usb_adapter *adap)
 {
 	struct vp702x_adapter_state *st = adap->priv;
 	int i;
-	u8 b[10] = { 0 };
+	u8 *b;
+
+	b = kzalloc(10, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
 
 	st->pid_filter_count = 8;
 	st->pid_filter_can_bypass = 1;
 	st->pid_filter_state = 0x00;
 
-	vp702x_set_pld_mode(adap, 1); // bypass
+	vp702x_set_pld_mode(adap, 1); /* bypass */
 
 	for (i = 0; i < st->pid_filter_count; i++)
 		vp702x_set_pid(adap, 0xffff, i, 1);
@@ -162,6 +191,7 @@ static int vp702x_init_pid_filter(struct dvb_usb_adapter *adap)
 	vp702x_usb_in_op(adap->dev, 0xb5, 1, 0, b, 10);
 
 	//vp702x_set_pld_mode(d, 0); // filter
+	kfree(b);
 	return 0;
 }
 
@@ -179,18 +209,23 @@ static struct rc_map_table rc_map_vp702x_table[] = {
 /* remote control stuff (does not work with my box) */
 static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	u8 key[10];
+	u8 *key;
 	int i;
 
 /* remove the following return to enabled remote querying */
 	return 0;
 
+	key = kmalloc(10, GFP_KERNEL);
+	if (!key)
+		return -ENOMEM;
+
 	vp702x_usb_in_op(d,READ_REMOTE_REQ,0,0,key,10);
 
 	deb_rc("remote query key: %x %d\n",key[1],key[1]);
 
 	if (key[1] == 0x44) {
 		*state = REMOTE_NO_KEY_PRESSED;
+		kfree(key);
 		return 0;
 	}
 
@@ -200,15 +235,24 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			*event = rc_map_vp702x_table[i].keycode;
 			break;
 		}
+	kfree(key);
 	return 0;
 }
 
 
 static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
 {
-	u8 i;
+	u8 i, *buf;
+
+	buf = kmalloc(6, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	for (i = 6; i < 12; i++)
-		vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1, &mac[i - 6], 1);
+		vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1, &buf[i - 6], 1);
+
+	memcpy(mac, buf, 6);
+	kfree(buf);
 	return 0;
 }
 
-- 
1.7.4.1

