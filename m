Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab0ENGso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:48:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47324 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab0ENGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:48:41 -0400
Message-ID: <4BECF158.5070200@oracle.com>
Date: Thu, 13 May 2010 23:44:40 -0700
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
Subject: Re: [PATCH 15/35] x86, lmb: Add lmb_reserve_area_overlap_ok()
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-16-git-send-email-yinghai@kernel.org> <1273804337.21352.396.camel@pasglop>
In-Reply-To: <1273804337.21352.396.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BECF1F9.0119:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 07:32 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
>> Some areas from firmware could be reserved several times from different callers.
>>
>> If these area are overlapped, We may have overlapped entries in lmb.reserved.
>>
>> Try to free the area at first, before rerserve them again.
> 
> I have already told you to make this a property of lmb_reserve() instead
> of adding that function with a terrible name.

make every lmb_reserve() call lmb_free at first?

> 
> Cheers,
> Ben.
> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/include/asm/lmb.h |    1 +
>>  arch/x86/mm/lmb.c          |   18 ++++++++++++++++++
>>  2 files changed, 19 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
>> index dd42ac1..9329e09 100644
>> --- a/arch/x86/include/asm/lmb.h
>> +++ b/arch/x86/include/asm/lmb.h
>> @@ -7,6 +7,7 @@ u64 lmb_find_area_size(u64 start, u64 *sizep, u64 align);
>>  void lmb_to_bootmem(u64 start, u64 end);
>>  
>>  void lmb_reserve_area(u64 start, u64 end, char *name);
>> +void lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name);
>>  void lmb_free_area(u64 start, u64 end);
>>  void lmb_add_memory(u64 start, u64 end);
>>  struct range;
>> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
>> index 19a5f49..1100c18 100644
>> --- a/arch/x86/mm/lmb.c
>> +++ b/arch/x86/mm/lmb.c
>> @@ -309,6 +309,24 @@ void __init lmb_reserve_area(u64 start, u64 end, char *name)
>>  	lmb_add_region(&lmb.reserved, start, end - start);
>>  }
>>  
>> +/*
>> + * Could be used to avoid having overlap entries in lmb.reserved.region.
>> + *  Don't need to use it with area that is from lmb_find_area()
>> + *  Only use it for the area that fw hidden area.
>> + */
>> +void __init lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name)
>> +{
>> +	if (start == end)
>> +		return;
>> +
>> +	if (WARN_ONCE(start > end, "lmb_reserve_area_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
>> +		return;
>> +
>> +	/* Free that region at first */
>> +	lmb_free(start, end - start);
>> +	lmb_add_region(&lmb.reserved, start, end - start);
>> +}
>> +
>>  void __init lmb_free_area(u64 start, u64 end)
>>  {
>>  	if (start == end)
> 

