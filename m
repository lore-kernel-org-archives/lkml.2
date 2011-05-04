Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1EDPHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:07:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61363 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1EDPHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:07:50 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, cbouatmailru@gmail.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, arnd@arndb.de, nico@fluxnic.net,
        alan@lxorguk.ukuu.org.uk, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 2/3] gpio/bt8xxgpio: convert to use basic_mmio_gpio library
Date: Wed,  4 May 2011 16:07:36 +0100
Message-Id: <1304521657-8527-3-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304521657-8527-1-git-send-email-jamie@jamieiles.com>
References: <1304521657-8527-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the basic_mmio_gpio library for the register accesses.  The driver
itself is now only concerned with PCI and hardware initialisation.
---
 drivers/gpio/Kconfig     |    1 +
 drivers/gpio/bt8xxgpio.c |  119 ++++++++++------------------------------------
 2 files changed, 26 insertions(+), 94 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index ca16a30..898cdb2 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -332,6 +332,7 @@ config GPIO_CS5535
 config GPIO_BT8XX
 	tristate "BT8XX GPIO abuser"
 	depends on PCI && VIDEO_BT848=n
+	select GPIO_BASIC_MMIO_CORE
 	help
 	  The BT8xx frame grabber chip has 24 GPIO pins than can be abused
 	  as a cheap PCI GPIO card.
diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
index aa4f09a..63ed0cb 100644
--- a/drivers/gpio/bt8xxgpio.c
+++ b/drivers/gpio/bt8xxgpio.c
@@ -43,11 +43,13 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/basic_mmio_gpio.h>
 
 /* Steal the hardware definitions from the bttv driver. */
 #include "../media/video/bt8xx/bt848.h"
@@ -61,7 +63,7 @@ struct bt8xxgpio {
 
 	void __iomem *mmio;
 	struct pci_dev *pdev;
-	struct gpio_chip gpio;
+	struct bgpio_chip bgc;
 
 #ifdef CONFIG_PM
 	u32 saved_outen;
@@ -77,101 +79,23 @@ static int modparam_gpiobase = -1/* dynamic */;
 module_param_named(gpiobase, modparam_gpiobase, int, 0444);
 MODULE_PARM_DESC(gpiobase, "The GPIO number base. -1 means dynamic, which is the default.");
 
-
-static int bt8xxgpio_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
+static int bt8xxgpio_gpio_setup(struct bt8xxgpio *bg)
 {
-	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
-	unsigned long flags;
-	u32 outen, data;
-
-	spin_lock_irqsave(&bg->lock, flags);
-
-	data = bgread(BT848_GPIO_DATA);
-	data &= ~(1 << nr);
-	bgwrite(data, BT848_GPIO_DATA);
-
-	outen = bgread(BT848_GPIO_OUT_EN);
-	outen &= ~(1 << nr);
-	bgwrite(outen, BT848_GPIO_OUT_EN);
-
-	spin_unlock_irqrestore(&bg->lock, flags);
-
-	return 0;
-}
-
-static int bt8xxgpio_gpio_get(struct gpio_chip *gpio, unsigned nr)
-{
-	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
-	unsigned long flags;
-	u32 val;
-
-	spin_lock_irqsave(&bg->lock, flags);
-	val = bgread(BT848_GPIO_DATA);
-	spin_unlock_irqrestore(&bg->lock, flags);
-
-	return !!(val & (1 << nr));
-}
-
-static int bt8xxgpio_gpio_direction_output(struct gpio_chip *gpio,
-					unsigned nr, int val)
-{
-	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
-	unsigned long flags;
-	u32 outen, data;
-
-	spin_lock_irqsave(&bg->lock, flags);
-
-	outen = bgread(BT848_GPIO_OUT_EN);
-	outen |= (1 << nr);
-	bgwrite(outen, BT848_GPIO_OUT_EN);
+	void __iomem *dir_out = bg->mmio + BT848_GPIO_OUT_EN;
+	void __iomem *dat = bg->mmio + BT848_GPIO_DATA;
+	int err;
 
-	data = bgread(BT848_GPIO_DATA);
-	if (val)
-		data |= (1 << nr);
-	else
-		data &= ~(1 << nr);
-	bgwrite(data, BT848_GPIO_DATA);
+	err = bgpio_init(&bg->bgc, &bg->pdev->dev, 4, dat, NULL, NULL,
+			 dir_out, NULL, 0);
+	if (err)
+		return err;
 
-	spin_unlock_irqrestore(&bg->lock, flags);
+	bg->bgc.gc.base = modparam_gpiobase;
+	bg->bgc.gc.ngpio = BT8XXGPIO_NR_GPIOS;
 
 	return 0;
 }
 
-static void bt8xxgpio_gpio_set(struct gpio_chip *gpio,
-			    unsigned nr, int val)
-{
-	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
-	unsigned long flags;
-	u32 data;
-
-	spin_lock_irqsave(&bg->lock, flags);
-
-	data = bgread(BT848_GPIO_DATA);
-	if (val)
-		data |= (1 << nr);
-	else
-		data &= ~(1 << nr);
-	bgwrite(data, BT848_GPIO_DATA);
-
-	spin_unlock_irqrestore(&bg->lock, flags);
-}
-
-static void bt8xxgpio_gpio_setup(struct bt8xxgpio *bg)
-{
-	struct gpio_chip *c = &bg->gpio;
-
-	c->label = dev_name(&bg->pdev->dev);
-	c->owner = THIS_MODULE;
-	c->direction_input = bt8xxgpio_gpio_direction_input;
-	c->get = bt8xxgpio_gpio_get;
-	c->direction_output = bt8xxgpio_gpio_direction_output;
-	c->set = bt8xxgpio_gpio_set;
-	c->dbg_show = NULL;
-	c->base = modparam_gpiobase;
-	c->ngpio = BT8XXGPIO_NR_GPIOS;
-	c->can_sleep = 0;
-}
-
 static int bt8xxgpio_probe(struct pci_dev *dev,
 			const struct pci_device_id *pci_id)
 {
@@ -216,18 +140,25 @@ static int bt8xxgpio_probe(struct pci_dev *dev,
 	bgwrite(0, BT848_GPIO_REG_INP);
 	bgwrite(0, BT848_GPIO_OUT_EN);
 
-	bt8xxgpio_gpio_setup(bg);
-	err = gpiochip_add(&bg->gpio);
+	err = bt8xxgpio_gpio_setup(bg);
 	if (err) {
-		printk(KERN_ERR "bt8xxgpio: Failed to register GPIOs\n");
+		printk(KERN_ERR "bt8xxgpio: Failed to init GPIOs\n");
 		goto err_release_mem;
 	}
 
+	err = gpiochip_add(&bg->bgc.gc);
+	if (err) {
+		printk(KERN_ERR "bt8xxgpio: Failed to register GPIOs\n");
+		goto err_release_bgc;
+	}
+
 	printk(KERN_INFO "bt8xxgpio: Abusing BT8xx card for GPIOs %d to %d\n",
-	       bg->gpio.base, bg->gpio.base + BT8XXGPIO_NR_GPIOS - 1);
+	       bg->bgc.gc.base, bg->bgc.gc.base + BT8XXGPIO_NR_GPIOS - 1);
 
 	return 0;
 
+err_release_bgc:
+	bgpio_remove(&bg->bgc);
 err_release_mem:
 	release_mem_region(pci_resource_start(dev, 0),
 			   pci_resource_len(dev, 0));
@@ -244,7 +175,7 @@ static void bt8xxgpio_remove(struct pci_dev *pdev)
 {
 	struct bt8xxgpio *bg = pci_get_drvdata(pdev);
 
-	gpiochip_remove(&bg->gpio);
+	bgpio_remove(&bg->bgc);
 
 	bgwrite(0, BT848_INT_MASK);
 	bgwrite(~0x0, BT848_INT_STAT);
-- 
1.7.4.4

