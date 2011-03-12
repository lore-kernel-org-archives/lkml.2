Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1CLUZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:25:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56750 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab1CLUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:23:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U3HGiBVLL4mwyzWf9xWxZZ1vywrVRbpVs9btPtNzJoUmyE9pv5C1J+pD1iEP9JBhGq
         SVGRUtWvyL/xARmqMmvZb1tDj3pjidffz6rYs2J9/LqMQHQ6eooemacmuUM1DkyhdFwk
         QmRyFcuMoiGHFxMgknBYSIs7uGz33j/IN/7sQ=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 08/13] i2c-designware: move controller config to bus specific portion of driver
Date: Sat, 12 Mar 2011 12:23:22 -0800
Message-Id: <1299961407-26852-9-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
References: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

With multiple I2C adapters possible in the system each running at
(possibly) different speeds we need to move the controller
configuration bit field to the adapter.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/i2c/busses/i2c-designware-core.c    |    6 ++----
 drivers/i2c/busses/i2c-designware-core.h    |    1 +
 drivers/i2c/busses/i2c-designware-platdrv.c |    2 ++
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 61f0101..6e31d35 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -142,7 +142,7 @@ static u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
 int i2c_dw_init(struct dw_i2c_dev *dev)
 {
 	u32 input_clock_khz;
-	u32 ic_con, hcnt, lcnt;
+	u32 hcnt, lcnt;
 	u32 reg;
 
 	input_clock_khz = dev->get_clk_rate_khz(dev);
@@ -198,9 +198,7 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	dw_writel(dev, 0, DW_IC_RX_TL);
 
 	/* configure the i2c master */
-	ic_con = DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
-		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
-	dw_writel(dev, ic_con, DW_IC_CON);
+	dw_writel(dev, dev->master_cfg , DW_IC_CON);
 	return 0;
 }
 
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index ab4e655..2938621 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -183,6 +183,7 @@ struct dw_i2c_dev {
 	int			swab;
 	struct i2c_adapter	adapter;
 	u32			functionality;
+	u32			master_cfg;
 	unsigned int		tx_fifo_depth;
 	unsigned int		rx_fifo_depth;
 };
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 36db7a8..1258cae 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -103,6 +103,8 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 		I2C_FUNC_SMBUS_BYTE_DATA |
 		I2C_FUNC_SMBUS_WORD_DATA |
 		I2C_FUNC_SMBUS_I2C_BLOCK;
+	dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
+		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
 
 	dev->base = ioremap(mem->start, resource_size(mem));
 	if (dev->base == NULL) {
-- 
1.7.3.4

