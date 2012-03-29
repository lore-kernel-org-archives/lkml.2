Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab2C2MZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:25:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab2C2MZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:25:44 -0400
Date: Thu, 29 Mar 2012 14:25:42 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Geunsik Lim <geunsik.lim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH, v2] Fix potentially derefencing uninitialized 'r'.
Message-ID: <20120329122450.GA30566@tiehlicka.suse.cz>
References: <1329814703-14398-1-git-send-email-geunsik.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329814703-14398-1-git-send-email-geunsik.lim@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-02-12 17:58:23, Geunsik Lim wrote:
> From: Geunsik Lim <geunsik.lim@samsung.com>

The warning seems to be bogus. The only caller is for_each_mem_pfn_range
and even if we had type->cnt == 0 we would return before accessing r.
I guess it would be more reasonable to silent the warning by
__maybe_unused.

> 
> v2: reorganize the code with better way to avoid compilation warning
> via the comment of Andrew Morton.
> 
> v1: struct memblock_region 'r' will not be initialized potentially
> because of while() condition in __next_mem_pfn_range()function.
> Solve the compilation warning related problem by initializing
> r data structure.
> 
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  mm/memblock.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 77b5f22..b8c40c5 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -673,14 +673,18 @@ void __init_memblock __next_mem_pfn_range(int *idx, int nid,
>  	struct memblock_type *type = &memblock.memory;
>  	struct memblock_region *r;
>  
> -	while (++*idx < type->cnt) {
> +	do {
>  		r = &type->regions[*idx];
>  
> +	   if (++*idx < type->cnt) {
>  		if (PFN_UP(r->base) >= PFN_DOWN(r->base + r->size))
>  			continue;
>  		if (nid == MAX_NUMNODES || nid == r->nid)
>  			break;
> -	}
> +	   } else
> +		break;
> +	} while (1);
> +
>  	if (*idx >= type->cnt) {
>  		*idx = -1;
>  		return;
> -- 
> 1.7.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
