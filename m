Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1LICau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:30:50 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34574 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1LICaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:30:46 -0500
MIME-Version: 1.0
In-Reply-To: <1323361659-11835-3-git-send-email-thomas.abraham@linaro.org>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
	<1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
	<1323361659-11835-3-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 9 Dec 2011 11:30:44 +0900
X-Google-Sender-Auth: 6Cz955nbYOpHujTjMDyn5005drk
Message-ID: <CAH9JG2WhH27O6VLZWro_cZ9-TgV+=kjvOM6UiAY=-4eAO1sChA@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: add device tree support for max8997
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/11, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Add device tree based discovery support for max8997.
>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  .../devicetree/bindings/regulator/max8997-pmic.txt |  122 +++++++++++++++++
>  drivers/mfd/max8997.c                              |   70 ++++++++++-
>  drivers/regulator/max8997.c                        |  137
> ++++++++++++++++++++
>  3 files changed, 328 insertions(+), 1 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/regulator/max8997-pmic.txt
>
> diff --git a/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
> b/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
> new file mode 100644
> index 0000000..1d5db76
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
> @@ -0,0 +1,122 @@
> +* Maxim MAX8997 Voltage and Current Regulator
> +
> +The Maxim MAX8997 is a multi-function device which includes volatage and
> +current regulators, rtc, charger controller and other sub-blocks. It is
> +interfaced to the host controller using a i2c interface. Each sub-block is
> +addressed by the host system using different i2c slave address. This
> document
> +describes the bindings for 'pmic' sub-block of max8997.
> +
> +Required properties:
> +- compatible: Should be "maxim,max8997-pmic".
> +- reg: Specifies the i2c slave address of the pmic block. It should be
> 0x66.
> +
> +Required properties, if interrupts are delivered to host system:
> +- interrupt-parent: Specifies the phandle of the interrupt controller to
> which
> +  the interrupts from max8997 are delivered to.
> +- interrupts: Interrupt specifiers for two interrupt sources.
> +  - First interrupt specifier is for 'irq1' interrupt.
> +  - Second interrupt specifier is for 'alert' interrupt.
> +
> +Optional properties:
> +- max8997,pmic-buck1-uses-gpio-dvs: 'buck1' can be controlled by gpio dvs.
> +- max8997,pmic-buck2-uses-gpio-dvs: 'buck2' can be controlled by gpio dvs.
> +- max8997,pmic-buck5-uses-gpio-dvs: 'buck5' can be controlled by gpio dvs.
> +
> +Additional properties required if either of the optional properties are
> used:
> +- max8997,pmic-ignore-gpiodvs-side-effect: When GPIO-DVS mode is used for
> +  multiple bucks, changing the voltage value of one of the bucks may affect
> +  that of another buck, which is the side effect of the change
> (set_voltage).
> +  Use this property to ignore such side effects and change the voltage.
> +
> +- max8997,pmic-buck125-default-dvs-idx: Default voltage setting selected
> from
> +  the possible 8 options selectable by the dvs gpios. The value of this
> +  property should be between 0 and 7. If not specified or if out of range,
> the
> +  default value of this property is set to 0.
> +
> +- max8997,pmic-buck125-dvs-gpios: GPIO specifiers for three host gpio's
> used
> +  for dvs. The format of the gpio specifier depends in the gpio controller.
> +
> +- max8997,pmic-buck1-dvs-voltage: A set of 8 voltage values in micro-volt
> (uV)
> +  units for buck1 when changing voltage using gpio dvs.
> +
> +- max8997,pmic-buck2-dvs-voltage: A set of 8 voltage values in micro-volt
> (uV)
> +  units for buck2 when changing voltage using gpio dvs.
> +
> +- max8997,pmic-buck5-dvs-voltage: A set of 8 voltage values in micro-volt
> (uV)
> +  units for buck5 when changing voltage using gpio dvs.
> +
> +Regulators: The regulators of max8997 that have to be instantiated should
> be
> +included in a sub-node named 'regulators'. Regulator nodes included in this
> +sub-node should be of the format as below. Note: The 'n' in LDOn and BUCKn
> +represents the LDO or BUCK number as per the datasheet of max8997.
> +
> +    For LDO's:
> +		LDOn {
> +			standard regulator bindings here
> +		};
> +
> +    For BUCK's
> +		BUCKn {
> +			standard regulator bindings here
> +		};
> +
> +The bindings inside the regulator nodes use the standard regulator bindings
> +which are documented elsewhere.
> +
> +Example:
> +
> +	max8997_pmic@66 {
> +		compatible = "maxim,max8997-pmic";
> +		interrupt-parent = <&wakeup_eint>;
> +		reg = <0x66>;
> +		interrupts = <4 0>, <3 0>;
> +
> +		max8997,pmic-buck1-uses-gpio-dvs;
> +		max8997,pmic-buck2-uses-gpio-dvs;
> +		max8997,pmic-buck5-uses-gpio-dvs;
> +
> +		max8997,pmic-ignore-gpiodvs-side-effect;
> +		max8997,pmic-buck125-default-dvs-idx = <0>;
> +
> +		max8997,pmic-buck125-dvs-gpios = <&gpx0 0 1 0 0>, /* SET1 */
> +						 <&gpx0 1 1 0 0>, /* SET2 */
> +						 <&gpx0 2 1 0 0>; /* SET3 */
> +
> +		max8997,pmic-buck1-dvs-voltage = <1350000>, <1300000>,
> +						 <1250000>, <1200000>,
> +						 <1150000>, <1100000>,
> +						 <1000000>, <950000>;
> +
> +		max8997,pmic-buck2-dvs-voltage = <1100000>, <1100000>,
> +				    		 <1100000>, <1100000>,
> +						 <1000000>, <1000000>,
> +						 <1000000>, <1000000>;
> +
> +		max8997,pmic-buck5-dvs-voltage = <1200000>, <1200000>,
> +						 <1200000>, <1200000>,
> +						 <1200000>, <1200000>,
> +						 <1200000>, <1200000>;
> +
> +		regulators {
> +			ldo1_reg: LDO1 {
> +				regulator-name = "VDD_ABB_3.3V";
> +				regulator-min-microvolt = <3300000>;
> +				regulator-max-microvolt = <3300000>;
> +			};
> +
> +			ldo2_reg: LDO2 {
> +				regulator-name = "VDD_ALIVE_1.1V";
> +				regulator-min-microvolt = <1100000>;
> +				regulator-max-microvolt = <1100000>;
> +				regulator-always-on;
> +			};
> +
> +			buck1_reg: BUCK1 {
> +				regulator-name = "VDD_ARM_1.2V";
> +				regulator-min-microvolt = <950000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +		};
> +	};
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index b996c6e..1749cf9 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -23,6 +23,7 @@
>
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
> +#include <linux/of_irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/module.h>
> @@ -122,6 +123,60 @@ int max8997_update_reg(struct i2c_client *i2c, u8 reg,
> u8 val, u8 mask)
>  }
>  EXPORT_SYMBOL_GPL(max8997_update_reg);
>
> +#ifdef CONFIG_OF
> +/*
> + * Only the common platform data elements for max8997 are parsed here from
> the
> + * device tree. Other sub-modules of max8997 such as pmic, rtc and others
> have
> + * to parse their own platform data elements from device tree.
> + *
> + * The max8997 platform data structure is instantiated here and the drivers
> for
> + * the sub-modules need not instantiate another instance while parsing
> their
> + * platform data.
> + */
> +static int max8997_i2c_parse_dt_pdata(struct device *dev,
> +					struct max8997_platform_data **pdata)
> +{
> +	struct max8997_platform_data *pd;
> +
> +	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> +	if (!pd) {
> +		dev_err(dev, "could not allocate memory for pdata\n");
> +		return -ENOMEM;
> +	}
> +
> +	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
> +
> +	/*
> +	 * ToDo: the 'wakeup' member in the platform data is more of a linux
> +	 * specfic information. Hence, there is no binding for that yet and
> +	 * not parsed here.
> +	 */
> +
> +	*pdata = pd;
> +	return 0;
> +}
> +#else
> +static int *max8997_i2c_parse_dt_pdata(struct device *dev
> +					struct max8997_platform_data **pdata)
It should be 'int' instead of 'int *'

It's helpful to compile without CONFIG_OF.

Thank you,
Kyungmin Park
> +{
> +	return 0;
> +}
> +#endif
> +
> +static struct of_device_id __devinitdata max8997_pmic_dt_match[];
> +static inline int max8997_i2c_get_driver_data(struct i2c_client *i2c,
> +						const struct i2c_device_id *id)
> +{
> +#ifdef CONFIG_OF
> +	if (i2c->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_node(max8997_pmic_dt_match, i2c->dev.of_node);
> +		return (int)match->data;
> +	}
> +#endif
> +	return (int)id->driver_data;
> +}
> +
>  static int max8997_i2c_probe(struct i2c_client *i2c,
>  			    const struct i2c_device_id *id)
>  {
> @@ -136,9 +191,16 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  	i2c_set_clientdata(i2c, max8997);
>  	max8997->dev = &i2c->dev;
>  	max8997->i2c = i2c;
> -	max8997->type = id->driver_data;
> +	max8997->type = max8997_i2c_get_driver_data(i2c, id);
>  	max8997->irq = i2c->irq;
>
> +	if (max8997->dev->of_node) {
> +		ret = max8997_i2c_parse_dt_pdata(max8997->dev, &pdata);
> +		if (ret)
> +			goto err;
> +		i2c->dev.platform_data = pdata;
> +	}
> +
>  	if (!pdata)
>  		goto err;
>
> @@ -428,11 +490,17 @@ const struct dev_pm_ops max8997_pm = {
>  	.restore = max8997_restore,
>  };
>
> +static struct of_device_id __devinitdata max8997_pmic_dt_match[] = {
> +	{ .compatible = "maxim,max8997-pmic", .data = TYPE_MAX8997 },
> +	{},
> +};
> +
>  static struct i2c_driver max8997_i2c_driver = {
>  	.driver = {
>  		   .name = "max8997",
>  		   .owner = THIS_MODULE,
>  		   .pm = &max8997_pm,
> +		   .of_match_table = of_match_ptr(max8997_pmic_dt_match),
>  	},
>  	.probe = max8997_i2c_probe,
>  	.remove = max8997_i2c_remove,
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index d26e864..a78695c 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -25,6 +25,7 @@
>  #include <linux/delay.h>
>  #include <linux/err.h>
>  #include <linux/gpio.h>
> +#include <linux/of_gpio.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> @@ -32,6 +33,7 @@
>  #include <linux/regulator/machine.h>
>  #include <linux/mfd/max8997.h>
>  #include <linux/mfd/max8997-private.h>
> +#include <linux/regulator/of_regulator.h>
>
>  struct max8997_data {
>  	struct device *dev;
> @@ -958,6 +960,137 @@ static struct regulator_desc regulators[] = {
>  	},
>  };
>
> +#if CONFIG_OF
> +static int max8997_pmic_dt_parse_dvs_gpio(struct max8997_dev *iodev,
> +			struct max8997_platform_data *pdata,
> +			struct device_node *pmic_np)
> +{
> +	int i, gpio;
> +
> +	for (i = 0; i < 3; i++) {
> +		gpio = of_get_named_gpio(pmic_np,
> +					"max8997,pmic-buck125-dvs-gpios", i);
> +		if (!gpio_is_valid(gpio)) {
> +			dev_err(iodev->dev, "invalid gpio[%d]: %d\n", i, gpio);
> +			return -EINVAL;
> +		}
> +		pdata->buck125_gpios[i] = gpio;
> +	}
> +	return 0;
> +}
> +
> +static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
> +					struct max8997_platform_data *pdata)
> +{
> +	struct device_node *pmic_np, *regulators_np, *reg_np;
> +	struct max8997_regulator_data *rdata;
> +	unsigned int i, ret;
> +
> +	pmic_np = iodev->dev->of_node;
> +	if (!pmic_np) {
> +		dev_err(iodev->dev, "could not find pmic sub-node\n");
> +		return -ENODEV;
> +	}
> +
> +	regulators_np = of_find_node_by_name(pmic_np, "regulators");
> +	if (!regulators_np) {
> +		dev_err(iodev->dev, "could not find regulators sub-node\n");
> +		return -EINVAL;
> +	}
> +
> +	/* count the number of regulators to be supported in pmic */
> +	pdata->num_regulators = 0;
> +	for_each_child_of_node(regulators_np, reg_np)
> +		pdata->num_regulators++;
> +
> +	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
> +				pdata->num_regulators, GFP_KERNEL);
> +	if (!rdata) {
> +		dev_err(iodev->dev, "could not allocate memory for "
> +						"regulator data\n");
> +		return -ENOMEM;
> +	}
> +
> +	pdata->regulators = rdata;
> +	for_each_child_of_node(regulators_np, reg_np) {
> +		for (i = 0; i < ARRAY_SIZE(regulators); i++)
> +			if (!of_node_cmp(reg_np->name, regulators[i].name))
> +				break;
> +		rdata->id = i;
> +		rdata->initdata = of_get_regulator_init_data(
> +						iodev->dev, reg_np);
> +		rdata++;
> +	}
> +
> +	if (of_get_property(pmic_np, "max8997,pmic-buck1-uses-gpio-dvs", NULL))
> +		pdata->buck1_gpiodvs = true;
> +
> +	if (of_get_property(pmic_np, "max8997,pmic-buck2-uses-gpio-dvs", NULL))
> +		pdata->buck2_gpiodvs = true;
> +
> +	if (of_get_property(pmic_np, "max8997,pmic-buck5-uses-gpio-dvs", NULL))
> +		pdata->buck5_gpiodvs = true;
> +
> +	if (pdata->buck1_gpiodvs) {
> +		if (of_property_read_u32_array(pmic_np,
> +				"max8997,pmic-buck1-dvs-voltage",
> +				pdata->buck1_voltage, 8)) {
> +			dev_err(iodev->dev, "buck1 voltages not specified\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (pdata->buck2_gpiodvs) {
> +		if (of_property_read_u32_array(pmic_np,
> +				"max8997,pmic-buck2-dvs-voltage",
> +				pdata->buck2_voltage, 8)) {
> +			dev_err(iodev->dev, "buck2 voltages not specified\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (pdata->buck5_gpiodvs) {
> +		if (of_property_read_u32_array(pmic_np,
> +				"max8997,pmic-buck5-dvs-voltage",
> +				pdata->buck5_voltage, 8)) {
> +			dev_err(iodev->dev, "buck5 voltages not specified\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (pdata->buck1_gpiodvs || pdata->buck2_gpiodvs ||
> +						pdata->buck5_gpiodvs) {
> +		ret = max8997_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);
> +		if (ret)
> +			return -EINVAL;
> +
> +		if (of_property_read_u32(pmic_np,
> +				"max8997,pmic-buck125-default-dvs-idx",
> +				&pdata->buck125_default_idx)) {
> +			pdata->buck125_default_idx = 0;
> +		} else {
> +			if (pdata->buck125_default_idx >= 8) {
> +				pdata->buck125_default_idx = 0;
> +				dev_info(iodev->dev, "invalid value for "
> +				"default dvs index, using 0 instead\n");
> +			}
> +		}
> +
> +		if (of_get_property(pmic_np,
> +			"max8997,pmic-ignore-gpiodvs-side-effect", NULL))
> +			pdata->ignore_gpiodvs_side_effect = true;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
> +					struct max8997_platform_data *pdata)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_OF */
> +
>  static __devinit int max8997_pmic_probe(struct platform_device *pdev)
>  {
>  	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> @@ -973,6 +1106,10 @@ static __devinit int max8997_pmic_probe(struct
> platform_device *pdev)
>  		return -ENODEV;
>  	}
>
> +	ret = max8997_pmic_dt_parse_pdata(iodev, pdata);
> +	if (ret)
> +		return ret;
> +
>  	max8997 = kzalloc(sizeof(struct max8997_data), GFP_KERNEL);
>  	if (!max8997)
>  		return -ENOMEM;
> --
> 1.6.6.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
