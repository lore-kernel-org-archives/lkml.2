Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3AJLGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:06:47 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:51893 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3AJLGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:06:45 -0500
MIME-Version: 1.0
In-Reply-To: <1357317909-12458-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
	<1357317909-12458-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Thu, 10 Jan 2013 12:06:44 +0100
Message-ID: <CACRpkda0yhVvCW9edWBi3XusfS4NaiWqKsoCfLpT9+X5iO-GXg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 5:45 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The IP responsible for the muxing on the Allwinner SoCs are also
> handling the GPIOs on the system. This patch adds the needed driver that
> relies on the pinctrl driver for most of its operations.
>
> The number of pins available for GPIOs operations are already declared
> in the pinctrl driver, we only need to probe a generic driver to handle
> the banks available for each SoC.
>
> This driver has been tested on a A13-Olinuxino.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Looking mostly good!

> +static int __devinit
> +sunxi_pinctrl_register_gpio_ranges(struct sunxi_pinctrl *pctl)
> +{
> +       int id = 0, base = 0, npins = 1, i, prev_pin = -1;
> +       struct pinctrl_gpio_range *range;
> +
> +       for (i = 0; i < pctl->desc->npins; i++) {
> +               const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
> +               unsigned pin_num = pin->pin.number;
> +
> +               if (prev_pin < 0) {
> +                       prev_pin = pin_num;
> +                       base = pin_num;
> +               } else if (prev_pin + 1 != pin_num) {
> +                       range = devm_kzalloc(pctl->dev,
> +                                       sizeof(*range),
> +                                       GFP_KERNEL);
> +                       if (!range)
> +                               return -ENOMEM;
> +
> +                       range->name = "sunxi";
> +                       range->id = id;
> +                       range->base = base;
> +                       range->pin_base = base;
> +                       range->npins = npins;
> +
> +                       pinctrl_add_gpio_range(pctl->pctl_dev, range);
> +
> +                       id++;
> +                       npins = 1;
> +                       prev_pin = pin_num;
> +                       base = prev_pin;
> +               } else {
> +                       prev_pin++;
> +                       npins++;
> +               }
> +       }
> +
> +       range = devm_kzalloc(pctl->dev, sizeof(*range),
> +                       GFP_KERNEL);
> +       if (!range)
> +               return -ENOMEM;
> +
> +       range->name = "sunxi";
> +       range->id = id;
> +       range->base = base;
> +       range->pin_base = base;
> +       range->npins = npins;
> +
> +       pinctrl_add_gpio_range(pctl->pctl_dev, range);
> +
> +       return 0;
> +}

Really hairy way to add ranges right?

Registering ranges from the pinctrl side is deprecated and discouraged.

Instead register the ranges from the GPIO driver.

Use gpiochip_add_pin_range() from the GPIO driver.

An example is provided in
drivers/pinctrl/pinctrl-coh901.c

After you have done this, you can probably get rid of this as well:

+static int __init sunxi_gpio_init(void)
+{
+       return platform_driver_register(&sunxi_gpio_driver);
+}
+postcore_initcall(sunxi_gpio_init);

This will become a simple module_init() if you are handling
deferred probe correctly.

Yours,
Linus Walleij
