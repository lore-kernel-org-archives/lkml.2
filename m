Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2BWFys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 00:54:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33632 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2BWFyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 00:54:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.160.131 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-20-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-20-git-send-email-swarren@nvidia.com>
Date: Thu, 23 Feb 2012 06:54:46 +0100
Message-ID: <CACRpkdZQhJ9hBxD93FHjpCngugTZ2EFgJFwWObGd1YmEtfnxFA@mail.gmail.com>
Subject: Re: [PATCH 19/20] pinctrl: API changes to support multiple states per device
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

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> The API model is changed from:
>
> p = pinctrl_get(dev, "state1");
> pinctrl_enable(p);
> ...
> pinctrl_disable(p);
> pinctrl_put(p);
> p = pinctrl_get(dev, "state2");
> pinctrl_enable(p);
> ...
> pinctrl_disable(p);
> pinctrl_put(p);
>
> to this:
>
> p = pinctrl_get(dev);
> s1 = pinctrl_lookup_state(p, "state1");
> s2 = pinctrl_lookup_state(p, "state2");
> pinctrl_select_state(p, s1);
> ...
> pinctrl_select_state(p, s2);
> ...
> pinctrl_put(p);
>
> This allows devices to directly transition between states without
> disabling the pin controller programming and put()/get()ing the
> configuration data each time. This model will also better suit pinconf
> programming, which doesn't have a concept of "disable".
>
> The special-case hogging feature of pin controllers is re-written to use
> the regular APIs instead of special-case code. Hence, the pinmux-hogs
> debugfs file is removed; see the top-level pinctrl-handles files for
> equivalent data.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Overall this is excellent and exactly what we have discussed and
just what we want, good job!

>  static const struct pinctrl_map __initdata mapping[] = {
>        {
> +               .dev_name = "foo-spi.0",
> +               .name = "default",

I think we should introduce a
#define PINCTRL_DEFAULT_STATE "default"

And use that #define in examples and code from day 1.

That will ease the transition to generalized states like
PINCTRL_IDLE_STATE etc further down the road.

>  {
> +       .dev_name = "foo-mmc.0",
>        .name = "2bit"
>        .ctrl_dev_name = "pinctrl-foo",
>        .function = "mmc0",
>        .group = "mmc0_1_grp",
> -       .dev_name = "foo-mmc.0",
>  },
>  {
> +       .dev_name = "foo-mmc.0",
>        .name = "4bit"
>        .ctrl_dev_name = "pinctrl-foo",
>        .function = "mmc0",
>        .group = "mmc0_1_grp",
> -       .dev_name = "foo-mmc.0",
>  },
>  {
> +       .dev_name = "foo-mmc.0",
>        .name = "4bit"
>        .ctrl_dev_name = "pinctrl-foo",
>        .function = "mmc0",
>        .group = "mmc0_2_grp",
> -       .dev_name = "foo-mmc.0",
>  },
>  {
> +       .dev_name = "foo-mmc.0",
>        .name = "8bit"
>        .ctrl_dev_name = "pinctrl-foo",
> +       .function = "mmc0",
>        .group = "mmc0_1_grp",
> -       .dev_name = "foo-mmc.0",
>  },
>  {
> +       .dev_name = "foo-mmc.0",
>        .name = "8bit"
>        .ctrl_dev_name = "pinctrl-foo",
>        .function = "mmc0",
>        .group = "mmc0_2_grp",
> -       .dev_name = "foo-mmc.0",
>  },
>  {
> +       .dev_name = "foo-mmc.0",
>        .name = "8bit"
>        .ctrl_dev_name = "pinctrl-foo",
>        .function = "mmc0",
>        .group = "mmc0_3_grp",
> -       .dev_name = "foo-mmc.0",
>  },

Seems like random reordering but no big deal, could go in separate
patch.

>  The result of grabbing this mapping from the device with something like
>  this (see next paragraph):
>
> -       p = pinctrl_get(&device, "8bit");
> +       p = pinctrl_get(dev);
> +       s = pinctrl_lookup_state(p, "8bit");
> +       ret = pinctrl_select_state(p, s);
> +
> +or more simply:
> +
> +       p = pinctrl_get_select(dev, "8bit");

Ohhh sweet! I like pinctrl_get_select()!

>  Pin control map entries can be hogged by the core when the pin controller
> -is registered. This means that the core will attempt to call pinctrl_get() and
> -pinctrl_enable() on it immediately after the pin control device has been
> -registered.
> +is registered. This means that the core will attempt to call pinctrl_get(),
> +lookup_state() and select_state() on it immediately after the pin control
> +device has been registered.
>
> -This is enabled by simply setting the .dev_name field in the map to the name
> -of the pin controller itself, like this:
> +This occurs for mapping table entries where the client device name is equal
> +to the pin controller device name, and the state name is "active".
>
>  {
> -       .name = "POWERMAP"
> +       .dev_name = "pinctrl-foo",
> +       .name = "active",

Again define a standard name, I think PINCTRL_STATE_DEFAULT
should be used for this too, since it means it defaults to active.

> -PIN_MAP_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
> +PIN_MAP_SYS_HOG("active", "pinctrl-foo", "power_func")

Then use that PINCTRL_STATE_DEFAULT

>  This snippet first muxes the function in the pins defined by group A, enables
>  it, disables and releases it, and muxes it in on the pins defined by group B:
> @@ -1017,23 +1045,36 @@ it, disables and releases it, and muxes it in on the pins defined by group B:
>  foo_switch()
>  {
>        struct pinctrl *p;
> +       struct pinctrl_state *s1, *s2;
> +
> +       /* Setup */
> +       p = pinctrl_get(&device);
> +       if (IS_ERR(p))
> +               ...
> +
> +       s1 = pinctrl_lookup_state(foo->p, "pos-A");
> +       if (IS_ERR(s1))
> +               ...
> +
> +       s2 = pinctrl_lookup_state(foo->p, "pos-B");
> +       if (IS_ERR(s2))
> +               ...
>
>        /* Enable on position A */
> -       p = pinctrl_get(&device, "spi0-pos-A");
> -       if IS_ERR(p)
> -               return PTR_ERR(p);
> -       pinctrl_enable(p);
> +       ret = pinctrl_select_state(s);
> +       if (ret < 0)
> +           ...
>
> -       /* This releases the pins again */
> -       pinctrl_disable(p);
> -       pinctrl_put(p);
> +       ...
>
>        /* Enable on position B */
> -       p = pinctrl_get(&device, "spi0-pos-B");
> -       if IS_ERR(p)
> -               return PTR_ERR(p);
> -       pinctrl_enable(p);
> +       ret = pinctrl_select_state(s);
> +       if (ret < 0)
> +           ...
> +
>        ...
> +
> +       pinctrl_put(p);
>  }

This is looking real good. I think recent discussion with Russell
also ironed out the problems with potential gpio interaction.

> -       PIN_MAP_SYS_HOG("POWER", "pinmux-u300", "power"),
> -       PIN_MAP_SYS_HOG("EMIF0", "pinmux-u300", "emif0"),
> -       PIN_MAP_SYS_HOG("EMIF1", "pinmux-u300", "emif1"),
> +       PIN_MAP_SYS_HOG("default", "pinmux-u300", "power"),
> +       PIN_MAP_SYS_HOG("default", "pinmux-u300", "emif0"),
> +       PIN_MAP_SYS_HOG("default", "pinmux-u300", "emif1"),
>        /* per-device maps for MMC/SD, SPI and UART */
> -       PIN_MAP("MMCSD", "pinmux-u300", "mmc0", "mmci"),
> -       PIN_MAP("SPI", "pinmux-u300", "spi0", "pl022"),
> -       PIN_MAP("UART0", "pinmux-u300", "uart0", "uart0"),
> +       PIN_MAP("default", "pinmux-u300", "mmc0", "mmci"),
> +       PIN_MAP("default", "pinmux-u300", "spi0", "pl022"),
> +       PIN_MAP("default", "pinmux-u300", "uart0", "uart0"),
>  };

PINCTRL_STATE_DEFAULT

So far I really like this. I should look closer at the code but mainly
I just have to trust you on it and fix any bugs later, this change is
way more valuable as is.

Please move this patch as far to the head of the series as possible
so we can get it in, I guess you need the state lookup in struct pinctrl
to proceed but could we e.g. puy the locking changes after this?

Yours,
Linus Walleij
