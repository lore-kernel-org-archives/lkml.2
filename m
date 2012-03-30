Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190Ab2C3VOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:14:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965165Ab2C3VOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:14:35 -0400
Message-Id: <20120330194857.057229934@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 106/149] [media] lgdt330x: fix signedness error in i2c_read_demod_bytes()
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit 34817174fca0c5512c2d5b6ea0fc37a0337ce1d8 upstream.

The error handling in lgdt3303_read_status() and lgdt330x_read_ucblocks()
doesn't work, because i2c_read_demod_bytes() returns a u8 and (err < 0)
is always false.

        err = i2c_read_demod_bytes(state, 0x58, buf, 1);
        if (err < 0)
                return err;

Change the return type of i2c_read_demod_bytes() to int.  Also change
the return value on error to -EIO to make (err < 0) work.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/frontends/lgdt330x.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -104,8 +104,8 @@ static int i2c_write_demod_bytes (struct
  * then reads the data returned for (len) bytes.
  */
 
-static u8 i2c_read_demod_bytes (struct lgdt330x_state* state,
-			       enum I2C_REG reg, u8* buf, int len)
+static int i2c_read_demod_bytes(struct lgdt330x_state *state,
+				enum I2C_REG reg, u8 *buf, int len)
 {
 	u8 wr [] = { reg };
 	struct i2c_msg msg [] = {
@@ -118,6 +118,8 @@ static u8 i2c_read_demod_bytes (struct l
 	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2) {
 		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n", __func__, state->config->demod_address, reg, ret);
+		if (ret >= 0)
+			ret = -EIO;
 	} else {
 		ret = 0;
 	}


