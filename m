Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab1E0Gmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:42:43 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:43526 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1E0Gmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:42:42 -0400
Date: Fri, 27 May 2011 00:42:38 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Syed S Azam <Syed.Azam@hp.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v6] gpio: Add support for Intel ICHx/3100/Series[56] GPIO
Message-ID: <20110527064238.GA31271@ponder.secretlab.ca>
References: <1299022100-14564-4-git-send-email-ptyser@xes-inc.com>
 <1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 11:35:54AM -0500, Peter Tyser wrote:
> This driver works on many Intel chipsets, including the ICH6, ICH7,
> ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> (Cougar Point), and NM10 (Tiger Point).
> 
> Additional Intel chipsets should be easily supported if needed, eg the
> ICH1-5, EP80579, etc.
> 
> Tested on a QM57 (Ibex Peak), 3100 (Whitmore Lake) , and
> NM10 (Tiger Point).
> 
> Cc: Alek Du <alek.du@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Syed S Azam <Syed.Azam@hp.com>
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> Tested-by: Vincent Palatin <vpalatin@chromium.org>

Hmmm, I merged a patch from Jean Delvare adding support for Intel
82801 gpio pins[1].  Does this driver support the same hardware?  I see
the same PCI ids.

[1] https://lkml.org/lkml/2011/4/19/170

Also, another comment below about module init.

> ---
> Changes since v1:
> - Fixed grammar in Kconfig menu entry 
> 
> Changes since v2:
> - Use GPIOF_DIR_* defines
> 
> Changes since v3:
> - Added Vincent's signed-off/tested-by
> - Added Tigerpoint PCI ID
> 
> Changes since v4:
> - Integrated feedback from Joe:
>    - Fixed comment before ;
>    - Fixed bridge typo
>    - Updated to use pr_fmt and pr_<level>
> 
> Changes since v5:
> - Listed NM10 in Kconfig description
> - Removed get_direction() support
>    - The get_direction() support was a new feature that is
>      not in the mainline kernel and I didn't want it to
>      gate adding this driver as a number of people have
>      asked about it off-list
> 
> I still plan on submitting support for get_direction(), just
> been busy at work recently.
> 
>  MAINTAINERS              |    5 +
>  drivers/gpio/Kconfig     |   11 +
>  drivers/gpio/Makefile    |    1 +
>  drivers/gpio/ichx_gpio.c |  545 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 562 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/ichx_gpio.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1e2724e..29fd490 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3135,6 +3135,11 @@ W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
>  S:	Supported
>  F:	drivers/scsi/ips.*
>  
> +ICHX GPIO DRIVER
> +M:	Peter Tyser <ptyser@xes-inc.com>
> +S:	Maintained
> +F:	drivers/gpio/ichx_gpio.c
> +
>  IDE SUBSYSTEM
>  M:	"David S. Miller" <davem@davemloft.net>
>  L:	linux-ide@vger.kernel.org
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d3b2953..dc80605 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -322,6 +322,17 @@ config GPIO_BT8XX
>  
>  	  If unsure, say N.
>  
> +config GPIO_ICHX
> +	tristate "Intel ICHx GPIO"
> +	depends on PCI && GPIOLIB && X86
> +	help
> +	  Say yes here to support the GPIO functionality of a number of Intel
> +	  ICH-based chipsets.  Currently supported devices: ICH6, ICH7, ICH8
> +	  ICH9, ICH10, Series 5/3400 (eg Ibex Peak), Series 6/C200 (eg
> +	  Cougar Point), NM10 (Tiger Point), and 3100 (Whitmore Lake).
> +
> +	  If unsure, say N.
> +
>  config GPIO_LANGWELL
>  	bool "Intel Langwell/Penwell GPIO support"
>  	depends on PCI && X86
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index becef59..23d8bf6 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
>  obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
>  obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
>  obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
> +obj-$(CONFIG_GPIO_ICHX)		+= ichx_gpio.o
>  obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
>  obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
>  obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
> diff --git a/drivers/gpio/ichx_gpio.c b/drivers/gpio/ichx_gpio.c
> new file mode 100644
> index 0000000..0f815c5
> --- /dev/null
> +++ b/drivers/gpio/ichx_gpio.c
> @@ -0,0 +1,545 @@
> +/*
> + * Intel ICH6-10, Series 5 and 6 GPIO driver
> + *
> + * Copyright (C) 2010 Extreme Engineering Solutions.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/gpio.h>
> +#include <linux/platform_device.h>
> +
> +#define DRV_NAME "ichx_gpio"
> +
> +/* PCI config register offsets into LPC I/F - D31:F0 */
> +#define PCI_ICHX_ACPI_BAR	0x40
> +#define PCI_ICHX_GPIO_BAR	0x48
> +#define PCI_ICHX_GPIO_CTRL	0x4C
> +
> +/*
> + * GPIO register offsets in GPIO I/O space.
> + * Each chunk of 32 GPIOs is manipulated via its own USE_SELx, IO_SELx, and
> + * LVLx registers.  Logic in the read/write functions takes a register and
> + * an absolute bit number and determines the proper register offset and bit
> + * number in that register.  For example, to read the value of GPIO bit 50
> + * the code would access offset ichx_regs[2(=GPIO_LVL)][1(=50/32)],
> + * bit 18 (50%32).
> + */
> +enum GPIO_REG {
> +	GPIO_USE_SEL = 0,
> +	GPIO_IO_SEL,
> +	GPIO_LVL,
> +};
> +static const u8 ichx_regs[3][3] = {
> +	{0x00, 0x30, 0x40},	/* USE_SEL[1-3] offsets */
> +	{0x04, 0x34, 0x44},	/* IO_SEL[1-3] offsets */
> +	{0x0c, 0x38, 0x48},	/* LVL[1-3] offsets */
> +};
> +
> +#define ICHX_GPIO_WRITE(val, reg)	outl(val, (reg) + ichx_priv.gpio_base)
> +#define ICHX_GPIO_READ(reg)		inl((reg) + ichx_priv.gpio_base)
> +#define ICHX_PM_WRITE(val, reg)		outl(val, (reg) + ichx_priv.pm_base)
> +#define ICHX_PM_READ(reg)		inl((reg) + ichx_priv.pm_base)
> +
> +/* Convenient wrapper to make our PCI ID table */
> +#define ICHX_GPIO_PCI_DEVICE(dev, data) \
> +	.vendor = PCI_VENDOR_ID_INTEL,	\
> +	.device = dev,			\
> +	.subvendor = PCI_ANY_ID,	\
> +	.subdevice = PCI_ANY_ID,	\
> +	.class = 0,			\
> +	.class_mask = 0,		\
> +	.driver_data = (ulong)data
> +
> +struct ichx_desc {
> +	/* Max GPIO pins the chipset can have */
> +	uint ngpio;
> +
> +	/* The offset of GPE0_STS in the PM IO region, 0 if unneeded */
> +	uint gpe0_sts_ofs;
> +
> +	/* USE_SEL is bogus on some chipsets, eg 3100 */
> +	u32 use_sel_ignore[3];
> +
> +	/* Some chipsets have quirks, let these use their own request/get */
> +	int (*request)(struct gpio_chip *chip, unsigned offset);
> +	int (*get)(struct gpio_chip *chip, unsigned offset);
> +};
> +
> +static struct {
> +	spinlock_t lock;
> +	struct platform_device *dev;
> +	struct pci_dev *pdev;
> +	struct gpio_chip chip;
> +	unsigned long gpio_base;/* GPIO IO base */
> +	unsigned long pm_base;	/* Power Mangagment IO base */
> +	struct ichx_desc *desc;	/* Pointer to chipset-specific description */
> +	u32 orig_gpio_ctrl;	/* Orig CTRL value, used to restore on exit */
> +} ichx_priv;
> +
> +static struct platform_device *ichx_gpio_platform_device;
> +
> +static int modparam_gpiobase = -1;	/* dynamic */
> +module_param_named(gpiobase, modparam_gpiobase, int, 0444);
> +MODULE_PARM_DESC(gpiobase, "The GPIO number base. -1 means dynamic, "
> +			   "which is the default.");
> +
> +static int ichx_write_bit(int reg, unsigned nr, int val, int verify)
> +{
> +	unsigned long flags;
> +	u32 data;
> +	int reg_nr = nr / 32;
> +	int bit = nr & 0x1f;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(&ichx_priv.lock, flags);
> +
> +	data = ICHX_GPIO_READ(ichx_regs[reg][reg_nr]);
> +	data = (data & ~(1 << bit)) | (val << bit);
> +	ICHX_GPIO_WRITE(data, ichx_regs[reg][reg_nr]);
> +	if (verify && (data != ICHX_GPIO_READ(ichx_regs[reg][reg_nr])))
> +		ret = -EPERM;
> +
> +	spin_unlock_irqrestore(&ichx_priv.lock, flags);
> +
> +	return ret;
> +}
> +
> +static int ichx_read_bit(int reg, unsigned nr)
> +{
> +	unsigned long flags;
> +	u32 data;
> +	int reg_nr = nr / 32;
> +	int bit = nr & 0x1f;
> +
> +	spin_lock_irqsave(&ichx_priv.lock, flags);
> +
> +	data = ICHX_GPIO_READ(ichx_regs[reg][reg_nr]);
> +
> +	spin_unlock_irqrestore(&ichx_priv.lock, flags);
> +
> +	return data & (1 << bit) ? 1 : 0;
> +}
> +
> +static int ichx_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
> +{
> +	/*
> +	 * Try setting pin as an input and verify it worked since many pins
> +	 * are output-only.
> +	 */
> +	if (ichx_write_bit(GPIO_IO_SEL, nr, 1, 1))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int ichx_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
> +					int val)
> +{
> +	/* Set GPIO output value. */
> +	ichx_write_bit(GPIO_LVL, nr, val, 0);
> +
> +	/*
> +	 * Try setting pin as an output and verify it worked since many pins
> +	 * are input-only.
> +	 */
> +	if (ichx_write_bit(GPIO_IO_SEL, nr, 0, 1))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int ichx_gpio_get(struct gpio_chip *chip, unsigned nr)
> +{
> +	return ichx_read_bit(GPIO_LVL, nr);
> +}
> +
> +static int ich6_gpio_get(struct gpio_chip *chip, unsigned nr)
> +{
> +	unsigned long flags;
> +	u32 data;
> +
> +	/*
> +	 * GPI 0 - 15 need to be read from the power management registers on
> +	 * a ICH6/3100 bridge.
> +	 */
> +	if (nr < 16) {
> +		spin_lock_irqsave(&ichx_priv.lock, flags);
> +
> +		/* GPI 0 - 15 are latched, write 1 to clear*/
> +		ICHX_PM_WRITE(1 << (16 + nr), ichx_priv.desc->gpe0_sts_ofs);
> +
> +		data = ICHX_PM_READ(ichx_priv.desc->gpe0_sts_ofs);
> +
> +		spin_unlock_irqrestore(&ichx_priv.lock, flags);
> +
> +		return (data >> 16) & (1 << nr) ? 1 : 0;
> +	} else {
> +		return ichx_gpio_get(chip, nr);
> +	}
> +}
> +
> +static int ichx_gpio_request(struct gpio_chip *chip, unsigned nr)
> +{
> +	/*
> +	 * Note we assume the BIOS properly set a bridge's USE value.  Some
> +	 * chips (eg Intel 3100) have bogus USE values though, so first see if
> +	 * the chipset's USE value can be trusted for this specific bit.
> +	 * If it can't be trusted, assume that the pin can be used as a GPIO.
> +	 */
> +	if (ichx_priv.desc->use_sel_ignore[nr / 32] & (1 << (nr & 0x1f)))
> +		return 1;
> +
> +	return ichx_read_bit(GPIO_USE_SEL, nr) ? 0 : -ENODEV;
> +}
> +
> +static int ich6_gpio_request(struct gpio_chip *chip, unsigned nr)
> +{
> +	/*
> +	 * Fixups for bits 16 and 17 are necessary on the Intel ICH6/3100
> +	 * bridge as they are controlled by USE register bits 0 and 1.  See
> +	 * "Table 704 GPIO_USE_SEL1 register" in the i3100 datasheet for
> +	 * additional info.
> +	 */
> +	if ((nr == 16) || (nr == 17))
> +		nr -= 16;
> +
> +	return ichx_gpio_request(chip, nr);
> +}
> +
> +static void ichx_gpio_set(struct gpio_chip *chip, unsigned nr, int val)
> +{
> +	ichx_write_bit(GPIO_LVL, nr, val, 0);
> +}
> +
> +static void __devinit ichx_gpiolib_setup(struct gpio_chip *chip)
> +{
> +	chip->owner = THIS_MODULE;
> +	chip->label = DRV_NAME;
> +
> +	/* Allow chip-specific overrides of request()/get() */
> +	chip->request = ichx_priv.desc->request ?
> +		ichx_priv.desc->request : ichx_gpio_request;
> +	chip->get = ichx_priv.desc->get ?
> +		ichx_priv.desc->get : ichx_gpio_get;
> +
> +	chip->set = ichx_gpio_set;
> +	chip->direction_input = ichx_gpio_direction_input;
> +	chip->direction_output = ichx_gpio_direction_output;
> +	chip->base = modparam_gpiobase;
> +	chip->ngpio = ichx_priv.desc->ngpio;
> +	chip->can_sleep = 0;
> +	chip->dbg_show = NULL;
> +}
> +
> +static int __devinit ichx_gpio_init(struct pci_dev *pdev,
> +				const struct pci_device_id *ent,
> +				struct platform_device *dev)
> +{
> +	int err;
> +
> +	ichx_priv.pdev = pdev;
> +	ichx_priv.dev = dev;
> +	ichx_priv.desc = (struct ichx_desc *)ent->driver_data;
> +
> +	/* Determine I/O address of GPIO registers */
> +	pci_read_config_dword(pdev, PCI_ICHX_GPIO_BAR,
> +			      (u32 *)&ichx_priv.gpio_base);
> +	ichx_priv.gpio_base &= PCI_BASE_ADDRESS_IO_MASK;
> +	if (!ichx_priv.gpio_base) {
> +		pr_err("GPIO BAR not enumerated\n");
> +		return -ENODEV;
> +	}
> +
> +	/*
> +	 * If necessary, determine the I/O address of ACPI/power management
> +	 * registers which are needed to read the the GPE0 register for GPI pins
> +	 * 0 - 15 on some chipsets.
> +	 */
> +	if (ichx_priv.desc->gpe0_sts_ofs) {
> +		pci_read_config_dword(pdev, PCI_ICHX_ACPI_BAR,
> +				      (u32 *)&ichx_priv.pm_base);
> +		ichx_priv.pm_base &= PCI_BASE_ADDRESS_IO_MASK;
> +		if (!ichx_priv.pm_base)
> +			pr_warn("ACPI BAR not enumerated, GPI 0 - 15 "
> +				"unusable\n");
> +	}
> +
> +	/* Enable GPIO */
> +	pci_read_config_dword(pdev, PCI_ICHX_GPIO_CTRL,
> +			&ichx_priv.orig_gpio_ctrl);
> +	pci_write_config_dword(pdev, PCI_ICHX_GPIO_CTRL,
> +			ichx_priv.orig_gpio_ctrl | 0x10);
> +
> +	/*
> +	 * Reserve GPIO I/O region. The power management region is used by other
> +	 * drivers thus shouldn't be reserved.  The GPIO I/O region is 64
> +	 * bytes for older chipsets with <= 64 GPIO, 128 bytes for newer
> +	 * chipsets with > 64 GPIO.
> +	 */
> +	if (!devm_request_region(&dev->dev, ichx_priv.gpio_base,
> +			ichx_priv.desc->ngpio > 64 ? 128 : 64,
> +			"ichxgpio")) {
> +		pr_err("Can't request iomem (0x%lx)\n", ichx_priv.gpio_base);
> +		return -EBUSY;
> +	}
> +
> +	ichx_gpiolib_setup(&ichx_priv.chip);
> +
> +	err = gpiochip_add(&ichx_priv.chip);
> +	if (err) {
> +		pr_err("Failed to register GPIOs\n");
> +		return err;
> +	}
> +
> +	pr_info("GPIO from %d to %d on %s\n", ichx_priv.chip.base,
> +	       ichx_priv.chip.base + ichx_priv.chip.ngpio - 1,
> +	       dev_name(&pdev->dev));
> +
> +	return 0;
> +}
> +
> +/* ICH6-based, 631xesb-based */
> +static struct ichx_desc ich6_desc = {
> +	/* Bridges using the ICH6 controller need fixups for GPIO 0 - 17 */
> +	.request = ich6_gpio_request,
> +	.get = ich6_gpio_get,
> +
> +	/* GPIO 0-15 are read in the GPE0_STS PM register */
> +	.gpe0_sts_ofs = 0x28,
> +
> +	.ngpio = 50,
> +};
> +
> +/* Intel 3100 */
> +static struct ichx_desc i3100_desc = {
> +	/*
> +	 * Bits 16,17, 20 of USE_SEL and bit 16 of USE_SEL2 always read 0 on
> +	 * the Intel 3100.  See "Table 712. GPIO Summary Table" of 3100
> +	 * Datasheet for more info.
> +	 */
> +	.use_sel_ignore = {0x00130000, 0x00010000, 0x0},
> +
> +	/* The 3100 needs fixups for GPIO 0 - 17 */
> +	.request = ich6_gpio_request,
> +	.get = ich6_gpio_get,
> +
> +	/* GPIO 0-15 are read in the GPE0_STS PM register */
> +	.gpe0_sts_ofs = 0x28,
> +
> +	.ngpio = 50,
> +};
> +
> +/* ICH7 and ICH8-based */
> +static struct ichx_desc ich7_desc = {
> +	.ngpio = 50,
> +};
> +
> +/* ICH9-based */
> +static struct ichx_desc ich9_desc = {
> +	.ngpio = 61,
> +};
> +
> +/* ICH10-based - Consumer/corporate versions have different amount of GPIO */
> +static struct ichx_desc ich10_cons_desc = {
> +	.ngpio = 51,
> +};
> +static struct ichx_desc ich10_corp_desc = {
> +	.ngpio = 72,
> +};
> +
> +/* Intel 5 series, 6 series, 3400 series, and C200 series */
> +static struct ichx_desc intel5_desc = {
> +	.ngpio = 76,
> +};
> +
> +/*
> + * Note that we don't register a PCI driver since the PCI device has additional
> + * functionality that is used by other drivers, eg iTCO_wdt.  We use the table
> + * to probe for matching devices, then use a platform driver.
> + *
> + * Also note that some additional, old chipsets should in theory be supported
> + * by this driver (eg 82801XX chips), but they are left out due to the fact
> + * that they complicate the driver and there likely isn't much of a demand
> + * since a driver doesn't already exist for the 10+ years the chipsets have
> + * existed for.
> + */
> +static DEFINE_PCI_DEVICE_TABLE(ichx_pci_tbl) = {
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_30, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_TGP_LPC, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4, &ich7_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_1, &ich9_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2, &ich9_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4, &ich9_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_5, &ich9_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_7, &ich9_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_8, &ich9_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH10_0, &ich10_corp_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH10_3, &ich10_corp_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH10_1, &ich10_cons_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH10_2, &ich10_cons_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0, &i3100_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x2671, &ich6_desc) }, /* 631Xesb series */
> +	{ ICHX_GPIO_PCI_DEVICE(0x2672, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x2673, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x2674, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x2675, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x2676, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x2677, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x2678, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x2679, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x267a, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x267b, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x267c, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x267d, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x267e, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x267f, &ich6_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b00, &intel5_desc) }, /* 5 series */
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b01, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b02, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b03, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b04, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b05, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b06, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b07, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b08, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b09, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b0a, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b0b, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b0c, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b0d, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b0e, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b0f, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c41, &intel5_desc) }, /* 6 Series */
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c42, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c43, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c44, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c45, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c46, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c47, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c48, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c49, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c4a, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c4b, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c4c, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c4d, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c4e, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c4f, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c50, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c51, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c52, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c53, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c54, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c55, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c56, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c57, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c58, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c59, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c5a, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c5b, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c5c, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c5d, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c5e, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x1c5f, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b12, &intel5_desc) }, /* 3400 series */
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b14, &intel5_desc) },
> +	{ ICHX_GPIO_PCI_DEVICE(0x3b16, &intel5_desc) },
> +	{ 0, },
> +};
> +MODULE_DEVICE_TABLE(pci, ichx_pci_tbl);
> +
> +static int __devinit ichx_gpio_probe(struct platform_device *dev)
> +{
> +	struct pci_dev *pdev = NULL;
> +	const struct pci_device_id *ent;
> +
> +	spin_lock_init(&ichx_priv.lock);
> +
> +	for_each_pci_dev(pdev) {
> +		ent = pci_match_id(ichx_pci_tbl, pdev);
> +		if (ent)
> +			return ichx_gpio_init(pdev, ent, dev);
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +static int __devexit ichx_gpio_remove(struct platform_device *dev)
> +{
> +	int ret = gpiochip_remove(&ichx_priv.chip);
> +
> +	/* Restore original GPIO control register value */
> +	pci_write_config_dword(ichx_priv.pdev, PCI_ICHX_GPIO_CTRL,
> +			ichx_priv.orig_gpio_ctrl);
> +
> +	return ret;
> +}
> +
> +static struct platform_driver ichx_gpio_driver = {
> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= DRV_NAME,
> +	},
> +	.probe		= ichx_gpio_probe,
> +	.remove		= __devexit_p(ichx_gpio_remove),
> +};
> +
> +static int __devinit ichx_gpio_init_module(void)
> +{
> +	int err = platform_driver_register(&ichx_gpio_driver);
> +	if (err)
> +		return err;
> +
> +	ichx_gpio_platform_device =
> +		platform_device_register_simple(DRV_NAME, -1, NULL, 0);
> +
> +	if (IS_ERR(ichx_gpio_platform_device)) {
> +		err = PTR_ERR(ichx_gpio_platform_device);
> +		goto unreg_platform_driver;
> +	}

Ugh, this always makes me nervous.  Very rarely should drivers be
registering their own devices in the module_init routine.

It /looks/ like the driver should be a pci_driver, and bind against
a pci device.

> +
> +	return 0;
> +
> +unreg_platform_driver:
> +	platform_driver_unregister(&ichx_gpio_driver);
> +	return err;
> +}
> +
> +static void __devexit ichx_gpio_exit_module(void)
> +{
> +	platform_device_unregister(ichx_gpio_platform_device);
> +	platform_driver_unregister(&ichx_gpio_driver);
> +}
> +
> +module_init(ichx_gpio_init_module);
> +module_exit(ichx_gpio_exit_module);
> +
> +MODULE_AUTHOR("Peter Tyser <ptyser@xes-inc.com>");
> +MODULE_DESCRIPTION("Intel ICHx series bridge GPIO driver");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.0.4
> 
