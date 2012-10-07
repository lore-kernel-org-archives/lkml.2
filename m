Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2JGPkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:40:04 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:18945
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715Ab2JGPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166840"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/13] drivers/media/tuners/qt1010.c: use macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:34 +0200
Message-Id: <1349624323-15584-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Introduce use of I2c_MSG_READ/WRITE/OP, for readability.

A length expressed as an explicit constant is also re-expressed as the size
of the buffer, when this is possible.

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
 drivers/media/tuners/qt1010.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index bc419f8..37ff254 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -25,10 +25,8 @@
 static int qt1010_readreg(struct qt1010_priv *priv, u8 reg, u8 *val)
 {
 	struct i2c_msg msg[2] = {
-		{ .addr = priv->cfg->i2c_address,
-		  .flags = 0, .buf = &reg, .len = 1 },
-		{ .addr = priv->cfg->i2c_address,
-		  .flags = I2C_M_RD, .buf = val, .len = 1 },
+		I2C_MSG_WRITE(priv->cfg->i2c_address, &reg, sizeof(reg)),
+		I2C_MSG_READ(priv->cfg->i2c_address, val, 1),
 	};
 
 	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
@@ -43,8 +41,8 @@ static int qt1010_readreg(struct qt1010_priv *priv, u8 reg, u8 *val)
 static int qt1010_writereg(struct qt1010_priv *priv, u8 reg, u8 val)
 {
 	u8 buf[2] = { reg, val };
-	struct i2c_msg msg = { .addr = priv->cfg->i2c_address,
-			       .flags = 0, .buf = buf, .len = 2 };
+	struct i2c_msg msg = I2C_MSG_WRITE(priv->cfg->i2c_address, buf,
+					   sizeof(buf));
 
 	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
 		dev_warn(&priv->i2c->dev, "%s: i2c wr failed reg=%02x\n",

