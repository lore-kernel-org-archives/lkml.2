Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab1JRNJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:09:54 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:56968
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757636Ab1JRNJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:09:52 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKc8kzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
Date: Tue, 18 Oct 2011 21:20:33 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <patches@linaro.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111018132032.GD30703@S2100-06.ap.freescale.net>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1318263578-7407-4-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 09:49:36PM +0530, Rajendra Nayak wrote:
> The helper routine is meant to be used by regulator drivers
> to extract the regulator_init_data structure from the data
> that is passed from device tree.
> 'consumer_supplies' which is part of regulator_init_data is not extracted
> as the regulator consumer mappings are passed through DT differently,
> implemented in subsequent patches.
> Similarly the regulator<-->parent/supply mapping is handled in
> subsequent patches.
> 
> Also add documentation for regulator bindings to be used to pass
> regulator_init_data struct information from device tree.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> ---
>  .../devicetree/bindings/regulator/regulator.txt    |   44 +++++++++
>  drivers/regulator/Kconfig                          |    8 ++
>  drivers/regulator/Makefile                         |    1 +
>  drivers/regulator/of_regulator.c                   |   93 ++++++++++++++++++++
>  include/linux/regulator/of_regulator.h             |   21 +++++
>  5 files changed, 167 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/regulator.txt
>  create mode 100644 drivers/regulator/of_regulator.c
>  create mode 100644 include/linux/regulator/of_regulator.h
> 
> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
> new file mode 100644
> index 0000000..a623fdd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/regulator.txt
> @@ -0,0 +1,44 @@
> +Voltage/Current Regulators
> +
> +Optional properties:
> +- regulator-min-uV: smallest voltage consumers may set
> +- regulator-max-uV: largest voltage consumers may set
> +- regulator-uV-offset: Offset applied to voltages to compensate for voltage drops
> +- regulator-min-uA: smallest current consumers may set
> +- regulator-max-uA: largest current consumers may set
> +- regulator-change-voltage: boolean, Output voltage can be changed by software
> +- regulator-change-current: boolean, Output current can be chnaged by software
> +- regulator-change-mode: boolean, Operating mode can be changed by software
> +- regulator-change-status: boolean, Enable/Disable control for regulator exists
> +- regulator-change-drms: boolean, Dynamic regulator mode switching is enabled
> +- regulator-mode-fast: boolean, allow/set fast mode for the regulator
> +- regulator-mode-normal: boolean, allow/set normal mode for the regulator
> +- regulator-mode-idle: boolean, allow/set idle mode for the regulator
> +- regulator-mode-standby: boolean, allow/set standby mode for the regulator
> +- regulator-input-uV: Input voltage for regulator when supplied by another regulator
> +- regulator-always-on: boolean, regulator should never be disabled
> +- regulator-boot-on: bootloader/firmware enabled regulator
> +- <name>-supply: phandle to the parent supply/regulator node
> +
> +Example:
> +
> +	xyzreg: regulator@0 {

Does this node have a compatible string?  With looking at the code,
I guess it has a compatible string in your dts file.

> +		regulator-min-uV = <1000000>;
> +		regulator-max-uV = <2500000>;
> +		regulator-mode-fast;
> +		regulator-change-voltage;
> +		regulator-always-on;
> +		vin-supply = <&vin>;
> +	};
> +
> +The same binding used by a regulator to reference its
> +supply can be used by any consumer to reference its
> +regulator/supply
> +
> +Example of a device node referencing a regulator node,
> +
> +	devicenode: node@0x0 {
> +		...
> +		...
> +		<name>-supply = <&xyzreg>;
> +	};
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index c7fd2c0..981c92e 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -64,6 +64,14 @@ config REGULATOR_USERSPACE_CONSUMER
>  
>            If unsure, say no.
>  
> +config OF_REGULATOR
> +	tristate "OF regulator helpers"
> +	depends on OF
> +	default y if OF
> +	help
> +	  OpenFirmware regulator framework helper routines that can
> +	  used by regulator drivers to extract data from device tree.
> +
>  config REGULATOR_BQ24022
>  	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
>  	help
> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
> index 040d5aa..e6bc009 100644
> --- a/drivers/regulator/Makefile
> +++ b/drivers/regulator/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_REGULATOR) += core.o dummy.o
>  obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
>  obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
>  obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
> +obj-$(CONFIG_OF_REGULATOR) += of_regulator.o
>  
>  obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
>  obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
> new file mode 100644
> index 0000000..9262d06
> --- /dev/null
> +++ b/drivers/regulator/of_regulator.c
> @@ -0,0 +1,93 @@
> +/*
> + * OF helpers for regulator framework
> + *
> + * Copyright (C) 2011 Texas Instruments, Inc.
> + * Rajendra Nayak <rnayak@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/regulator/machine.h>
> +
> +static void of_get_regulation_constraints(struct device_node *np,
> +					struct regulator_init_data **init_data)
> +{
> +	const __be32 *min_uV, *max_uV, *uV_offset;
> +	const __be32 *min_uA, *max_uA, *input_uV;
> +	unsigned int valid_modes_mask = 0, valid_ops_mask = 0;
> +
> +	min_uV = of_get_property(np, "regulator-min-uV", NULL);
> +	if (min_uV)
> +		(*init_data)->constraints.min_uV = be32_to_cpu(*min_uV);
> +	max_uV = of_get_property(np, "regulator-max-uV", NULL);
> +	if (max_uV)
> +		(*init_data)->constraints.max_uV = be32_to_cpu(*max_uV);
> +	uV_offset = of_get_property(np, "regulator-uV-offset", NULL);
> +	if (uV_offset)
> +		(*init_data)->constraints.uV_offset = be32_to_cpu(*uV_offset);
> +	min_uA = of_get_property(np, "regulator-min-uA", NULL);
> +	if (min_uA)
> +		(*init_data)->constraints.min_uA = be32_to_cpu(*min_uA);
> +	max_uA = of_get_property(np, "regulator-max-uA", NULL);
> +	if (max_uA)
> +		(*init_data)->constraints.max_uA = be32_to_cpu(*max_uA);
> +	input_uV = of_get_property(np, "regulator-input-uV", NULL);
> +	if (input_uV)
> +		(*init_data)->constraints.input_uV = be32_to_cpu(*input_uV);
> +
> +	/* valid modes mask */
> +	if (of_find_property(np, "regulator-mode-fast", NULL))
> +				valid_modes_mask |= REGULATOR_MODE_FAST;
> +	if (of_find_property(np, "regulator-mode-normal", NULL))
> +				valid_modes_mask |= REGULATOR_MODE_NORMAL;
> +	if (of_find_property(np, "regulator-mode-idle", NULL))
> +				valid_modes_mask |= REGULATOR_MODE_IDLE;
> +	if (of_find_property(np, "regulator-mode-standby", NULL))
> +				valid_modes_mask |= REGULATOR_MODE_STANDBY;
> +
> +	/* valid ops mask */
> +	if (of_find_property(np, "regulator-change-voltage", NULL))
> +				valid_ops_mask |= REGULATOR_CHANGE_VOLTAGE;
> +	if (of_find_property(np, "regulator-change-current", NULL))
> +				valid_ops_mask |= REGULATOR_CHANGE_CURRENT;
> +	if (of_find_property(np, "regulator-change-mode", NULL))
> +				valid_ops_mask |= REGULATOR_CHANGE_MODE;
> +	if (of_find_property(np, "regulator-change-status", NULL))
> +				valid_ops_mask |= REGULATOR_CHANGE_STATUS;
> +
> +	(*init_data)->constraints.valid_modes_mask = valid_modes_mask;
> +	(*init_data)->constraints.valid_ops_mask = valid_ops_mask;
> +
> +	if (of_find_property(np, "regulator-always-on", NULL))
> +				(*init_data)->constraints.always_on = true;
> +	if (of_find_property(np, "regulator-boot-on", NULL))
> +				(*init_data)->constraints.boot_on = true;
> +}
> +
> +/**
> + * of_get_regulator_init_data - extract regulator_init_data structure info
> + * @dev: device requesting for regulator_init_data
> + *
> + * Populates regulator_init_data structure by extracting data from device
> + * tree node, returns a pointer to the populated struture or NULL if memory
> + * alloc fails.
> + */
> +struct regulator_init_data *of_get_regulator_init_data(struct device *dev)

I remember that Mark ever had a comment on a previous regulator DT
series from Haojian Zhuang, saying this DT parsing procedure can
probably just be private to regulator core and invisible to regulator
drivers.  That said whenever regulator_register() gets called with
parameter init_data as NULL, it should try to retrieve
regulator_init_data from device tree.  It will ease regulator drivers
a little.  They will only need to call regulator_register() with NULL
init_data for DT case.  More importantly, doing so will help solve the
dual 'dev' problem I see below.

> +{
> +	struct regulator_init_data *init_data;
> +
> +	if (!dev->of_node)
> +		return NULL;
> +
> +	init_data = devm_kzalloc(dev, sizeof(*init_data), GFP_KERNEL);
> +	if (!init_data)
> +		return NULL; /* Out of memory? */
> +
> +	of_get_regulation_constraints(dev->of_node, &init_data);

Beside the 'dev' here with of_node attached, there will be another
'dev' created by regulator core function regulator_register(), which
is wrapped by 'regulator_dev'.

So we have two 'dev'.  One is created by DT core with of_node attached,
and used to retrieve regulator_init_data from device tree.  Another one
is created in regulator_register() and used by regulator core.

IMO, this is not what we want.  Instead of having two 'dev' for given
regulator, we should use the same 'dev' created in regulator_register()
to retrieve regulator_init_data from device tree, so that we do not need
the 'dev' created by DT core.  That said, with DT parsing procedure
moved into regulator core, we can get of_node for given regulator and
attach it to the 'dev' created by regulator core.

Will elaborate it a little more in patch #5.

Regards,
Shawn

> +	return init_data;
> +}
> diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
> new file mode 100644
> index 0000000..c5a1ad6
> --- /dev/null
> +++ b/include/linux/regulator/of_regulator.h
> @@ -0,0 +1,21 @@
> +/*
> + * OpenFirmware regulator support routines
> + *
> + */
> +
> +#ifndef __LINUX_OF_REG_H
> +#define __LINUX_OF_REG_H
> +
> +#if defined(CONFIG_OF_REGULATOR)
> +extern struct regulator_init_data
> +	*of_get_regulator_init_data(struct device *dev);
> +#else
> +static inline struct regulator_init_data
> +	*of_get_regulator_init_data(struct device *dev)
> +{
> +	return NULL;
> +}
> +#endif /* CONFIG_OF_REGULATOR */
> +
> +#endif /* __LINUX_OF_REG_H */
> +
> -- 
> 1.7.1
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

