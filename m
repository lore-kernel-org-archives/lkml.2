Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab2J2DjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:39:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:24487 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab2J2DjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:39:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,668,1344236400"; 
   d="scan'208";a="161741111"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNs7Z0Ti91BiFLfUibRvXA4zlK85fPmf1g
Date: Mon, 29 Oct 2012 03:38:14 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335373918@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
In-Reply-To: <20121026201409.GF2708@phenom.dumpdata.com>
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

It's doable to register a stub for xen. However, it's not preferred, say, to make xen pad as module, considering the case 'rmmod xen_acpi_pad' then 'insmod acpi_pad'? Under such case there is risk of mwait #UD, if we want to remove mwait check as 'patch 2/2: Revert-pad-config-check-in-xen_check_mwait.patch' did, advantages of which is to enjoy deep Cx.

IMHO to prevent mwait #UD, native pad should never have chance to register successfully when running under Xen. So it's better never unregister/disable xen pad.

Konrad Rzeszutek Wilk wrote:
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -29,6 +29,7 @@ obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
>>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
>>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
>> +obj-$(CONFIG_XEN_DOM0)			+= xen_acpi_pad.o
> 
> We should have a Kconfig option. In it, please mention what
> version of hypervisor supports this functionality.
> 

Kconfig option for xen pad is not preferred, considering if we disable xen pad and then register native pad driver? (of course the precondition is that we do not register stub for xen).

>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +#include <acpi/acpi_bus.h>
>> +#include <acpi/acpi_drivers.h>
>> +#include <asm/xen/hypercall.h>
>> +
>> +#if defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) || \
>> +		defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)
> 
> I don't think you need that.
> 

OK.

>> +
>> +static int __init xen_acpi_pad_init(void)
>> +{
>> +	/* Only DOM0 is responsible for Xen acpi pad */
>> +	if (xen_initial_domain())
>> +		return acpi_bus_register_driver(&xen_acpi_pad_driver); +
>> +	return -ENODEV;
>> +}
>> +subsys_initcall(xen_acpi_pad_init);
> 
> 
> No way of making this a module? It would be nice - perhaps have a stub
> function that registers the bus but does not do anything until this
> proper module is loaded?
> 

It's doable but not preferred, reason as above.

>> +
>> +#endif
>> diff --git a/include/xen/interface/platform.h
>> b/include/xen/interface/platform.h index 4755b5f..0f44376 100644 ---
>> a/include/xen/interface/platform.h +++
>> b/include/xen/interface/platform.h @@ -324,6 +324,22 @@ struct
>>  xenpf_cpu_ol { };
>>  DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
>> 
>> +/*
>> + * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
>> + * which already occupied at Xen hypervisor side.
>            ^- are
> 

Sure.

Thanks,
Jinsong

