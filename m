Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2LFE2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 23:28:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:3645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab2LFE2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 23:28:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,227,1355126400"; 
   d="scan'208";a="252749691"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: RE: [PATCH V1 1/2] Xen acpi memory hotplug driver
Thread-Topic: [PATCH V1 1/2] Xen acpi memory hotplug driver
Thread-Index: AQHN0xANUNtbxbdZSkG9MqBQJp2L85gLG13g
Date: Thu, 6 Dec 2012 04:27:36 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353A2366@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923353942F9@SHSMSX101.ccr.corp.intel.com>
 <20121128192601.GA15871@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233539AC1D@SHSMSX101.ccr.corp.intel.com>
 <20121205174307.GC16072@phenom.dumpdata.com>
In-Reply-To: <20121205174307.GC16072@phenom.dumpdata.com>
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

>>>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
>>>> index 126d8ce..abd0396 100644
>>>> --- a/drivers/xen/Kconfig
>>>> +++ b/drivers/xen/Kconfig
>>>> @@ -206,4 +206,15 @@ config XEN_MCE_LOG
>>>>  	  Allow kernel fetching MCE error from Xen platform and
>>>>  	  converting it into Linux mcelog format for mcelog tools
>>>> 
>>>> +config XEN_ACPI_MEMORY_HOTPLUG
>>>> +	bool "Xen ACPI memory hotplug"
>>> 
>>> There should be a way to make this a module.
>> 
>> I have some concerns to make it a module:
>> 1. xen and native memhotplug driver both work as module, while we
>> need early load xen driver. 
>> 2. if possible, a xen stub driver may solve load sequence issue, but
>>   it may involve other issues * if xen driver load then unload,
>> native driver may have chance to load successfully; 
> 
> The stub driver would still "occupy" the ACPI bus for the memory
> hotplug PnP, so I think this would not be a problem.
> 

I'm not quite clear your mean here, do you mean it has
1. xen_stub driver + xen_memhoplug driver, then xen_strub driver unload and entirely replaced by xen_memhotplug driver, or
2. xen_stub driver (w/ stub ops) + xen_memhotplug ops (not driver), then xen_stub driver keep occupying but its stub ops later replaced by xen_memhotplug ops?

If in way #1, it has risk that native driver may load (if xen driver unload).
If in way #2, xen_memhotplug ops lose the chance to probe/add/bind existed memory devices (since it's done when driver registerred).

>>   * if xen driver load --> unload --> load again, then it will lose
>> hotplug notification during unload period; 
> 
> Sure. But I think we can do it with this driver? After all the
> function of 
> it is to just tell the firmware to turn on/off sockets - and if we
> miss 
> one notification we won't take advantage of the power savings - but we
> can do that later on.
> 

Not only inform firmware.
Hotplug notify callback will invoke acpi_bus_add -> ... -> implicitly invoke drv->ops.add method to add the hotadded memory device.

> 
>>   * if xen driver load --> unload --> load again, then it will
>> re-add all memory devices, but the handle for 'booting memory
>> device' and 'hotplug memory device' are different while we have no
>> way to distinguish these 2 kind of devices.   
> 
> Wouldn't the stub driver hold onto that?
> 

Same question as comment #1. Do you mean it has a xen_stub driver (w/ stub ops) and a xen_memhotplug ops?

>> 
>> IMHO I think to make xen hotplug logic as module may involves
>> unexpected result. Is there any obvious advantages of doing so?
>> after all we have provided config choice to user. Thoughts?  
> 
> Yes, it becomes a module - which is what we want.
> 

What I meant here is, module will bring some unexpected issues for xen hotplug.
We can provide user 'bool' config choice, let them decide to build-in or not, but not 'tristate' choice.

Thanks
Jinsong