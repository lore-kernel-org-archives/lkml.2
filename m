Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1BPWet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:34:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58493 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1BPWer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yc/JQIWRC00f7jnbQ0EnwvAWflLU9X7B39W7mb+FtzU12xqRqlgXwJPlxFaf/JG5DQ
         vjohbzVi1M6NFVw1Ga5h61zdWbOlzHP35XKJt4wIk4uRPSyDkXJPQ6f1kFW7PAnrgS1h
         3yR1J7zB7wMcM9aayHHjgGhrVefVBvDg2SKqY=
Date: Wed, 16 Feb 2011 14:34:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net
Subject: Re: [PATCH v3] olpc_battery: convert to platform device
Message-ID: <20110216223436.GA16004@core.coreip.homeip.net>
References: <20110216222820.487AE9D401C@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216222820.487AE9D401C@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 10:28:20PM +0000, Daniel Drake wrote:
> This is needed so that suspend/resume (wakeup) support can be added.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/platform/olpc/olpc.c |   15 +++++++++++
>  drivers/power/olpc_battery.c  |   53 +++++++++++++++++++++++-----------------
>  2 files changed, 45 insertions(+), 23 deletions(-)
> 
> v2: add MODULE_ALIAS thanks to Dmitry Torokhov
> 
> v3: fix __devexit annotation thanks to Dmitry
> 

Looks good to me, thank you for making the changes.

Reviewed-by: Dmitry Torohkov <dtor@mail.ru>

> diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
> index edaf3fe..a5fb933 100644
> --- a/arch/x86/platform/olpc/olpc.c
> +++ b/arch/x86/platform/olpc/olpc.c
> @@ -239,6 +239,17 @@ static int __init add_xo1_platform_devices(void)
>  	return 0;
>  }
>  
> +static int __init add_common_platform_devices(void)
> +{
> +	struct platform_device *pdev;
> +
> +	pdev = platform_device_register_simple("olpc-battery", -1, NULL, 0);
> +	if (IS_ERR(pdev))
> +		return PTR_ERR(pdev);
> +
> +	return 0;
> +}
> +
>  static int __init olpc_init(void)
>  {
>  	int r = 0;
> @@ -269,6 +280,10 @@ static int __init olpc_init(void)
>  			olpc_platform_info.boardrev >> 4,
>  			olpc_platform_info.ecver);
>  
> +	r = add_common_platform_devices();
> +	if (r)
> +		return r;
> +
>  	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0)) { /* XO-1 */
>  		r = add_xo1_platform_devices();
>  		if (r)
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index 0b0ff3a..18580b4 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -519,8 +519,6 @@ static struct device_attribute olpc_bat_error = {
>   *		Initialisation
>   *********************************************************************/
>  
> -static struct platform_device *bat_pdev;
> -
>  static struct power_supply olpc_bat = {
>  	.get_property = olpc_bat_get_property,
>  	.use_for_apm = 1,
> @@ -534,14 +532,11 @@ void olpc_battery_trigger_uevent(unsigned long cause)
>  		kobject_uevent(&olpc_bat.dev->kobj, KOBJ_CHANGE);
>  }
>  
> -static int __init olpc_bat_init(void)
> +static int __devinit olpc_battery_probe(struct platform_device *pdev)
>  {
> -	int ret = 0;
> +	int ret;
>  	uint8_t status;
>  
> -	if (!olpc_platform_info.ecver)
> -		return -ENXIO;
> -
>  	/*
>  	 * We've seen a number of EC protocol changes; this driver requires
>  	 * the latest EC protocol, supported by 0x44 and above.
> @@ -552,21 +547,16 @@ static int __init olpc_bat_init(void)
>  		return -ENXIO;
>  	}
>  
> +	/* Ignore the status. It doesn't actually matter */
>  	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &status, 1);
>  	if (ret)
>  		return ret;
>  
> -	/* Ignore the status. It doesn't actually matter */
> -
> -	bat_pdev = platform_device_register_simple("olpc-battery", 0, NULL, 0);
> -	if (IS_ERR(bat_pdev))
> -		return PTR_ERR(bat_pdev);
> -
> -	ret = power_supply_register(&bat_pdev->dev, &olpc_ac);
> +	ret = power_supply_register(&pdev->dev, &olpc_ac);
>  	if (ret)
> -		goto ac_failed;
> +		return ret;
>  
> -	olpc_bat.name = bat_pdev->name;
> +	olpc_bat.name = pdev->name;
>  	if (olpc_board_at_least(olpc_board_pre(0xd0))) { /* XO-1.5 */
>  		olpc_bat.properties = olpc_xo15_bat_props;
>  		olpc_bat.num_properties = ARRAY_SIZE(olpc_xo15_bat_props);
> @@ -575,7 +565,7 @@ static int __init olpc_bat_init(void)
>  		olpc_bat.num_properties = ARRAY_SIZE(olpc_xo1_bat_props);
>  	}
>  
> -	ret = power_supply_register(&bat_pdev->dev, &olpc_bat);
> +	ret = power_supply_register(&pdev->dev, &olpc_bat);
>  	if (ret)
>  		goto battery_failed;
>  
> @@ -587,7 +577,7 @@ static int __init olpc_bat_init(void)
>  	if (ret)
>  		goto error_failed;
>  
> -	goto success;
> +	return 0;
>  
>  error_failed:
>  	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
> @@ -595,19 +585,35 @@ eeprom_failed:
>  	power_supply_unregister(&olpc_bat);
>  battery_failed:
>  	power_supply_unregister(&olpc_ac);
> -ac_failed:
> -	platform_device_unregister(bat_pdev);
> -success:
>  	return ret;
>  }
>  
> -static void __exit olpc_bat_exit(void)
> +static int __devexit olpc_battery_remove(struct platform_device *pdev)
>  {
>  	device_remove_file(olpc_bat.dev, &olpc_bat_error);
>  	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
>  	power_supply_unregister(&olpc_bat);
>  	power_supply_unregister(&olpc_ac);
> -	platform_device_unregister(bat_pdev);
> +	return 0;
> +}
> +
> +static struct platform_driver olpc_battery_drv = {
> +	.driver = {
> +		.name = "olpc-battery",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = olpc_battery_probe,
> +	.remove = __devexit_p(olpc_battery_remove),
> +};
> +
> +static int __init olpc_bat_init(void)
> +{
> +	return platform_driver_register(&olpc_battery_drv);
> +}
> +
> +static void __exit olpc_bat_exit(void)
> +{
> +	platform_driver_unregister(&olpc_battery_drv);
>  }
>  
>  module_init(olpc_bat_init);
> @@ -616,3 +622,4 @@ module_exit(olpc_bat_exit);
>  MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("Battery driver for One Laptop Per Child 'XO' machine");
> +MODULE_ALIAS("platform:olpc-battery");
> -- 
> 1.7.4
> 

-- 
Dmitry
