Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1FUORf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:17:35 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:58919 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1FUORd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:17:33 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] pch_gpio: transform mutex into spinlock
Date: Tue, 21 Jun 2011 16:17:27 +0200
Message-Id: <1308665847-13924-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_chip.can_sleep is 0, but gpio_set_value & friends lock a mutex. Thus
those functions are not callable from interrupt context.
Changing mutex into spinlock.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
I just noticed that the patch introduced at
http://marc.info/?l=linux-kernel&m=130863151431202&w=2
also added a spinlock. I think those two spinlock can be merged into one.

 drivers/gpio/pch_gpio.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index 36919e7..262c200 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -62,15 +62,16 @@ struct pch_gpio {
 	struct device *dev;
 	struct gpio_chip gpio;
 	struct pch_gpio_reg_data pch_gpio_reg;
-	struct mutex lock;
+	struct spinlock lock;
 };
 
 static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
 {
 	u32 reg_val;
+	unsigned long flags;
 	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->lock, flags);
 	reg_val = ioread32(&chip->reg->po);
 	if (val)
 		reg_val |= (1 << nr);
@@ -78,7 +79,7 @@ static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
 		reg_val &= ~(1 << nr);
 
 	iowrite32(reg_val, &chip->reg->po);
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->lock, flags);
 }
 
 static int pch_gpio_get(struct gpio_chip *gpio, unsigned nr)
@@ -94,8 +95,9 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
 	u32 pm;
 	u32 reg_val;
+	unsigned long flags;
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->lock, flags);
 	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS;
 	pm |= (1 << nr);
 	iowrite32(pm, &chip->reg->pm);
@@ -107,7 +109,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 		reg_val &= ~(1 << nr);
 	iowrite32(reg_val, &chip->reg->po);
 
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->lock, flags);
 
 	return 0;
 }
@@ -116,12 +118,13 @@ static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
 {
 	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
 	u32 pm;
+	unsigned long flags;
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->lock, flags);
 	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS; /*bits 0-11*/
 	pm &= ~(1 << nr);
 	iowrite32(pm, &chip->reg->pm);
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->lock, flags);
 
 	return 0;
 }
@@ -194,7 +197,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 
 	chip->reg = chip->base;
 	pci_set_drvdata(pdev, chip);
-	mutex_init(&chip->lock);
+	spin_lock_init(&chip->lock);
 	pch_gpio_setup(chip);
 	ret = gpiochip_add(&chip->gpio);
 	if (ret) {
-- 
1.7.3.4

