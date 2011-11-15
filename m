Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1KOVkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:40:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43111 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab1KOVkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:40:45 -0500
Date: Tue, 15 Nov 2011 13:40:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Colin Cross <ccross@android.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <20111114140421.GA27150@suse.de>
Message-ID: <alpine.DEB.2.00.1111151332160.26232@chino.kir.corp.google.com>
References: <20111114140421.GA27150@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011, Mel Gorman wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9dd443d..5402897 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -127,6 +127,20 @@ void pm_restrict_gfp_mask(void)
>  	saved_gfp_mask = gfp_allowed_mask;
>  	gfp_allowed_mask &= ~GFP_IOFS;
>  }
> +
> +static bool pm_suspending(void)
> +{
> +	if ((gfp_allowed_mask & GFP_IOFS) == GFP_IOFS)
> +		return false;
> +	return true;
> +}
> +
> +#else
> +
> +static bool pm_suspending(void)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_PM_SLEEP */
>  
>  #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
> @@ -2214,6 +2228,14 @@ rebalance:
>  
>  			goto restart;
>  		}
> +
> +		/*
> +		 * Suspend converts GFP_KERNEL to __GFP_WAIT which can
> +		 * prevent reclaim making forward progress without
> +		 * invoking OOM. Bail if we are suspending
> +		 */
> +		if (pm_suspending())
> +			goto nopage;
>  	}
>  
>  	/* Check if we should retry the allocation */

This allows all __GFP_NOFAIL allocations to fail while 
pm_restrict_gfp_mask() is in effect, so I disagree with this unless it is 
moved into the should_alloc_retry() logic.  If you pass did_some_progress 
into that function and then moved the check for __GFP_NOFAIL right under 
the check for __GFP_NORETRY and checked for pm_suspending() there (and 
before the check for PAGE_ALLOC_COSTLY_ORDER) then it would allow the 
infinite loop for __GFP_NOFAIL which is required if __GFP_WAIT.
