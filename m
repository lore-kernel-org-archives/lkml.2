Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2F0KbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:31:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31176 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2F0KbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:31:12 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-24-4feae0ee650e
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] Exynos : Add support for Exynos random number generator
Date: Wed, 27 Jun 2012 19:31:01 +0900
Message-id: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd13D175G0zdJWdxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyLm8KKthhXdF++zJ7A+Nuwy5GTg4JAROJZ03vWSFsMYkL99az
	dTFycQgJLGKU+Lp9DzOEs5RJ4vuCQ8wgVWwCOhL/991kB7FFBBQkNvc+YwUpYhbYwyTx+/Nt
	sCJhAW+JQzvuM3YxcnCwCKhKLL/BBhLmFfCQuLZqEhvENgWJBffesk1g5F7AyLCKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTI9iDz6R2MK5ssDjEKMDBqMTDO/XWK38h1sSy4srcQ4wSHMxK
	IrzH1wGFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZZX/AXEkhPLEnNTk0tSC2CyTJxcEo1MPZL
	fHK/7uGfsfz4667Hpg3Hjn9kfa34zePlTfbKYptdm+YbSSzS7zBpDtv7wyuS5/SHkKXWirMD
	mSXEhZNPr2WaxX9zy9bj0vVyVavvd6/f7yAd8lpZ02t9Y4nGl/3X9xdtf5fl3tOtddOEe45G
	lxSzpebUg8EeT7ZESvbfTLVx01jGbm+/U4mlOCPRUIu5qDgRAAkWQMfcAQAA
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
v2
 - Add HAS_IOMEM and PM_RUNTIME to config condition in Kconfig.
 - Modify parameter of exynos_rng_readl/writel fuction from base register address
   to struct exynos_rng.
 - Fix obscure using of pm_runtime API in exynos_init.
 - Register suspend/resume function with UNIVERSAL_DEV_PM_OPS macro to support
   system suspend/resume and runtime suspend/resume.

 drivers/char/hw_random/Kconfig      |   12 ++
 drivers/char/hw_random/Makefile     |    1 +
 drivers/char/hw_random/exynos-rng.c |  191 +++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hw_random/exynos-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index f45dad3..a9e3806 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -263,3 +263,15 @@ config HW_RANDOM_PSERIES
 	  module will be called pseries-rng.
 
 	  If unsure, say Y.
+
+config HW_RANDOM_EXYNOS
+	tristate "EXYNOS HW random number generator support"
+	depends on HW_RANDOM && ARCH_EXYNOS && HAS_IOMEM && PM_RUNTIME
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
index 0000000..9c8d690
--- /dev/null
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -0,0 +1,191 @@
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
+#include <linux/err.h>
+
+#define EXYNOS_PRNG_STATUS_OFFSET	0x10
+#define EXYNOS_PRNG_SEED_OFFSET		0x140
+#define EXYNOS_PRNG_OUT1_OFFSET		0x160
+#define SEED_SETTING_DONE		BIT(1)
+#define PRNG_START			0x18
+#define PRNG_DONE			BIT(5)
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
+		exynos_rng_writel(exynos_rng, i, EXYNOS_PRNG_SEED_OFFSET + 4*i);
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
+	do {
+		cpu_relax();
+	} while (!(exynos_rng_readl(exynos_rng,
+			EXYNOS_PRNG_STATUS_OFFSET) & PRNG_DONE));
+
+	exynos_rng_writel(exynos_rng, PRNG_DONE, EXYNOS_PRNG_STATUS_OFFSET);
+
+	*data = exynos_rng_readl(exynos_rng, EXYNOS_PRNG_OUT1_OFFSET);
+
+	pm_runtime_put(exynos_rng->dev);
+	return 4;
+}
+
+static int __devinit exynos_rng_probe(struct platform_device *pdev)
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
+	exynos_rng->clk = devm_clk_get(&pdev->dev, "secss");
+	if (IS_ERR(exynos_rng->clk)) {
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
+	exynos_rng->mem = devm_request_and_ioremap(&pdev->dev, res);
+	if (!exynos_rng->mem) {
+		dev_err(&pdev->dev, "Ioremap failed.\n");
+		return -EBUSY;
+	}
+
+	platform_set_drvdata(pdev, exynos_rng);
+
+	pm_runtime_enable(&pdev->dev);
+
+	ret = hwrng_register(&exynos_rng->rng);
+	if (ret)
+		return ret;
+
+	return 0;
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
+	return 0;
+}
+
+static int exynos_rng_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
+
+	clk_prepare_enable(exynos_rng->clk);
+	return 0;
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

