Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab0EDQvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:51:13 -0400
Received: from bamako.nerim.net ([62.4.17.28]:58207 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0EDQvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:51:12 -0400
Date: Tue, 4 May 2010 18:51:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwmon: applesmc: Correct sysfs fan error handling
Message-ID: <20100504185108.01fe2124@hyperion.delvare>
In-Reply-To: <1272980343-3880-1-git-send-email-rydberg@euromail.se>
References: <1272980343-3880-1-git-send-email-rydberg@euromail.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 May 2010 15:39:02 +0200, Henrik Rydberg wrote:
> The current code will not remove the sysfs files for fan numbers three
> and up. Also, upon exit, fans one and two are removed regardless of
> their existence.  This patch cleans up the sysfs error handling for
> the fans.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |   61 +++++++++++++++++++---------------------------
>  1 files changed, 25 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 36a0d62..57c0331 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -209,6 +209,9 @@ static unsigned int applesmc_accelerometer;
>  /* Indicates whether this computer has light sensors and keyboard backlight. */
>  static unsigned int applesmc_light;
>  
> +/* The number of fans handled by the driver */
> +static unsigned int fans_handled;
> +
>  /* Indicates which temperature sensors set to use. */
>  static unsigned int applesmc_temperature_set;
>  
> @@ -1530,39 +1533,24 @@ static int __init applesmc_init(void)
>  
>  	/* create fan files */
>  	count = applesmc_get_fan_count();
> -	if (count < 0) {
> +	if (count < 0)
>  		printk(KERN_ERR "applesmc: Cannot get the number of fans.\n");
> -	} else {
> +	else
>  		printk(KERN_INFO "applesmc: %d fans found.\n", count);
>  
> -		switch (count) {
> -		default:
> -			printk(KERN_WARNING "applesmc: More than 4 fans found,"
> -					" but at most 4 fans are supported"
> -						" by the driver.\n");
> -		case 4:
> -			ret = sysfs_create_group(&pdev->dev.kobj,
> -						 &fan_attribute_groups[3]);
> -			if (ret)
> -				goto out_key_enumeration;
> -		case 3:
> -			ret = sysfs_create_group(&pdev->dev.kobj,
> -						 &fan_attribute_groups[2]);
> -			if (ret)
> -				goto out_key_enumeration;
> -		case 2:
> -			ret = sysfs_create_group(&pdev->dev.kobj,
> -						 &fan_attribute_groups[1]);
> -			if (ret)
> -				goto out_key_enumeration;
> -		case 1:
> -			ret = sysfs_create_group(&pdev->dev.kobj,
> -						 &fan_attribute_groups[0]);
> -			if (ret)
> -				goto out_fan_1;
> -		case 0:
> -			;
> -		}
> +	if (count > 4) {
> +		count = 4;
> +		printk(KERN_WARNING "applesmc: More than 4 fans found,"
> +		       " but at most 4 fans are supported"
> +		       " by the driver.\n");
> +	}
> +
> +	while (fans_handled < count) {
> +		ret = sysfs_create_group(&pdev->dev.kobj,
> +					 &fan_attribute_groups[fans_handled]);
> +		if (ret)
> +			goto out_fans;
> +		fans_handled++;
>  	}
>  
>  	for (i = 0;
> @@ -1631,10 +1619,10 @@ out_accelerometer:
>  		applesmc_release_accelerometer();
>  out_temperature:
>  	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
> -	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
> -out_fan_1:
> -	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
> -out_key_enumeration:
> +out_fans:
> +	while (fans_handled)
> +		sysfs_remove_group(&pdev->dev.kobj,
> +				   &fan_attribute_groups[--fans_handled]);
>  	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
>  out_name:
>  	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
> @@ -1660,8 +1648,9 @@ static void __exit applesmc_exit(void)
>  	if (applesmc_accelerometer)
>  		applesmc_release_accelerometer();
>  	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
> -	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
> -	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
> +	while (fans_handled)
> +		sysfs_remove_group(&pdev->dev.kobj,
> +				   &fan_attribute_groups[--fans_handled]);
>  	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
>  	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
>  	platform_device_unregister(pdev);

Applied, thanks.

-- 
Jean Delvare
