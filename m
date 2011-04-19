Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1DSMxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:53:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40679 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab1DSMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:53:17 -0400
Date: Tue, 19 Apr 2011 14:53:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20110419145303.111aead7@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need this to handle SMBus multiplexing on my Asus Z8NA-D6 board. It
has an ICH10, I've added support for older ICH chips in case someone
needs it, as it was relatively simply to do that.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
Note 1: On early ICH chips, some pins are exclusively inputs or
outputs. The driver doesn't currently enforce this.

Note 2: I'm not yet sure if we want a module alias for this driver.
Many systems have the device but only a few of them will need the
driver (and an ACPI resource conflict will be reported for many
others, especially laptops I suspect.) So it might make more sense to
let consumer drivers request the i801_gpio driver as needed (which they
should do anyway, as you can't assume udev is always up and running on
all systems.)

Note 3: This is my first GPIO driver, so while it works fine for me, it
might not be perfect. I welcome comments on how to improve it.

 drivers/gpio/Kconfig     |    7 
 drivers/gpio/Makefile    |    1 
 drivers/gpio/i801_gpio.c |  432 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 440 insertions(+)

--- linux-2.6.39-rc3.orig/drivers/gpio/Kconfig	2011-04-18 19:41:51.000000000 +0200
+++ linux-2.6.39-rc3/drivers/gpio/Kconfig	2011-04-18 22:36:41.000000000 +0200
@@ -322,6 +322,13 @@ config GPIO_BT8XX
 
 	  If unsure, say N.
 
+config GPIO_I801
+	tristate "Intel 82801 (ICH) GPIO"
+	depends on PCI
+	help
+	  This driver is for the GPIO pins of Intel 82801 south bridges
+	  (aka ICH).
+
 config GPIO_LANGWELL
 	bool "Intel Langwell/Penwell GPIO support"
 	depends on PCI && X86
--- linux-2.6.39-rc3.orig/drivers/gpio/Makefile	2011-04-18 19:41:51.000000000 +0200
+++ linux-2.6.39-rc3/drivers/gpio/Makefile	2011-04-18 22:36:41.000000000 +0200
@@ -11,6 +11,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
+obj-$(CONFIG_GPIO_I801)		+= i801_gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.39-rc3/drivers/gpio/i801_gpio.c	2011-04-19 13:55:25.000000000 +0200
@@ -0,0 +1,432 @@
+/*
+ * Linux kernel driver for the Intel 82801 GPIO pins
+ * Copyright (C) 2011 Jean Delvare <khali@linux-fr.org>
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
+
+#include <linux/kernel.h>
+#include <linux/acpi.h>
+#include <linux/bitops.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+
+static int force;
+module_param(force, int, 0444);
+MODULE_PARM_DESC(force, "Forcibly enable access to GPIO");
+
+enum chips { ICH2, ICH4, ICH6, ICH10_CORP };
+
+/* Register definitions */
+static const u8 REG_GPIO_USE_SEL[3]	= { 0x00, 0x30, 0x40 };
+static const u8 REG_GP_IO_SEL[3]	= { 0x04, 0x34, 0x44 };
+static const u8 REG_GP_LVL[3]		= { 0x0C, 0x38, 0x48 };
+
+/**
+ * struct i801_gpio_data - 82801 GPIO private data
+ * @base:		Base I/O port
+ * @io_size:		I/O region size (64 or 128)
+ * @gpio:		Data for GPIO infrastructure
+ * @lock:		Mutex to serialize read-modify-write cycles
+ */
+struct i801_gpio_data {
+	u32 base;
+	u32 io_size;
+	u32 use_sel[3];
+	struct gpio_chip gpio;
+	struct mutex lock;
+};
+
+static int i801_gpio_request(struct gpio_chip *gpio, unsigned nr)
+{
+	struct i801_gpio_data *data;
+	int group = nr >> 5;
+
+	data = container_of(gpio, struct i801_gpio_data, gpio);
+	nr &= 0x1f;
+
+	if (data->use_sel[group] & BIT(nr))
+		return 0;
+	else
+		return -EINVAL;
+}
+
+static void i801_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
+{
+	struct i801_gpio_data *data;
+	int group = nr >> 5;
+	u32 reg_val;
+
+	data = container_of(gpio, struct i801_gpio_data, gpio);
+	nr &= 0x1f;
+
+	mutex_lock(&data->lock);
+	reg_val = inl(data->base + REG_GP_LVL[group]);
+	if (val)
+		reg_val |= BIT(nr);
+	else
+		reg_val &= ~BIT(nr);
+	outl(reg_val, data->base + REG_GP_LVL[group]);
+	mutex_unlock(&data->lock);
+}
+
+static int i801_gpio_get(struct gpio_chip *gpio, unsigned nr)
+{
+	struct i801_gpio_data *data;
+	int group = nr >> 5;
+
+	data = container_of(gpio, struct i801_gpio_data, gpio);
+	nr &= 0x1f;
+
+	return (inl(data->base + REG_GP_LVL[group]) >> nr) & 1;
+}
+
+static int i801_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
+				      int val)
+{
+	struct i801_gpio_data *data;
+	int group = nr >> 5;
+	u32 reg_val;
+
+	data = container_of(gpio, struct i801_gpio_data, gpio);
+	nr &= 0x1f;
+
+	mutex_lock(&data->lock);
+	reg_val = inl(data->base + REG_GP_IO_SEL[group]);
+	reg_val &= ~BIT(nr);
+	outl(reg_val, data->base + REG_GP_IO_SEL[group]);
+
+	reg_val = inl(data->base + REG_GP_LVL[group]);
+	if (val)
+		reg_val |= BIT(nr);
+	else
+		reg_val &= ~BIT(nr);
+	outl(reg_val, data->base + REG_GP_LVL[group]);
+	mutex_unlock(&data->lock);
+
+	return 0;
+}
+
+static int i801_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	struct i801_gpio_data *data;
+	int group = nr >> 5;
+	u32 reg_val;
+
+	data = container_of(gpio, struct i801_gpio_data, gpio);
+	nr &= 0x1f;
+
+	mutex_lock(&data->lock);
+	reg_val = inl(data->base + REG_GP_IO_SEL[group]);
+	reg_val |= BIT(nr);
+	outl(reg_val, data->base + REG_GP_IO_SEL[group]);
+	mutex_unlock(&data->lock);
+
+	return 0;
+}
+
+static void __devinit i801_gpio_setup(struct gpio_chip *gpio,
+				      struct device *dev, int ngpio)
+{
+	gpio->label = "i801_gpio";
+	gpio->dev = dev;
+	gpio->owner = THIS_MODULE;
+	gpio->request = i801_gpio_request;
+	gpio->direction_input = i801_gpio_direction_input;
+	gpio->get = i801_gpio_get;
+	gpio->direction_output = i801_gpio_direction_output;
+	gpio->set = i801_gpio_set;
+	gpio->base = -1;
+	gpio->ngpio = ngpio;
+}
+
+/*
+ * On the ICH/ICH0, ICH3, ICH4 and ICH5, some selection bits control more
+ * than one GPIO.
+ */
+static void __devinit i801_gpio_sel_fixup(struct i801_gpio_data *data,
+					  u32 device)
+{
+	switch (device) {
+	case PCI_DEVICE_ID_INTEL_82801AA_0:
+	case PCI_DEVICE_ID_INTEL_82801AB_0:
+	case PCI_DEVICE_ID_INTEL_82801CA_0:
+	case PCI_DEVICE_ID_INTEL_82801CA_12:
+	case PCI_DEVICE_ID_INTEL_82801DB_0:
+	case PCI_DEVICE_ID_INTEL_82801DB_12:
+	case PCI_DEVICE_ID_INTEL_82801EB_0:
+		if (data->use_sel[0] & BIT(0))
+			data->use_sel[0] |= BIT(16);
+		if (data->use_sel[0] & BIT(1))
+			data->use_sel[0] |= BIT(17);
+		if (data->use_sel[0] & BIT(27))
+			data->use_sel[0] |= BIT(28);
+		break;
+	}
+}
+
+static __devinitdata
+const struct {
+	int ngroup;
+	int io_size;
+	u8 reg_gpiobase;
+	u8 reg_gc;
+} i801_gpio_cfg[] = {
+	[ICH2]		= { 1,  64, 0x58, 0x5C },
+	[ICH4]		= { 2,  64, 0x58, 0x5C },
+	[ICH6]		= { 2,  64, 0x48, 0x4C },
+	[ICH10_CORP]	= { 3, 128, 0x48, 0x4C },
+};
+
+static void __devinit i801_gpio_print_state(struct i801_gpio_data *data,
+					    struct device *dev, int ngroup)
+{
+	int i, group;
+	u32 io_sel, lvl;
+
+	dev_dbg(dev, "Current state of GPIO pins:\n");
+	for (group = 0; group < ngroup; group++) {
+		io_sel = inl(data->base + REG_GP_IO_SEL[group]);
+		lvl = inl(data->base + REG_GP_LVL[group]);
+
+		for (i = 0; i < 32; i++) {
+			if (!(data->use_sel[group] & BIT(i)))
+				continue;
+
+			dev_dbg(dev, "GPIO%d: %s, level %d\n", group * 32 + i,
+				io_sel & BIT(i) ? "input" : "output",
+				!!(lvl & BIT(i)));
+		}
+	}
+}
+
+static int __devinit i801_gpio_probe(struct pci_dev *pdev,
+				     const struct pci_device_id *id)
+{
+	struct i801_gpio_data *data;
+	u32 gpiobase;
+	u8 gc;
+	int type = id->driver_data;
+	int group, ngroup, err;
+
+	data = kzalloc(sizeof(struct i801_gpio_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enable device (%d)\n", err);
+		goto err_free;
+	}
+
+	/* Get the base I/O address */
+	err = pci_read_config_dword(pdev, i801_gpio_cfg[type].reg_gpiobase,
+				    &gpiobase);
+	if (err) {
+		dev_err(&pdev->dev, "Couldn't read %s value (%d)\n",
+			"GPIOBASE", err);
+		goto err_disable;
+	}
+	data->base = gpiobase & ~BIT(0);
+	if (!data->base) {
+		dev_err(&pdev->dev, "GPIOBASE not set\n");
+		err = -ENODEV;
+		goto err_disable;
+	}
+
+	/* Check configuration */
+	err = pci_read_config_byte(pdev, i801_gpio_cfg[type].reg_gc, &gc);
+	if (err) {
+		dev_err(&pdev->dev, "Couldn't read %s value (%d)\n",
+			"GC", err);
+		goto err_disable;
+	}
+	if (gc & BIT(0)) {
+		dev_err(&pdev->dev, "GPIO function is %s\n", "locked");
+		err = -EBUSY;
+		goto err_disable;
+	}
+	if (!(gc & BIT(4))) {
+		if (!force) {
+			dev_err(&pdev->dev, "GPIO function is %s\n",
+				"disabled");
+			err = -ENODEV;
+			goto err_disable;
+		}
+
+		gc |= BIT(4);
+		err = pci_write_config_byte(pdev,
+					    i801_gpio_cfg[type].reg_gc, gc);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable GPIO function (%d)\n",
+				err);
+			err = -ENODEV;
+			goto err_disable;
+		}
+		dev_info(&pdev->dev, "Enabling GPIO function\n");
+	}
+
+	/*
+	 * "Corporate" incarnations of the ICH10 have an I/O region of size
+	 * 128 and 73 GPIO pins. Others ("consumer") have an I/O region of
+	 * size only 64 and 61 GPIO pins, as the ICH6, ICH7, ICH8 and ICH9
+	 * had.
+	 */
+	data->io_size = i801_gpio_cfg[type].io_size;
+	if (!force) {
+		err = acpi_check_region(data->base, data->io_size, "i801_gpio");
+		if (err)
+			goto err_disable;
+	}
+	if (!request_region(data->base, data->io_size, "i801_gpio")) {
+		dev_err(&pdev->dev, "Failed to request I/O ports (%d)", err);
+		err = -EBUSY;
+		goto err_disable;
+	}
+
+	ngroup = i801_gpio_cfg[type].ngroup;
+	for (group = 0; group < ngroup; group++)
+		data->use_sel[group] = inl(data->base +
+					   REG_GPIO_USE_SEL[group]);
+	i801_gpio_sel_fixup(data, id->device);
+	mutex_init(&data->lock);
+
+	i801_gpio_setup(&data->gpio, &pdev->dev, ngroup * 32);
+	i801_gpio_print_state(data, &pdev->dev, ngroup);
+
+	pci_set_drvdata(pdev, data);
+	err = gpiochip_add(&data->gpio);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to register GPIO (%d)\n", err);
+		goto err_release;
+	}
+
+	return 0;
+
+ err_release:
+	release_region(data->base, data->io_size);
+
+ err_disable:
+	pci_disable_device(pdev);
+
+ err_free:
+	kfree(data);
+	return err;
+}
+
+static void __devexit i801_gpio_remove(struct pci_dev *pdev)
+{
+	struct i801_gpio_data *data = pci_get_drvdata(pdev);
+	int err;
+
+	err = gpiochip_remove(&data->gpio);
+	if (err)
+		dev_err(&pdev->dev, "Failed to unregister GPIO (%d)\n", err);
+
+	release_region(data->base, data->io_size);
+	pci_disable_device(pdev);
+	kfree(data);
+}
+
+/* driver_data is the number of GPIO groups */
+static DEFINE_PCI_DEVICE_TABLE(i801_gpio_pcidev_id) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_0),
+	  .driver_data = ICH2 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_0),
+	  .driver_data = ICH2 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_0),
+	  .driver_data = ICH2 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_10),
+	  .driver_data = ICH2 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_0),
+	  .driver_data = ICH4 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_12),
+	  .driver_data = ICH4 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_0),
+	  .driver_data = ICH4 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_12),
+	  .driver_data = ICH4 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_0),
+	  .driver_data = ICH4 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_0),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_1),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_2),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_3),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_4),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_1),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_2),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_4),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_5),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_8),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_0),
+	  .driver_data = ICH10_CORP },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_1),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_2),
+	  .driver_data = ICH6 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_3),
+	  .driver_data = ICH10_CORP },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, i801_gpio_pcidev_id);
+
+static struct pci_driver i801_gpio_driver = {
+	.name		= "i801_gpio",
+	.id_table	= i801_gpio_pcidev_id,
+	.probe		= i801_gpio_probe,
+	.remove		= __devexit_p(i801_gpio_remove),
+};
+
+static int __init i801_gpio_pci_init(void)
+{
+	return pci_register_driver(&i801_gpio_driver);
+}
+module_init(i801_gpio_pci_init);
+
+static void __exit i801_gpio_pci_exit(void)
+{
+	pci_unregister_driver(&i801_gpio_driver);
+}
+module_exit(i801_gpio_pci_exit);
+
+MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
+MODULE_DESCRIPTION("Intel 82801 (ICH) GPIO driver");
+MODULE_LICENSE("GPL");


-- 
Jean Delvare
