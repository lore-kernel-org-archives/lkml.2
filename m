Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2KPBoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:44:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33277 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2KPBoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:44:00 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50A59A46.2030308@jp.fujitsu.com>
Date: Fri, 16 Nov 2012 10:43:34 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <lenb@kernel.org>, <toshi.kani@hp.com>, <liuj97@gmail.com>
Subject: Re: [PATCH v6] create sun sysfs file
References: <50A1F711.7020408@jp.fujitsu.com>
In-Reply-To: <50A1F711.7020408@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Please merge this patch into your tree.
It has been acked by Len.

Thanks,
Yasuaki Ishimatsu

2012/11/13 16:30, Yasuaki Ishimatsu wrote:
> Hi Rafael,
> 
> The patch was rebased on linux-next. Ant it has been acked by Len:
> 
> https://lkml.org/lkml/2012/10/10/65
> 
> So please merge it into your tree.
> 
> ---
> _SUN method provides the slot unique-ID in the ACPI namespace. And The value
> is written in Advanced Configuration and Power Interface Specification as
> follows:
> 
> "The _SUN value is required to be unique among the slots ofthe same type.
> It is also recommended that this number match the slot number printed on
> the physical slot whenever possible."
> 
> So if we can know the value, we can identify the physical position of the
> slot in the system.
> 
> The patch creates "sun" file in sysfs for identifying physical position
> of the slot.
> 
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>   Documentation/ABI/testing/sysfs-devices-sun |   14 ++++++++++++++
>   drivers/acpi/scan.c                         |   24 ++++++++++++++++++++++++
>   include/acpi/acpi_bus.h                     |    1 +
>   3 files changed, 39 insertions(+)
> 
> Index: linux-next/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-next.orig/include/acpi/acpi_bus.h	2012-11-12 17:58:08.000000000 +0900
> +++ linux-next/include/acpi/acpi_bus.h	2012-11-12 19:07:33.577427071 +0900
> @@ -179,6 +179,7 @@ struct acpi_device_pnp {
>   	acpi_device_name device_name;	/* Driver-determined */
>   	acpi_device_class device_class;	/*        "          */
>   	union acpi_object *str_obj;	/* unicode string for _STR method */
> +	unsigned long sun;		/* _SUN */
>   };
>   
>   #define acpi_device_bid(d)	((d)->pnp.bus_id)
> Index: linux-next/drivers/acpi/scan.c
> ===================================================================
> --- linux-next.orig/drivers/acpi/scan.c	2012-11-12 17:57:44.000000000 +0900
> +++ linux-next/drivers/acpi/scan.c	2012-11-12 19:08:53.387428254 +0900
> @@ -292,11 +292,21 @@ static ssize_t description_show(struct d
>   }
>   static DEVICE_ATTR(description, 0444, description_show, NULL);
>   
> +static ssize_t
> +acpi_device_sun_show(struct device *dev, struct device_attribute *attr,
> +		     char *buf) {
> +	struct acpi_device *acpi_dev = to_acpi_device(dev);
> +
> +	return sprintf(buf, "%lu\n", acpi_dev->pnp.sun);
> +}
> +static DEVICE_ATTR(sun, 0444, acpi_device_sun_show, NULL);
> +
>   static int acpi_device_setup_files(struct acpi_device *dev)
>   {
>   	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
>   	acpi_status status;
>   	acpi_handle temp;
> +	unsigned long long sun;
>   	int result = 0;
>   
>   	/*
> @@ -338,6 +348,16 @@ static int acpi_device_setup_files(struc
>   	if (dev->pnp.unique_id)
>   		result = device_create_file(&dev->dev, &dev_attr_uid);
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
>           /*
>            * If device has _EJ0, 'eject' file is created that is used to trigger
>            * hot-removal function from userland.
> @@ -369,6 +389,10 @@ static void acpi_device_remove_files(str
>   	if (ACPI_SUCCESS(status))
>   		device_remove_file(&dev->dev, &dev_attr_eject);
>   
> +	status = acpi_get_handle(dev->handle, "_SUN", &temp);
> +	if (ACPI_SUCCESS(status))
> +		device_remove_file(&dev->dev, &dev_attr_sun);
> +
>   	if (dev->pnp.unique_id)
>   		device_remove_file(&dev->dev, &dev_attr_uid);
>   	if (dev->flags.bus_address)
> Index: linux-next/Documentation/ABI/testing/sysfs-devices-sun
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-next/Documentation/ABI/testing/sysfs-devices-sun	2012-11-12 19:09:26.854428750 +0900
> @@ -0,0 +1,14 @@
> +Whatt:		/sys/devices/.../sun
> +Date:		October 2012
> +Contact:	Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> +Description:
> +		The file contains a Slot-unique ID which provided by the _SUN
> +		method in the ACPI namespace. The value is written in Advanced
> +		Configuration and Power Interface Specification as follows:
> +
> +		"The _SUN value is required to be unique among the slots of
> +		the same type. It is also recommended that this number match
> +		the slot number printed on the physical slot whenever possible."
> +
> +		So reading the sysfs file, we can identify a physical position
> +		of the slot in the system.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


