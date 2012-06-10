Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab2FJEPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 00:15:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:31077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab2FJEPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 00:15:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154267248"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: RE: [PATCHv2] power_supply: Register battery as a thermal zone
Thread-Topic: [PATCHv2] power_supply: Register battery as a thermal zone
Thread-Index: Ac1GvmoNA4wiBYEMTWeEBMlVOOTaTg==
Date: Sun, 10 Jun 2012 04:15:25 +0000
Message-ID: <20ADAB092842284E95860F279283C56425D17E@BGSMSX101.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Ping..
Could you please review/merge this patch ?

Thanks,
-jtc

> -----Original Message-----
> From: Tc, Jenny
> Sent: Wednesday, May 09, 2012 8:37 PM
> To: cbouatmailru@gmail.com; anton.vorontsov@linaro.org
> Cc: linux-kernel@vger.kernel.org; R, Durgadoss; Tc, Jenny
> Subject: [PATCHv2] power_supply: Register battery as a thermal zone
> 
> Battery and charger contribute to Thermals in most of the embedded
> devices. So, it makes sense to identify them as Thermal zones in a particular
> platform.
> 
> This patch registers a thermal zone if the power supply is reporting a
> temperature property. The thermal zone will be used by platform's thermal
> management solution.
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
> v1
>  * Made initial code changes
> v2
>  * Removed unnecessary WARN_ON's
>  * Consolidated all #ifdef CONFIG_THERMAL in one place
>  drivers/power/power_supply_core.c |   59
> +++++++++++++++++++++++++++++++++++++
>  include/linux/power_supply.h      |    3 ++
>  2 files changed, 62 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/power_supply_core.c
> b/drivers/power/power_supply_core.c
> index 6ad6127..8e01432 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -17,6 +17,7 @@
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/power_supply.h>
> +#include <linux/thermal.h>
>  #include "power_supply.h"
> 
>  /* exported for the APM Power driver, APM emulation */ @@ -169,6
> +170,53 @@ static void power_supply_dev_release(struct device *dev)
>  	kfree(dev);
>  }
> 
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
> +	ret = psy->get_property(psy,
> +				  POWER_SUPPLY_PROP_TEMP, &val);
> +
> +	/* Convert tenths of degree Celsius to milli degree Celsius*/
> +	if (!ret)
> +		*temp = val.intval * 100;
> +
> +	return ret;
> +}
> +
> +static struct thermal_zone_device_ops psy_tzd_ops = {
> +	.get_temp = power_supply_read_temp,
> +};
> +
> +static int register_thermal(struct power_supply *psy) {
> +	int i;
> +	/* Register battery zone device psy reports temperature */
> +	for (i = 0; i < psy->num_properties; i++) {
> +		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
> +			psy->tzd = thermal_zone_device_register(
> +					(char *)psy->name, 0, psy,
> +					&psy_tzd_ops, 0, 0, 0, 0);
> +			if (IS_ERR(psy->tzd))
> +				return PTR_ERR(psy->tzd);
> +			break;
> +		}
> +	}
> +	return 0;
> +}
> +#else
> +static int register_thermal(struct power_supply *psy) {
> +	return 0;
> +}
> +#endif
> +
>  int power_supply_register(struct device *parent, struct power_supply *psy)
> {
>  	struct device *dev;
> @@ -197,6 +245,10 @@ int power_supply_register(struct device *parent,
> struct power_supply *psy)
>  	if (rc)
>  		goto device_add_failed;
> 
> +	rc = register_thermal(psy);
> +	if (rc)
> +		goto therm_zone_reg_failed;
> +
>  	rc = power_supply_create_triggers(psy);
>  	if (rc)
>  		goto create_triggers_failed;
> @@ -206,6 +258,9 @@ int power_supply_register(struct device *parent,
> struct power_supply *psy)
>  	goto success;
> 
>  create_triggers_failed:
> +	if (psy->tzd)
> +		thermal_zone_device_unregister(psy->tzd);
> +therm_zone_reg_failed:
>  	device_del(dev);
>  kobject_set_name_failed:
>  device_add_failed:
> @@ -220,6 +275,10 @@ void power_supply_unregister(struct power_supply
> *psy)
>  	cancel_work_sync(&psy->changed_work);
>  	sysfs_remove_link(&psy->dev->kobj, "powers");
>  	power_supply_remove_triggers(psy);
> +#ifdef CONFIG_THERMAL
> +	if (psy->tzd)
> +		thermal_zone_device_unregister(psy->tzd);
> +#endif
>  	device_unregister(psy->dev);
>  }
>  EXPORT_SYMBOL_GPL(power_supply_unregister);
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index c38c13d..1f58435 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -172,6 +172,9 @@ struct power_supply {
>  	/* private */
>  	struct device *dev;
>  	struct work_struct changed_work;
> +#ifdef CONFIG_THERMAL
> +	struct thermal_zone_device *tzd;
> +#endif
> 
>  #ifdef CONFIG_LEDS_TRIGGERS
>  	struct led_trigger *charging_full_trig;
> --
> 1.7.1

