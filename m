Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab1IQVgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 17:36:23 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43911 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1IQVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 17:36:22 -0400
Subject: [PATCH] Merge pata_of_platform.c into pata_platform.c
To: linux-ide@vger.kernel.org, Dave Martin <dave.martin@linaro.org>,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 17 Sep 2011 15:36:19 -0600
Message-ID: <20110917213532.20710.92002.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for two drivers anymore

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Dave Martin <dave.martin@linaro.org>
COMPILE TESTED ONLY
---
[resend - I flubbed Dave's email address]

Dave, as I mentioned in the other thread, this is the patch that I
hacked together to get rid of pata_of_platform.c.  Can you take over
on this patch please?

 drivers/ata/pata_of_platform.c |  116 ----------------------------------------
 drivers/ata/pata_platform.c    |   60 ++++++++++++++++++---
 include/linux/ata_platform.h   |    9 ---
 3 files changed, 52 insertions(+), 133 deletions(-)
 delete mode 100644 drivers/ata/pata_of_platform.c

diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
deleted file mode 100644
index f305400..0000000
--- a/drivers/ata/pata_of_platform.c
+++ /dev/null
@@ -1,116 +0,0 @@
-/*
- * OF-platform PATA driver
- *
- * Copyright (c) 2007  MontaVista Software, Inc.
- *                     Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License (Version 2) as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/of_platform.h>
-#include <linux/ata_platform.h>
-
-static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
-{
-	int ret;
-	struct device_node *dn = ofdev->dev.of_node;
-	struct resource io_res;
-	struct resource ctl_res;
-	struct resource irq_res;
-	unsigned int reg_shift = 0;
-	int pio_mode = 0;
-	int pio_mask;
-	const u32 *prop;
-
-	ret = of_address_to_resource(dn, 0, &io_res);
-	if (ret) {
-		dev_err(&ofdev->dev, "can't get IO address from "
-			"device tree\n");
-		return -EINVAL;
-	}
-
-	if (of_device_is_compatible(dn, "electra-ide")) {
-		/* Altstatus is really at offset 0x3f6 from the primary window
-		 * on electra-ide. Adjust ctl_res and io_res accordingly.
-		 */
-		ctl_res = io_res;
-		ctl_res.start = ctl_res.start+0x3f6;
-		io_res.end = ctl_res.start-1;
-	} else {
-		ret = of_address_to_resource(dn, 1, &ctl_res);
-		if (ret) {
-			dev_err(&ofdev->dev, "can't get CTL address from "
-				"device tree\n");
-			return -EINVAL;
-		}
-	}
-
-	ret = of_irq_to_resource(dn, 0, &irq_res);
-	if (ret == NO_IRQ)
-		irq_res.start = irq_res.end = 0;
-	else
-		irq_res.flags = 0;
-
-	prop = of_get_property(dn, "reg-shift", NULL);
-	if (prop)
-		reg_shift = *prop;
-
-	prop = of_get_property(dn, "pio-mode", NULL);
-	if (prop) {
-		pio_mode = *prop;
-		if (pio_mode > 6) {
-			dev_err(&ofdev->dev, "invalid pio-mode\n");
-			return -EINVAL;
-		}
-	} else {
-		dev_info(&ofdev->dev, "pio-mode unspecified, assuming PIO0\n");
-	}
-
-	pio_mask = 1 << pio_mode;
-	pio_mask |= (1 << pio_mode) - 1;
-
-	return __pata_platform_probe(&ofdev->dev, &io_res, &ctl_res, &irq_res,
-				     reg_shift, pio_mask);
-}
-
-static int __devexit pata_of_platform_remove(struct platform_device *ofdev)
-{
-	return __pata_platform_remove(&ofdev->dev);
-}
-
-static struct of_device_id pata_of_platform_match[] = {
-	{ .compatible = "ata-generic", },
-	{ .compatible = "electra-ide", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, pata_of_platform_match);
-
-static struct platform_driver pata_of_platform_driver = {
-	.driver = {
-		.name = "pata_of_platform",
-		.owner = THIS_MODULE,
-		.of_match_table = pata_of_platform_match,
-	},
-	.probe		= pata_of_platform_probe,
-	.remove		= __devexit_p(pata_of_platform_remove),
-};
-
-static int __init pata_of_platform_init(void)
-{
-	return platform_driver_register(&pata_of_platform_driver);
-}
-module_init(pata_of_platform_init);
-
-static void __exit pata_of_platform_exit(void)
-{
-	platform_driver_unregister(&pata_of_platform_driver);
-}
-module_exit(pata_of_platform_exit);
-
-MODULE_DESCRIPTION("OF-platform PATA driver");
-MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 2067308..adc435a 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -17,6 +17,7 @@
 #include <linux/blkdev.h>
 #include <scsi/scsi_host.h>
 #include <linux/ata.h>
+#include <linux/of.h>
 #include <linux/libata.h>
 #include <linux/platform_device.h>
 #include <linux/ata_platform.h>
@@ -176,7 +177,6 @@ int __devinit __pata_platform_probe(struct device *dev,
 	return ata_host_activate(host, irq, irq ? ata_sff_interrupt : NULL,
 				 irq_flags, &pata_platform_sht);
 }
-EXPORT_SYMBOL_GPL(__pata_platform_probe);
 
 /**
  *	__pata_platform_remove		-	unplug a platform interface
@@ -185,7 +185,7 @@ EXPORT_SYMBOL_GPL(__pata_platform_probe);
  *	A platform bus ATA device has been unplugged. Perform the needed
  *	cleanup. Also called on module unload for any active devices.
  */
-int __pata_platform_remove(struct device *dev)
+int __devexit __pata_platform_remove(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
 
@@ -193,14 +193,28 @@ int __pata_platform_remove(struct device *dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__pata_platform_remove);
+
+#ifdef CONFIG_OF
+static struct of_device_id pata_platform_match[] = {
+	{ .compatible = "arm,versatile-ata", },
+	{ .compatible = "ata-generic", },
+	{ .compatible = "electra-ide", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pata_platform_match);
+#else
+#define pata_platform_match NULL
+#endif
 
 static int __devinit pata_platform_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct resource *io_res;
 	struct resource *ctl_res;
 	struct resource *irq_res;
 	struct pata_platform_info *pp_info = pdev->dev.platform_data;
+	int local_pio_mask = pio_mask;
+	u32 reg_shift = 0;
 
 	/*
 	 * Simple resource validation ..
@@ -224,11 +238,24 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 	 * Then the CTL base
 	 */
 	ctl_res = platform_get_resource(pdev, IORESOURCE_IO, 1);
-	if (ctl_res == NULL) {
+	if (ctl_res == NULL)
 		ctl_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (unlikely(ctl_res == NULL))
-			return -EINVAL;
+#ifdef CONFIG_OF
+	if ((ctl_res == NULL) && of_device_is_compatible(np, "electra-ide")) {
+		/* electra-ide quirk: Altstatus is really at offset 0x3f6 from
+		 * the primary window. Adjust ctl_res and io_res accordingly. */
+		ctl_res = devm_kzalloc(&pdev->dev, sizeof(*ctl_res) * 2, GFP_KERNEL);
+		if (ctl_res) {
+			ctl_res[0] = *io_res;
+			ctl_res[1] = *io_res;
+			io_res = &ctl_res[1];
+			ctl_res->start += 0x3f6;
+			io_res->end = ctl_res->start - 1;
+		}
 	}
+#endif
+	if (unlikely(ctl_res == NULL))
+		return -EINVAL;
 
 	/*
 	 * And the IRQ
@@ -237,9 +264,25 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 	if (irq_res)
 		irq_res->flags = pp_info ? pp_info->irq_flags : 0;
 
+	/* Parse device tree data if available */
+	if (np) {
+		u32 pio_mode = 0;
+		of_property_read_u32(np, "reg-shift", &reg_shift);
+		if (of_property_read_u32(np, "pio-mode", &pio_mode) == 0)
+			dev_info(&pdev->dev, "pio-mode unspecified, assuming PIO0\n");
+		if (pio_mode > 6) {
+			dev_err(&pdev->dev, "invalid pio-mode\n");
+			return -EINVAL;
+		}
+		local_pio_mask = (1 << (pio_mode + 1)) - 1;
+	}
+
+	/* Platform data takes precedence if available */
+	if (pp_info)
+		reg_shift = pp_info->ioport_shift;
+
 	return __pata_platform_probe(&pdev->dev, io_res, ctl_res, irq_res,
-				     pp_info ? pp_info->ioport_shift : 0,
-				     pio_mask);
+				     reg_shift, local_pio_mask);
 }
 
 static int __devexit pata_platform_remove(struct platform_device *pdev)
@@ -253,6 +296,7 @@ static struct platform_driver pata_platform_driver = {
 	.driver = {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
+		.of_match_table = pata_platform_match,
 	},
 };
 
diff --git a/include/linux/ata_platform.h b/include/linux/ata_platform.h
index 9a26c83..1e83a7f 100644
--- a/include/linux/ata_platform.h
+++ b/include/linux/ata_platform.h
@@ -15,15 +15,6 @@ struct pata_platform_info {
 	unsigned int irq_flags;
 };
 
-extern int __devinit __pata_platform_probe(struct device *dev,
-					   struct resource *io_res,
-					   struct resource *ctl_res,
-					   struct resource *irq_res,
-					   unsigned int ioport_shift,
-					   int __pio_mask);
-
-extern int __devexit __pata_platform_remove(struct device *dev);
-
 /*
  * Marvell SATA private data
  */

