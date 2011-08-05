Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab1HEEF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 00:05:27 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26040 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab1HEEFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 00:05:04 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 2/3] gpio-ml-ioh: Support interrupt function
Date: Fri,  5 Aug 2011 13:04:21 +0900
Message-Id: <1312517062-5582-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1312517062-5582-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1312517062-5582-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/Kconfig       |    1 +
 drivers/gpio/gpio-ml-ioh.c |  209 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 207 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 5d9ff05..7a4e72d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -387,6 +387,7 @@ config GPIO_PCH
 config GPIO_ML_IOH
 	tristate "OKI SEMICONDUCTOR ML7213 IOH GPIO support"
 	depends on PCI
+	select GENERIC_IRQ_CHIP
 	help
 	  ML7213 is companion chip for Intel Atom E6xx series.
 	  This driver can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/Output
diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 655e55c..4fab37b 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -18,6 +18,17 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#define IOH_EDGE_FALLING	0
+#define IOH_EDGE_RISING		BIT(0)
+#define IOH_LEVEL_L		BIT(1)
+#define IOH_LEVEL_H		(BIT(0) | BIT(1))
+#define IOH_EDGE_BOTH		BIT(2)
+#define IOH_IM_MASK		(BIT(0) | BIT(1) | BIT(2))
+
+#define IOH_IRQ_BASE		0
 
 #define PCI_VENDOR_ID_ROHM             0x10DB
 
@@ -46,12 +57,20 @@ struct ioh_regs {
 
 /**
  * struct ioh_gpio_reg_data - The register store data.
+ * @ien_reg	To store contents of interrupt enable register.
+ * @imask_reg:	To store contents of interrupt mask regist
  * @po_reg:	To store contents of PO register.
  * @pm_reg:	To store contents of PM register.
+ * @im0_reg:	To store contents of interrupt mode regist0
+ * @im1_reg:	To store contents of interrupt mode regist1
  */
 struct ioh_gpio_reg_data {
+	u32 ien_reg;
+	u32 imask_reg;
 	u32 po_reg;
 	u32 pm_reg;
+	u32 im0_reg;
+	u32 im1_reg;
 };
 
 /**
@@ -63,6 +82,9 @@ struct ioh_gpio_reg_data {
  * @ioh_gpio_reg:		Memory mapped Register data is saved here
  *				when suspend.
  * @ch:				Indicate GPIO channel
+ * @irq_base:		Save base of IRQ number for interrupt
+ * @spinlock:		Used for register access protection in
+ *				interrupt context ioh_irq_type and PM;
  */
 struct ioh_gpio {
 	void __iomem *base;
@@ -72,6 +94,8 @@ struct ioh_gpio {
 	struct ioh_gpio_reg_data ioh_gpio_reg;
 	struct mutex lock;
 	int ch;
+	int irq_base;
+	spinlock_t spinlock;
 };
 
 static const int num_ports[] = {6, 12, 16, 16, 15, 16, 16, 12};
@@ -147,6 +171,10 @@ static void ioh_gpio_save_reg_conf(struct ioh_gpio *chip)
 {
 	chip->ioh_gpio_reg.po_reg = ioread32(&chip->reg->regs[chip->ch].po);
 	chip->ioh_gpio_reg.pm_reg = ioread32(&chip->reg->regs[chip->ch].pm);
+	chip->ioh_gpio_reg.ien_reg = ioread32(&chip->reg->regs[chip->ch].ien);
+	chip->ioh_gpio_reg.imask_reg = ioread32(&chip->reg->regs[chip->ch].imask);
+	chip->ioh_gpio_reg.im0_reg = ioread32(&chip->reg->regs[chip->ch].im_0);
+	chip->ioh_gpio_reg.im1_reg = ioread32(&chip->reg->regs[chip->ch].im_1);
 }
 
 /*
@@ -154,13 +182,21 @@ static void ioh_gpio_save_reg_conf(struct ioh_gpio *chip)
  */
 static void ioh_gpio_restore_reg_conf(struct ioh_gpio *chip)
 {
-	/* to store contents of PO register */
 	iowrite32(chip->ioh_gpio_reg.po_reg, &chip->reg->regs[chip->ch].po);
-	/* to store contents of PM register */
 	iowrite32(chip->ioh_gpio_reg.pm_reg, &chip->reg->regs[chip->ch].pm);
+	iowrite32(chip->ioh_gpio_reg.ien_reg, &chip->reg->regs[chip->ch].ien);
+	iowrite32(chip->ioh_gpio_reg.imask_reg, &chip->reg->regs[chip->ch].imask);
+	iowrite32(chip->ioh_gpio_reg.im0_reg, &chip->reg->regs[chip->ch].im_0);
+	iowrite32(chip->ioh_gpio_reg.im1_reg, &chip->reg->regs[chip->ch].im_1);
 }
 #endif
 
+static int ioh_gpio_to_irq(struct gpio_chip *gpio, unsigned offset)
+{
+	struct ioh_gpio *chip = container_of(gpio, struct ioh_gpio, gpio);
+	return chip->irq_base + offset;
+}
+
 static void ioh_gpio_setup(struct ioh_gpio *chip, int num_port)
 {
 	struct gpio_chip *gpio = &chip->gpio;
@@ -175,16 +211,148 @@ static void ioh_gpio_setup(struct ioh_gpio *chip, int num_port)
 	gpio->base = -1;
 	gpio->ngpio = num_port;
 	gpio->can_sleep = 0;
+	gpio->to_irq = ioh_gpio_to_irq;
+}
+
+static int ioh_irq_type(struct irq_data *d, unsigned int type)
+{
+	u32 im;
+	u32 *im_reg;
+	u32 ien;
+	u32 im_pos;
+	int ch;
+	unsigned long flags;
+	u32 val;
+	int irq = d->irq;
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct ioh_gpio *chip = gc->private;
+
+	ch = irq - chip->irq_base;
+	if (irq <= chip->irq_base + 7) {
+		im_reg = &chip->reg->regs[chip->ch].im_0;
+		im_pos = ch;
+	} else {
+		im_reg = &chip->reg->regs[chip->ch].im_1;
+		im_pos = ch - 8;
+	}
+	dev_dbg(chip->dev, "%s:irq=%d type=%d ch=%d pos=%d type=%d\n",
+		__func__, irq, type, ch, im_pos, type);
+
+	spin_lock_irqsave(&chip->spinlock, flags);
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		val = IOH_EDGE_RISING;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		val = IOH_EDGE_FALLING;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		val = IOH_EDGE_BOTH;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		val = IOH_LEVEL_H;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		val = IOH_LEVEL_L;
+		break;
+	case IRQ_TYPE_PROBE:
+		goto end;
+	default:
+		dev_warn(chip->dev, "%s: unknown type(%dd)",
+			__func__, type);
+		goto end;
+	}
+
+	/* Set interrupt mode */
+	im = ioread32(im_reg) & ~(IOH_IM_MASK << (im_pos * 4));
+	iowrite32(im | (val << (im_pos * 4)), im_reg);
+
+	/* iclr */
+	iowrite32(BIT(ch), &chip->reg->regs[chip->ch].iclr);
+
+	/* IMASKCLR */
+	iowrite32(BIT(ch), &chip->reg->regs[chip->ch].imaskclr);
+
+	/* Enable interrupt */
+	ien = ioread32(&chip->reg->regs[chip->ch].ien);
+	iowrite32(ien | BIT(ch), &chip->reg->regs[chip->ch].ien);
+end:
+	spin_unlock_irqrestore(&chip->spinlock, flags);
+
+	return 0;
+}
+
+static void ioh_irq_unmask(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct ioh_gpio *chip = gc->private;
+
+	iowrite32(1 << (d->irq - chip->irq_base),
+		  &chip->reg->regs[chip->ch].imaskclr);
+}
+
+static void ioh_irq_mask(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct ioh_gpio *chip = gc->private;
+
+	iowrite32(1 << (d->irq - chip->irq_base),
+		  &chip->reg->regs[chip->ch].imask);
+}
+
+static irqreturn_t ioh_gpio_handler(int irq, void *dev_id)
+{
+	struct ioh_gpio *chip = dev_id;
+	u32 reg_val;
+	int i, j;
+	int ret = IRQ_NONE;
+
+	for (i = 0; i < 8; i++) {
+		reg_val = ioread32(&chip->reg->regs[i].istatus);
+		for (j = 0; j < num_ports[i]; j++) {
+			if (reg_val & BIT(j)) {
+				dev_dbg(chip->dev,
+					"%s:[%d]:irq=%d status=0x%x\n",
+					__func__, j, irq, reg_val);
+				iowrite32(BIT(j),
+					  &chip->reg->regs[chip->ch].iclr);
+				generic_handle_irq(chip->irq_base + j);
+				ret = IRQ_HANDLED;
+			}
+		}
+	}
+	return ret;
+}
+
+static __devinit void ioh_gpio_alloc_generic_chip(struct ioh_gpio *chip,
+				unsigned int irq_start, unsigned int num)
+{
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
+
+	gc = irq_alloc_generic_chip("ioh_gpio", 1, irq_start, chip->base,
+				    handle_simple_irq);
+	gc->private = chip;
+	ct = gc->chip_types;
+
+	ct->chip.irq_mask = ioh_irq_mask;
+	ct->chip.irq_unmask = ioh_irq_unmask;
+	ct->chip.irq_set_type = ioh_irq_type;
+
+	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
+			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
 }
 
 static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
 	int ret;
-	int i;
+	int i, j;
 	struct ioh_gpio *chip;
 	void __iomem *base;
 	void __iomem *chip_save;
+	int irq_base;
 
 	ret = pci_enable_device(pdev);
 	if (ret) {
@@ -228,10 +396,41 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 	}
 
 	chip = chip_save;
+	for (j = 0; j < 8; j++, chip++) {
+		irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
+					   GFP_KERNEL);
+		if (irq_base < 0) {
+			dev_warn(&pdev->dev,
+				"ml_ioh_gpio: Failed to get IRQ base num\n");
+			chip->irq_base = -1;
+			goto err_irq_alloc_descs;
+		}
+		chip->irq_base = irq_base;
+		ioh_gpio_alloc_generic_chip(chip, irq_base, num_ports[j]);
+	}
+
+	chip = chip_save;
+	ret = request_irq(pdev->irq, ioh_gpio_handler,
+			     IRQF_SHARED, KBUILD_MODNAME, chip);
+	if (ret != 0) {
+		dev_err(&pdev->dev,
+			"%s request_irq failed\n", __func__);
+		goto err_request_irq;
+	}
+
 	pci_set_drvdata(pdev, chip);
 
 	return 0;
 
+err_request_irq:
+	chip = chip_save;
+err_irq_alloc_descs:
+	while (--j >= 0) {
+		chip--;
+		irq_free_descs(chip->irq_base, num_ports[j]);
+	}
+
+	chip = chip_save;
 err_gpiochip_add:
 	while (--i >= 0) {
 		chip--;
@@ -264,7 +463,11 @@ static void __devexit ioh_gpio_remove(struct pci_dev *pdev)
 	void __iomem *chip_save;
 
 	chip_save = chip;
+
+	free_irq(pdev->irq, chip);
+
 	for (i = 0; i < 8; i++, chip++) {
+		irq_free_descs(chip->irq_base, num_ports[i]);
 		err = gpiochip_remove(&chip->gpio);
 		if (err)
 			dev_err(&pdev->dev, "Failed gpiochip_remove\n");
-- 
1.7.4.4

