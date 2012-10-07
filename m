Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2JGPke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:40:34 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:3043 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab2JGPjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166853"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] drivers/media/tuners/tda8290.c: use macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:41 +0200
Message-Id: <1349624323-15584-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Introduce use of I2c_MSG_READ/WRITE/OP, for readability.

A length expressed as an explicit constant is also re-expressed as the size
of the bufferin each case.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,b,c;
identifier x;
@@

struct i2c_msg x =
- {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
+ I2C_MSG_READ(a,b,c)
 ;

@@
expression a,b,c;
identifier x;
@@

struct i2c_msg x =
- {.addr = a, .buf = b, .len = c, .flags = 0}
+ I2C_MSG_WRITE(a,b,c)
 ;

@@
expression a,b,c,d;
identifier x;
@@

struct i2c_msg x = 
- {.addr = a, .buf = b, .len = c, .flags = d}
+ I2C_MSG_OP(a,b,c,d)
 ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/tuners/tda8290.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 8c48521..83ecee2 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -463,7 +463,8 @@ static void tda8290_standby(struct dvb_frontend *fe)
 	unsigned char cb1[] = { 0x30, 0xD0 };
 	unsigned char tda8290_standby[] = { 0x00, 0x02 };
 	unsigned char tda8290_agc_tri[] = { 0x02, 0x20 };
-	struct i2c_msg msg = {.addr = priv->tda827x_addr, .flags=0, .buf=cb1, .len = 2};
+	struct i2c_msg msg = I2C_MSG_WRITE(priv->tda827x_addr, cb1,
+					   sizeof(cb1));
 
 	tda8290_i2c_bridge(fe, 1);
 	if (priv->ver & TDA8275A)
@@ -532,8 +533,8 @@ static void tda8290_init_tuner(struct dvb_frontend *fe)
 					  0x3F, 0x2A, 0x04, 0xFF, 0x00, 0x00, 0x40 };
 	unsigned char tda8275a_init[] = { 0x00, 0x00, 0x00, 0x00, 0xdC, 0x05, 0x8b,
 					  0x0c, 0x04, 0x20, 0xFF, 0x00, 0x00, 0x4b };
-	struct i2c_msg msg = {.addr = priv->tda827x_addr, .flags=0,
-			      .buf=tda8275_init, .len = 14};
+	struct i2c_msg msg = I2C_MSG_WRITE(priv->tda827x_addr, tda8275_init,
+					   sizeof(tda8275_init));
 	if (priv->ver & TDA8275A)
 		msg.buf = tda8275a_init;
 
@@ -569,7 +570,7 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 	int i, ret, tuners_found;
 	u32 tuner_addrs;
 	u8 data;
-	struct i2c_msg msg = { .flags = I2C_M_RD, .buf = &data, .len = 1 };
+	struct i2c_msg msg = I2C_MSG_READ(0, &data, sizeof(data));
 
 	if (!analog_ops->i2c_gate_ctrl) {
 		printk(KERN_ERR "tda8290: no gate control were provided!\n");
@@ -658,8 +659,8 @@ static int tda8290_probe(struct tuner_i2c_props *i2c_props)
 #define TDA8290_ID 0x89
 	u8 reg = 0x1f, id;
 	struct i2c_msg msg_read[] = {
-		{ .addr = i2c_props->addr, .flags = 0, .len = 1, .buf = &reg },
-		{ .addr = i2c_props->addr, .flags = I2C_M_RD, .len = 1, .buf = &id },
+		I2C_MSG_WRITE(i2c_props->addr, &reg, sizeof(reg)),
+		I2C_MSG_READ(i2c_props->addr, &id, sizeof(id)),
 	};
 
 	/* detect tda8290 */
@@ -685,8 +686,8 @@ static int tda8295_probe(struct tuner_i2c_props *i2c_props)
 #define TDA8295C2_ID 0x8b
 	u8 reg = 0x2f, id;
 	struct i2c_msg msg_read[] = {
-		{ .addr = i2c_props->addr, .flags = 0, .len = 1, .buf = &reg },
-		{ .addr = i2c_props->addr, .flags = I2C_M_RD, .len = 1, .buf = &id },
+		I2C_MSG_WRITE(i2c_props->addr, &reg, sizeof(reg)),
+		I2C_MSG_READ(i2c_props->addr, &id, sizeof(id)),
 	};
 
 	/* detect tda8295 */

