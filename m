Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0JWHlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 03:41:20 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:53947 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0JWHlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 03:41:18 -0400
Date: Sat, 23 Oct 2010 00:41:14 -0700
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dsd@laptop.org, cjb@laptop.org
Subject: [PATCH 3/4] cs5535-mfgpt: convert from pci device to platform
 device
Message-ID: <20101023004114.5db539e2@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The cs5535-mfd driver now takes care of the PCI BAR handling; this
simplifies the mfgpt driver a bunch.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/misc/cs5535-mfgpt.c |   73 ++++++++++++------------------------------
 1 files changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index 6f62180..499bd64 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -16,12 +16,11 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
-#include <linux/pci.h>
+#include <linux/platform_device.h>
 #include <linux/cs5535.h>
 #include <linux/slab.h>
 
 #define DRV_NAME "cs5535-mfgpt"
-#define MFGPT_BAR 2
 
 static int mfgpt_reset_timers;
 module_param_named(mfgptfix, mfgpt_reset_timers, int, 0644);
@@ -37,7 +36,7 @@ static struct cs5535_mfgpt_chip {
 	DECLARE_BITMAP(avail, MFGPT_MAX_TIMERS);
 	resource_size_t base;
 
-	struct pci_dev *pdev;
+	struct platform_device *pdev;
 	spinlock_t lock;
 	int initialized;
 } cs5535_mfgpt_chip;
@@ -290,10 +289,10 @@ static int __init scan_timers(struct cs5535_mfgpt_chip *mfgpt)
 	return timers;
 }
 
-static int __init cs5535_mfgpt_probe(struct pci_dev *pdev,
-		const struct pci_device_id *pci_id)
+static int __devinit cs5535_mfgpt_probe(struct platform_device *pdev)
 {
-	int err, t;
+	struct resource *res;
+	int err = -EIO, t;
 
 	/* There are two ways to get the MFGPT base address; one is by
 	 * fetching it from MSR_LBAR_MFGPT, the other is by reading the
@@ -302,29 +301,28 @@ static int __init cs5535_mfgpt_probe(struct pci_dev *pdev,
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
 
-	err = pci_request_region(pdev, MFGPT_BAR, DRV_NAME);
-	if (err) {
-		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", MFGPT_BAR);
+	if (!request_region(res->start, resource_size(res), pdev->name)) {
+		dev_err(&pdev->dev, "can't request region\n");
 		goto done;
 	}
 
 	/* set up the driver-specific struct */
-	cs5535_mfgpt_chip.base = pci_resource_start(pdev, MFGPT_BAR);
+	cs5535_mfgpt_chip.base = res->start;
 	cs5535_mfgpt_chip.pdev = pdev;
 	spin_lock_init(&cs5535_mfgpt_chip.lock);
 
-	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", MFGPT_BAR,
-			(unsigned long long) cs5535_mfgpt_chip.base);
+	dev_info(&pdev->dev, "region 0x%x - 0x%x reserved\n", res->start,
+			res->end);
 
 	/* detect the available timers */
 	t = scan_timers(&cs5535_mfgpt_chip);
-	dev_info(&pdev->dev, DRV_NAME ": %d MFGPT timers available\n", t);
+	dev_info(&pdev->dev, "%d MFGPT timers available\n", t);
 	cs5535_mfgpt_chip.initialized = 1;
 	return 0;
 
@@ -332,47 +330,18 @@ done:
 	return err;
 }
 
-static struct pci_device_id cs5535_mfgpt_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
-	{ 0, },
+static struct platform_driver cs5535_mfgpt_drv = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = cs5535_mfgpt_probe,
 };
-MODULE_DEVICE_TABLE(pci, cs5535_mfgpt_pci_tbl);
 
-/*
- * Just like with the cs5535-gpio driver, we can't use the standard PCI driver
- * registration stuff.  It only allows only one driver to bind to each PCI
- * device, and we want the GPIO and MFGPT drivers to be able to share a PCI
- * device.  Instead, we manually scan for the PCI device, request a single
- * region, and keep track of the devices that we're using.
- */
-
-static int __init cs5535_mfgpt_scan_pci(void)
-{
-	struct pci_dev *pdev;
-	int err = -ENODEV;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(cs5535_mfgpt_pci_tbl); i++) {
-		pdev = pci_get_device(cs5535_mfgpt_pci_tbl[i].vendor,
-				cs5535_mfgpt_pci_tbl[i].device, NULL);
-		if (pdev) {
-			err = cs5535_mfgpt_probe(pdev,
-					&cs5535_mfgpt_pci_tbl[i]);
-			if (err)
-				pci_dev_put(pdev);
-
-			/* we only support a single CS5535/6 southbridge */
-			break;
-		}
-	}
-
-	return err;
-}
 
 static int __init cs5535_mfgpt_init(void)
 {
-	return cs5535_mfgpt_scan_pci();
+	return platform_driver_register(&cs5535_mfgpt_drv);
 }
 
 module_init(cs5535_mfgpt_init);
-- 
1.7.1

