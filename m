Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0ENGct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:32:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58942 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab0ENGcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:32:47 -0400
Message-ID: <4BECEDAA.9070009@oracle.com>
Date: Thu, 13 May 2010 23:28:58 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/35] x86, lmb: Add lmb_find_area_size()
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-6-git-send-email-yinghai@kernel.org> <1273803621.21352.368.camel@pasglop>
In-Reply-To: <1273803621.21352.368.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BECEE66.00FC:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 07:20 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
>> size is returned according free range.
>> Will be used to find free ranges for early_memtest and memory corruption check
> 
> Please provide a better explanation of what these functions do. It's
> very unclear from the code (which looks like it could be a lot simpler),
> and the name of the function is totally obscure as well.

this just line by line translation from early_res version to lmb changes

please focus on lmb core at this point.

> 
> We have asked you how many times to improve on your changeset comments
> at the -very-least- ? Explain what functions do and why they do it, and
> when I say explain, I don't mean 2 lines of rot13. I mean actual
> sentences that a human being can read and have a chance to understand.
> 
> Also, I would appreciate if you picked up the habit of adding docbook
> doco for any API function you add, even if it's in the x86 "internal"
> file.
> 
> Cheers,
> Ben.
> 
>> Do not mess it up with mm/lmb.c yet.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/include/asm/lmb.h |    8 ++++
>>  arch/x86/mm/Makefile       |    2 +
>>  arch/x86/mm/lmb.c          |   88 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 98 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/x86/include/asm/lmb.h
>>  create mode 100644 arch/x86/mm/lmb.c
>>
>> diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
>> new file mode 100644
>> index 0000000..aa3a66e
>> --- /dev/null
>> +++ b/arch/x86/include/asm/lmb.h
>> @@ -0,0 +1,8 @@
>> +#ifndef _X86_LMB_H
>> +#define _X86_LMB_H
>> +
>> +#define ARCH_DISCARD_LMB
>> +
>> +u64 lmb_find_area_size(u64 start, u64 *sizep, u64 align);
>> +
>> +#endif
>> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
>> index a4c7683..8ab0505 100644
>> --- a/arch/x86/mm/Makefile
>> +++ b/arch/x86/mm/Makefile
>> @@ -26,4 +26,6 @@ obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
>>  obj-$(CONFIG_K8_NUMA)		+= k8topology_64.o
>>  obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
>>  
>> +obj-$(CONFIG_HAVE_LMB)		+= lmb.o
>> +
>>  obj-$(CONFIG_MEMTEST)		+= memtest.o
>> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
>> new file mode 100644
>> index 0000000..9d26eed
>> --- /dev/null
>> +++ b/arch/x86/mm/lmb.c
>> @@ -0,0 +1,88 @@
>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +#include <linux/init.h>
>> +#include <linux/bitops.h>
>> +#include <linux/lmb.h>
>> +#include <linux/bootmem.h>
>> +#include <linux/mm.h>
>> +#include <linux/range.h>
>> +
>> +/* Check for already reserved areas */
>> +static inline bool __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
>> +{
>> +	int i;
>> +	u64 addr = *addrp, last;
>> +	u64 size = *sizep;
>> +	bool changed = false;
>> +again:
>> +	last = addr + size;
>> +	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.regions[i].size; i++) {
>> +		struct lmb_region *r = &lmb.reserved.regions[i];
>> +		if (last > r->base && addr < r->base) {
>> +			size = r->base - addr;
>> +			changed = true;
>> +			goto again;
>> +		}
>> +		if (last > (r->base + r->size) && addr < (r->base + r->size)) {
>> +			addr = round_up(r->base + r->size, align);
>> +			size = last - addr;
>> +			changed = true;
>> +			goto again;
>> +		}
>> +		if (last <= (r->base + r->size) && addr >= r->base) {
>> +			(*sizep)++;
>> +			return false;
>> +		}
>> +	}
>> +	if (changed) {
>> +		*addrp = addr;
>> +		*sizep = size;
>> +	}
>> +	return changed;
>> +}
>> +
>> +static u64 __init __lmb_find_area_size(u64 ei_start, u64 ei_last, u64 start,
>> +			 u64 *sizep, u64 align)
>> +{
>> +	u64 addr, last;
>> +
>> +	addr = round_up(ei_start, align);
>> +	if (addr < start)
>> +		addr = round_up(start, align);
>> +	if (addr >= ei_last)
>> +		goto out;
>> +	*sizep = ei_last - addr;
>> +	while (bad_addr_size(&addr, sizep, align) && addr + *sizep <= ei_last)
>> +		;
>> +	last = addr + *sizep;
>> +	if (last > ei_last)
>> +		goto out;
>> +
>> +	return addr;
>> +
>> +out:
>> +	return LMB_ERROR;
>> +}
>> +
>> +/*
>> + * Find next free range after *start
>> + */
>> +u64 __init lmb_find_area_size(u64 start, u64 *sizep, u64 align)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < lmb.memory.cnt; i++) {
>> +		u64 ei_start = lmb.memory.regions[i].base;
>> +		u64 ei_last = ei_start + lmb.memory.regions[i].size;
>> +		u64 addr;
>> +
>> +		addr = __lmb_find_area_size(ei_start, ei_last, start,
>> +					 sizep, align);
>> +
>> +		if (addr != LMB_ERROR)
>> +			return addr;
>> +	}
>> +
>> +	return LMB_ERROR;
>> +}
>> +
> 

