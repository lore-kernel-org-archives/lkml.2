Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab2G2C4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 22:56:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57953 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab2G2C4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 22:56:00 -0400
Message-ID: <1343530554.5373.3.camel@phoenix>
Subject: [PATCH RFT 2/2] gpio: gpio-pch: Use spinlock for register access
 protection
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 29 Jul 2012 10:55:54 +0800
In-Reply-To: <1343530482.5373.2.camel@phoenix>
References: <1343530482.5373.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_chip.can_sleep is 0, but current code uses mutex in pch_gpio_set
pch_gpio_get and pch_gpio_direction_input functions.
Thus those functions are not callable from interrupt context.
This patch converts mutex into spinlock.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-pch.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 139ad3e..4ad0c4f 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -92,9 +92,7 @@ struct pch_gpio_reg_data {
  * @lock:			Used for register access protection
  * @irq_base:		Save base of IRQ number for interrupt
  * @ioh:		IOH ID
- * @spinlock:		Used for register access protection in
- *				interrupt context pch_irq_mask,
- *				pch_irq_unmask and pch_irq_type;
+ * @spinlock:		Used for register access protection
  */
 struct pch_gpio {
 	void __iomem *base;
@@ -102,7 +100,6 @@ struct pch_gpio {
 	struct device *dev;
 	struct gpio_chip gpio;
 	struct pch_gpio_reg_data pch_gpio_reg;
-	struct mutex lock;
 	int irq_base;
 	enum pch_type_t ioh;
 	spinlock_t spinlock;
@@ -112,8 +109,9 @@ static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
 {
 	u32 reg_val;
 	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+	unsigned long flags;
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->spinlock, flags);
 	reg_val = ioread32(&chip->reg->po);
 	if (val)
 		reg_val |= (1 << nr);
@@ -121,7 +119,7 @@ static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
 		reg_val &= ~(1 << nr);
 
 	iowrite32(reg_val, &chip->reg->po);
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
 }
 
 static int pch_gpio_get(struct gpio_chip *gpio, unsigned nr)
@@ -137,8 +135,9 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
 	u32 pm;
 	u32 reg_val;
+	unsigned long flags;
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->spinlock, flags);
 	pm = ioread32(&chip->reg->pm) & ((1 << gpio_pins[chip->ioh]) - 1);
 	pm |= (1 << nr);
 	iowrite32(pm, &chip->reg->pm);
@@ -149,8 +148,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 	else
 		reg_val &= ~(1 << nr);
 	iowrite32(reg_val, &chip->reg->po);
-
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -159,12 +157,13 @@ static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
 {
 	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
 	u32 pm;
+	unsigned long flags;
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->spinlock, flags);
 	pm = ioread32(&chip->reg->pm) & ((1 << gpio_pins[chip->ioh]) - 1);
 	pm &= ~(1 << nr);
 	iowrite32(pm, &chip->reg->pm);
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -387,7 +386,6 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 
 	chip->reg = chip->base;
 	pci_set_drvdata(pdev, chip);
-	mutex_init(&chip->lock);
 	spin_lock_init(&chip->spinlock);
 	pch_gpio_setup(chip);
 	ret = gpiochip_add(&chip->gpio);
-- 
1.7.9.5



