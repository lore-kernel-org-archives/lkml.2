Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761858Ab2EJWcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:32:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39287 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761612Ab2EJWch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:32:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 2/4] regulator: tps62360: add dt support
To: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com,
        linux@arm.linux.org.uk, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        olof@lixom.net
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1336682979-11810-3-git-send-email-ldewangan@nvidia.com>
References: <1336682979-11810-1-git-send-email-ldewangan@nvidia.com> <1336682979-11810-3-git-send-email-ldewangan@nvidia.com>
Date: Thu, 10 May 2012 16:32:34 -0600
Message-Id: <20120510223234.687863E04A6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 02:19:37 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Add dt support for the pmu device tps62360 and
> Add binding documentation with example.
> With this patch driver will support both device-tree and
> non-device tree registration.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> Fixed possible build error in non devicetree.

Minor comments below...

> 
>  .../bindings/regulator/tps62360-regulator.txt      |   45 ++++++++++++
>  drivers/regulator/tps62360-regulator.c             |   74 +++++++++++++++++++-
>  2 files changed, 118 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
> 
> diff --git a/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
> new file mode 100644
> index 0000000..e337cd6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
> @@ -0,0 +1,45 @@
> +TPS62360 Voltage regulators
> +
> +Required properties:
> +- compatible: Must be one of the following.
> +	"ti,tps62360"
> +	"ti,tps62361",
> +	"ti,tps62362",
> +	"ti,tps62363",
> +- reg: I2C slave address
> +
> +Optional properties:
> +- ti,enable-force-pwm: Enable fore PWM mode. This is boolean value.
typo ----------------------------^^^^

> +- ti,enable-vout-discharge: Enable output discharge. This is boolean value.
> +- ti,enable-pull-down: Enable pull down. This is boolean value.
> +- ti,vsel0-gpio: GPIO for controlling VSEL0 line.
> +  If this property is missing, then assume that there is no GPIO
> +  for vsel0 control.
> +- ti,vsel1-gpio: Gpio for controlling VSEL1 line.
> +  If this property is missing, then assume that there is no GPIO
> +  for vsel1 control.
> +- ti,vsel0-state-high: Inital state of vsel0 input is high.
> +  If this property is missing, then assume the state as low (0).
> +- ti,vsel1-state-high: Inital state of vsel1 input is high.
> +  If this property is missing, then assume the state as low (0).
> +
> +Any property defined as part of the core regulator binding, defined in
> +regulator.txt, can also be used.
> +
> +Example:
> +
> +	abc: tps62360 {
> +		compatible = "ti,tps62361";
> +		reg =  <0x60>;
> +		regulator-name = "tps62361-vout";
> +		regulator-min-microvolt = <500000>;
> +		regulator-max-microvolt = <1500000>;
> +		regulator-boot-on
> +		ti,vsel0-gpio = <&gpio1 16 0>;
> +		ti,vsel1-gpio = <&gpio1 17 0>;
> +		ti,vsel0-state-high;
> +		ti,vsel1-state-high;
> +		ti,enable-pull-down;
> +		ti,enable-force-pwm;
> +		ti,enable-vout-discharge;
> +	};
> diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
> index 3506900..9985303 100644
> --- a/drivers/regulator/tps62360-regulator.c
> +++ b/drivers/regulator/tps62360-regulator.c
> @@ -26,6 +26,10 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_gpio.h>
> +#include <linux/regulator/of_regulator.h>
>  #include <linux/platform_device.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/machine.h>
> @@ -297,6 +301,58 @@ static const struct regmap_config tps62360_regmap_config = {
>  	.cache_type		= REGCACHE_RBTREE,
>  };
>  
> +static struct tps62360_regulator_platform_data *
> +	of_get_tps62360_platform_data(struct device *dev)
> +{
> +	struct tps62360_regulator_platform_data *pdata;
> +	struct device_node *np = dev->of_node;
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		dev_err(dev, "Memory alloc failed for platform data\n");
> +		return NULL;
> +	}
> +
> +	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
> +	if (!pdata->reg_init_data) {
> +		dev_err(dev, "Not able to get OF regulator init data\n");
> +		return NULL;
> +	}
> +
> +	pdata->vsel0_gpio = of_get_named_gpio(np, "vsel0-gpio", 0);
> +	pdata->vsel1_gpio = of_get_named_gpio(np, "vsel1_gpio", 0);
typo --------------------------------------------------^^^

Otherwise looks good to me.

g.

