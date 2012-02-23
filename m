Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab2BWGIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 01:08:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2BWGIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 01:08:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.202.97 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-21-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-21-git-send-email-swarren@nvidia.com>
Date: Thu, 23 Feb 2012 07:08:35 +0100
Message-ID: <CACRpkdZshQqM5ZZj21gXMZ6xZCUsdEvDDDyzvhFJTjnuZ2=twg@mail.gmail.com>
Subject: Re: [PATCH 20/20] pinctrl: Enhance mapping table to support pin
 config operations
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:46 AM, Stephen Warren <swarren@nvidia.com> wrote:

> The pinctrl mapping table can now contain entries to:
> * Set the mux function of a pin group
> * Apply a set of pin config options to a pin or a group
>
> This allows pinctrl_select_state() to apply pin configs settings as well
> as mux settings.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Overall excellent, just smaller things below:

> @@ -817,7 +827,40 @@ it even more compact which assumes you want to use pinctrl-foo and position
>  0 for mapping, for example:
>
>  static struct pinctrl_map __initdata mapping[] = {
> -       PIN_MAP("default", "pinctrl-foo", "i2c0", "foo-i2c.0"),
> +       PIN_MAP_MUX_GROUP("foo-i2c.o", "default", "pinctrl-foo", NULL, "i2c0"),
> +};

OK looks good!

> +The mapping table may also contain pin configuration entries. It's common for
> +each pin/group to have a number of configuration entries that affect it, so
> +the table entries for configuration reference an array of config parameters
> +and values. An example using the convenience macros is shown below:
> +
> +static unsigned long i2c_grp_configs[] = {
> +       FOO_PIN_DRIVEN,
> +       FOO_PIN_PULLUP,
> +};
> +
> +static unsigned long i2c_pin_configs[] = {
> +       FOO_OPEN_COLLECTOR,
> +       FOO_SLEW_RATE_SLOW,
> +};
> +
> +static struct pinctrl_map __initdata mapping[] = {
> +       PIN_MAP_MUX_GROUP("foo-i2c.0", "default", "pinctrl-foo", "i2c0", "i2c0"),
> +       PIN_MAP_MUX_CONFIGS_GROUP("foo-i2c.0", "default", "pinctrl-foo", "i2c0", i2c_grp_configs),
> +       PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", "default", "pinctrl-foo", "i2c0scl", i2c_pin_configs),
> +       PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", "default", "pinctrl-foo", "i2c0sda", i2c_pin_configs),
> +};

I buy this too...

> +Finally, some devices expect the mapping table to contain certain specific
> +named states. When running on hardware that doesn't need any pin controller
> +configuration, the mapping table must still contain those named states, in
> +order to explicitly indicate that the states were provided and intended to
> +be empty. Table entry macro PIN_MAP_DUMMY_STATE serves the purpose of defining
> +a named state without causing any pin controller to be programmed:
> +
> +static struct pinctrl_map __initdata mapping[] = {
> +       PIN_MAP_DUMMY_STATE("foo-i2c.0", "default"),
>  };

Looks useful so why not.

> @@ -1022,7 +1074,7 @@ Since it may be common to request the core to hog a few always-applicable
>  mux settings on the primary pin controller, there is a convenience macro for
>  this:
>
> -PIN_MAP_SYS_HOG("active", "pinctrl-foo", "power_func")
> +PIN_MAP_MUX_GROUP("pinctrl-foo", "active", "pinctrl-foo", NULL, "power_func")

Please keep the explicit _HOG macros for readability. Relying on
the implicit relation between dev and pctldev being the same and to be
parsed by humans is vulnerable.

PIN_MAP_MUX_GROUP_HOG()

in this case, with the same arguments (though with PINCTRL_STATE_DEFAULT
in place for "active") is better IMO.

>  /* Pinmux settings */
>  static struct pinctrl_map __initdata u300_pinmux_map[] = {
>        /* anonymous maps for chip power and EMIFs */
> -       PIN_MAP_SYS_HOG("default", "pinmux-u300", "power"),
> -       PIN_MAP_SYS_HOG("default", "pinmux-u300", "emif0"),
> -       PIN_MAP_SYS_HOG("default", "pinmux-u300", "emif1"),
> +       PIN_MAP_MUX_GROUP("pinmux-u300", "default", "pinmux-u300", NULL, "power"),
> +       PIN_MAP_MUX_GROUP("pinmux-u300", "default", "pinmux-u300", NULL, "emif0"),
> +       PIN_MAP_MUX_GROUP("pinmux-u300", "default", "pinmux-u300", NULL, "emif1"),
>        /* per-device maps for MMC/SD, SPI and UART */
> -       PIN_MAP("default", "pinmux-u300", "mmc0", "mmci"),
> -       PIN_MAP("default", "pinmux-u300", "spi0", "pl022"),
> -       PIN_MAP("default", "pinmux-u300", "uart0", "uart0"),
> +       PIN_MAP_MUX_GROUP("mmci",  "default", "pinmux-u300", NULL, "mmc0"),
> +       PIN_MAP_MUX_GROUP("pl022", "default", "pinmux-u300", NULL, "spi0"),
> +       PIN_MAP_MUX_GROUP("uart0", "default", "pinmux-u300", NULL, "uart0"),
>  };

PIN_MAP_MUX_GROUP_HOG() please. PINCTRL_STATE_DEFAULT instead
of "default".

Or maybe we should imply that PIN_MAP_MUX_GROUP_HOG() hogs the
default state, or have PIN_MAP_MUX_GROUP_HOG_DEFAULT() even?

> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -341,6 +341,31 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
>  }
>
>  /**
> + * pinctrl_get_pin_id() - returns the group selector for a group
> + * @pctldev: the pin controller handling the group
> + * @pin_group: the pin group to look up

This kerneldoc is wrong... pin, not group.

> + */
> +int pinctrl_get_pin_id(struct pinctrl_dev *pctldev,
> +                      const char *pin)
> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < pctldev->desc->npins; i++) {
> +               if (pctldev->desc->pins[i].name == NULL)
> +                       continue;
> +               if (!strcmp(pin, pctldev->desc->pins[i].name)) {
> +                       dev_dbg(pctldev->dev, "found pin id %u for %s\n",
> +                               i, pin);
> +                       return i;
> +               }
> +       }

(...)

>        /* First sanity check the new mapping */
>        for (i = 0; i < num_maps; i++) {
> +               if (!maps[i].dev_name) {
> +                       pr_err("failed to register map %s (%d): no device given\n",
> +                              maps[i].name, i);
> +                       return -EINVAL;
> +               }
> +

Hm should this not be done earlier in the patch series?

> +       /*
> +        * FIXME: We should really get the pin controler to dump the config
> +        * values, so they can be decoded to something meaningful.
> +        */
> +       for (i = 0; i < setting->data.configs.num_configs; i++)
> +               seq_printf(s, " %08lx", setting->data.configs.configs[i]);
> +
> +       seq_printf(s, "\n");
> +}

Per-device config print function? But no need to rush that.

Apart from this I mostly just trust this patch, like the previous one.

Yours,
Linus Walleij
