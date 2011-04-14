Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab1DNJlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:41:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40078 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab1DNJlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:41:51 -0400
From: Michal Simek <monstr@monstr.eu>
To: devicetree-discuss@lists.ozlabs.org
Cc: grant.likely@secretlab.ca, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@hansjkoch.de, w.sang@pengutronix.de,
        arnd@arndb.de, Michal Simek <monstr@monstr.eu>
Subject: [PATCH v2] uio/pdrv_genirq: Add OF support
Date: Thu, 14 Apr 2011 11:41:46 +0200
Message-Id: <1302774106-32764-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support OF support. "generic-uio" compatible property is used.

Signed-off-by: Michal Simek <monstr@monstr.eu>

---
v2: Remove additional resource binding
    Setup correct version string
    Clear compatible string
---
 drivers/uio/uio_pdrv_genirq.c |   45 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 7174d51..fd84a93 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -23,6 +23,10 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+
 #define DRIVER_NAME "uio_pdrv_genirq"
 
 struct uio_pdrv_genirq_platdata {
@@ -97,6 +101,28 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	int ret = -EINVAL;
 	int i;
 
+	if (!uioinfo) {
+		/* alloc uioinfo for one device */
+		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
+		if (!uioinfo) {
+			ret = -ENOMEM;
+			dev_err(&pdev->dev, "unable to kmalloc\n");
+			goto bad2;
+		}
+		uioinfo->name = pdev->dev.of_node->name;
+		uioinfo->version = "dt";
+
+		/* Multiple IRQs are not supported */
+		if (pdev->num_resources > 1) {
+			struct resource *r = &pdev->resource[1];
+			uioinfo->irq = r->start;
+			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
+		} else {
+			uioinfo->irq = UIO_IRQ_NONE;
+			dev_info(&pdev->dev, "no IRQ found\n");
+		}
+	}
+
 	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
 		dev_err(&pdev->dev, "missing platform_data\n");
 		goto bad0;
@@ -180,6 +206,10 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	kfree(priv);
 	pm_runtime_disable(&pdev->dev);
  bad0:
+	/* kfree uioinfo for CONFIG_OF */
+	if (!pdev->dev.platform_data)
+		kfree(uioinfo);
+ bad2:
 	return ret;
 }
 
@@ -215,6 +245,20 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 	.runtime_resume = uio_pdrv_genirq_runtime_nop,
 };
 
+#ifdef CONFIG_OF
+/*
+ * Empty match table for of_platform binding
+ * Select your custom compatible string in format
+ * { .compatible = "<compatible string>", },
+ */
+static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
+	{ /* end of list */ },
+};
+MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
+#else
+# define uio_of_genirq_match NULL
+#endif
+
 static struct platform_driver uio_pdrv_genirq = {
 	.probe = uio_pdrv_genirq_probe,
 	.remove = uio_pdrv_genirq_remove,
@@ -222,6 +266,7 @@ static struct platform_driver uio_pdrv_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_pdrv_genirq_dev_pm_ops,
+		.of_match_table = uio_of_genirq_match,
 	},
 };
 
-- 
1.5.5.6

