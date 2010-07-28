Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0G1FBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:01:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:47538 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab0G1FBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:01:08 -0400
Subject: Re: [PATCH 03/16] x86, memblock: Add memblock_x86_to_bootmem()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1279824241-17582-4-git-send-email-yinghai@kernel.org>
References: <1279824241-17582-1-git-send-email-yinghai@kernel.org>
	 <1279824241-17582-4-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 15:00:36 +1000
Message-ID: <1280293236.1970.234.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:43 -0700, Yinghai Lu wrote:
> memblock_x86_to_bootmem() will reserve memblock.reserved.region in bootmem after bootmem is

> +#ifndef CONFIG_NO_BOOTMEM
> +void __init memblock_x86_to_bootmem(u64 start, u64 end)
> +{
> +	int count;
> +	u64 final_start, final_end;
> +	struct memblock_region *r;
> +
> +	/* Take out region array itself */
> +	if (memblock.reserved.regions != memblock_reserved_init_regions)
> +		memblock_free(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);

So that's why you export memblock_reserved_init_regions...

I really -really- don't like it. First of all, it's really gross to
free the array then walk it. We know it won't race but still ...
especially since you re-do the above every time
memblock_x86_to_bootmem() is called. Is it called more than once ? If
yes, then it's bogus. If not, then why have start,end ?

If you really want to free it, maybe best is to stick something in
mm/memblock.c that kicks in at late init time and does the freeing ?

I'm going to keep the exporting out of my branch for now. If you really
want it, you can always add it to this specific patch, but it sucks.

Ben.

> +	count  = memblock.reserved.cnt;
> +	pr_info("(%d early reservations) ==> bootmem [%010llx-%010llx]\n", count, start, end - 1);
> +	for_each_memblock(reserved, r) {
> +		pr_info("  [%010llx-%010llx] ", (u64)r->base, (u64)r->base + r->size - 1);
> +		final_start = max(start, r->base);
> +		final_end = min(end, r->base + r->size);
> +		if (final_start >= final_end) {
> +			pr_cont("\n");
> +			continue;
> +		}
> +		pr_cont(" ==> [%010llx-%010llx]\n", final_start, final_end - 1);
> +		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
> +	}
> +
> +	/* Put region array back ? */
> +	if (memblock.reserved.regions != memblock_reserved_init_regions)
> +		memblock_reserve(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
> +}
> +#endif


