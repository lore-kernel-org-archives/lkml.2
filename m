Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab0DMEr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:47:56 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:22894 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0DMEry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:47:54 -0400
Message-ID: <4BC3F6C8.4020303@oracle.com>
Date: Mon, 12 Apr 2010 21:44:56 -0700
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
Subject: Re: [PATCH 18/39] lmb: Add lmb_reserve_area_overlap_ok()
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>	 <1270793048-23796-19-git-send-email-yinghai@kernel.org> <1271132476.13059.66.camel@pasglop>
In-Reply-To: <1271132476.13059.66.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BC3F75D.00E9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 09:21 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
>> Some areas from firmware could be reserved several times from different callers.
>>
>> If these area are overlapped, We may have overlapped entries in lmb.reserved.
>>
>> Try to free the area at first, before rerserve them again.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
> 
>> +
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
>> +	__lmb_reserve_area(start, end, name);
>>  }
> 
> That is going to only work with one overlap. IE. lmb_free() will not do
> very well unless it's a one and only match.
> 
> You should modify it to work in a loop.
that is only for some special cases about area that is reserved for fw region.

and even there is overlapped area, it the code still can go through when lmb_to_bootmem or create range list for slab.
because they are using range array subtract.

> 
> Besides, lmb_reserve_area_overlap_ok() sucks as a name :-)

any suggestion for better name?

YH
