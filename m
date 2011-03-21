Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1CUSex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:34:53 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43661 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab1CUSeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:34:07 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, js@linuxtv.org,
        tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 5/6] [media] m920x: get rid of on-stack dma buffers
Date: Mon, 21 Mar 2011 19:33:45 +0100
Message-Id: <1300732426-18958-6-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300732426-18958-1-git-send-email-florian@mickler.org>
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
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
 drivers/media/dvb/dvb-usb/m920x.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index da9dc91..f66eaa3 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -134,13 +134,17 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	struct m920x_state *m = d->priv;
 	int i, ret = 0;
-	u8 rc_state[2];
+	u8 *rc_state;
+
+	rc_state = kmalloc(2, GFP_KERNEL);
+	if (!rc_state)
+		return -ENOMEM;
 
 	if ((ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_STATE, rc_state, 1)) != 0)
-		goto unlock;
+		goto out;
 
 	if ((ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_KEY, rc_state + 1, 1)) != 0)
-		goto unlock;
+		goto out;
 
 	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++)
 		if (rc5_data(&d->props.rc.legacy.rc_map_table[i]) == rc_state[1]) {
@@ -149,7 +153,7 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			switch(rc_state[0]) {
 			case 0x80:
 				*state = REMOTE_NO_KEY_PRESSED;
-				goto unlock;
+				goto out;
 
 			case 0x88: /* framing error or "invalid code" */
 			case 0x99:
@@ -157,7 +161,7 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			case 0xd8:
 				*state = REMOTE_NO_KEY_PRESSED;
 				m->rep_count = 0;
-				goto unlock;
+				goto out;
 
 			case 0x93:
 			case 0x92:
@@ -165,7 +169,7 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			case 0x82:
 				m->rep_count = 0;
 				*state = REMOTE_KEY_PRESSED;
-				goto unlock;
+				goto out;
 
 			case 0x91:
 			case 0x81: /* pinnacle PCTV310e */
@@ -174,12 +178,12 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 					*state = REMOTE_KEY_REPEAT;
 				else
 					*state = REMOTE_NO_KEY_PRESSED;
-				goto unlock;
+				goto out;
 
 			default:
 				deb("Unexpected rc state %02x\n", rc_state[0]);
 				*state = REMOTE_NO_KEY_PRESSED;
-				goto unlock;
+				goto out;
 			}
 		}
 
@@ -188,8 +192,8 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 	*state = REMOTE_NO_KEY_PRESSED;
 
- unlock:
-
+ out:
+	kfree(rc_state);
 	return ret;
 }
 
@@ -339,13 +343,19 @@ static int m920x_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, in
 static int m920x_firmware_download(struct usb_device *udev, const struct firmware *fw)
 {
 	u16 value, index, size;
-	u8 read[4], *buff;
+	u8 *read, *buff;
 	int i, pass, ret = 0;
 
 	buff = kmalloc(65536, GFP_KERNEL);
 	if (buff == NULL)
 		return -ENOMEM;
 
+	read = kmalloc(4, GFP_KERNEL);
+	if (!read) {
+		kfree(buff);
+		return -ENOMEM;
+	}
+
 	if ((ret = m920x_read(udev, M9206_FILTER, 0x0, 0x8000, read, 4)) != 0)
 		goto done;
 	deb("%x %x %x %x\n", read[0], read[1], read[2], read[3]);
@@ -396,6 +406,7 @@ static int m920x_firmware_download(struct usb_device *udev, const struct firmwar
 	deb("firmware uploaded!\n");
 
  done:
+	kfree(read);
 	kfree(buff);
 
 	return ret;
-- 
1.7.4.1

