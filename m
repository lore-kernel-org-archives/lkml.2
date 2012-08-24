Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab2HXJSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:18:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48124 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2HXJSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:18:20 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/5] ARM i.MX: Switch IRAM allocator to device tree initialization
Date: Fri, 24 Aug 2012 11:17:42 +0200
Message-Id: <1345799866-19876-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
References: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/plat-mxc/include/mach/iram.h |    6 -----
 arch/arm/plat-mxc/iram_alloc.c        |   44 ++++++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/iram.h b/arch/arm/plat-mxc/include/mach/iram.h
index 022690c..d5c863f 100644
--- a/arch/arm/plat-mxc/include/mach/iram.h
+++ b/arch/arm/plat-mxc/include/mach/iram.h
@@ -20,17 +20,11 @@
 
 #ifdef CONFIG_IRAM_ALLOC
 
-int __init iram_init(unsigned long base, unsigned long size);
 void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr);
 void iram_free(unsigned long dma_addr, unsigned int size);
 
 #else
 
-static inline int __init iram_init(unsigned long base, unsigned long size)
-{
-	return -ENOMEM;
-}
-
 static inline void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
 {
 	return NULL;
diff --git a/arch/arm/plat-mxc/iram_alloc.c b/arch/arm/plat-mxc/iram_alloc.c
index 074c386..673deb4 100644
--- a/arch/arm/plat-mxc/iram_alloc.c
+++ b/arch/arm/plat-mxc/iram_alloc.c
@@ -22,6 +22,8 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/genalloc.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 #include <mach/iram.h>
 
 static unsigned long iram_phys_base;
@@ -55,15 +57,26 @@ void iram_free(unsigned long addr, unsigned int size)
 }
 EXPORT_SYMBOL(iram_free);
 
-int __init iram_init(unsigned long base, unsigned long size)
+static int __devinit iram_probe(struct platform_device *pdev)
 {
-	iram_phys_base = base;
+	struct resource *res;
+	unsigned long size;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
+	if (iram_phys_base)
+		return -EBUSY;
+
+	iram_phys_base = res->start;
+	size = resource_size(res);
 
 	iram_pool = gen_pool_create(PAGE_SHIFT, -1);
 	if (!iram_pool)
 		return -ENOMEM;
 
-	gen_pool_add(iram_pool, base, size, -1);
+	gen_pool_add(iram_pool, res->start, size, -1);
 	iram_virt_base = ioremap(iram_phys_base, size);
 	if (!iram_virt_base)
 		return -EIO;
@@ -71,3 +84,28 @@ int __init iram_init(unsigned long base, unsigned long size)
 	pr_debug("i.MX IRAM pool: %ld KB@0x%p\n", size / 1024, iram_virt_base);
 	return 0;
 }
+
+static int __devexit iram_remove(struct platform_device *pdev)
+{
+	gen_pool_destroy(iram_pool);
+	iram_pool = NULL;
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static struct of_device_id iram_dt_ids[] = {
+	{ .compatible = "fsl,imx-iram" },
+	{ /* sentinel */ }
+};
+#endif
+
+static struct platform_driver iram_driver = {
+	.driver = {
+		.name = "imx-iram",
+		.of_match_table = of_match_ptr(iram_dt_ids),
+	},
+	.probe = iram_probe,
+	.remove = __devexit_p(iram_remove),
+};
+
+module_platform_driver(iram_driver);
-- 
1.7.10.4

