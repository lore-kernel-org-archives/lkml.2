Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2JTPuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 11:50:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43200 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2JTPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 11:50:49 -0400
Message-ID: <5082C8C8.80902@gmail.com>
Date: Sat, 20 Oct 2012 17:52:40 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
CC: lee.jones@linaro.org, arnd@arndb.de, anton.vorontsov@linaro.org,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH] mfd: ab8500: add devicetree support for fuelgauge
References: <1350358619-1160-1-git-send-email-rajanikanth.hv@stericsson.com>
In-Reply-To: <1350358619-1160-1-git-send-email-rajanikanth.hv@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rajanikanth,

On 10/16/2012 05:36 AM, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> - This patch adds device tree support for fuelgauge driver
> - optimize bm devices platform_data usage and of_probe(...)
>   Note: of_probe() routine for battery managed devices is made
>   common across all bm drivers.
> - test status:
>   - interrupt numbers assigned differs between legacy and FDT mode.
> 
> Legacy platform_data Mode:
> root@ME:/ cat /proc/interrupts
>            CPU0       CPU1
> 483:          0          0    ab8500  ab8500-ponkey-dbf
> 484:          0          0    ab8500  ab8500-ponkey-dbr
> 485:          0          0    ab8500  BATT_OVV
> 494:          0          1    ab8500
> 495:          0          0    ab8500  ab8500-rtc
> 501:          0         13    ab8500  NCONV_ACCU
> 503:          7         22    ab8500  CCEOC
> 504:          0          1    ab8500  CC_INT_CALIB
> 505:          0          0    ab8500  LOW_BAT_F
> 516:          0         34    ab8500  ab8500-gpadc
> 556:          0          0    ab8500  usb-link-status
> 
> FDT Mode:
> root@ME:/ cat /proc/interrupts
>            CPU0       CPU1
>   6:          0          0    ab8500  ab8500-ponkey-dbf
>   7:          0          0    ab8500  ab8500-ponkey-dbr
>   8:          0          0    ab8500  BATT_OVV
> 162:          0          7    ab8500  ab8500-gpadc
> 163:          0          1    ab8500
> 164:          0          0    ab8500  ab8500-rtc
> 484:          0          0    ab8500  usb-link-status
> 499:          0          4    ab8500  NCONV_ACCU
> 500:          0          0    ab8500  LOW_BAT_F
> 502:          0          1    ab8500  CC_INT_CALIB
> 503:          0          6    ab8500  CCEOC
> 
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
[...]
> +int __devinit
> +bmdevs_of_probe(struct device *dev,
> +		struct device_node *np,
> +		struct abx500_bm_data **battery)
> +{
> +	struct	abx500_battery_type *btype;
> +	struct  device_node *np_bat_supply;
> +	struct	abx500_bm_data *bat;
> +	int	i, thermistor;
> +	char	*bat_tech = "UNKNOWN";

This initialization is useless.

> +
> +	*battery = devm_kzalloc(dev, sizeof(*bat), GFP_KERNEL);
> +	if (!*battery) {
> +		dev_err(dev, "%s no mem for plat_data\n", __func__);
> +		return -ENOMEM;
> +	}
> +	*battery = &ab8500_bm_data;

Looks like dynamic allocation here is not what you need, since you are
overwriting the pointer to the allocated data.

> +
> +	/* get phandle to 'battery-info' node */
> +	np_bat_supply = of_parse_phandle(np, "battery", 0);
> +	if (!np_bat_supply) {
> +		dev_err(dev, "missing property battery\n");
> +		return -EINVAL;
> +	}
> +	if (of_property_read_bool(np_bat_supply,
> +			"thermistor-on-batctrl"))
> +		thermistor = NTC_INTERNAL;
> +	else
> +		thermistor = NTC_EXTERNAL;
> +
> +	bat = *battery;
> +	if (thermistor == NTC_EXTERNAL) {
> +		bat->n_btypes  = 4;
> +		bat->bat_type  = bat_type_ext_thermistor;
> +		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
> +	}
> +	bat_tech = (char *)of_get_property(
> +			np_bat_supply, "stericsson,battery-type", NULL);

No need to cast a void * to a char *.

> +	if (!bat_tech) {
> +		dev_warn(dev, "missing property battery-name/type\n");
> +		strncpy(bat_tech, "UNKNOWN", 7);

You are writing at a NULL pointer here...

> +	}
> +	of_node_put(np_bat_supply);

You can't call of_node_put here, because you are going to use bat_tech
later on. You have to call it at the end of this function, after you are
done with bat_tech.

> +
> +	if (strncmp(bat_tech, "LION", 4) == 0) {
> +		bat->no_maintenance  = true;
> +		bat->chg_unknown_bat = true;
> +		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
> +		bat->bat_type[BATTERY_UNKNOWN].termination_vol    = 4150;
> +		bat->bat_type[BATTERY_UNKNOWN].recharge_vol	  = 4130;
> +		bat->bat_type[BATTERY_UNKNOWN].normal_cur_lvl	  = 520;
> +		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl	  = 4200;
> +	}
> +	/* select the battery resolution table */
> +	for (i = 0; i < bat->n_btypes; ++i) {
> +		btype = (bat->bat_type + i);
> +		if (thermistor == NTC_EXTERNAL) {
> +			btype->batres_tbl =
> +				temp_to_batres_tbl_ext_thermistor;
> +		} else if (strncmp(bat_tech, "LION", 4) == 0) {
> +			btype->batres_tbl =
> +				temp_to_batres_tbl_9100;
> +		} else {
> +			btype->batres_tbl =
> +				temp_to_batres_tbl_thermistor;
> +		}
> +	}
> +	return 0;
> +}
[...]
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index bf02225..ff64dd4 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -22,15 +22,16 @@
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
>  #include <linux/kobject.h>
> -#include <linux/mfd/abx500/ab8500.h>
> -#include <linux/mfd/abx500.h>
>  #include <linux/slab.h>
> -#include <linux/mfd/abx500/ab8500-bm.h>
>  #include <linux/delay.h>
> -#include <linux/mfd/abx500/ab8500-gpadc.h>
> -#include <linux/mfd/abx500.h>
>  #include <linux/time.h>
> +#include <linux/of.h>
>  #include <linux/completion.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/abx500.h>
> +#include <linux/mfd/abx500/ab8500.h>
> +#include <linux/mfd/abx500/ab8500-bm.h>
> +#include <linux/mfd/abx500/ab8500-gpadc.h>
>  
>  #define MILLI_TO_MICRO			1000
>  #define FG_LSB_IN_MA			1627
> @@ -212,7 +213,6 @@ struct ab8500_fg {
>  	struct ab8500_fg_avg_cap avg_cap;
>  	struct ab8500 *parent;
>  	struct ab8500_gpadc *gpadc;
> -	struct abx500_fg_platform_data *pdata;
>  	struct abx500_bm_data *bat;
>  	struct power_supply fg_psy;
>  	struct workqueue_struct *fg_wq;
> @@ -2416,6 +2416,8 @@ static int __devexit ab8500_fg_remove(struct platform_device *pdev)
>  	int ret = 0;
>  	struct ab8500_fg *di = platform_get_drvdata(pdev);
>  
> +	of_node_put(pdev->dev.of_node);

This is wrong, the probe function doesn't increment the refcount of this
node, so you don't have to decrement it here.

> +
>  	list_del(&di->node);
>  
>  	/* Disable coulomb counter */
> @@ -2429,7 +2431,6 @@ static int __devexit ab8500_fg_remove(struct platform_device *pdev)
>  	flush_scheduled_work();
>  	power_supply_unregister(&di->fg_psy);
>  	platform_set_drvdata(pdev, NULL);
> -	kfree(di);
>  	return ret;
>  }
>  
> @@ -2442,21 +2443,44 @@ static struct ab8500_fg_interrupts ab8500_fg_irq[] = {
>  	{"CCEOC", ab8500_fg_cc_data_end_handler},
>  };
>  
> +char *supply_interface[] = {
> +	"ab8500_chargalg",
> +	"ab8500_usb",
> +};
> +
>  static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>  {
> +	struct device_node *np = pdev->dev.of_node;
> +	struct ab8500_fg *di;
>  	int i, irq;
>  	int ret = 0;
> -	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
> -	struct ab8500_fg *di;
>  
> -	if (!plat_data) {
> -		dev_err(&pdev->dev, "No platform data\n");
> -		return -EINVAL;
> +	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
> +	if (!di) {
> +		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
> +		if (np) {
> +			ret = -ENOMEM;
> +			goto release_node;

Here and below, release_node is wrong for the same reason as I wrote for
the remove function, you don't have to call of_node_put().

> +		}
> +	}
> +	di->bat = (struct abx500_bm_data *)
> +			pdev->mfd_cell->platform_data;

No need to cast a void *.

> +	if (!di->bat) {
> +		if (np) {
> +			ret = bmdevs_of_probe(&pdev->dev, np, &di->bat);
> +			if (ret) {
> +				dev_err(&pdev->dev,
> +					"failed to get battery information\n");
> +				goto release_node;
> +			}
> +		} else {
> +			dev_err(&pdev->dev, "missing dt node for ab8500_fg\n");
> +			ret = -EINVAL;
> +			goto release_node;
> +		}
> +	} else {
> +		dev_info(&pdev->dev, "falling back to legacy platform data\n");
>  	}
> -
> -	di = kzalloc(sizeof(*di), GFP_KERNEL);
> -	if (!di)
> -		return -ENOMEM;
>  
>  	mutex_init(&di->cc_lock);
>  
> @@ -2465,29 +2489,13 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>  	di->parent = dev_get_drvdata(pdev->dev.parent);
>  	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
>  
> -	/* get fg specific platform data */
> -	di->pdata = plat_data->fg;
> -	if (!di->pdata) {
> -		dev_err(di->dev, "no fg platform data supplied\n");
> -		ret = -EINVAL;
> -		goto free_device_info;
> -	}
> -
> -	/* get battery specific platform data */
> -	di->bat = plat_data->battery;
> -	if (!di->bat) {
> -		dev_err(di->dev, "no battery platform data supplied\n");
> -		ret = -EINVAL;
> -		goto free_device_info;
> -	}
> -
>  	di->fg_psy.name = "ab8500_fg";
>  	di->fg_psy.type = POWER_SUPPLY_TYPE_BATTERY;
>  	di->fg_psy.properties = ab8500_fg_props;
>  	di->fg_psy.num_properties = ARRAY_SIZE(ab8500_fg_props);
>  	di->fg_psy.get_property = ab8500_fg_get_property;
> -	di->fg_psy.supplied_to = di->pdata->supplied_to;
> -	di->fg_psy.num_supplicants = di->pdata->num_supplicants;
> +	di->fg_psy.supplied_to = supply_interface;
> +	di->fg_psy.num_supplicants = ARRAY_SIZE(supply_interface),
>  	di->fg_psy.external_power_changed = ab8500_fg_external_power_changed;
>  
>  	di->bat_cap.max_mah_design = MILLI_TO_MICRO *
> @@ -2506,7 +2514,8 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>  	di->fg_wq = create_singlethread_workqueue("ab8500_fg_wq");
>  	if (di->fg_wq == NULL) {
>  		dev_err(di->dev, "failed to create work queue\n");
> -		goto free_device_info;
> +		ret = -ENOMEM;
> +		goto release_node;
>  	}
>  
>  	/* Init work for running the fg algorithm instantly */
> @@ -2605,12 +2614,17 @@ free_irq:
>  	}
>  free_inst_curr_wq:
>  	destroy_workqueue(di->fg_wq);
> -free_device_info:
> -	kfree(di);
>  
> +release_node:
> +	of_node_put(np);
>  	return ret;
>  }

--
Francesco
