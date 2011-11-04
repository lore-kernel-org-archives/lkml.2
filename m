Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab1KDUeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:34:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47718 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1KDUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:34:05 -0400
Date: Fri, 4 Nov 2011 13:34:22 -0700
From: Olof Johansson <olof@lixom.net>
To: Rajendra Nayak <rnayak@ti.com>
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] regulator: adapt fixed regulator driver to dt
Message-ID: <20111104203422.GB3918@quad.lixom.net>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <1319702185-16108-3-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319702185-16108-3-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:26:23PM +0530, Rajendra Nayak wrote:
> The fixed regulator driver uses of_get_fixed_voltage_config()
> to extract fixed_voltage_config structure contents from device tree.
> 
> Also add documenation for additional bindings for fixed
> regulators that can be passed through dt.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>

Shouldn't a fixed regulator just be a subset of a fixed one? If so, should the
binding be merged with that one?

> ---
>  .../bindings/regulator/fixed-regulator.txt         |   25 +++++++++
>  drivers/regulator/fixed.c                          |   57 ++++++++++++++++++++
>  2 files changed, 82 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/fixed-regulator.txt
> 
> diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
> new file mode 100644
> index 0000000..049df3d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
> @@ -0,0 +1,25 @@
> +Fixed Voltage regulators
> +
> +Required properties:
> +- compatible: Must be "regulator-fixed";
> +
> +Optional properties:
> +- regulator-fixed-supply: Name of the regulator supply
> +- regulator-fixed-microvolts: Output voltage of regulator

Other regulator binding usese uV, here it's microvolts. Pick one, microvolts
has the benefit of not needing caps. :)

> +- regulator-fixed-gpio: gpio to use for enable control
> +- regulator-fixed-startup-delay: startup time in microseconds

startup-delay-ms ?

> +- regulator-fixed-enable-high: Polarity of enable GPIO,
> +  1 = Active High, 0 = Active low

Some gpio specifiers allow you to specify active high or low flags, but either
way something like "enable-active-low" as a property (with active high as
default if property is missing) is a more devicetreey convention.

> +- regulator-fixed-enabled-at-boot: 1 = yes, 0 = no

Same here, you can drop the prefix. Also, the regular regulators use
"regulator-name" for the supply name, it would make sense to reuse the same
naming here, right?

> +
> +Example:
> +
> +	abc: fixedregulator@0 {
> +		compatible = "regulator-fixed";
> +		regulator-fixed-supply = "fixed-supply";
> +		regulator-fixed-microvolts = <1800000>;
> +		regulator-fixed-gpio = <43>;

This is not a valid gpio specifier.

> +		regulator-fixed-startup-delay = <70000>;
> +		regulator-fixed-enable-high;
> +		regulator-fixed-enabled-at-boot;
> +	};
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index 2fe9d99..9851b42 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -26,6 +26,9 @@
>  #include <linux/gpio.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/regulator/of_regulator.h>
> +#include <linux/regulator/machine.h>
>  
>  struct fixed_voltage_data {
>  	struct regulator_desc desc;
> @@ -37,6 +40,46 @@ struct fixed_voltage_data {
>  	bool is_enabled;
>  };
>  
> +
> +/**
> + * of_get_fixed_voltage_config - extract fixed_voltage_config structure info
> + * @dev: device requesting for fixed_voltage_config
> + *
> + * Populates fixed_voltage_config structure by extracting data from device
> + * tree node, returns a pointer to the populated structure of NULL if memory
> + * alloc fails.
> + */
> +struct fixed_voltage_config *of_get_fixed_voltage_config(struct device *dev)
> +{
> +	struct fixed_voltage_config *config;
> +	struct device_node *np = dev->of_node;
> +	const __be32 *microvolts, *gpio, *delay;
> +
> +	config = devm_kzalloc(dev, sizeof(struct fixed_voltage_config), GFP_KERNEL);
> +	if (!config)
> +		return NULL;
> +
> +	config->supply_name = of_get_property(np, "regulator-fixed-supply", NULL);
> +	microvolts = of_get_property(np, "regulator-fixed-microvolts", NULL);
> +	if (microvolts)
> +		config->microvolts = be32_to_cpu(*microvolts);
> +	gpio = of_get_property(np, "regulator-fixed-gpio", NULL);
> +	if (gpio)
> +		config->gpio = be32_to_cpu(*gpio);

This needs to be fixed to parse a gpio properly instead.



-Olof
