Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab0JWHlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 03:41:17 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:53941 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab0JWHlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 03:41:13 -0400
Date: Sat, 23 Oct 2010 00:41:09 -0700
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dsd@laptop.org, cjb@laptop.org
Subject: [PATCH 2/4] cs5535-gpio: convert from pci device to platform device
Message-ID: <20101023004109.319bbdef@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The cs5535-mfd driver now takes care of the PCI BAR handling; this
simplifies the gpio driver a lot.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/cs5535-gpio.c |   93 +++++++++++++++-----------------------------
 1 files changed, 31 insertions(+), 62 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index e23c068..ea6290f 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -11,13 +11,12 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
-#include <linux/pci.h>
+#include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/cs5535.h>
 
 #define DRV_NAME "cs5535-gpio"
-#define GPIO_BAR 1
 
 /*
  * Some GPIO pins
@@ -46,7 +45,7 @@ static struct cs5535_gpio_chip {
 	struct gpio_chip chip;
 	resource_size_t base;
 
-	struct pci_dev *pdev;
+	struct platform_device *pdev;
 	spinlock_t lock;
 } cs5535_gpio_chip;
 
@@ -226,10 +225,10 @@ static struct cs5535_gpio_chip cs5535_gpio_chip = {
 	},
 };
 
-static int __init cs5535_gpio_probe(struct pci_dev *pdev,
-		const struct pci_device_id *pci_id)
+static int __devinit cs5535_gpio_probe(struct platform_device *pdev)
 {
-	int err;
+	struct resource *res;
+	int err = -EIO;
 	ulong mask_orig = mask;
 
 	/* There are two ways to get the GPIO base address; one is by
@@ -239,25 +238,24 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
 	 * it turns out to be unreliable in the face of crappy BIOSes, we
 	 * can always go back to using MSRs.. */
 
-	err = pci_enable_device_io(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "can't enable device IO\n");
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
 		goto done;
 	}
 
-	err = pci_request_region(pdev, GPIO_BAR, DRV_NAME);
-	if (err) {
-		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", GPIO_BAR);
+	if (!request_region(res->start, resource_size(res), pdev->name)) {
+		dev_err(&pdev->dev, "can't request region\n");
 		goto done;
 	}
 
 	/* set up the driver-specific struct */
-	cs5535_gpio_chip.base = pci_resource_start(pdev, GPIO_BAR);
+	cs5535_gpio_chip.base = res->start;
 	cs5535_gpio_chip.pdev = pdev;
 	spin_lock_init(&cs5535_gpio_chip.lock);
 
-	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", GPIO_BAR,
-			(unsigned long long) cs5535_gpio_chip.base);
+	dev_info(&pdev->dev, "region 0x%x - 0x%x reserved\n",
+			res->start, res->end);
 
 	/* mask out reserved pins */
 	mask &= 0x1F7FFFFF;
@@ -275,78 +273,49 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
 	if (err)
 		goto release_region;
 
-	dev_info(&pdev->dev, DRV_NAME ": GPIO support successfully loaded.\n");
+	dev_info(&pdev->dev, "GPIO support successfully loaded.\n");
 	return 0;
 
 release_region:
-	pci_release_region(pdev, GPIO_BAR);
+	release_region(res->start, resource_size(res));
 done:
 	return err;
 }
 
-static void __exit cs5535_gpio_remove(struct pci_dev *pdev)
+static int __devexit cs5535_gpio_remove(struct platform_device *pdev)
 {
+	struct resource *r;
 	int err;
 
 	err = gpiochip_remove(&cs5535_gpio_chip.chip);
 	if (err) {
 		/* uhh? */
 		dev_err(&pdev->dev, "unable to remove gpio_chip?\n");
+		return err;
 	}
-	pci_release_region(pdev, GPIO_BAR);
-}
-
-static struct pci_device_id cs5535_gpio_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
-	{ 0, },
-};
-MODULE_DEVICE_TABLE(pci, cs5535_gpio_pci_tbl);
 
-/*
- * We can't use the standard PCI driver registration stuff here, since
- * that allows only one driver to bind to each PCI device (and we want
- * multiple drivers to be able to bind to the device).  Instead, manually
- * scan for the PCI device, request a single region, and keep track of the
- * devices that we're using.
- */
-
-static int __init cs5535_gpio_scan_pci(void)
-{
-	struct pci_dev *pdev;
-	int err = -ENODEV;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(cs5535_gpio_pci_tbl); i++) {
-		pdev = pci_get_device(cs5535_gpio_pci_tbl[i].vendor,
-				cs5535_gpio_pci_tbl[i].device, NULL);
-		if (pdev) {
-			err = cs5535_gpio_probe(pdev, &cs5535_gpio_pci_tbl[i]);
-			if (err)
-				pci_dev_put(pdev);
-
-			/* we only support a single CS5535/6 southbridge */
-			break;
-		}
-	}
-
-	return err;
+	r = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	release_region(r->start, resource_size(r));
+	return 0;
 }
 
-static void __exit cs5535_gpio_free_pci(void)
-{
-	cs5535_gpio_remove(cs5535_gpio_chip.pdev);
-	pci_dev_put(cs5535_gpio_chip.pdev);
-}
+static struct platform_driver cs5535_gpio_drv = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = cs5535_gpio_probe,
+	.remove = __devexit_p(cs5535_gpio_remove),
+};
 
 static int __init cs5535_gpio_init(void)
 {
-	return cs5535_gpio_scan_pci();
+	return platform_driver_register(&cs5535_gpio_drv);
 }
 
 static void __exit cs5535_gpio_exit(void)
 {
-	cs5535_gpio_free_pci();
+	platform_driver_unregister(&cs5535_gpio_drv);
 }
 
 module_init(cs5535_gpio_init);
-- 
1.7.1

