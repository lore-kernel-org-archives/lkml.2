Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1CLU0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:26:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42964 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab1CLUXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:23:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SOy7em68oeVyp3zOVnKLgSczGqCNl0nkRIELjaL0ZDOUIgvPChywuznXLcOXDt+Tv2
         u5xutP+cX03My0Qn+5qCMJ9wJRP25jMlw/HgCmqn7/ZJ/qdtwg89S5VRb4Cj2bWu3Wi/
         47FF5zpAzaCQGcJ9Icpw8tkRSlxY0BCjA6l0Q=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 05/13] i2c-designware: split of i2c-designware.c into core and bus specific parts
Date: Sat, 12 Mar 2011 12:23:19 -0800
Message-Id: <1299961407-26852-6-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
References: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch splits i2c-designware.c into three pieces:
     i2c-designware-core.c, contains the code that interacts directly
     with the core.

     i2c-designware-platdrv.c, contains the code specific to the
     platform driver using the core.

     i2c-designware-core.h contains the definitions and declareations
     shared by i2c-designware-core.c and i2c-designware-platdrv.c.

This patch is the first in a set to allow multiple instances of the
designware I2C core in the system.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/i2c/busses/Kconfig                         |    6 +-
 drivers/i2c/busses/Makefile                        |    3 +-
 .../{i2c-designware.c => i2c-designware-core.c}    |  353 +-------------------
 drivers/i2c/busses/i2c-designware-core.h           |  194 +++++++++++
 drivers/i2c/busses/i2c-designware-platdrv.c        |  199 +++++++++++
 5 files changed, 412 insertions(+), 343 deletions(-)
 rename drivers/i2c/busses/{i2c-designware.c => i2c-designware-core.c} (60%)
 create mode 100644 drivers/i2c/busses/i2c-designware-core.h
 create mode 100644 drivers/i2c/busses/i2c-designware-platdrv.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 113505a..35b5e6b 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -347,15 +347,15 @@ config I2C_DAVINCI
 	  devices such as DaVinci NIC.
 	  For details please see http://www.ti.com/davinci
 
-config I2C_DESIGNWARE
-	tristate "Synopsys DesignWare"
+config I2C_DESIGNWARE_PLATFORM
+	tristate "Synopsys DesignWare Platfrom"
 	depends on HAVE_CLK
 	help
 	  If you say yes to this option, support will be included for the
 	  Synopsys DesignWare I2C adapter. Only master mode is supported.
 
 	  This driver can also be built as a module.  If so, the module
-	  will be called i2c-designware.
+	  will be called i2c-designware-platform.
 
 config I2C_GPIO
 	tristate "GPIO-based bitbanging I2C"
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 9d2d0ec..effbcc7 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -33,7 +33,8 @@ obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
 obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bfin-twi.o
 obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
 obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
-obj-$(CONFIG_I2C_DESIGNWARE)	+= i2c-designware.o
+obj-$(CONFIG_I2C_DESIGNWARE_PLATFORM)	+= i2c-designware-platform.o
+i2c-designware-platform-objs := i2c-designware-platdrv.o i2c-designware-core.o
 obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
 obj-$(CONFIG_I2C_HIGHLANDER)	+= i2c-highlander.o
 obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware-core.c
similarity index 60%
rename from drivers/i2c/busses/i2c-designware.c
rename to drivers/i2c/busses/i2c-designware-core.c
index 85517c5..432bfdd 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -25,127 +25,13 @@
  * ----------------------------------------------------------------------------
  *
  */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/i2c.h>
 #include <linux/clk.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/err.h>
+#include <linux/i2c.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/slab.h>
-#include <linux/swab.h>
-
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
-#define DW_IC_COMP_PARAM_1	0xf4
-#define DW_IC_COMP_TYPE		0xfc
-#define DW_IC_TX_ABRT_SOURCE	0x80
-
-#define DW_IC_CON_MASTER		0x1
-#define DW_IC_CON_SPEED_STD		0x2
-#define DW_IC_CON_SPEED_FAST		0x4
-#define DW_IC_CON_10BITADDR_MASTER	0x10
-#define DW_IC_CON_RESTART_EN		0x20
-#define DW_IC_CON_SLAVE_DISABLE		0x40
-
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
-
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
+#include "i2c-designware-core.h"
 
 static char *abort_sources[] = {
 	[ABRT_7B_ADDR_NOACK] =
@@ -172,59 +58,7 @@ static char *abort_sources[] = {
 		"lost arbitration",
 };
 
-/**
- * struct dw_i2c_dev - private i2c-designware data
- * @dev: driver model device node
- * @base: IO registers pointer
- * @cmd_complete: tx completion indicator
- * @lock: protect this struct and IO registers
- * @clk: input reference clock
- * @cmd_err: run time hadware error code
- * @msgs: points to an array of messages currently being transfered
- * @msgs_num: the number of elements in msgs
- * @msg_write_idx: the element index of the current tx message in the msgs
- *	array
- * @tx_buf_len: the length of the current tx buffer
- * @tx_buf: the current tx buffer
- * @msg_read_idx: the element index of the current rx message in the msgs
- *	array
- * @rx_buf_len: the length of the current rx buffer
- * @rx_buf: the current rx buffer
- * @msg_err: error status of the current transfer
- * @status: i2c master status, one of STATUS_*
- * @abort_source: copy of the TX_ABRT_SOURCE register
- * @irq: interrupt number for the i2c master
- * @swab: true if the instantiated IP is of different endianess
- * @adapter: i2c subsystem adapter node
- * @tx_fifo_depth: depth of the hardware tx fifo
- * @rx_fifo_depth: depth of the hardware rx fifo
- */
-struct dw_i2c_dev {
-	struct device		*dev;
-	void __iomem		*base;
-	struct completion	cmd_complete;
-	struct mutex		lock;
-	struct clk		*clk;
-	int			cmd_err;
-	struct i2c_msg		*msgs;
-	int			msgs_num;
-	int			msg_write_idx;
-	u32			tx_buf_len;
-	u8			*tx_buf;
-	int			msg_read_idx;
-	u32			rx_buf_len;
-	u8			*rx_buf;
-	int			msg_err;
-	unsigned int		status;
-	u32			abort_source;
-	int			irq;
-	int			swab;
-	struct i2c_adapter	adapter;
-	unsigned int		tx_fifo_depth;
-	unsigned int		rx_fifo_depth;
-};
-
-static u32 dw_readl(struct dw_i2c_dev *dev, int offset)
+u32 dw_readl(struct dw_i2c_dev *dev, int offset)
 {
 	u32 value = readl(dev->base + offset);
 
@@ -234,7 +68,7 @@ static u32 dw_readl(struct dw_i2c_dev *dev, int offset)
 		return value;
 }
 
-static void dw_writel(struct dw_i2c_dev *dev, u32 b, int offset)
+void dw_writel(struct dw_i2c_dev *dev, u32 b, int offset)
 {
 	if (dev->swab)
 		b = swab32(b);
@@ -305,7 +139,7 @@ static u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
  * This function is called during I2C init function, and in case of timeout at
  * run time.
  */
-static int i2c_dw_init(struct dw_i2c_dev *dev)
+int i2c_dw_init(struct dw_i2c_dev *dev)
 {
 	u32 input_clock_khz = clk_get_rate(dev->clk) / 1000;
 	u32 ic_con, hcnt, lcnt;
@@ -419,7 +253,7 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
  * messages into the tx buffer.  Even if the size of i2c_msg data is
  * longer than the size of the tx buffer, it handles everything.
  */
-static void
+void
 i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 {
 	struct i2c_msg *msgs = dev->msgs;
@@ -427,7 +261,7 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 	int tx_limit, rx_limit;
 	u32 addr = msgs[dev->msg_write_idx].addr;
 	u32 buf_len = dev->tx_buf_len;
-	u8 *buf = dev->tx_buf;;
+	u8 *buf = dev->tx_buf;
 
 	intr_mask = DW_IC_INTR_DEFAULT_MASK;
 
@@ -490,7 +324,7 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 	if (dev->msg_err)
 		intr_mask = 0;
 
-	dw_writel(dev, intr_mask, DW_IC_INTR_MASK);
+	dw_writel(dev, intr_mask,  DW_IC_INTR_MASK);
 }
 
 static void
@@ -555,7 +389,7 @@ static int i2c_dw_handle_tx_abort(struct dw_i2c_dev *dev)
 /*
  * Prepare controller for a transaction and call i2c_dw_xfer_msg
  */
-static int
+int
 i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 {
 	struct dw_i2c_dev *dev = i2c_get_adapdata(adap);
@@ -618,7 +452,7 @@ done:
 	return ret;
 }
 
-static u32 i2c_dw_func(struct i2c_adapter *adap)
+u32 i2c_dw_func(struct i2c_adapter *adap)
 {
 	return	I2C_FUNC_I2C |
 		I2C_FUNC_10BIT_ADDR |
@@ -638,9 +472,9 @@ static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
 	 * in the IC_RAW_INTR_STAT register.
 	 *
 	 * That is,
-	 *   stat = readl(IC_INTR_STAT);
+	 *   stat = dw_readl(IC_INTR_STAT);
 	 * equals to,
-	 *   stat = readl(IC_RAW_INTR_STAT) & readl(IC_INTR_MASK);
+	 *   stat = dw_readl(IC_RAW_INTR_STAT) & dw_readl(IC_INTR_MASK);
 	 *
 	 * The raw version might be useful for debugging purposes.
 	 */
@@ -649,7 +483,7 @@ static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
 	/*
 	 * Do not use the IC_CLR_INTR register to clear interrupts, or
 	 * you'll miss some interrupts, triggered during the period from
-	 * readl(IC_INTR_STAT) to readl(IC_CLR_INTR).
+	 * dw_readl(IC_INTR_STAT) to dw_readl(IC_CLR_INTR).
 	 *
 	 * Instead, use the separately-prepared IC_CLR_* registers.
 	 */
@@ -687,7 +521,7 @@ static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
  * Interrupt service routine. This gets called whenever an I2C interrupt
  * occurs.
  */
-static irqreturn_t i2c_dw_isr(int this_irq, void *dev_id)
+irqreturn_t i2c_dw_isr(int this_irq, void *dev_id)
 {
 	struct dw_i2c_dev *dev = dev_id;
 	u32 stat;
@@ -726,162 +560,3 @@ tx_aborted:
 	return IRQ_HANDLED;
 }
 
-static struct i2c_algorithm i2c_dw_algo = {
-	.master_xfer	= i2c_dw_xfer,
-	.functionality	= i2c_dw_func,
-};
-
-static int __devinit dw_i2c_probe(struct platform_device *pdev)
-{
-	struct dw_i2c_dev *dev;
-	struct i2c_adapter *adap;
-	struct resource *mem, *ioarea;
-	int irq, r;
-	u32 reg;
-
-	/* NOTE: driver uses the static register mapping */
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "no mem resource?\n");
-		return -EINVAL;
-	}
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "no irq resource?\n");
-		return irq; /* -ENXIO */
-	}
-
-	ioarea = request_mem_region(mem->start, resource_size(mem),
-			pdev->name);
-	if (!ioarea) {
-		dev_err(&pdev->dev, "I2C region already claimed\n");
-		return -EBUSY;
-	}
-
-	dev = kzalloc(sizeof(struct dw_i2c_dev), GFP_KERNEL);
-	if (!dev) {
-		r = -ENOMEM;
-		goto err_release_region;
-	}
-
-	init_completion(&dev->cmd_complete);
-	mutex_init(&dev->lock);
-	dev->dev = get_device(&pdev->dev);
-	dev->irq = irq;
-	platform_set_drvdata(pdev, dev);
-
-	dev->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(dev->clk)) {
-		r = -ENODEV;
-		goto err_free_mem;
-	}
-	clk_enable(dev->clk);
-
-	dev->base = ioremap(mem->start, resource_size(mem));
-	if (dev->base == NULL) {
-		dev_err(&pdev->dev, "failure mapping io resources\n");
-		r = -EBUSY;
-		goto err_unuse_clocks;
-	}
-
-	r = i2c_dw_init(dev);
-	if (r)
-		goto err_unuse_clocks;
-
-	reg = dw_readl(dev, DW_IC_COMP_PARAM_1);
-	dev->tx_fifo_depth = ((reg >> 16) & 0xff) + 1;
-	dev->rx_fifo_depth = ((reg >> 8)  & 0xff) + 1;
-
-
-	dw_writel(dev, 0, DW_IC_INTR_MASK); /* disable IRQ */
-	r = request_irq(dev->irq, i2c_dw_isr, IRQF_DISABLED, pdev->name, dev);
-	if (r) {
-		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
-		goto err_iounmap;
-	}
-
-	adap = &dev->adapter;
-	i2c_set_adapdata(adap, dev);
-	adap->owner = THIS_MODULE;
-	adap->class = I2C_CLASS_HWMON;
-	strlcpy(adap->name, "Synopsys DesignWare I2C adapter",
-			sizeof(adap->name));
-	adap->algo = &i2c_dw_algo;
-	adap->dev.parent = &pdev->dev;
-
-	adap->nr = pdev->id;
-	r = i2c_add_numbered_adapter(adap);
-	if (r) {
-		dev_err(&pdev->dev, "failure adding adapter\n");
-		goto err_free_irq;
-	}
-
-	return 0;
-
-err_free_irq:
-	free_irq(dev->irq, dev);
-err_iounmap:
-	iounmap(dev->base);
-err_unuse_clocks:
-	clk_disable(dev->clk);
-	clk_put(dev->clk);
-	dev->clk = NULL;
-err_free_mem:
-	platform_set_drvdata(pdev, NULL);
-	put_device(&pdev->dev);
-	kfree(dev);
-err_release_region:
-	release_mem_region(mem->start, resource_size(mem));
-
-	return r;
-}
-
-static int __devexit dw_i2c_remove(struct platform_device *pdev)
-{
-	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
-	struct resource *mem;
-
-	platform_set_drvdata(pdev, NULL);
-	i2c_del_adapter(&dev->adapter);
-	put_device(&pdev->dev);
-
-	clk_disable(dev->clk);
-	clk_put(dev->clk);
-	dev->clk = NULL;
-
-	dw_writel(dev, 0, DW_IC_ENABLE);
-	free_irq(dev->irq, dev);
-	kfree(dev);
-
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
-	return 0;
-}
-
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:i2c_designware");
-
-static struct platform_driver dw_i2c_driver = {
-	.remove		= __devexit_p(dw_i2c_remove),
-	.driver		= {
-		.name	= "i2c_designware",
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init dw_i2c_init_driver(void)
-{
-	return platform_driver_probe(&dw_i2c_driver, dw_i2c_probe);
-}
-module_init(dw_i2c_init_driver);
-
-static void __exit dw_i2c_exit_driver(void)
-{
-	platform_driver_unregister(&dw_i2c_driver);
-}
-module_exit(dw_i2c_exit_driver);
-
-MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
-MODULE_DESCRIPTION("Synopsys DesignWare I2C bus adapter");
-MODULE_LICENSE("GPL");
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
new file mode 100644
index 0000000..4e37031
--- /dev/null
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -0,0 +1,194 @@
+/*
+ * Synopsys DesignWare I2C adapter driver (master only).
+ *
+ * Based on the TI DAVINCI I2C adapter driver.
+ *
+ * Copyright (C) 2006 Texas Instruments.
+ * Copyright (C) 2007 MontaVista Software Inc.
+ * Copyright (C) 2009 Provigent Ltd.
+ *
+ * ----------------------------------------------------------------------------
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * ----------------------------------------------------------------------------
+ *
+ */
+
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
+#define DW_IC_CON_MASTER		0x1
+#define DW_IC_CON_SPEED_STD		0x2
+#define DW_IC_CON_SPEED_FAST		0x4
+#define DW_IC_CON_10BITADDR_MASTER	0x10
+#define DW_IC_CON_RESTART_EN		0x20
+#define DW_IC_CON_SLAVE_DISABLE		0x40
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
+/**
+ * struct dw_i2c_dev - private i2c-designware data
+ * @dev: driver model device node
+ * @base: IO registers pointer
+ * @cmd_complete: tx completion indicator
+ * @lock: protect this struct and IO registers
+ * @clk: input reference clock
+ * @cmd_err: run time hadware error code
+ * @msgs: points to an array of messages currently being transfered
+ * @msgs_num: the number of elements in msgs
+ * @msg_write_idx: the element index of the current tx message in the msgs
+ *	array
+ * @tx_buf_len: the length of the current tx buffer
+ * @tx_buf: the current tx buffer
+ * @msg_read_idx: the element index of the current rx message in the msgs
+ *	array
+ * @rx_buf_len: the length of the current rx buffer
+ * @rx_buf: the current rx buffer
+ * @msg_err: error status of the current transfer
+ * @status: i2c master status, one of STATUS_*
+ * @abort_source: copy of the TX_ABRT_SOURCE register
+ * @irq: interrupt number for the i2c master
+ * @adapter: i2c subsystem adapter node
+ * @tx_fifo_depth: depth of the hardware tx fifo
+ * @rx_fifo_depth: depth of the hardware rx fifo
+ */
+struct dw_i2c_dev {
+	struct device		*dev;
+	void __iomem		*base;
+	struct completion	cmd_complete;
+	struct mutex		lock;
+	struct clk		*clk;
+	int			cmd_err;
+	struct i2c_msg		*msgs;
+	int			msgs_num;
+	int			msg_write_idx;
+	u32			tx_buf_len;
+	u8			*tx_buf;
+	int			msg_read_idx;
+	u32			rx_buf_len;
+	u8			*rx_buf;
+	int			msg_err;
+	unsigned int		status;
+	u32			abort_source;
+	int			irq;
+	int			swab;
+	struct i2c_adapter	adapter;
+	unsigned int		tx_fifo_depth;
+	unsigned int		rx_fifo_depth;
+};
+
+extern u32 dw_readl(struct dw_i2c_dev *dev, int offset);
+extern void dw_writel(struct dw_i2c_dev *dev, u32 b, int offset);
+extern int i2c_dw_init(struct dw_i2c_dev *dev);
+extern int i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
+		int num);
+extern u32 i2c_dw_func(struct i2c_adapter *adap);
+extern irqreturn_t i2c_dw_isr(int this_irq, void *dev_id);
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
new file mode 100644
index 0000000..9d10ae8
--- /dev/null
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -0,0 +1,199 @@
+/*
+ * Synopsys DesignWare I2C adapter driver (master only).
+ *
+ * Based on the TI DAVINCI I2C adapter driver.
+ *
+ * Copyright (C) 2006 Texas Instruments.
+ * Copyright (C) 2007 MontaVista Software Inc.
+ * Copyright (C) 2009 Provigent Ltd.
+ *
+ * ----------------------------------------------------------------------------
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * ----------------------------------------------------------------------------
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/clk.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include "i2c-designware-core.h"
+
+static struct i2c_algorithm i2c_dw_algo = {
+	.master_xfer	= i2c_dw_xfer,
+	.functionality	= i2c_dw_func,
+};
+
+static int __devinit dw_i2c_probe(struct platform_device *pdev)
+{
+	struct dw_i2c_dev *dev;
+	struct i2c_adapter *adap;
+	struct resource *mem, *ioarea;
+	int irq, r;
+
+	/* NOTE: driver uses the static register mapping */
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "no mem resource?\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no irq resource?\n");
+		return irq; /* -ENXIO */
+	}
+
+	ioarea = request_mem_region(mem->start, resource_size(mem),
+			pdev->name);
+	if (!ioarea) {
+		dev_err(&pdev->dev, "I2C region already claimed\n");
+		return -EBUSY;
+	}
+
+	dev = kzalloc(sizeof(struct dw_i2c_dev), GFP_KERNEL);
+	if (!dev) {
+		r = -ENOMEM;
+		goto err_release_region;
+	}
+
+	init_completion(&dev->cmd_complete);
+	mutex_init(&dev->lock);
+	dev->dev = get_device(&pdev->dev);
+	dev->irq = irq;
+	platform_set_drvdata(pdev, dev);
+
+	dev->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dev->clk)) {
+		r = -ENODEV;
+		goto err_free_mem;
+	}
+	clk_enable(dev->clk);
+
+	dev->base = ioremap(mem->start, resource_size(mem));
+	if (dev->base == NULL) {
+		dev_err(&pdev->dev, "failure mapping io resources\n");
+		r = -EBUSY;
+		goto err_unuse_clocks;
+	}
+	{
+		u32 param1 = dw_readl(dev, DW_IC_COMP_PARAM_1);
+
+		dev->tx_fifo_depth = ((param1 >> 16) & 0xff) + 1;
+		dev->rx_fifo_depth = ((param1 >> 8)  & 0xff) + 1;
+	}
+	r = i2c_dw_init(dev);
+	if (r)
+		goto err_iounmap;
+
+	dw_writel(dev, 0, DW_IC_INTR_MASK); /* disable IRQ */
+	r = request_irq(dev->irq, i2c_dw_isr, IRQF_DISABLED, pdev->name, dev);
+	if (r) {
+		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
+		goto err_iounmap;
+	}
+
+	adap = &dev->adapter;
+	i2c_set_adapdata(adap, dev);
+	adap->owner = THIS_MODULE;
+	adap->class = I2C_CLASS_HWMON;
+	strlcpy(adap->name, "Synopsys DesignWare I2C adapter",
+			sizeof(adap->name));
+	adap->algo = &i2c_dw_algo;
+	adap->dev.parent = &pdev->dev;
+
+	adap->nr = pdev->id;
+	r = i2c_add_numbered_adapter(adap);
+	if (r) {
+		dev_err(&pdev->dev, "failure adding adapter\n");
+		goto err_free_irq;
+	}
+
+	return 0;
+
+err_free_irq:
+	free_irq(dev->irq, dev);
+err_iounmap:
+	iounmap(dev->base);
+err_unuse_clocks:
+	clk_disable(dev->clk);
+	clk_put(dev->clk);
+	dev->clk = NULL;
+err_free_mem:
+	platform_set_drvdata(pdev, NULL);
+	put_device(&pdev->dev);
+	kfree(dev);
+err_release_region:
+	release_mem_region(mem->start, resource_size(mem));
+
+	return r;
+}
+
+static int __devexit dw_i2c_remove(struct platform_device *pdev)
+{
+	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
+	struct resource *mem;
+
+	platform_set_drvdata(pdev, NULL);
+	i2c_del_adapter(&dev->adapter);
+	put_device(&pdev->dev);
+
+	clk_disable(dev->clk);
+	clk_put(dev->clk);
+	dev->clk = NULL;
+
+	dw_writel(dev, 0, DW_IC_ENABLE);
+	free_irq(dev->irq, dev);
+	kfree(dev);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(mem->start, resource_size(mem));
+	return 0;
+}
+
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:i2c_designware");
+
+static struct platform_driver dw_i2c_driver = {
+	.remove		= __devexit_p(dw_i2c_remove),
+	.driver		= {
+		.name	= "i2c_designware",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init dw_i2c_init_driver(void)
+{
+	return platform_driver_probe(&dw_i2c_driver, dw_i2c_probe);
+}
+module_init(dw_i2c_init_driver);
+
+static void __exit dw_i2c_exit_driver(void)
+{
+	platform_driver_unregister(&dw_i2c_driver);
+}
+module_exit(dw_i2c_exit_driver);
+
+MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
+MODULE_DESCRIPTION("Synopsys DesignWare I2C bus adapter");
+MODULE_LICENSE("GPL");
-- 
1.7.3.4

