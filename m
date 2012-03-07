Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab2CGTWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:22:19 -0500
Received: from smtp.ispras.ru ([83.149.198.202]:33961 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885Ab2CGTWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:22:17 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Olivier Grenie <olivier.grenie@dibcom.fr>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] [media] dib0700: unlock mutexes on error paths
Date: Wed,  7 Mar 2012 23:21:58 +0400
Message-Id: <1331148118-22593-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dib0700_i2c_xfer [_new and _legacy] leave i2c_mutex locked on error paths.
The patch adds appropriate unlocks.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 070e82a..8ec22c4 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -228,7 +228,7 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 			/* Write request */
 			if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 				err("could not acquire lock");
-				return 0;
+				break;
 			}
 			st->buf[0] = REQUEST_NEW_I2C_WRITE;
 			st->buf[1] = msg[i].addr << 1;
@@ -270,11 +270,14 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 	struct dib0700_state *st = d->priv;
 	int i,len;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0) {
+		err("could not acquire lock");
 		return -EAGAIN;
+	}
 	if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
+		mutex_unlock(&d->i2c_mutex);
 		err("could not acquire lock");
-		return 0;
+		return -EAGAIN;
 	}
 
 	for (i = 0; i < num; i++) {
-- 
1.7.4.1

