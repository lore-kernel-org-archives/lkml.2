Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1FUFtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 01:49:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33794 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1FUFtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 01:49:16 -0400
Message-ID: <4E0030DB.6000208@cs.helsinki.fi>
Date: Tue, 21 Jun 2011 08:49:15 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Subject: Re: [Q] mm/memblock.c: cast truncates bits from RED_INACTIVE
References: <ADE657CA350FB648AAC2C43247A983F001F382220E0F@AUSP01VMBX24.collaborationhost.net> <20110620170249.d5cd98b1.akpm@linux-foundation.org> <ADE657CA350FB648AAC2C43247A983F001F38227BF35@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F38227BF35@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/11 3:31 AM, H Hartley Sweeten wrote:
> On Monday, June 20, 2011 5:03 PM, Andrew Morton wrote:
>> On Tue, 14 Jun 2011 19:47:19 -0500 H Hartley Sweeten wrote:
>>
>>> Hello all,
>>>
>>> Sparse is reporting a couple warnings in mm/memblock.c:
>>>
>>> 	warning: cast truncates bits from constant value (9f911029d74e35b becomes 9d74e35b)
>>>
>>> The warnings are due to the cast of RED_INACTIVE in memblock_analyze():
>>>
>>> 	/* Check marker in the unused last array entry */
>>> 	WARN_ON(memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS].base
>>> 		!= (phys_addr_t)RED_INACTIVE);
>>> 	WARN_ON(memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS].base
>>> 		!= (phys_addr_t)RED_INACTIVE);
>>>
>>> And in memblock_init():
>>>
>>> 	/* Write a marker in the unused last array entry */
>>> 	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
>>> 	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
>>>
>>> Could this cause any problems?  If not, is there anyway to quiet the sparse noise?
>>>
>>
>> It's all just a debugging check and that check will continue to work OK
>> despite this bug.
>>
>> But yes, it's ugly and should be fixed.
>>
>> I don't think that mm/memblock.c should have reused RED_INACTIVE.
>> That's a slab thing and wedging it into a phys_addr_t was
>> inappropriate.
>>
>> In fact I don't think RED_INACTIVE should exist.  It's just inviting
>> other subsystems to (ab)use it.  It should be replaced by a
>> slab-specific SLAB_RED_INACTIVE, as slub did with SLUB_RED_INACTIVE.
>>
>>
>> I'd suggest something like the below, which I didn't test.  Feel free to
>> send it back at me, or ignore it ;)
>>
>>
>> diff -puN include/linux/poison.h~a include/linux/poison.h
>> --- a/include/linux/poison.h~a
>> +++ a/include/linux/poison.h
>> @@ -40,6 +40,12 @@
>>   #define	RED_INACTIVE	0x09F911029D74E35BULL	/* when obj is inactive */
>>   #define	RED_ACTIVE	0xD84156C5635688C0ULL	/* when obj is active */
>>
>> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
>> +#define MEMBLOCK_INACTIVE	0x3a84fb0144c9e71bULL
>> +#else
>> +#define MEMBLOCK_INACTIVE	0x44c9e71bUL
>> +#endif
>> +
>>   #define SLUB_RED_INACTIVE	0xbb
>>   #define SLUB_RED_ACTIVE		0xcc
>>
>> diff -puN mm/memblock.c~a mm/memblock.c
>> --- a/mm/memblock.c~a
>> +++ a/mm/memblock.c
>> @@ -758,9 +758,9 @@ void __init memblock_analyze(void)
>>
>>   	/* Check marker in the unused last array entry */
>>   	WARN_ON(memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS].base
>> -		!= (phys_addr_t)RED_INACTIVE);
>> +		!= MEMBLOCK_INACTIVE);
>>   	WARN_ON(memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS].base
>> -		!= (phys_addr_t)RED_INACTIVE);
>> +		!= MEMBLOCK_INACTIVE);
>>
>>   	memblock.memory_size = 0;
>>
>> @@ -786,8 +786,8 @@ void __init memblock_init(void)
>>   	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
>>
>>   	/* Write a marker in the unused last array entry */
>> -	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
>> -	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
>> +	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = MEMBLOCK_INACTIVE;
>> +	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = MEMBLOCK_INACTIVE;
>>
>>   	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
>>   	 * This simplifies the memblock_add() code below...
>
> FWIW, your patch above quiet's the sparse warnings on my system (arm ep93xx) and
> the system boots and runs fine.
>
> If you want it..
>
> Tested-by: H Hartley Sweeten<hsweeten@visionengravers.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
