Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1KEV2E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 17:28:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47136 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750860Ab1KEV2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 17:28:01 -0400
X-Authenticated: #1242716
X-Provags-ID: V01U2FsdGVkX1/26ssbCmH2ZtKfKrjPgr/b/daQbnq/xFbMZvTVbF
	BRujjP81J38PZJ
Message-ID: <4EB5AA5E.8020707@gmx.de>
Date: Sat, 05 Nov 2011 22:27:58 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: [Patch 2/2] gpiolib: output basic details and consolidate gpio device
 drivers
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes duplicate kernel messages, which are now output by gpiolib from the following drivers:
	* gpio-adp5588
	* gpio-bt8xx
	* gpio-cs5535
	* gpio-janz-ttl
	* gpio-nomadik
	* gpio-pcf857x
	* gpio-xilinx
	* drivers/of/gpio.c (I hope that is OK with you)

Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
-------------------------------------------------------------
diff --git a/drivers/gpio/gpio-adp5588.c b/drivers/gpio/gpio-adp5588.c
index 3525ad9..9ad1703 100644
--- a/drivers/gpio/gpio-adp5588.c
+++ b/drivers/gpio/gpio-adp5588.c
@@ -418,9 +418,8 @@ static int __devinit adp5588_gpio_probe(struct i2c_client *client,
 	if (ret)
 		goto err_irq;
 
-	dev_info(&client->dev, "gpios %d..%d (IRQ Base %d) on a %s Rev. %d\n",
-			gc->base, gc->base + gc->ngpio - 1,
-			pdata->irq_base, client->name, revid);
+	dev_info(&client->dev, "IRQ Base: %d Rev.: %d\n",
+			pdata->irq_base, revid);
 
 	if (pdata->setup) {
 		ret = pdata->setup(client, gc->base, gc->ngpio, pdata->context);
diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
index ec57936..5ca4098 100644
--- a/drivers/gpio/gpio-bt8xx.c
+++ b/drivers/gpio/gpio-bt8xx.c
@@ -223,9 +223,6 @@ static int bt8xxgpio_probe(struct pci_dev *dev,
 		goto err_release_mem;
 	}
 
-	printk(KERN_INFO "bt8xxgpio: Abusing BT8xx card for GPIOs %d to %d\n",
-	       bg->gpio.base, bg->gpio.base + BT8XXGPIO_NR_GPIOS - 1);
-
 	return 0;
 
 err_release_mem:
diff --git a/drivers/gpio/gpio-cs5535.c b/drivers/gpio/gpio-cs5535.c
index 6e16cba..693a81b 100644
--- a/drivers/gpio/gpio-cs5535.c
+++ b/drivers/gpio/gpio-cs5535.c
@@ -347,7 +347,6 @@ static int __devinit cs5535_gpio_probe(struct platform_device *pdev)
 	if (err)
 		goto release_region;
 
-	dev_info(&pdev->dev, "GPIO support successfully loaded.\n");
 	return 0;
 
 release_region:
diff --git a/drivers/gpio/gpio-janz-ttl.c b/drivers/gpio/gpio-janz-ttl.c
index 813ac07..6f7fda0 100644
--- a/drivers/gpio/gpio-janz-ttl.c
+++ b/drivers/gpio/gpio-janz-ttl.c
@@ -201,8 +201,6 @@ static int __devinit ttl_probe(struct platform_device *pdev)
 		goto out_iounmap_regs;
 	}
 
-	dev_info(&pdev->dev, "module %d: registered GPIO device\n",
-			     pdata->modno);
 	return 0;
 
 out_iounmap_regs:
diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index 1ebedfb..839624f 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -1150,8 +1150,8 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 	nmk_gpio_init_irq(nmk_chip);
 
-	dev_info(&dev->dev, "Bits %i-%i at address %p\n",
-		 nmk_chip->chip.base, nmk_chip->chip.base+31, nmk_chip->addr);
+	dev_info(&dev->dev, "at address %p\n",
+		 nmk_chip->addr);
 	return 0;
 
 out_free:
diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 7369fdd..083bede 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -289,10 +289,7 @@ static int pcf857x_probe(struct i2c_client *client,
 	 * methods can't be called from sleeping contexts.
 	 */
 
-	dev_info(&client->dev, "gpios %d..%d on a %s%s\n",
-			gpio->chip.base,
-			gpio->chip.base + gpio->chip.ngpio - 1,
-			client->name,
+	dev_info(&client->dev, "%s\n",
 			client->irq ? " (irq ignored)" : "");
 
 	/* Let platform code set up the GPIOs and their users.
diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 846fbd5..0a22418 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -205,7 +205,6 @@ static int __devinit xgpio_of_probe(struct device_node *np)
 		       np->full_name, status);
 		return status;
 	}
-	pr_info("XGpio: %s: registered\n", np->full_name);
 	return 0;
 }
 
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index ef0105f..ea4f2fa 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -198,8 +198,6 @@ int of_mm_gpiochip_add(struct device_node *np,
 	if (ret)
 		goto err2;
 
-	pr_debug("%s: registered as generic GPIO chip, base is %d\n",
-		 np->full_name, gc->base);
 	return 0;
 err2:
 	iounmap(mm_gc->regs);

