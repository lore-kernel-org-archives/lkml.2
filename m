Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab1CaMaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:30:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39854 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab1CaMaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:30:07 -0400
From: Michal Simek <monstr@monstr.eu>
To: devicetree-discuss@lists.ozlabs.org
Cc: grant.likely@secretlab.ca, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH] uio/pdrv_genirq: Add OF support
Date: Thu, 31 Mar 2011 14:30:00 +0200
Message-Id: <1301574600-4861-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support OF support. "generic-uio" compatible property is used.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/uio/uio_pdrv_genirq.c |   60 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 7174d51..9e89806 100644
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
@@ -92,11 +96,44 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 {
 	struct uio_info *uioinfo = pdev->dev.platform_data;
-	struct uio_pdrv_genirq_platdata *priv;
+	struct uio_pdrv_genirq_platdata *priv = NULL;
 	struct uio_mem *uiomem;
 	int ret = -EINVAL;
 	int i;
 
+	if (!uioinfo) {
+		struct resource r_irq; /* Interrupt resources */
+		int rc = 0;
+
+		rc = of_address_to_resource(pdev->dev.of_node, 0,
+							&pdev->resource[0]);
+		if (rc) {
+			dev_err(&pdev->dev, "invalid address\n");
+			goto bad2;
+		}
+		pdev->num_resources = 1;
+
+		/* alloc uioinfo for one device */
+		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
+		if (!uioinfo) {
+			ret = -ENOMEM;
+			dev_err(&pdev->dev, "unable to kmalloc\n");
+			goto bad2;
+		}
+		uioinfo->name = pdev->dev.of_node->name;
+		/* Use version for storing full IP name for identification */
+		uioinfo->version = pdev->dev.of_node->full_name;
+
+		/* Get IRQ for the device */
+		rc = of_irq_to_resource(pdev->dev.of_node, 0, &r_irq);
+		if (rc == NO_IRQ)
+			dev_err(&pdev->dev, "no IRQ found\n");
+		else {
+			uioinfo->irq = r_irq.start;
+			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
+		}
+	}
+
 	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
 		dev_err(&pdev->dev, "missing platform_data\n");
 		goto bad0;
@@ -176,10 +213,15 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 	return 0;
- bad1:
+
+bad1:
 	kfree(priv);
 	pm_runtime_disable(&pdev->dev);
- bad0:
+bad0:
+	/* kfree uioinfo for CONFIG_OF */
+	if (!pdev->dev.platform_data)
+		kfree(uioinfo);
+bad2:
 	return ret;
 }
 
@@ -215,6 +257,17 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 	.runtime_resume = uio_pdrv_genirq_runtime_nop,
 };
 
+#ifdef CONFIG_OF
+/* Match table for of_platform binding */
+static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
+	{ .compatible = "generic-uio", },
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
@@ -222,6 +275,7 @@ static struct platform_driver uio_pdrv_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_pdrv_genirq_dev_pm_ops,
+		.of_match_table = uio_of_genirq_match,
 	},
 };
 
-- 
1.5.5.6

