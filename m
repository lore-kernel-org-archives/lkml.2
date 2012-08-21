Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2HULZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:25:22 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61694 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2HULZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:25:19 -0400
MIME-Version: 1.0
In-Reply-To: <1345060656-32201-2-git-send-email-thomas.abraham@linaro.org>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
	<1345060656-32201-2-git-send-email-thomas.abraham@linaro.org>
Date: Tue, 21 Aug 2012 13:25:18 +0200
Message-ID: <CACRpkdYqPYesgE-YxPLZqROw1T2fsPWR6R+aDTTz2=XbP7oe9A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pinctrl: add samsung pinctrl and gpiolib driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dong Aisheng <dong.aisheng@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 9:57 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> Add a new device tree enabled pinctrl and gpiolib driver for Samsung
> SoC's.

Thanks for doing this Thomas, great work!

> +++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt

I don't understand the rules around bindings very well, I would
suggest you include
devicetree-discuss@lists.ozlabs.org on the mails, besides you know
this stuff way
better than me anyway :-)

> +  The child node can also optionally specify one or more of the pin
> +  configuration that should be applied on all the pins listed in the
> +  "samsung,pins" property of the child node. The following pin configuration
> +  properties are supported.
> +
> +  - samsung,pin-pud: Pull up/down configuration.
> +  - samsung,pin-drv: Drive strength configuration.
> +  - samsung,pin-pud-pdn: Pull up/down configuration in power down mode.
> +  - samsung,pin-drv-pdn: Drive strength configuration in power down mode.

This looks a bit scary, as it seems to be orthogonal to the pin config
interface. I.e. this will be programmed "behind the back" of the
pin config system. However as long as the pin config implementation
reads back these things from the registers it will work, too.

In the U300 and Ux500 I explicitly use pin config hogs to set up
the pin configuration, and when we enter a state such as
"default" the mux setting and config settings are set from the
framework separately.

See for example:
arch/arm/mach-ux500/board-mop500-pins.c

This example is using platform data but it should be trivial to do with
device tree.

I think the Tegra also works this way. Can you elaborate on
why you need this static setup from the device tree instead
of using default states?

I also think this looks like it could use generic pin config to stash
the configs, just expand the stuff in <linux/pinctrl/pinconf-generic.h>

(...)
> +Example 1:

The examples seem to only pertain to the pin controller per se, maybe you
could include a DT entry for a uart or something showing how the
uart device binds to a certain pinctrl setting.

> +       pinctrl_0: pinctrl@11400000 {
> +               compatible = "samsung,pinctrl-exynos4210";
> +               reg = <0x11400000 0x1000>;
> +               interrupts = <0 47 0>;
> +
> +               uart0_data: uart0-data {
> +                       samsung,pins = "gpa0-0", "gpa0-1";
> +                       samsung,pin-function = <2>;
> +                       samsung,pin-pud = <0>;
> +                       samsung,pin-drv = <0>;
> +               };

This setup needs to be associated with a certain state, it's possible to
do in the code or directly in the device tree.

I.e. these settings for pin-pud and pin-drv needs to belong to a
certain pin config state, typically the state named "default"

> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig

> +config PINCTRL_SAMSUNG
> +       bool "Samsung pinctrl driver"
> +       depends on OF

I don't understand how this can even compile. Do you need:

select PINMUX
select PINCONF

to get the framework files you need to compile?

Or are you selecting thes in some platform Kconfig or so?
In that case please move them here.

> +/* list of all possible config options supported */
> +struct pin_config {
> +       char            *prop_cfg;
> +       unsigned int    cfg_type;
> +} pcfgs[] = {
> +       { "samsung,pin-pud", PINCFG_TYPE_PUD },
> +       { "samsung,pin-drv", PINCFG_TYPE_DRV },
> +       { "samsung,pin-pud-pdn", PINCFG_TYPE_CON_PND },
> +       { "samsung,pin-drv-pdn", PINCFG_TYPE_PUD_PND },
> +};

Hmmmmm it looks very much like this controller could make use of
the generic pinconf library, but it's not mandatory so just a suggestion.

(...)
> +/* create pinctrl_map entries by parsing device tree nodes */
> +static int samsung_dt_node_to_map(struct pinctrl_dev *pctldev,
> +                       struct device_node *np, struct pinctrl_map **maps,
> +                       unsigned *nmaps)
> +{
(...)
> +       /* Allocate memory for pin group name. The pin group name is derived
> +        * from the node name from which these map entries are be created.
> +        */
> +       gname = kzalloc(strlen(np->name) + 4, GFP_KERNEL);

Why +4? I would have suspected +1 for the null terminator...

> +       if (!gname) {
> +               dev_err(dev, "failed to alloc memory for group name\n");
> +               goto free_map;
> +       }
> +       sprintf(gname, "%s-grp", np->name);

The rest of the pinmux implementation looks nice!

(...)
> +/* set the pull up/down and driver strength settings for a specified pin */
> +static int samsung_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
> +                                       unsigned long config)
> +{
> +       struct samsung_pinctrl_drv_data *drvdata;
> +       unsigned long pin_offset;
> +       struct samsung_pin_bank *bank;
> +       void __iomem *reg;
> +
> +       drvdata = pinctrl_dev_get_drvdata(pctldev);
> +       pin_to_reg_bank(drvdata->gc, pin - drvdata->ctrl->base, &reg,
> +                                       &pin_offset, &bank);
> +
> +       switch (PINCFG_UNPACK_TYPE(config)) {
> +       case PINCFG_TYPE_PUD:
> +               samsung_pinconf_set_pud(drvdata, bank, reg, pin_offset, config);
> +               break;
> +       case PINCFG_TYPE_DRV:
> +               samsung_pinconf_set_drv(drvdata, bank, reg, pin_offset, config);
> +               break;


Hm there are two more types defined in the device tree:

+  - samsung,pin-pud: Pull up/down configuration.
+  - samsung,pin-drv: Drive strength configuration.
+  - samsung,pin-pud-pdn: Pull up/down configuration in power down mode.
+  - samsung,pin-drv-pdn: Drive strength configuration in power down mode.

I think you should define these as well, especially if you use the
states to program these things instead of the hack that I'm quite
sceptical about...

> +/* reading pin pull up/down and driver strength settings not implemented */

OK why not? It seems very simple and straight-forward.
Just read the same registers and switch() then return...

(...)

The gpiolib part looks really good, so no comments on that.

(...)
> +               /* derive function name from the node name */
> +               fname = devm_kzalloc(dev, strlen(cfg_np->name) + 4, GFP_KERNEL);

This +4 again...

(...)
> +       drvdata->grange.name = "samsung-pctrl-gpio-range";
> +       drvdata->grange.id = 0;
> +       drvdata->grange.base = drvdata->ctrl->base;
> +       drvdata->grange.npins = drvdata->ctrl->nr_pins;
> +       drvdata->grange.gc = drvdata->gc;
> +       pinctrl_add_gpio_range(drvdata->pctl_dev, &drvdata->grange);

Grant didn't like custom ranges at all IIRC and wanted a generic
way of handling this. But doing so requires turning the range registration
API:s upside down and let the GPIO controller register the ranges.

If noone else is coding that, I guess we might have to live with
this kind of custom hacks. (No, I don't have time to fix it, sadly.)

(...)
> +static int __devinit samsung_pinctrl_probe(struct platform_device *pdev)
(...)
> +       if (ctrl->eint_gpio_init)
> +               ctrl->eint_gpio_init(drvdata);
> +       if (ctrl->eint_wkup_init)
> +               ctrl->eint_wkup_init(drvdata);

So this stuff I'm doing in the default states instead.

(...)
> +++ b/drivers/pinctrl/pinctrl-samsung.h
(...)
> +#ifndef __PINCTRL_SAMSUNG_H
> +#define __PINCTRL_SAMSUNG_H
> +
> +#include <linux/module.h>
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/pinmux.h>
> +#include <linux/pinctrl/pinconf.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/pinctrl/machine.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>

Usually I prefer to have as many as possible of these in the .c file, but this
works too, and I haven't seen any rationale about it. Especially since this is
a local include I can live with it...


> +/**
> + * struct samsung_pin_bank: represent a controller pin-bank.
> + * @reg_offset: starting offset of the pin-bank registers.
> + * @pin_base: starting pin number of the bank.
> + * @nr_pins: number of pins included in this bank.
> + * @func_width: width of the function selector bit field.
> + * @pud_width: width of the pin pull up/down selector bit field.
> + * @drc_width: width of the pin driver strength selector bit field.
> + * @eint_type: type of the external interrupt supported by the bank.
> + * @irq_base: starting controller local irq number of the bank.
> + * @name: name to be prefixed for each pin in this pin bank.
> + */
> +struct samsung_pin_bank {
> +       unsigned int            pctl_offset;

Isn't this a u32?

> +       unsigned int            pin_base;
> +       unsigned int            nr_pins;
> +       unsigned int            func_width;
> +       unsigned int            pud_width;
> +       unsigned int            drv_width;

Are these "widths" really unsigned (32/64) bits?
Isn't u8 enough?

> +       unsigned int            eint_type;

Shouldn't this be some kund of enum if it denotes a type?

> +       unsigned int            irq_base;

u32?

> +       char                    *name;
> +};
> +
> +/**
> + * struct samsung_pin_ctrl: represent a pin controller.
> + * @pin_banks: list of pin banks included in this controller.
> + * @nr_banks: number of pin banks.
> + * @base: starting system wide pin number.
> + * @nr_pins: number of pins supported by the controller.
> + * @nr_gint: number of external gpio interrupts supported.
> + * @nr_wint: number of external wakeup interrupts supported.
> + * @geint_con: offset of the ext-gpio controller registers.

If it's an offset why not name it geint_con_offset?

> + * @geint_mask: offset of the ext-gpio interrupt mask registers.
> + * @geint_pend: offset of the ext-gpio interrupt pending registers.
> + * @weint_con: offset of the ext-wakeup controller registers.
> + * @weint_mask: offset of the ext-wakeup interrupt mask registers.
> + * @weint_pend: offset of the ext-wakeup interrupt pending registers.

Dito.

> + * @svc: offset of the interrupt service register.
> + * @eint_gpio_init: platform specific callback to setup the external gpio
> + *     interrupts for the controller.
> + * @eint_wkup_init: platform specific callback to setup the external wakeup
> + *     interrupts for the controller.
> + * @label: for debug information.

Could you add some free text here explaining the hardware just a little
bit? What is a external GPIO? what is an external wakeup? etc.

> + */
> +struct samsung_pin_ctrl {
> +       struct samsung_pin_bank *pin_banks;
> +       unsigned int            nr_banks;
> +
> +       unsigned int            base;

u32?

> +       unsigned int            nr_pins;
> +       unsigned int            nr_gint;
> +       unsigned int            nr_wint;
> +
> +       unsigned long           geint_con;
> +       unsigned long           geint_mask;
> +       unsigned long           geint_pend;

All three u32?

> +       unsigned long           weint_con;

u32?

> +       unsigned long           weint_mask;
> +       unsigned long           weint_pend;

u32?

> +       unsigned long           svc;

u32?

> +
> +       int                     (*eint_gpio_init)(struct samsung_pinctrl_drv_data *);
> +       int                     (*eint_wkup_init)(struct samsung_pinctrl_drv_data *);

I guess you need to set up these using auxdata?

> +       char                    *label;
> +};
> +
> +/**
> + * struct samsung_pinctrl_drv_data: wrapper for holding driver data together.
> + * @virt_base: register base address of the controller.
> + * @dev: device instance representing the controller.
> + * @irq: interrpt number used by the controller to notify gpio interrupts.
> + * @ctrl: pin controller instance managed by the driver.
> + * @pctl: pin controller descriptor registered with the pinctrl subsystem.

Maybe name this pctl_desc then?

> + * @pctl_dev: cookie representing pinctrl device instance.
> + * @pin_groups: list of pin groups available to the driver.
> + * @nr_groups: number of such pin groups.
> + * @pmx_functions: list of pin functions available to the driver.
> + * @nr_function: number of such pin functions.
> + * @gc: gpio_chip instance registered with gpiolib.
> + * @grange: linux gpio pin range supported by this controller.
> + */
> +struct samsung_pinctrl_drv_data {
> +       void __iomem                    *virt_base;
> +       struct device                   *dev;
> +       int                             irq;
> +
> +       struct samsung_pin_ctrl         *ctrl;
> +       struct pinctrl_desc             pctl;
> +       struct pinctrl_dev              *pctl_dev;
> +
> +       const struct samsung_pin_group  *pin_groups;
> +       unsigned int                    nr_groups;
> +       const struct samsung_pmx_func   *pmx_functions;
> +       unsigned int                    nr_functions;
> +
> +       struct irq_domain               *gpio_irqd;
> +       struct irq_domain               *wkup_irqd;
> +
> +       struct gpio_chip                *gc;
> +       struct pinctrl_gpio_range       grange;
> +};

This is looking really good.

No further comments! (Atleast not this time, since it's a big
driver I have probably missed something...)

Linus Walleij
