Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1EBGwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 02:52:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1EBGwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 02:52:01 -0400
From: Michal Simek <monstr@monstr.eu>
To: devicetree-discuss@lists.ozlabs.org
Cc: grant.likely@secretlab.ca, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@hansjkoch.de, w.sang@pengutronix.de,
        arnd@arndb.de, Michal Simek <monstr@monstr.eu>
Subject: [PATCH v4] uio/pdrv_genirq: Add OF support
Date: Mon,  2 May 2011 08:51:55 +0200
Message-Id: <1304319115-32745-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding OF binding to genirq.
Version string is setup to the "devicetree".

Compatible string is not setup for now but you can add your
custom compatible string to uio_of_genirq_match structure.

For example with "vendor,device" compatible string:
static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
	{ .compatible = "vendor,device", },
	{ /* empty for now */ },
};

Signed-off-by: Michal Simek <monstr@monstr.eu>

---

v4: Remove dev_info messages
    Check irq against -ENXIO for no irq

v3: Fix irq binding
    Use "devicetree" as version string

v2: Remove additional resource binding
    Setup correct version string
    Clear compatible string
---
 drivers/uio/uio_pdrv_genirq.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 7174d51..ed6bf64 100644
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
@@ -97,6 +101,27 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	int ret = -EINVAL;
 	int i;
 
+	if (!uioinfo) {
+		int irq;
+
+		/* alloc uioinfo for one device */
+		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
+		if (!uioinfo) {
+			ret = -ENOMEM;
+			dev_err(&pdev->dev, "unable to kmalloc\n");
+			goto bad2;
+		}
+		uioinfo->name = pdev->dev.of_node->name;
+		uioinfo->version = "devicetree";
+
+		/* Multiple IRQs are not supported */
+		irq = platform_get_irq(pdev, 0);
+		if (irq == -ENXIO)
+			uioinfo->irq = UIO_IRQ_NONE;
+		else
+			uioinfo->irq = irq;
+	}
+
 	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
 		dev_err(&pdev->dev, "missing platform_data\n");
 		goto bad0;
@@ -180,6 +205,10 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	kfree(priv);
 	pm_runtime_disable(&pdev->dev);
  bad0:
+	/* kfree uioinfo for CONFIG_OF */
+	if (!pdev->dev.platform_data)
+		kfree(uioinfo);
+ bad2:
 	return ret;
 }
 
@@ -215,6 +244,15 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 	.runtime_resume = uio_pdrv_genirq_runtime_nop,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
+	{ /* empty for now */ },
+};
+MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
+#else
+# define uio_of_genirq_match NULL
+#endif
+
 static struct platform_driver uio_pdrv_genirq = {
 	.probe = uio_pdrv_genirq_probe,
 	.remove = uio_pdrv_genirq_remove,
@@ -222,6 +260,7 @@ static struct platform_driver uio_pdrv_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_pdrv_genirq_dev_pm_ops,
+		.of_match_table = uio_of_genirq_match,
 	},
 };
 
-- 
1.5.5.6

