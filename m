Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1FUHWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:22:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59375 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1FUHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:22:17 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 5/8] remoteproc: add davinci implementation
Date: Tue, 21 Jun 2011 10:18:31 +0300
Message-Id: <1308640714-17961-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308640714-17961-1-git-send-email-ohad@wizery.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Grosen <mgrosen@ti.com>

Add remoteproc implementation for da850, so we can boot its DSP.

Signed-off-by: Mark Grosen <mgrosen@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-davinci/include/mach/remoteproc.h |   28 +++++
 drivers/remoteproc/Kconfig                      |   16 +++
 drivers/remoteproc/Makefile                     |    1 +
 drivers/remoteproc/davinci_remoteproc.c         |  147 +++++++++++++++++++++++
 4 files changed, 192 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-davinci/include/mach/remoteproc.h
 create mode 100644 drivers/remoteproc/davinci_remoteproc.c

diff --git a/arch/arm/mach-davinci/include/mach/remoteproc.h b/arch/arm/mach-davinci/include/mach/remoteproc.h
new file mode 100644
index 0000000..af6e88c
--- /dev/null
+++ b/arch/arm/mach-davinci/include/mach/remoteproc.h
@@ -0,0 +1,28 @@
+/*
+ * Remote Processor
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DAVINCI_REMOTEPROC_H
+#define _DAVINCI_REMOTEPROC_H
+
+#include <linux/remoteproc.h>
+
+struct davinci_rproc_pdata {
+	struct rproc_ops *ops;
+	char *name;
+	char *clk_name;
+	char *firmware;
+};
+
+#endif /* _DAVINCI_REMOTEPROC_H */
diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 88421bd..1e594b5 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -26,3 +26,19 @@ config OMAP_REMOTE_PROC
 
 	  It's safe to say n here if you're not interested in multimedia
 	  offloading or just want a bare minimum kernel.
+
+config DAVINCI_REMOTE_PROC
+	tristate "Davinci remoteproc support"
+	depends on ARCH_DAVINCI_DA850
+	select REMOTE_PROC
+	default y
+	help
+	  Say y here to support Davinci's DSP remote processor via the remote
+	  processor framework (currently only da850 is supported).
+
+	  Usually you want to say y here, in order to enable multimedia
+	  use-cases to run on your platform (multimedia codecs are
+	  offloaded to remote DSP processors using this framework).
+
+	  It's safe to say n here if you're not interested in multimedia
+	  offloading or just want a bare minimum kernel.
diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index 0198b1d..e83dac9 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_REMOTE_PROC)		+= remoteproc.o
 obj-$(CONFIG_OMAP_REMOTE_PROC)		+= omap_remoteproc.o
+obj-$(CONFIG_DAVINCI_REMOTE_PROC)	+= davinci_remoteproc.o
diff --git a/drivers/remoteproc/davinci_remoteproc.c b/drivers/remoteproc/davinci_remoteproc.c
new file mode 100644
index 0000000..0e26fe9
--- /dev/null
+++ b/drivers/remoteproc/davinci_remoteproc.c
@@ -0,0 +1,147 @@
+/*
+ * Remote processor machine-specific module for Davinci
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)    "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/printk.h>
+#include <linux/bitops.h>
+#include <linux/platform_device.h>
+#include <linux/remoteproc.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+
+#include <mach/da8xx.h>
+#include <mach/cputype.h>
+#include <mach/psc.h>
+#include <mach/remoteproc.h>
+
+/*
+ * Technical Reference:
+ * OMAP-L138 Applications Processor System Reference Guide
+ * http://www.ti.com/litv/pdf/sprugm7d
+ */
+
+/* local reset bit (0 is asserted) in MDCTL15 register (section 9.6.18) */
+#define LRST		BIT(8)
+
+/* next state bits in MDCTL15 register (section 9.6.18) */
+#define NEXT_ENABLED	0x3
+
+/* register for DSP boot address in SYSCFG0 module (section 11.5.6) */
+#define HOST1CFG	0x44
+
+static inline int davinci_rproc_start(struct rproc *rproc, u64 bootaddr)
+{
+	struct device *dev = rproc->dev;
+	struct davinci_rproc_pdata *pdata = dev->platform_data;
+	struct davinci_soc_info *soc_info = &davinci_soc_info;
+	void __iomem *psc_base;
+	struct clk *dsp_clk;
+
+	/* hw requires the start (boot) address be on 1KB boundary */
+	if (bootaddr & 0x3ff) {
+		dev_err(dev, "invalid boot address: must be aligned to 1KB\n");
+		return -EINVAL;
+	}
+
+	dsp_clk = clk_get(dev, pdata->clk_name);
+	if (IS_ERR_OR_NULL(dsp_clk)) {
+		dev_err(dev, "clk_get error: %ld\n", PTR_ERR(dsp_clk));
+		return PTR_ERR(dsp_clk);
+	}
+
+	clk_enable(dsp_clk);
+	rproc->priv = dsp_clk;
+
+	psc_base = ioremap(soc_info->psc_bases[0], SZ_4K);
+
+	/* insure local reset is asserted before writing start address */
+	__raw_writel(NEXT_ENABLED, psc_base + MDCTL + 4 * DA8XX_LPSC0_GEM);
+
+	__raw_writel(bootaddr, DA8XX_SYSCFG0_VIRT(HOST1CFG));
+
+	/* de-assert local reset to start the dsp running */
+	__raw_writel(LRST | NEXT_ENABLED, psc_base + MDCTL +
+		4 * DA8XX_LPSC0_GEM);
+
+	iounmap(psc_base);
+
+	return 0;
+}
+
+static inline int davinci_rproc_stop(struct rproc *rproc)
+{
+	struct davinci_soc_info *soc_info = &davinci_soc_info;
+	void __iomem *psc_base;
+	struct clk *dsp_clk = rproc->priv;
+
+	psc_base = ioremap(soc_info->psc_bases[0], SZ_4K);
+
+	/* halt the dsp by asserting local reset */
+	__raw_writel(NEXT_ENABLED, psc_base + MDCTL + 4 * DA8XX_LPSC0_GEM);
+
+	clk_disable(dsp_clk);
+	clk_put(dsp_clk);
+
+	iounmap(psc_base);
+
+	return 0;
+}
+
+static struct rproc_ops davinci_rproc_ops = {
+	.start = davinci_rproc_start,
+	.stop = davinci_rproc_stop,
+};
+
+static int davinci_rproc_probe(struct platform_device *pdev)
+{
+	struct davinci_rproc_pdata *pdata = pdev->dev.platform_data;
+
+	return rproc_register(&pdev->dev, pdata->name, &davinci_rproc_ops,
+				pdata->firmware, NULL, THIS_MODULE);
+}
+
+static int __devexit davinci_rproc_remove(struct platform_device *pdev)
+{
+	struct davinci_rproc_pdata *pdata = pdev->dev.platform_data;
+
+	return rproc_unregister(pdata->name);
+}
+
+static struct platform_driver davinci_rproc_driver = {
+	.probe = davinci_rproc_probe,
+	.remove = __devexit_p(davinci_rproc_remove),
+	.driver = {
+		.name = "davinci-rproc",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init davinci_rproc_init(void)
+{
+	return platform_driver_register(&davinci_rproc_driver);
+}
+module_init(davinci_rproc_init);
+
+static void __exit davinci_rproc_exit(void)
+{
+	platform_driver_unregister(&davinci_rproc_driver);
+}
+module_exit(davinci_rproc_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Davinci Remote Processor control driver");
-- 
1.7.1

