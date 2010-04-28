Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0D1WWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:22:31 -0400
Received: from tex.lwn.net ([70.33.254.29]:48833 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab0D1WSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:18 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 14/30] viafb: add a driver for GPIO lines
Date: Wed, 28 Apr 2010 16:17:15 -0600
Message-Id: <1272493051-25380-15-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple gpiolib driver giving access to the GPIO lines in the
VIA framebuffer system.  A simple mechanism exists for switching lines
between GPIO and I2C, but it's only compile-time for now.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/Kconfig        |    2 +
 drivers/video/via/Makefile   |    5 +-
 drivers/video/via/via-core.c |    7 +
 drivers/video/via/via-gpio.c |  268 ++++++++++++++++++++++++++++++++++++++++++
 drivers/video/via/via-gpio.h |   15 +++
 5 files changed, 296 insertions(+), 1 deletions(-)
 create mode 100644 drivers/video/via/via-gpio.c
 create mode 100644 drivers/video/via/via-gpio.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 6e16244..22c1662 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1511,6 +1511,7 @@ config FB_VIA
        select FB_CFB_IMAGEBLIT
        select I2C_ALGOBIT
        select I2C
+       select GPIOLIB
        help
 	  This is the frame buffer device driver for Graphics chips of VIA
 	  UniChrome (Pro) Family (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
@@ -1520,6 +1521,7 @@ config FB_VIA
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called viafb.
+
 config FB_NEOMAGIC
 	tristate "NeoMagic display support"
 	depends on FB && PCI
diff --git a/drivers/video/via/Makefile b/drivers/video/via/Makefile
index f644092..2751cb2 100644
--- a/drivers/video/via/Makefile
+++ b/drivers/video/via/Makefile
@@ -4,4 +4,7 @@
 
 obj-$(CONFIG_FB_VIA) += viafb.o 
 
-viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o via-core.o
+viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o \
+	via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o \
+	via-core.o via-gpio.o
+
diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 6f8f8e2..2f7eba3 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -9,6 +9,7 @@
  */
 #include "via-core.h"
 #include "via_i2c.h"
+#include "via-gpio.h"
 #include "global.h"
 
 #include <linux/module.h>
@@ -223,6 +224,11 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 		via_fb_pci_remove(pdev);
 		return ret;
 	}
+	/*
+	 * Create the GPIOs.  We continue whether or not this succeeds;
+	 * the framebuffer might be useful even without GPIO ports.
+	 */
+	ret = viafb_create_gpios(&global_dev, adap_configs);
 	return 0;
 
 out_teardown:
@@ -232,6 +238,7 @@ out_teardown:
 
 static void __devexit via_pci_remove(struct pci_dev *pdev)
 {
+	viafb_destroy_gpios();
 	viafb_delete_i2c_busses();
 	via_fb_pci_remove(pdev);
 	via_pci_teardown_mmio(&global_dev);
diff --git a/drivers/video/via/via-gpio.c b/drivers/video/via/via-gpio.c
new file mode 100644
index 0000000..e119d21
--- /dev/null
+++ b/drivers/video/via/via-gpio.c
@@ -0,0 +1,268 @@
+/*
+ * Support for viafb GPIO ports.
+ *
+ * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
+ * Distributable under version 2 of the GNU General Public License.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/gpio.h>
+#include "via-core.h"
+#include "via-gpio.h"
+#include "global.h"
+
+/*
+ * The ports we know about.  Note that the port-25 gpios are not
+ * mentioned in the datasheet.
+ */
+
+struct viafb_gpio {
+	char *vg_name;	/* Data sheet name */
+	u16 vg_io_port;
+	u8  vg_port_index;
+	int  vg_mask_shift;
+};
+
+static struct viafb_gpio viafb_all_gpios[] = {
+	{
+		.vg_name = "VGPIO0",  /* Guess - not in datasheet */
+		.vg_io_port = VIASR,
+		.vg_port_index = 0x25,
+		.vg_mask_shift = 1
+	},
+	{
+		.vg_name = "VGPIO1",
+		.vg_io_port = VIASR,
+		.vg_port_index = 0x25,
+		.vg_mask_shift = 0
+	},
+	{
+		.vg_name = "VGPIO2",  /* aka DISPCLKI0 */
+		.vg_io_port = VIASR,
+		.vg_port_index = 0x2c,
+		.vg_mask_shift = 1
+	},
+	{
+		.vg_name = "VGPIO3",  /* aka DISPCLKO0 */
+		.vg_io_port = VIASR,
+		.vg_port_index = 0x2c,
+		.vg_mask_shift = 0
+	},
+	{
+		.vg_name = "VGPIO4",  /* DISPCLKI1 */
+		.vg_io_port = VIASR,
+		.vg_port_index = 0x3d,
+		.vg_mask_shift = 1
+	},
+	{
+		.vg_name = "VGPIO5",  /* DISPCLKO1 */
+		.vg_io_port = VIASR,
+		.vg_port_index = 0x3d,
+		.vg_mask_shift = 0
+	},
+};
+
+#define VIAFB_NUM_GPIOS ARRAY_SIZE(viafb_all_gpios)
+
+/*
+ * This structure controls the active GPIOs, which may be a subset
+ * of those which are known.
+ */
+
+struct viafb_gpio_cfg {
+	struct gpio_chip gpio_chip;
+	struct viafb_dev *vdev;
+	struct viafb_gpio *active_gpios[VIAFB_NUM_GPIOS];
+	char *gpio_names[VIAFB_NUM_GPIOS];
+};
+
+/*
+ * GPIO access functions
+ */
+static void via_gpio_set(struct gpio_chip *chip, unsigned int nr,
+			 int value)
+{
+	struct viafb_gpio_cfg *cfg = container_of(chip,
+						  struct viafb_gpio_cfg,
+						  gpio_chip);
+	u8 reg;
+	struct viafb_gpio *gpio;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cfg->vdev->reg_lock, flags);
+	gpio = cfg->active_gpios[nr];
+	reg = viafb_read_reg(VIASR, gpio->vg_port_index);
+	reg |= 0x40 << gpio->vg_mask_shift;  /* output enable */
+	if (value)
+		reg |= 0x10 << gpio->vg_mask_shift;
+	else
+		reg &= ~(0x10 << gpio->vg_mask_shift);
+	viafb_write_reg(gpio->vg_port_index, VIASR, reg);
+	spin_unlock_irqrestore(&cfg->vdev->reg_lock, flags);
+}
+
+static int via_gpio_dir_out(struct gpio_chip *chip, unsigned int nr,
+			    int value)
+{
+	via_gpio_set(chip, nr, value);
+	return 0;
+}
+
+/*
+ * Set the input direction.  I'm not sure this is right; we should
+ * be able to do input without disabling output.
+ */
+static int via_gpio_dir_input(struct gpio_chip *chip, unsigned int nr)
+{
+	struct viafb_gpio_cfg *cfg = container_of(chip,
+						  struct viafb_gpio_cfg,
+						  gpio_chip);
+	struct viafb_gpio *gpio;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cfg->vdev->reg_lock, flags);
+	gpio = cfg->active_gpios[nr];
+	viafb_write_reg_mask(gpio->vg_port_index, VIASR, 0,
+			     0x40 << gpio->vg_mask_shift);
+	spin_unlock_irqrestore(&cfg->vdev->reg_lock, flags);
+	return 0;
+}
+
+static int via_gpio_get(struct gpio_chip *chip, unsigned int nr)
+{
+	struct viafb_gpio_cfg *cfg = container_of(chip,
+						  struct viafb_gpio_cfg,
+						  gpio_chip);
+	u8 reg;
+	struct viafb_gpio *gpio;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cfg->vdev->reg_lock, flags);
+	gpio = cfg->active_gpios[nr];
+	reg = viafb_read_reg(VIASR, gpio->vg_port_index);
+	spin_unlock_irqrestore(&cfg->vdev->reg_lock, flags);
+	return reg & (0x04 << gpio->vg_mask_shift);
+}
+
+
+static struct viafb_gpio_cfg gpio_config = {
+	.gpio_chip = {
+		.label = "VIAFB onboard GPIO",
+		.owner = THIS_MODULE,
+		.direction_output = via_gpio_dir_out,
+		.set = via_gpio_set,
+		.direction_input = via_gpio_dir_input,
+		.get = via_gpio_get,
+		.base = -1,
+		.ngpio = 0,
+		.can_sleep = 0
+	}
+};
+
+/*
+ * Manage the software enable bit.
+ */
+static void viafb_gpio_enable(struct viafb_gpio *gpio)
+{
+	viafb_write_reg_mask(gpio->vg_port_index, VIASR, 0x02, 0x02);
+}
+
+static void viafb_gpio_disable(struct viafb_gpio *gpio)
+{
+	viafb_write_reg_mask(gpio->vg_port_index, VIASR, 0, 0x02);
+}
+
+
+
+
+int viafb_create_gpios(struct viafb_dev *vdev,
+		const struct via_port_cfg *port_cfg)
+{
+	int i, ngpio = 0, ret;
+	struct viafb_gpio *gpio;
+	unsigned long flags;
+
+	/*
+	 * Set up entries for all GPIOs which have been configured to
+	 * operate as such (as opposed to as i2c ports).
+	 */
+	for (i = 0; i < VIAFB_NUM_PORTS; i++) {
+		if (port_cfg[i].mode != VIA_MODE_GPIO)
+			continue;
+		for (gpio = viafb_all_gpios;
+		     gpio < viafb_all_gpios + VIAFB_NUM_GPIOS; gpio++)
+			if (gpio->vg_port_index == port_cfg[i].ioport_index) {
+				gpio_config.active_gpios[ngpio] = gpio;
+				gpio_config.gpio_names[ngpio] = gpio->vg_name;
+				ngpio++;
+			}
+	}
+	gpio_config.gpio_chip.ngpio = ngpio;
+	gpio_config.gpio_chip.names = gpio_config.gpio_names;
+	gpio_config.vdev = vdev;
+	if (ngpio == 0) {
+		printk(KERN_INFO "viafb: no GPIOs configured\n");
+		return 0;
+	}
+	/*
+	 * Enable the ports.  They come in pairs, with a single
+	 * enable bit for both.
+	 */
+	spin_lock_irqsave(&gpio_config.vdev->reg_lock, flags);
+	for (i = 0; i < ngpio; i += 2)
+		viafb_gpio_enable(gpio_config.active_gpios[i]);
+	spin_unlock_irqrestore(&gpio_config.vdev->reg_lock, flags);
+	/*
+	 * Get registered.
+	 */
+	gpio_config.gpio_chip.base = -1;  /* Dynamic */
+	ret = gpiochip_add(&gpio_config.gpio_chip);
+	if (ret) {
+		printk(KERN_ERR "viafb: failed to add gpios (%d)\n", ret);
+		gpio_config.gpio_chip.ngpio = 0;
+	}
+	return ret;
+/* Port enable ? */
+}
+
+
+int viafb_destroy_gpios(void)
+{
+	unsigned long flags;
+	int ret = 0, i;
+
+	spin_lock_irqsave(&gpio_config.vdev->reg_lock, flags);
+	/*
+	 * Get unregistered.
+	 */
+	if (gpio_config.gpio_chip.ngpio > 0) {
+		ret = gpiochip_remove(&gpio_config.gpio_chip);
+		if (ret) { /* Somebody still using it? */
+			printk(KERN_ERR "Viafb: GPIO remove failed\n");
+			goto out;
+		}
+	}
+	/*
+	 * Disable the ports.
+	 */
+	for (i = 0; i < gpio_config.gpio_chip.ngpio; i += 2)
+		viafb_gpio_disable(gpio_config.active_gpios[i]);
+	gpio_config.gpio_chip.ngpio = 0;
+out:
+	spin_unlock_irqrestore(&gpio_config.vdev->reg_lock, flags);
+	return ret;
+}
+
+/*
+ * Look up a specific gpio and return the number it was assigned.
+ */
+int viafb_gpio_lookup(const char *name)
+{
+	int i;
+
+	for (i = 0; i < gpio_config.gpio_chip.ngpio; i++)
+		if (!strcmp(name, gpio_config.active_gpios[i]->vg_name))
+			return gpio_config.gpio_chip.base + i;
+	return -1;
+}
+EXPORT_SYMBOL_GPL(viafb_gpio_lookup);
diff --git a/drivers/video/via/via-gpio.h b/drivers/video/via/via-gpio.h
new file mode 100644
index 0000000..7b53f96
--- /dev/null
+++ b/drivers/video/via/via-gpio.h
@@ -0,0 +1,15 @@
+/*
+ * Support for viafb GPIO ports.
+ *
+ * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
+ * Distributable under version 2 of the GNU General Public License.
+ */
+
+#ifndef __VIA_GPIO_H__
+#define __VIA_GPIO_H__
+
+extern int viafb_create_gpios(struct viafb_dev *vdev,
+		const struct via_port_cfg *port_cfg);
+extern int viafb_destroy_gpios(void);
+extern int viafb_gpio_lookup(const char *name);
+#endif
-- 
1.7.0.1

