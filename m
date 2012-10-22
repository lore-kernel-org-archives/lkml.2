Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2JVOVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:21:49 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50695 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2JVOVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:21:47 -0400
Date: Mon, 22 Oct 2012 10:21:44 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] x86, mm: Use big page size for small memory range
Message-ID: <20121022142143.GC14193@konrad-lan.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350593430-24470-5-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:50:12PM -0700, Yinghai Lu wrote:
> We could map small range in the middle of big range at first, so should use
> big page size at first to avoid using small page size to break down page table.
> 
> Only can set big page bit when that range has ram area around it.

The code looks good.

I would alter the description to say:

(Describe the problem)

"We are wasting entries in the page-table b/c are not taking advantage
of the fact that adjoining ranges could be of the same type and
coalescing them together. Instead we end up using the small size type."

(Explain your patch).

"We fix this by iterating over the ranges, detecting whether the
ranges that are next to each other are of the same type - and if so
set them to our type."

> 
> -v2: fix 32bit boundary checking. We can not count ram above max_low_pfn
> 	for 32 bit.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index c12dfd5..09ce38f 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -88,6 +88,40 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
>  	return nr_range;
>  }
>  
> +/*
> + * adjust the page_size_mask for small range to go with
> + *	big page size instead small one if nearby are ram too.
> + */
> +static void __init_refok adjust_range_page_size_mask(struct map_range *mr,
> +							 int nr_range)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_range; i++) {
> +		if ((page_size_mask & (1<<PG_LEVEL_2M)) &&
> +		    !(mr[i].page_size_mask & (1<<PG_LEVEL_2M))) {
> +			unsigned long start = round_down(mr[i].start, PMD_SIZE);
> +			unsigned long end = round_up(mr[i].end, PMD_SIZE);
> +
> +#ifdef CONFIG_X86_32
> +			if ((end >> PAGE_SHIFT) > max_low_pfn)
> +				continue;
> +#endif
> +
> +			if (memblock_is_region_memory(start, end - start))
> +				mr[i].page_size_mask |= 1<<PG_LEVEL_2M;
> +		}
> +		if ((page_size_mask & (1<<PG_LEVEL_1G)) &&
> +		    !(mr[i].page_size_mask & (1<<PG_LEVEL_1G))) {
> +			unsigned long start = round_down(mr[i].start, PUD_SIZE);
> +			unsigned long end = round_up(mr[i].end, PUD_SIZE);
> +
> +			if (memblock_is_region_memory(start, end - start))
> +				mr[i].page_size_mask |= 1<<PG_LEVEL_1G;
> +		}
> +	}
> +}
> +
>  static int __meminit split_mem_range(struct map_range *mr, int nr_range,
>  				     unsigned long start,
>  				     unsigned long end)
> @@ -182,6 +216,9 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
>  		nr_range--;
>  	}
>  
> +	if (!after_bootmem)
> +		adjust_range_page_size_mask(mr, nr_range);
> +
>  	for (i = 0; i < nr_range; i++)
>  		printk(KERN_DEBUG " [mem %#010lx-%#010lx] page %s\n",
>  				mr[i].start, mr[i].end - 1,
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
