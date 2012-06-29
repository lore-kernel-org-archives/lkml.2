Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2F2And (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 20:43:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56680 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2F2Anc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 20:43:32 -0400
X-AuditID: cbfee61b-b7f776d000002f3f-ea-4fecfa3234de
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v4] Exynos : Add support for Exynos random number generator
Date: Fri, 29 Jun 2012 09:43:26 +0900
Message-id: <1340930606-2604-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQV2jX2/8DVZMNbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZy2afZS+4ZF3x4mIbWwPjN8MuRk4OCQETiV+rVrJB2GISF+6t
	B7K5OIQEpjNKLH13EcpZyiTROfM7I0gVm4COxP99N9lBbBEBBYnNvc9YQYqYBfYwSfz+fJsZ
	JCEs4C1xe9FvoG4ODhYBVYmJ+/hAwrwC7hJ7Vt9ghNimILHg3lu2CYzcCxgZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIE+/CZ9A7GVQ0WhxgFOBiVeHgjPr3xF2JNLCuuzD3EKMHBrCTC
	u3kqUIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvk/UFfyGB9MSS1OzU1ILUIpgsEwenVAPjUi0e
	95u9AUp3ppwrObQq6kyZ+Xc7dfbNv39cvLp7uveq1tfZT2+JTd64I5q1QvYk86UNAb9XLjv0
	x/jrU7aiTtWVJrvsr8+4oitmPTtz+d5vZxy9l/rq61SVT8yxPK7o83J1h5zlKc6HcsGGN+Zd
	v8E+LXnKXDN94ZQDT8vkZT3XXZ6tquKcrsRSnJFoqMVcVJwIAM8GBqPdAQAA
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
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
v4
 - Remove unneccessary header file; <linux/delay.h>.

v3
 - It supports pm_runtime_autosuspend. After busy working it sets timer and it will
   be suspended automatically when timer is expired.
 - Use jiffies as the seeds of generator for more accuracy randomness.
 - Fix Kconfig depends-on condition to broden this drivers's coverage.

v2
 https://lkml.org/lkml/2012/6/27/186
 drivers/char/hw_random/Kconfig      |   12 +++
 drivers/char/hw_random/Makefile     |    1 +
 drivers/char/hw_random/exynos-rng.c |  182 +++++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hw_random/exynos-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index f45dad3..b01d673 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -263,3 +263,15 @@ config HW_RANDOM_PSERIES
 	  module will be called pseries-rng.
 
 	  If unsure, say Y.
+
+config HW_RANDOM_EXYNOS
+	tristate "EXYNOS HW random number generator support"
+	depends on HW_RANDOM && HAS_IOMEM && HAVE_CLK
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
index 0000000..232ba9c
--- /dev/null
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -0,0 +1,182 @@
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
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+#include <linux/err.h>
+
+#define EXYNOS_PRNG_STATUS_OFFSET	0x10
+#define EXYNOS_PRNG_SEED_OFFSET		0x140
+#define EXYNOS_PRNG_OUT1_OFFSET		0x160
+#define SEED_SETTING_DONE		BIT(1)
+#define PRNG_START			0x18
+#define PRNG_DONE			BIT(5)
+#define EXYNOS_AUTOSUSPEND_DELAY	100
+
+struct exynos_rng {
+	struct device *dev;
+	struct hwrng rng;
+	void __iomem *mem;
+	struct clk *clk;
+};
+
+static u32 exynos_rng_readl(struct exynos_rng *rng, u32 offset)
+{
+	return	__raw_readl(rng->mem + offset);
+}
+
+static void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)
+{
+	__raw_writel(val, rng->mem + offset);
+}
+
+static int exynos_init(struct hwrng *rng)
+{
+	struct exynos_rng *exynos_rng = container_of(rng,
+						struct exynos_rng, rng);
+	int i;
+	int ret = 0;
+
+	pm_runtime_get_sync(exynos_rng->dev);
+
+	for (i = 0 ; i < 5 ; i++)
+		exynos_rng_writel(exynos_rng, jiffies,
+				EXYNOS_PRNG_SEED_OFFSET + 4*i);
+
+	if (!(exynos_rng_readl(exynos_rng, EXYNOS_PRNG_STATUS_OFFSET)
+						 & SEED_SETTING_DONE))
+		ret = -EIO;
+
+	pm_runtime_put_noidle(exynos_rng->dev);
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
+
+	pm_runtime_get_sync(exynos_rng->dev);
+
+	exynos_rng_writel(exynos_rng, PRNG_START, 0);
+
+	while (!(exynos_rng_readl(exynos_rng,
+			EXYNOS_PRNG_STATUS_OFFSET) & PRNG_DONE))
+		cpu_relax();
+
+	exynos_rng_writel(exynos_rng, PRNG_DONE, EXYNOS_PRNG_STATUS_OFFSET);
+
+	*data = exynos_rng_readl(exynos_rng, EXYNOS_PRNG_OUT1_OFFSET);
+
+	pm_runtime_mark_last_busy(exynos_rng->dev);
+	pm_runtime_autosuspend(exynos_rng->dev);
+
+	return 4;
+}
+
+static int __devinit exynos_rng_probe(struct platform_device *pdev)
+{
+	struct exynos_rng *exynos_rng;
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
+	exynos_rng->clk = devm_clk_get(&pdev->dev, "secss");
+	if (IS_ERR(exynos_rng->clk)) {
+		dev_err(&pdev->dev, "Couldn't get clock.\n");
+		return -ENOENT;
+	}
+
+	exynos_rng->mem = devm_request_and_ioremap(&pdev->dev,
+			platform_get_resource(pdev, IORESOURCE_MEM, 0));
+	if (!exynos_rng->mem)
+		return -EBUSY;
+
+	platform_set_drvdata(pdev, exynos_rng);
+
+	pm_runtime_set_autosuspend_delay(&pdev->dev, EXYNOS_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	return hwrng_register(&exynos_rng->rng);
+}
+
+static int __devexit exynos_rng_remove(struct platform_device *pdev)
+{
+	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
+
+	hwrng_unregister(&exynos_rng->rng);
+
+	return 0;
+}
+
+static int exynos_rng_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(exynos_rng->clk);
+
+	return 0;
+}
+
+static int exynos_rng_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
+
+	return clk_prepare_enable(exynos_rng->clk);
+}
+
+
+UNIVERSAL_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_runtime_suspend,
+					exynos_rng_runtime_resume, NULL);
+
+static struct platform_driver exynos_rng_driver = {
+	.driver		= {
+		.name	= "exynos-rng",
+		.owner	= THIS_MODULE,
+		.pm	= &exynos_rng_pm_ops,
+	},
+	.probe		= exynos_rng_probe,
+	.remove		= __devexit_p(exynos_rng_remove),
+};
+
+module_platform_driver(exynos_rng_driver);
+
+MODULE_DESCRIPTION("EXYNOS 4 H/W Random Number Generator driver");
+MODULE_AUTHOR("Jonghwa Lee <jonghwa3.lee@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

