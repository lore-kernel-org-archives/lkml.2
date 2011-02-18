Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1BRDIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:08:31 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51916 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab1BRDIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:20 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH 29/29] cs5535-mfd: add sharing for acpi/pms cells
Date: Thu, 17 Feb 2011 19:07:36 -0800
Message-Id: <1297998456-7615-30-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables sharing of cs5535-mfd cells via the new mfd_shared_* API.
Hooks for enable/disble of resources are added, with refcounting of
resources being automatically handled so that cs5535_mfd_res_enable/disable
are only called when necessary.

Clients of cs5535-mfd (in this case, olpc-xo1.c) are also modified to
use the mfd_shared API.  The platform drivers are also renamed to
olpc-xo1-{pms,acpi}, and resource enabling/disabling is replaced
with mfd_shared API calls.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/platform/olpc/olpc-xo1.c |   42 +++++++++++++++++-------------------
 drivers/mfd/cs5535-mfd.c          |   37 ++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index 1277756..f415535 100644
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
+	if (strcmp(pdev->name, "olpc-xo1-pms") == 0)
 		pms_base = res->start;
-	else if (strcmp(pdev->name, "cs5535-acpi") == 0)
+	else if (strcmp(pdev->name, "olpc-xo1-ac-acpi") == 0)
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
+	if (strcmp(pdev->name, "olpc-xo1-pms") == 0)
 		pms_base = 0;
-	else if (strcmp(pdev->name, "cs5535-acpi") == 0)
+	else if (strcmp(pdev->name, "olpc-xo1-acpi") == 0)
 		acpi_base = 0;
 
 	pm_power_off = NULL;
@@ -104,7 +101,7 @@ static int __devexit olpc_xo1_remove(struct platform_device *pdev)
 
 static struct platform_driver cs5535_pms_drv = {
 	.driver = {
-		.name = "cs5535-pms",
+		.name = "olpc-xo1-pms",
 		.owner = THIS_MODULE,
 	},
 	.probe = olpc_xo1_probe,
@@ -113,7 +110,7 @@ static struct platform_driver cs5535_pms_drv = {
 
 static struct platform_driver cs5535_acpi_drv = {
 	.driver = {
-		.name = "cs5535-acpi",
+		.name = "olpc-xo1-acpi",
 		.owner = THIS_MODULE,
 	},
 	.probe = olpc_xo1_probe,
@@ -124,26 +121,27 @@ static int __init olpc_xo1_init(void)
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
index 59ca6f1..886a068 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -39,6 +39,37 @@ enum cs5535_mfd_bars {
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
+	release_region(res->start, resource_size(res));
+	return 0;
+}
+
 static __devinitdata struct resource cs5535_mfd_resources[NR_BARS];
 
 static __devinitdata struct mfd_cell cs5535_mfd_cells[] = {
@@ -65,12 +96,18 @@ static __devinitdata struct mfd_cell cs5535_mfd_cells[] = {
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

