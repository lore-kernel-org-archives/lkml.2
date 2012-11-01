Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366Ab2KAVAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:00:18 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:52079 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757236Ab2KAVAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:00:16 -0400
Message-ID: <1351803609.1597.16.camel@x61.thuisdomein>
Subject: [PATCH] [media] tda18212: tda18218: use 'val' if initialized
From: Paul Bolle <pebolle@tiscali.nl>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 01 Nov 2012 22:00:09 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Nov 2012 21:00:09.0697 (UTC) FILETIME=[E0DD6D10:01CDB873]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits e666a44fa313cb9329c0381ad02fc6ee1e21cb31 ("[media] tda18212:
silence compiler warning") and e0e52d4e9f5bce7ea887027c127473eb654a5a04
("[media] tda18218: silence compiler warning") silenced warnings
equivalent to these:
    drivers/media/tuners/tda18212.c: In function ‘tda18212_attach’:
    drivers/media/tuners/tda18212.c:299:2: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/media/tuners/tda18218.c: In function ‘tda18218_attach’:
    drivers/media/tuners/tda18218.c:305:2: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]

But in both cases 'val' will still be used uninitialized if the calls
of tda18212_rd_reg() or tda18218_rd_reg() fail. Fix this by only
printing the "chip id" if the calls of those functions were successful.
This allows to drop the uninitialized_var() stopgap measure.

Also stop printing the return values of tda18212_rd_reg() or
tda18218_rd_reg(), as these are not interesting.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

 drivers/media/tuners/tda18212.c | 6 +++---
 drivers/media/tuners/tda18218.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 5d9f028..e4a84ee 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -277,7 +277,7 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 {
 	struct tda18212_priv *priv = NULL;
 	int ret;
-	u8 uninitialized_var(val);
+	u8 val;
 
 	priv = kzalloc(sizeof(struct tda18212_priv), GFP_KERNEL);
 	if (priv == NULL)
@@ -296,8 +296,8 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 
-	dev_dbg(&priv->i2c->dev, "%s: ret=%d chip id=%02x\n", __func__, ret,
-			val);
+	if (!ret)
+		dev_dbg(&priv->i2c->dev, "%s: chip id=%02x\n", __func__, val);
 	if (ret || val != 0xc7) {
 		kfree(priv);
 		return NULL;
diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 1819853..2d31aeb 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -277,7 +277,7 @@ struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, struct tda18218_config *cfg)
 {
 	struct tda18218_priv *priv = NULL;
-	u8 uninitialized_var(val);
+	u8 val;
 	int ret;
 	/* chip default registers values */
 	static u8 def_regs[] = {
@@ -302,8 +302,8 @@ struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
 
 	/* check if the tuner is there */
 	ret = tda18218_rd_reg(priv, R00_ID, &val);
-	dev_dbg(&priv->i2c->dev, "%s: ret=%d chip id=%02x\n", __func__, ret,
-			val);
+	if (!ret)
+		dev_dbg(&priv->i2c->dev, "%s: chip id=%02x\n", __func__, val);
 	if (ret || val != def_regs[R00_ID]) {
 		kfree(priv);
 		return NULL;
-- 
1.7.11.7

