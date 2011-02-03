Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1BCE0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:26:38 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:42069 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1BCE0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:26:36 -0500
Date: Wed, 2 Feb 2011 20:26:32 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, dsd@laptop.org
Subject: [PATCH 19/19] cs5535-mfd: add sharing for acpi/pms cells
Message-ID: <20110202202632.522a7c54@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This shows example usage by an mfd client.  Daniel's got the OLPC
patches that actually need the mfd sharing.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/platform/olpc/olpc-xo1.c |   40 ++++++++++++++++--------------------
 drivers/mfd/cs5535-mfd.c          |   39 ++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index 1277756..86da51f 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/mfd/core.h>
 
 #include <asm/io.h>
 #include <asm/olpc.h>
@@ -56,25 +57,24 @@ static void xo1_power_off(void)
 static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	int err;
 
 	/* don't run on non-XOs */
 	if (!machine_is_olpc())
 		return -ENODEV;
 
+	err = mfd_shared_cell_enable(pdev);
+	if (err)
+		return err;
+
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "can't fetch device resource info\n");
 		return -EIO;
 	}
-
-	if (!request_region(res->start, resource_size(res), DRV_NAME)) {
-		dev_err(&pdev->dev, "can't request region\n");
-		return -EIO;
-	}
-
-	if (strcmp(pdev->name, "cs5535-pms") == 0)
+	if (strncmp(pdev->name, "cs5535-pms", strlen("cs5535-pms")) == 0)
 		pms_base = res->start;
-	else if (strcmp(pdev->name, "cs5535-acpi") == 0)
+	else if (strncmp(pdev->name, "cs5535-acpi", strlen("cs5535-acpi")) == 0)
 		acpi_base = res->start;
 
 	/* If we have both addresses, we can override the poweroff hook */
@@ -88,14 +88,11 @@ static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 
 static int __devexit olpc_xo1_remove(struct platform_device *pdev)
 {
-	struct resource *r;
-
-	r = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	release_region(r->start, resource_size(r));
+	mfd_shared_cell_disable(pdev);
 
-	if (strcmp(pdev->name, "cs5535-pms") == 0)
+	if (strncmp(pdev->name, "cs5535-pms", strlen("cs5535-pms")) == 0)
 		pms_base = 0;
-	else if (strcmp(pdev->name, "cs5535-acpi") == 0)
+	else if (strncmp(pdev->name, "cs5535-acpi", strlen("cs5535-acpi")) == 0)
 		acpi_base = 0;
 
 	pm_power_off = NULL;
@@ -104,7 +101,6 @@ static int __devexit olpc_xo1_remove(struct platform_device *pdev)
 
 static struct platform_driver cs5535_pms_drv = {
 	.driver = {
-		.name = "cs5535-pms",
 		.owner = THIS_MODULE,
 	},
 	.probe = olpc_xo1_probe,
@@ -113,7 +109,6 @@ static struct platform_driver cs5535_pms_drv = {
 
 static struct platform_driver cs5535_acpi_drv = {
 	.driver = {
-		.name = "cs5535-acpi",
 		.owner = THIS_MODULE,
 	},
 	.probe = olpc_xo1_probe,
@@ -124,26 +119,27 @@ static int __init olpc_xo1_init(void)
 {
 	int r;
 
-	r = platform_driver_register(&cs5535_pms_drv);
+	r = mfd_shared_platform_driver_register(&cs5535_pms_drv, "cs5535-pms");
 	if (r)
 		return r;
 
-	r = platform_driver_register(&cs5535_acpi_drv);
+	r = mfd_shared_platform_driver_register(&cs5535_acpi_drv,
+			"cs5535-acpi");
 	if (r)
-		platform_driver_unregister(&cs5535_pms_drv);
+		mfd_shared_platform_driver_unregister(&cs5535_pms_drv);
 
 	return r;
 }
 
 static void __exit olpc_xo1_exit(void)
 {
-	platform_driver_unregister(&cs5535_acpi_drv);
-	platform_driver_unregister(&cs5535_pms_drv);
+	mfd_shared_platform_driver_unregister(&cs5535_acpi_drv);
+	mfd_shared_platform_driver_unregister(&cs5535_pms_drv);
 }
 
 MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:olpc-xo1");
+MODULE_ALIAS("platform:cs5535-pms");
 
 module_init(olpc_xo1_init);
 module_exit(olpc_xo1_exit);
diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 59ca6f1..5b08f16 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -39,6 +39,39 @@ enum cs5535_mfd_bars {
 	NR_BARS,
 };
 
+static int cs5535_mfd_res_enable(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -EIO;
+	}
+
+dev_warn(&pdev->dev, "%s(%s) called, requesting %pR\n", __func__, pdev->name, res);
+	if (!request_region(res->start, resource_size(res), DRV_NAME)) {
+		dev_err(&pdev->dev, "can't request region\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int cs5535_mfd_res_disable(struct platform_device *pdev)
+{
+	struct resource *res;
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -EIO;
+	}
+
+dev_warn(&pdev->dev, "%s(%s) called, releasing %pR\n", __func__, pdev->name, res);
+	release_region(res->start, resource_size(res));
+	return 0;
+}
+
 static __devinitdata struct resource cs5535_mfd_resources[NR_BARS];
 
 static __devinitdata struct mfd_cell cs5535_mfd_cells[] = {
@@ -65,12 +98,18 @@ static __devinitdata struct mfd_cell cs5535_mfd_cells[] = {
 		.name = "cs5535-pms",
 		.num_resources = 1,
 		.resources = &cs5535_mfd_resources[PMS_BAR],
+
+		.enable = cs5535_mfd_res_enable,
+		.disable = cs5535_mfd_res_disable,
 	},
 	{
 		.id = ACPI_BAR,
 		.name = "cs5535-acpi",
 		.num_resources = 1,
 		.resources = &cs5535_mfd_resources[ACPI_BAR],
+
+		.enable = cs5535_mfd_res_enable,
+		.disable = cs5535_mfd_res_disable,
 	},
 };
 
-- 
1.7.2.3

