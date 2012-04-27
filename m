Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab2D0KJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 06:09:04 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63508 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870Ab2D0KI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 06:08:59 -0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: add a driver for GPIO pins found on AMD-8111 south bridge chips
Date: Fri, 27 Apr 2012 14:08:51 +0400
Message-Id: <1335521331-16199-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver to use GPIO pins available on several AMD south bridges
(currently only AMD 8111 is supported).

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/gpio/Kconfig        |   12 +++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpio-amd8111.c |  218 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+)
 create mode 100644 drivers/gpio/gpio-amd8111.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d0c4118..b05902f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -379,6 +379,18 @@ config GPIO_BT8XX
 
 	  If unsure, say N.
 
+config GPIO_AMD8111
+	tristate "AMD 8111 GPIO driver"
+	depends on PCI
+	help
+	  The AMD 8111 south bridge contains 32 GPIO pins which can be used.
+
+	  Note, that usually system firmware/ACPI handles GPIO pins on their
+	  own and users might easily break their systems with uncarefull usage
+	  of this driver!
+
+	  If unsure, say N
+
 config GPIO_LANGWELL
 	bool "Intel Langwell/Penwell GPIO support"
 	depends on PCI && X86
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fa10df6..a6d2ac7 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_GPIO_74X164)	+= gpio-74x164.o
 obj-$(CONFIG_GPIO_AB8500)	+= gpio-ab8500.o
 obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
 obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
+obj-$(CONFIG_GPIO_AMD8111)	+= gpio-amd8111.o
 obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
diff --git a/drivers/gpio/gpio-amd8111.c b/drivers/gpio/gpio-amd8111.c
new file mode 100644
index 0000000..fc4a09e
--- /dev/null
+++ b/drivers/gpio/gpio-amd8111.c
@@ -0,0 +1,218 @@
+/*
+ * GPIO driver for AMD 8111 south bridges
+ *
+ * Copyright (c) 2012 Dmitry Eremin-Solenikov
+ *
+ * Based on the AMD RNG driver:
+ * Copyright 2005 (c) MontaVista Software, Inc.
+ * with the majority of the code coming from:
+ *
+ * Hardware driver for the Intel/AMD/VIA Random Number Generators (RNG)
+ * (c) Copyright 2003 Red Hat Inc <jgarzik@redhat.com>
+ *
+ * derived from
+ *
+ * Hardware driver for the AMD 768 Random Number Generator (RNG)
+ * (c) Copyright 2001 Red Hat Inc
+ *
+ * derived from
+ *
+ * Hardware driver for Intel i810 Random Number Generator (RNG)
+ * Copyright 2000,2001 Jeff Garzik <jgarzik@pobox.com>
+ * Copyright 2000,2001 Philipp Rumpf <prumpf@mandrakesoft.com>
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/gpio.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+
+#define PMBASE_OFFSET 0xb0
+#define PMBASE_SIZE   0x30
+#define PMBASE_GPIO(i) (0xc0 + (i))
+
+/*
+ * Data for PCI driver interface
+ *
+ * This data only exists for exporting the supported
+ * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
+ * register a pci_driver, because someone else might one day
+ * want to register another driver on the same PCI id.
+ */
+static DEFINE_PCI_DEVICE_TABLE(pci_tbl) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8111_SMBUS), 0 },
+	{ 0, },	/* terminate list */
+};
+MODULE_DEVICE_TABLE(pci, pci_tbl);
+
+struct amd_gpio {
+	struct gpio_chip	chip;
+	u32			pmbase;
+	void __iomem		*pm;
+	struct pci_dev		*pdev;
+	spinlock_t		lock; /* guards hw registers and orig table */
+	u8			orig[32];
+};
+
+#define to_agp(chip)	container_of(chip, struct amd_gpio, chip)
+
+static int amd_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct amd_gpio *agp = to_agp(chip);
+
+	agp->orig[offset] = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+
+	dev_dbg(&agp->pdev->dev, "Requested gpio %d, data %x\n", offset, agp->orig[offset]);
+
+	return 0;
+}
+
+static void amd_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct amd_gpio *agp = to_agp(chip);
+
+	dev_dbg(&agp->pdev->dev, "Freed gpio %d, data %x\n", offset, agp->orig[offset]);
+
+	iowrite8(agp->orig[offset], agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+}
+
+static void amd_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct amd_gpio *agp = to_agp(chip);
+	u8 temp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&agp->lock, flags);
+	temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+	temp = (temp & 0x1c) | (!!value);
+	iowrite8(temp, agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+	spin_unlock_irqrestore(&agp->lock, flags);
+
+	dev_dbg(&agp->pdev->dev, "Setting gpio %d, value %d, reg=%02x\n", offset, !!value, temp);
+}
+
+static int amd_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct amd_gpio *agp = to_agp(chip);
+	u8 temp;
+
+	temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+
+	dev_dbg(&agp->pdev->dev, "Getting gpio %d, reg=%02x\n", offset, temp);
+
+	return !!(temp & 0x20);
+}
+
+static int amd_gpio_dirout(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct amd_gpio *agp = to_agp(chip);
+	u8 temp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&agp->lock, flags);
+	temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+	temp = (temp & 0x10) | 0x4 | (!!value);
+	iowrite8(temp, agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+	spin_unlock_irqrestore(&agp->lock, flags);
+
+	dev_dbg(&agp->pdev->dev, "Dirout gpio %d, value %d, reg=%02x\n", offset, !!value, temp);
+
+	return 0;
+}
+
+static int amd_gpio_dirin(struct gpio_chip *chip, unsigned offset)
+{
+	struct amd_gpio *agp = to_agp(chip);
+	u8 temp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&agp->lock, flags);
+	temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+	temp = (temp & 0x10);
+	iowrite8(temp, agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
+	spin_unlock_irqrestore(&agp->lock, flags);
+
+	dev_dbg(&agp->pdev->dev, "Dirin gpio %d, reg=%02x\n", offset, temp);
+
+	return 0;
+}
+
+static struct amd_gpio gp = {
+	.chip = {
+		.label		= "AMD GPIO",
+		.owner		= THIS_MODULE,
+		.base		= -1,
+		.ngpio		= 32,
+		.request	= amd_gpio_request,
+		.free		= amd_gpio_free,
+		.set		= amd_gpio_set,
+		.get		= amd_gpio_get,
+		.direction_output = amd_gpio_dirout,
+		.direction_input = amd_gpio_dirin,
+	},
+};
+
+static int __init mod_init(void)
+{
+	int err = -ENODEV;
+	struct pci_dev *pdev = NULL;
+	const struct pci_device_id *ent;
+
+	for_each_pci_dev(pdev) {
+		ent = pci_match_id(pci_tbl, pdev);
+		if (ent)
+			goto found;
+	}
+	/* Device not found. */
+	goto out;
+
+found:
+	err = pci_read_config_dword(pdev, 0x58, &gp.pmbase);
+	if (err)
+		goto out;
+	err = -EIO;
+	gp.pmbase &= 0x0000FF00;
+	if (gp.pmbase == 0)
+		goto out;
+	if (!request_region(gp.pmbase + PMBASE_OFFSET, PMBASE_SIZE, "AMD GPIO")) {
+		dev_err(&pdev->dev, "AMD GPIO region 0x%x already in use!\n",
+			gp.pmbase + PMBASE_OFFSET);
+		err = -EBUSY;
+		goto out;
+	}
+	gp.pm = ioport_map(gp.pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+	gp.pdev = pdev;
+	gp.chip.dev = &pdev->dev;
+
+	spin_lock_init(&gp.lock);
+
+	printk(KERN_INFO "AMD-8111 GPIO detected\n");
+	err = gpiochip_add(&gp.chip);
+	if (err) {
+		printk(KERN_ERR "GPIO registering failed (%d)\n",
+		       err);
+		release_region(gp.pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+		goto out;
+	}
+out:
+	return err;
+}
+
+static void __exit mod_exit(void)
+{
+	int err = gpiochip_remove(&gp.chip);
+	WARN_ON(err);
+	ioport_unmap(gp.pm);
+	release_region(gp.pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+}
+
+module_init(mod_init);
+module_exit(mod_exit);
+
+MODULE_AUTHOR("The Linux Kernel team");
+MODULE_DESCRIPTION("GPIO driver for AMD chipsets");
+MODULE_LICENSE("GPL");
-- 
1.7.10

