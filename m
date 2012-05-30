Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2E3Rql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:46:41 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:35166 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab2E3Rqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:46:38 -0400
Date: Wed, 30 May 2012 19:45:55 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH RFC 2/3] i2c-nomadik: turn the platform driver to an amba
 driver
Message-ID: <349645b61d0b28f6e84f7ae1f2c8c28e12a11d92.1338398567.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1338398567.git.rubini@gnudd.com>
In-Reply-To: <cover.1338398567.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-nomadik gateware is really a PrimeCell APB device. By hosting
the driver under the amba bus we can access it more easily, for
example using the generic pci-amba driver. The patch also fixes the
mach-ux500 users to register an AMBA device, not a platform device.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: STEricsson_nomadik_linux@list.st.com
Cc: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-common.h |   21 +-----
 drivers/i2c/busses/i2c-nomadik.c     |  137 +++++++++++++++++-----------------
 2 files changed, 71 insertions(+), 87 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 50d1292..d73fed5 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -56,27 +56,12 @@ dbx500_add_uart(struct device *parent, const char *name, resource_size_t base,
 
 struct nmk_i2c_controller;
 
-static inline struct platform_device *
+static inline struct amba_device *
 dbx500_add_i2c(struct device *parent, int id, resource_size_t base, int irq,
 	       struct nmk_i2c_controller *data)
 {
-	struct resource res[] = {
-		DEFINE_RES_MEM(base, SZ_4K),
-		DEFINE_RES_IRQ(irq),
-	};
-
-	struct platform_device_info pdevinfo = {
-		.parent = parent,
-		.name = "nmk-i2c",
-		.id = id,
-		.res = res,
-		.num_res = ARRAY_SIZE(res),
-		.data = data,
-		.size_data = sizeof(*data),
-		.dma_mask = DMA_BIT_MASK(32),
-	};
-
-	return platform_device_register_full(&pdevinfo);
+	return amba_apb_device_add(parent, "nmk-i2c", base, SZ_4K, irq, 0,
+				   data, 0);
 }
 
 static inline struct amba_device *
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 09b7589..292e72c 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -14,7 +14,7 @@
  */
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
+#include <linux/amba/bus.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
@@ -135,7 +135,7 @@ struct i2c_nmk_client {
 
 /**
  * struct nmk_i2c_dev - private data structure of the controller.
- * @pdev: parent platform device.
+ * @adev: parent amba device.
  * @adap: corresponding I2C adapter.
  * @irq: interrupt line for the controller.
  * @virtbase: virtual io memory area.
@@ -149,7 +149,7 @@ struct i2c_nmk_client {
  * @busy: Busy doing transfer.
  */
 struct nmk_i2c_dev {
-	struct platform_device		*pdev;
+	struct amba_device		*adev;
 	struct i2c_adapter		adap;
 	int				irq;
 	void __iomem			*virtbase;
@@ -216,7 +216,7 @@ static int flush_i2c_fifo(struct nmk_i2c_dev *dev)
 		}
 	}
 
-	dev_err(&dev->pdev->dev,
+	dev_err(&dev->adev->dev,
 		"flushing operation timed out giving up after %d attempts",
 		LOOP_ATTEMPTS);
 
@@ -363,7 +363,7 @@ static void setup_i2c_controller(struct nmk_i2c_dev *dev)
 	 * and high speed (up to 3.4 Mb/s)
 	 */
 	if (dev->cfg.sm > I2C_FREQ_MODE_FAST) {
-		dev_err(&dev->pdev->dev,
+		dev_err(&dev->adev->dev,
 			"do not support this mode defaulting to std. mode\n");
 		brcr2 = i2c_clk/(100000 * 2) & 0xffff;
 		writel((brcr1 | brcr2), dev->virtbase + I2C_BRCR);
@@ -422,7 +422,7 @@ static int read_i2c(struct nmk_i2c_dev *dev)
 		&dev->xfer_complete, dev->adap.timeout);
 
 	if (timeout < 0) {
-		dev_err(&dev->pdev->dev,
+		dev_err(&dev->adev->dev,
 			"wait_for_completion_timeout "
 			"returned %d waiting for event\n", timeout);
 		status = timeout;
@@ -430,7 +430,7 @@ static int read_i2c(struct nmk_i2c_dev *dev)
 
 	if (timeout == 0) {
 		/* Controller timed out */
-		dev_err(&dev->pdev->dev, "read from slave 0x%x timed out\n",
+		dev_err(&dev->adev->dev, "read from slave 0x%x timed out\n",
 				dev->cli.slave_adr);
 		status = -ETIMEDOUT;
 	}
@@ -509,7 +509,7 @@ static int write_i2c(struct nmk_i2c_dev *dev)
 		&dev->xfer_complete, dev->adap.timeout);
 
 	if (timeout < 0) {
-		dev_err(&dev->pdev->dev,
+		dev_err(&dev->adev->dev,
 			"wait_for_completion_timeout "
 			"returned %d waiting for event\n", timeout);
 		status = timeout;
@@ -517,7 +517,7 @@ static int write_i2c(struct nmk_i2c_dev *dev)
 
 	if (timeout == 0) {
 		/* Controller timed out */
-		dev_err(&dev->pdev->dev, "write to slave 0x%x timed out\n",
+		dev_err(&dev->adev->dev, "write to slave 0x%x timed out\n",
 				dev->cli.slave_adr);
 		status = -ETIMEDOUT;
 	}
@@ -556,7 +556,7 @@ static int nmk_i2c_xfer_one(struct nmk_i2c_dev *dev, u16 flags)
 		if (((i2c_sr >> 2) & 0x3) == 0x3) {
 			/* get the abort cause */
 			cause =	(i2c_sr >> 4) & 0x7;
-			dev_err(&dev->pdev->dev, "%s\n",
+			dev_err(&dev->adev->dev, "%s\n",
 				cause >= ARRAY_SIZE(abort_causes) ?
 				"unknown reason" :
 				abort_causes[cause]);
@@ -629,7 +629,7 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 	if (dev->regulator)
 		regulator_enable(dev->regulator);
-	pm_runtime_get_sync(&dev->pdev->dev);
+	pm_runtime_get_sync(&dev->adev->dev);
 
 	clk_enable(dev->clk);
 
@@ -644,7 +644,7 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 		for (i = 0; i < num_msgs; i++) {
 			if (unlikely(msgs[i].flags & I2C_M_TEN)) {
-				dev_err(&dev->pdev->dev,
+				dev_err(&dev->adev->dev,
 					"10 bit addressing not supported\n");
 
 				status = -EINVAL;
@@ -666,7 +666,7 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 out:
 	clk_disable(dev->clk);
-	pm_runtime_put_sync(&dev->pdev->dev);
+	pm_runtime_put_sync(&dev->adev->dev);
 	if (dev->regulator)
 		regulator_disable(dev->regulator);
 
@@ -789,7 +789,7 @@ static irqreturn_t i2c_irq_handler(int irq, void *arg)
 
 		if (dev->cli.count) {
 			dev->result = -EIO;
-			dev_err(&dev->pdev->dev,
+			dev_err(&dev->adev->dev,
 				"%lu bytes still remain to be xfered\n",
 				dev->cli.count);
 			(void) init_hw(dev);
@@ -833,7 +833,7 @@ static irqreturn_t i2c_irq_handler(int irq, void *arg)
 		dev->result = -EIO;
 		(void) init_hw(dev);
 
-		dev_err(&dev->pdev->dev, "Tx Fifo Over run\n");
+		dev_err(&dev->adev->dev, "Tx Fifo Over run\n");
 		complete(&dev->xfer_complete);
 
 		break;
@@ -846,10 +846,10 @@ static irqreturn_t i2c_irq_handler(int irq, void *arg)
 	case I2C_IT_RFSE:
 	case I2C_IT_WTSR:
 	case I2C_IT_STD:
-		dev_err(&dev->pdev->dev, "unhandled Interrupt\n");
+		dev_err(&dev->adev->dev, "unhandled Interrupt\n");
 		break;
 	default:
-		dev_err(&dev->pdev->dev, "spurious Interrupt..\n");
+		dev_err(&dev->adev->dev, "spurious Interrupt..\n");
 		break;
 	}
 
@@ -860,8 +860,8 @@ static irqreturn_t i2c_irq_handler(int irq, void *arg)
 #ifdef CONFIG_PM
 static int nmk_i2c_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct nmk_i2c_dev *nmk_i2c = platform_get_drvdata(pdev);
+	struct amba_device *adev = to_amba_device(dev);
+	struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
 
 	if (nmk_i2c->busy)
 		return -EBUSY;
@@ -898,79 +898,67 @@ static const struct i2c_algorithm nmk_i2c_algo = {
 	.functionality	= nmk_i2c_functionality
 };
 
-static int __devinit nmk_i2c_probe(struct platform_device *pdev)
+static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 {
 	int ret = 0;
-	struct resource *res;
 	struct nmk_i2c_controller *pdata =
-			pdev->dev.platform_data;
+			adev->dev.platform_data;
 	struct nmk_i2c_dev	*dev;
 	struct i2c_adapter *adap;
 
+	if (!pdata) {
+		dev_warn(&adev->dev, "no platform data\n");
+		return -ENODEV;
+	}
 	dev = kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
 	if (!dev) {
-		dev_err(&pdev->dev, "cannot allocate memory\n");
+		dev_err(&adev->dev, "cannot allocate memory\n");
 		ret = -ENOMEM;
 		goto err_no_mem;
 	}
 	dev->busy = false;
-	dev->pdev = pdev;
-	platform_set_drvdata(pdev, dev);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENOENT;
-		goto err_no_resource;
-	}
+	dev->adev = adev;
+	amba_set_drvdata(adev, dev);
 
-	if (request_mem_region(res->start, resource_size(res),
-		DRIVER_NAME "I/O region") == NULL) {
-		ret = -EBUSY;
-		goto err_no_region;
-	}
-
-	dev->virtbase = ioremap(res->start, resource_size(res));
+	dev->virtbase = ioremap(adev->res.start, resource_size(&adev->res));
 	if (!dev->virtbase) {
 		ret = -ENOMEM;
 		goto err_no_ioremap;
 	}
 
-	dev->irq = platform_get_irq(pdev, 0);
+	dev->irq = adev->irq[0];
 	ret = request_irq(dev->irq, i2c_irq_handler, 0,
 				DRIVER_NAME, dev);
 	if (ret) {
-		dev_err(&pdev->dev, "cannot claim the irq %d\n", dev->irq);
+		dev_err(&adev->dev, "cannot claim the irq %d\n", dev->irq);
 		goto err_irq;
 	}
 
-	dev->regulator = regulator_get(&pdev->dev, "v-i2c");
+	dev->regulator = regulator_get(&adev->dev, "v-i2c");
 	if (IS_ERR(dev->regulator)) {
-		dev_warn(&pdev->dev, "could not get i2c regulator\n");
+		dev_warn(&adev->dev, "could not get i2c regulator\n");
 		dev->regulator = NULL;
 	}
 
-	pm_suspend_ignore_children(&pdev->dev, true);
-	pm_runtime_enable(&pdev->dev);
+	pm_suspend_ignore_children(&adev->dev, true);
+	pm_runtime_enable(&adev->dev);
 
-	dev->clk = clk_get(&pdev->dev, NULL);
+	dev->clk = clk_get(&adev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
-		dev_err(&pdev->dev, "could not get i2c clock\n");
+		dev_err(&adev->dev, "could not get i2c clock\n");
 		ret = PTR_ERR(dev->clk);
 		goto err_no_clk;
 	}
 
 	adap = &dev->adap;
-	adap->dev.parent = &pdev->dev;
+	adap->dev.parent = &adev->dev;
 	adap->owner	= THIS_MODULE;
 	adap->class	= I2C_CLASS_HWMON | I2C_CLASS_SPD;
 	adap->algo	= &nmk_i2c_algo;
 	adap->timeout	= pdata->timeout ? msecs_to_jiffies(pdata->timeout) :
 		msecs_to_jiffies(20000);
 	snprintf(adap->name, sizeof(adap->name),
-		 "Nomadik I2C%d at %lx", pdev->id, (unsigned long)res->start);
-
-	/* fetch the controller id */
-	adap->nr	= pdev->id;
+		 "Nomadik I2C%d at %pR", adap->nr, &adev->res);
 
 	/* fetch the controller configuration from machine */
 	dev->cfg.clk_freq = pdata->clk_freq;
@@ -981,13 +969,13 @@ static int __devinit nmk_i2c_probe(struct platform_device *pdev)
 
 	i2c_set_adapdata(adap, dev);
 
-	dev_info(&pdev->dev,
+	dev_info(&adev->dev,
 		 "initialize %s on virtual base %p\n",
 		 adap->name, dev->virtbase);
 
 	ret = i2c_add_numbered_adapter(adap);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to add adapter\n");
+		dev_err(&adev->dev, "failed to add adapter\n");
 		goto err_add_adap;
 	}
 
@@ -998,25 +986,22 @@ static int __devinit nmk_i2c_probe(struct platform_device *pdev)
  err_no_clk:
 	if (dev->regulator)
 		regulator_put(dev->regulator);
-	pm_runtime_disable(&pdev->dev);
+	pm_runtime_disable(&adev->dev);
 	free_irq(dev->irq, dev);
  err_irq:
 	iounmap(dev->virtbase);
  err_no_ioremap:
-	release_mem_region(res->start, resource_size(res));
- err_no_region:
-	platform_set_drvdata(pdev, NULL);
- err_no_resource:
+	amba_set_drvdata(adev, NULL);
 	kfree(dev);
  err_no_mem:
 
 	return ret;
 }
 
-static int __devexit nmk_i2c_remove(struct platform_device *pdev)
+static int nmk_i2c_remove(struct amba_device *adev)
 {
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	struct nmk_i2c_dev *dev = platform_get_drvdata(pdev);
+	struct resource *res = &adev->res;
+	struct nmk_i2c_dev *dev = amba_get_drvdata(adev);
 
 	i2c_del_adapter(&dev->adap);
 	flush_i2c_fifo(dev);
@@ -1031,31 +1016,46 @@ static int __devexit nmk_i2c_remove(struct platform_device *pdev)
 	clk_put(dev->clk);
 	if (dev->regulator)
 		regulator_put(dev->regulator);
-	pm_runtime_disable(&pdev->dev);
-	platform_set_drvdata(pdev, NULL);
+	pm_runtime_disable(&adev->dev);
+	amba_set_drvdata(adev, NULL);
 	kfree(dev);
 
 	return 0;
 }
 
-static struct platform_driver nmk_i2c_driver = {
-	.driver = {
+static struct amba_id nmk_i2c_ids[] = {
+	{
+		.id	= 0x00018024,
+		.mask	= 0x00ffffff,
+	},
+	{
+		.id	= 0x00380024,
+		.mask	= 0x00ffffff,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(amba, nmk_i2c_ids);
+
+static struct amba_driver nmk_i2c_driver = {
+	.drv = {
 		.owner = THIS_MODULE,
 		.name = DRIVER_NAME,
 		.pm = &nmk_i2c_pm,
 	},
+	.id_table = nmk_i2c_ids,
 	.probe = nmk_i2c_probe,
-	.remove = __devexit_p(nmk_i2c_remove),
+	.remove = nmk_i2c_remove,
 };
 
 static int __init nmk_i2c_init(void)
 {
-	return platform_driver_register(&nmk_i2c_driver);
+	return amba_driver_register(&nmk_i2c_driver);
 }
 
 static void __exit nmk_i2c_exit(void)
 {
-	platform_driver_unregister(&nmk_i2c_driver);
+	amba_driver_unregister(&nmk_i2c_driver);
 }
 
 subsys_initcall(nmk_i2c_init);
@@ -1064,4 +1064,3 @@ module_exit(nmk_i2c_exit);
 MODULE_AUTHOR("Sachin Verma, Srinidhi KASAGAR");
 MODULE_DESCRIPTION("Nomadik/Ux500 I2C driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.7.7.2
