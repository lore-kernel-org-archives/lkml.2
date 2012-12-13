Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2LMNYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:24:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:64336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab2LMNWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:22:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,273,1355126400"; 
   d="scan'208";a="233435673"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: RE: [PATCH] X86/acpi: remove redundant logic of acpi memory hotadd
Thread-Topic: [PATCH] X86/acpi: remove redundant logic of acpi memory hotadd
Thread-Index: AQHN2SMhPVBNd0EOSNivpcZOpMzv75gWt1qA
Date: Thu, 13 Dec 2012 13:22:13 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353A8C10@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233539DED4@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923353A779A@SHSMSX101.ccr.corp.intel.com>
 <50C93F36.4030402@huawei.com> <1747018.CRodbRKbDV@vostro.rjw.lan>
In-Reply-To: <1747018.CRodbRKbDV@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBDDOSYc025205

Rafael J. Wysocki wrote:
> On Thursday, December 13, 2012 10:36:38 AM Jiang Liu wrote:
>> On 2012-12-12 22:37, Liu, Jinsong wrote:
>>> Wen Congyang wrote:
>>>> At 12/08/2012 06:19 AM, Rafael J. Wysocki Wrote:
>>>>> On Tuesday, December 04, 2012 01:39:54 AM Liu, Jinsong wrote:
>>>>>> Resend it, add Rafael and linux-acpi@vger.kernel.org
>>>>> 
>>>>> I wonder what memory hotplug people think about that.
>>>>> 
>>>>> Thanks,
>>>>> Rafael
>>>>> 
>>>>> 
>>>>>> ===============
>>>>>> From 1d39279e45c54ce531691da5ffe261e7689dd92c Mon Sep 17
>>>>>> 00:00:00 2001 From: Liu Jinsong <jinsong.liu@intel.com>
>>>>>> Date: Wed, 14 Nov 2012 18:52:06 +0800
>>>>>> Subject: [PATCH] X86/acpi: remove redundant logic of acpi memory
>>>>>> hotadd 
>>>>>> 
>>>>>> When memory hotadd, acpi_memory_enable_device has already been
>>>>>> done at drv->ops.add (acpi_memory_device_add), no need to do it
>>>>>> again at notify callback. 
>>>>>> 
>>>>>> At acpi_memory_enable_device, acpi_memory_get_device_resources
>>>>>> is also a redundant action, since it has been done at
>>>>>> drv->ops.add. 
>>>>>> 
>>>>>> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
>>>>>> ---
>>>>>>  drivers/acpi/acpi_memhotplug.c |   17 -----------------
>>>>>>  1 files changed, 0 insertions(+), 17 deletions(-)
>>>>>> 
>>>>>> diff --git a/drivers/acpi/acpi_memhotplug.c
>>>>>> b/drivers/acpi/acpi_memhotplug.c
>>>>>> index 24c807f..a6489fd 100644
>>>>>> --- a/drivers/acpi/acpi_memhotplug.c
>>>>>> +++ b/drivers/acpi/acpi_memhotplug.c
>>>>>> @@ -220,15 +220,6 @@ static int acpi_memory_enable_device(struct
>>>>>>  	acpi_memory_device *mem_device) struct acpi_memory_info *info;
>>>>>> int node; 
>>>>>> 
>>>>>> -
>>>>>> -	/* Get the range from the _CRS */
>>>>>> -	result = acpi_memory_get_device_resources(mem_device);
>>>>>> -	if (result) {
>>>>>> -		printk(KERN_ERR PREFIX "get_device_resources failed\n");
>>>>>> -		mem_device->state = MEMORY_INVALID_STATE;
>>>>>> -		return result;
>>>>>> -	}
>>>>>> -
>>>>>>  	node = acpi_get_node(mem_device->device->handle);  	/*
>>>>>>  	 * Tell the VM there is more memory here...
>>>>>> @@ -357,14 +348,6 @@ static void
>>>>>>  		acpi_memory_device_notify(acpi_handle handle, u32 event, void
>>>>>> *data)  			break; } 
>>>>>> 
>>>>>> -		if (acpi_memory_check_device(mem_device))
>>>>>> -			break;
>>>> 
>>>> Hmm, if acpi_memory_check_device() fails, it means the memory
>>>> device disappears I don't know if a real hardware uses this way to
>>>> remove memory device. 
>>>> 
>>>>>> -
>>>>>> -		if (acpi_memory_enable_device(mem_device)) {
>>>>>> -			printk(KERN_ERR PREFIX "Cannot enable memory device\n");
>>>>>> -			break;
>>>>>> -		}
>>>> 
>>>> If acpi_memory_get_device() doesn't fail, it means that the device
>>>> has been managed by this driver, so I think we can do this cleanup.
>>>> 
>>>> Thanks
>>>> Wen Congyang
>>>> 
>>> 
>>> Thanks! any comments from Huawei side, Jiang? Hi Jinsong,
>> 
>> We think it's ok.
>> 
>> acpi_memory_device_notify
>> 	acpi_memory_get_device
>> 		acpi_memory_device_add
>> 			acpi_memory_get_device_resources
>> 			acpi_memory_enable_device
>> 				acpi_memory_get_device_resources£¨redundant£©
>> 	acpi_memory_check_device£¨redundant£©
>> 	acpi_memory_enable_device£¨redundant£©
> 
> OK, thanks.
> 
> I'll queue it up for submission as a fix later in the cycle.
> 
> Thanks,
> Rafael

Thank you all!

Jinsongÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
