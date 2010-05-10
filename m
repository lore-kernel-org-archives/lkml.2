Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0EJHMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 03:12:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:40658 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab0EJHM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 03:12:28 -0400
Subject: Re: [PATCH 05/22] lmb: Add lmb_reserve_area/lmb_free_area
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273331860-14325-6-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-6-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 17:10:38 +1000
Message-ID: <1273475438.23699.74.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
> They will check if the region array is big enough.
> 
> __check_and_double_region_array will try to double the region array if that
> array spare slots is not big enough.  Old array will be copied to new array.
> 
> Arch code should set lmb.default_alloc_limit accordingly, so the new array is in
> accessiable address.

More issues...

> +static void __init __check_and_double_region_array(struct lmb_region *type,
> +			 struct lmb_property *static_region)
> +{
> +	u64 size, mem;
> +	struct lmb_property *new, *old;
> +	unsigned long rgnsz = type->nr_regions;
> +
> +	/* Do we have enough slots left ? */
> +	if ((rgnsz - type->cnt) > 2)
> +		return;
> +
> +	old = type->region;
> +	/* Double the array size */
> +	size = sizeof(struct lmb_property) * rgnsz * 2;
> +
> +	mem = __lmb_alloc_base(size, sizeof(struct lmb_property), lmb.default_alloc_limit);
> +	if (mem == 0)
> +		panic("can not find more space for lmb.reserved.region array");

Now, that is not right because we do memory hotplug. Thus lmb_add() must
be able to deal with things running past LMB init.

slab_is_available() will do the job for now, unless somebody has bootmem
and tries to lmb_add() memory while bootmem is active, but screw that
for now. See the code I'll post tonight.

> +	new = __va(mem);
> +	/* Copy old to new */
> +	memcpy(&new[0], &old[0], sizeof(struct lmb_property) * rgnsz);
> +	memset(&new[rgnsz], 0, sizeof(struct lmb_property) * rgnsz);
> +
> +	memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
> +	type->region = new;
> +	type->nr_regions = rgnsz * 2;
> +	printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld at [%llx - %llx]\n",
> +		type->nr_regions, mem, mem + size - 1);
> +
> +	/* Free old one ?*/
> +	if (old != static_region)
> +		lmb_free(__pa(old), sizeof(struct lmb_property) * rgnsz);
> +}

Similar comment, don't bother if slab is available.

> +void __init lmb_add_memory(u64 start, u64 end)
> +{
> +	lmb_add_region(&lmb.memory, start, end - start);
> +	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0]);
> +}

So you duplicate lmb_add() gratuituously ? 

> +void __init lmb_reserve_area(u64 start, u64 end, char *name)
> +{
> +	if (start == end)
> +		return;
> +
> +	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
> +		return;
> +
> +	lmb_add_region(&lmb.reserved, start, end - start);
> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
> +}

And lmb_reserve() ?

Do we want to end up with 5 copies of the same API with subtle
differences just for fun ?

Cheers,
Ben.


