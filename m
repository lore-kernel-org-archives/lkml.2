Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1KVALb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:11:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1KVALa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:11:30 -0500
Date: Tue, 22 Nov 2011 01:11:27 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111122001127.GG4017@quack.suse.cz>
References: <20111121130342.211953629@intel.com>
 <20111121131215.905222115@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121131215.905222115@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-11-11 21:03:45, Wu Fengguang wrote:
> When dd in 512bytes, generic_perform_write() calls
> balance_dirty_pages_ratelimited() 8 times for the same page, but
> obviously the page is only dirtied once.
> 
> Fix it by accounting nr_dirtied at page dirty time.
  Well, but after this change, the interface balance_dirty_ratelimited_nr()
is strange because the argument is only used for per-CPU ratelimiting and
not for per-task ratelimiting... So if you do this switch then I'd also
switch bdp_ratelimits to get consistent results and a clean interface and
completely kill balance_dirty_pages_ratelimited_nr().

								Honza

> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-11-17 20:57:13.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-11-17 20:57:15.000000000 +0800
> @@ -1224,8 +1224,6 @@ void balance_dirty_pages_ratelimited_nr(
>  	if (bdi->dirty_exceeded)
>  		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
>  
> -	current->nr_dirtied += nr_pages_dirtied;
> -
>  	preempt_disable();
>  	/*
>  	 * This prevents one CPU to accumulate too many dirtied pages without
> @@ -1734,6 +1732,7 @@ void account_page_dirtied(struct page *p
>  		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
>  		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
>  		task_io_account_write(PAGE_CACHE_SIZE);
> +		current->nr_dirtied++;
>  	}
>  }
>  EXPORT_SYMBOL(account_page_dirtied);
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
