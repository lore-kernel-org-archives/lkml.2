Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1LGKxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:53:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab1LGKxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:53:43 -0500
Date: Wed, 7 Dec 2011 11:53:40 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111207105340.GF4622@quack.suse.cz>
References: <20111128135338.249672012@intel.com>
 <20111128140513.275099009@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128140513.275099009@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-11-11 21:53:41, Wu Fengguang wrote:
> When dd in 512bytes, generic_perform_write() calls
> balance_dirty_pages_ratelimited() 8 times for the same page, but
> obviously the page is only dirtied once.
  Actually, for ppc where pages can be 64 KB the problem is even worse.

> Fix it by accounting tsk->nr_dirtied and bdp_ratelimits at page dirty time.
  I was wondering about one more thing - couldn't we rather check in
generic_perform_write() whether the page was dirty before calling
->write_end and call balance_dirty_pages_ratelimited() only if it wasn't?

  For generic_perform_write() it doesn't really matter that much since we
do things page-by-page anyway but other callers could be more efficient...

								Honza

> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-11-28 21:23:20.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-11-28 21:23:23.000000000 +0800
> @@ -1239,8 +1239,6 @@ void balance_dirty_pages_ratelimited_nr(
>  	if (bdi->dirty_exceeded)
>  		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
>  
> -	current->nr_dirtied += nr_pages_dirtied;
> -
>  	preempt_disable();
>  	/*
>  	 * This prevents one CPU to accumulate too many dirtied pages without
> @@ -1251,12 +1249,9 @@ void balance_dirty_pages_ratelimited_nr(
>  	p =  &__get_cpu_var(bdp_ratelimits);
>  	if (unlikely(current->nr_dirtied >= ratelimit))
>  		*p = 0;
> -	else {
> -		*p += nr_pages_dirtied;
> -		if (unlikely(*p >= ratelimit_pages)) {
> -			*p = 0;
> -			ratelimit = 0;
> -		}
> +	else if (unlikely(*p >= ratelimit_pages)) {
> +		*p = 0;
> +		ratelimit = 0;
>  	}
>  	/*
>  	 * Pick up the dirtied pages by the exited tasks. This avoids lots of
> @@ -1749,6 +1744,8 @@ void account_page_dirtied(struct page *p
>  		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
>  		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
>  		task_io_account_write(PAGE_CACHE_SIZE);
> +		current->nr_dirtied++;
> +		this_cpu_inc(bdp_ratelimits);
>  	}
>  }
>  EXPORT_SYMBOL(account_page_dirtied);
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
