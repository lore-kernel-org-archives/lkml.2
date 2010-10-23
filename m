Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0JWHla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 03:41:30 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51484 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab0JWHl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 03:41:29 -0400
Date: Sat, 23 Oct 2010 00:41:19 -0700
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dsd@laptop.org, cjb@laptop.org
Subject: [PATCH 4/4] x86: OLPC: convert olpc-xo1 driver from pci device to
 platform device
Message-ID: <20101023004119.5b4f13ef@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The cs5535-mfd driver now takes care of the PCI BAR handling; this
means the olpc-xo1 driver shouldn't be touching the PCI device at all.

This patch uses both cs5535-acpi and cs5535-pms platform devices rather
than a single platform device because the cs5535-mfd driver may be used
by other CS5535 platform-specific drivers; OLPC doesn't get to dictate
that ACPI and PMS will always be used together.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig           |    2 +-
 arch/x86/kernel/olpc-xo1.c |  101 ++++++++++++++++++++++++--------------------
 2 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dfabfef..7ad6666 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2038,7 +2038,7 @@ config OLPC
 
 config OLPC_XO1
 	tristate "OLPC XO-1 support"
-	depends on OLPC && PCI
+	depends on OLPC && MFD_CS5535
 	---help---
 	  Add support for non-essential features of the OLPC XO-1 laptop.
 
diff --git a/arch/x86/kernel/olpc-xo1.c b/arch/x86/kernel/olpc-xo1.c
index f5442c0..1277756 100644
--- a/arch/x86/kernel/olpc-xo1.c
+++ b/arch/x86/kernel/olpc-xo1.c
@@ -1,6 +1,7 @@
 /*
  * Support for features of the OLPC XO-1 laptop
  *
+ * Copyright (C) 2010 Andres Salomon <dilinger@queued.net>
  * Copyright (C) 2010 One Laptop per Child
  * Copyright (C) 2006 Red Hat, Inc.
  * Copyright (C) 2006 Advanced Micro Devices, Inc.
@@ -12,8 +13,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/pci_ids.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 
@@ -22,9 +21,6 @@
 
 #define DRV_NAME "olpc-xo1"
 
-#define PMS_BAR		4
-#define ACPI_BAR	5
-
 /* PMC registers (PMS block) */
 #define PM_SCLK		0x10
 #define PM_IN_SLPCTL	0x20
@@ -57,65 +53,67 @@ static void xo1_power_off(void)
 	outl(0x00002000, acpi_base + PM1_CNT);
 }
 
-/* Read the base addresses from the PCI BAR info */
-static int __devinit setup_bases(struct pci_dev *pdev)
+static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 {
-	int r;
+	struct resource *res;
 
-	r = pci_enable_device_io(pdev);
-	if (r) {
-		dev_err(&pdev->dev, "can't enable device IO\n");
-		return r;
-	}
+	/* don't run on non-XOs */
+	if (!machine_is_olpc())
+		return -ENODEV;
 
-	r = pci_request_region(pdev, ACPI_BAR, DRV_NAME);
-	if (r) {
-		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", ACPI_BAR);
-		return r;
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -EIO;
 	}
 
-	r = pci_request_region(pdev, PMS_BAR, DRV_NAME);
-	if (r) {
-		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", PMS_BAR);
-		pci_release_region(pdev, ACPI_BAR);
-		return r;
+	if (!request_region(res->start, resource_size(res), DRV_NAME)) {
+		dev_err(&pdev->dev, "can't request region\n");
+		return -EIO;
 	}
 
-	acpi_base = pci_resource_start(pdev, ACPI_BAR);
-	pms_base = pci_resource_start(pdev, PMS_BAR);
+	if (strcmp(pdev->name, "cs5535-pms") == 0)
+		pms_base = res->start;
+	else if (strcmp(pdev->name, "cs5535-acpi") == 0)
+		acpi_base = res->start;
+
+	/* If we have both addresses, we can override the poweroff hook */
+	if (pms_base && acpi_base) {
+		pm_power_off = xo1_power_off;
+		printk(KERN_INFO "OLPC XO-1 support registered\n");
+	}
 
 	return 0;
 }
 
-static int __devinit olpc_xo1_probe(struct platform_device *pdev)
+static int __devexit olpc_xo1_remove(struct platform_device *pdev)
 {
-	struct pci_dev *pcidev;
-	int r;
-
-	pcidev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
-				NULL);
-	if (!pdev)
-		return -ENODEV;
-
-	r = setup_bases(pcidev);
-	if (r)
-		return r;
+	struct resource *r;
 
-	pm_power_off = xo1_power_off;
+	r = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	release_region(r->start, resource_size(r));
 
-	printk(KERN_INFO "OLPC XO-1 support registered\n");
-	return 0;
-}
+	if (strcmp(pdev->name, "cs5535-pms") == 0)
+		pms_base = 0;
+	else if (strcmp(pdev->name, "cs5535-acpi") == 0)
+		acpi_base = 0;
 
-static int __devexit olpc_xo1_remove(struct platform_device *pdev)
-{
 	pm_power_off = NULL;
 	return 0;
 }
 
-static struct platform_driver olpc_xo1_driver = {
+static struct platform_driver cs5535_pms_drv = {
+	.driver = {
+		.name = "cs5535-pms",
+		.owner = THIS_MODULE,
+	},
+	.probe = olpc_xo1_probe,
+	.remove = __devexit_p(olpc_xo1_remove),
+};
+
+static struct platform_driver cs5535_acpi_drv = {
 	.driver = {
-		.name = DRV_NAME,
+		.name = "cs5535-acpi",
 		.owner = THIS_MODULE,
 	},
 	.probe = olpc_xo1_probe,
@@ -124,12 +122,23 @@ static struct platform_driver olpc_xo1_driver = {
 
 static int __init olpc_xo1_init(void)
 {
-	return platform_driver_register(&olpc_xo1_driver);
+	int r;
+
+	r = platform_driver_register(&cs5535_pms_drv);
+	if (r)
+		return r;
+
+	r = platform_driver_register(&cs5535_acpi_drv);
+	if (r)
+		platform_driver_unregister(&cs5535_pms_drv);
+
+	return r;
 }
 
 static void __exit olpc_xo1_exit(void)
 {
-	platform_driver_unregister(&olpc_xo1_driver);
+	platform_driver_unregister(&cs5535_acpi_drv);
+	platform_driver_unregister(&cs5535_pms_drv);
 }
 
 MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
-- 
1.7.1

