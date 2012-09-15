Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2IOLAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 07:00:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60367 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2IOLAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 07:00:33 -0400
Message-ID: <5054600C.8000901@gmail.com>
Date: Sat, 15 Sep 2012 13:01:32 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rajanikanth HV <rajanikanth.hv@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Patch Tracking <patches@linaro.org>
Subject: Re: mfd: Implement devicetree support for AB8500 Btemp
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com>
In-Reply-To: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 01:21 PM, Rajanikanth HV wrote:
...
> -static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
> +static int __devinit
> +btemp_of_probe(struct device *dev,
> +		struct device_node *np,
> +		struct abx500_bm_plat_data *bm_pdata)
>  {
> -	int irq, i, ret = 0;
> -	u8 val;
> -	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
> -	struct ab8500_btemp *di;
> -
> -	if (!plat_data) {
> -		dev_err(&pdev->dev, "No platform data\n");
> -		return -EINVAL;
> +	u8	val;
> +	u32	pval;
> +	int	i;
> +	int	ext_thermister, lion_battery, ret = 0;
> +	const char *bm_dev_name;
> +	struct	abx500_btemp_platform_data *btemp = bm_pdata->btemp;
> +	struct	abx500_bm_data		   *bat;
> +	struct	abx500_battery_type	   *btype;
> +
> +	ret = of_property_read_u32(np, "num_supplicants", &pval);
> +	if (ret) {
> +		dev_err(dev, "missing property num_supplicants\n");
> +		ret = -EINVAL;
> +		goto inval_pval;
>  	}
> -
> -	di = kzalloc(sizeof(*di), GFP_KERNEL);
> -	if (!di)
> -		return -ENOMEM;
> -
> -	/* get parent data */
> -	di->dev = &pdev->dev;
> -	di->parent = dev_get_drvdata(pdev->dev.parent);
> -	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
> -
> -	/* get btemp specific platform data */
> -	di->pdata = plat_data->btemp;
> -	if (!di->pdata) {
> -		dev_err(di->dev, "no btemp platform data supplied\n");
> +	btemp->num_supplicants = pval;
> +	btemp->supplied_to =
> +		devm_kzalloc(dev, btemp->num_supplicants *
> +			sizeof(const char *), GFP_KERNEL);
> +	if (btemp->supplied_to == NULL) {
> +		dev_err(dev, "%s no mem for supplied_to\n", __func__);
> +		ret = -ENOMEM;
> +		goto inval_pval;
> +	}
> +	for (val = 0; val < btemp->num_supplicants; ++val)
> +		if (of_property_read_string_index
> +			(np, "supplied_to", val, &bm_dev_name) == 0)
> +			*(btemp->supplied_to + val) = (char *)bm_dev_name;
> +		else {
> +			dev_err(dev, "insufficient number of supplied_to data found\n");
> +			ret = -EINVAL;
> +			goto free_dev_mem;
> +		}
> +	ret = of_property_read_u32(np, "thermister_on_batctrl", &pval);
> +	if (ret) {
> +		dev_err(dev, "missing property thermister_on_batctrl\n");
>  		ret = -EINVAL;
> -		goto free_device_info;
> +		goto free_dev_mem;
> +	}
> +	bm_pdata->battery = &ab8500_bm_data;
> +	bat = bm_pdata->battery;
> +	ext_thermister = 0;
> +	if (pval == 0) {
> +		bat->n_btypes = 4;
> +		bat->bat_type = bat_type_ext_thermister;
> +		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
> +		ext_thermister = 1;
> +	}
> +	ret = of_property_read_u32(np, "li_ion_9100", &pval);
> +	if (ret) {
> +		dev_err(dev, "missing property li_ion_9100\n");
> +		ret = -EINVAL;
> +		goto free_dev_mem;
> +	}
> +	lion_battery = 0;
> +	if (pval == 1) {
> +		bat->no_maintenance = true;
> +		bat->chg_unknown_bat = true;
> +		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
> +		bat->bat_type[BATTERY_UNKNOWN].termination_vol = 4150;
> +		bat->bat_type[BATTERY_UNKNOWN].recharge_vol = 4130;
> +		bat->bat_type[BATTERY_UNKNOWN].normal_cur_lvl = 520;
> +		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl = 4200;
> +		lion_battery = 1;
> +	}
> +	/* select the battery resolution table */
> +	for (i = 0; i < bat->n_btypes; ++i) {
> +		btype = (bat->bat_type + i);
> +		if (ext_thermister) {
> +			btype->batres_tbl =
> +				temp_to_batres_tbl_ext_thermister;
> +		} else if (lion_battery) {
> +			btype->batres_tbl =
> +				temp_to_batres_tbl_9100;
> +		} else {
> +			btype->batres_tbl =
> +				temp_to_batres_tbl_thermister;
> +		}
> +	}
> +	return ret;
> +free_dev_mem:
> +	devm_kfree(dev, btemp->supplied_to);
> +inval_pval:
> +	return ret;
> +}
> +
> +static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
> +{
> +	u8	val;
> +	int	i;
> +	int	irq, ret = 0;
> +	struct	abx500_bm_plat_data *pdata = pdev->dev.platform_data;
> +	struct	device_node	*np = pdev->dev.of_node;
> +	struct	ab8500_btemp	*di;
> +
> +	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
> +	if (!di) {
> +		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
> +		ret = -ENOMEM;
>  	}
> 
> -	/* get battery specific platform data */
> -	di->bat = plat_data->battery;
> -	if (!di->bat) {
> -		dev_err(di->dev, "no battery platform data supplied\n");
> +	if (np) {
> +		if (!pdata) {
> +			pdata =
> +			devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +			if (!pdata) {
> +				dev_err(&pdev->dev,
> +					"%s no mem for pdata\n", __func__);
> +				ret = -ENOMEM;
> +				goto err_no_mem;
> +			}
> +			pdata->btemp = devm_kzalloc(&pdev->dev,
> +					sizeof(*pdata->btemp), GFP_KERNEL);
> +			if (!pdata->btemp) {
> +				devm_kfree(&pdev->dev, pdata);
> +				dev_err(&pdev->dev,
> +					"%s no mem for pdata->btemp\n",
> +					__func__);
> +				ret = -ENOMEM;
> +				goto free_device_info;
> +			}
> +		}
> +		/* get battery specific platform data */
> +		ret = btemp_of_probe(&pdev->dev, np, pdata);
> +		if (ret) {
> +			devm_kfree(&pdev->dev, pdata->btemp);
> +			devm_kfree(&pdev->dev, pdata);
> +			goto free_device_info;
> +		}
> +	}
> +	if (!pdata) {
> +		dev_err(&pdev->dev,
> +			"%s no btemp platform data found\n", __func__);
>  		ret = -EINVAL;
>  		goto free_device_info;
>  	}
> +	di->pdata = pdata->btemp;
> +	di->bat = pdata->battery;
> +	/* get parent data */
> +	di->dev = &pdev->dev;
> +	di->parent = dev_get_drvdata(pdev->dev.parent);
> +	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
> 
>  	/* BTEMP supply */
>  	di->btemp_psy.name = "ab8500_btemp";
> @@ -1008,7 +1121,6 @@ static int __devinit ab8500_btemp_probe(struct
> platform_device *pdev)
>  	di->btemp_psy.external_power_changed =
>  		ab8500_btemp_external_power_changed;
> 
> -
>  	/* Create a work queue for the btemp */
>  	di->btemp_wq =
>  		create_singlethread_workqueue("ab8500_btemp_wq");
> @@ -1065,7 +1177,7 @@ static int __devinit ab8500_btemp_probe(struct
> platform_device *pdev)
>  			IRQF_SHARED | IRQF_NO_SUSPEND,
>  			ab8500_btemp_irq[i].name, di);
> 
> -		if (ret) {
> +		if (ret < 0) {
>  			dev_err(di->dev, "failed to request %s IRQ %d: %d\n"
>  				, ab8500_btemp_irq[i].name, irq, ret);
>  			goto free_irq;
> @@ -1093,11 +1205,17 @@ free_irq:
>  free_btemp_wq:
>  	destroy_workqueue(di->btemp_wq);
>  free_device_info:
> -	kfree(di);
> +	devm_kfree(&pdev->dev, di);
> +err_no_mem:
> 
>  	return ret;
>  }

Same story as in fg driver, there is no need to call devm_kfree() on
error in probe functions, and kfree(di) should be removed from
ab8500_btemp_remove()

--
Francesco
