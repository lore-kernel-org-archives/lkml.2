Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab2BNSfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:35:22 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42278 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2BNSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:35:20 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] lgdt330x: fix signedness error in i2c_read_demod_bytes()
Date: Tue, 14 Feb 2012 13:32:41 -0500
Message-Id: <1329244361-31416-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error handling in lgdt3303_read_status() and lgdt330x_read_ucblocks()
doesn't work, because i2c_read_demod_bytes() returns a u8 and (err < 0)
is always false.

        err = i2c_read_demod_bytes(state, 0x58, buf, 1);
        if (err < 0)
                return err;

Change the return type of i2c_read_demod_bytes() to int.  Also change
the return value on error to -EIO to make (err < 0) work.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/dvb/frontends/lgdt330x.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index c990d35..e046622 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -104,8 +104,8 @@ static int i2c_write_demod_bytes (struct lgdt330x_state* state,
  * then reads the data returned for (len) bytes.
  */
 
-static u8 i2c_read_demod_bytes (struct lgdt330x_state* state,
-			       enum I2C_REG reg, u8* buf, int len)
+static int i2c_read_demod_bytes(struct lgdt330x_state *state,
+				enum I2C_REG reg, u8 *buf, int len)
 {
 	u8 wr [] = { reg };
 	struct i2c_msg msg [] = {
@@ -118,6 +118,8 @@ static u8 i2c_read_demod_bytes (struct lgdt330x_state* state,
 	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2) {
 		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n", __func__, state->config->demod_address, reg, ret);
+		if (ret >= 0)
+			ret = -EIO;
 	} else {
 		ret = 0;
 	}
-- 
1.7.5.4

