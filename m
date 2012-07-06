Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab2GFUch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:32:37 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:56906 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2GFUcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:32:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / crypto / ux500: Use struct dev_pm_ops for power management
Date: Fri, 6 Jul 2012 22:38:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207062238.08013.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / crypto / ux500: Use struct dev_pm_ops for power management

Make the ux500 crypto driver define its PM callbacks through
struct dev_pm_ops objects rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/crypto/ux500/cryp/cryp_core.c |   39 ++++++++++++++++------------------
 drivers/crypto/ux500/hash/hash_core.c |   33 +++++++++++++---------------
 2 files changed, 34 insertions(+), 38 deletions(-)

Index: linux/drivers/crypto/ux500/cryp/cryp_core.c
===================================================================
--- linux.orig/drivers/crypto/ux500/cryp/cryp_core.c
+++ linux/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1661,27 +1661,26 @@ static void ux500_cryp_shutdown(struct p
 
 }
 
-static int ux500_cryp_suspend(struct platform_device *pdev, pm_message_t state)
+static int ux500_cryp_suspend(struct device *dev)
 {
 	int ret;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct cryp_device_data *device_data;
 	struct resource *res_irq;
 	struct cryp_ctx *temp_ctx = NULL;
 
-	dev_dbg(&pdev->dev, "[%s]", __func__);
+	dev_dbg(dev, "[%s]", __func__);
 
 	/* Handle state? */
 	device_data = platform_get_drvdata(pdev);
 	if (!device_data) {
-		dev_err(&pdev->dev, "[%s]: platform_get_drvdata() failed!",
-			__func__);
+		dev_err(dev, "[%s]: platform_get_drvdata() failed!", __func__);
 		return -ENOMEM;
 	}
 
 	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res_irq)
-		dev_err(&pdev->dev, "[%s]: IORESOURCE_IRQ, unavailable",
-			__func__);
+		dev_err(dev, "[%s]: IORESOURCE_IRQ, unavailable", __func__);
 	else
 		disable_irq(res_irq->start);
 
@@ -1692,32 +1691,32 @@ static int ux500_cryp_suspend(struct pla
 
 	if (device_data->current_ctx == ++temp_ctx) {
 		if (down_interruptible(&driver_data.device_allocation))
-			dev_dbg(&pdev->dev, "[%s]: down_interruptible() "
-					"failed", __func__);
-		ret = cryp_disable_power(&pdev->dev, device_data, false);
+			dev_dbg(dev, "[%s]: down_interruptible() failed",
+				__func__);
+		ret = cryp_disable_power(dev, device_data, false);
 
 	} else
-		ret = cryp_disable_power(&pdev->dev, device_data, true);
+		ret = cryp_disable_power(dev, device_data, true);
 
 	if (ret)
-		dev_err(&pdev->dev, "[%s]: cryp_disable_power()", __func__);
+		dev_err(dev, "[%s]: cryp_disable_power()", __func__);
 
 	return ret;
 }
 
-static int ux500_cryp_resume(struct platform_device *pdev)
+static int ux500_cryp_resume(struct device *dev)
 {
 	int ret = 0;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct cryp_device_data *device_data;
 	struct resource *res_irq;
 	struct cryp_ctx *temp_ctx = NULL;
 
-	dev_dbg(&pdev->dev, "[%s]", __func__);
+	dev_dbg(dev, "[%s]", __func__);
 
 	device_data = platform_get_drvdata(pdev);
 	if (!device_data) {
-		dev_err(&pdev->dev, "[%s]: platform_get_drvdata() failed!",
-			__func__);
+		dev_err(dev, "[%s]: platform_get_drvdata() failed!", __func__);
 		return -ENOMEM;
 	}
 
@@ -1730,11 +1729,10 @@ static int ux500_cryp_resume(struct plat
 	if (!device_data->current_ctx)
 		up(&driver_data.device_allocation);
 	else
-		ret = cryp_enable_power(&pdev->dev, device_data, true);
+		ret = cryp_enable_power(dev, device_data, true);
 
 	if (ret)
-		dev_err(&pdev->dev, "[%s]: cryp_enable_power() failed!",
-			__func__);
+		dev_err(dev, "[%s]: cryp_enable_power() failed!", __func__);
 	else {
 		res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 		if (res_irq)
@@ -1744,15 +1742,16 @@ static int ux500_cryp_resume(struct plat
 	return ret;
 }
 
+static SIMPLE_DEV_PM_OPS(ux500_cryp_pm, ux500_cryp_suspend, ux500_cryp_resume);
+
 static struct platform_driver cryp_driver = {
 	.probe  = ux500_cryp_probe,
 	.remove = ux500_cryp_remove,
 	.shutdown = ux500_cryp_shutdown,
-	.suspend  = ux500_cryp_suspend,
-	.resume   = ux500_cryp_resume,
 	.driver = {
 		.owner = THIS_MODULE,
 		.name  = "cryp1"
+		.pm    = &ux500_cryp_pm,
 	}
 };
 
Index: linux/drivers/crypto/ux500/hash/hash_core.c
===================================================================
--- linux.orig/drivers/crypto/ux500/hash/hash_core.c
+++ linux/drivers/crypto/ux500/hash/hash_core.c
@@ -1894,19 +1894,17 @@ static void ux500_hash_shutdown(struct p
 
 /**
  * ux500_hash_suspend - Function that suspends the hash device.
- * @pdev:	The platform device.
- * @state:	-
+ * @dev:	Device to suspend.
  */
-static int ux500_hash_suspend(struct platform_device *pdev, pm_message_t state)
+static int ux500_hash_suspend(struct device *dev)
 {
 	int ret;
 	struct hash_device_data *device_data;
 	struct hash_ctx *temp_ctx = NULL;
 
-	device_data = platform_get_drvdata(pdev);
+	device_data = platform_get_drvdata(to_platform_device(dev));
 	if (!device_data) {
-		dev_err(&pdev->dev, "[%s] platform_get_drvdata() failed!",
-				__func__);
+		dev_err(dev, "[%s] platform_get_drvdata() failed!", __func__);
 		return -ENOMEM;
 	}
 
@@ -1917,33 +1915,32 @@ static int ux500_hash_suspend(struct pla
 
 	if (device_data->current_ctx == ++temp_ctx) {
 		if (down_interruptible(&driver_data.device_allocation))
-			dev_dbg(&pdev->dev, "[%s]: down_interruptible() "
-					"failed", __func__);
+			dev_dbg(dev, "[%s]: down_interruptible() failed",
+				__func__);
 		ret = hash_disable_power(device_data, false);
 
 	} else
 		ret = hash_disable_power(device_data, true);
 
 	if (ret)
-		dev_err(&pdev->dev, "[%s]: hash_disable_power()", __func__);
+		dev_err(dev, "[%s]: hash_disable_power()", __func__);
 
 	return ret;
 }
 
 /**
  * ux500_hash_resume - Function that resume the hash device.
- * @pdev:	The platform device.
+ * @dev:	Device to resume.
  */
-static int ux500_hash_resume(struct platform_device *pdev)
+static int ux500_hash_resume(struct device *dev)
 {
 	int ret = 0;
 	struct hash_device_data *device_data;
 	struct hash_ctx *temp_ctx = NULL;
 
-	device_data = platform_get_drvdata(pdev);
+	device_data = platform_get_drvdata(to_platform_device(dev));
 	if (!device_data) {
-		dev_err(&pdev->dev, "[%s] platform_get_drvdata() failed!",
-				__func__);
+		dev_err(dev, "[%s] platform_get_drvdata() failed!", __func__);
 		return -ENOMEM;
 	}
 
@@ -1958,21 +1955,21 @@ static int ux500_hash_resume(struct plat
 		ret = hash_enable_power(device_data, true);
 
 	if (ret)
-		dev_err(&pdev->dev, "[%s]: hash_enable_power() failed!",
-			__func__);
+		dev_err(dev, "[%s]: hash_enable_power() failed!", __func__);
 
 	return ret;
 }
 
+static SIMPLE_DEV_PM_OPS(ux500_hash_pm, ux500_hash_suspend, ux500_hash_resume);
+
 static struct platform_driver hash_driver = {
 	.probe  = ux500_hash_probe,
 	.remove = ux500_hash_remove,
 	.shutdown = ux500_hash_shutdown,
-	.suspend  = ux500_hash_suspend,
-	.resume   = ux500_hash_resume,
 	.driver = {
 		.owner = THIS_MODULE,
 		.name  = "hash1",
+		.pm    = &ux500_hash_pm,
 	}
 };
 
