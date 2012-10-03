Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2JCJyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:54:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46528 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2JCJyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:54:49 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506C0B52.4010800@jp.fujitsu.com>
Date: Wed, 3 Oct 2012 18:54:26 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <lenb@kernel.org>
CC: <toshi.kani@hp.com>, <liuj97@gmail.com>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] create sun sysfs file
References: <502062FB.7030502@jp.fujitsu.com> <503EC30B.2070900@jp.fujitsu.com> <505FC5F1.4090306@jp.fujitsu.com>
In-Reply-To: <505FC5F1.4090306@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Ping...
Pleae merge the patch into your tree.

Thanks,
Yasuaki Ishimatsu

2012/09/24 11:31, Yasuaki Ishimatsu wrote:
> Hi Len,
> 
> Ping...
> I want you to merge the patch into your tree for linux-3.7.
> 
> Thanks,
> Yasuaki Ishimatsu
> 
> 2012/08/30 10:34, Yasuaki Ishimatsu wrote:
>> Hi Len,
>>
>> Three weeks passed after I post the patch.
>> All comments have already been applied to it. And I think there is no
>> comments about it. So I want you to merge it into your tree.
>>
>> Thanks,
>> Yasuaki Ishimatsu
>>
>> 2012/08/07 9:36, Yasuaki Ishimatsu wrote:
>>> Even if a device has _SUN method, there is no way to know the slot unique-ID.
>>> Thus the patch creates "sun" file in sysfs so that we can recognize it.
>>>
>>> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>
>>> ---
>>>     drivers/acpi/scan.c     |   24 ++++++++++++++++++++++++
>>>     include/acpi/acpi_bus.h |    1 +
>>>     2 files changed, 25 insertions(+)
>>>
>>> Index: linux-3.5/include/acpi/acpi_bus.h
>>> ===================================================================
>>> --- linux-3.5.orig/include/acpi/acpi_bus.h	2012-07-30 10:06:49.722171575 +0900
>>> +++ linux-3.5/include/acpi/acpi_bus.h	2012-08-07 08:57:45.678204360 +0900
>>> @@ -209,6 +209,7 @@ struct acpi_device_pnp {
>>>     	struct list_head ids;		/* _HID and _CIDs */
>>>     	acpi_device_name device_name;	/* Driver-determined */
>>>     	acpi_device_class device_class;	/*        "          */
>>> +	unsigned long sun;		/* _SUN */
>>>     };
>>>     
>>>     #define acpi_device_bid(d)	((d)->pnp.bus_id)
>>> Index: linux-3.5/drivers/acpi/scan.c
>>> ===================================================================
>>> --- linux-3.5.orig/drivers/acpi/scan.c	2012-07-30 10:06:49.713171688 +0900
>>> +++ linux-3.5/drivers/acpi/scan.c	2012-08-07 09:01:38.196203659 +0900
>>> @@ -192,10 +192,20 @@ end:
>>>     }
>>>     static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
>>>     
>>> +static ssize_t
>>> +acpi_device_sun_show(struct device *dev, struct device_attribute *attr,
>>> +		     char *buf) {
>>> +	struct acpi_device *acpi_dev = to_acpi_device(dev);
>>> +
>>> +	return sprintf(buf, "%lu\n", acpi_dev->pnp.sun);
>>> +}
>>> +static DEVICE_ATTR(sun, 0444, acpi_device_sun_show, NULL);
>>> +
>>>     static int acpi_device_setup_files(struct acpi_device *dev)
>>>     {
>>>     	acpi_status status;
>>>     	acpi_handle temp;
>>> +	unsigned long long sun;
>>>     	int result = 0;
>>>     
>>>     	/*
>>> @@ -217,6 +227,16 @@ static int acpi_device_setup_files(struc
>>>     			goto end;
>>>     	}
>>>     
>>> +	status = acpi_evaluate_integer(dev->handle, "_SUN", NULL, &sun);
>>> +	if (ACPI_SUCCESS(status)) {
>>> +		dev->pnp.sun = (unsigned long)sun;
>>> +		result = device_create_file(&dev->dev, &dev_attr_sun);
>>> +		if (result)
>>> +			goto end;
>>> +	} else {
>>> +		dev->pnp.sun = (unsigned long)-1;
>>> +	}
>>> +
>>>             /*
>>>              * If device has _EJ0, 'eject' file is created that is used to trigger
>>>              * hot-removal function from userland.
>>> @@ -241,6 +261,10 @@ static void acpi_device_remove_files(str
>>>     	if (ACPI_SUCCESS(status))
>>>     		device_remove_file(&dev->dev, &dev_attr_eject);
>>>     
>>> +	status = acpi_get_handle(dev->handle, "_SUN", &temp);
>>> +	if (ACPI_SUCCESS(status))
>>> +		device_remove_file(&dev->dev, &dev_attr_sun);
>>> +
>>>     	device_remove_file(&dev->dev, &dev_attr_modalias);
>>>     	device_remove_file(&dev->dev, &dev_attr_hid);
>>>     	if (dev->handle)
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


