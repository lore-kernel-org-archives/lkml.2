Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1FITZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:25:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34494 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab1FITW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SqjxB19bOeRgxnn8EIHPEU620vkJMx2XaUHiaento6ixaxXCgSQpNT7blXwkT3MkFX
         qtG3QJYA4PHrKopBN9+fz6sBZpbquELsMJ4nLGpJ2eBd/g/X+eiiF+esxkzFF4K/nXiE
         mOepuhOpk2SJYn++NO3CGd6H2Ht4DNAJHsicU=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 03/13] i2c-designware: Allow mixed endianness accesses
Date: Thu,  9 Jun 2011 12:21:40 -0700
Message-Id: <1307647310-24332-4-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>

Allows CPUs of a given endianness to access a dw controller of a different
endianness. Endianncess difference is detected at run time through the dw
component type register.

Signed-off-by: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index 4be9297..680f7c9 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -37,6 +37,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/swab.h>
 
 /*
  * Registers offset
@@ -193,6 +194,7 @@ static char *abort_sources[] = {
  * @status: i2c master status, one of STATUS_*
  * @abort_source: copy of the TX_ABRT_SOURCE register
  * @irq: interrupt number for the i2c master
+ * @swab: true if the instantiated IP is of different endianess
  * @adapter: i2c subsystem adapter node
  * @tx_fifo_depth: depth of the hardware tx fifo
  * @rx_fifo_depth: depth of the hardware rx fifo
@@ -216,6 +218,7 @@ struct dw_i2c_dev {
 	unsigned int		status;
 	u32			abort_source;
 	int			irq;
+	int			swab;
 	struct i2c_adapter	adapter;
 	unsigned int		tx_fifo_depth;
 	unsigned int		rx_fifo_depth;
@@ -223,11 +226,19 @@ struct dw_i2c_dev {
 
 static u32 dw_readl(struct dw_i2c_dev *dev, int offset)
 {
-	return readl(dev->base + offset);
+	u32 value = readl(dev->base + offset);
+
+	if (dev->swab)
+		return swab32(value);
+	else
+		return value;
 }
 
 static void dw_writel(struct dw_i2c_dev *dev, u32 b, int offset)
 {
+	if (dev->swab)
+		b = swab32(b);
+
 	writel(b, dev->base + offset);
 }
 
@@ -760,7 +771,9 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 	}
 
 	reg = dw_readl(dev, DW_IC_COMP_TYPE);
-	if (reg != 0x44570140) {
+	if (reg == ___constant_swab32(0x44570140))
+		dev->swab = 1;
+	else if (reg != 0x44570140) {
 		dev_err(&pdev->dev, "Unknown Synopsys component type: "
 				"0x%08x\n",	reg);
 		r = -ENODEV;
-- 
1.7.3.4

