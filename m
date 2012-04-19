Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2DSJwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:52:03 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:33877
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab2DSJv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:51:57 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linux-i2c@vger.kernel.org>
CC: <w.sang@pengutronix.de>, <leoli@freescale.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] i2c-mpc: avoid I2C abnormal after resuming from deep sleep
Date: Thu, 19 Apr 2012 17:51:34 +0800
Message-ID: <1334829094-22048-1-git-send-email-chenhui.zhao@freescale.com>
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
 drivers/i2c/busses/i2c-mpc.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index a8ebb84..fb2627b 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -64,6 +64,9 @@ struct mpc_i2c {
 	struct i2c_adapter adap;
 	int irq;
 	u32 real_clk;
+#ifdef CONFIG_PM
+	u8 fdr, dfsrr;
+#endif
 };
 
 struct mpc_i2c_divider {
@@ -668,6 +671,30 @@ static int __devexit fsl_i2c_remove(struct platform_device *op)
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
@@ -712,6 +739,9 @@ static struct platform_driver mpc_i2c_driver = {
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


