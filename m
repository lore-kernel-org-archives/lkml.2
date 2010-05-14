Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0ENIXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:23:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:53694 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233Ab0ENIXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:23:38 -0400
Subject: Re: [PATCH 13/35] x86, lmb: Add lmb_free_memory_size()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECF0E2.90406@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-14-git-send-email-yinghai@kernel.org>
	 <1273804285.21352.392.camel@pasglop>  <4BECF0E2.90406@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:21:27 +1000
Message-ID: <1273825287.21352.592.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:42 -0700, Yinghai wrote:
> On 05/13/2010 07:31 PM, Benjamin Herrenschmidt wrote:
> > On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> >> It will return free memory size in specified range.
> >>
> >> We can not use memory_size - reserved_size here, because some reserved area
> >> may not be in the scope of lmb.memory.region.
> >>
> >> Use lmb.memory.region subtracting lmb.reserved.region to get free range array.
> >> then count size of all free ranges.
> > 
> > I remember having already told you that the naming sucks.
> 
> any suggestion?
> 
> i think this name is clear.

Well, I did have suggestions yes. Among others, because you are
operating on a range, you should have the word "range" in your name. For
example, something like lmb_free_memory_in_range(). A bit long but at
least is self explanatory and doesn't lead to confusion.
 
> > Also, you fail to explain what this is actually needed for.
> 
> needed by 
> 
> [PATCH 21/35] x86, lmb: Use lmb_memory_size()/lmb_free_memory_size() to get correct dma_reserve

Ok, that's some x86ism that I would need to study more closely, but it's
fair enough to have those accessors if they are really needed. But
please, try to make an effort on the naming.

Cheers,
Ben.

> 
> > 
> > Cheers,
> > Ben.
> > 
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> ---
> >>  arch/x86/include/asm/lmb.h |    1 +
> >>  arch/x86/mm/lmb.c          |   51 ++++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 52 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
> >> index 358d8a6..4fb94b5 100644
> >> --- a/arch/x86/include/asm/lmb.h
> >> +++ b/arch/x86/include/asm/lmb.h
> >> @@ -16,5 +16,6 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
> >>  					 unsigned long last_pfn);
> >>  u64 lmb_hole_size(u64 start, u64 end);
> >>  u64 lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
> >> +u64 lmb_free_memory_size(u64 addr, u64 limit);
> >>  
> >>  #endif
> >> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
> >> index c5fa1dd..6c69e99 100644
> >> --- a/arch/x86/mm/lmb.c
> >> +++ b/arch/x86/mm/lmb.c
> >> @@ -226,6 +226,57 @@ void __init lmb_to_bootmem(u64 start, u64 end)
> >>  }
> >>  #endif
> >>  
> >> +u64 __init lmb_free_memory_size(u64 addr, u64 limit)
> >> +{
> >> +	int i, count;
> >> +	struct range *range;
> >> +	int nr_range;
> >> +	u64 final_start, final_end;
> >> +	u64 free_size;
> >> +
> >> +	count = (lmb.reserved.cnt + lmb.memory.cnt) * 2;
> >> +
> >> +	range = find_range_array(count);
> >> +	nr_range = 0;
> >> +
> >> +	addr = PFN_UP(addr);
> >> +	limit = PFN_DOWN(limit);
> >> +
> >> +	for (i = 0; i < lmb.memory.cnt; i++) {
> >> +		struct lmb_region *r = &lmb.memory.regions[i];
> >> +
> >> +		final_start = PFN_UP(r->base);
> >> +		final_end = PFN_DOWN(r->base + r->size);
> >> +		if (final_start >= final_end)
> >> +			continue;
> >> +		if (final_start >= limit || final_end <= addr)
> >> +			continue;
> >> +
> >> +		nr_range = add_range(range, count, nr_range, final_start, final_end);
> >> +	}
> >> +	subtract_range(range, count, 0, addr);
> >> +	subtract_range(range, count, limit, -1ULL);
> >> +	for (i = 0; i < lmb.reserved.cnt; i++) {
> >> +		struct lmb_region *r = &lmb.reserved.regions[i];
> >> +
> >> +		final_start = PFN_DOWN(r->base);
> >> +		final_end = PFN_UP(r->base + r->size);
> >> +		if (final_start >= final_end)
> >> +			continue;
> >> +		if (final_start >= limit || final_end <= addr)
> >> +			continue;
> >> +
> >> +		subtract_range(range, count, final_start, final_end);
> >> +	}
> >> +	nr_range = clean_sort_range(range, count);
> >> +
> >> +	free_size = 0;
> >> +	for (i = 0; i < nr_range; i++)
> >> +		free_size += range[i].end - range[i].start;
> >> +
> >> +	return free_size << PAGE_SHIFT;
> >> +}
> >> +
> >>  void __init lmb_add_memory(u64 start, u64 end)
> >>  {
> >>  	lmb_add_region(&lmb.memory, start, end - start);
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


