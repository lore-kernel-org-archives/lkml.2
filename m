Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2FTISW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:18:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2FTISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:18:17 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-8e-4fe1874504cf
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herber@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] Exynos : Add support for Exynos random number generator
Date: Wed, 20 Jun 2012 17:18:04 +0900
Message-id: <1340180284-24453-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQV3X9of+Bhc3Gltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MxVtusRecs6pYeeAtWwPjOYMuRk4OCQETiZdPv7BA2GISF+6t
	Z+ti5OIQEpjOKHG75QgzhLOSSeLmuh+MIFVsAjoS//fdZAexRQQUJDb3PmMFKWIWmMIksfLy
	H7BRwgIeEpsnQ9gsAqoS1xaeA7N5geIn9kxih1inILHg3lu2CYzcCxgZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEe/GZ9A7GVQ0WhxgFOBiVeHh/VD/0F2JNLCuuzD3EKMHBrCTCa9AI
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM7bZH3BX0ggPbEkNTs1tSC1CCbLxMEp1cAo18fl6Z+k
	toVTT3X9ZI+ZiVVeJxsXH0/TcyoNeGs2M26PldSrA3pbd2+xq105U1a3WXyR/Exudsf1X9R9
	GLct/sZSHfTy0aOfPdX8KX95DrP8lM35aN73XFWtSHByZbvbk7OsrlfNd/39Kjz3w5FtPyde
	7vF/+NhornrS0YnZv9bJiC3c4R+pxFKckWioxVxUnAgA7dGebt4BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports Exynos SOC's PRNG driver. Exynos's PRNG has 5 seeds and
5 random number outputs. Module is excuted under runtime power management control,
so it activates only while it's in use. Otherwise it will be suspended generally.
It was tested on PQ board by rngtest program.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/char/hw_random/Kconfig      |   12 ++
 drivers/char/hw_random/Makefile     |    1 +
 drivers/char/hw_random/exynos-rng.c |  204 +++++++++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hw_random/exynos-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index f45dad3..8220026 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -263,3 +263,15 @@ config HW_RANDOM_PSERIES
 	  module will be called pseries-rng.
 
 	  If unsure, say Y.
+
+config HW_RANDOM_EXYNOS
+	tristate "EXYNOS Random Number Generator support"
+	depends on HW_RANDOM && ARCH_EXYNOS4
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on EXYNOS SOCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called exynos-rng.
+
+	  If unsure, say Y.
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index d901dfa..8d6d173 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
 obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
+obj-$(CONFIG_HW_RANDOM_EXYNOS)	+= exynos-rng.o
diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
new file mode 100644
index 0000000..b58a28b
--- /dev/null
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -0,0 +1,204 @@
+/*
+ * exynos-rng.c - Random Number Generator driver for the exynos
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * Jonghwa Lee <jonghwa3.lee@smasung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/hw_random.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+
+#define	EXYNOS_PRNG_STATUS_OFFSET	0x10
+#define EXYNOS_PRNG_SEED_OFFSET		0x140
+#define EXYNOS_PRNG_OUT1_OFFSET		0x160
+#define SEED_SETTING_DONE		BIT(1)
+#define PRNG_START			0x18
+#define	PRNG_DONE			BIT(5)
+
+struct exynos_rng {
+	struct device *dev;
+	struct hwrng rng;
+	void __iomem *mem;
+	struct clk *clk;
+};
+
+static u32 exynos_rng_readl(void __iomem *base, u32 offset)
+{
+	return	__raw_readl(base + offset);
+}
+
+static void exynos_rng_writel(u32 val, void __iomem *base, u32 offset)
+{
+	__raw_writel(val, base + offset);
+}
+
+static int exynos_init(struct hwrng *rng)
+{
+	struct exynos_rng *exynos_rng = container_of(rng,
+						struct exynos_rng, rng);
+	int i;
+	int ret = 0;
+	u32 PRND_SEED[5];
+
+	pm_runtime_put_noidle(exynos_rng->dev);
+	pm_runtime_get_sync(exynos_rng->dev);
+
+	for (i = 0 ; i < 5 ; i++) {
+		PRND_SEED[i] = i;
+		exynos_rng_writel(PRND_SEED[i], exynos_rng->mem,
+					EXYNOS_PRNG_SEED_OFFSET + 4*i);
+	}
+
+	if (!(exynos_rng_readl(exynos_rng->mem, EXYNOS_PRNG_STATUS_OFFSET)
+						 & SEED_SETTING_DONE))
+		ret = -EIO;
+
+	pm_runtime_put(exynos_rng->dev);
+	pm_runtime_get_noresume(exynos_rng->dev);
+
+	return ret;
+}
+
+static int exynos_read(struct hwrng *rng, void *buf,
+					size_t max, bool wait)
+{
+	struct exynos_rng *exynos_rng = container_of(rng,
+						struct exynos_rng, rng);
+	u32 *data = buf;
+	u32 status = 0;
+
+	pm_runtime_get_sync(exynos_rng->dev);
+	exynos_rng_writel(PRNG_START, exynos_rng->mem, 0);
+
+	while (!status) {
+		status = exynos_rng_readl(exynos_rng->mem,
+					EXYNOS_PRNG_STATUS_OFFSET);
+		status &= PRNG_DONE;
+	}
+
+	exynos_rng_writel(PRNG_DONE, exynos_rng->mem,
+					EXYNOS_PRNG_STATUS_OFFSET);
+
+	*data = exynos_rng_readl(exynos_rng->mem,
+					EXYNOS_PRNG_OUT1_OFFSET);
+
+	pm_runtime_put(exynos_rng->dev);
+	return 4;
+}
+
+static int __init exynos_rng_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct exynos_rng *exynos_rng;
+	struct resource *res;
+
+	exynos_rng = devm_kzalloc(&pdev->dev, sizeof(struct exynos_rng),
+					GFP_KERNEL);
+	if (!exynos_rng)
+		return -ENOMEM;
+
+	exynos_rng->dev = &pdev->dev;
+	exynos_rng->rng.name = "exynos";
+	exynos_rng->rng.init =	exynos_init;
+	exynos_rng->rng.read = exynos_read;
+	exynos_rng->clk = clk_get(NULL, "secss");
+	if (!exynos_rng->clk) {
+		dev_err(&pdev->dev, "Couldn't get clock.\n");
+		return -ENOENT;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		clk_put(exynos_rng->clk);
+		return -ENODEV;
+	}
+
+	exynos_rng->mem = devm_ioremap(&pdev->dev, res->start,
+						 resource_size(res));
+	if (!exynos_rng->mem) {
+		dev_err(&pdev->dev, "Ioremap failed.\n");
+		return -EBUSY;
+	}
+
+	platform_set_drvdata(pdev, exynos_rng);
+
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_irq_safe(&pdev->dev);
+
+	ret = hwrng_register(&exynos_rng->rng);
+	if (ret) {
+		clk_put(exynos_rng->clk);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __exit exynos_rng_remove(struct platform_device *pdev)
+{
+	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
+
+	hwrng_unregister(&exynos_rng->rng);
+	clk_put(exynos_rng->clk);
+	return 0;
+}
+
+static int exynos_rng_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
+
+	clk_disable(exynos_rng->clk);
+	return 0;
+}
+
+static int exynos_rng_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
+
+	clk_enable(exynos_rng->clk);
+	return 0;
+}
+
+static const struct dev_pm_ops exynos_rng_pm_ops = {
+	.runtime_suspend = exynos_rng_runtime_suspend,
+	.runtime_resume = exynos_rng_runtime_resume,
+};
+
+static struct platform_driver exynos_rng_driver = {
+	.driver		= {
+		.name	= "exynos-rng",
+		.owner	= THIS_MODULE,
+		.pm	= &exynos_rng_pm_ops,
+	},
+	.probe		= exynos_rng_probe,
+	.remove		= exynos_rng_remove,
+};
+
+module_platform_driver(exynos_rng_driver);
+
+MODULE_DESCRIPTION("EXYNOS 4 H/W Random Number Generator driver");
+MODULE_AUTHOR("Jonghwa Lee <jonghwa3.lee@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

