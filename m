Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2JGPnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:43:00 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:3043 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab2JGPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166838"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:32 +0200
Message-Id: <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Introduce use of I2c_MSG_READ/WRITE/OP, for readability.

In the second i2c_msg structure, a length expressed as an explicit constant
is also re-expressed as the size of the buffer, reg.

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
 drivers/media/tuners/e4000.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 1b33ed3..8f182fc 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -26,12 +26,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 	int ret;
 	u8 buf[1 + len];
 	struct i2c_msg msg[1] = {
-		{
-			.addr = priv->cfg->i2c_addr,
-			.flags = 0,
-			.len = sizeof(buf),
-			.buf = buf,
-		}
+		I2C_MSG_WRITE(priv->cfg->i2c_addr, buf, sizeof(buf))
 	};
 
 	buf[0] = reg;
@@ -54,17 +49,8 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 	int ret;
 	u8 buf[len];
 	struct i2c_msg msg[2] = {
-		{
-			.addr = priv->cfg->i2c_addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = priv->cfg->i2c_addr,
-			.flags = I2C_M_RD,
-			.len = sizeof(buf),
-			.buf = buf,
-		}
+		I2C_MSG_WRITE(priv->cfg->i2c_addr, &reg, sizeof(reg)),
+		I2C_MSG_READ(priv->cfg->i2c_addr, buf, sizeof(buf))
 	};
 
 	ret = i2c_transfer(priv->i2c, msg, 2);

