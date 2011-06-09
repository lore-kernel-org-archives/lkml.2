Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1FITYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:24:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59091 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1FITWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xc+bJdROgtIpxO3AzxfwVn1OMzXXcOWxOwiEMs9olDcrlhhjJKp2RnRZIxKu/r8C4U
         RvNJP+1ZNbzU6oY+lPk6/AD6/Ma/82TRFrZOFGmc0oq2SS7VHxHAV50+8NUyUwt08rEg
         U364zM/4LdXvKsm7LeW/t7Iaw+fgGSgC2AgGQ=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 10/13] i2c-designware: Push all register reads/writes into the core code.
Date: Thu,  9 Jun 2011 12:21:47 -0700
Message-Id: <1307647310-24332-11-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Move all register manipulation code into the core, also move register
offset definitions to i2c-designware-core.c since the bus specific
portions of the driver no longer need/use them.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware-core.c    |  134 +++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-designware-core.h    |  105 +--------------------
 drivers/i2c/busses/i2c-designware-platdrv.c |    6 +-
 3 files changed, 143 insertions(+), 102 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 11909eb..b9f18dd 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -34,6 +34,108 @@
 #include <linux/delay.h>
 #include "i2c-designware-core.h"
 
+/*
+ * Registers offset
+ */
+#define DW_IC_CON		0x0
+#define DW_IC_TAR		0x4
+#define DW_IC_DATA_CMD		0x10
+#define DW_IC_SS_SCL_HCNT	0x14
+#define DW_IC_SS_SCL_LCNT	0x18
+#define DW_IC_FS_SCL_HCNT	0x1c
+#define DW_IC_FS_SCL_LCNT	0x20
+#define DW_IC_INTR_STAT		0x2c
+#define DW_IC_INTR_MASK		0x30
+#define DW_IC_RAW_INTR_STAT	0x34
+#define DW_IC_RX_TL		0x38
+#define DW_IC_TX_TL		0x3c
+#define DW_IC_CLR_INTR		0x40
+#define DW_IC_CLR_RX_UNDER	0x44
+#define DW_IC_CLR_RX_OVER	0x48
+#define DW_IC_CLR_TX_OVER	0x4c
+#define DW_IC_CLR_RD_REQ	0x50
+#define DW_IC_CLR_TX_ABRT	0x54
+#define DW_IC_CLR_RX_DONE	0x58
+#define DW_IC_CLR_ACTIVITY	0x5c
+#define DW_IC_CLR_STOP_DET	0x60
+#define DW_IC_CLR_START_DET	0x64
+#define DW_IC_CLR_GEN_CALL	0x68
+#define DW_IC_ENABLE		0x6c
+#define DW_IC_STATUS		0x70
+#define DW_IC_TXFLR		0x74
+#define DW_IC_RXFLR		0x78
+#define DW_IC_TX_ABRT_SOURCE	0x80
+#define DW_IC_COMP_PARAM_1	0xf4
+#define DW_IC_COMP_TYPE		0xfc
+#define DW_IC_COMP_TYPE_VALUE	0x44570140
+
+#define DW_IC_INTR_RX_UNDER	0x001
+#define DW_IC_INTR_RX_OVER	0x002
+#define DW_IC_INTR_RX_FULL	0x004
+#define DW_IC_INTR_TX_OVER	0x008
+#define DW_IC_INTR_TX_EMPTY	0x010
+#define DW_IC_INTR_RD_REQ	0x020
+#define DW_IC_INTR_TX_ABRT	0x040
+#define DW_IC_INTR_RX_DONE	0x080
+#define DW_IC_INTR_ACTIVITY	0x100
+#define DW_IC_INTR_STOP_DET	0x200
+#define DW_IC_INTR_START_DET	0x400
+#define DW_IC_INTR_GEN_CALL	0x800
+
+#define DW_IC_INTR_DEFAULT_MASK		(DW_IC_INTR_RX_FULL | \
+					 DW_IC_INTR_TX_EMPTY | \
+					 DW_IC_INTR_TX_ABRT | \
+					 DW_IC_INTR_STOP_DET)
+
+#define DW_IC_STATUS_ACTIVITY	0x1
+
+#define DW_IC_ERR_TX_ABRT	0x1
+
+/*
+ * status codes
+ */
+#define STATUS_IDLE			0x0
+#define STATUS_WRITE_IN_PROGRESS	0x1
+#define STATUS_READ_IN_PROGRESS		0x2
+
+#define TIMEOUT			20 /* ms */
+
+/*
+ * hardware abort codes from the DW_IC_TX_ABRT_SOURCE register
+ *
+ * only expected abort codes are listed here
+ * refer to the datasheet for the full list
+ */
+#define ABRT_7B_ADDR_NOACK	0
+#define ABRT_10ADDR1_NOACK	1
+#define ABRT_10ADDR2_NOACK	2
+#define ABRT_TXDATA_NOACK	3
+#define ABRT_GCALL_NOACK	4
+#define ABRT_GCALL_READ		5
+#define ABRT_SBYTE_ACKDET	7
+#define ABRT_SBYTE_NORSTRT	9
+#define ABRT_10B_RD_NORSTRT	10
+#define ABRT_MASTER_DIS		11
+#define ARB_LOST		12
+
+#define DW_IC_TX_ABRT_7B_ADDR_NOACK	(1UL << ABRT_7B_ADDR_NOACK)
+#define DW_IC_TX_ABRT_10ADDR1_NOACK	(1UL << ABRT_10ADDR1_NOACK)
+#define DW_IC_TX_ABRT_10ADDR2_NOACK	(1UL << ABRT_10ADDR2_NOACK)
+#define DW_IC_TX_ABRT_TXDATA_NOACK	(1UL << ABRT_TXDATA_NOACK)
+#define DW_IC_TX_ABRT_GCALL_NOACK	(1UL << ABRT_GCALL_NOACK)
+#define DW_IC_TX_ABRT_GCALL_READ	(1UL << ABRT_GCALL_READ)
+#define DW_IC_TX_ABRT_SBYTE_ACKDET	(1UL << ABRT_SBYTE_ACKDET)
+#define DW_IC_TX_ABRT_SBYTE_NORSTRT	(1UL << ABRT_SBYTE_NORSTRT)
+#define DW_IC_TX_ABRT_10B_RD_NORSTRT	(1UL << ABRT_10B_RD_NORSTRT)
+#define DW_IC_TX_ABRT_MASTER_DIS	(1UL << ABRT_MASTER_DIS)
+#define DW_IC_TX_ARB_LOST		(1UL << ARB_LOST)
+
+#define DW_IC_TX_ABRT_NOACK		(DW_IC_TX_ABRT_7B_ADDR_NOACK | \
+					 DW_IC_TX_ABRT_10ADDR1_NOACK | \
+					 DW_IC_TX_ABRT_10ADDR2_NOACK | \
+					 DW_IC_TX_ABRT_TXDATA_NOACK | \
+					 DW_IC_TX_ABRT_GCALL_NOACK)
+
 static char *abort_sources[] = {
 	[ABRT_7B_ADDR_NOACK] =
 		"slave address not acknowledged (7bit mode)",
@@ -563,3 +665,35 @@ tx_aborted:
 	return IRQ_HANDLED;
 }
 
+void i2c_dw_enable(struct dw_i2c_dev *dev)
+{
+       /* Enable the adapter */
+	dw_writel(dev, 1, DW_IC_ENABLE);
+}
+
+void i2c_dw_disable(struct dw_i2c_dev *dev)
+{
+	int ret;
+
+	/* Disable controller */
+	dw_writel(dev, 0, DW_IC_ENABLE);
+
+	/* Disable all interupts */
+	dw_writel(dev, 0, DW_IC_INTR_MASK);
+	dw_readl(dev, DW_IC_CLR_INTR);
+}
+
+void i2c_dw_clear_int(struct dw_i2c_dev *dev)
+{
+	dw_readl(dev, DW_IC_CLR_INTR);
+}
+
+void i2c_dw_disable_int(struct dw_i2c_dev *dev)
+{
+	dw_writel(dev, 0, DW_IC_INTR_MASK);
+}
+
+u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev)
+{
+	return dw_readl(dev, DW_IC_COMP_PARAM_1);
+}
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 2938621..697f12c 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -26,40 +26,6 @@
  *
  */
 
-/*
- * Registers offset
- */
-#define DW_IC_CON		0x0
-#define DW_IC_TAR		0x4
-#define DW_IC_DATA_CMD		0x10
-#define DW_IC_SS_SCL_HCNT	0x14
-#define DW_IC_SS_SCL_LCNT	0x18
-#define DW_IC_FS_SCL_HCNT	0x1c
-#define DW_IC_FS_SCL_LCNT	0x20
-#define DW_IC_INTR_STAT		0x2c
-#define DW_IC_INTR_MASK		0x30
-#define DW_IC_RAW_INTR_STAT	0x34
-#define DW_IC_RX_TL		0x38
-#define DW_IC_TX_TL		0x3c
-#define DW_IC_CLR_INTR		0x40
-#define DW_IC_CLR_RX_UNDER	0x44
-#define DW_IC_CLR_RX_OVER	0x48
-#define DW_IC_CLR_TX_OVER	0x4c
-#define DW_IC_CLR_RD_REQ	0x50
-#define DW_IC_CLR_TX_ABRT	0x54
-#define DW_IC_CLR_RX_DONE	0x58
-#define DW_IC_CLR_ACTIVITY	0x5c
-#define DW_IC_CLR_STOP_DET	0x60
-#define DW_IC_CLR_START_DET	0x64
-#define DW_IC_CLR_GEN_CALL	0x68
-#define DW_IC_ENABLE		0x6c
-#define DW_IC_STATUS		0x70
-#define DW_IC_TXFLR		0x74
-#define DW_IC_RXFLR		0x78
-#define DW_IC_TX_ABRT_SOURCE	0x80
-#define DW_IC_COMP_PARAM_1	0xf4
-#define DW_IC_COMP_TYPE		0xfc
-#define DW_IC_COMP_TYPE_VALUE	0x44570140
 
 #define DW_IC_CON_MASTER		0x1
 #define DW_IC_CON_SPEED_STD		0x2
@@ -68,72 +34,7 @@
 #define DW_IC_CON_RESTART_EN		0x20
 #define DW_IC_CON_SLAVE_DISABLE		0x40
 
-#define DW_IC_INTR_RX_UNDER	0x001
-#define DW_IC_INTR_RX_OVER	0x002
-#define DW_IC_INTR_RX_FULL	0x004
-#define DW_IC_INTR_TX_OVER	0x008
-#define DW_IC_INTR_TX_EMPTY	0x010
-#define DW_IC_INTR_RD_REQ	0x020
-#define DW_IC_INTR_TX_ABRT	0x040
-#define DW_IC_INTR_RX_DONE	0x080
-#define DW_IC_INTR_ACTIVITY	0x100
-#define DW_IC_INTR_STOP_DET	0x200
-#define DW_IC_INTR_START_DET	0x400
-#define DW_IC_INTR_GEN_CALL	0x800
-
-#define DW_IC_INTR_DEFAULT_MASK		(DW_IC_INTR_RX_FULL | \
-					 DW_IC_INTR_TX_EMPTY | \
-					 DW_IC_INTR_TX_ABRT | \
-					 DW_IC_INTR_STOP_DET)
-
-#define DW_IC_STATUS_ACTIVITY	0x1
-
-#define DW_IC_ERR_TX_ABRT	0x1
-
-/*
- * status codes
- */
-#define STATUS_IDLE			0x0
-#define STATUS_WRITE_IN_PROGRESS	0x1
-#define STATUS_READ_IN_PROGRESS		0x2
 
-#define TIMEOUT			20 /* ms */
-
-/*
- * hardware abort codes from the DW_IC_TX_ABRT_SOURCE register
- *
- * only expected abort codes are listed here
- * refer to the datasheet for the full list
- */
-#define ABRT_7B_ADDR_NOACK	0
-#define ABRT_10ADDR1_NOACK	1
-#define ABRT_10ADDR2_NOACK	2
-#define ABRT_TXDATA_NOACK	3
-#define ABRT_GCALL_NOACK	4
-#define ABRT_GCALL_READ		5
-#define ABRT_SBYTE_ACKDET	7
-#define ABRT_SBYTE_NORSTRT	9
-#define ABRT_10B_RD_NORSTRT	10
-#define ABRT_MASTER_DIS		11
-#define ARB_LOST		12
-
-#define DW_IC_TX_ABRT_7B_ADDR_NOACK	(1UL << ABRT_7B_ADDR_NOACK)
-#define DW_IC_TX_ABRT_10ADDR1_NOACK	(1UL << ABRT_10ADDR1_NOACK)
-#define DW_IC_TX_ABRT_10ADDR2_NOACK	(1UL << ABRT_10ADDR2_NOACK)
-#define DW_IC_TX_ABRT_TXDATA_NOACK	(1UL << ABRT_TXDATA_NOACK)
-#define DW_IC_TX_ABRT_GCALL_NOACK	(1UL << ABRT_GCALL_NOACK)
-#define DW_IC_TX_ABRT_GCALL_READ	(1UL << ABRT_GCALL_READ)
-#define DW_IC_TX_ABRT_SBYTE_ACKDET	(1UL << ABRT_SBYTE_ACKDET)
-#define DW_IC_TX_ABRT_SBYTE_NORSTRT	(1UL << ABRT_SBYTE_NORSTRT)
-#define DW_IC_TX_ABRT_10B_RD_NORSTRT	(1UL << ABRT_10B_RD_NORSTRT)
-#define DW_IC_TX_ABRT_MASTER_DIS	(1UL << ABRT_MASTER_DIS)
-#define DW_IC_TX_ARB_LOST		(1UL << ARB_LOST)
-
-#define DW_IC_TX_ABRT_NOACK		(DW_IC_TX_ABRT_7B_ADDR_NOACK | \
-					 DW_IC_TX_ABRT_10ADDR1_NOACK | \
-					 DW_IC_TX_ABRT_10ADDR2_NOACK | \
-					 DW_IC_TX_ABRT_TXDATA_NOACK | \
-					 DW_IC_TX_ABRT_GCALL_NOACK)
 /**
  * struct dw_i2c_dev - private i2c-designware data
  * @dev: driver model device node
@@ -195,3 +96,9 @@ extern int i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		int num);
 extern u32 i2c_dw_func(struct i2c_adapter *adap);
 extern irqreturn_t i2c_dw_isr(int this_irq, void *dev_id);
+extern void i2c_dw_enable(struct dw_i2c_dev *dev);
+extern void i2c_dw_disable(struct dw_i2c_dev *dev);
+extern void i2c_dw_clear_int(struct dw_i2c_dev *dev);
+extern void i2c_dw_disable_int(struct dw_i2c_dev *dev);
+extern u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev);
+
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 1258cae..2d3657a 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -113,7 +113,7 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 		goto err_unuse_clocks;
 	}
 	{
-		u32 param1 = dw_readl(dev, DW_IC_COMP_PARAM_1);
+		u32 param1 = i2c_dw_read_comp_param(dev);
 
 		dev->tx_fifo_depth = ((param1 >> 16) & 0xff) + 1;
 		dev->rx_fifo_depth = ((param1 >> 8)  & 0xff) + 1;
@@ -122,7 +122,7 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 	if (r)
 		goto err_iounmap;
 
-	dw_writel(dev, 0, DW_IC_INTR_MASK); /* disable IRQ */
+	i2c_dw_disable_int(dev);
 	r = request_irq(dev->irq, i2c_dw_isr, IRQF_DISABLED, pdev->name, dev);
 	if (r) {
 		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
@@ -178,7 +178,7 @@ static int __devexit dw_i2c_remove(struct platform_device *pdev)
 	clk_put(dev->clk);
 	dev->clk = NULL;
 
-	dw_writel(dev, 0, DW_IC_ENABLE);
+	i2c_dw_disable(dev);
 	free_irq(dev->irq, dev);
 	kfree(dev);
 
-- 
1.7.3.4

