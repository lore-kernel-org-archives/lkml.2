Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2HKT4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 15:56:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35102 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2HKT4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 15:56:21 -0400
Date: Sat, 11 Aug 2012 12:56:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/5] x86: find_early_table_space based on memory ranges
 that are being mapped
Message-ID: <20120811195616.GE2874@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344547389-4599-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 09, 2012 at 04:23:06PM -0500, Jacob Shin wrote:
> Current logic finds enough space to cover number of tables from 0 to end.
> Instead, we only need to find enough space to cover from mr[0].start to
> mr[nr_range].end.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/mm/init.c |   57 +++++++++++++++++++++++++++-------------------------
>  1 file changed, 30 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index e0e6990..d4e01a7 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -35,40 +35,43 @@ struct map_range {
>  	unsigned page_size_mask;
>  };
>  
> -static void __init find_early_table_space(struct map_range *mr, unsigned long end,
> -					  int use_pse, int use_gbpages)
> +static void __init find_early_table_space(struct map_range *mr, int nr_range)
>  {
> -	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
> +	int i;
> +	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
> +	unsigned long start = 0, good_end;
>  	phys_addr_t base;
>  
> -	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
> -	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
> -
> -	if (use_gbpages) {
> -		unsigned long extra;
> +	for (i = 0; i < nr_range; i++) {
> +		unsigned long range, extra;
>  
> -		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
> -		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
> -	} else
> -		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
> -
> -	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
> +		range = mr[i].end - mr[i].start;
> +		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
>  
> -	if (use_pse) {
> -		unsigned long extra;
> +		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
> +			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
> +			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
> +		} else {
> +			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
> +		}
>  
> -		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
> +		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
> +			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
>  #ifdef CONFIG_X86_32
> -		extra += PMD_SIZE;
> +			extra += PMD_SIZE;
>  #endif
> -		/* The first 2/4M doesn't use large pages. */
> -		if (mr->start < PMD_SIZE)
> -			extra += mr->end - mr->start;
> -
> -		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -	} else
> -		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +			/* The first 2/4M doesn't use large pages. */
> +			if (mr[i].start < PMD_SIZE)
> +				extra += range;
> +
> +			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +		} else {
> +			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +		}
> +	}
>  
> +	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
> +	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);

It would really be great if you can sprinkle some comments explaining
what the function is trying to do and how it does that.  Functions
like this can be pretty difficult to extract higher-level concept out
of.

Thanks.

-- 
tejun
