Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2JGPkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:40:55 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:18945
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab2JGPjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166850"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michael Buesch <m@bues.ch>
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/13] drivers/media/tuners/fc0011.c: use macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:40 +0200
Message-Id: <1349624323-15584-11-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Introduce use of I2c_MSG_READ/WRITE/OP, for readability.

A length expressed as an explicit constant is also re-expressed as the size
of the buffer in each case.

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
 drivers/media/tuners/fc0011.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
index e488254..5dbba98 100644
--- a/drivers/media/tuners/fc0011.c
+++ b/drivers/media/tuners/fc0011.c
@@ -80,8 +80,7 @@ struct fc0011_priv {
 static int fc0011_writereg(struct fc0011_priv *priv, u8 reg, u8 val)
 {
 	u8 buf[2] = { reg, val };
-	struct i2c_msg msg = { .addr = priv->addr,
-		.flags = 0, .buf = buf, .len = 2 };
+	struct i2c_msg msg = I2C_MSG_WRITE(priv->addr, buf, sizeof(buf));
 
 	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
 		dev_err(&priv->i2c->dev,
@@ -97,10 +96,8 @@ static int fc0011_readreg(struct fc0011_priv *priv, u8 reg, u8 *val)
 {
 	u8 dummy;
 	struct i2c_msg msg[2] = {
-		{ .addr = priv->addr,
-		  .flags = 0, .buf = &reg, .len = 1 },
-		{ .addr = priv->addr,
-		  .flags = I2C_M_RD, .buf = val ? : &dummy, .len = 1 },
+		I2C_MSG_WRITE(priv->addr, &reg, sizeof(reg)),
+		I2C_MSG_READ(priv->addr, val ? : &dummy, sizeof(dummy)),
 	};
 
 	if (i2c_transfer(priv->i2c, msg, 2) != 2) {

