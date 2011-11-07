Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1KGMXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:23:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab1KGMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:23:41 -0500
From: Michal Simek <monstr@monstr.eu>
To: devicetree-discuss@lists.ozlabs.org
Cc: grant.likely@secretlab.ca, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] of: gpio: Add support for dual xilinx GPIO
Date: Mon,  7 Nov 2011 13:23:36 +0100
Message-Id: <1320668616-12225-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register new gpiochip for the second channel.

The first channel name is: /plb@0/gpio@81420000
The second channel name is: /plb@0/gpio@81420008

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/gpio/xilinx_gpio.c |   84 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/xilinx_gpio.c b/drivers/gpio/xilinx_gpio.c
index 846fbd5..a92f9f6 100644
--- a/drivers/gpio/xilinx_gpio.c
+++ b/drivers/gpio/xilinx_gpio.c
@@ -25,10 +25,13 @@
 #define XGPIO_DATA_OFFSET   (0x0)	/* Data register  */
 #define XGPIO_TRI_OFFSET    (0x4)	/* I/O direction register  */
 
+#define XGPIO_CHANNEL_OFFSET	0x8
+
 struct xgpio_instance {
 	struct of_mm_gpio_chip mmchip;
 	u32 gpio_state;		/* GPIO state shadow register */
 	u32 gpio_dir;		/* GPIO direction shadow register */
+	u32 offset;
 	spinlock_t gpio_lock;	/* Lock used for synchronization */
 };
 
@@ -43,8 +46,11 @@ struct xgpio_instance {
 static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
 
-	return (in_be32(mm_gc->regs + XGPIO_DATA_OFFSET) >> gpio) & 1;
+	return (in_be32(mm_gc->regs + chip->offset + XGPIO_DATA_OFFSET)
+								>> gpio) & 1;
 }
 
 /**
@@ -70,7 +76,8 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 		chip->gpio_state |= 1 << gpio;
 	else
 		chip->gpio_state &= ~(1 << gpio);
-	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+	out_be32(mm_gc->regs + chip->offset + XGPIO_DATA_OFFSET,
+							chip->gpio_state);
 
 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
 }
@@ -95,7 +102,7 @@ static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 
 	/* Set the GPIO bit in shadow register and set direction as input */
 	chip->gpio_dir |= (1 << gpio);
-	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	out_be32(mm_gc->regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);
 
 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
 
@@ -126,11 +133,12 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 		chip->gpio_state |= 1 << gpio;
 	else
 		chip->gpio_state &= ~(1 << gpio);
-	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+	out_be32(mm_gc->regs + chip->offset + XGPIO_DATA_OFFSET,
+							chip->gpio_state);
 
 	/* Clear the GPIO bit in shadow register and set direction as output */
 	chip->gpio_dir &= (~(1 << gpio));
-	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	out_be32(mm_gc->regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);
 
 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
 
@@ -146,8 +154,9 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
 
-	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
-	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	out_be32(mm_gc->regs + chip->offset + XGPIO_DATA_OFFSET,
+							chip->gpio_state);
+	out_be32(mm_gc->regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);
 }
 
 /**
@@ -205,7 +214,66 @@ static int __devinit xgpio_of_probe(struct device_node *np)
 		       np->full_name, status);
 		return status;
 	}
-	pr_info("XGpio: %s: registered\n", np->full_name);
+
+	pr_info("XGpio: %s: registered, base is %d\n", np->full_name,
+							chip->mmchip.gc.base);
+
+	tree_info = of_get_property(np, "xlnx,is-dual", NULL);
+	if (tree_info && be32_to_cpup(tree_info)) {
+		/* Distinguish dual gpio chip */
+		/* NOTE baseaddr ends with zero address XGPIO_CHANNEL_OFFSET */
+		np->full_name[strlen(np->full_name) - 1] = '8';
+
+		chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+		if (!chip)
+			return -ENOMEM;
+
+		/* Add dual channel offset */
+		chip->offset = XGPIO_CHANNEL_OFFSET;
+
+		/* Update GPIO state shadow register with default value */
+		tree_info = of_get_property(np, "xlnx,dout-default-2", NULL);
+		if (tree_info)
+			chip->gpio_state = be32_to_cpup(tree_info);
+
+		/* Update GPIO direction shadow register with default value */
+		/* By default, all pins are inputs */
+		chip->gpio_dir = 0xFFFFFFFF;
+		tree_info = of_get_property(np, "xlnx,tri-default-2", NULL);
+		if (tree_info)
+			chip->gpio_dir = be32_to_cpup(tree_info);
+
+		/* Check device node and parent device node for device width */
+		/* By default assume full GPIO controller */
+		chip->mmchip.gc.ngpio = 32;
+		tree_info = of_get_property(np, "xlnx,gpio2-width", NULL);
+		if (!tree_info)
+			tree_info = of_get_property(np->parent,
+						"xlnx,gpio2-width", NULL);
+		if (tree_info)
+			chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);
+
+		spin_lock_init(&chip->gpio_lock);
+
+		chip->mmchip.gc.direction_input = xgpio_dir_in;
+		chip->mmchip.gc.direction_output = xgpio_dir_out;
+		chip->mmchip.gc.get = xgpio_get;
+		chip->mmchip.gc.set = xgpio_set;
+
+		chip->mmchip.save_regs = xgpio_save_regs;
+
+		/* Call the OF gpio helper to setup and register the GPIO dev */
+		status = of_mm_gpiochip_add(np, &chip->mmchip);
+		if (status) {
+			kfree(chip);
+			pr_err("%s: error in probe function with status %d\n",
+			np->full_name, status);
+			return status;
+		}
+		pr_info("XGpio: %s: dual channel registered, base is %d\n",
+					np->full_name, chip->mmchip.gc.base);
+	}
+
 	return 0;
 }
 
-- 
1.7.5.4

