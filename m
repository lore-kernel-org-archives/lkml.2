Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1CQVmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:42:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36823 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755662Ab1CQVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:42:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] mfd: Avoid copying data in WM8994 I2C write
Date: Thu, 17 Mar 2011 21:42:28 +0000
Message-Id: <1300398150-11834-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As well as providing a trivial performance optimisation this also avoids
allocating a copy of the message on the stack which is beneficial when
doing large transfers.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 749c31d..ce93796 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -580,25 +580,29 @@ static int wm8994_i2c_read_device(struct wm8994 *wm8994, unsigned short reg,
 	return 0;
 }
 
-/* Currently we allocate the write buffer on the stack; this is OK for
- * small writes - if we need to do large writes this will need to be
- * revised.
- */
 static int wm8994_i2c_write_device(struct wm8994 *wm8994, unsigned short reg,
 				   int bytes, void *src)
 {
 	struct i2c_client *i2c = wm8994->control_data;
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

