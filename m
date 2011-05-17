Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1EQClB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:41:01 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6206 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185Ab1EQCk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:40:59 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_gpio: support interrupt function
Date: Tue, 17 May 2011 11:46:35 +0900
Message-Id: <1305600395-7192-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support interrupt function.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/Kconfig    |    2 +-
 drivers/gpio/pch_gpio.c |  153 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 664660e..bfb467b 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -326,7 +326,7 @@ config GPIO_LANGWELL
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
 config GPIO_PCH
-	tristate "PCH GPIO of Intel Topcliff"
+	bool "PCH GPIO of Intel Topcliff"
 	depends on PCI
 	help
 	  This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index 2c6af87..939771a 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -17,10 +17,21 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */
 #define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */
 
+#define PCH_EDGE_FALLING	0
+#define PCH_EDGE_RISING		BIT(0)
+#define PCH_LEVEL_L		BIT(1)
+#define PCH_LEVEL_H		(BIT(0) | BIT(1))
+#define PCH_EDGE_BOTH		BIT(2)
+#define PCH_IM_MASK		(BIT(0) | BIT(1) | BIT(2))
+
+#define PCH_IRQ_BASE		23
+
 struct pch_regs {
 	u32	ien;
 	u32	istatus;
@@ -55,6 +66,7 @@ struct pch_gpio_reg_data {
  * @gpio:			Data for GPIO infrastructure.
  * @pch_gpio_reg:		Memory mapped Register data is saved here
  *				when suspend.
+ * @lock:			spin_lock variable
  */
 struct pch_gpio {
 	void __iomem *base;
@@ -63,6 +75,8 @@ struct pch_gpio {
 	struct gpio_chip gpio;
 	struct pch_gpio_reg_data pch_gpio_reg;
 	struct mutex lock;
+	int irq_base;
+	spinlock_t spinlock;
 };
 
 static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
@@ -105,6 +119,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 		reg_val |= (1 << nr);
 	else
 		reg_val &= ~(1 << nr);
+	iowrite32(reg_val, &chip->reg->po);
 
 	mutex_unlock(&chip->lock);
 
@@ -145,6 +160,12 @@ static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
 	iowrite32(chip->pch_gpio_reg.pm_reg, &chip->reg->pm);
 }
 
+static int pch_gpio_to_irq(struct gpio_chip *gpio, unsigned offset)
+{
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+	return chip->irq_base + offset;
+}
+
 static void pch_gpio_setup(struct pch_gpio *chip)
 {
 	struct gpio_chip *gpio = &chip->gpio;
@@ -159,6 +180,101 @@ static void pch_gpio_setup(struct pch_gpio *chip)
 	gpio->base = -1;
 	gpio->ngpio = GPIO_NUM_PINS;
 	gpio->can_sleep = 0;
+	gpio->to_irq = pch_gpio_to_irq;
+}
+
+static int pch_irq_type(unsigned irq, unsigned type)
+{
+	u32 im;
+	u32 *im_reg;
+	u32 ien;
+	u32 im_pos;
+	int ch;
+	unsigned long flags;
+	u32 val;
+	struct pch_gpio *chip = get_irq_chip_data(irq);
+
+	ch = irq - chip->irq_base;
+	if (irq <= chip->irq_base + 7) {
+		im_reg = &chip->reg->im0;
+		im_pos = ch;
+	} else {
+		im_reg = &chip->reg->im1;
+		im_pos = ch - 8;
+	}
+	dev_dbg(chip->dev, "%s:irq=%d type=%d ch=%d pos=%d\n",
+		__func__, irq, type, ch, im_pos);
+
+	spin_lock_irqsave(&chip->spinlock, flags);
+
+	if (type == IRQ_TYPE_EDGE_RISING)
+		val = PCH_EDGE_RISING;
+	else if (type == IRQ_TYPE_EDGE_FALLING)
+		val = PCH_EDGE_FALLING;
+	else if (type == IRQ_TYPE_EDGE_BOTH)
+		val = PCH_EDGE_BOTH;
+	else if (type == IRQ_TYPE_LEVEL_HIGH)
+		val = PCH_LEVEL_L;
+	else if (type == IRQ_TYPE_LEVEL_LOW)
+		val = PCH_LEVEL_H;
+	else if (type == IRQ_TYPE_PROBE)
+		goto end;
+	else {
+		dev_warn(chip->dev, "%s: unknown type(%dd)", __func__, type);
+		goto end;
+	}
+
+	/* Set interrupt mode */
+	im = ioread32(im_reg) & ~(PCH_IM_MASK << (im_pos * 4));
+	iowrite32(im | (val << (im_pos * 4)), im_reg);
+
+	/* iclr */
+	iowrite32(BIT(ch), &chip->reg->iclr);
+
+	/* IMASKCLR */
+	iowrite32(BIT(ch), &chip->reg->imaskclr);
+
+	/* Enable interrupt */
+	ien = ioread32(&chip->reg->ien);
+	iowrite32(ien | BIT(ch), &chip->reg->ien);
+end:
+	spin_unlock_irqrestore(&chip->spinlock, flags);
+
+	return 0;
+}
+
+static void pch_irq_unmask(unsigned irq)
+{
+}
+
+static void pch_irq_mask(unsigned irq)
+{
+}
+
+static struct irq_chip pch_irqchip = {
+	.name		= "PCH-GPIO",
+	.mask		= pch_irq_mask,
+	.unmask		= pch_irq_unmask,
+	.set_type	= pch_irq_type,
+};
+
+static irqreturn_t pch_gpio_handler(int irq, void *dev_id)
+{
+	struct pch_gpio *chip = dev_id;
+	u32 reg_val = ioread32(&chip->reg->istatus);
+	int i;
+	int ret = IRQ_NONE;
+
+	for (i = 0; i < GPIO_NUM_PINS; i++) {
+		if (reg_val & BIT(i)) {
+			dev_dbg(chip->dev, "%s:[%d]:irq=%d  status=0x%x\n",
+				__func__, i, irq, reg_val);
+			iowrite32(BIT(i), &chip->reg->iclr);
+			generic_handle_irq(chip->irq_base + i);
+			ret = IRQ_HANDLED;
+		}
+	}
+	return ret;
 }
 
 static int __devinit pch_gpio_probe(struct pci_dev *pdev,
@@ -166,6 +282,8 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 {
 	s32 ret;
 	struct pch_gpio *chip;
+	int irq_base;
+	int i;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -201,8 +319,41 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 		goto err_gpiochip_add;
 	}
 
+	irq_base = irq_alloc_descs(-1, PCH_IRQ_BASE, GPIO_NUM_PINS, GFP_KERNEL);
+	if (irq_base < 0) {
+		dev_err(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");
+		goto err_irq_alloc_descs;
+	}
+
+	chip->irq_base = irq_base;
+
+	ret = request_irq(pdev->irq, pch_gpio_handler,
+			     IRQF_SHARED, KBUILD_MODNAME, chip);
+	if (ret != 0) {
+		dev_err(&pdev->dev,
+			"%s request_irq failed\n", __func__);
+		goto err_request_irq;
+	}
+
+	for (i = 0; i < GPIO_NUM_PINS; i++) {
+		set_irq_chip_and_handler_name(i + irq_base, &pch_irqchip,
+					handle_simple_irq, "pch");
+		set_irq_chip_data(i + irq_base, chip);
+	}
+
+	/* Initialize interrupt ien register */
+	iowrite32(0, &chip->reg->ien);
+
 	return 0;
 
+err_request_irq:
+	irq_free_descs(irq_base, GPIO_NUM_PINS);
+
+err_irq_alloc_descs:
+	ret = gpiochip_remove(&chip->gpio);
+	if (ret)
+		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);
+
 err_gpiochip_add:
 	pci_iounmap(pdev, chip->base);
 
@@ -223,6 +374,8 @@ static void __devexit pch_gpio_remove(struct pci_dev *pdev)
 	int err;
 	struct pch_gpio *chip = pci_get_drvdata(pdev);
 
+	irq_free_descs(chip->irq_base, GPIO_NUM_PINS);
+
 	err = gpiochip_remove(&chip->gpio);
 	if (err)
 		dev_err(&pdev->dev, "Failed gpiochip_remove\n");
-- 
1.7.4

