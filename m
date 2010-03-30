Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0C3WoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:44:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:57099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab0C3WoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:44:14 -0400
Message-ID: <4BB27E52.80509@kernel.org>
Date: Tue, 30 Mar 2010 15:42:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>	 <1269901252.2286.11.camel@concordia> <1269905491.7101.40.camel@pasglop>	 <4BB13FDB.9060006@kernel.org> <1269926794.7101.46.camel@pasglop>	 <4BB19656.9040803@kernel.org> <1269984635.7101.59.camel@pasglop>
In-Reply-To: <1269984635.7101.59.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 02:30 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2010-03-29 at 23:12 -0700, Yinghai Lu wrote:
>>
>> 1. you want to reserve rangeA
>> 2. before that will check if region array is big enough,
>> 3. if region is not big enough, will call lmb_alloc to get new range.
>>    lmb_alloc could return rangB that is overlapped with rangeA
>> 4. current lmb_alloc only honor limit, and doesn't honor low limit.
> 
> I see. This is a direct consequence of you wanting to use find/reserve
> instead of alloc tho :-)
> 
> This is also easily fixed. Instead of doing the resize "on demand" like
> I originally proposed, do it at the end of reserve/alloc. If the number
> of free entries is down to 1 or 0, then alloc a new chunk.

already done. last night, Michael point that out.

> 
> Of course, all of that requires that reservations done from FW to take
> memory out because it must not be accessed need to be all done before
> the first grow of the array, and so the static array must be sized
> accordingly. We may want to catch these things too. We don't want to
> warn on multiple overlapping lmb_reserve() tho on powerpc...
>  
>> another usage is: for temporary buffer, like range array for
>> subtraction. we don't need to do free later.
> 
> Sorry, doesn't parse.
never mind.
> 
>>> Ie. It should all be one single find/allocation function.
>>>
>>> In fact, you want to split lmb_find from lmb_reserve, then just make
>>> lmb_alloc use the above, I don't want 2 implementations of the same
>>> thing (maybe call it __lmb_find to expose the fact that it's a low
>> level
>>> function to avoid for normal use).
>>
>> that is some difference between them, and lmb_alloc doesn't honor low
>> limit.
> 
> If you want a low and a high limit, then add the low limit to
> lmb_alloc_base(), it's easy to fix all callers, there aren't many, and
> make not one but two defaults for lmb_alloc(), one for the low limit and
> one for the high limit. Problem solved.

make 32 bit x86 can work from high to low now.

> 
>> we can provide
>> lmb_find_area
>> lmb_reserve_area
>> lmb_free_area
>>
>> and use lmb_find_area + lmb_reserve_area to get one lmb_alloc()
> 
> I still don't understand why you insist on using find + reserve instead
> of alloc in x86 land. Can you give me a proper explanation as to why
> that is needed since it seems to be causing problems, and so far and I
> don't see what it solves.
> 
>> x86 sometime is using find_lmb_area to find big area, and use those
>> area and later reserve actually used area.
> 
> That's very wrong. If you use something, alloc/reserve it. You can
> always free it later.
> 
>> you could use lmb_alloc, and later lmb_free not used. that is equal to
>> lmb_find + lmb_reserve + lmb_free ...
> 
> Sure, then just do alloc + later free.

ok, I will replace that later after it get stable.
but at first will expose the find_lmb_area.

will send out -v11, please check that version.

Thanks

Yinghai
