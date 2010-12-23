Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0LWL4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:56:31 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:18002 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943Ab0LWL4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:56:30 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Marc Zyngier <maz@misterjones.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] gpio/ml_ioh_gpio: ML7213 GPIO driver
Date: Thu, 23 Dec 2010 20:58:44 +0900
Message-Id: <1293105524-3250-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML7213 is companion chip for Intel Atom E6xx series.
This driver can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/Output Hub) which
is for IVI(In-Vehicle Infotainment) use.
This driver can access the IOH's GPIO device.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/Kconfig       |    9 ++
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/ml_ioh_gpio.c |  345 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 355 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/ml_ioh_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3143ac7..3dcd0ce 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -333,6 +333,15 @@ config GPIO_PCH
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
 	  This driver can access PCH GPIO device.
 
+config GPIO_ML_IOH
+	tristate "OKI SEMICONDUCTOR ML7213 IOH GPIO support"
+	depends on PCI
+	help
+	  ML7213 is companion chip for Intel Atom E6xx series.
+	  This driver can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/Output
+	  Hub) which is for IVI(In-Vehicle Infotainment) use.
+	  This driver can access the IOH's GPIO device.
+
 config GPIO_TIMBERDALE
 	bool "Support for timberdale GPIO IP"
 	depends on MFD_TIMBERDALE && GPIOLIB && HAS_IOMEM
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index bdf3dde..b95f8c6 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -41,3 +41,4 @@ obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
 obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
+obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
diff --git a/drivers/gpio/ml_ioh_gpio.c b/drivers/gpio/ml_ioh_gpio.c
new file mode 100644
index 0000000..4fa3224
--- /dev/null
+++ b/drivers/gpio/ml_ioh_gpio.c
@@ -0,0 +1,345 @@
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+
+#define PCI_VENDOR_ID_ROHM             0x10DB
+
+struct ioh_reg_comn {
+	u32	ien;
+	u32	istatus;
+	u32	idisp;
+	u32	iclr;
+	u32	imask;
+	u32	imaskclr;
+	u32	po;
+	u32	pi;
+	u32	pm;
+	u32	im_0;
+	u32	im_1;
+	u32	reserved;
+};
+
+struct ioh_regs {
+	struct ioh_reg_comn regs[8];
+	u32 reserve1[16];
+	u32 ioh_sel_reg[4];
+	u32 reserve2[11];
+	u32 srst;
+};
+
+/**
+ * struct ioh_gpio_reg_data - The register store data.
+ * @po_reg:	To store contents of PO register.
+ * @pm_reg:	To store contents of PM register.
+ */
+struct ioh_gpio_reg_data {
+	u32 po_reg;
+	u32 pm_reg;
+};
+
+/**
+ * struct ioh_gpio - GPIO private data structure.
+ * @base:			PCI base address of Memory mapped I/O register.
+ * @reg:			Memory mapped IOH GPIO register list.
+ * @dev:			Pointer to device structure.
+ * @gpio:			Data for GPIO infrastructure.
+ * @ioh_gpio_reg:		Memory mapped Register data is saved here
+ *				when suspend.
+ * @ch:				Indicate GPIO channel
+ */
+struct ioh_gpio {
+	void __iomem *base;
+	struct ioh_regs __iomem *reg;
+	struct device *dev;
+	struct gpio_chip gpio;
+	struct ioh_gpio_reg_data ioh_gpio_reg;
+	struct mutex lock;
+	int ch;
+};
+
+static const int num_ports[] = {6, 12, 16, 16, 15, 16, 16, 12};
+
+static void ioh_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
+{
+	u32 reg_val;
+	struct ioh_gpio *chip =	container_of(gpio, struct ioh_gpio, gpio);
+
+	mutex_lock(&chip->lock);
+	reg_val = ioread32(&chip->reg->regs[chip->ch].po);
+	if (val)
+		reg_val |= (1 << nr);
+	else
+		reg_val &= ~(1 << nr);
+
+	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
+	mutex_unlock(&chip->lock);
+}
+
+static int ioh_gpio_get(struct gpio_chip *gpio, unsigned nr)
+{
+	struct ioh_gpio *chip =	container_of(gpio, struct ioh_gpio, gpio);
+
+	return ioread32(&chip->reg->regs[chip->ch].pi) & (1 << nr);
+}
+
+static int ioh_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
+				     int val)
+{
+	struct ioh_gpio *chip =	container_of(gpio, struct ioh_gpio, gpio);
+	u32 pm;
+	u32 reg_val;
+
+	mutex_lock(&chip->lock);
+	pm = ioread32(&chip->reg->regs[chip->ch].pm) &
+					((1 << num_ports[chip->ch]) - 1);
+	pm |= (1 << nr);
+	iowrite32(pm, &chip->reg->regs[chip->ch].pm);
+
+	reg_val = ioread32(&chip->reg->regs[chip->ch].po);
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
+static int ioh_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	struct ioh_gpio *chip =	container_of(gpio, struct ioh_gpio, gpio);
+	u32 pm;
+
+	mutex_lock(&chip->lock);
+	pm = ioread32(&chip->reg->regs[chip->ch].pm) &
+				((1 << num_ports[chip->ch]) - 1);
+	pm &= ~(1 << nr);
+	iowrite32(pm, &chip->reg->regs[chip->ch].pm);
+	mutex_unlock(&chip->lock);
+
+	return 0;
+}
+
+/*
+ * Save register configuration and disable interrupts.
+ */
+static void ioh_gpio_save_reg_conf(struct ioh_gpio *chip)
+{
+	chip->ioh_gpio_reg.po_reg = ioread32(&chip->reg->regs[chip->ch].po);
+	chip->ioh_gpio_reg.pm_reg = ioread32(&chip->reg->regs[chip->ch].pm);
+}
+
+/*
+ * This function restores the register configuration of the GPIO device.
+ */
+static void ioh_gpio_restore_reg_conf(struct ioh_gpio *chip)
+{
+	/* to store contents of PO register */
+	iowrite32(chip->ioh_gpio_reg.po_reg, &chip->reg->regs[chip->ch].po);
+	/* to store contents of PM register */
+	iowrite32(chip->ioh_gpio_reg.pm_reg, &chip->reg->regs[chip->ch].pm);
+}
+
+static void ioh_gpio_setup(struct ioh_gpio *chip, int num_port)
+{
+	struct gpio_chip *gpio = &chip->gpio;
+
+	gpio->label = dev_name(chip->dev);
+	gpio->owner = THIS_MODULE;
+	gpio->direction_input = ioh_gpio_direction_input;
+	gpio->get = ioh_gpio_get;
+	gpio->direction_output = ioh_gpio_direction_output;
+	gpio->set = ioh_gpio_set;
+	gpio->dbg_show = NULL;
+	gpio->base = -1;
+	gpio->ngpio = num_port;
+	gpio->can_sleep = 0;
+}
+
+static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
+				    const struct pci_device_id *id)
+{
+	int ret;
+	int i;
+	struct ioh_gpio *chip;
+	void __iomem *base;
+	void __iomem *chip_save;
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "%s : pci_enable_device failed", __func__);
+		goto err_pci_enable;
+	}
+
+	ret = pci_request_regions(pdev, KBUILD_MODNAME);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_request_regions failed-%d", ret);
+		goto err_request_regions;
+	}
+
+	base = pci_iomap(pdev, 1, 0);
+	if (base == 0) {
+		dev_err(&pdev->dev, "%s : pci_iomap failed", __func__);
+		ret = -ENOMEM;
+		goto err_iomap;
+	}
+
+	chip_save = kzalloc(sizeof(*chip) * 8, GFP_KERNEL);
+	if (chip_save == NULL) {
+		dev_err(&pdev->dev, "%s : kzalloc failed", __func__);
+		ret = -ENOMEM;
+		goto err_kzalloc;
+	}
+
+	for (i = 0, chip = chip_save; i < 8; i++, chip++) {
+		chip->dev = &pdev->dev;
+		chip->base = base;
+		chip->reg = chip->base;
+		chip->ch = i;
+		mutex_init(&chip->lock);
+		ioh_gpio_setup(chip, num_ports[i]);
+		ret = gpiochip_add(&chip->gpio);
+		if (ret) {
+			dev_err(&pdev->dev, "IOH gpio: Failed to register GPIO\n");
+			goto err_gpiochip_add;
+		}
+	}
+
+	chip = chip_save;
+	pci_set_drvdata(pdev, chip);
+
+	return 0;
+
+err_gpiochip_add:
+	kfree(chip_save);
+
+err_kzalloc:
+	pci_iounmap(pdev, base);
+
+err_iomap:
+	pci_release_regions(pdev);
+
+err_request_regions:
+	pci_disable_device(pdev);
+
+err_pci_enable:
+
+	dev_err(&pdev->dev, "%s Failed returns %d\n", __func__, ret);
+	return ret;
+}
+
+static void __devexit ioh_gpio_remove(struct pci_dev *pdev)
+{
+	int err;
+	int i;
+	struct ioh_gpio *chip = pci_get_drvdata(pdev);
+	void __iomem *chip_save;
+
+	chip_save = chip;
+	for (i = 0; i < 8; i++, chip++) {
+		err = gpiochip_remove(&chip->gpio);
+		if (err)
+			dev_err(&pdev->dev, "Failed gpiochip_remove\n");
+	}
+
+	chip = chip_save;
+	pci_iounmap(pdev, chip->base);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	kfree(chip);
+}
+
+#ifdef CONFIG_PM
+static int ioh_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	s32 ret;
+	struct ioh_gpio *chip = pci_get_drvdata(pdev);
+
+	ioh_gpio_save_reg_conf(chip);
+	ioh_gpio_restore_reg_conf(chip);
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
+static int ioh_gpio_resume(struct pci_dev *pdev)
+{
+	s32 ret;
+	struct ioh_gpio *chip = pci_get_drvdata(pdev);
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
+	iowrite32(0x01, &chip->reg->srst);
+	iowrite32(0x00, &chip->reg->srst);
+	ioh_gpio_restore_reg_conf(chip);
+
+	return 0;
+}
+#else
+#define ioh_gpio_suspend NULL
+#define ioh_gpio_resume NULL
+#endif
+
+static DEFINE_PCI_DEVICE_TABLE(ioh_gpio_pcidev_id) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x802E) },
+	{ 0, }
+};
+
+static struct pci_driver ioh_gpio_driver = {
+	.name = "ml_ioh_gpio",
+	.id_table = ioh_gpio_pcidev_id,
+	.probe = ioh_gpio_probe,
+	.remove = __devexit_p(ioh_gpio_remove),
+	.suspend = ioh_gpio_suspend,
+	.resume = ioh_gpio_resume
+};
+
+static int __init ioh_gpio_pci_init(void)
+{
+	return pci_register_driver(&ioh_gpio_driver);
+}
+module_init(ioh_gpio_pci_init);
+
+static void __exit ioh_gpio_pci_exit(void)
+{
+	pci_unregister_driver(&ioh_gpio_driver);
+}
+module_exit(ioh_gpio_pci_exit);
+
+MODULE_DESCRIPTION("OKI SEMICONDUCTOR ML-IOH series GPIO Driver");
+MODULE_LICENSE("GPL");
-- 
1.6.0.6

