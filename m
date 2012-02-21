Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2BUGVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 01:21:53 -0500
Received: from mail.active-venture.com ([67.228.131.195]:54153 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2BUGVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 01:21:51 -0500
X-Originating-IP: 99.61.165.181
Message-Id: <6.2.5.6.2.20120220221635.0273c0d0@roeck-us.net>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Mon, 20 Feb 2012 22:21:46 -0800
To: Aaron Sierra <asierra@xes-inc.com>, Jean Delvare <khali@linux-fr.org>
From: Guenter Roeck <guenter@roeck-us.net>
Subject: Re: [PATCH V5 2/3] gpio: Add support for Intel
  ICHx/3100/Series[56] GPIO
Cc: Peter Tyser <ptyser@xes-inc.com>, Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <e46cd35e-bde3-49ef-9dc9-98fe7b8354e1@zimbra>
References: <625e6c76-399b-4eb2-8f56-87caf241b87c@zimbra>
 <e46cd35e-bde3-49ef-9dc9-98fe7b8354e1@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron,

At 05:11 PM 2/20/2012, Aaron Sierra wrote:
>From: Peter Tyser <ptyser@xes-inc.com>
>
>This driver works on many Intel chipsets, including the ICH6, ICH7,
>ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
>(Cougar Point), and NM10 (Tiger Point).
>
>Additional Intel chipsets should be easily supported if needed, eg the
>ICH1-5, EP80579, etc.
>
>Tested on QM67 (Cougar Point), QM57 (Ibex Peak), 3100 (Whitmore Lake),
>and NM10 (Tiger Point).
>
>Includes work from Jean Delvare:
>         - Resource leak removal during module load/unload
>         - GPIO API bit value enforcement
>
>Also includes code cleanup from Guenter Roeck.
>
>Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
>Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
>---
>  MAINTAINERS             |    6 +
>  drivers/gpio/Kconfig    |   13 ++
>  drivers/gpio/Makefile   |    1 +
>  drivers/gpio/gpio-ich.c |  432 
> +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 452 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/gpio-ich.c
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index a1fce9a..9a0b59f 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -3284,6 +3284,12 @@ 
>W:       http://www.developer.ibm.com/welcome/netfinity/serveraid.html
>  S:     Supported
>  F:     drivers/scsi/ips.*
>
>+ICH LPC DRIVER
>+M:     Peter Tyser <ptyser@xes-inc.com>
>+S:     Maintained
>+F:     drivers/mfd/lpc_ich.c
>+F:     drivers/gpio/gpio-ich.c
>+
>  IDE SUBSYSTEM
>  M:     "David S. Miller" <davem@davemloft.net>
>  L:     linux-ide@vger.kernel.org
>diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>index d0c4118..3359f1e 100644
>--- a/drivers/gpio/Kconfig
>+++ b/drivers/gpio/Kconfig
>@@ -178,6 +178,19 @@ config GPIO_SCH
>           The Intel Tunnel Creek processor has 5 GPIOs powered by the
>           core power rail and 9 from suspend power supply.
>
>+config GPIO_ICH
>+       tristate "Intel ICH GPIO"
>+       depends on PCI && X86
>+       select MFD_CORE
>+       select LPC_ICH
>+       help
>+         Say yes here to support the GPIO functionality of a number of Intel
>+         ICH-based chipsets.  Currently supported devices: ICH6, ICH7, ICH8
>+         ICH9, ICH10, Series 5/3400 (eg Ibex Peak), Series 6/C200 (eg
>+         Cougar Point), NM10 (Tiger Point), and 3100 (Whitmore Lake).
>+
>+         If unsure, say N.
>+
>  config GPIO_VX855
>         tristate "VIA VX855/VX875 GPIO"
>         depends on PCI
>diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
>index fa10df6..b538830 100644
>--- a/drivers/gpio/Makefile
>+++ b/drivers/gpio/Makefile
>@@ -44,6 +44,7 @@ obj-$(CONFIG_GPIO_PXA)                += gpio-pxa.o
>  obj-$(CONFIG_GPIO_RDC321X)     += gpio-rdc321x.o
>  obj-$(CONFIG_PLAT_SAMSUNG)     += gpio-samsung.o
>  obj-$(CONFIG_ARCH_SA1100)      += gpio-sa1100.o
>+obj-$(CONFIG_GPIO_ICH)         += gpio-ich.o
>  obj-$(CONFIG_GPIO_SCH)         += gpio-sch.o
>  obj-$(CONFIG_GPIO_STMPE)       += gpio-stmpe.o
>  obj-$(CONFIG_GPIO_SX150X)      += gpio-sx150x.o
>diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
>new file mode 100644
>index 0000000..e2c737c
>--- /dev/null
>+++ b/drivers/gpio/gpio-ich.c
>@@ -0,0 +1,432 @@
>+/*
>+ * Intel ICH6-10, Series 5 and 6 GPIO driver
>+ *
>+ * Copyright (C) 2010 Extreme Engineering Solutions.
>+ *
>+ * This program is free software; you can redistribute it and/or modify
>+ * it under the terms of the GNU General Public License as published by
>+ * the Free Software Foundation; either version 2 of the License, or
>+ * (at your option) any later version.
>+ *
>+ * This program is distributed in the hope that it will be useful,
>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>+ * GNU General Public License for more details.
>+ *
>+ * You should have received a copy of the GNU General Public License
>+ * along with this program; if not, write to the Free Software
>+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>+ */
>+
>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>+
>+#include <linux/module.h>
>+#include <linux/pci.h>
>+#include <linux/gpio.h>
>+#include <linux/platform_device.h>
>+#include <linux/mfd/lpc_ich.h>
>+
>+#define DRV_NAME "gpio_ich"
>+
>+/* PCI config register offsets into LPC I/F - D31:F0 */
>+#define PCI_ICHX_ACPI_BAR      0x40
>+#define PCI_ICHX_GPIO_BAR      0x48
>+#define PCI_ICHX_GPIO_CTRL     0x4C
>+
>+/*
>+ * GPIO register offsets in GPIO I/O space.
>+ * Each chunk of 32 GPIOs is manipulated via its own USE_SELx, IO_SELx, and
>+ * LVLx registers.  Logic in the read/write functions takes a register and
>+ * an absolute bit number and determines the proper register offset and bit
>+ * number in that register.  For example, to read the value of GPIO bit 50
>+ * the code would access offset ichx_regs[2(=GPIO_LVL)][1(=50/32)],
>+ * bit 18 (50%32).
>+ */
>+enum GPIO_REG {
>+       GPIO_USE_SEL = 0,
>+       GPIO_IO_SEL,
>+       GPIO_LVL,
>+};
>+
>+static const u8 ichx_regs[3][3] = {
>+       {0x00, 0x30, 0x40},     /* USE_SEL[1-3] offsets */
>+       {0x04, 0x34, 0x44},     /* IO_SEL[1-3] offsets */
>+       {0x0c, 0x38, 0x48},     /* LVL[1-3] offsets */
>+};
>+
>+#define ICHX_WRITE(val, reg, base_res) outl(val, (reg) + (base_res)->start)
>+#define ICHX_READ(reg, base_res)       inl((reg) + (base_res)->start)
>+
>+struct ichx_desc {
>+       /* Max GPIO pins the chipset can have */
>+       uint ngpio;
>+
>+       /* Whether the chipset has GPIO in GPE0_STS in the PM IO region */
>+       bool uses_gpe0;
>+
>+       /* USE_SEL is bogus on some chipsets, eg 3100 */
>+       u32 use_sel_ignore[3];
>+
>+       /* Some chipsets have quirks, let these use their own request/get */
>+       int (*request)(struct gpio_chip *chip, unsigned offset);
>+       int (*get)(struct gpio_chip *chip, unsigned offset);
>+};
>+
>+static struct {
>+       spinlock_t lock;
>+       struct platform_device *dev;
>+       struct gpio_chip chip;
>+       struct resource *gpio_base;     /* GPIO IO base */
>+       struct resource *pm_base;       /* Power Mangagment IO base */
>+       struct ichx_desc *desc; /* Pointer to chipset-specific description */
>+       u32 orig_gpio_ctrl;     /* Orig CTRL value, used to restore on exit */
>+} ichx_priv;
>+
>+static int modparam_gpiobase = -1;     /* dynamic */
>+module_param_named(gpiobase, modparam_gpiobase, int, 0444);
>+MODULE_PARM_DESC(gpiobase, "The GPIO number base. -1 means dynamic, "
>+                          "which is the default.");
>+
>+static int ichx_write_bit(int reg, unsigned nr, int val, int verify)
>+{
>+       unsigned long flags;
>+       u32 data, tmp;
>+       int reg_nr = nr / 32;
>+       int bit = nr & 0x1f;
>+       int ret = 0;
>+
>+       spin_lock_irqsave(&ichx_priv.lock, flags);
>+
>+       data = ICHX_READ(ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
>+       if (val)
>+               data |= 1 << bit;
>+       else
>+               data &= ~(1 << bit);
>+       ICHX_WRITE(data, ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
>+       tmp = ICHX_READ(ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
>+       if (verify && data != tmp)
>+               ret = -EPERM;
>+
>+       spin_unlock_irqrestore(&ichx_priv.lock, flags);
>+
>+       return ret;
>+}
>+
>+static int ichx_read_bit(int reg, unsigned nr)
>+{
>+       unsigned long flags;
>+       u32 data;
>+       int reg_nr = nr / 32;
>+       int bit = nr & 0x1f;
>+
>+       spin_lock_irqsave(&ichx_priv.lock, flags);
>+
>+       data = ICHX_READ(ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
>+
>+       spin_unlock_irqrestore(&ichx_priv.lock, flags);
>+
>+       return data & (1 << bit) ? 1 : 0;
>+}
>+
>+static int ichx_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
>+{
>+       /*
>+       * Try setting pin as an input and verify it worked since many pins
>+       * are output-only.
>+       */
>+       if (ichx_write_bit(GPIO_IO_SEL, nr, 1, 1))
>+               return -EINVAL;
>+
>+       return 0;
>+}
>+
>+static int ichx_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
>+                                       int val)
>+{
>+       /* Set GPIO output value. */
>+       ichx_write_bit(GPIO_LVL, nr, val, 0);
>+
>+       /*
>+       * Try setting pin as an output and verify it worked since many pins
>+       * are input-only.
>+       */
>+       if (ichx_write_bit(GPIO_IO_SEL, nr, 0, 1))
>+               return -EINVAL;
>+
>+       return 0;
>+}
>+
>+static int ichx_gpio_get(struct gpio_chip *chip, unsigned nr)
>+{
>+       return ichx_read_bit(GPIO_LVL, nr);
>+}
>+
>+static int ich6_gpio_get(struct gpio_chip *chip, unsigned nr)
>+{
>+       unsigned long flags;
>+       u32 data;
>+
>+       /*
>+       * GPI 0 - 15 need to be read from the power management registers on
>+       * a ICH6/3100 bridge.
>+       */
>+       if (nr < 16 && ichx_priv.pm_base) {
>+               spin_lock_irqsave(&ichx_priv.lock, flags);
>+
>+               /* GPI 0 - 15 are latched, write 1 to clear*/
>+               ICHX_WRITE(1 << (16 + nr), 0, ichx_priv.pm_base);
>+               data = ICHX_READ(0, ichx_priv.pm_base);
>+
>+               spin_unlock_irqrestore(&ichx_priv.lock, flags);
>+
>+               return (data >> 16) & (1 << nr) ? 1 : 0;
>+       } else {


unless I am missing something, this still does not address the error 
case where pm_base
is not set because of an ACPI conflict (.uses_gpe0 is true, but 
.pm_base is NULL).

Not sure what to do in that case, but simply calling ichx_gpio_get 
doesn't seem to be
the correct solution.

>+               return ichx_gpio_get(chip, nr);
>+       }
>+}
>+
>+static int ichx_gpio_request(struct gpio_chip *chip, unsigned nr)
>+{
>+       /*
>+       * Note we assume the BIOS properly set a bridge's USE value.  Some
>+       * chips (eg Intel 3100) have bogus USE values though, so first see if
>+       * the chipset's USE value can be trusted for this specific bit.
>+       * If it can't be trusted, assume that the pin can be used as a GPIO.
>+       */
>+       if (ichx_priv.desc->use_sel_ignore[nr / 32] & (1 << (nr & 0x1f)))
>+               return 1;
>+
>+       return ichx_read_bit(GPIO_USE_SEL, nr) ? 0 : -ENODEV;
>+}
>+
>+static int ich6_gpio_request(struct gpio_chip *chip, unsigned nr)
>+{
>+       /*
>+       * Fixups for bits 16 and 17 are necessary on the Intel ICH6/3100
>+       * bridge as they are controlled by USE register bits 0 and 1.  See
>+       * "Table 704 GPIO_USE_SEL1 register" in the i3100 datasheet for
>+       * additional info.
>+       */
>+       if (nr == 16 || nr == 17)
>+               nr -= 16;
>+
>+       return ichx_gpio_request(chip, nr);
>+}
>+
>+static void ichx_gpio_set(struct gpio_chip *chip, unsigned nr, int val)
>+{
>+       ichx_write_bit(GPIO_LVL, nr, val, 0);
>+}
>+
>+static void __devinit ichx_gpiolib_setup(struct gpio_chip *chip)
>+{
>+       chip->owner = THIS_MODULE;
>+       chip->label = DRV_NAME;
>+       chip->dev = &ichx_priv.dev->dev;
>+
>+       /* Allow chip-specific overrides of request()/get() */
>+       chip->request = ichx_priv.desc->request ?
>+               ichx_priv.desc->request : ichx_gpio_request;
>+       chip->get = ichx_priv.desc->get ?
>+               ichx_priv.desc->get : ichx_gpio_get;
>+
>+       chip->set = ichx_gpio_set;
>+       chip->direction_input = ichx_gpio_direction_input;
>+       chip->direction_output = ichx_gpio_direction_output;
>+       chip->base = modparam_gpiobase;
>+       chip->ngpio = ichx_priv.desc->ngpio;
>+       chip->can_sleep = 0;
>+       chip->dbg_show = NULL;
>+}
>+
>+/* ICH6-based, 631xesb-based */
>+static struct ichx_desc ich6_desc = {
>+       /* Bridges using the ICH6 controller need fixups for GPIO 0 - 17 */
>+       .request = ich6_gpio_request,
>+       .get = ich6_gpio_get,
>+
>+       /* GPIO 0-15 are read in the GPE0_STS PM register */
>+       .uses_gpe0 = true,
>+
>+       .ngpio = 50,
>+};
>+
>+/* Intel 3100 */
>+static struct ichx_desc i3100_desc = {
>+       /*
>+       * Bits 16,17, 20 of USE_SEL and bit 16 of USE_SEL2 always read 0 on
>+       * the Intel 3100.  See "Table 712. GPIO Summary Table" of 3100
>+       * Datasheet for more info.
>+       */
>+       .use_sel_ignore = {0x00130000, 0x00010000, 0x0},
>+
>+       /* The 3100 needs fixups for GPIO 0 - 17 */
>+       .request = ich6_gpio_request,
>+       .get = ich6_gpio_get,
>+
>+       /* GPIO 0-15 are read in the GPE0_STS PM register */
>+       .uses_gpe0 = true,
>+
>+       .ngpio = 50,
>+};
>+
>+/* ICH7 and ICH8-based */
>+static struct ichx_desc ich7_desc = {
>+       .ngpio = 50,
>+};
>+
>+/* ICH9-based */
>+static struct ichx_desc ich9_desc = {
>+       .ngpio = 61,
>+};
>+
>+/* ICH10-based - Consumer/corporate versions have different amount of GPIO */
>+static struct ichx_desc ich10_cons_desc = {
>+       .ngpio = 61,
>+};
>+static struct ichx_desc ich10_corp_desc = {
>+       .ngpio = 72,
>+};
>+
>+/* Intel 5 series, 6 series, 3400 series, and C200 series */
>+static struct ichx_desc intel5_desc = {
>+       .ngpio = 76,
>+};
>+
>+static int __devinit ichx_gpio_probe(struct platform_device *pdev)
>+{
>+       struct resource *res_base, *res_pm;
>+       int err;
>+       struct lpc_ich_info *ich_info = pdev->dev.platform_data;
>+
>+       if (!ich_info)
>+               return -ENODEV;
>+
>+       ichx_priv.dev = pdev;
>+
>+       switch (ich_info->gpio_version) {
>+       case ICH_I3100_GPIO:
>+               ichx_priv.desc = &i3100_desc;
>+               break;
>+       case ICH_V5_GPIO:
>+               ichx_priv.desc = &intel5_desc;
>+               break;
>+       case ICH_V6_GPIO:
>+               ichx_priv.desc = &ich6_desc;
>+               break;
>+       case ICH_V7_GPIO:
>+               ichx_priv.desc = &ich7_desc;
>+               break;
>+       case ICH_V9_GPIO:
>+               ichx_priv.desc = &ich9_desc;
>+               break;
>+       case ICH_V10CORP_GPIO:
>+               ichx_priv.desc = &ich10_corp_desc;
>+               break;
>+       case ICH_V10CONS_GPIO:
>+               ichx_priv.desc = &ich10_cons_desc;
>+               break;
>+       default:
>+               return -ENODEV;
>+       }
>+
>+       res_base = platform_get_resource(pdev, IORESOURCE_IO, ICH_RES_GPIO);
>+       if (!res_base || !res_base->start || !res_base->end)
>+               return -ENODEV;
>+
>+       if (!request_region(res_base->start, resource_size(res_base),
>+                               pdev->name))
>+               return -EBUSY;
>+
>+       ichx_priv.gpio_base = res_base;
>+
>+       /*
>+       * If necessary, determine the I/O address of ACPI/power management
>+       * registers which are needed to read the the GPE0 register 
>for GPI pins
>+       * 0 - 15 on some chipsets.
>+       */
>+       if (!ichx_priv.desc->uses_gpe0)
>+               goto init;
>+
>+       res_pm = platform_get_resource(pdev, IORESOURCE_IO, ICH_RES_GPE0);
>+       if (!res_pm || !res_pm->start || !res_pm->end) {
>+               pr_warn("ACPI BAR is unavailable, GPI 0 - 15 unavailable\n");
>+               goto init;
>+       }
>+
>+       if (!request_region(res_pm->start, resource_size(res_pm),
>+                       pdev->name)) {
>+               pr_warn("ACPI BAR is busy, GPI 0 - 15 unavailable\n");
>+               goto init;
>+       }
>+
>+       ichx_priv.pm_base = res_pm;
>+
>+init:
>+       ichx_gpiolib_setup(&ichx_priv.chip);
>+       err = gpiochip_add(&ichx_priv.chip);
>+       if (err) {
>+               pr_err("Failed to register GPIOs\n");
>+               goto add_err;
>+       }
>+
>+       pr_info("GPIO from %d to %d on %s\n", ichx_priv.chip.base,
>+              ichx_priv.chip.base + ichx_priv.chip.ngpio - 1, DRV_NAME);
>+
>+       return 0;
>+
>+add_err:
>+       release_region(ichx_priv.gpio_base->start,
>+                       resource_size(ichx_priv.gpio_base));
>+       if (ichx_priv.pm_base)
>+               release_region(ichx_priv.pm_base->start,
>+                               resource_size(ichx_priv.pm_base));
>+       return err;
>+}
>+
>+static int __devexit ichx_gpio_remove(struct platform_device *pdev)
>+{
>+       int err;
>+
>+       err = gpiochip_remove(&ichx_priv.chip);
>+       if (err) {
>+               dev_err(&pdev->dev, "%s failed, %d\n",
>+                               "gpiochip_remove()", err);
>+               return err;
>+       }
>+
>+       release_region(ichx_priv.gpio_base->start,
>+                               resource_size(ichx_priv.gpio_base));
>+       if (ichx_priv.pm_base)
>+               release_region(ichx_priv.pm_base->start,
>+                               resource_size(ichx_priv.pm_base));
>+
>+       return 0;
>+}
>+
>+static struct platform_driver ichx_gpio_driver = {
>+       .driver         = {
>+               .owner  = THIS_MODULE,
>+               .name   = DRV_NAME,
>+       },
>+       .probe          = ichx_gpio_probe,
>+       .remove         = __devexit_p(ichx_gpio_remove),
>+};
>+
>+static int __devinit ichx_gpio_init_module(void)
>+{
>+       return platform_driver_register(&ichx_gpio_driver);
>+}
>+
>+static void __devexit ichx_gpio_exit_module(void)
>+{
>+       platform_driver_unregister(&ichx_gpio_driver);
>+}
>+
>+subsys_initcall(ichx_gpio_init_module);
>+module_exit(ichx_gpio_exit_module);
>+
>+MODULE_AUTHOR("Peter Tyser <ptyser@xes-inc.com>");
>+MODULE_DESCRIPTION("GPIO interface for Intel ICH series");
>+MODULE_LICENSE("GPL");
>+MODULE_ALIAS("platform:"DRV_NAME);
>--
>1.7.0.4

