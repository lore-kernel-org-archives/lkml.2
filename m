Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab1ANQLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:11:13 -0500
Received: from mail-wy0-f194.google.com ([74.125.82.194]:51332 "EHLO
	mail-wy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab1ANQLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:11:02 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Jamie Iles <jamie@jamieiles.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH] hwrng: add support for picoxcell TRNG
Date: Fri, 14 Jan 2011 16:10:48 +0000
Message-Id: <1295021448-25018-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for the True Random Number Generator in
the Picochip PC3X3 and later devices.

Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---

ARCH_PICOXCELL machine support patches have been posted the ARM mailing
lists for review (with another revision to follow soon).

 drivers/char/hw_random/Kconfig         |   12 ++
 drivers/char/hw_random/Makefile        |    1 +
 drivers/char/hw_random/picoxcell-rng.c |  175 ++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hw_random/picoxcell-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index d31483c..beecd1c 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -198,3 +198,15 @@ config HW_RANDOM_NOMADIK
 	  module will be called nomadik-rng.
 
 	  If unsure, say Y.
+
+config HW_RANDOM_PICOXCELL
+	tristate "Picochip picoXcell true random number generator support"
+	depends on HW_RANDOM && ARCH_PICOXCELL && PICOXCELL_PC3X3
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on Picochip PC3x3 and later devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called picoxcell-rng.
+
+	  If unsure, say Y.
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 4273308..3db4eb8 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
 obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
+obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
new file mode 100644
index 0000000..e750056
--- /dev/null
+++ b/drivers/char/hw_random/picoxcell-rng.c
@@ -0,0 +1,175 @@
+/*
+ * Copyright (c) 2010-2011 Picochip Ltd., Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * All enquiries to support@picochip.com
+ */
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#define DATA_REG_OFFSET			0x0200
+#define CSR_REG_OFFSET			0x0278
+#define		CSR_OUT_EMPTY_MASK	(1 << 24)
+#define TAI_REG_OFFSET			0x0380
+
+static void __iomem *rng_base;
+static struct clk *rng_clk;
+
+/*
+ * Get some random data from the random number generator. The hw_random core
+ * layer provides us with locking. We can't rely on data being word aligned
+ * though so we'll need to do a memcpy.
+ */
+static int picoxcell_trng_read(struct hwrng *rng, void *buf, size_t max,
+			       bool wait)
+{
+	u32 __iomem *csr = rng_base + CSR_REG_OFFSET;
+	int data_avail = !(__raw_readl(csr) & CSR_OUT_EMPTY_MASK);
+	u32 data;
+
+	if (!data_avail && !wait)
+		return 0;
+
+	/* Wait for some data to become available. */
+	while (!data_avail) {
+		data_avail = !(__raw_readl(csr) & CSR_OUT_EMPTY_MASK);
+		cpu_relax();
+	}
+
+	data = __raw_readl(rng_base + DATA_REG_OFFSET);
+	memcpy(buf, &data, min(max, sizeof(data)));
+
+	return sizeof(data);
+}
+
+static struct hwrng picoxcell_trng = {
+	.name		= "picoxcell",
+	.read		= picoxcell_trng_read,
+};
+
+/*
+ * Take the random number generator out of reset and make sure the interrupts
+ * are masked. We shouldn't need to get large amounts of random bytes so just
+ * poll the status register. The hardware generates 32 bits every 320ns so we
+ * shouldn't have to wait long enough to warrant waiting for an IRQ.
+ */
+static void picoxcell_trng_start(void)
+{
+	__raw_writel(0, rng_base + TAI_REG_OFFSET);
+	__raw_writel(0, rng_base + CSR_REG_OFFSET);
+}
+
+static int picoxcell_trng_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!mem) {
+		dev_warn(&pdev->dev, "no memory resource\n");
+		return -ENOMEM;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
+				     "picoxcell_trng")) {
+		dev_warn(&pdev->dev, "unable to request io mem\n");
+		return -EBUSY;
+	}
+
+	rng_base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!rng_base) {
+		dev_warn(&pdev->dev, "unable to remap io mem\n");
+		return -ENOMEM;
+	}
+
+	rng_clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(rng_clk)) {
+		dev_warn(&pdev->dev, "no clk\n");
+		return PTR_ERR(rng_clk);
+	}
+
+	ret = clk_enable(rng_clk);
+	if (ret) {
+		dev_warn(&pdev->dev, "unable to enable clk\n");
+		goto err_enable;
+	}
+
+	picoxcell_trng_start();
+	ret = hwrng_register(&picoxcell_trng);
+	if (ret)
+		goto err_register;
+
+	dev_info(&pdev->dev, "pixoxcell random number generator active\n");
+
+	return 0;
+
+err_register:
+	clk_disable(rng_clk);
+err_enable:
+	clk_put(rng_clk);
+
+	return ret;
+}
+
+static int __devexit picoxcell_trng_remove(struct platform_device *pdev)
+{
+	hwrng_unregister(&picoxcell_trng);
+	clk_disable(rng_clk);
+	clk_put(rng_clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int picoxcell_trng_suspend(struct device *dev)
+{
+	clk_disable(rng_clk);
+
+	return 0;
+}
+
+static int picoxcell_trng_resume(struct device *dev)
+{
+	return clk_enable(rng_clk);
+}
+
+static const struct dev_pm_ops picoxcell_trng_pm_ops = {
+	.suspend	= picoxcell_trng_suspend,
+	.resume		= picoxcell_trng_resume,
+};
+#endif /* CONFIG_PM */
+
+static struct platform_driver picoxcell_trng_driver = {
+	.probe		= picoxcell_trng_probe,
+	.remove		= __devexit_p(picoxcell_trng_remove),
+	.driver		= {
+		.name	= "picoxcell-trng",
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &picoxcell_trng_pm_ops,
+#endif /* CONFIG_PM */
+	},
+};
+
+static int __init picoxcell_trng_init(void)
+{
+	return platform_driver_register(&picoxcell_trng_driver);
+}
+module_init(picoxcell_trng_init);
+
+static void __exit picoxcell_trng_exit(void)
+{
+	platform_driver_unregister(&picoxcell_trng_driver);
+}
+module_exit(picoxcell_trng_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("Picochip picoXcell TRNG driver");
-- 
1.7.3.4

