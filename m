Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2GXOtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:49:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44249 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2GXOtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:49:04 -0400
Message-ID: <500EB594.3000303@ti.com>
Date: Tue, 24 Jul 2012 10:47:48 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nico@linaro.org>, <will.deacon@arm.com>, <catalin.marinas@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 17/23] ARM: add machine desc hook for early memory/paging
 initialization
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <1343092165-9470-18-git-send-email-cyril@ti.com> <201207241432.27790.arnd@arndb.de>
In-Reply-To: <201207241432.27790.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for looking at this, Arnd.

On 7/24/2012 10:32 AM, Arnd Bergmann wrote:
> On Tuesday 24 July 2012, Cyril Chemparathy wrote:
>> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
>> index 0b1c94b..49e9c2a 100644
>> --- a/arch/arm/include/asm/mach/arch.h
>> +++ b/arch/arm/include/asm/mach/arch.h
>> @@ -39,6 +39,7 @@ struct machine_desc {
>>                                           struct meminfo *);
>>          void                    (*reserve)(void);/* reserve mem blocks  */
>>          void                    (*map_io)(void);/* IO mapping function  */
>> +       void                    (*init_meminfo)(void);
>>          void                    (*init_early)(void);
>>          void                    (*init_irq)(void);
>>          struct sys_timer        *timer;         /* system tick timer    */
>> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>> index e15d83b..7cbe292 100644
>> --- a/arch/arm/kernel/setup.c
>> +++ b/arch/arm/kernel/setup.c
>> @@ -964,6 +964,9 @@ void __init setup_arch(char **cmdline_p)
>>
>>          parse_early_param();
>>
>> +       if (mdesc->init_meminfo)
>> +               mdesc->init_meminfo();
>> +
>>          sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
>>          sanity_check_meminfo();
>>          arm_memblock_init(&meminfo, mdesc);
>
> The function pointers in that structure are ordered by execution time,
> and you call init_meminfo just before ->reserve, so it should go there.
>

Sure.  Will update.

> I wonder if it's better to just do the setup in the reserve callback,
> which would be a slight abuse of that interface but also keep down
> the number of early callbacks.
>

We need to switch the phys offset before sanity_check_meminfo() mangles 
the meminfo banks.

If we were to do this switch over in reserve(), we'd need to go back and 
fixup things that happen between the current location and reserve(). 
For example, we'd need to fix up the memblock regions.

-- 
Thanks
- Cyril
