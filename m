Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab1JFS1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:27:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43730 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935Ab1JFS1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:27:32 -0400
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: ben-linux@fluff.org, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 06/13] i2c-designware: Move retriveving the clock speed out of core code.
Date: Thu,  6 Oct 2011 11:26:30 -0700
Message-Id: <1317925597-32245-7-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1317925597-32245-1-git-send-email-dirk.brandewie@gmail.com>
References: <1317925597-32245-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The clock frequecy supplied to the IP core is specific to a single
instance of the driver.  This patch makes it possible to have multiple
Designware I2C cores in the system possibly running at different core
frequencies.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware-core.c    |    4 +++-
 drivers/i2c/busses/i2c-designware-core.h    |    1 +
 drivers/i2c/busses/i2c-designware-platdrv.c |    6 ++++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 38d5a6b..cd52f17 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -142,10 +142,12 @@ static u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
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

