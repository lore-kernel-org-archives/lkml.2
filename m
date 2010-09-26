Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0IZPFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 11:05:38 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:18686 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab0IZPFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 11:05:36 -0400
From: Daniel Drake <dsd@laptop.org>
To: akpm@linux-foundation.org
Cc: sameo@linux.intel.com
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Cc: laforge@gnumonks.org
Subject: [PATCH] Add VIA VX855 multi-function device support
Message-Id: <20100926150513.45B829D401B@zog.reactivated.net>
Date: Sun, 26 Sep 2010 16:05:12 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=sCMvU203fv4A:10 a=ykoPv_dRAAAA:8 a=OA8392kgAAAA:8 a=Op-mwl0xAAAA:8 a=uPPSuVceIouxzflBcAoA:9 a=d1n4dTmw-XaN9YnG21YA:7 a=k34xKww9lv-TeBbciWD-wsE2WBEA:4 a=H_jQXghYZ-gA:10 a=GTw93z-ti4wA:10 a=d4CUUju0HPYA:10 a=r19uI-tuE90RK2Kl:21 a=ZKMbae0HJneeaHMS:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@gnumonks.org>

Initially we add support for the south bridge GPIO lines via GPIOLIB
as well as some skeleton for the SPI controllers.

This hardware can be found in the OLPC XO-1.5 laptop.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---

Resending after 1 week with no feedback.

 drivers/mfd/Kconfig      |   27 ++++
 drivers/mfd/Makefile     |    3 +
 drivers/mfd/vx855-core.c |  132 +++++++++++++++++
 drivers/mfd/vx855-gpio.c |  350 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/vx855-spi.c  |  302 +++++++++++++++++++++++++++++++++++++++
 drivers/mfd/vx855.h      |   16 ++
 6 files changed, 830 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/vx855-core.c
 create mode 100644 drivers/mfd/vx855-gpio.c
 create mode 100644 drivers/mfd/vx855-spi.c
 create mode 100644 drivers/mfd/vx855.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index db51ea1..6de344b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -555,6 +555,33 @@ config MFD_TPS6586X
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps6586x.
 
+config MFD_VX855
+	tristate "Support for VIA VX855/VX875 integrated south bridge"
+	depends on X86
+	help
+	  Say yes here to enable support for various functions of the
+	  VIA VX855/VX875 south bridge.
+
+config MFD_VX855_GPIO
+	tristate "Support for VIA VX855/VX875 GPIO"
+	depends on GPIOLIB
+	help
+	  Support access to the VX855/VX975 GPIO lines through the gpio library.
+
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
+config MFD_VX855_SPI
+	tristate "Support for VIA VX855/VX875 SPI"
+	depends on SPI_MASTER
+	help
+      Support access to the SPI bus on the VX855/VX875 south bridge.
+
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index feaeeae..eb2492e 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -76,3 +76,6 @@ obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
 obj-$(CONFIG_MFD_JZ4740_ADC)	+= jz4740-adc.o
 obj-$(CONFIG_MFD_TPS6586X)	+= tps6586x.o
+obj-$(CONFIG_MFD_VX855)		+= vx855-core.o
+obj-$(CONFIG_MFD_VX855_GPIO)	+= vx855-gpio.o
+obj-$(CONFIG_MFD_VX855_SPI)	+= vx855-spi.o
diff --git a/drivers/mfd/vx855-core.c b/drivers/mfd/vx855-core.c
new file mode 100644
index 0000000..3c591fe
--- /dev/null
+++ b/drivers/mfd/vx855-core.c
@@ -0,0 +1,132 @@
+/*
+ * Linux multi-function-device driver (MFD) for the integrated peripherals
+ * of the VIA VX855 chipset
+ *
+ * Copyright (C) 2009 VIA Technologies, Inc.
+ * Author: Harald Welte <HaraldWelte@viatech.com>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+
+#include "vx855.h"
+
+static int vx855_client_dev_register(struct vx855 *vg, const char *name,
+				     struct platform_device **pdev)
+{
+	struct vx855_subdev_pdata *subdev_pdata;
+	int ret;
+
+	*pdev = platform_device_alloc(name, -1);
+	if (!*pdev) {
+		dev_err(&vg->pdev->dev, "Failed to allocate pdev %s\n", name);
+		return -ENOMEM;
+	}
+
+	subdev_pdata = kmalloc(sizeof(*subdev_pdata), GFP_KERNEL);
+	if (!subdev_pdata) {
+		platform_device_put(*pdev);
+		return -ENOMEM;
+	}
+
+	subdev_pdata->vx855 = vg;
+	(*pdev)->dev.platform_data = subdev_pdata;
+	(*pdev)->dev.parent = &vg->pdev->dev;
+
+	ret = platform_device_add(*pdev);
+	if (ret) {
+		dev_err(&vg->pdev->dev, "Failed to register pdev %s\n", name);
+		kfree(subdev_pdata);
+		platform_device_put(*pdev);
+		*pdev = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+static __devinit int vx855_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *id)
+{
+	int ret;
+	struct vx855 *vg;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return -ENODEV;
+
+	vg = kzalloc(sizeof(*vg), GFP_KERNEL);
+	if (!vg)
+		return -ENOMEM;
+
+	vg->pdev = pdev;
+	pci_set_drvdata(pdev, vg);
+
+	vx855_client_dev_register(vg, "vx855-gpio", &vg->gpio_pdev);
+	vx855_client_dev_register(vg, "vx855-spi", &vg->spi_pdev);
+	vx855_client_dev_register(vg, "viapro-i2c", &vg->i2c_pdev);
+
+	/* we always return -ENODEV here in order to enable other
+	 * drivers like old, not-yet-platform_device ported i2c-viapro */
+	return -ENODEV;
+}
+
+static void vx855_remove(struct pci_dev *pdev)
+{
+	struct vx855 *vg = pci_get_drvdata(pdev);
+
+	platform_device_unregister(vg->i2c_pdev);
+	platform_device_unregister(vg->spi_pdev);
+	platform_device_unregister(vg->gpio_pdev);
+
+	pci_set_drvdata(pdev, NULL);
+	kfree(vg);
+}
+
+static struct pci_device_id vx855_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
+	{ 0, }
+};
+
+static struct pci_driver vx855_pci_driver = {
+	.name		= "vx855",
+	.id_table	= vx855_pci_tbl,
+	.probe		= vx855_probe,
+	.remove		= vx855_remove,
+};
+
+static int vx855_init(void)
+{
+	return pci_register_driver(&vx855_pci_driver);
+}
+module_init(vx855_init);
+
+static void vx855_exit(void)
+{
+	pci_unregister_driver(&vx855_pci_driver);
+}
+module_exit(vx855_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <HaraldWelte@viatech.com>");
+MODULE_DESCRIPTION("Driver for the VIA VX855 chipset");
diff --git a/drivers/mfd/vx855-gpio.c b/drivers/mfd/vx855-gpio.c
new file mode 100644
index 0000000..c79caad
--- /dev/null
+++ b/drivers/mfd/vx855-gpio.c
@@ -0,0 +1,350 @@
+/*
+ * Linux GPIOlib driver for the VIA VX855 integrated southbridge GPIO
+ *
+ * Copyright (C) 2009 VIA Technologies, Inc.
+ * Author: Harald Welte <HaraldWelte@viatech.com>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+
+#include "vx855.h"
+
+/* offset into pci config space indicating the 16bit register containing
+ * the power management IO space base */
+#define VX855_CFG_PMIO_OFFSET	0x88
+
+/* ACPI I/O Space registers */
+#define VX855_PMIO_ACPI		0x00
+#define VX855_PMIO_ACPI_LEN	0x0b
+/* Processor Power Management */
+#define VX855_PMIO_PPM		0x10
+#define VX855_PMIO_PPM_LEN	0x08
+/* General Purpose Power Management */
+#define VX855_PMIO_GPPM		0x20
+#define VX855_PMIO_GPPM_LEN	0x33
+
+#define VX855_PMIO_R_GPI	0x48
+#define VX855_PMIO_R_GPO	0x4c
+
+/* The VX855 south bridge has the following GPIO pins:
+ *	GPI 0...13	General Purpose Input
+ *	GPO 0...12	General Purpose Output
+ *	GPIO 0...14	General Purpose I/O (Open-Drain)
+ */
+
+#define NR_VX855_GPI	14
+#define NR_VX855_GPO	13
+#define NR_VX855_GPIO	15
+
+#define NR_VX855_GPInO	(NR_VX855_GPI + NR_VX855_GPO)
+#define NR_VX855_GP	(NR_VX855_GPI + NR_VX855_GPO + NR_VX855_GPIO)
+
+struct vx855_gpio {
+	struct gpio_chip gpio;
+	spinlock_t lock;
+	u_int32_t io_base;
+	struct vx855 *vx855;
+};
+
+/* resolve a GPIx into the corresponding bit position */
+static inline u_int32_t gpi_i_bit(int i)
+{
+	if (i < 10)
+		return 1 << i;
+	else
+		return 1 << (i + 14);
+}
+
+static inline u_int32_t gpo_o_bit(int i)
+{
+	if (i < 11)
+		return 1 << i;
+	else
+		return 1 << (i + 14);
+}
+
+static inline u_int32_t gpio_i_bit(int i)
+{
+	if (i < 14)
+		return 1 << (i + 10);
+	else
+		return 1 << (i + 14);
+}
+
+static inline u_int32_t read_pmio_reg(struct vx855_gpio *vg, u_int32_t reg)
+{
+	return inl(vg->io_base + (reg - VX855_PMIO_GPPM));
+}
+
+static inline void write_pmio_reg(struct vx855_gpio *vg, u_int32_t reg,
+				  u_int32_t val)
+{
+	outl(val, vg->io_base + (reg - VX855_PMIO_GPPM));
+}
+
+static inline u_int32_t gpio_o_bit(int i)
+{
+	if (i < 14)
+		return 1 << (i + 11);
+	else
+		return 1 << (i + 13);
+}
+
+/* Mapping betwee numeric GPIO ID and the actual GPIO hardware numbering:
+ * 0..13	GPI 0..13
+ * 14..26	GPO 0..12
+ * 27..41	GPIO 0..14
+ */
+
+static int vx855gpio_direction_input(struct gpio_chip *gpio,
+				     unsigned int nr)
+{
+	struct vx855_gpio *vg = container_of(gpio, struct vx855_gpio, gpio);
+	unsigned long flags;
+	u_int32_t reg_out;
+
+	/* Real GPI bits are always in input direction */
+	if (nr < NR_VX855_GPI)
+		return 0;
+
+	/* Real GPO bits cannot be put in output direction */
+	if (nr < NR_VX855_GPInO)
+		return -EINVAL;
+
+	/* Open Drain GPIO have to be set to one */
+	spin_lock_irqsave(&vg->lock, flags);
+	reg_out = read_pmio_reg(vg, VX855_PMIO_R_GPO);
+	reg_out |= gpio_o_bit(nr - NR_VX855_GPInO);
+	write_pmio_reg(vg, VX855_PMIO_R_GPO, reg_out);
+	spin_unlock_irqrestore(&vg->lock, flags);
+
+	return 0;
+}
+
+static int vx855gpio_get(struct gpio_chip *gpio, unsigned int nr)
+{
+	struct vx855_gpio *vg = container_of(gpio, struct vx855_gpio, gpio);
+	u_int32_t reg_in;
+	int ret = 0;
+
+	if (nr < NR_VX855_GPI) {
+		reg_in = read_pmio_reg(vg, VX855_PMIO_R_GPI);
+		if (reg_in & gpi_i_bit(nr))
+			ret = 1;
+	} else if (nr < NR_VX855_GPInO) {
+		/* GPO don't have an input bit, we need to read it
+		 * back from the output register */
+		reg_in = read_pmio_reg(vg, VX855_PMIO_R_GPO);
+		if (reg_in & gpo_o_bit(nr - NR_VX855_GPI))
+			ret = 1;
+	} else {
+		reg_in = read_pmio_reg(vg, VX855_PMIO_R_GPI);
+		if (reg_in & gpio_i_bit(nr - NR_VX855_GPInO))
+			ret = 1;
+	}
+
+	return ret;
+}
+
+static void vx855gpio_set(struct gpio_chip *gpio, unsigned int nr,
+			  int val)
+{
+	struct vx855_gpio *vg = container_of(gpio, struct vx855_gpio, gpio);
+	unsigned long flags;
+	u_int32_t reg_out;
+
+	/* True GPI cannot be switched to output mode */
+	if (nr < NR_VX855_GPI)
+		return;
+
+	spin_lock_irqsave(&vg->lock, flags);
+	reg_out = read_pmio_reg(vg, VX855_PMIO_R_GPO);
+	if (nr < NR_VX855_GPInO) {
+		if (val)
+			reg_out |= gpo_o_bit(nr - NR_VX855_GPI);
+		else
+			reg_out &= ~gpo_o_bit(nr - NR_VX855_GPI);
+	} else {
+		if (val)
+			reg_out |= gpio_o_bit(nr - NR_VX855_GPInO);
+		else
+			reg_out &= ~gpio_o_bit(nr - NR_VX855_GPInO);
+	}
+	write_pmio_reg(vg, VX855_PMIO_R_GPO, reg_out);
+	spin_unlock_irqrestore(&vg->lock, flags);
+}
+
+static int vx855gpio_direction_output(struct gpio_chip *gpio,
+				      unsigned int nr, int val)
+{
+	/* True GPI cannot be switched to output mode */
+	if (nr < NR_VX855_GPI)
+		return -EINVAL;
+
+	/* True GPO don't need to be switched to output mode,
+	 * and GPIO are open-drain, i.e. also need no switching,
+	 * so all we do is set the level */
+	vx855gpio_set(gpio, nr, val);
+
+	return 0;
+}
+
+static const char *vx855gpio_names[NR_VX855_GP] = {
+	"VX855_GPI0", "VX855_GPI1", "VX855_GPI2", "VX855_GPI3", "VX855_GPI4",
+	"VX855_GPI5", "VX855_GPI6", "VX855_GPI7", "VX855_GPI8", "VX855_GPI9",
+	"VX855_GPI10", "VX855_GPI11", "VX855_GPI12", "VX855_GPI13",
+	"VX855_GPO0", "VX855_GPO1", "VX855_GPO2", "VX855_GPO3", "VX855_GPO4",
+	"VX855_GPO5", "VX855_GPO6", "VX855_GPO7", "VX855_GPO8", "VX855_GPO9",
+	"VX855_GPO10", "VX855_GPO11", "VX855_GPO12",
+	"VX855_GPIO0", "VX855_GPIO1", "VX855_GPIO2", "VX855_GPIO3",
+	"VX855_GPIO4", "VX855_GPIO5", "VX855_GPIO6", "VX855_GPIO7",
+	"VX855_GPIO8", "VX855_GPIO9", "VX855_GPIO10", "VX855_GPIO11",
+	"VX855_GPIO12", "VX855_GPIO13", "VX855_GPIO14"
+};
+
+static void vx855gpio_gpio_setup(struct vx855_gpio *vg)
+{
+	struct gpio_chip *c = &vg->gpio;
+
+	c->label = "VX855 South Bridge";
+	c->owner = THIS_MODULE;
+	c->direction_input = vx855gpio_direction_input;
+	c->direction_output = vx855gpio_direction_output;
+	c->get = vx855gpio_get;
+	c->set = vx855gpio_set;
+	c->dbg_show = NULL;
+	c->base = 0;
+	c->ngpio = NR_VX855_GP;
+	c->can_sleep = 0;
+	c->names = vx855gpio_names;
+}
+
+static __devinit int vx855gpio_probe(struct platform_device *pdev)
+{
+	struct vx855_gpio *vg;
+	struct vx855_subdev_pdata *pdata = pdev->dev.platform_data;
+	u_int16_t io_offset;
+	int ret;
+
+	vg = kzalloc(sizeof(*vg), GFP_KERNEL);
+	if (!vg)
+		return -ENOMEM;
+
+	vg->vx855 = pdata->vx855;
+	platform_set_drvdata(pdev, vg);
+
+	ret = pci_read_config_word(vg->vx855->pdev,
+				   VX855_CFG_PMIO_OFFSET, &io_offset);
+	if (ret) {
+		ret = -EIO;
+		goto out_free;
+	}
+
+	if (!io_offset) {
+		dev_warn(&pdev->dev, "BIOS did not assign PMIO base offset?!?\n");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	/* mask out the lowest seven bits, as they are always zero, but
+	 * hardware returns them as 0x01 */
+	io_offset &= 0xff80;
+	io_offset += VX855_PMIO_GPPM;
+
+	dev_info(&pdev->dev, "found VX855 PMIO at base 0x%x\n", io_offset);
+
+	vg->io_base = io_offset;
+	spin_lock_init(&vg->lock);
+
+	/* Typically the ACPI code will already have requested this
+	 * region, so we have to skip requesting it.  If you run a
+	 * system without ACPI, you should enable VX855GPIO_REQUEST_REGION */
+#ifdef VX855GPIO_REQUEST_REGION
+	if (!request_region(io_offset, VX855_PMIO_GPPM_LEN,
+			    "vx855-gpio")) {
+		dev_err(&pdev->dev, "I/O resource busy\n");
+		ret = -EBUSY;
+		goto out_free;
+	}
+#endif
+	vx855gpio_gpio_setup(vg);
+
+	ret = gpiochip_add(&vg->gpio);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register GPIOs\n");
+		goto out_release;
+	}
+
+	return 0;
+
+out_release:
+#ifdef VX855GPIO_REQUEST_REGION
+	release_region(io_offset, VX855_PMIO_GPPM_LEN);
+#endif
+out_free:
+	platform_set_drvdata(pdev, NULL);
+	kfree(vg);
+	return ret;
+}
+
+static int __devexit vx855gpio_remove(struct platform_device *pdev)
+{
+	struct vx855_gpio *vg = platform_get_drvdata(pdev);
+
+	if (gpiochip_remove(&vg->gpio))
+		dev_err(&pdev->dev, "unable to remove gpio_chip?\n");
+#ifdef VX855GPIO_REQUEST_REGION
+	release_region(vg->mmio_phys, VX855_PMIO_GPPM_LEN);
+#endif
+	platform_set_drvdata(pdev, NULL);
+	kfree(vg);
+
+	return 0;
+}
+
+static struct platform_driver vx855gpio_driver = {
+	.driver = {
+		.name		= "vx855-gpio",
+	},
+	.probe		= vx855gpio_probe,
+	.remove		= vx855gpio_remove,
+};
+
+static int vx855gpio_init(void)
+{
+	return platform_driver_register(&vx855gpio_driver);
+}
+module_init(vx855gpio_init);
+
+static void vx855gpio_exit(void)
+{
+	platform_driver_unregister(&vx855gpio_driver);
+}
+module_exit(vx855gpio_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <HaraldWelte@viatech.com>");
+MODULE_DESCRIPTION("GPIO driver for the VIA VX855 chipset");
diff --git a/drivers/mfd/vx855-spi.c b/drivers/mfd/vx855-spi.c
new file mode 100644
index 0000000..cbe457e
--- /dev/null
+++ b/drivers/mfd/vx855-spi.c
@@ -0,0 +1,302 @@
+/*
+ * VIA Chipset SPI Controller Driver for VX855/VX875
+ *
+ * Copyright (C) 2009 VIA Technologies, Inc.
+ * Author: Harald Welte <HaraldWelte@viatech.com>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/uaccess.h>
+
+#include <linux/spi/spi.h>
+
+#include "vx855.h"
+
+#define VIASPI_NAME	"vx855-spi"
+
+
+/* Control Registers */
+#define CTRL_REG_SPI0_CTRL	0x00
+#define CTRL_REG_SPI1_CTRL	0x04
+#define CTRL_REG_MISC_CTRL	0x08
+#define CTRL_REG_IRQ_CTRL	0x09
+
+#define VSPIC_MMIO_SIZE	0x1000
+
+/* SPI Bus 0 */
+#define VSPI0_REG_SPIS		0x00	/* SPI Status (16 bit) */
+#define VSPI0_REG_SPIC		0x02	/* SPI Control (16 bit)*/
+#define VSPI0_REG_SPIA		0x04	/* SPI Address (32 bit)*/
+#define VSPI0_REG_SPID0		0x08	/* SPI Data 0 (64bit) */
+#define VSPI0_REG_SPID1		0x10	/* SPI Data 1 (64bit) */
+#define VSPI0_REG_BBAR		0x50	/* BIOS Base Address (32bit) */
+#define VSPI0_REG_PREOP		0x54	/* Prefix Opcode (16bit) */
+#define VSPI0_REG_OPTYOE	0x56	/* Opcode Type (16bit) */
+#define VSPI0_REG_OPMENU	0x58	/* Opcode Menu (16bit) */
+#define VSPI0_REG_PBR0		0x60	/* Protected BIOS Range[0] (32bit) */
+#define VSPI0_REG_PBR1		0x64	/* Protected BIOS Range[1] (32bit) */
+#define VSPI0_REG_PBR2		0x68	/* Protected BIOS Range[2] (32bit) */
+#define VSPI0_REG_CLKDIV	0x6c	/* Clock divider (8bit) */
+#define VSPI0_REG_MISC1		0x6d	/* Misc Control 1 (8bit) */
+#define VSPI0_REG_MISC2		0x6e	/* Misc Control 2 (8bit) */
+#define VSPI0_REG_IRQ		0x70	/* Interrupt Control (8bit) */
+#define VSPI0_REG_CYCLE		0x71	/* Cycle Control (16bit) */
+#define VSPI0_REG_IRQ_STAT	0x73	/* Interrupt Status (8bit) */
+#define VSPI0_REG_DMA_R_BB	0x74	/* DMA Read Buffer Base (32bit) */
+#define VSPI0_REG_DMA_W_BB	0x78	/* DMA Write Buffer Base (32bit) */
+#define VSPI0_REG_DMA_R_BL	0x7c	/* DMA Read Buffer Length (16bit) */
+#define VSPI0_REG_DMA_W_BL	0x7e	/* DMA Write Buffer Length (16bit) */
+#define VSPI0_REG_DMA_R_PTR	0x80	/* DMA Read Pointer (32bit) */
+#define VSPI0_REG_DMA_W_PTR	0x84	/* DMA Write Pointer (32bit) */
+
+#define VSPI0_MMIO_SIZE		0x88
+
+/* SPI Bus 1 */
+#define VSPI1_REG_CLKDIV	0x00	/* Clock Divider (8bit) */
+#define VSPI1_REG_MISC1		0x01	/* Misc Control 1 (8bit) */
+#define VSPI1_REG_MISC2		0x02	/* Misc Control 2 (8bit) */
+#define VSPI1_REG_IRQ		0x03	/* Interrupt Control (8bit) */
+#define VSPI1_REG_CYCLE1	0x04	/* Cycle Control 1 (16bit) */
+#define VSPI1_REG_CYCLE2	0x06	/* Cycle Control 1 (8bit) */
+#define VSPI1_REG_IRQ_STAT	0x07	/* Interrupt Status (8bit) */
+#define VSPI1_REG_DMA_R_BB	0x08	/* DMA Read Buffer Base (32bit) */
+#define VSPI1_REG_DMA_W_BB	0x0c	/* DMA Write Buffer Base (32bit) */
+#define VSPI1_REG_DMA_R_BL	0x10	/* DMA Read Buffer Length (16bit) */
+#define VSPI1_REG_DMA_W_BL	0x12	/* DMA Write Buffer Length (16bit) */
+#define VSPI1_REG_DMA_R_PTR	0x14	/* DMA Read Pointer (32bit) */
+#define VSPI1_REG_DMA_W_PTR	0x18	/* DMA Write Pointer (32bit) */
+
+#define VSPI1_MMIO_SIZE		0x1c
+
+struct via_spi_port {
+	u_int32_t mmio_base;
+	u_int32_t mmio_len;
+	void __iomem *regs;
+	struct spi_master *master;
+};
+
+struct via_spi {
+	struct vx855 *vx855;
+	struct {
+		u_int32_t mmio_base;
+		void __iomem *regs;
+		u_int8_t irq;
+	} ctrl;
+	struct via_spi_port port[2];
+};
+
+static int vx855_spi_setup(struct spi_device *spi)
+{
+	return -EINVAL;
+}
+
+static int vx855_spi_transfer(struct spi_device *spi,
+			     struct spi_message *mesg)
+{
+	return -EIO;
+}
+
+static int __init via_spi_probe(struct platform_device *pdev)
+{
+	struct vx855_subdev_pdata *pdata = pdev->dev.platform_data;
+	struct via_spi *vspi;
+	struct spi_master *master;
+	u_int32_t ctrlreg;
+	int err;
+
+	vspi = kzalloc(sizeof(*vspi), GFP_KERNEL);
+	if (!vspi)
+		return -ENOMEM;
+
+	vspi->vx855 = pdata->vx855;
+	platform_set_drvdata(pdev, vspi);
+
+	/* First we determine the MMIO base of the control registers */
+	pci_read_config_dword(vspi->vx855->pdev, 0xbc, &vspi->ctrl.mmio_base);
+
+	vspi->ctrl.mmio_base >>= 4;	/* lowest 4 bit reserved */
+	vspi->ctrl.mmio_base <<= 12;	/* only bits 31..12 present */
+
+	if (!vspi->ctrl.mmio_base) {
+		err = -ENODEV;
+		goto out_free;
+	}
+
+	dev_info(&pdev->dev, "Found VIA Chipset SPI Controller at 0x%x\n",
+		 vspi->ctrl.mmio_base);
+
+	if (!request_region(vspi->ctrl.mmio_base, VSPIC_MMIO_SIZE,
+			    VIASPI_NAME)) {
+		dev_err(&pdev->dev, "Address 0x%x already in use\n",
+			vspi->ctrl.mmio_base);
+	}
+
+	vspi->ctrl.regs = ioremap(vspi->ctrl.mmio_base, VSPIC_MMIO_SIZE);
+	if (!vspi->ctrl.regs) {
+		dev_err(&pdev->dev, "Cannot remap registers\n");
+		err = -EIO;
+		goto out_release_ctrl;
+	}
+
+	/* Now we can actually enable the two controllers */
+	ctrlreg = readl(vspi->ctrl.regs + CTRL_REG_SPI0_CTRL);
+	vspi->port[0].mmio_base = ctrlreg & 0xffffff00;
+	dev_info(&pdev->dev, "SPI Bus 1 at 0x%x: %s\n",
+		 vspi->port[0].mmio_base,
+		 ctrlreg & 1 ? " Enabled" :  "Disabled");
+	vspi->port[0].mmio_len = VSPI0_MMIO_SIZE;
+
+	if (!request_region(vspi->port[0].mmio_base, VSPI0_MMIO_SIZE,
+			    VIASPI_NAME)) {
+		dev_err(&pdev->dev, "Address 0x%x already in use\n",
+			vspi->port[0].mmio_base);
+	}
+
+	vspi->port[0].regs = ioremap(vspi->port[0].mmio_base,
+				     VSPI0_MMIO_SIZE);
+	if (!vspi->port[0].regs) {
+		err = -EIO;
+		goto out_release_port0;
+	}
+	master = spi_alloc_master(&pdev->dev, 0);
+	if (!master) {
+		err = -ENOMEM;
+		goto out_unmap_port0;
+	}
+	master->num_chipselect = 1;
+	master->bus_num = 0;
+	master->setup = vx855_spi_setup;
+	master->transfer = vx855_spi_transfer;
+	vspi->port[0].master = master;
+	err = spi_register_master(master);
+	if (err)
+		goto out_free_master0;
+
+	ctrlreg = readl(vspi->ctrl.regs + CTRL_REG_SPI1_CTRL);
+	vspi->port[1].mmio_base = ctrlreg & 0xffffff00;
+	dev_info(&pdev->dev, "SPI Bus 1 at 0x%x%s\n",
+		 vspi->port[1].mmio_base,
+		 ctrlreg & 1 ? " Enabled" :  "Disabled");
+	vspi->port[1].mmio_len = VSPI1_MMIO_SIZE;
+
+	if (!request_region(vspi->port[1].mmio_base, VSPI1_MMIO_SIZE,
+			    VIASPI_NAME)) {
+		dev_err(&pdev->dev, "Address 0x%x already in use\n",
+			vspi->port[1].mmio_base);
+	}
+
+	vspi->port[1].regs = ioremap(vspi->port[1].mmio_base,
+				     VSPI1_MMIO_SIZE);
+	if (!vspi->port[1].regs) {
+		err = -EIO;
+		goto out_release_port1;
+	}
+
+	master = spi_alloc_master(&pdev->dev, 0);
+	if (!master) {
+		err = -ENOMEM;
+		goto out_unmap_port1;
+	}
+	master->num_chipselect = 1;
+	master->bus_num = 1;
+	master->setup = vx855_spi_setup;
+	master->transfer = vx855_spi_transfer;
+	vspi->port[1].master = master;
+	err = spi_register_master(master);
+	if (err)
+		goto out_free_master1;
+
+	return 0;
+
+	spi_unregister_master(vspi->port[1].master);
+out_free_master1:
+	spi_master_put(vspi->port[1].master);
+out_unmap_port1:
+	iounmap(vspi->port[1].regs);
+out_release_port1:
+	release_region(vspi->port[1].mmio_base, VSPI1_MMIO_SIZE);
+	spi_unregister_master(vspi->port[0].master);
+out_free_master0:
+	spi_master_put(vspi->port[0].master);
+out_unmap_port0:
+	iounmap(vspi->port[0].regs);
+out_release_port0:
+	release_region(vspi->port[0].mmio_base, VSPI0_MMIO_SIZE);
+	iounmap(vspi->ctrl.regs);
+out_release_ctrl:
+	release_region(vspi->ctrl.mmio_base, VSPIC_MMIO_SIZE);
+out_free:
+	platform_set_drvdata(pdev, NULL);
+	kfree(vspi);
+
+	return err;
+}
+
+static int __exit via_spi_remove(struct platform_device *pdev)
+{
+	struct via_spi *vspi = platform_get_drvdata(pdev);
+
+	spi_unregister_master(vspi->port[1].master);
+	spi_master_put(vspi->port[1].master);
+	iounmap(vspi->port[1].regs);
+	release_region(vspi->port[1].mmio_base, VSPI1_MMIO_SIZE);
+
+	spi_unregister_master(vspi->port[0].master);
+	spi_master_put(vspi->port[0].master);
+	iounmap(vspi->port[0].regs);
+	release_region(vspi->port[0].mmio_base, VSPI0_MMIO_SIZE);
+
+	iounmap(vspi->ctrl.regs);
+	release_region(vspi->ctrl.mmio_base, VSPIC_MMIO_SIZE);
+	platform_set_drvdata(pdev, NULL);
+	kfree(vspi);
+
+	return 0;
+}
+
+static struct platform_driver via_spi_driver = {
+	.driver = {
+		.name		= VIASPI_NAME,
+	},
+	.probe		= via_spi_probe,
+	.remove		= via_spi_remove,
+};
+
+static int __init via_spi_init(void)
+{
+	return platform_driver_register(&via_spi_driver);
+}
+
+static void __exit via_spi_exit(void)
+{
+	platform_driver_unregister(&via_spi_driver);
+}
+
+module_init(via_spi_init);
+module_exit(via_spi_exit);
+
+MODULE_DESCRIPTION("Via VX855 Chipset SPI Driver");
+MODULE_AUTHOR("Harald Welte <HaraldWelte@viatech.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/vx855.h b/drivers/mfd/vx855.h
new file mode 100644
index 0000000..652e81f
--- /dev/null
+++ b/drivers/mfd/vx855.h
@@ -0,0 +1,16 @@
+#ifndef _VX855_H
+#define _VX855_H
+
+struct vx855 {
+	spinlock_t lock;
+	struct pci_dev *pdev;
+	struct platform_device *gpio_pdev;
+	struct platform_device *spi_pdev;
+	struct platform_device *i2c_pdev;
+};
+
+struct vx855_subdev_pdata {
+	struct vx855 *vx855;
+};
+
+#endif /* _VX855_H */
-- 
1.7.2.2

