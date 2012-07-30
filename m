Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2G3PdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:33:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2G3PdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:33:20 -0400
Message-ID: <5016A939.9050600@gmail.com>
Date: Mon, 30 Jul 2012 23:33:13 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: lenb@kernel.org, toshi.kani@hp.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] create sun sysfs file
References: <5015DC4B.2000802@jp.fujitsu.com>
In-Reply-To: <5015DC4B.2000802@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 08:58 AM, Yasuaki Ishimatsu wrote:
> Even if a device has _SUN method, there is no way to know the slot unique-ID.
> Thus the patch creates "sun" file in sysfs so that we can recognize it.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>  drivers/acpi/scan.c     |   25 +++++++++++++++++++++++++
>  include/acpi/acpi_bus.h |    1 +
>  2 files changed, 26 insertions(+)
> 
> Index: linux-3.5/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-3.5.orig/include/acpi/acpi_bus.h	2012-07-27 10:20:22.722553439 +0900
> +++ linux-3.5/include/acpi/acpi_bus.h	2012-07-27 10:20:25.741555954 +0900
> @@ -209,6 +209,7 @@ struct acpi_device_pnp {
>  	struct list_head ids;		/* _HID and _CIDs */
>  	acpi_device_name device_name;	/* Driver-determined */
>  	acpi_device_class device_class;	/*        "          */
> +	unsigned long sun;		/* _SUN */
>  };
>  
>  #define acpi_device_bid(d)	((d)->pnp.bus_id)
> Index: linux-3.5/drivers/acpi/scan.c
> ===================================================================
> --- linux-3.5.orig/drivers/acpi/scan.c	2012-07-27 10:20:22.721522499 +0900
> +++ linux-3.5/drivers/acpi/scan.c	2012-07-30 09:52:32.581887304 +0900
> @@ -192,10 +192,21 @@ end:
>  }
>  static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
>  
> +static ssize_t
> +acpi_device_sun_show(struct device *dev, struct device_attribute *attr, char *buf) {
The above line is more than 80 characters.

> +	struct acpi_device *acpi_dev = to_acpi_device(dev);
> +	int result;
> +
> +	result = sprintf(buf, "%lu\n", acpi_dev->pnp.sun);
> +	return result;
How about just
return sprintf(buf, "%lu\n", acpi_dev->pnp.sun);

> +}
> +static DEVICE_ATTR(sun, 0444, acpi_device_sun_show, NULL);
> +
>  static int acpi_device_setup_files(struct acpi_device *dev)
>  {
>  	acpi_status status;
>  	acpi_handle temp;
> +	unsigned long long sun;
>  	int result = 0;
>  
>  	/*
> @@ -217,6 +228,16 @@ static int acpi_device_setup_files(struc
>  			goto end;
>  	}
>  
> +	status = acpi_evaluate_integer(dev->handle, "_SUN", NULL, &sun);
> +	if (ACPI_SUCCESS(status)) {
> +		dev->pnp.sun = (unsigned long)sun;
> +		result = device_create_file(&dev->dev, &dev_attr_sun);
> +		if (result)
> +			goto end;
> +	} else {
> +		dev->pnp.sun = (unsigned long)-1;
> +	}
> +
>          /*
>           * If device has _EJ0, 'eject' file is created that is used to trigger
>           * hot-removal function from userland.
> @@ -241,6 +262,10 @@ static void acpi_device_remove_files(str
>  	if (ACPI_SUCCESS(status))
>  		device_remove_file(&dev->dev, &dev_attr_eject);
>  
> +	status = acpi_get_handle(dev->handle, "_SUN", &temp);
> +	if (ACPI_SUCCESS(status))
> +		device_remove_file(&dev->dev, &dev_attr_sun);
> +
>  	device_remove_file(&dev->dev, &dev_attr_modalias);
>  	device_remove_file(&dev->dev, &dev_attr_hid);
>  	if (dev->handle)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

