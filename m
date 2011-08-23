Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1HWHqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:46:39 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:45451 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab1HWHqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:46:37 -0400
X-ASG-Debug-ID: 1314085596-082c3ff20001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
Message-ID: <4E535B66.8070301@marvell.com>
Date: Tue, 23 Aug 2011 15:48:54 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        Jon Nettleton <jon.nettleton@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] ARM: mmp: map sram as MT_MEMORY rather than MT_DEVICE
Subject: Re: [PATCH] ARM: mmp: map sram as MT_MEMORY rather than MT_DEVICE
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>	<1313377794-26721-2-git-send-email-leoy@marvell.com>	<20110822164740.5682541b@queued.net>	<CAMPhdO-cttCzdm_gh=KdNqqPYQOgPBNS57DtPduPahpkP2rk0g@mail.gmail.com> <20110822190838.3e03c3ec@debxo>
X-ASG-Orig-Subj: Re: [PATCH] ARM: mmp: map sram as MT_MEMORY rather than MT_DEVICE
In-Reply-To: <20110822190838.3e03c3ec@debxo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1314085596
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/23/2011 10:08 AM, Andres Salomon wrote:
> On Tue, 23 Aug 2011 08:07:41 +0800
> Eric Miao<eric.y.miao@gmail.com>  wrote:
>
>> On Tue, Aug 23, 2011 at 7:47 AM, Andres Salomon<dilinger@queued.net>
>> wrote:
>>> The sram code allocates memory with ioremap, which assumes MT_DEVICE
>>> for memory protections.  This explodes when we map sram for power
>>> management purposes and then attempt to execute it (jump_to_lp_sram)
>>> on the OLPC XO-1.75.  Instead, we want to specify MT_MEMORY, which
>>> doesn't set the L_PTE_XN bit.
>>>
>>> Signed-off-by: Andres Salomon<dilinger@queued.net>
>>> ---
>>>   arch/arm/mach-mmp/sram.c |    4 +++-
>>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>>
>>> Eric, this patch is against the devel branch of your pxa tree.
>>>
>>> diff --git a/arch/arm/mach-mmp/sram.c b/arch/arm/mach-mmp/sram.c
>>> index 4304f95..ca4d3c1 100644
>>> --- a/arch/arm/mach-mmp/sram.c
>>> +++ b/arch/arm/mach-mmp/sram.c
>>> @@ -21,6 +21,7 @@
>>>   #include<linux/err.h>
>>>   #include<linux/slab.h>
>>>   #include<linux/genalloc.h>
>>> +#include<asm/mach/map.h>
>>>
>>>   #include<mach/sram.h>
>>>
>>> @@ -87,7 +88,8 @@ static int __devinit sram_probe(struct
>>> platform_device *pdev)
>>>
>>>         info->sram_phys   = (phys_addr_t)res->start;
>>>         info->sram_size   = resource_size(res);
>>> -       info->sram_virt   = ioremap(info->sram_phys,
>>> info->sram_size);
>>> +       info->sram_virt   = __arm_ioremap(info->sram_phys,
>>> info->sram_size,
>>> +                                         MT_MEMORY);
>>
>> I doubt MT_MEMORY is intended for use with __arm_ioremap(). There
>> could be other way around to the L_PTE_XN bit.
>>
>> One other way I'm actually thinking of is to add the SRAM mapping to
>> mmp_map_io(). The difference of SRAM offset/size may result the
>> separation of mmp_map_io() into {pxa168,pxa910,mmp2}_map_io()
>> if necessary.
>>
>
> I guess I don't follow.  I think you're talking about adding it to the
> standard_io_desc array, but that would require having it pre-mapped and
> knowing the virtual address.  Or were you planning to ioremap it?

I missed the L_PTE_XN bit.
The patch is originally for audio sram, so use the ioremap is ok for 
that. But for the internal sram we should need the different mapping 
property.

so far, the standard_io_desc is shared by pxa168/pxa910/mmp2;
we can not add the sram's entry into it for now sram is only dedicated
to mmp2; just like Eric's suggestion, we need mmp2_map_io() only for
mmp2, and add the sram's entries into the structure.
if so, we need transfer the mapped info into the sram module,
and sram module just keep the info and do not need remap it again.

so what's your opinion?
