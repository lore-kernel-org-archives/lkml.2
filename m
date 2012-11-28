Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2K1QwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:52:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38290 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2K1QvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:51:06 -0500
Date: Wed, 28 Nov 2012 11:50:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 06/46] x86, mm: Change find_early_table_space()
 paramters
Message-ID: <20121128165007.GE21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <1353123563-3103-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123563-3103-7-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


s/paramters/parameters/

On Fri, Nov 16, 2012 at 07:38:43PM -0800, Yinghai Lu wrote:
> call split_mem_range inside the function.

So this looks to introduce an extra split_mem_range which
does the same operations on 'mr' that is done in find_early_table_space.

Could the find_early_table_space use the init_memory_mapping
'mr' and 'nr_range'?

This is the call chain:
	nr_range = split_mem_range(mr, nr_range, start, end)

	..
	if (!after_bootmem)
		find_early_table_space(..)
			nr_rnage = split_mem_range(mr, nr_range, start, end)

Perhaps you could modify find_early_table_space to just return
the nr_range (and also use the 'mr')?

And then you would do:

	if (!after_bootmem)
		nr_range = find_early_table_space(..)
	else {
		memset(mr, 0, sizeof(mr));
        	nr_range = split_mem_range(mr, 0, start, end);
	}


Ah, I see you redid this in the next patch. Can you then point
this out in the commit description please? Say:

"The patch: x86, mm: Find early page table buffer together
tidies this up so we do not end up calling split_mem_range twice."


> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index dbef4ff..51f919f 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -196,12 +196,18 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
>   * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
>   * pages. Then find enough contiguous space for those page tables.
>   */
> -static void __init find_early_table_space(struct map_range *mr, int nr_range)
> +static void __init find_early_table_space(unsigned long start, unsigned long end)
>  {
>  	int i;
>  	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
> -	unsigned long start = 0, good_end;
> +	unsigned long good_end;
>  	phys_addr_t base;
> +	struct map_range mr[NR_RANGE_MR];
> +	int nr_range;
> +
> +	memset(mr, 0, sizeof(mr));
> +	nr_range = 0;
> +	nr_range = split_mem_range(mr, nr_range, start, end);
>  
>  	for (i = 0; i < nr_range; i++) {
>  		unsigned long range, extra;
> @@ -276,7 +282,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	 * nodes are discovered.
>  	 */
>  	if (!after_bootmem)
> -		find_early_table_space(mr, nr_range);
> +		find_early_table_space(start, end);
>  
>  	for (i = 0; i < nr_range; i++)
>  		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
> -- 
> 1.7.7
