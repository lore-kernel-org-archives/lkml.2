Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1H2LRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:17:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53206 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1H2LRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:17:09 -0400
MIME-Version: 1.0
In-Reply-To: <1314315824-9687-11-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
	<1314315824-9687-11-git-send-email-swarren@nvidia.com>
Date: Mon, 29 Aug 2011 13:09:19 +0200
Message-ID: <CACRpkdaTiWEtgjVOhUKeXhpiESvrWyz97p5j_PHe3MvEM4UaCw@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] of: add a generic pinmux helper
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 1:43 AM, Stephen Warren <swarren@nvidia.com> wrote:

> diff --git a/drivers/of/of_pinmux.c b/drivers/of/of_pinmux.c

> +int of_pinmux_parse(const struct of_pinmux_ctrl *ctrl,
> +                   struct of_pinmux_cfg *cfg)

OK...

> +{
> +       struct device_node *np;
> +
> +       if (!ctrl || !ctrl->dev || !ctrl->node || !ctrl->configure)
> +               return -EINVAL;
> +
> +       for_each_child_of_node(ctrl->node, np) {
> +               int ret;
> +               bool hadpins = 0;
> +               struct of_iter_string_prop iter;
> +
> +               cfg->node = np;
> +
> +               ret = of_property_read_string(np, "function",
> +                                             &cfg->function);
> +               if (ret < 0) {
> +                       dev_err(ctrl->dev, "no function for node %s\n",
> +                               np->name);
> +                       continue;
> +               }

I buy this part.

> +
> +               cfg->flags &= 0;
> +
> +               if (of_find_property(np, "pull-up", NULL))
> +                       cfg->flags |= OF_PINMUX_PULL_UP;
> +               if (of_find_property(np, "pull-down", NULL))
> +                       cfg->flags |= OF_PINMUX_PULL_DOWN;
> +
> +               if ((cfg->flags & OF_PINMUX_PULL_MASK) ==
> +                   OF_PINMUX_PULL_MASK) {
> +                       dev_warn(ctrl->dev, "node %s has both "
> +                                "pull-up and pull-down properties - "
> +                                "defaulting to no pull\n",
> +                                np->name);
> +                       cfg->flags &= ~OF_PINMUX_PULL_MASK;
> +               }
> +
> +               if (of_find_property(np, "tristate", NULL))
> +                       cfg->flags |= OF_PINMUX_TRISTATE;

But what does this stuff has to do with pinmux?

I call this "pin biasing" and it has very little to do with muxing.

If a broader, generic term is to be used, I'd prefer "pin control"
which sort of nails the thing.

> +               for_each_string_property_value(iter, np, "pins") {
> +                       hadpins = 1;
> +
> +                       cfg->pin = iter.value;
> +
> +                       dev_dbg(ctrl->dev,
> +                               "configure pin %s func=%s flags=0x%lx\n",
> +                               cfg->pin, cfg->function, cfg->flags);
> +                       if (ctrl->configure(ctrl, cfg))
> +                               dev_warn(ctrl->dev,
> +                                        "failed to configure pin %s\n",
> +                                        cfg->pin);
> +               }
> +
> +               if (!hadpins)
> +                       dev_warn(ctrl->dev, "no pins for node %s\n",
> +                                np->name);
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_pinmux_parse);

Renamed of_pinctrl_parse I'm happier with it.

> +/**
> + * struct of_pinmux_cfg - configuration state for a single pinmux entry.
> + *
> + * @function: the name of the function that the pinmux entry should be
> + *     configured to.
> + * @pin: the device_node of the pinmux entry that should be configured.
> + *     Platform specific properties that aren't in the generic binding may be
> + *     obtained from this device node.
> + * @flags: flags for common pinmux options such as pull and tristate.

I don't think these things has anything to do with pinmux at all.

But with the struct renamed of_pinctrl_cfg I'm again happier.

> + */
> +struct of_pinmux_cfg {
> +       struct device_node      *node;
> +       const char              *pin;
> +       const char              *function;
> +       unsigned long           flags;
> +};

The current pinctrl patch set would probably want an unsigned
"position" attribute too. (If we should build on that.)

> +/**
> + * struct of_pinmux_ctrl - platform specific pinmux control state.
> + *
> + * @pinmux: the pinmux device node.  All child nodes are required to be the
> + *     pinmux entry definitions.  Depending on the platform, this may either be
> + *     a single pin or a group of pins where they can be set to a common
> + *     function.
> + * @configure: platform specific callback to configure the pinmux entry.
> + */
> +struct of_pinmux_ctrl {
> +       struct device      *dev;
> +       struct device_node *node;
> +       int                (*parse)(const struct of_pinmux_ctrl *ctrl,
> +                                   struct of_pinmux_cfg *cfg);
> +       int                (*configure)(const struct of_pinmux_ctrl *ctrl,
> +                                       const struct of_pinmux_cfg *cfg);
> +};

s/pinmux/pinctrl/g

Yours,
Linus Walleij
