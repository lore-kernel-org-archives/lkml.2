Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab2KQLmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 06:42:04 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58470 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2KQLmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 06:42:00 -0500
Date: Sat, 17 Nov 2012 03:38:50 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121117113849.GA5228@lizard>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 07:55:45PM +0900, Alexandre Courbot wrote:
> Some device drivers (e.g. panel or backlights) need to follow precise
> sequences for powering on and off, involving GPIOs, regulators, PWMs
> and other power-related resources, with a defined powering order and
> delays to respect between steps. These sequences are device-specific,
> and do not belong to a particular driver - therefore they have been
> performed by board-specific hook functions so far.
> 
> With the advent of the device tree and of ARM kernels that are not
> board-tied, we cannot rely on these board-specific hooks anymore but
> need a way to implement these sequences in a portable manner. This patch
> introduces a simple interpreter that can execute such power sequences
> encoded either as platform data or within the device tree. It also
> introduces first support for regulator, GPIO and PWM resources.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@wwwdotorg.org>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---

This looks almost perfect!

Just a few final notes, again mostly about the build system bits.

[...]
> diff --git a/drivers/power/power_seq/Kconfig b/drivers/power/power_seq/Kconfig
> new file mode 100644
> index 0000000..0ece819
> --- /dev/null
> +++ b/drivers/power/power_seq/Kconfig
> @@ -0,0 +1,2 @@
> +config POWER_SEQ
> +	tristate

This really needs a proper Kconfig description and a help text, shortly
describing the purpose of the subsystem.

> diff --git a/drivers/power/power_seq/Makefile b/drivers/power/power_seq/Makefile
> new file mode 100644
> index 0000000..964b91e
> --- /dev/null
> +++ b/drivers/power/power_seq/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_POWER_SEQ)		+= power_seq.o
> +power_seq-y			:= core.o delay.o regulator.o gpio.o pwm.o
> diff --git a/drivers/power/power_seq/core.c b/drivers/power/power_seq/core.c
> new file mode 100644
> index 0000000..d51b9b8
> --- /dev/null
> +++ b/drivers/power/power_seq/core.c
> @@ -0,0 +1,362 @@
> +/*
> + * core.c - power sequence interpreter for platform devices and device tree

We usually don't write file names in the comments.

> + *
> + * Author: Alexandre Courbot <acourbot@nvidia.com>
> + *
[...]
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(power_seq_run);
> +
> +/* defined in power_seq_*.c files */

Why not place the decls into the _priv.h file?.. I understand that this
might be a temporary stuff until we have something better for ops
registration, but still, I believe it belongs to the header file.

> +extern const struct power_seq_res_ops power_seq_delay_ops;
> +extern const struct power_seq_res_ops power_seq_gpio_ops;
> +extern const struct power_seq_res_ops power_seq_regulator_ops;
> +extern const struct power_seq_res_ops power_seq_pwm_ops;
> +
> +static const struct power_seq_res_ops *power_seq_ops[POWER_SEQ_NUM_TYPES] = {
> +	[POWER_SEQ_DELAY] = &power_seq_delay_ops,
> +	[POWER_SEQ_REGULATOR] = &power_seq_regulator_ops,
> +	[POWER_SEQ_PWM] = &power_seq_gpio_ops,
> +	[POWER_SEQ_GPIO] = &power_seq_pwm_ops,
> +};
> +
> +MODULE_AUTHOR("Alexandre Courbot <acourbot@nvidia.com>");
> +MODULE_DESCRIPTION("Runtime Interpreted Power Sequences");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/power/power_seq/delay.c b/drivers/power/power_seq/delay.c
> new file mode 100644
> index 0000000..de6810b
> --- /dev/null
> +++ b/drivers/power/power_seq/delay.c
> @@ -0,0 +1,66 @@
> +/*
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + */
> +
> +#include "power_seq_priv.h"
> +#include <linux/delay.h>

Things should not depend on _priv.h's includes. I.e. I see this file uses
of_ routines, so it should include <linux/of.h>. <linux/delay.h> for
udelay_range(), etc.

Also, usually we place "private" headers at the very end, not at the
beginning.

> +
> +#ifdef CONFIG_OF
> +static int of_power_seq_parse_delay(struct device_node *node,
> +				    struct power_seq *seq,
> +				    unsigned int step_nbr,
> +				    struct power_seq_resource *res)
> +{
> +	struct power_seq_step *step = &seq->steps[step_nbr];
> +	int err;
> +
> +	err = of_property_read_u32(node, "delay",
> +				   &step->delay.delay);
> +	if (err < 0)
> +		power_seq_err(seq, step_nbr, "error reading delay property\n");
> +
> +	return err;
> +}
> +#else
> +#define of_power_seq_parse_delay NULL
> +#endif

[...]
> +#define power_seq_err(seq, step_nbr, format, ...)			\
> +	dev_err(seq->set->dev, "%s[%d]: " format, seq->id, step_nbr,	\
> +	##__VA_ARGS__);
> +
> +#ifdef CONFIG_OF
> +int of_power_seq_parse_enable_properties(struct device_node *node,
> +					 struct power_seq *seq,
> +					 unsigned int step_nbr, bool *enable);

Um, I believe you don't need CONFIG_OF here. (If it's about 'struct
device_node', then as I see it in of.h, the header always declares it,
even for the !OF case.)

> +#endif
> +
> +/**
[...]
> +++ b/drivers/power/power_seq/regulator.c
> @@ -0,0 +1,87 @@
> +/*
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + */
> +
> +#include "power_seq_priv.h"
> +
> +#ifdef CONFIG_REGULATOR

Would be really great if you could get rid of the #ifdefs in the .c files.

To do so, in the makefile you could write something like this:

power_seq-$(CONFIG_REGULATOR) += regulator.o

And in the header file (as explained above), you'd have

#ifdef CONFIG_REGULATOR
#define ...REGULATOR_OPS &power_seq_regulator_ops
#else
#define ...REGULATOR_OPS NULL
#endif

Or something along these lines...

Thanks,
Anton.
