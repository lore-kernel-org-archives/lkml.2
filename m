Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab1CLUXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:23:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56750 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab1CLUXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:23:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L7QWsEQw4yiHyjvthdAoecyErajMyrcDBvXYQeASLH4Nn+4L3euhJTXMKfzCsCNOPm
         n4AidQeK4ID/b0XLutzrt9eaqZBJ5pnkTuHTcQdkkh+E0L63f5hUCq+IK0ee3fodq6N8
         dCXr7sFAkWMLsBGb0JQHeangwQHSVZxeBTEGw=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 03/13] i2c-designware: Allow mixed endianness accesses
Date: Sat, 12 Mar 2011 12:23:17 -0800
Message-Id: <1299961407-26852-4-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
References: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>

Allows CPUs of a given endianness to access a dw controller of a different
endianness. Endianncess difference is detected at run time through the dw
component type register.

Signed-off-by: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/i2c/busses/i2c-designware.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index b2b2a19..f58f05d 100644
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

