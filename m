Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0I3U4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:56:00 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:25508 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932421Ab0I3Uz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:55:58 -0400
From: Daniel Drake <dsd@laptop.org>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Cc: laforge@gnumonks.org
Subject: [PATCH 3/3] Add VIA VX855 GPIO driver
Message-Id: <20100930205548.66C179D401B@zog.reactivated.net>
Date: Thu, 30 Sep 2010 21:55:48 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=Dc4OT_6SFpYA:10 a=Op-mwl0xAAAA:8 a=OA8392kgAAAA:8 a=etD4TZLk5thmHfiUyIEA:9 a=UZ5EznctjQI96FSNbsUA:7 a=OSeQKP86734hRxNZc4O5iXjTgJsA:4 a=d4CUUju0HPYA:10 a=GTw93z-ti4wA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for supporting the upcoming VX855 camera and OLPC DCON
drivers, as well as the advanced viafb features on non-OLPC hardware
based on this chip.

Based on earlier work by Harald Welte.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/gpio/Kconfig      |   12 ++
 drivers/gpio/Makefile     |    1 +
 drivers/gpio/vx855_gpio.c |  332 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 345 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/vx855_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 510aa20..bd9e009 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -111,6 +111,18 @@ config GPIO_SCH
 	  This driver can also be built as a module. If so, the module
 	  will be called sch-gpio.
 
+config GPIO_VX855
+	tristate "VIA VX855/VX875 GPIO"
+	depends on GPIOLIB
+	select MFD_CORE
+	select MFD_VX855
+	help
+	  Support access to the VX855/VX875 GPIO lines through the gpio library.
+
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fc6019d..7ddfeea 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -37,3 +37,4 @@ obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
 obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
 obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
+obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
diff --git a/drivers/gpio/vx855_gpio.c b/drivers/gpio/vx855_gpio.c
new file mode 100644
index 0000000..8a98ee5
--- /dev/null
+++ b/drivers/gpio/vx855_gpio.c
@@ -0,0 +1,332 @@
+/*
+ * Linux GPIOlib driver for the VIA VX855 integrated southbridge GPIO
+ *
+ * Copyright (C) 2009 VIA Technologies, Inc.
+ * Copyright (C) 2010 One Laptop per Child
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
+#define MODULE_NAME "vx855_gpio"
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
+	u32 io_gpi;
+	u32 io_gpo;
+	bool gpi_reserved;
+	bool gpo_reserved;
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
+	reg_out = inl(vg->io_gpo);
+	reg_out |= gpio_o_bit(nr - NR_VX855_GPInO);
+	outl(reg_out, vg->io_gpo);
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
+		reg_in = inl(vg->io_gpi);
+		if (reg_in & gpi_i_bit(nr))
+			ret = 1;
+	} else if (nr < NR_VX855_GPInO) {
+		/* GPO don't have an input bit, we need to read it
+		 * back from the output register */
+		reg_in = inl(vg->io_gpo);
+		if (reg_in & gpo_o_bit(nr - NR_VX855_GPI))
+			ret = 1;
+	} else {
+		reg_in = inl(vg->io_gpi);
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
+	reg_out = inl(vg->io_gpo);
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
+	outl(reg_out, vg->io_gpo);
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
+/* This platform device is ordinarily registered by the vx855 mfd driver */
+static __devinit int vx855gpio_probe(struct platform_device *pdev)
+{
+	struct resource *res_gpi;
+	struct resource *res_gpo;
+	struct vx855_gpio *vg;
+	int ret;
+
+	res_gpi = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	res_gpo = platform_get_resource(pdev, IORESOURCE_IO, 1);
+	if (!res_gpi || !res_gpo)
+		return -EBUSY;
+
+	vg = kzalloc(sizeof(*vg), GFP_KERNEL);
+	if (!vg)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, vg);
+
+	dev_info(&pdev->dev, "found VX855 GPIO controller\n");
+	vg->io_gpi = res_gpi->start;
+	vg->io_gpo = res_gpo->start;
+	spin_lock_init(&vg->lock);
+
+	/*
+	 * A single byte is used to control various GPIO ports on the VX855,
+	 * and in the case of the OLPC XO-1.5, some of those ports are used
+	 * for switches that are interpreted and exposed through ACPI. ACPI
+	 * will have reserved the region, so our own reservation will not
+	 * succeed. Ignore and continue.
+	 */
+
+	if (!request_region(res_gpi->start, resource_size(res_gpi),
+			MODULE_NAME "_gpi"))
+		dev_warn(&pdev->dev,
+			"GPI I/O resource busy, probably claimed by ACPI\n");
+	else
+		vg->gpi_reserved = true;
+
+	if (!request_region(res_gpo->start, resource_size(res_gpo),
+			MODULE_NAME "_gpo"))
+		dev_warn(&pdev->dev,
+			"GPO I/O resource busy, probably claimed by ACPI\n");
+	else
+		vg->gpo_reserved = true;
+
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
+	if (vg->gpi_reserved)
+		release_region(res_gpi->start, resource_size(res_gpi));
+	if (vg->gpo_reserved)
+		release_region(res_gpi->start, resource_size(res_gpo));
+	platform_set_drvdata(pdev, NULL);
+	kfree(vg);
+	return ret;
+}
+
+static int __devexit vx855gpio_remove(struct platform_device *pdev)
+{
+	struct vx855_gpio *vg = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	if (gpiochip_remove(&vg->gpio))
+		dev_err(&pdev->dev, "unable to remove gpio_chip?\n");
+
+	if (vg->gpi_reserved) {
+		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+		release_region(res->start, resource_size(res));
+	}
+	if (vg->gpo_reserved) {
+		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
+		release_region(res->start, resource_size(res));
+	}
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(vg);
+	return 0;
+}
+
+static struct platform_driver vx855gpio_driver = {
+	.driver = {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= vx855gpio_probe,
+	.remove		= __devexit_p(vx855gpio_remove),
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
+MODULE_ALIAS("platform:vx855_gpio");
-- 
1.7.2.3

