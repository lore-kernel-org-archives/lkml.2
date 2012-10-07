Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2JGPka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:40:30 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:42652
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428Ab2JGPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166854"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] drivers/media/tuners/tda18218.c: use macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:42 +0200
Message-Id: <1349624323-15584-13-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/tuners/tda18218.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 1819853..c0c2fef 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -26,11 +26,7 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 	int ret = 0, len2, remaining;
 	u8 buf[1 + len];
 	struct i2c_msg msg[1] = {
-		{
-			.addr = priv->cfg->i2c_address,
-			.flags = 0,
-			.buf = buf,
-		}
+		I2C_MSG_WRITE(priv->cfg->i2c_address, buf, 0)
 	};
 
 	for (remaining = len; remaining > 0;
@@ -65,17 +61,8 @@ static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 	int ret;
 	u8 buf[reg+len]; /* we must start read always from reg 0x00 */
 	struct i2c_msg msg[2] = {
-		{
-			.addr = priv->cfg->i2c_address,
-			.flags = 0,
-			.len = 1,
-			.buf = "\x00",
-		}, {
-			.addr = priv->cfg->i2c_address,
-			.flags = I2C_M_RD,
-			.len = sizeof(buf),
-			.buf = buf,
-		}
+		I2C_MSG_WRITE(priv->cfg->i2c_address, "\x00", 1),
+		I2C_MSG_READ(priv->cfg->i2c_address, buf, sizeof(buf))
 	};
 
 	ret = i2c_transfer(priv->i2c, msg, 2);

