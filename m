Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1AVBJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:09:26 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54981 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1AVBJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=JIUXx88cm4ls4x/7reu/UtJIJDE3HXJMSko0rKgEHAdMIRwbXp1cgQEpFP+I1kBvnD
         oS4R5EchpeFsLGwSFsWrEq9YxzhQ6qMz4nvHFtmxCMfN1RmCU2cJZverHB1buk7EIbSw
         jXj+TJlVfxnQ3U1tvFUMhb+YpAvW9y5An9qrI=
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
From: Andrea Merello <andrea.merello@gmail.com>
Date: Sat, 22 Jan 2011 02:09:04 +0100
Message-ID: <AANLkTikmw=Hoa_R94dKwy432Wm3XfMwuDvkqoT9xmJRY@mail.gmail.com>
Subject: DVB TDA18218 tuner driver BUG in I2C write
To: Antti Palosaari <crope@iki.fi>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm looking at tda18218.c file from 2.6.37 kernel.
I think the tda18218_wr_regs function has a bug:

I think it works as long as priv->cfg->i2c_wr_max is > than len parameter,
but let's assume that priv->cfg->i2c_wr_max is set to 2.

If tda18218_wr_regs is called with len = 1 it is easy to see it does
not perform the write. In this case:

msg_len_max is priv->cfg->i2c_wr_max -1, thus it is 1
remainder is len % msg_len_max, thus it is 0

the 'for loop' condition (i <= quotient && remainder) is thus false
and no write is performed at all.

I changed the function so it writes correctly now for me. Maybe you
prefer to fix the original algo rather than heavily changing it as I
did. Anyway I attach the patch I produced to make it working here.

Please note that I tested this only with priv->cfg->i2c_wr_max set to
2 and with the AF9035 driver that is not even in the kernel (any plan
to include ?) and I couldn't try this with any other in-kernel driver
due to lack of HW. So the patch need to be eventually checked and
tested more.

Thank you
Andrea

--- drivers/media/common/tuners/tda18218_orig.c 2011-01-22
22:44:59.323333347 +0100
+++ drivers/media/common/tuners/tda18218.c      2011-01-22
22:46:36.846666668 +0100
@@ -28,8 +28,9 @@ MODULE_PARM_DESC(debug, "Turn on/off deb
 /* write multiple registers */
 static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8
*val, u8 len)
 {
-       int ret;
-       u8 buf[1+len], quotient, remainder, i, msg_len, msg_len_max;
+       int ret=0;
+       u8 buf[1+len], msg_len, msg_len_max;
+       int remaining;
        struct i2c_msg msg[1] = {
                {
                        .addr = priv->cfg->i2c_address,
@@ -39,18 +40,21 @@ static int tda18218_wr_regs(struct tda18
        };

        msg_len_max = priv->cfg->i2c_wr_max - 1;
-       quotient = len / msg_len_max;
-       remainder = len % msg_len_max;
-       msg_len = msg_len_max;
-       for (i = 0; (i <= quotient && remainder); i++) {
-               if (i == quotient)  /* set len of the last msg */
-                       msg_len = remainder;
-
-               msg[0].len = msg_len + 1;
-               buf[0] = reg + i * msg_len_max;
-               memcpy(&buf[1], &val[i * msg_len_max], msg_len);
+
+       remaining = len;
+       for (; remaining > 0;remaining -= msg_len_max) {
+
+               msg_len = remaining;
+
+               if (msg_len > msg_len_max)  /* set len of the last msg */
+                       msg_len = msg_len_max;
+
+               msg[0].len = msg_len +1;
+               buf[0] = reg + (len - remaining);
+               memcpy(&buf[1], &val[(len - remaining)], msg_len);

                ret = i2c_transfer(priv->i2c, msg, 1);
+
                if (ret != 1)
                        break;
        }
