Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1GaHaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:30:16 -0400
Received: from mail.perches.com ([173.55.12.10]:4398 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1GaHaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 03:30:12 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] tda18212: Use standard logging, remove tda18212_priv.h
Date: Sun, 31 Jul 2011 00:30:10 -0700
Message-Id: <9120902ede1339aac93a0b9b39d68ad31d8ccce3.1312097354.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more current logging styles with pr_fmt.
Remove now unnecessary private include.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/common/tuners/tda18212.c      |   31 ++++++++++++++-----
 drivers/media/common/tuners/tda18212_priv.h |   44 ---------------------------
 2 files changed, 23 insertions(+), 52 deletions(-)
 delete mode 100644 drivers/media/common/tuners/tda18212_priv.h

diff --git a/drivers/media/common/tuners/tda18212.c b/drivers/media/common/tuners/tda18212.c
index 1f1db20..e29cc2b 100644
--- a/drivers/media/common/tuners/tda18212.c
+++ b/drivers/media/common/tuners/tda18212.c
@@ -18,7 +18,20 @@
  *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
-#include "tda18212_priv.h"
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "tda18212.h"
+
+struct tda18212_priv {
+	struct tda18212_config *cfg;
+	struct i2c_adapter *i2c;
+};
+
+#define dbg(fmt, arg...)					\
+do {								\
+	if (debug)						\
+		pr_info("%s: " fmt, __func__, ##arg);		\
+} while (0)
 
 static int debug;
 module_param(debug, int, 0644);
@@ -46,7 +59,8 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		warn("i2c wr failed ret:%d reg:%02x len:%d", ret, reg, len);
+		pr_warn("i2c wr failed ret:%d reg:%02x len:%d\n",
+			ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -77,7 +91,8 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		warn("i2c rd failed ret:%d reg:%02x len:%d", ret, reg, len);
+		pr_warn("i2c rd failed ret:%d reg:%02x len:%d\n",
+			ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -129,8 +144,8 @@ static int tda18212_set_params(struct dvb_frontend *fe,
 		{ 0x92, 0x53, 0x03 }, /* DVB-C */
 	};
 
-	dbg("%s: delsys=%d RF=%d BW=%d", __func__,
-		c->delivery_system, c->frequency, c->bandwidth_hz);
+	dbg("delsys=%d RF=%d BW=%d\n",
+	    c->delivery_system, c->frequency, c->bandwidth_hz);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
@@ -196,7 +211,7 @@ exit:
 	return ret;
 
 error:
-	dbg("%s: failed:%d", __func__, ret);
+	dbg("failed:%d\n", ret);
 	goto exit;
 }
 
@@ -245,13 +260,13 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 
-	dbg("%s: ret:%d chip ID:%02x", __func__, ret, val);
+	dbg("ret:%d chip ID:%02x\n", ret, val);
 	if (ret || val != 0xc7) {
 		kfree(priv);
 		return NULL;
 	}
 
-	info("NXP TDA18212HN successfully identified.");
+	pr_info("NXP TDA18212HN successfully identified\n");
 
 	memcpy(&fe->ops.tuner_ops, &tda18212_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
diff --git a/drivers/media/common/tuners/tda18212_priv.h b/drivers/media/common/tuners/tda18212_priv.h
deleted file mode 100644
index 9adff93..0000000
--- a/drivers/media/common/tuners/tda18212_priv.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * NXP TDA18212HN silicon tuner driver
- *
- * Copyright (C) 2011 Antti Palosaari <crope@iki.fi>
- *
- *    This program is free software; you can redistribute it and/or modify
- *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
- *
- *    This program is distributed in the hope that it will be useful,
- *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- */
-
-#ifndef TDA18212_PRIV_H
-#define TDA18212_PRIV_H
-
-#include "tda18212.h"
-
-#define LOG_PREFIX "tda18212"
-
-#undef dbg
-#define dbg(f, arg...) \
-	if (debug) \
-		printk(KERN_INFO   LOG_PREFIX": " f "\n" , ## arg)
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
-
-struct tda18212_priv {
-	struct tda18212_config *cfg;
-	struct i2c_adapter *i2c;
-};
-
-#endif
-- 
1.7.6.131.g99019

