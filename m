Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2JGPmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:42:50 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:42652
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571Ab2JGPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166839"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/13] drivers/media/tuners/mxl5007t.c: use macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:33 +0200
Message-Id: <1349624323-15584-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Introduce use of I2c_MSG_READ/WRITE/OP, for readability.

In each case, a length expressed as an explicit constant is also
re-expressed as the size of the buffer, when this is possible.

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
 drivers/media/tuners/mxl5007t.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
index 69e453e..c0c28be 100644
--- a/drivers/media/tuners/mxl5007t.c
+++ b/drivers/media/tuners/mxl5007t.c
@@ -464,8 +464,8 @@ reg_pair_t *mxl5007t_calc_rf_tune_regs(struct mxl5007t_state *state,
 static int mxl5007t_write_reg(struct mxl5007t_state *state, u8 reg, u8 val)
 {
 	u8 buf[] = { reg, val };
-	struct i2c_msg msg = { .addr = state->i2c_props.addr, .flags = 0,
-			       .buf = buf, .len = 2 };
+	struct i2c_msg msg = I2C_MSG_WRITE(state->i2c_props.addr, buf,
+					   sizeof(buf));
 	int ret;
 
 	ret = i2c_transfer(state->i2c_props.adap, &msg, 1);
@@ -494,10 +494,8 @@ static int mxl5007t_read_reg(struct mxl5007t_state *state, u8 reg, u8 *val)
 {
 	u8 buf[2] = { 0xfb, reg };
 	struct i2c_msg msg[] = {
-		{ .addr = state->i2c_props.addr, .flags = 0,
-		  .buf = buf, .len = 2 },
-		{ .addr = state->i2c_props.addr, .flags = I2C_M_RD,
-		  .buf = val, .len = 1 },
+		I2C_MSG_WRITE(state->i2c_props.addr, buf, sizeof(buf)),
+		I2C_MSG_READ(state->i2c_props.addr, val, 1),
 	};
 	int ret;
 
@@ -512,10 +510,8 @@ static int mxl5007t_read_reg(struct mxl5007t_state *state, u8 reg, u8 *val)
 static int mxl5007t_soft_reset(struct mxl5007t_state *state)
 {
 	u8 d = 0xff;
-	struct i2c_msg msg = {
-		.addr = state->i2c_props.addr, .flags = 0,
-		.buf = &d, .len = 1
-	};
+	struct i2c_msg msg = I2C_MSG_WRITE(state->i2c_props.addr, &d,
+					   sizeof(d));
 	int ret = i2c_transfer(state->i2c_props.adap, &msg, 1);
 
 	if (ret != 1) {

