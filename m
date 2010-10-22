Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0JVFvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:51:50 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:22126 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183Ab0JVFvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:51:49 -0400
Message-ID: <4CC1267D.50301@dsn.okisemi.com>
Date: Fri, 22 Oct 2010 14:51:57 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: LKML <linux-kernel@vger.kernel.org>, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com, yong.y.wang@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        tomoya-linux@dsn.okisemi.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: [PATCH v4] Topcliff: Update PCH_GPIO driver to 2.6.35
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew Morton,

We want a GPIO maintainer to merge to 2.6.37.
We got "Reviewed-by" for this patch.
But I heard gpio tree is pretty much orphaned at the minute.
Could you merge this patch to 2.6.37 ?

Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)
---
GPIO driver of Topcliff PCH

Topcliff PCH is the platform controller hub that is going to be used in
Intel's upcoming general embedded platform. All IO peripherals in
Topcliff PCH are actually devices sitting on AMBA bus. Topcliff PCH has 
GPIO I/F. Using this I/F, it is able to access system
devices connected to GPIO.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
  drivers/gpio/Kconfig    |    8 ++
  drivers/gpio/Makefile   |    1 +
  drivers/gpio/pch_gpio.c |  312 
+++++++++++++++++++++++++++++++++++++++++++++++
  3 files changed, 321 insertions(+), 0 deletions(-)
  create mode 100644 drivers/gpio/pch_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 7face91..f0876b1 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -298,6 +298,14 @@ config GPIO_RDC321X
  	  Support for the RDC R321x SoC GPIOs over southbridge
  	  PCI configuration space.
  +config GPIO_PCH
+	tristate "PCH GPIO of Intel Topcliff"
+	depends on PCI
+	help
+	  This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
+	  which is an IOH(Input/Output Hub) for x86 embedded processor.
+	  This driver can access PCH GPIO device.
+
  comment "SPI GPIO expanders:"
   config GPIO_MAX7301
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index e53dcff..a2ef754 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -35,3 +35,4 @@ obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
  obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
  obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
  obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
+obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
new file mode 100644
index 0000000..b8fbe0c
--- /dev/null
+++ b/drivers/gpio/pch_gpio.c
@@ -0,0 +1,312 @@
+/*
+ * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 
02111-1307, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+
+#define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */
+#define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */
+
+struct pch_regs {
+	u32	ien;
+	u32	istatus;
+	u32	idisp;
+	u32	iclr;
+	u32	imask;
+	u32	imaskclr;
+	u32	po;
+	u32	pi;
+	u32	pm;
+	u32	im0;
+	u32	im1;
+	u32	reserved[4];
+	u32	reset;
+};
+
+/**
+ * struct pch_gpio_reg_data - The register store data.
+ * @po_reg:	To store contents of PO register.
+ * @pm_reg:	To store contents of PM register.
+ */
+struct pch_gpio_reg_data {
+	u32 po_reg;
+	u32 pm_reg;
+};
+
+/**
+ * struct pch_gpio - GPIO private data structure.
+ * @base:			PCI base address of Memory mapped I/O register.
+ * @reg:			Memory mapped PCH GPIO register list.
+ * @dev:			Pointer to device structure.
+ * @gpio:			Data for GPIO infrastructure.
+ * @pch_gpio_reg:		Memory mapped Register data is saved here
+ *				when suspend.
+ */
+struct pch_gpio {
+	void __iomem *base;
+	struct pch_regs __iomem *reg;
+	struct device *dev;
+	struct gpio_chip gpio;
+	struct pch_gpio_reg_data pch_gpio_reg;
+	struct mutex lock;
+};
+
+static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
+{
+	u32 reg_val;
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+
+	mutex_lock(&chip->lock);
+	reg_val = ioread32(&chip->reg->po);
+	if (val)
+		reg_val |= (1 << nr);
+	else
+		reg_val &= ~(1 << nr);
+
+	iowrite32(reg_val, &chip->reg->po);
+	mutex_unlock(&chip->lock);
+}
+
+static int pch_gpio_get(struct gpio_chip *gpio, unsigned nr)
+{
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+
+	return ioread32(&chip->reg->pi) & (1 << nr);
+}
+
+static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
+				     int val)
+{
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+	u32 pm;
+	u32 reg_val;
+
+	mutex_lock(&chip->lock);
+	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS;
+	pm |= (1 << nr);
+	iowrite32(pm, &chip->reg->pm);
+
+	reg_val = ioread32(&chip->reg->po);
+	if (val)
+		reg_val |= (1 << nr);
+	else
+		reg_val &= ~(1 << nr);
+
+	mutex_unlock(&chip->lock);
+
+	return 0;
+}
+
+static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+	u32 pm;
+
+	mutex_lock(&chip->lock);
+	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS; /*bits 0-11*/
+	pm &= ~(1 << nr);
+	iowrite32(pm, &chip->reg->pm);
+	mutex_unlock(&chip->lock);
+
+	return 0;
+}
+
+/*
+ * Save register configuration and disable interrupts.
+ */
+static void pch_gpio_save_reg_conf(struct pch_gpio *chip)
+{
+	chip->pch_gpio_reg.po_reg = ioread32(&chip->reg->po);
+	chip->pch_gpio_reg.pm_reg = ioread32(&chip->reg->pm);
+}
+
+/*
+ * This function restores the register configuration of the GPIO device.
+ */
+static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
+{
+	/* to store contents of PO register */
+	iowrite32(chip->pch_gpio_reg.po_reg, &chip->reg->po);
+	/* to store contents of PM register */
+	iowrite32(chip->pch_gpio_reg.pm_reg, &chip->reg->pm);
+}
+
+static void pch_gpio_setup(struct pch_gpio *chip)
+{
+	struct gpio_chip *gpio = &chip->gpio;
+
+	gpio->label = dev_name(chip->dev);
+	gpio->owner = THIS_MODULE;
+	gpio->direction_input = pch_gpio_direction_input;
+	gpio->get = pch_gpio_get;
+	gpio->direction_output = pch_gpio_direction_output;
+	gpio->set = pch_gpio_set;
+	gpio->dbg_show = NULL;
+	gpio->base = -1;
+	gpio->ngpio = GPIO_NUM_PINS;
+	gpio->can_sleep = 0;
+}
+
+static int __devinit pch_gpio_probe(struct pci_dev *pdev,
+				    const struct pci_device_id *id)
+{
+	s32 ret;
+	struct pch_gpio *chip;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	chip->dev = &pdev->dev;
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "%s : pci_enable_device FAILED", __func__);
+		goto err_pci_enable;
+	}
+
+	ret = pci_request_regions(pdev, KBUILD_MODNAME);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_request_regions FAILED-%d", ret);
+		goto err_request_regions;
+	}
+
+	chip->base = pci_iomap(pdev, 1, 0);
+	if (chip->base == 0) {
+		dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);
+		ret = -ENOMEM;
+		goto err_iomap;
+	}
+
+	chip->reg = chip->base;
+	pci_set_drvdata(pdev, chip);
+	mutex_init(&chip->lock);
+	pch_gpio_setup(chip);
+	ret = gpiochip_add(&chip->gpio);
+	if (ret) {
+		dev_err(&pdev->dev, "PCH gpio: Failed to register GPIO\n");
+		goto err_gpiochip_add;
+	}
+
+	return 0;
+
+err_gpiochip_add:
+	pci_iounmap(pdev, chip->base);
+
+err_iomap:
+	pci_release_regions(pdev);
+
+err_request_regions:
+	pci_disable_device(pdev);
+
+err_pci_enable:
+	kfree(chip);
+	dev_err(&pdev->dev, "%s Failed returns %d\n", __func__, ret);
+	return ret;
+}
+
+static void __devexit pch_gpio_remove(struct pci_dev *pdev)
+{
+	int err;
+	struct pch_gpio *chip = pci_get_drvdata(pdev);
+
+	err = gpiochip_remove(&chip->gpio);
+	if (err)
+		dev_err(&pdev->dev, "Failed gpiochip_remove\n");
+
+	pci_iounmap(pdev, chip->base);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	kfree(chip);
+}
+
+#ifdef CONFIG_PM
+static int pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	s32 ret;
+	struct pch_gpio *chip = pci_get_drvdata(pdev);
+
+	pch_gpio_save_reg_conf(chip);
+	pch_gpio_restore_reg_conf(chip);
+
+	ret = pci_save_state(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_save_state Failed-%d\n", ret);
+		return ret;
+	}
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D0);
+	ret = pci_enable_wake(pdev, PCI_D0, 1);
+	if (ret)
+		dev_err(&pdev->dev, "pci_enable_wake Failed -%d\n", ret);
+
+	return 0;
+}
+
+static int pch_gpio_resume(struct pci_dev *pdev)
+{
+	s32 ret;
+	struct pch_gpio *chip = pci_get_drvdata(pdev);
+
+	ret = pci_enable_wake(pdev, PCI_D0, 0);
+
+	pci_set_power_state(pdev, PCI_D0);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_enable_device Failed-%d ", ret);
+		return ret;
+	}
+	pci_restore_state(pdev);
+
+	iowrite32(0x01, &chip->reg->reset);
+	iowrite32(0x00, &chip->reg->reset);
+	pch_gpio_restore_reg_conf(chip);
+
+	return 0;
+}
+#else
+#define pch_gpio_suspend NULL
+#define pch_gpio_resume NULL
+#endif
+
+static const struct pci_device_id pch_gpio_pcidev_id[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803)},
+	{0,}
+};
+
+static struct pci_driver pch_gpio_driver = {
+	.name = "pch_gpio",
+	.id_table = pch_gpio_pcidev_id,
+	.probe = pch_gpio_probe,
+	.remove = __devexit_p(pch_gpio_remove),
+	.suspend = pch_gpio_suspend,
+	.resume = pch_gpio_resume
+};
+
+static int __init pch_gpio_pci_init(void)
+{
+	return pci_register_driver(&pch_gpio_driver);
+}
+module_init(pch_gpio_pci_init);
+
+static void __exit pch_gpio_pci_exit(void)
+{
+	pci_unregister_driver(&pch_gpio_driver);
+}
+module_exit(pch_gpio_pci_exit);
+
+MODULE_DESCRIPTION("PCH GPIO PCI Driver");
+MODULE_LICENSE("GPL");
-- 
1.6.0.6

