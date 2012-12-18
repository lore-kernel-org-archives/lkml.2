Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2LRNP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:15:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:32842 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab2LRNP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:15:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,309,1355126400"; 
   d="scan'208";a="235672448"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V1 1/2] Xen acpi memory hotplug driver
Thread-Topic: [PATCH V1 1/2] Xen acpi memory hotplug driver
Thread-Index: AQHN1IPpUNtbxbdZSkG9MqBQJp2L85gVdm/ggALVLaCABk6VoA==
Date: Tue, 18 Dec 2012 13:15:52 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353AD822@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923353942F9@SHSMSX101.ccr.corp.intel.com>
	<20121128192601.GA15871@phenom.dumpdata.com>
	<DE8DF0795D48FD4CA783C40EC829233539AC1D@SHSMSX101.ccr.corp.intel.com>
	<20121205174307.GC16072@phenom.dumpdata.com>
	<DE8DF0795D48FD4CA783C40EC82923353A2366@SHSMSX101.ccr.corp.intel.com>
	<20121207140528.GA3140@phenom.dumpdata.com>
	<DE8DF0795D48FD4CA783C40EC82923353A7C7B@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923353A9E57@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353A9E57@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liu, Jinsong wrote:
> Liu, Jinsong wrote:
>> Konrad Rzeszutek Wilk wrote:
>>> On Thu, Dec 06, 2012 at 04:27:36AM +0000, Liu, Jinsong wrote:
>>>>>>>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig index
>>>>>>>> 126d8ce..abd0396 100644 --- a/drivers/xen/Kconfig
>>>>>>>> +++ b/drivers/xen/Kconfig
>>>>>>>> @@ -206,4 +206,15 @@ config XEN_MCE_LOG
>>>>>>>>  	  Allow kernel fetching MCE error from Xen platform and
>>>>>>>>  	  converting it into Linux mcelog format for mcelog tools
>>>>>>>> 
>>>>>>>> +config XEN_ACPI_MEMORY_HOTPLUG
>>>>>>>> +	bool "Xen ACPI memory hotplug"
>>>>>>> 
>>>>>>> There should be a way to make this a module.
>>>>>> 
>>>>>> I have some concerns to make it a module:
>>>>>> 1. xen and native memhotplug driver both work as module, while
>>>>>> we need early load xen driver. 
>>>>>> 2. if possible, a xen stub driver may solve load sequence issue,
>>>>>>   but it may involve other issues * if xen driver load then
>>>>>> unload, native driver may have chance to load successfully;
>>>>> 
>>>>> The stub driver would still "occupy" the ACPI bus for the memory
>>>>> hotplug PnP, so I think this would not be a problem.
>>>>> 
>>>> 
>>>> I'm not quite clear your mean here, do you mean it has
>>>> 1. xen_stub driver + xen_memhoplug driver, then xen_strub driver
>>>> unload and entirely replaced by xen_memhotplug driver, or
>>>> 2. xen_stub driver (w/ stub ops) + xen_memhotplug ops (not driver),
>>>> then xen_stub driver keep occupying but its stub ops later replaced
>>>> by xen_memhotplug ops?
>>> 
>>> #2
>>>> 
>>>> If in way #1, it has risk that native driver may load (if xen
>>>> driver unload). If in way #2, xen_memhotplug ops lose the chance to
>>>> probe/add/bind existed memory devices (since it's done when driver
>>>> registerred).
>>> 
>>> Could the stub driver have a queue of events?
>> 
>> If so, why not do 'real' add ops (like our patch did, to build-in
>> xen memory hotplug logic)? I'm not quite clear your purpose of
>> insisting module -- what's advantage of module you prefer?
>> 
>>> 
>>>> 
>>>>>>   * if xen driver load --> unload --> load again, then it will
>>>>>> lose hotplug notification during unload period;
>>>>> 
>>>>> Sure. But I think we can do it with this driver? After all the
>>>>> function of it is to just tell the firmware to turn on/off sockets
>>>>> - and if we miss one notification we won't take advantage of the
>>>>> power savings - but we can do that later on.
>>>>> 
>>>> 
>>>> Not only inform firmware.
>>>> Hotplug notify callback will invoke acpi_bus_add -> ... ->
>>>> implicitly invoke drv->ops.add method to add the hotadded memory
>>>> device.
>>> 
>>> Gotcha.
>> 
>> ? So it will lose the notification and no way to add the new memory
>> device in the future. 
>> 
>> Xen memory hotplug logic consist of 2 parts:
>> 1) driver logic (.add/.remove etc)
>> 2) notification install/callback logic
>> If you want to use 'xen_stub driver + .add/.remove ops', then
>> notification install/callback logic would implement with xen_stub
>> driver (means in build-in part, otherwise it would lose notification
>> when the ops unload) --> but that would make xen_stub in big build-in
>> size.
> 
> How about
> * build-in part: xen_stub driver (stub .add to record what matched
> cpu devices) + notification install/callback; 
> * module part: .add/.remove ops;
> w/ it, native driver has no chance to load and no hotplug event lose,
> and approximately 1/3 code is build-in and 2/3 are module. 
> 
> I think it will work but I'm not quite sure, at least we can have a
> try/test? 
> 
> Thanks,
> Jinsong
> 

Thoughts? If you think it's OK, I will update later.

Thanks,
Jinsong