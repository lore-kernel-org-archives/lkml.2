Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab1CXV2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:28:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:39943 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755085Ab1CXV1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:27:38 -0400
Message-Id: <20110324212509.025730689@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 24 Mar 2011 21:27:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [patch 2/3] gpio: Cleanup genirq namespace
References: <20110324212330.292903803@linutronix.de>
Content-Disposition: inline; filename=gpio-irq-namespace.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/gpio/adp5588-gpio.c |    8 ++++----
 drivers/gpio/max732x.c      |    8 ++++----
 drivers/gpio/pca953x.c      |    6 +++---
 drivers/gpio/pl061.c        |   14 +++++++-------
 drivers/gpio/stmpe-gpio.c   |   12 ++++++------
 drivers/gpio/sx150x.c       |   10 +++++-----
 drivers/gpio/tc3589x-gpio.c |   12 ++++++------
 drivers/gpio/timbgpio.c     |   18 +++++++++---------
 drivers/gpio/vr41xx_giu.c   |   12 ++++++------
 9 files changed, 50 insertions(+), 50 deletions(-)

Index: linux-2.6-tip/drivers/gpio/adp5588-gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/adp5588-gpio.c
+++ linux-2.6-tip/drivers/gpio/adp5588-gpio.c
@@ -289,10 +289,10 @@ static int adp5588_irq_setup(struct adp5
 
 	for (gpio = 0; gpio < dev->gpio_chip.ngpio; gpio++) {
 		int irq = gpio + dev->irq_base;
-		set_irq_chip_data(irq, dev);
-		set_irq_chip_and_handler(irq, &adp5588_irq_chip,
+		irq_set_chip_data(irq, dev);
+		irq_set_chip_and_handler(irq, &adp5588_irq_chip,
 					 handle_level_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		/*
 		 * ARM needs us to explicitly flag the IRQ as VALID,
@@ -300,7 +300,7 @@ static int adp5588_irq_setup(struct adp5
 		 */
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
Index: linux-2.6-tip/drivers/gpio/max732x.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/max732x.c
+++ linux-2.6-tip/drivers/gpio/max732x.c
@@ -470,14 +470,14 @@ static int max732x_irq_setup(struct max7
 			if (!(chip->dir_input & (1 << lvl)))
 				continue;
 
-			set_irq_chip_data(irq, chip);
-			set_irq_chip_and_handler(irq, &max732x_irq_chip,
+			irq_set_chip_data(irq, chip);
+			irq_set_chip_and_handler(irq, &max732x_irq_chip,
 						 handle_edge_irq);
-			set_irq_nested_thread(irq, 1);
+			irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else
-			set_irq_noprobe(irq);
+			irq_set_noprobe(irq);
 #endif
 		}
 
Index: linux-2.6-tip/drivers/gpio/pca953x.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/pca953x.c
+++ linux-2.6-tip/drivers/gpio/pca953x.c
@@ -395,13 +395,13 @@ static int pca953x_irq_setup(struct pca9
 		for (lvl = 0; lvl < chip->gpio_chip.ngpio; lvl++) {
 			int irq = lvl + chip->irq_base;
 
-			set_irq_chip_data(irq, chip);
-			set_irq_chip_and_handler(irq, &pca953x_irq_chip,
+			irq_set_chip_data(irq, chip);
+			irq_set_chip_and_handler(irq, &pca953x_irq_chip,
 						 handle_edge_irq);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else
-			set_irq_noprobe(irq);
+			irq_set_noprobe(irq);
 #endif
 		}
 
Index: linux-2.6-tip/drivers/gpio/pl061.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/pl061.c
+++ linux-2.6-tip/drivers/gpio/pl061.c
@@ -210,7 +210,7 @@ static struct irq_chip pl061_irqchip = {
 
 static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct list_head *chip_list = get_irq_data(irq);
+	struct list_head *chip_list = irq_get_handler_data(irq);
 	struct list_head *ptr;
 	struct pl061_gpio *chip;
 
@@ -294,7 +294,7 @@ static int pl061_probe(struct amba_devic
 		ret = -ENODEV;
 		goto iounmap;
 	}
-	set_irq_chained_handler(irq, pl061_irq_handler);
+	irq_set_chained_handler(irq, pl061_irq_handler);
 	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
 		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
 		if (chip_list == NULL) {
@@ -303,9 +303,9 @@ static int pl061_probe(struct amba_devic
 			goto iounmap;
 		}
 		INIT_LIST_HEAD(chip_list);
-		set_irq_data(irq, chip_list);
+		irq_set_handler_data(irq, chip_list);
 	} else
-		chip_list = get_irq_data(irq);
+		chip_list = irq_get_handler_data(irq);
 	list_add(&chip->list, chip_list);
 
 	for (i = 0; i < PL061_GPIO_NR; i++) {
@@ -315,10 +315,10 @@ static int pl061_probe(struct amba_devic
 		else
 			pl061_direction_input(&chip->gc, i);
 
-		set_irq_chip(i+chip->irq_base, &pl061_irqchip);
-		set_irq_handler(i+chip->irq_base, handle_simple_irq);
+		irq_set_chip(i + chip->irq_base, &pl061_irqchip);
+		irq_set_handler(i + chip->irq_base, handle_simple_irq);
 		set_irq_flags(i+chip->irq_base, IRQF_VALID);
-		set_irq_chip_data(i+chip->irq_base, chip);
+		irq_set_chip_data(i + chip->irq_base, chip);
 	}
 
 	return 0;
Index: linux-2.6-tip/drivers/gpio/stmpe-gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/stmpe-gpio.c
+++ linux-2.6-tip/drivers/gpio/stmpe-gpio.c
@@ -254,14 +254,14 @@ static int __devinit stmpe_gpio_irq_init
 	int irq;
 
 	for (irq = base; irq < base + stmpe_gpio->chip.ngpio; irq++) {
-		set_irq_chip_data(irq, stmpe_gpio);
-		set_irq_chip_and_handler(irq, &stmpe_gpio_irq_chip,
+		irq_set_chip_data(irq, stmpe_gpio);
+		irq_set_chip_and_handler(irq, &stmpe_gpio_irq_chip,
 					 handle_simple_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -277,8 +277,8 @@ static void stmpe_gpio_irq_remove(struct
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip_and_handler(irq, NULL, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
Index: linux-2.6-tip/drivers/gpio/sx150x.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/sx150x.c
+++ linux-2.6-tip/drivers/gpio/sx150x.c
@@ -551,12 +551,12 @@ static int sx150x_install_irq_chip(struc
 
 	for (n = 0; n < chip->dev_cfg->ngpios; ++n) {
 		irq = irq_base + n;
-		set_irq_chip_and_handler(irq, &chip->irq_chip, handle_edge_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_chip_and_handler(irq, &chip->irq_chip, handle_edge_irq);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -583,8 +583,8 @@ static void sx150x_remove_irq_chip(struc
 
 	for (n = 0; n < chip->dev_cfg->ngpios; ++n) {
 		irq = chip->irq_base + n;
-		set_irq_handler(irq, NULL);
-		set_irq_chip(irq, NULL);
+		irq_set_handler(irq, NULL);
+		irq_set_chip(irq, NULL);
 	}
 }
 
Index: linux-2.6-tip/drivers/gpio/tc3589x-gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/tc3589x-gpio.c
+++ linux-2.6-tip/drivers/gpio/tc3589x-gpio.c
@@ -239,14 +239,14 @@ static int tc3589x_gpio_irq_init(struct 
 	int irq;
 
 	for (irq = base; irq < base + tc3589x_gpio->chip.ngpio; irq++) {
-		set_irq_chip_data(irq, tc3589x_gpio);
-		set_irq_chip_and_handler(irq, &tc3589x_gpio_irq_chip,
+		irq_set_chip_data(irq, tc3589x_gpio);
+		irq_set_chip_and_handler(irq, &tc3589x_gpio_irq_chip,
 					 handle_simple_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -262,8 +262,8 @@ static void tc3589x_gpio_irq_remove(stru
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip_and_handler(irq, NULL, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
Index: linux-2.6-tip/drivers/gpio/timbgpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/timbgpio.c
+++ linux-2.6-tip/drivers/gpio/timbgpio.c
@@ -195,7 +195,7 @@ out:
 
 static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = get_irq_data(irq);
+	struct timbgpio *tgpio = irq_get_handler_data(irq);
 	unsigned long ipr;
 	int offset;
 
@@ -291,16 +291,16 @@ static int __devinit timbgpio_probe(stru
 		return 0;
 
 	for (i = 0; i < pdata->nr_pins; i++) {
-		set_irq_chip_and_handler_name(tgpio->irq_base + i,
+		irq_set_chip_and_handler_name(tgpio->irq_base + i,
 			&timbgpio_irqchip, handle_simple_irq, "mux");
-		set_irq_chip_data(tgpio->irq_base + i, tgpio);
+		irq_set_chip_data(tgpio->irq_base + i, tgpio);
 #ifdef CONFIG_ARM
 		set_irq_flags(tgpio->irq_base + i, IRQF_VALID | IRQF_PROBE);
 #endif
 	}
 
-	set_irq_data(irq, tgpio);
-	set_irq_chained_handler(irq, timbgpio_irq);
+	irq_set_handler_data(irq, tgpio);
+	irq_set_chained_handler(irq, timbgpio_irq);
 
 	return 0;
 
@@ -327,12 +327,12 @@ static int __devexit timbgpio_remove(str
 	if (irq >= 0 && tgpio->irq_base > 0) {
 		int i;
 		for (i = 0; i < pdata->nr_pins; i++) {
-			set_irq_chip(tgpio->irq_base + i, NULL);
-			set_irq_chip_data(tgpio->irq_base + i, NULL);
+			irq_set_chip(tgpio->irq_base + i, NULL);
+			irq_set_chip_data(tgpio->irq_base + i, NULL);
 		}
 
-		set_irq_handler(irq, NULL);
-		set_irq_data(irq, NULL);
+		irq_set_handler(irq, NULL);
+		irq_set_handler_data(irq, NULL);
 	}
 
 	err = gpiochip_remove(&tgpio->gpio);
Index: linux-2.6-tip/drivers/gpio/vr41xx_giu.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/vr41xx_giu.c
+++ linux-2.6-tip/drivers/gpio/vr41xx_giu.c
@@ -238,13 +238,13 @@ void vr41xx_set_irq_trigger(unsigned int
 					break;
 				}
 			}
-			set_irq_chip_and_handler(GIU_IRQ(pin),
+			irq_set_chip_and_handler(GIU_IRQ(pin),
 						 &giuint_low_irq_chip,
 						 handle_edge_irq);
 		} else {
 			giu_clear(GIUINTTYPL, mask);
 			giu_clear(GIUINTHTSELL, mask);
-			set_irq_chip_and_handler(GIU_IRQ(pin),
+			irq_set_chip_and_handler(GIU_IRQ(pin),
 						 &giuint_low_irq_chip,
 						 handle_level_irq);
 		}
@@ -273,13 +273,13 @@ void vr41xx_set_irq_trigger(unsigned int
 					break;
 				}
 			}
-			set_irq_chip_and_handler(GIU_IRQ(pin),
+			irq_set_chip_and_handler(GIU_IRQ(pin),
 						 &giuint_high_irq_chip,
 						 handle_edge_irq);
 		} else {
 			giu_clear(GIUINTTYPH, mask);
 			giu_clear(GIUINTHTSELH, mask);
-			set_irq_chip_and_handler(GIU_IRQ(pin),
+			irq_set_chip_and_handler(GIU_IRQ(pin),
 						 &giuint_high_irq_chip,
 						 handle_level_irq);
 		}
@@ -539,9 +539,9 @@ static int __devinit giu_probe(struct pl
 			chip = &giuint_high_irq_chip;
 
 		if (trigger & (1 << pin))
-			set_irq_chip_and_handler(i, chip, handle_edge_irq);
+			irq_set_chip_and_handler(i, chip, handle_edge_irq);
 		else
-			set_irq_chip_and_handler(i, chip, handle_level_irq);
+			irq_set_chip_and_handler(i, chip, handle_level_irq);
 
 	}
 


