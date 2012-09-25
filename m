Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2IYMN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:13:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:55724 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab2IYMNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:13:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,481,1344236400"; 
   d="scan'208";a="196801373"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv1 2/6] dmaengine: dw_dmac: add driver for Atmel AT32
Date: Tue, 25 Sep 2012 15:13:06 +0300
Message-Id: <1348575190-11761-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

This driver should be usable on all platforms that depend on clk API.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/Kconfig        |    9 +++
 drivers/dma/Makefile       |    1 +
 drivers/dma/dw_dmac.c      |   23 +------
 drivers/dma/dw_dmac_at32.c |  150 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 162 insertions(+), 21 deletions(-)
 create mode 100644 drivers/dma/dw_dmac_at32.c

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index df32537..e47cc90 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -89,6 +89,15 @@ config DW_DMAC
 	  Support the Synopsys DesignWare AHB DMA controller.  This
 	  can be integrated in chips such as the Atmel AT32ap7000.
 
+config DW_DMAC_AT32
+	tristate "Synopsys DesignWare AHB DMA support for Atmel"
+	depends on HAVE_CLK
+	select DW_DMAC
+	default y if CPU_AT32AP7000
+	help
+	  Support the Synopsys DesignWare AHB DMA controller in the chips
+	  such as the Atmel AT32ap7000.
+
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
 	depends on ARCH_AT91
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 7428fea..d76020b 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_FSL_DMA) += fsldma.o
 obj-$(CONFIG_MPC512X_DMA) += mpc512x_dma.o
 obj-$(CONFIG_MV_XOR) += mv_xor.o
 obj-$(CONFIG_DW_DMAC) += dw_dmac.o
+obj-$(CONFIG_DW_DMAC_AT32) += dw_dmac_at32.o
 obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
 obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d9344a7..9c8a500 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/of.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -1681,35 +1680,17 @@ static const struct dev_pm_ops dw_dev_pm_ops = {
 	.poweroff_noirq = dw_suspend_noirq,
 };
 
-#ifdef CONFIG_OF
-static const struct of_device_id dw_dma_id_table[] = {
-	{ .compatible = "snps,dma-spear1340" },
-	{}
-};
-MODULE_DEVICE_TABLE(of, dw_dma_id_table);
-#endif
-
 static struct platform_driver dw_driver = {
+	.probe		= dw_probe,
 	.remove		= __devexit_p(dw_remove),
 	.shutdown	= dw_shutdown,
 	.driver = {
 		.name	= "dw_dmac",
 		.pm	= &dw_dev_pm_ops,
-		.of_match_table = of_match_ptr(dw_dma_id_table),
 	},
 };
 
-static int __init dw_init(void)
-{
-	return platform_driver_probe(&dw_driver, dw_probe);
-}
-subsys_initcall(dw_init);
-
-static void __exit dw_exit(void)
-{
-	platform_driver_unregister(&dw_driver);
-}
-module_exit(dw_exit);
+module_platform_driver(dw_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
diff --git a/drivers/dma/dw_dmac_at32.c b/drivers/dma/dw_dmac_at32.c
new file mode 100644
index 0000000..7bc7ac4
--- /dev/null
+++ b/drivers/dma/dw_dmac_at32.c
@@ -0,0 +1,150 @@
+/*
+ * Driver for the Synopsys DesignWare DMA Controller
+ *
+ * The driver is based on the excerpts from the original dw_dmac.c. That's why
+ * the same copyright holders are mentioned here as well.
+ *
+ * Copyright (C) 2007-2008 Atmel Corporation
+ * Copyright (C) 2010-2011 ST Microelectronics
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/dw_dmac.h>
+
+struct dw_at32 {
+	struct platform_device	*pdev;
+	struct clk		*clk;
+};
+
+static int __init dw_at32_probe(struct platform_device *pdev)
+{
+	struct dw_at32			*at32;
+	struct platform_device		*pd;
+	struct dw_dma_platform_data	*pdata = pdev->dev.platform_data;
+	static int			instance;
+	int				ret;
+
+	at32 = devm_kzalloc(&pdev->dev, sizeof(*at32), GFP_KERNEL);
+	if (!at32) {
+		dev_err(&pdev->dev, "can't allocate memory\n");
+		return -ENOMEM;
+	}
+
+	pd = platform_device_alloc("dw_dmac", instance);
+	if (!pd) {
+		dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, at32);
+
+	pd->dev.parent = &pdev->dev;
+	at32->pdev = pd;
+
+	at32->clk = devm_clk_get(&pdev->dev, "hclk");
+	if (IS_ERR(at32->clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		ret = -EINVAL;
+		goto err0;
+	}
+	clk_prepare_enable(at32->clk);
+
+	ret = platform_device_add_resources(pd, pdev->resource,
+						pdev->num_resources);
+	if (ret) {
+		dev_err(&pdev->dev, "can't add resources to the device\n");
+		goto err1;
+	}
+
+	ret = platform_device_add_data(pd, pdata, sizeof(*pdata));
+	if (ret)
+		goto err1;
+
+	ret = platform_device_add(pd);
+	if (ret)
+		goto err1;
+
+	instance++;
+	return 0;
+
+err1:
+	clk_disable_unprepare(at32->clk);
+err0:
+	platform_device_put(pd);
+	return ret;
+}
+
+static int __exit dw_at32_remove(struct platform_device *pdev)
+{
+	struct dw_at32 *at32 = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(at32->clk);
+	platform_device_unregister(at32->pdev);
+
+	return 0;
+}
+
+static void dw_at32_shutdown(struct platform_device *pdev)
+{
+	struct dw_at32 *at32 = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(at32->clk);
+}
+
+static int dw_at32_suspend_noirq(struct device *dev)
+{
+	struct dw_at32 *at32 = platform_get_drvdata(to_platform_device(dev));
+
+	clk_disable_unprepare(at32->clk);
+
+	return 0;
+}
+
+static int dw_at32_resume_noirq(struct device *dev)
+{
+	struct dw_at32 *at32 = platform_get_drvdata(to_platform_device(dev));
+
+	clk_prepare_enable(at32->clk);
+
+	return 0;
+}
+
+static const struct dev_pm_ops dw_at32_pm_ops = {
+	.suspend_noirq = dw_at32_suspend_noirq,
+	.resume_noirq = dw_at32_resume_noirq,
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id dw_dma_id_table[] = {
+	{ .compatible = "snps,dma-spear1340" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, dw_dma_id_table);
+#endif
+
+static struct platform_driver dw_at32_driver = {
+	.probe		= dw_at32_probe,
+	.remove		= __exit_p(dw_at32_remove),
+	.shutdown	= dw_at32_shutdown,
+	.driver = {
+		.name	= "at32_dmac",
+		.pm	= &dw_at32_pm_ops,
+		.of_match_table = of_match_ptr(dw_dma_id_table),
+	},
+};
+
+module_platform_driver(dw_at32_driver);
+
+MODULE_ALIAS("platform:at32_dmac");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("DesignWare DMAC driver for Atmel AT32");
+MODULE_AUTHOR("Heikki Krogerus <heikki.krogerus@linux.intel.com>");
+MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
-- 
1.7.10.4

