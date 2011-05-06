Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1EFJa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:30:29 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:50568 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1EFJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:29:09 -0400
X-ASG-Debug-ID: 1304674149-082ccec50001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it,
        khali@linux-fr.org, ben-linux@fluff.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 3/6] mfd: 88pm860x: enhance lock on i2c transaction
Subject: [PATCH 3/6] mfd: 88pm860x: enhance lock on i2c transaction
Date: Fri,  6 May 2011 17:21:22 +0800
X-ASG-Orig-Subj: [PATCH 3/6] mfd: 88pm860x: enhance lock on i2c transaction
Message-Id: <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1304674149
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing test page in 88pm860x is a sequence of read/write on i2c bus.
Bus lock is used in each small i2c transaction. But it may result the
whole sequence interrupted by other i2c client transaction.

Use i2c_lock_adapter()/i2c_unlock_adapter() to protect the sequence and
use master_xfer() to send i2c message.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 drivers/mfd/88pm860x-i2c.c |  112 +++++++++++++++++++++++++++++++------------
 1 files changed, 81 insertions(+), 31 deletions(-)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index e017dc8..67a34f4 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -126,6 +126,51 @@ out:
 }
 EXPORT_SYMBOL(pm860x_set_bits);
 
+static int read_device(struct i2c_client *i2c, int reg,
+		       int bytes, void *dest)
+{
+	unsigned char msgbuf0[I2C_SMBUS_BLOCK_MAX + 3];
+	unsigned char msgbuf1[I2C_SMBUS_BLOCK_MAX + 2];
+	struct i2c_adapter *adap = i2c->adapter;
+	struct i2c_msg msg[2] = {{i2c->addr, i2c->flags, 1, msgbuf0},
+				 {i2c->addr, i2c->flags | I2C_M_RD, 0, msgbuf1},
+				};
+	int num = 1, ret = 0;
+
+	if (dest == NULL)
+		return -EINVAL;
+	msgbuf0[0] = (unsigned char)reg;	/* command */
+	msg[1].len = bytes;
+
+	/* if data needs to read back, num should be 2 */
+	if (bytes > 0)
+		num = 2;
+	ret = adap->algo->master_xfer(adap, msg, num);
+	memcpy(dest, msgbuf1, bytes);
+	return ret;
+}
+
+static int write_device(struct i2c_client *i2c, int reg,
+			int bytes, void *src)
+{
+	unsigned char buf[bytes + 1];
+	struct i2c_adapter *adap = i2c->adapter;
+	struct i2c_msg msg;
+	int ret;
+
+	buf[0] = (unsigned char)reg;
+	memcpy(&buf[1], src, bytes);
+	msg.addr = i2c->addr;
+	msg.flags = i2c->flags;
+	msg.len = bytes + 1;
+	msg.buf = buf;
+
+	ret = adap->algo->master_xfer(adap, &msg, 1);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
 int pm860x_page_reg_read(struct i2c_client *i2c, int reg)
 {
 	struct pm860x_chip *chip = i2c_get_clientdata(i2c);
@@ -134,14 +179,15 @@ int pm860x_page_reg_read(struct i2c_client *i2c, int reg)
 	int ret;
 
 	mutex_lock(&chip->io_lock);
-	pm860x_write_device(i2c, 0xFA, 0, &zero);
-	pm860x_write_device(i2c, 0xFB, 0, &zero);
-	pm860x_write_device(i2c, 0xFF, 0, &zero);
-	ret = pm860x_read_device(i2c, reg, 1, &data);
+	i2c_lock_adapter(i2c->adapter);
+	read_device(i2c, 0xFA, 0, &zero);
+	read_device(i2c, 0xFB, 0, &zero);
+	read_device(i2c, 0xFF, 0, &zero);
+	ret = read_device(i2c, reg, 1, &data);
 	if (ret >= 0)
 		ret = (int)data;
-	pm860x_write_device(i2c, 0xFE, 0, &zero);
-	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	read_device(i2c, 0xFC, 0, &zero);
+	i2c_unlock_adapter(i2c->adapter);
 	mutex_unlock(&chip->io_lock);
 	return ret;
 }
@@ -155,12 +201,13 @@ int pm860x_page_reg_write(struct i2c_client *i2c, int reg,
 	int ret;
 
 	mutex_lock(&chip->io_lock);
-	pm860x_write_device(i2c, 0xFA, 0, &zero);
-	pm860x_write_device(i2c, 0xFB, 0, &zero);
-	pm860x_write_device(i2c, 0xFF, 0, &zero);
-	ret = pm860x_write_device(i2c, reg, 1, &data);
-	pm860x_write_device(i2c, 0xFE, 0, &zero);
-	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	i2c_lock_adapter(i2c->adapter);
+	read_device(i2c, 0xFA, 0, &zero);
+	read_device(i2c, 0xFB, 0, &zero);
+	read_device(i2c, 0xFF, 0, &zero);
+	ret = write_device(i2c, reg, 1, &data);
+	read_device(i2c, 0xFC, 0, &zero);
+	i2c_unlock_adapter(i2c->adapter);
 	mutex_unlock(&chip->io_lock);
 	return ret;
 }
@@ -174,12 +221,13 @@ int pm860x_page_bulk_read(struct i2c_client *i2c, int reg,
 	int ret;
 
 	mutex_lock(&chip->io_lock);
-	pm860x_write_device(i2c, 0xFA, 0, &zero);
-	pm860x_write_device(i2c, 0xFB, 0, &zero);
-	pm860x_write_device(i2c, 0xFF, 0, &zero);
-	ret = pm860x_read_device(i2c, reg, count, buf);
-	pm860x_write_device(i2c, 0xFE, 0, &zero);
-	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	i2c_lock_adapter(i2c->adapter);
+	read_device(i2c, 0xFA, 0, &zero);
+	read_device(i2c, 0xFB, 0, &zero);
+	read_device(i2c, 0xFF, 0, &zero);
+	ret = read_device(i2c, reg, count, buf);
+	read_device(i2c, 0xFC, 0, &zero);
+	i2c_unlock_adapter(i2c->adapter);
 	mutex_unlock(&chip->io_lock);
 	return ret;
 }
@@ -193,12 +241,13 @@ int pm860x_page_bulk_write(struct i2c_client *i2c, int reg,
 	int ret;
 
 	mutex_lock(&chip->io_lock);
-	pm860x_write_device(i2c, 0xFA, 0, &zero);
-	pm860x_write_device(i2c, 0xFB, 0, &zero);
-	pm860x_write_device(i2c, 0xFF, 0, &zero);
-	ret = pm860x_write_device(i2c, reg, count, buf);
-	pm860x_write_device(i2c, 0xFE, 0, &zero);
-	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	i2c_lock_adapter(i2c->adapter);
+	read_device(i2c, 0xFA, 0, &zero);
+	read_device(i2c, 0xFB, 0, &zero);
+	read_device(i2c, 0xFF, 0, &zero);
+	ret = write_device(i2c, reg, count, buf);
+	read_device(i2c, 0xFC, 0, &zero);
+	i2c_unlock_adapter(i2c->adapter);
 	mutex_unlock(&chip->io_lock);
 	return ret;
 }
@@ -213,18 +262,19 @@ int pm860x_page_set_bits(struct i2c_client *i2c, int reg,
 	int ret;
 
 	mutex_lock(&chip->io_lock);
-	pm860x_write_device(i2c, 0xFA, 0, &zero);
-	pm860x_write_device(i2c, 0xFB, 0, &zero);
-	pm860x_write_device(i2c, 0xFF, 0, &zero);
-	ret = pm860x_read_device(i2c, reg, 1, &value);
+	i2c_lock_adapter(i2c->adapter);
+	read_device(i2c, 0xFA, 0, &zero);
+	read_device(i2c, 0xFB, 0, &zero);
+	read_device(i2c, 0xFF, 0, &zero);
+	ret = read_device(i2c, reg, 1, &value);
 	if (ret < 0)
 		goto out;
 	value &= ~mask;
 	value |= data;
-	ret = pm860x_write_device(i2c, reg, 1, &value);
+	ret = write_device(i2c, reg, 1, &value);
 out:
-	pm860x_write_device(i2c, 0xFE, 0, &zero);
-	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	read_device(i2c, 0xFC, 0, &zero);
+	i2c_unlock_adapter(i2c->adapter);
 	mutex_unlock(&chip->io_lock);
 	return ret;
 }
-- 
1.5.6.5

