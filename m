Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1CLUZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:25:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56750 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab1CLUXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:23:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jgu5TuGm8pGLQ0uMVPjcFZxMi/rR+3Mqyip1omMQKT1C8p9FY5u8v8A92p2YDLVXee
         0Ym66i36QR8Bd4M5rV4dEJ2M8dncqxcl5A0aaRy8VdSIxI33rC4RXP16eKi6zeWC+wJ1
         FSdNTT1YXBRSRD/HEMs2HYYZvCDdmYEYKofQQ=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 06/13] i2c-designware: Move retriveving the clock speed out of core code.
Date: Sat, 12 Mar 2011 12:23:20 -0800
Message-Id: <1299961407-26852-7-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
References: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The clock frequecy supplied to the IP core is specific to a single
instance of the driver.  This patch makes it possible to have multiple
Designware I2C cores in the system possibly running at different core
frequencies.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/i2c/busses/i2c-designware-core.c    |    4 +++-
 drivers/i2c/busses/i2c-designware-core.h    |    1 +
 drivers/i2c/busses/i2c-designware-platdrv.c |    6 ++++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 432bfdd..4a0394e 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -141,10 +141,12 @@ static u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
  */
 int i2c_dw_init(struct dw_i2c_dev *dev)
 {
-	u32 input_clock_khz = clk_get_rate(dev->clk) / 1000;
+	u32 input_clock_khz;
 	u32 ic_con, hcnt, lcnt;
 	u32 reg;
 
+	input_clock_khz = dev->get_clk_rate_khz(dev);
+
 	/* Configure register endianess access */
 	reg = dw_readl(dev, DW_IC_COMP_TYPE);
 	if (reg == ___constant_swab32(DW_IC_COMP_TYPE_VALUE)) {
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 4e37031..43de340 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -166,6 +166,7 @@ struct dw_i2c_dev {
 	struct completion	cmd_complete;
 	struct mutex		lock;
 	struct clk		*clk;
+	u32			(*get_clk_rate_khz) (struct dw_i2c_dev *dev);
 	int			cmd_err;
 	struct i2c_msg		*msgs;
 	int			msgs_num;
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 9d10ae8..08783a6 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -43,6 +43,10 @@ static struct i2c_algorithm i2c_dw_algo = {
 	.master_xfer	= i2c_dw_xfer,
 	.functionality	= i2c_dw_func,
 };
+static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
+{
+	return clk_get_rate(dev->clk)/1000;
+}
 
 static int __devinit dw_i2c_probe(struct platform_device *pdev)
 {
@@ -84,6 +88,8 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 
 	dev->clk = clk_get(&pdev->dev, NULL);
+	dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
+
 	if (IS_ERR(dev->clk)) {
 		r = -ENODEV;
 		goto err_free_mem;
-- 
1.7.3.4

