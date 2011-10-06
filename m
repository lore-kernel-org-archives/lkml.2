Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab1JFS1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:27:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62341 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935Ab1JFS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:27:26 -0400
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: ben-linux@fluff.org,
        Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 02/13] i2c-designware: Check component type register
Date: Thu,  6 Oct 2011 11:26:26 -0700
Message-Id: <1317925597-32245-3-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1317925597-32245-1-git-send-email-dirk.brandewie@gmail.com>
References: <1317925597-32245-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>

Designware component type register is checked before attaching to the device.

Signed-off-by: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index 1afb8c0..4be9297 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -69,6 +69,7 @@
 #define DW_IC_TXFLR		0x74
 #define DW_IC_RXFLR		0x78
 #define DW_IC_COMP_PARAM_1	0xf4
+#define DW_IC_COMP_TYPE		0xfc
 #define DW_IC_TX_ABRT_SOURCE	0x80
 
 #define DW_IC_CON_MASTER		0x1
@@ -710,6 +711,7 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 	struct i2c_adapter *adap;
 	struct resource *mem, *ioarea;
 	int irq, r;
+	u32 reg;
 
 	/* NOTE: driver uses the static register mapping */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -756,12 +758,19 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 		r = -EBUSY;
 		goto err_unuse_clocks;
 	}
-	{
-		u32 param1 = dw_readl(dev, DW_IC_COMP_PARAM_1);
 
-		dev->tx_fifo_depth = ((param1 >> 16) & 0xff) + 1;
-		dev->rx_fifo_depth = ((param1 >> 8)  & 0xff) + 1;
+	reg = dw_readl(dev, DW_IC_COMP_TYPE);
+	if (reg != 0x44570140) {
+		dev_err(&pdev->dev, "Unknown Synopsys component type: "
+				"0x%08x\n",	reg);
+		r = -ENODEV;
+		goto err_iounmap;
 	}
+
+	reg = dw_readl(dev, DW_IC_COMP_PARAM_1);
+	dev->tx_fifo_depth = ((reg >> 16) & 0xff) + 1;
+	dev->rx_fifo_depth = ((reg >> 8)  & 0xff) + 1;
+
 	i2c_dw_init(dev);
 
 	dw_writel(dev, 0, DW_IC_INTR_MASK); /* disable IRQ */
-- 
1.7.3.4

