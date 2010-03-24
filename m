Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0CXFsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:48:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:43439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0CXFsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:48:02 -0400
Message-ID: <4BA9A71F.7080801@kernel.org>
Date: Tue, 23 Mar 2010 22:46:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -v3 1/2] lmb: seperate region array from lmb_region
 struct
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org>	 <1269333587-1866-5-git-send-email-yinghai@kernel.org>	 <4BA899C2.8020208@kernel.org>  <20100323104241.GA1189@elte.hu> <1269405955.8599.156.camel@pasglop>
In-Reply-To: <1269405955.8599.156.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 09:45 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2010-03-23 at 11:42 +0100, Ingo Molnar wrote:
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>>  void __init lmb_init(void)
>>>  {
>>> +	lmb.memory.region   = lmb_memory_region;
>>> +	lmb.memory.region_array_size   = ARRAY_SIZE(lmb_memory_region);
>>> +	lmb.reserved.region = lmb_reserved_region;
>>> +	lmb.reserved.region_array_size = ARRAY_SIZE(lmb_reserved_region);
>>> +
>>
>> That's rather unreadable and has random whitespace noise.
>>
>> Should be something like:
>>
>> 	lmb.memory.region		= lmb_memory_region;
>> 	lmb.memory.region_array_size	= ARRAY_SIZE(lmb_memory_region);
>> 	lmb.reserved.region		= lmb_reserved_region;
>> 	lmb.reserved.region_array_size	= ARRAY_SIZE(lmb_reserved_region);
>>
>> also, i'd suggest to shorten region_array_size to region_size (we know it's an 
>> array), so it would become:
> 
> I dislike those arrays anyways. See my other message about turning them
> into lists, which would get rid of capacity constraints completely. What
> do you think ?
> 
2/2 introduce one new function that could double the array size

please check the v4.

the function rely on find_lmb_area().

it will check if there is enough space left, otherwise try to get new big array, and
copy old array to new array.

final function like:

static void __init __check_and_double_region_array(struct lmb_region *type,
			 struct lmb_property *static_region,
			 u64 ex_start, u64 ex_end)
{
	u64 start, end, size, mem;
	struct lmb_property *new, *old;
	unsigned long rgnsz = type->nr_regions;

	/* do we have enough slots left ? */
	if ((rgnsz - type->cnt) > max_t(unsigned long, rgnsz/8, 2))
		return;

	old = type->region;
	/* double it */
	mem = -1ULL;
	size = sizeof(struct lmb_property) * rgnsz * 2;
	if (old == static_region)
		start = 0;
	else
		start = __pa(old) + sizeof(struct lmb_property) * rgnsz;
	end = ex_start;
	if (start + size < end)
		mem = find_lmb_area(start, end, size,
					 sizeof(struct lmb_property));
	if (mem == -1ULL) {
		start = ex_end;
		end = get_max_mapped();
		if (start + size < end)
			mem = find_lmb_area(start, end, size, sizeof(struct lmb_property));
	}
	if (mem == -1ULL)
		panic("can not find more space for lmb.reserved.region array");

	new = __va(mem);
	/* copy old to new */
	memcpy(&new[0], &old[0], sizeof(struct lmb_property) * rgnsz);
	memset(&new[rgnsz], 0, sizeof(struct lmb_property) * rgnsz);

	memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
	type->region = new;
	type->nr_regions = rgnsz * 2;
	printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld at [%llx - %llx]\n",
		type->nr_regions, mem, mem + size - 1);

	/* reserve new array and free old one */
	lmb_reserve(mem, sizeof(struct lmb_property) * rgnsz * 2);
	if (old != static_region)
		lmb_free(__pa(old), sizeof(struct lmb_property) * rgnsz);
}

void __init add_lmb_memory(u64 start, u64 end)
{
	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0], start, end);
	lmb_add(start, end - start);
}

void __init reserve_early(u64 start, u64 end, char *name)
{
	if (start == end)
		return;

	if (WARN_ONCE(start > end, "reserve_early: wrong range [%#llx, %#llx]\n", start, end))
		return;

	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
	lmb_reserve(start, end - start);
}

void __init free_early(u64 start, u64 end)
{
	if (start == end)
		return;

	if (WARN_ONCE(start > end, "free_early: wrong range [%#llx, %#llx]\n", start, end))
		return;

	/* keep punching hole, could run out of slots too */
	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
	lmb_free(start, end - start);
}

with those function, we can replace the bootmem in x86.


Thanks

Yinghai
