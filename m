Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2B1QYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:24:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:64177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2B1QYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:24:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112267805"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <jbeulich@suse.com>, "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
Thread-Topic: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
Thread-Index: AQHM9Kz1m4MGy1d3TzK01xgwJYdnxZZSeQog
Date: Tue, 28 Feb 2012 16:24:09 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350B9496@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
 <4F46530B020000780007F751@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350B2013@SHSMSX101.ccr.corp.intel.com>
 <20120226173458.GB18098@phenom.dumpdata.com>
In-Reply-To: <20120226173458.GB18098@phenom.dumpdata.com>
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

Konrad Rzeszutek Wilk wrote:
> On Sun, Feb 26, 2012 at 08:25:41AM +0000, Liu, Jinsong wrote:
>> Liu, Jinsong wrote:
>>> Jan Beulich wrote:
>>>>>>> "Liu, Jinsong" <jinsong.liu@intel.com> 02/23/12 2:29 PM >>>
>>>>> --- a/drivers/acpi/Kconfig
>>>>> +++ b/drivers/acpi/Kconfig
>>>>> @@ -213,10 +213,11 @@ config ACPI_HOTPLUG_CPU
>>>>>    default y
>>>>  >
>>>>> config ACPI_PROCESSOR_AGGREGATOR
>>>>> -    tristate "Processor Aggregator"
>>>>> +    bool "Processor Aggregator"
>>>> 
>>>> There must be ways to address whatever strange problem you see
>>>> without making this piece of code non-modular.
>>>> 
>>> 
>>> Yes, another approach is x86_init approach, defining acpi_pad_ops at
>>> x86_init.c and overwritten when xen_start_kernel. This patch is just
>>> a RFC patch, to evaluate which approch is more reasonable :-)
>>> 
>> 
>> Have a more think about it, x86_init approach still need to disable
>> acpi_pad module. 
>> Seems we have to set acpi_pad as bool, as long as it need to hook to
>> native acpi_pad fucs/variables. 
> 
> What about the other approach I suggested where there are some
> function overrides in osl.c? Something similar to
> https://lkml.org/lkml/2012/1/17/401, specifically
> https://lkml.org/lkml/2012/1/17/403 - that way you are not turning
> the modules into being built in, but intead have the function table
> already in the kernel (as some form of EXPORT_SYMBOL_GPL or a
> registration function). 
> 

Thanks for the example (it's good itself :-), but per my understanding they are different cases.

In the osl example case, tboot_late_init call acpi_os_set_prepare_sleep to register func, so it works no matter tboot.c built as y/n/m (through currently it's bool).

However, in our case, we just cannot do so. We need
1. predefine a hook to native acpi pad funcs, take effect when static compile stage;
2. when xen init, redirect the hook to xen acpi pad funcs, take effect at running time;
(The point is, we cannot do init twice for native and xen acpi pad, so we have to statically predefine a hook to native acpi_pad)

For the reason above, I think we have to remove acpi_pad module, as long as we need to hook to native acpi_pad funcs. Thoughts?

Regards,
Jinsong
