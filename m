Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1G0EFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:05:55 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54902 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab1G0EFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:50 -0400
X-Sasl-enc: 52859Sw5jlICKW3UIcNBQJSSGCRj3D8x938RYH5b9Wr6 1311739549
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Michal Simek <monstr@monstr.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        John Williams <john.williams@petalogix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/11] uio: uio_pdrv_genirq: Add OF support
Date: Tue, 26 Jul 2011 21:05:19 -0700
Message-Id: <1311739521-11014-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311739521-11014-1-git-send-email-gregkh@suse.de>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Hans J. Koch" <hjk@hansjkoch.de>

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
Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
CC: Hans J. Koch <hjk@hansjkoch.de>
CC: Arnd Bergmann <arnd@arndb.de>
CC: John Williams <john.williams@petalogix.com>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio_pdrv_genirq.c |   43 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 0f424af..f8f81db 100644
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
+	/* kfree uioinfo for OF */
+	if (pdev->dev.of_node)
+		kfree(uioinfo);
+ bad2:
 	return ret;
 }
 
@@ -193,6 +222,10 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
 	priv->uioinfo->handler = NULL;
 	priv->uioinfo->irqcontrol = NULL;
 
+	/* kfree uioinfo for OF */
+	if (pdev->dev.of_node)
+		kfree(priv->uioinfo);
+
 	kfree(priv);
 	return 0;
 }
@@ -219,6 +252,15 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
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
@@ -226,6 +268,7 @@ static struct platform_driver uio_pdrv_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_pdrv_genirq_dev_pm_ops,
+		.of_match_table = uio_of_genirq_match,
 	},
 };
 
-- 
1.7.6

