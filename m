Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031421Ab2I1Thx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:37:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38829 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031394Ab2I1Thr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:37:47 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sekhar Nori <nsekhar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v2 2/7] uio: uio_pruss: add support for am33xx
Date: Fri, 28 Sep 2012 15:37:47 -0400
Message-Id: <1348861072-14507-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348861072-14507-1-git-send-email-mporter@ti.com>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds DT, pinctrl, and runtime PM support to enable AM33xx.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/uio/Kconfig     |    4 +--
 drivers/uio/uio_pruss.c |   90 +++++++++++++++++++++++++++++++++++++----------
 2 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index c48b938..5db1f34 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -96,10 +96,10 @@ config UIO_NETX
 
 config UIO_PRUSS
 	tristate "Texas Instruments PRUSS driver"
-	depends on ARCH_DAVINCI_DA850
+	depends on ARCH_DAVINCI_DA850 || SOC_AM33XX
 	select GENERIC_ALLOCATOR
 	help
-	  PRUSS driver for OMAPL138/DA850/AM18XX devices
+	  PRUSS driver for OMAPL138/DA850/AM18XX and AM33XX devices
 	  PRUSS driver requires user space components, examples and user space
 	  driver is available from below SVN repo - you may use anonymous login
 
diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
index 1b55db3..8560958 100644
--- a/drivers/uio/uio_pruss.c
+++ b/drivers/uio/uio_pruss.c
@@ -26,6 +26,11 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/genalloc.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/err.h>
+#include <linux/pm_runtime.h>
 
 #define DRV_NAME "pruss_uio"
 #define DRV_VERSION "1.0"
@@ -120,8 +125,10 @@ static int __devinit pruss_probe(struct platform_device *dev)
 	struct uio_info *p;
 	struct uio_pruss_dev *gdev;
 	struct resource *regs_prussio;
+	struct resource res;
 	int ret = -ENODEV, cnt = 0, len;
 	struct uio_pruss_pdata *pdata = dev->dev.platform_data;
+	struct pinctrl *pinctrl;
 
 	gdev = kzalloc(sizeof(struct uio_pruss_dev), GFP_KERNEL);
 	if (!gdev)
@@ -132,18 +139,51 @@ static int __devinit pruss_probe(struct platform_device *dev)
 		kfree(gdev);
 		return -ENOMEM;
 	}
-	/* Power on PRU in case its not done as part of boot-loader */
-	gdev->pruss_clk = clk_get(&dev->dev, "pruss");
-	if (IS_ERR(gdev->pruss_clk)) {
-		dev_err(&dev->dev, "Failed to get clock\n");
-		kfree(gdev->info);
-		kfree(gdev);
-		ret = PTR_ERR(gdev->pruss_clk);
-		return ret;
+
+	if (dev->dev.of_node) {
+		pm_runtime_enable(&dev->dev);
+		ret = pm_runtime_get_sync(&dev->dev);
+		if (IS_ERR_VALUE(ret)) {
+			dev_err(&dev->dev, "pm_runtime_get_sync() failed\n");
+			return ret;
+		}
+
+		ret = of_address_to_resource(dev->dev.of_node, 0, &res);
+		if (IS_ERR_VALUE(ret)) {
+			dev_err(&dev->dev, "failed to parse DT reg\n");
+			return ret;
+		}
+		regs_prussio = &res;
+
+		ret = of_property_read_u32(dev->dev.of_node,
+					   "ti,pintc-offset",
+					   &gdev->pintc_base);
+		if (ret < 0) {
+			dev_err(&dev->dev,
+				"Can't parse ti,pintc-offset property\n");
+			goto out_free;
+		}
 	} else {
-		clk_enable(gdev->pruss_clk);
+		/* Power on PRU in case its not done as part of boot-loader */
+		gdev->pruss_clk = clk_get(&dev->dev, "pruss");
+		if (IS_ERR(gdev->pruss_clk)) {
+			dev_err(&dev->dev, "Failed to get clock\n");
+			kfree(gdev->info);
+			kfree(gdev);
+			ret = PTR_ERR(gdev->pruss_clk);
+			return ret;
+		} else {
+			clk_enable(gdev->pruss_clk);
+		}
+		gdev->pintc_base = pdata->pintc_base;
+		gdev->sram_pool = pdata->l3ram_pool;
 	}
 
+	pinctrl = devm_pinctrl_get_select_default(&dev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&dev->dev,
+			"pins are not configured from the driver\n");
+
 	regs_prussio = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!regs_prussio) {
 		dev_err(&dev->dev, "No PRUSS I/O resource specified\n");
@@ -155,8 +195,7 @@ static int __devinit pruss_probe(struct platform_device *dev)
 		goto out_free;
 	}
 
-	if (pdata->l3ram_pool) {
-		gdev->sram_pool = pdata->l3ram_pool;
+	if (gdev->sram_pool) {
 		gdev->sram_vaddr =
 			gen_pool_alloc(gdev->sram_pool, sram_pool_sz);
 		if (!gdev->sram_vaddr) {
@@ -182,7 +221,6 @@ static int __devinit pruss_probe(struct platform_device *dev)
 		goto out_free;
 	}
 
-	gdev->pintc_base = pdata->pintc_base;
 	gdev->hostirq_start = platform_get_irq(dev, 0);
 
 	for (cnt = 0, p = gdev->info; cnt < MAX_PRUSS_EVT; cnt++, p++) {
@@ -190,13 +228,19 @@ static int __devinit pruss_probe(struct platform_device *dev)
 		p->mem[0].size = resource_size(regs_prussio);
 		p->mem[0].memtype = UIO_MEM_PHYS;
 
-		p->mem[1].addr = gdev->sram_paddr;
-		p->mem[1].size = sram_pool_sz;
-		p->mem[1].memtype = UIO_MEM_PHYS;
-
-		p->mem[2].addr = gdev->ddr_paddr;
-		p->mem[2].size = extram_pool_sz;
-		p->mem[2].memtype = UIO_MEM_PHYS;
+		if (gdev->sram_vaddr) {
+			p->mem[1].addr = gdev->sram_paddr;
+			p->mem[1].size = sram_pool_sz;
+			p->mem[1].memtype = UIO_MEM_PHYS;
+
+			p->mem[2].addr = gdev->ddr_paddr;
+			p->mem[2].size = extram_pool_sz;
+			p->mem[2].memtype = UIO_MEM_PHYS;
+		} else {
+			p->mem[1].addr = gdev->ddr_paddr;
+			p->mem[1].size = extram_pool_sz;
+			p->mem[1].memtype = UIO_MEM_PHYS;
+		}
 
 		p->name = kasprintf(GFP_KERNEL, "pruss_evt%d", cnt);
 		p->version = DRV_VERSION;
@@ -228,12 +272,20 @@ static int __devexit pruss_remove(struct platform_device *dev)
 	return 0;
 }
 
+static const struct of_device_id pruss_dt_ids[] = {
+	{ .compatible = "ti,pruss-v1", .data = NULL, },
+	{ .compatible = "ti,pruss-v2", .data = NULL, },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pruss_dt_ids);
+
 static struct platform_driver pruss_driver = {
 	.probe = pruss_probe,
 	.remove = __devexit_p(pruss_remove),
 	.driver = {
 		   .name = DRV_NAME,
 		   .owner = THIS_MODULE,
+		   .of_match_table = pruss_dt_ids,
 		   },
 };
 
-- 
1.7.9.5

