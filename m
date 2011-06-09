Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1FITWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:22:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64443 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1FITW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p5rVmcmH5YHYQxkXIUndGxCUmcREGeqtg8QkOzgfchBja1oJsx2f88GS9qn2kCQ4kS
         SZVDLh1XP3MPzrz6bynD7zZu5CnArRYgnWmD83TA3VYUvnLKK3p80BECxyBM5LYsdJK8
         0DdnQsN7w+17Vh03QlH94GVVInoN2yL1SoZTo=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 02/13] i2c-designware: Check component type register
Date: Thu,  9 Jun 2011 12:21:39 -0700
Message-Id: <1307647310-24332-3-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
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

