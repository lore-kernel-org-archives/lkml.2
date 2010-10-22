Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab0JVS6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:58:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49636 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481Ab0JVS6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:58:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] langwell_gpio: Add support for whitney point
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Fri, 22 Oct 2010 19:03:35 +0100
Message-ID: <20101022180317.11032.46614.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

In this case the logic is very similar but the IRQs are not exposed and the
device is not picked up via PCI

Based on a separate internal whitney point driver by:
    	Yin Kangkai <kangkai.yin@intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpio/langwell_gpio.c |   82 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 81 insertions(+), 1 deletions(-)


diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 8383a8d..b60945f 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -18,10 +18,12 @@
 /* Supports:
  * Moorestown platform Langwell chip.
  * Medfield platform Penwell chip.
+ * Whitney point.
  */
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/stddef.h>
@@ -300,9 +302,87 @@ static struct pci_driver lnw_gpio_driver = {
 	.probe		= lnw_gpio_probe,
 };
 
+
+static int __devinit wp_gpio_probe(struct platform_device *pdev)
+{
+	struct lnw_gpio *lnw;
+	struct gpio_chip *gc;
+	struct resource *rc;
+	int retval = 0;
+
+	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!rc)
+		return -EINVAL;
+
+	lnw = kzalloc(sizeof(struct lnw_gpio), GFP_KERNEL);
+	if (!lnw) {
+		dev_err(&pdev->dev,
+			"can't allocate whitneypoint_gpio chip data\n");
+		return -ENOMEM;
+	}
+	lnw->reg_base = ioremap_nocache(rc->start, resource_size(rc));
+	if (lnw->reg_base == NULL) {
+		retval = -EINVAL;
+		goto err_kmalloc;
+	}
+	spin_lock_init(&lnw->lock);
+	gc = &lnw->chip;
+	gc->label = dev_name(&pdev->dev);
+	gc->owner = THIS_MODULE;
+	gc->direction_input = lnw_gpio_direction_input;
+	gc->direction_output = lnw_gpio_direction_output;
+	gc->get = lnw_gpio_get;
+	gc->set = lnw_gpio_set;
+	gc->to_irq = NULL;
+	gc->base = 0;
+	gc->ngpio = 64;
+	gc->can_sleep = 0;
+	retval = gpiochip_add(gc);
+	if (retval) {
+		dev_err(&pdev->dev, "whitneypoint gpiochip_add error %d\n", retval);
+		goto err_ioremap;
+	}
+	platform_set_drvdata(pdev, lnw);
+	return 0;
+err_ioremap:
+	iounmap(lnw->reg_base);
+err_kmalloc:
+	kfree(lnw);
+	return retval;
+}
+
+static int __devexit wp_gpio_remove(struct platform_device *pdev)
+{
+	struct lnw_gpio *lnw = platform_get_drvdata(pdev);
+	int err;
+	err = gpiochip_remove(&lnw->chip);
+	if (err)
+		dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
+	iounmap(lnw->reg_base);
+	kfree(lnw);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver wp_gpio_driver = {
+	.probe		= wp_gpio_probe,
+	.remove		= __devexit_p(wp_gpio_remove),
+	.driver		= {
+		.name	= "wp_gpio",
+		.owner	= THIS_MODULE,
+	},
+};
+
 static int __init lnw_gpio_init(void)
 {
-	return pci_register_driver(&lnw_gpio_driver);
+	int ret;
+	ret =  pci_register_driver(&lnw_gpio_driver);
+	if (ret < 0)
+		return ret;
+	ret = platform_driver_register(&wp_gpio_driver);
+	if (ret < 0)
+		pci_unregister_driver(&lnw_gpio_driver);
+	return ret;
 }
 
 device_initcall(lnw_gpio_init);

