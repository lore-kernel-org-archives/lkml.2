Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2B2KiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:38:12 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:37970 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2B2KiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:38:10 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Zhao Chenhui <chenhui.zhao@freescale.com>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep sleep
Date: Wed, 29 Feb 2012 18:39:21 +0800
Message-ID: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When entering deep sleep, the value in the registers I2CFDR and
I2CDFSRR are lost. This causes I2C access to fail after resuming.

Add suspend/resume routines to save/restore the registers
I2CFDR and I2CDFSRR.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/i2c/busses/i2c-mpc.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index a8ebb84..f95a647 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -1,7 +1,9 @@
 /*
  * (C) Copyright 2003-2004
  * Humboldt Solutions Ltd, adrian@humboldt.co.uk.
-
+ *
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ *
  * This is a combined i2c adapter and algorithm driver for the
  * MPC107/Tsi107 PowerPC northbridge and processors that include
  * the same I2C unit (8240, 8245, 85xx).
@@ -64,6 +66,9 @@ struct mpc_i2c {
 	struct i2c_adapter adap;
 	int irq;
 	u32 real_clk;
+#ifdef CONFIG_PM
+	u8 fdr, dfsrr;
+#endif
 };
 
 struct mpc_i2c_divider {
@@ -668,6 +673,30 @@ static int __devexit fsl_i2c_remove(struct platform_device *op)
 	return 0;
 };
 
+#ifdef CONFIG_PM
+static int mpc_i2c_suspend(struct device *dev)
+{
+	struct mpc_i2c *i2c = dev_get_drvdata(dev);
+
+	i2c->fdr = readb(i2c->base + MPC_I2C_FDR);
+	i2c->dfsrr = readb(i2c->base + MPC_I2C_DFSRR);
+
+	return 0;
+}
+
+static int mpc_i2c_resume(struct device *dev)
+{
+	struct mpc_i2c *i2c = dev_get_drvdata(dev);
+
+	writeb(i2c->fdr, i2c->base + MPC_I2C_FDR);
+	writeb(i2c->dfsrr, i2c->base + MPC_I2C_DFSRR);
+
+	return 0;
+}
+
+SIMPLE_DEV_PM_OPS(mpc_i2c_pm_ops, mpc_i2c_suspend, mpc_i2c_resume);
+#endif
+
 static struct mpc_i2c_data mpc_i2c_data_512x __devinitdata = {
 	.setup = mpc_i2c_setup_512x,
 };
@@ -712,6 +741,9 @@ static struct platform_driver mpc_i2c_driver = {
 		.owner = THIS_MODULE,
 		.name = DRV_NAME,
 		.of_match_table = mpc_i2c_of_match,
+#ifdef CONFIG_PM
+		.pm = &mpc_i2c_pm_ops,
+#endif
 	},
 };
 
-- 
1.6.4.1


