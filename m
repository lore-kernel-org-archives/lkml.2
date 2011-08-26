Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1HZJQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:16:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62164 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab1HZJQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:16:18 -0400
Date: Fri, 26 Aug 2011 10:16:08 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 10/13] of: add a generic pinmux helper
Message-ID: <20110826091608.GA3926@pulham.picochip.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
 <1314315824-9687-11-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314315824-9687-11-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Aug 25, 2011 at 05:43:41PM -0600, Stephen Warren wrote:
> From: Jamie Iles <jamie@jamieiles.com>
> 
> This patch adds a helper function of_pinmux_parse() that can be used to
> extract common pinmux configuration to avoid each platform implementing
> a parsing loop.  Platforms supply the node containing the pinmux
> definitions and a platform specific callback for configuring a pingroup.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> [swarren: Added support for pins property, added parse() callback, use
>  dev_err instead of pr_err, related minor changes]
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/of/Kconfig        |    5 ++
>  drivers/of/Makefile       |    1 +
>  drivers/of/of_pinmux.c    |  109 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_pinmux.h |   74 ++++++++++++++++++++++++++++++
>  4 files changed, 189 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/of/of_pinmux.c
>  create mode 100644 include/linux/of_pinmux.h
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index cac63c9..71a19a3 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -81,4 +81,9 @@ config OF_PCI_IRQ
>  	help
>  	  OpenFirmware PCI IRQ routing helpers
>  
> +config OF_PINMUX
> +	def_bool y
> +	help
> +	  OpenFirmware pin multiplexing helpers
> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index dccb117..0666ff3 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_OF_SPI)	+= of_spi.o
>  obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
>  obj-$(CONFIG_OF_PCI)	+= of_pci.o
>  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
> +obj-$(CONFIG_OF_PINMUX) += of_pinmux.o
> diff --git a/drivers/of/of_pinmux.c b/drivers/of/of_pinmux.c
> new file mode 100644
> index 0000000..8050b8b
> --- /dev/null
> +++ b/drivers/of/of_pinmux.c
> @@ -0,0 +1,109 @@
> +/*
> + * Copyright (c) 2011 Picochip Ltd., Jamie Iles
> + * Copyright (c) 2011 NVIDIA, Inc.
> + *
> + * Generic pinmux bindings for device tree.
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
> + */
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +#include <linux/of_iter_prop.h>
> +#include <linux/of_pinmux.h>
> +
> +/**
> + * of_pinmux_parse - configure a set of pinmux groups for a pinmux controller
> + *
> + * @controller: the controller to configure the pinmux entries for.  This
> + *	defines the controller device node and the callback for configuring
> + *	the pingroups.
> + *
> + * This helper loops over all of the child nodes of a pinmux controller and
> + * collects the configuration for each pinmux group.  A pinmux group is
> + * defined as one or more pins that are configured to a common function.  This
> + * handles common properties that many platforms may implement, but for
> + * platform specific properties these may be handled in the configure
> + * callback.
> + */
> +int of_pinmux_parse(const struct of_pinmux_ctrl *ctrl,
> +		    struct of_pinmux_cfg *cfg)
> +{
> +	struct device_node *np;
> +
> +	if (!ctrl || !ctrl->dev || !ctrl->node || !ctrl->configure)
> +		return -EINVAL;
> +
> +	for_each_child_of_node(ctrl->node, np) {
> +		int ret;
> +		bool hadpins = 0;
> +		struct of_iter_string_prop iter;
> +
> +		cfg->node = np;
> +
> +		ret = of_property_read_string(np, "function",
> +					      &cfg->function);
> +		if (ret < 0) {
> +			dev_err(ctrl->dev, "no function for node %s\n",
> +				np->name);
> +			continue;
> +		}
> +
> +		cfg->flags &= 0;

cfg->flags = 0?

> +
> +		if (of_find_property(np, "pull-up", NULL))
> +			cfg->flags |= OF_PINMUX_PULL_UP;
> +		if (of_find_property(np, "pull-down", NULL))
> +			cfg->flags |= OF_PINMUX_PULL_DOWN;
> +
> +		if ((cfg->flags & OF_PINMUX_PULL_MASK) ==
> +		    OF_PINMUX_PULL_MASK) {
> +			dev_warn(ctrl->dev, "node %s has both "
> +				 "pull-up and pull-down properties - "
> +				 "defaulting to no pull\n",
> +				 np->name);

For format strings I believe it's preferred to keep it on one long line 
so it can at least be grepped for.

> +			cfg->flags &= ~OF_PINMUX_PULL_MASK;
> +		}
> +
> +		if (of_find_property(np, "tristate", NULL))
> +			cfg->flags |= OF_PINMUX_TRISTATE;
> +
> +		if (ctrl->parse && ctrl->parse(ctrl, cfg)) {
> +			dev_warn(ctrl->dev,
> +				    "failed to parse node %s\n",
> +				    np->name);
> +			continue;
> +		}
> +
> +		for_each_string_property_value(iter, np, "pins") {
> +			hadpins = 1;
> +
> +			cfg->pin = iter.value;
> +
> +			dev_dbg(ctrl->dev,
> +				"configure pin %s func=%s flags=0x%lx\n",
> +				cfg->pin, cfg->function, cfg->flags);
> +			if (ctrl->configure(ctrl, cfg))
> +				dev_warn(ctrl->dev,
> +					 "failed to configure pin %s\n",
> +					 cfg->pin);
> +		}
> +
> +		if (!hadpins)
> +			dev_warn(ctrl->dev, "no pins for node %s\n",
> +				 np->name);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_pinmux_parse);
> diff --git a/include/linux/of_pinmux.h b/include/linux/of_pinmux.h
> new file mode 100644
> index 0000000..7ccddcf
> --- /dev/null
> +++ b/include/linux/of_pinmux.h
> @@ -0,0 +1,74 @@
> +/*
> + * Copyright (c) 2011 Picochip Ltd., Jamie Iles
> + * Copyright (c) 2011 NVIDIA, Inc.
> + *
> + * Generic pinmux bindings for device tree.
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
> + */
> +#ifndef __OF_PINMUX_H__
> +#define __OF_PINMUX_H__
> +
> +struct device_node;
> +
> +#define OF_PINMUX_PULL_UP	(1 << 0)
> +#define OF_PINMUX_PULL_DOWN	(1 << 1)
> +#define OF_PINMUX_TRISTATE	(1 << 2)
> +
> +#define OF_PINMUX_PULL_MASK	(OF_PINMUX_PULL_UP | OF_PINMUX_PULL_DOWN)
> +
> +/**
> + * struct of_pinmux_cfg - configuration state for a single pinmux entry.
> + *
> + * @function: the name of the function that the pinmux entry should be
> + *	configured to.
> + * @pin: the device_node of the pinmux entry that should be configured.
> + *	Platform specific properties that aren't in the generic binding may be
> + *	obtained from this device node.
> + * @flags: flags for common pinmux options such as pull and tristate.

The kerneldoc is out of date here.

> + */
> +struct of_pinmux_cfg {
> +	struct device_node	*node;
> +	const char		*pin;
> +	const char		*function;
> +	unsigned long		flags;
> +};
> +
> +/**
> + * struct of_pinmux_ctrl - platform specific pinmux control state.
> + *
> + * @pinmux: the pinmux device node.  All child nodes are required to be the
> + *	pinmux entry definitions.  Depending on the platform, this may either be
> + *	a single pin or a group of pins where they can be set to a common
> + *	function.
> + * @configure: platform specific callback to configure the pinmux entry.

and here.

> + */
> +struct of_pinmux_ctrl {
> +	struct device	   *dev;
> +	struct device_node *node;
> +	int		   (*parse)(const struct of_pinmux_ctrl *ctrl,
> +				    struct of_pinmux_cfg *cfg);
> +	int		   (*configure)(const struct of_pinmux_ctrl *ctrl,
> +					const struct of_pinmux_cfg *cfg);
> +};
> +
> +#ifdef CONFIG_OF
> +extern int of_pinmux_parse(const struct of_pinmux_ctrl *ctrl,
> +			   struct of_pinmux_cfg *cfg);
> +#else
> +static inline int of_pinmux_parse(const struct of_pinmux_ctrl *ctrl,
> +				  struct of_pinmux_cfg *cfg)
> +{
> +	return -ENOSYS;
> +}
> +#endif /* CONFIG_OF */
> +
> +#endif /* __OF_PINMUX_H__ */
> -- 
> 1.7.0.4
> 
