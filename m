Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1CQVk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:40:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36813 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094Ab1CQVkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:40:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Remove copy from WM831x I2C write function
Date: Thu, 17 Mar 2011 21:40:51 +0000
Message-Id: <1300398051-11238-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves us allocating an array on the stack, giving a meaningless
performance improvement and ensuring that if drivers ever do large writes
we'll not allocate large arrays on the stack.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-i2c.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
index 3853fa8..a06cbc7 100644
--- a/drivers/mfd/wm831x-i2c.c
+++ b/drivers/mfd/wm831x-i2c.c
@@ -51,17 +51,25 @@ static int wm831x_i2c_write_device(struct wm831x *wm831x, unsigned short reg,
 				   int bytes, void *src)
 {
 	struct i2c_client *i2c = wm831x->control_data;
-	unsigned char msg[bytes + 2];
+	struct i2c_msg xfer[2];
 	int ret;
 
 	reg = cpu_to_be16(reg);
-	memcpy(&msg[0], &reg, 2);
-	memcpy(&msg[2], src, bytes);
 
-	ret = i2c_master_send(i2c, msg, bytes + 2);
+	xfer[0].addr = i2c->addr;
+	xfer[0].flags = 0;
+	xfer[0].len = 2;
+	xfer[0].buf = (char *)&reg;
+
+	xfer[1].addr = i2c->addr;
+	xfer[1].flags = I2C_M_NOSTART;
+	xfer[1].len = bytes;
+	xfer[1].buf = (char *)src;
+
+	ret = i2c_transfer(i2c->adapter, xfer, 2);
 	if (ret < 0)
 		return ret;
-	if (ret < bytes + 2)
+	if (ret != 2)
 		return -EIO;
 
 	return 0;
-- 
1.7.4.1

