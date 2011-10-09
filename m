Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1JIJ0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 05:26:40 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:6594 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750749Ab1JIJ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 05:26:39 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sun, 9 Oct 2011 17:36:52 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stijn Devriendt <highguy@gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
Message-ID: <20111009093651.GC24198@S2100-06.ap.freescale.net>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 10:17:42AM +0200, Linus Walleij wrote:
[...]
> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> new file mode 100644
> index 0000000..2cd4033
> --- /dev/null
> +++ b/include/linux/pinctrl/machine.h
> @@ -0,0 +1,107 @@
> +/*
> + * Machine interface for the pinctrl subsystem.
> + *
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + * Based on bits of regulator core, gpio core and clk core
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#ifndef __LINUX_PINMUX_MACHINE_H
> +#define __LINUX_PINMUX_MACHINE_H
> +
> +/**
> + * struct pinmux_map - boards/machines shall provide this map for devices
> + * @name: the name of this specific map entry for the particular machine.
> + *	This is the second parameter passed to pinmux_get() when you want
> + *	to have several mappings to the same device
> + * @ctrl_dev: the pin control device to be used by this mapping, may be NULL
> + *	if you provide .ctrl_dev_name instead (this is more common)
> + * @ctrl_dev_name: the name of the device controlling this specific mapping,
> + *	the name must be the same as in your struct device*, may be NULL if
> + *	you provide .ctrl_dev instead
> + * @function: a function in the driver to use for this mapping, the driver
> + *	will lookup the function referenced by this ID on the specified
> + *	pin control device
> + * @group: sometimes a function can map to different pin groups, so this
> + *	selects a certain specific pin group to activate for the function, if
> + *	left as NULL, the first applicable group will be used
> + * @dev: the device using this specific mapping, may be NULL if you provide
> + *	.dev_name instead (this is more common)
> + * @dev_name: the name of the device using this specific mapping, the name
> + *	must be the same as in your struct device*, may be NULL if you
> + *	provide .dev instead
> + * @hog_on_boot: if this is set to true, the regulator subsystem will itself
						^^^^^^^^^
s/regulator/pinmux?

> + *	hog the mappings as the pinmux device drivers are attched, so this is
> + *	typically used with system maps (mux mappings without an assigned
> + *	device) that you want to get hogged and enabled by default as soon as
> + *	a pinmux device supporting it is registered. These maps will not be
> + *	disabled and put until the system shuts down.
> + */
> +struct pinmux_map {
> +	const char *name;
> +	struct device *ctrl_dev;
> +	const char *ctrl_dev_name;
> +	const char *function;
> +	const char *group;
> +	struct device *dev;
> +	const char *dev_name;
> +	const bool hog_on_boot;
> +};
> +
> +/*
> + * Convenience macro to set a simple map from a certain pin controller and a
> + * certain function to a named device
> + */
> +#define PINMUX_MAP(a, b, c, d) \
> +	{ .name = a, .ctrl_dev_name = b, .function = c, .dev_name = d }
> +
> +/*
> + * Convenience macro to map a system function onto a certain pinctrl device.
> + * System functions are not assigned to a particular device.
> + */
> +#define PINMUX_MAP_SYS(a, b, c) \
> +	{ .name = a, .ctrl_dev_name = b, .function = c }
> +
> +/*
> + * Convenience macro to map a function onto the primary device pinctrl device
> + * this is especially helpful on systems that have only one pin controller
> + * or need to set up a lot of mappings on the primary controller.
> + */
> +#define PINMUX_MAP_PRIMARY(a, b, c) \
> +	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b, \
> +	  .dev_name = c }
> +
> +/*
> + * Convenience macro to map a system function onto the primary pinctrl device.
> + * System functions are not assigned to a particular device.
> + */
> +#define PINMUX_MAP_PRIMARY_SYS(a, b) \
> +	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b }
> +
> +/*
> + * Convenience macro to map a system function onto the primary pinctrl device,
> + * to be hogged by the pinmux core until the system shuts down.
> + */
> +#define PINMUX_MAP_PRIMARY_SYS_HOG(a, b) \
> +	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b, \
> +	  .hog_on_boot = true }
> +
> +
> +#ifdef CONFIG_PINMUX
> +
> +extern int pinmux_register_mappings(struct pinmux_map const *map,
> +				unsigned num_maps);
> +
> +#else
> +
> +static inline int pinmux_register_mappings(struct pinmux_map const *map,
> +					   unsigned num_maps)
> +{
> +	return 0;
> +}
> +
> +#endif /* !CONFIG_PINCTRL */

s/!CONFIG_PINCTRL/CONFIG_PINMUX?

> +#endif

-- 
Regards,
Shawn

