Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3AFCx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 21:53:59 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:45742 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3AFCxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 21:53:55 -0500
Date: Sat, 5 Jan 2013 18:50:24 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org, Jenny TC <jenny.tc@intel.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] power_supply: Add charge control struct in power
 supply class
Message-ID: <20130106025024.GC6919@lizard.sbx05280.losalca.wayport.net>
References: <1354002423-24587-1-git-send-email-ramakrishna.pallala@intel.com>
 <1354002423-24587-2-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354002423-24587-2-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 01:17:02PM +0530, Ramakrishna Pallala wrote:
[...]
> +++ b/drivers/power/power_supply_core.c
> @@ -158,6 +158,24 @@ struct power_supply *power_supply_get_by_name(char *name)
>  }
>  EXPORT_SYMBOL_GPL(power_supply_get_by_name);
>  
> +#ifdef CONFIG_PSY_CM_LOW_LEVEL_SUPPORT
> +struct power_supply_charger_control
> +		*power_supply_get_chrg_cntl_by_name(const char *name)
> +{
> +	struct device *dev = class_find_device(power_supply_class, NULL,
> +			(char *)name, power_supply_match_device_by_name);
> +
> +	return dev ? ((struct power_supply *)dev_get_drvdata(dev))->chrg_cntl : NULL;
> +}
> +#else
> +struct power_supply_charger_control
> +		*power_supply_get_chrg_cntl_by_name(const char *name)
> +{
> +	return NULL;
> +}
> +#endif
> +EXPORT_SYMBOL_GPL(power_supply_get_chrg_cntl_by_name);

>  int power_supply_powers(struct power_supply *psy, struct device *dev)
>  {
>  	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 1f0ab90..35cdf2c 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -191,6 +191,10 @@ struct power_supply {
>  	struct thermal_cooling_device *tcd;
>  #endif
>  
> +#ifdef CONFIG_PSY_CM_LOW_LEVEL_SUPPORT
> +	struct power_supply_charger_control *chrg_cntl;
> +#endif
> +
>  #ifdef CONFIG_LEDS_TRIGGERS
>  	struct led_trigger *charging_full_trig;
>  	char *charging_full_trig_name;
> @@ -224,7 +228,29 @@ struct power_supply_info {
>  	int use_for_apm;
>  };
>  
> +struct power_supply_charger_control {
> +	const char *name;
> +	/* get charging status */
> +	int (*is_charging_enabled)(void);
> +	int (*is_charger_enabled)(void);
> +
> +	/* set charging parameters */
> +	int (*set_in_current_limit)(int uA);
> +	int (*set_charge_current)(int uA);
> +	int (*set_charge_voltage)(int uV);
> +
> +	/* control battery charging */
> +	int (*enable_charging)(void);
> +	int (*disable_charging)(void);
> +
> +	/* control VSYS or system supply */
> +	int (*turnon_charger)(void);
> +	int (*turnoff_charger)(void);
> +};
> +

I'm all for this patch, but why do you need to place it into
power_supply.h and power_supply_core.c? :) I see nothing generic here,
it's pure charger-manager stuff. So, place everything into
charger-manager.{c,h}.

You can still add this:

> +#ifdef CONFIG_PSY_CM_LOW_LEVEL_SUPPORT
> +	struct power_supply_charger_control *chrg_cntl;
> +#endif

to power_supply.h, of course. It's OK.

>  extern struct power_supply *power_supply_get_by_name(char *name);
> +extern struct power_supply_charger_control
> +		*power_supply_get_chrg_cntl_by_name(const char *name);
>  extern void power_supply_changed(struct power_supply *psy);
>  extern int power_supply_am_i_supplied(struct power_supply *psy);
>  extern int power_supply_set_battery_charged(struct power_supply *psy);
> -- 
> 1.7.0.4
