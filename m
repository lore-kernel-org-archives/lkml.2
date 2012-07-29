Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2G2Cyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 22:54:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2G2Cyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 22:54:51 -0400
Message-ID: <1343530482.5373.2.camel@phoenix>
Subject: [PATCH RFT 1/2] gpio: gpio-ml-ioh: Use spinlock for register access
 protection
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 29 Jul 2012 10:54:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_chip.can_sleep is 0, but current code uses mutex in ioh_gpio_set,
ioh_gpio_get and ioh_gpio_direction_input functions.
Thus those functions are not callable from interrupt context.
This patch converts mutex into spinlock.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-ml-ioh.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index db01f15..6a29ee1 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -87,8 +87,7 @@ struct ioh_gpio_reg_data {
  * @gpio_use_sel:		Save GPIO_USE_SEL1~4 register for PM
  * @ch:				Indicate GPIO channel
  * @irq_base:		Save base of IRQ number for interrupt
- * @spinlock:		Used for register access protection in
- *				interrupt context ioh_irq_type and PM;
+ * @spinlock:		Used for register access protection
  */
 struct ioh_gpio {
 	void __iomem *base;
@@ -97,7 +96,6 @@ struct ioh_gpio {
 	struct gpio_chip gpio;
 	struct ioh_gpio_reg_data ioh_gpio_reg;
 	u32 gpio_use_sel;
-	struct mutex lock;
 	int ch;
 	int irq_base;
 	spinlock_t spinlock;
@@ -109,8 +107,9 @@ static void ioh_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
 {
 	u32 reg_val;
 	struct ioh_gpio *chip =	container_of(gpio, struct ioh_gpio, gpio);
+	unsigned long flags;
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->spinlock, flags);
 	reg_val = ioread32(&chip->reg->regs[chip->ch].po);
 	if (val)
 		reg_val |= (1 << nr);
@@ -118,7 +117,7 @@ static void ioh_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
 		reg_val &= ~(1 << nr);
 
 	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
 }
 
 static int ioh_gpio_get(struct gpio_chip *gpio, unsigned nr)
@@ -134,8 +133,9 @@ static int ioh_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 	struct ioh_gpio *chip =	container_of(gpio, struct ioh_gpio, gpio);
 	u32 pm;
 	u32 reg_val;
+	unsigned long flags;
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->spinlock, flags);
 	pm = ioread32(&chip->reg->regs[chip->ch].pm) &
 					((1 << num_ports[chip->ch]) - 1);
 	pm |= (1 << nr);
@@ -148,7 +148,7 @@ static int ioh_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 		reg_val &= ~(1 << nr);
 	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
 
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -157,13 +157,14 @@ static int ioh_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
 {
 	struct ioh_gpio *chip =	container_of(gpio, struct ioh_gpio, gpio);
 	u32 pm;
+	unsigned long flags;
 
-	mutex_lock(&chip->lock);
+	spin_lock_irqsave(&chip->spinlock, flags);
 	pm = ioread32(&chip->reg->regs[chip->ch].pm) &
 				((1 << num_ports[chip->ch]) - 1);
 	pm &= ~(1 << nr);
 	iowrite32(pm, &chip->reg->regs[chip->ch].pm);
-	mutex_unlock(&chip->lock);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -447,7 +448,6 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 		chip->base = base;
 		chip->reg = chip->base;
 		chip->ch = i;
-		mutex_init(&chip->lock);
 		spin_lock_init(&chip->spinlock);
 		ioh_gpio_setup(chip, num_ports[i]);
 		ret = gpiochip_add(&chip->gpio);
-- 
1.7.9.5



