Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2DTS3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:29:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38237 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab2DTS3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:29:12 -0400
Date: Fri, 20 Apr 2012 11:29:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: yinghai@kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120420182907.GG32324@google.com>
References: <20120417155502.GE22687@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417155502.GE22687@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 05:55:02PM +0200, Michal Hocko wrote:
> Hi,
> I just come across the following condition in __alloc_bootmem_node_high
> which I have hard times to understand. I guess it is a bug and we need
> something like the following. But, to be honest, I have no idea why we
> care about those 128MB above MAX_DMA32_PFN.
> ---
>  mm/bootmem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 0131170..5adb072 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -737,7 +737,7 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
>  	/* update goal according ...MAX_DMA32_PFN */
>  	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
>  
> -	if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
> +	if (end_pfn > MAX_DMA32_PFN + (128 << (20 - PAGE_SHIFT)) &&
>  	    (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
>  		void *ptr;
>  		unsigned long new_goal;

Regardless of x86 not using it, this is a bug fix and this code path
seems to be used by mips at least.  Michal, can you please post proper
signed-off patch?  The code is simply trying to use memory above DMA32
limit if there seems to be enough space (128M) to avoid unnecessarily
using DMA32 memory.

Thanks.

-- 
tejun
