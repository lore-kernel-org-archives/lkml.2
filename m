Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0EJSON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:14:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42411 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab0EJSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:14:08 -0400
Message-ID: <4BE84BE7.1020404@oracle.com>
Date: Mon, 10 May 2010 11:09:43 -0700
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
Subject: Re: [PATCH 05/22] lmb: Add lmb_reserve_area/lmb_free_area
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>	 <1273331860-14325-6-git-send-email-yinghai@kernel.org> <1273475438.23699.74.camel@pasglop>
In-Reply-To: <1273475438.23699.74.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4BE84C97.0042:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 12:10 AM, Benjamin Herrenschmidt wrote:
> On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
>> They will check if the region array is big enough.
>>
>> __check_and_double_region_array will try to double the region array if that
>> array spare slots is not big enough.  Old array will be copied to new array.
>>
>> Arch code should set lmb.default_alloc_limit accordingly, so the new array is in
>> accessiable address.
> 
> More issues...
> 
>> +static void __init __check_and_double_region_array(struct lmb_region *type,
>> +			 struct lmb_property *static_region)
>> +{
>> +	u64 size, mem;
>> +	struct lmb_property *new, *old;
>> +	unsigned long rgnsz = type->nr_regions;
>> +
>> +	/* Do we have enough slots left ? */
>> +	if ((rgnsz - type->cnt) > 2)
>> +		return;
>> +
>> +	old = type->region;
>> +	/* Double the array size */
>> +	size = sizeof(struct lmb_property) * rgnsz * 2;
>> +
>> +	mem = __lmb_alloc_base(size, sizeof(struct lmb_property), lmb.default_alloc_limit);
>> +	if (mem == 0)
>> +		panic("can not find more space for lmb.reserved.region array");
> 
> Now, that is not right because we do memory hotplug. Thus lmb_add() must
> be able to deal with things running past LMB init.
> 
> slab_is_available() will do the job for now, unless somebody has bootmem
> and tries to lmb_add() memory while bootmem is active, but screw that
> for now. See the code I'll post tonight.
> 
>> +	new = __va(mem);
>> +	/* Copy old to new */
>> +	memcpy(&new[0], &old[0], sizeof(struct lmb_property) * rgnsz);
>> +	memset(&new[rgnsz], 0, sizeof(struct lmb_property) * rgnsz);
>> +
>> +	memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
>> +	type->region = new;
>> +	type->nr_regions = rgnsz * 2;
>> +	printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld at [%llx - %llx]\n",
>> +		type->nr_regions, mem, mem + size - 1);
>> +
>> +	/* Free old one ?*/
>> +	if (old != static_region)
>> +		lmb_free(__pa(old), sizeof(struct lmb_property) * rgnsz);
>> +}
> 
> Similar comment, don't bother if slab is available.
> 
>> +void __init lmb_add_memory(u64 start, u64 end)
>> +{
>> +	lmb_add_region(&lmb.memory, start, end - start);
>> +	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0]);
>> +}
> 
> So you duplicate lmb_add() gratuituously ? 
> 
>> +void __init lmb_reserve_area(u64 start, u64 end, char *name)
>> +{
>> +	if (start == end)
>> +		return;
>> +
>> +	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
>> +		return;
>> +
>> +	lmb_add_region(&lmb.reserved, start, end - start);
>> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
>> +}
> 
> And lmb_reserve() ?
> 
> Do we want to end up with 5 copies of the same API with subtle
> differences just for fun ?

those functions have __init markers, and only can be used on boot stage. so do need to worry about hotplug mem.

what I do is: use current lmb code for x86, and keep the affects to original lmb users to minimum. (should be near 0)

YH
