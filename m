Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2DTMx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 08:53:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:41013 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab2DTMx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 08:53:26 -0400
X-IronPort-AV: E=Sophos;i="4.75,454,1330923600"; 
   d="scan'208";a="24362419"
Message-ID: <4F915C43.4020207@citrix.com>
Date: Fri, 20 Apr 2012 13:53:23 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Lin Ming <mlin@ss.pku.edu.cn>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with hypercall
References: <1334913957.2863.1.camel@hp6530s>  <4F913340.4000202@citrix.com>  <1334920396.2863.16.camel@hp6530s> <1334925508.28331.63.camel@zakaz.uk.xensource.com>
In-Reply-To: <1334925508.28331.63.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/12 13:38, Ian Campbell wrote:
> On Fri, 2012-04-20 at 12:13 +0100, Lin Ming wrote:
>> On Fri, 2012-04-20 at 10:58 +0100, Andrew Cooper wrote:
>>> On 20/04/12 10:25, Lin Ming wrote:
>>>> Implements xen_io_apic_read with hypercall, so it returns proper IO-APIC
>>>> information instead of fabricated one.
>>>>
>>>> Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
>>>> ---
>>>>  arch/x86/xen/apic.c |   16 +++++++++++-----
>>>>  1 files changed, 11 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
>>>> index aee16ab..f1f392d 100644
>>>> --- a/arch/x86/xen/apic.c
>>>> +++ b/arch/x86/xen/apic.c
>>>> @@ -1,14 +1,20 @@
>>>>  #include <linux/init.h>
>>>>  #include <asm/x86_init.h>
>>>> +#include <asm/apic.h>
>>>> +#include <xen/interface/physdev.h>
>>>> +#include <asm/xen/hypercall.h>
>>>>  
>>>>  unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
>>>>  {
>>>> -	if (reg == 0x1)
>>>> -		return 0x00170020;
>>>> -	else if (reg == 0x0)
>>>> -		return apic << 24;
>>>> +	struct physdev_apic apic_op;
>>>> +	int ret;
>>>>  
>>>> -	return 0xff;
>>>> +	apic_op.apic_physbase = mpc_ioapic_addr(apic);
>>>> +	apic_op.reg = reg;
>>>> +	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +	return apic_op.value;
>>> Hypercall ret errors are negative, yet this function is unsigned.  Given
>>> that the previous function had no possible way to fail, perhaps on error
>>> you should fake up the values as before.
>> How about return -1 on error?
>> The calling function can check -1 for error. 
> Isn't -1 potentially (at least theoretically) a valid value to read from
> one of these registers?

Theoretically yes, but practically it would only be buggy hardware
returning -1.

>
> Under what circumstances can these hypercalls fail? Would a BUG_ON be
> appropriate/

-EFAULT, -EPERM, anything xsm_apic() could return (which looks only to
be -EPERM).  The call into Xen itself will return 0 as a value if an
invalid physbase is passed in the hypercall.

So a BUG_ON() is not safe/sensible for domU.

>
>> unsigned int ret = apic_read(...);
>> if (ret == -1)
>> 	//handle error.
>>
>> Thanks,
>> Lin Ming
>>
>>
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xen.org
>> http://lists.xen.org/xen-devel
>

-- 
Andrew Cooper - Dom0 Kernel Engineer, Citrix XenServer
T: +44 (0)1223 225 900, http://www.citrix.com

