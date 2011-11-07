Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab1KGG1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:27:54 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:46524 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755315Ab1KGG1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:27:52 -0500
Message-ID: <4EB77A60.5050704@ti.com>
Date: Mon, 07 Nov 2011 11:57:44 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] regulator: adapt fixed regulator driver to dt
References: <1319702185-16108-1-git-send-email-rnayak@ti.com> <1319702185-16108-3-git-send-email-rnayak@ti.com> <20111104203422.GB3918@quad.lixom.net>
In-Reply-To: <20111104203422.GB3918@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> +- regulator-fixed-gpio: gpio to use for enable control
>> +- regulator-fixed-startup-delay: startup time in microseconds
>
> startup-delay-ms ?

ok.

>
>> +- regulator-fixed-enable-high: Polarity of enable GPIO,
>> +  1 = Active High, 0 = Active low
>
> Some gpio specifiers allow you to specify active high or low flags, but either
> way something like "enable-active-low" as a property (with active high as
> default if property is missing) is a more devicetreey convention.
>
>> +- regulator-fixed-enabled-at-boot: 1 = yes, 0 = no
>
> Same here, you can drop the prefix. Also, the regular regulators use
> "regulator-name" for the supply name, it would make sense to reuse the same
> naming here, right?

yes, will do these changes.

>
>> +
>> +Example:
>> +
>> +	abc: fixedregulator@0 {
>> +		compatible = "regulator-fixed";
>> +		regulator-fixed-supply = "fixed-supply";
>> +		regulator-fixed-microvolts =<1800000>;
>> +		regulator-fixed-gpio =<43>;
>
> This is not a valid gpio specifier.

right. will fix.
>
>> +		regulator-fixed-startup-delay =<70000>;
>> +		regulator-fixed-enable-high;
>> +		regulator-fixed-enabled-at-boot;
>> +	};
>> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
>> index 2fe9d99..9851b42 100644
>> --- a/drivers/regulator/fixed.c
>> +++ b/drivers/regulator/fixed.c
>> @@ -26,6 +26,9 @@
>>   #include<linux/gpio.h>
>>   #include<linux/delay.h>
>>   #include<linux/slab.h>
>> +#include<linux/of.h>
>> +#include<linux/regulator/of_regulator.h>
>> +#include<linux/regulator/machine.h>
>>
>>   struct fixed_voltage_data {
>>   	struct regulator_desc desc;
>> @@ -37,6 +40,46 @@ struct fixed_voltage_data {
>>   	bool is_enabled;
>>   };
>>
>> +
>> +/**
>> + * of_get_fixed_voltage_config - extract fixed_voltage_config structure info
>> + * @dev: device requesting for fixed_voltage_config
>> + *
>> + * Populates fixed_voltage_config structure by extracting data from device
>> + * tree node, returns a pointer to the populated structure of NULL if memory
>> + * alloc fails.
>> + */
>> +struct fixed_voltage_config *of_get_fixed_voltage_config(struct device *dev)
>> +{
>> +	struct fixed_voltage_config *config;
>> +	struct device_node *np = dev->of_node;
>> +	const __be32 *microvolts, *gpio, *delay;
>> +
>> +	config = devm_kzalloc(dev, sizeof(struct fixed_voltage_config), GFP_KERNEL);
>> +	if (!config)
>> +		return NULL;
>> +
>> +	config->supply_name = of_get_property(np, "regulator-fixed-supply", NULL);
>> +	microvolts = of_get_property(np, "regulator-fixed-microvolts", NULL);
>> +	if (microvolts)
>> +		config->microvolts = be32_to_cpu(*microvolts);
>> +	gpio = of_get_property(np, "regulator-fixed-gpio", NULL);
>> +	if (gpio)
>> +		config->gpio = be32_to_cpu(*gpio);
>
> This needs to be fixed to parse a gpio properly instead.

yes, will use of_get_gpio() here.

>
>
>
> -Olof

