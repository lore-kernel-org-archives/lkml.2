Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab1DOVFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:05:54 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:36445 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906Ab1DOVFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:05:53 -0400
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Apr 2011 17:05:52 EDT
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] lmedm04: Do not unlock mutex if mutex_lock_interruptible failed
Date: Sat, 16 Apr 2011 00:40:17 +0400
Message-Id: <1302900017-10437-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of places where mutex_unlock() is called even 
if mutex_lock_interruptible() failed. The patch fixes the issue.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index f2db012..40907df 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -591,9 +591,10 @@ static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	else {
 		deb_info(1, "STM Steam Off");
 		/* mutex is here only to avoid collision with I2C */
-		ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
+		if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
+			return -EAGAIN;
 
-		ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
+		ret = lme2510_usb_talk(adap->dev, clear_reg_3,
 				sizeof(clear_reg_3), rbuf, rlen);
 		st->stream_on = 0;
 		st->i2c_talk_onoff = 1;
@@ -1017,12 +1018,13 @@ static int lme2510_powerup(struct dvb_usb_device *d, int onoff)
 	static u8 rbuf[1];
 	int ret, len = 3, rlen = 1;
 
-	ret = mutex_lock_interruptible(&d->i2c_mutex);
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
 
 	if (onoff)
-		ret |= lme2510_usb_talk(d, lnb_on, len, rbuf, rlen);
+		ret = lme2510_usb_talk(d, lnb_on, len, rbuf, rlen);
 	else
-		ret |= lme2510_usb_talk(d, lnb_off, len, rbuf, rlen);
+		ret = lme2510_usb_talk(d, lnb_off, len, rbuf, rlen);
 
 	st->i2c_talk_onoff = 1;
 
-- 
1.7.1

