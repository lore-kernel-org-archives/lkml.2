Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2JJBIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:08:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43826 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab2JJBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:08:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5074CA61.3010802@jp.fujitsu.com>
Date: Wed, 10 Oct 2012 10:07:45 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lenb@kernel.org>, <wency@cn.fujitsu.com>,
        <vasilis.liaskovitis@profitbricks.com>
Subject: Re: acpi : acpi_bus_trim() stops removing devices when failing to
 remove the device
References: <5073E4CC.3090600@jp.fujitsu.com> <1349800566.23493.9.camel@misato.fc.hp.com>
In-Reply-To: <1349800566.23493.9.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2012/10/10 1:36, Toshi Kani wrote:
> On Tue, 2012-10-09 at 17:48 +0900, Yasuaki Ishimatsu wrote:
>> acpi_bus_trim() stops removing devices, when acpi_bus_remove() return error
>> number. But acpi_bus_remove() cannot return error number correctly.
>> acpi_bus_remove() only return -EINVAL, when dev argument is NULL. Thus even if
>> device cannot be removed correctly, acpi_bus_trim() ignores and continues to
>> remove devices. acpi_bus_hot_remove_device() uses acpi_bus_trim() for removing
>> devices. Therefore acpi_bus_hot_remove_device() can send "_EJ0" to firmware,
>> even if the device is running on the system. In this case, the system cannot
>> work well.
>>
>> Vasilis hit the bug at memory hotplug and reported it as follow:
>> https://lkml.org/lkml/2012/9/26/318
>>
>> So acpi_bus_trim() should check whether device was removed or not correctly.
>> The patch adds error check into some functions to remove the device.
>>
>> Applying the patch, acpi_bus_trim() stops removing devices when failing
>> to remove the device. But I think there is no impact with the
>> exceptionof CPU and Memory hotplug path. Because other device also fails
>> but the fail is an irregular case like device is NULL.
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> ---
>>   drivers/acpi/scan.c    |   15 ++++++++++++---
>>   drivers/base/dd.c      |   22 +++++++++++++++++-----
>>   include/linux/device.h |    2 +-
>>   3 files changed, 30 insertions(+), 9 deletions(-)
>>
>> Index: linux-3.6/drivers/acpi/scan.c
>> ===================================================================
>> --- linux-3.6.orig/drivers/acpi/scan.c	2012-10-09 17:25:40.956496325 +0900
>> +++ linux-3.6/drivers/acpi/scan.c	2012-10-09 17:25:55.405497800 +0900
>> @@ -445,12 +445,17 @@ static int acpi_device_remove(struct dev
>>   {
>>   	struct acpi_device *acpi_dev = to_acpi_device(dev);
>>   	struct acpi_driver *acpi_drv = acpi_dev->driver;
>> +	int ret;
>>
>>   	if (acpi_drv) {
>>   		if (acpi_drv->ops.notify)
>>   			acpi_device_remove_notify_handler(acpi_dev);
>> -		if (acpi_drv->ops.remove)
>> -			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
>> +		if (acpi_drv->ops.remove) {
>> +			ret = acpi_drv->ops.remove(acpi_dev,
>> +						   acpi_dev->removal_type);
>> +			if (ret)
>
> Hi Yasuaki,
>
> Shouldn't the notify handler be reinstalled here if it was removed by
> the acpi_device_remove_notify_handler() above?

I do not reinstall the notify handler.
The function has not been removed on linux-3.6. And the patch is created
on linux-3.6. So the function remains in the patch.

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> -Toshi
>
>> +				return ret;
>> +		}
>>   	}
>>   	acpi_dev->driver = NULL;
>>   	acpi_dev->driver_data = NULL;
>> @@ -1226,11 +1231,15 @@ static int acpi_device_set_context(struc
>>
>>   static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>>   {
>> +	int ret;
>> +
>>   	if (!dev)
>>   		return -EINVAL;
>>
>>   	dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
>> -	device_release_driver(&dev->dev);
>> +	ret = device_release_driver(&dev->dev);
>> +	if (ret)
>> +		return ret;
>>
>>   	if (!rmdevice)
>>   		return 0;
>> Index: linux-3.6/drivers/base/dd.c
>> ===================================================================
>> --- linux-3.6.orig/drivers/base/dd.c	2012-10-01 08:47:46.000000000 +0900
>> +++ linux-3.6/drivers/base/dd.c	2012-10-09 17:25:55.442497825 +0900
>> @@ -475,9 +475,10 @@ EXPORT_SYMBOL_GPL(driver_attach);
>>    * __device_release_driver() must be called with @dev lock held.
>>    * When called for a USB interface, @dev->parent lock must be held as well.
>>    */
>> -static void __device_release_driver(struct device *dev)
>> +static int __device_release_driver(struct device *dev)
>>   {
>>   	struct device_driver *drv;
>> +	int ret = 0;
>>
>>   	drv = dev->driver;
>>   	if (drv) {
>> @@ -493,9 +494,11 @@ static void __device_release_driver(stru
>>   		pm_runtime_put_sync(dev);
>>
>>   		if (dev->bus && dev->bus->remove)
>> -			dev->bus->remove(dev);
>> +			ret = dev->bus->remove(dev);
>>   		else if (drv->remove)
>> -			drv->remove(dev);
>> +			ret = drv->remove(dev);
>> +		if (ret)
>> +			goto rollback;
>>   		devres_release_all(dev);
>>   		dev->driver = NULL;
>>   		dev_set_drvdata(dev, NULL);
>> @@ -506,6 +509,12 @@ static void __device_release_driver(stru
>>   						     dev);
>>
>>   	}
>> +
>> +	return ret;
>> +
>> +rollback:
>> +	driver_sysfs_add(dev);
>> +	return ret;
>>   }
>>
>>   /**
>> @@ -515,16 +524,19 @@ static void __device_release_driver(stru
>>    * Manually detach device from driver.
>>    * When called for a USB interface, @dev->parent lock must be held.
>>    */
>> -void device_release_driver(struct device *dev)
>> +int device_release_driver(struct device *dev)
>>   {
>> +	int ret;
>>   	/*
>>   	 * If anyone calls device_release_driver() recursively from
>>   	 * within their ->remove callback for the same device, they
>>   	 * will deadlock right here.
>>   	 */
>>   	device_lock(dev);
>> -	__device_release_driver(dev);
>> +	ret = __device_release_driver(dev);
>>   	device_unlock(dev);
>> +
>> +	return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(device_release_driver);
>>
>> Index: linux-3.6/include/linux/device.h
>> ===================================================================
>> --- linux-3.6.orig/include/linux/device.h	2012-10-01 08:47:46.000000000 +0900
>> +++ linux-3.6/include/linux/device.h	2012-10-09 17:25:55.479497852 +0900
>> @@ -834,7 +834,7 @@ static inline void *dev_get_platdata(con
>>    * for information on use.
>>    */
>>   extern int __must_check device_bind_driver(struct device *dev);
>> -extern void device_release_driver(struct device *dev);
>> +extern int device_release_driver(struct device *dev);
>>   extern int  __must_check device_attach(struct device *dev);
>>   extern int __must_check driver_attach(struct device_driver *drv);
>>   extern int __must_check device_reprobe(struct device *dev);
>>
>
>


