Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab2EIGQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:16:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35272 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab2EIGQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:16:09 -0400
Message-ID: <4FAA0BA1.5080004@gmail.com>
Date: Wed, 09 May 2012 16:16:01 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jenny TC <jenny.tc@intel.com>
CC: cbouatmailru@gmail.com, anton.vorontsov@linaro.org,
        linux-kernel@vger.kernel.org, durgadoss.r@intel.com
Subject: Re: [PATCH] power_supply: Register battery as a thermal zone
References: <1336562318-16096-1-git-send-email-jenny.tc@intel.com>
In-Reply-To: <1336562318-16096-1-git-send-email-jenny.tc@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/12 21:18, Jenny TC wrote:

> Battery and charger contribute to Thermals in most of the embedded
> devices. So, it makes sense to identify them as Thermal zones in a
> particular platform.
> 
> This patch registers a thermal zone if the power supply is reporting
> a temperature property. The thermal zone will be used by platform's
> thermal management solution.
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---

> +#ifdef CONFIG_THERMAL
> +static int power_supply_read_temp(struct thermal_zone_device *tzd,
> +		unsigned long *temp)
> +{
> +	struct power_supply *psy;
> +	union power_supply_propval val;
> +	int ret;
> +
> +	WARN_ON(tzd == NULL);
> +	psy = tzd->devdata;
> +	WARN_ON(psy == NULL);


These WARN_ONs seem unnecessary since you will oops if either of them
are NULL anyway.

> +	ret = psy->get_property(psy,
> +				  POWER_SUPPLY_PROP_TEMP, &val);
> +	if (!ret)
> +		*temp = val.intval * 100;
> +	return ret;
> +}


<snip>

>  int power_supply_register(struct device *parent, struct power_supply *psy)
>  {
>  	struct device *dev;
>  	int rc;
> +#ifdef CONFIG_THERMAL
> +	int i;
> +#endif
>  
>  	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>  	if (!dev)
> @@ -196,7 +223,21 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
>  	rc = device_add(dev);
>  	if (rc)
>  		goto device_add_failed;
> -
> +#ifdef CONFIG_THERMAL
> +	/* Register battery zone device psy reports temperature */
> +	for (i = 0; i < psy->num_properties; i++) {
> +		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
> +			psy->tzd = thermal_zone_device_register(
> +					(char *)psy->name, 0, psy,
> +					&psy_tzd_ops, 0, 0, 0, 0);
> +			if (IS_ERR(psy->tzd)) {
> +				rc = PTR_ERR(psy->tzd);
> +				goto therm_zone_reg_failed;
> +			}
> +			break;
> +		}
> +	}
> +#endif


This would be better moved into its own function, so you can minimise
the amount of ifdefs needed. Having extra ifdefs for variable
declarations and exit paths is especially ugly :-/. Ideally you can have
a single #ifdef CONFIG_THERMAL block, and define empty functions for the
!CONFIG_THERMAL case.

~Ryan
