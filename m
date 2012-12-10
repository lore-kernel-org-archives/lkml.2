Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2LJJsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:48:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51041 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2LJJsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:48:40 -0500
MIME-Version: 1.0
In-Reply-To: <1354888899-21907-2-git-send-email-mathias.nyman@linux.intel.com>
References: <1354888899-21907-1-git-send-email-mathias.nyman@linux.intel.com>
	<1354888899-21907-2-git-send-email-mathias.nyman@linux.intel.com>
Date: Mon, 10 Dec 2012 10:48:39 +0100
Message-ID: <CACRpkdYG641KYR05jtu3OS7BDGcFpJ-pzu+gTM+RHJnMqytfEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: add Lynxpoint chipset gpio driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: grant.likely@secretlab.ca, mika.westerberg@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 3:01 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Add gpio support for Intel Lynxpoint chipset.
> Lynxpoint supports 94 gpio pins which can generate interrupts.
> Driver will fail requests for pins that are marked as owned by ACPI, or
> set in an alternate mode (non-gpio).
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Nice shape on this patch, makes it easy to focus the review on the
important stuff, thanks Magnus!

> +config GPIO_LYNXPOINT
> +       bool "Intel Lynxpoint GPIO support"

So you don't want to be able to build it as module?
(OK just odd on Intel systems.)

> +       select IRQ_DOMAIN
> +       help
> +         driver for GPIO functionality on Intel Lynxpoint PCH chipset
> +         Requires platform or ACPI code to set up a platform device.

(...)
> +++ b/drivers/gpio/gpio-lynxpoint.c
(...)
> +/* LynxPoint chipset has support for 94 gpio pins */
> +
> +#define LP_NUM_GPIO    94
> +
> +/* Register offsets */
> +#define LP_ACPI_OWNED  0x00 /* Bitmap, set by bios, 0: pin reserved for ACPI */
> +#define LP_GC          0x7C /* set APIC IRQ to IRQ14 or IRQ15 for all pins */
> +#define LP_INT_STAT    0x80
> +#define LP_INT_ENABLE  0x90
> +
> +/* Each pin has two 32 bit config registers, starting at 0x100 */
> +#define LP_CONFIG1     0x100
> +#define LP_CONFIG2     0x104
> +
> +/* LP_CONFIG1 reg bits */
> +#define OUT_LVL_BIT    BIT(31)
> +#define IN_LVL_BIT     BIT(30)
> +#define TRIG_SEL_BIT   BIT(4) /* 0: Edge, 1: Level */
> +#define INT_INV_BIT    BIT(3) /* Invert interrupt triggering */
> +#define DIR_BIT                BIT(2) /* 0: Output, 1: Input */
> +#define USE_SEL_BIT    BIT(0) /* 0: Native, 1: GPIO */
> +
> +/* LP_CONFIG2 reg bits */
> +#define GPINDIS_BIT    BIT(2) /* disable input sensing */
> +#define GPIWP_BIT      (BIT(0) | BIT(1)) /* weak pull options */

Kudos for using BIT() macros, very readable, thanks!

> +struct lp_gpio {
> +       struct gpio_chip        chip;
> +       struct irq_domain       *domain;
> +       struct platform_device  *pdev;
> +       spinlock_t              lock;
> +       unsigned                hwirq;

This struct member is only used in probe() so make it a local variable there
and cut it from the struct.

> +       unsigned long           reg_base;
> +       unsigned long           reg_len;

Same comment for reg_len.

> +};
> +
> +static unsigned long gpio_reg(struct gpio_chip *chip, unsigned gpio, int reg)

Rename lp_gpio_reg() so as to match the family.

Rename the argument "gpio" to "offset" since it's a local number,
not in the global GPIO numberspace. (Please change this everywhere
a local index is used.)

> +{
> +       struct lp_gpio *lg = container_of(chip, struct lp_gpio, chip);
> +       int offset;
> +
> +       if (reg == LP_CONFIG1 || reg == LP_CONFIG2)
> +               offset = gpio * 8;
> +       else
> +               offset = (gpio / 32) * 4;

Put in some comment above this explaining the layout of the offsets
for these two cases so we understand what's happening here.

> +       return lg->reg_base + reg + offset;
> +}
> +
> +static int lp_gpio_request(struct gpio_chip *chip, unsigned gpio)
> +{
> +       struct lp_gpio *lg = container_of(chip, struct lp_gpio, chip);
> +       unsigned long reg = gpio_reg(chip, gpio, LP_CONFIG1);
> +       unsigned long conf2 = gpio_reg(chip, gpio, LP_CONFIG2);
> +       unsigned long acpi_use = gpio_reg(chip, gpio, LP_ACPI_OWNED);
> +
> +       /* Fail if BIOS reserved pin for ACPI use */
> +       if (!(inl(acpi_use) & BIT(gpio % 32))) {
> +               dev_err(&lg->pdev->dev, "gpio %d reserved for ACPI\n", gpio);
> +               return -EBUSY;
> +       }

This %32 magic only seems to consider the latter part of the if()
statement in the gpio_reg() function. It's like you assume only the
(gpio / 32) * 4 path to be taken. It seems that for the two models
handled there this should be %8 or something. Or I'm getting it
wrong, which is an indication that something is pretty unclear here...

> +       /* Fail if pin is in alternate function mode (not GPIO mode) */
> +       if (!(inl(reg) & USE_SEL_BIT))
> +               return -ENODEV;
> +
> +       /* enable input sensing */
> +       outl(inl(conf2) & ~GPINDIS_BIT, conf2);
> +
> +       return 0;
> +}

(...)
> +static void lp_irq_enable(struct irq_data *d)
> +{
> +       struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
> +       u32 gpio = irqd_to_hwirq(d);

That variable is confusingly named. It's not a global gpio number,
it's a local offset, so please rename it "offset".

> +       unsigned long reg = gpio_reg(&lg->chip, gpio, LP_INT_ENABLE);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&lg->lock, flags);
> +       outl(inl(reg) | BIT(gpio % 32), reg);
> +       spin_unlock_irqrestore(&lg->lock, flags);
> +}
> +
> +static void lp_irq_disable(struct irq_data *d)
> +{
> +       struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
> +       u32 gpio = irqd_to_hwirq(d);

Dito.

> +       unsigned long reg = gpio_reg(&lg->chip, gpio, LP_INT_ENABLE);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&lg->lock, flags);
> +       outl(inl(reg) & ~BIT(gpio % 32), reg);
> +       spin_unlock_irqrestore(&lg->lock, flags);
> +}
(...)
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id lynxpoint_gpio_acpi_match[] = {
> +       { "INT33C7", 0 },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(acpi, lynxpoint_gpio_acpi_match);
> +#endif

Aha so how many users are there of this driver which are not
using ACPI?

If zero, why not just depend on ACPI in Kconfig?

> +static int __devexit lp_gpio_remove(struct platform_device *pdev)

All __devinit/__devexit macros are going away in v3.8 so delete them
everywhere.

> +{
> +       struct lp_gpio *lg = platform_get_drvdata(pdev);
> +       int err;
> +       err = gpiochip_remove(&lg->chip);
> +       if (err)
> +               dev_warn(&pdev->dev, "failed to remove gpio_chip.\n");
> +       platform_set_drvdata(pdev, NULL);
> +       return 0;
> +}
> +
> +static struct platform_driver lp_gpio_driver = {
> +       .probe          = lp_gpio_probe,
> +       .remove         = __devexit_p(lp_gpio_remove),

Delete that __devexit_p() too I suppose.

> +       .driver         = {
> +               .name   = "lp_gpio",
> +               .owner  = THIS_MODULE,
> +               .acpi_match_table = ACPI_PTR(lynxpoint_gpio_acpi_match),
> +       },
> +};
> +
> +static int __init lp_gpio_init(void)
> +{
> +       return platform_driver_register(&lp_gpio_driver);
> +}
> +
> +subsys_initcall(lp_gpio_init);

Yours,
Linus Walleij
