Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2JGPkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:40:13 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:18945
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab2JGPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166844"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/13] drivers/media/tuners/tda18271-common.c: use macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:37 +0200
Message-Id: <1349624323-15584-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Introduce use of I2c_MSG_READ/WRITE/OP, for readability.

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

 drivers/media/tuners/tda18271-common.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
index 221171e..d05ed53 100644
--- a/drivers/media/tuners/tda18271-common.c
+++ b/drivers/media/tuners/tda18271-common.c
@@ -125,10 +125,8 @@ int tda18271_read_regs(struct dvb_frontend *fe)
 	unsigned char buf = 0x00;
 	int ret;
 	struct i2c_msg msg[] = {
-		{ .addr = priv->i2c_props.addr, .flags = 0,
-		  .buf = &buf, .len = 1 },
-		{ .addr = priv->i2c_props.addr, .flags = I2C_M_RD,
-		  .buf = regs, .len = 16 }
+		I2C_MSG_WRITE(priv->i2c_props.addr, &buf, sizeof(buf)),
+		I2C_MSG_READ(priv->i2c_props.addr, regs, 16)
 	};
 
 	tda18271_i2c_gate_ctrl(fe, 1);
@@ -155,10 +153,8 @@ int tda18271_read_extended(struct dvb_frontend *fe)
 	unsigned char buf = 0x00;
 	int ret, i;
 	struct i2c_msg msg[] = {
-		{ .addr = priv->i2c_props.addr, .flags = 0,
-		  .buf = &buf, .len = 1 },
-		{ .addr = priv->i2c_props.addr, .flags = I2C_M_RD,
-		  .buf = regdump, .len = TDA18271_NUM_REGS }
+		I2C_MSG_WRITE(priv->i2c_props.addr, &buf, sizeof(buf)),
+		I2C_MSG_READ(priv->i2c_props.addr, regdump, sizeof(regdump))
 	};
 
 	tda18271_i2c_gate_ctrl(fe, 1);
@@ -192,8 +188,7 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
 	struct tda18271_priv *priv = fe->tuner_priv;
 	unsigned char *regs = priv->tda18271_regs;
 	unsigned char buf[TDA18271_NUM_REGS + 1];
-	struct i2c_msg msg = { .addr = priv->i2c_props.addr, .flags = 0,
-			       .buf = buf };
+	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_props.addr, buf, 0);
 	int i, ret = 1, max;
 
 	BUG_ON((len == 0) || (idx + len > sizeof(buf)));
