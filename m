Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1FITZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:25:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59091 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab1FITW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F+64S+dPQpV/vencYsi34TKW+Ox7WgMAAbT7LvjkRXjcfjxyImAJZTcjJRryw9PpBg
         ETQq6yCgQaLXNw0JjBdGrxz5ada5kvlBbRLQxgWDrxYlZd4EK5L3ljoRxQDztjxlqNkV
         I3dXoSpPgS1Wrq3AdqgAztczKl7kTKMqjAeVs=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 04/13] i2c-designware: Move checking of IP core version to i2c_dw_init()
Date: Thu,  9 Jun 2011 12:21:41 -0700
Message-Id: <1307647310-24332-5-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Move checking IP core version to i2c_dw_init() in preparation for
splitting i2c-designware.c into core and bus specific portions.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index 680f7c9..e5c2362 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -305,10 +305,24 @@ static u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
  * This function is called during I2C init function, and in case of timeout at
  * run time.
  */
-static void i2c_dw_init(struct dw_i2c_dev *dev)
+static int i2c_dw_init(struct dw_i2c_dev *dev)
 {
 	u32 input_clock_khz = clk_get_rate(dev->clk) / 1000;
 	u32 ic_con, hcnt, lcnt;
+	u32 reg;
+
+	/* Configure register endianess access */
+	reg = dw_readl(dev, DW_IC_COMP_TYPE);
+	if (reg == ___constant_swab32(DW_IC_COMP_TYPE_VALUE)) {
+		dev->swab = 1;
+		reg = DW_IC_COMP_TYPE_VALUE;
+	}
+
+	if (reg != DW_IC_COMP_TYPE_VALUE) {
+		dev_err(dev->dev, "Unknown Synopsys component type: "
+			"0x%08x\n", reg);
+		return -ENODEV;
+	}
 
 	/* Disable the adapter */
 	dw_writel(dev, 0, DW_IC_ENABLE);
@@ -351,6 +365,7 @@ static void i2c_dw_init(struct dw_i2c_dev *dev)
 	ic_con = DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
 		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
 	dw_writel(dev, ic_con, DW_IC_CON);
+	return 0;
 }
 
 /*
@@ -770,21 +785,14 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 		goto err_unuse_clocks;
 	}
 
-	reg = dw_readl(dev, DW_IC_COMP_TYPE);
-	if (reg == ___constant_swab32(0x44570140))
-		dev->swab = 1;
-	else if (reg != 0x44570140) {
-		dev_err(&pdev->dev, "Unknown Synopsys component type: "
-				"0x%08x\n",	reg);
-		r = -ENODEV;
-		goto err_iounmap;
-	}
+	r = i2c_dw_init(dev);
+	if (r)
+		goto err_unuse_clocks;
 
 	reg = dw_readl(dev, DW_IC_COMP_PARAM_1);
 	dev->tx_fifo_depth = ((reg >> 16) & 0xff) + 1;
 	dev->rx_fifo_depth = ((reg >> 8)  & 0xff) + 1;
 
-	i2c_dw_init(dev);
 
 	dw_writel(dev, 0, DW_IC_INTR_MASK); /* disable IRQ */
 	r = request_irq(dev->irq, i2c_dw_isr, IRQF_DISABLED, pdev->name, dev);
-- 
1.7.3.4

