Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab0H1WLD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 18:11:03 -0400
Received: from cobra.newdream.net ([66.33.216.30]:56972 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab0H1WLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 18:11:01 -0400
Date: Sat, 28 Aug 2010 15:11:51 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Michael Rubin <mrubin@google.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, fengguang.wu@intel.com, jack@suse.cz,
        riel@redhat.com, akpm@linux-foundation.org, david@fromorbit.com,
        kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, hch@lst.de,
        axboe@kernel.dk
Subject: Re: [PATCH 1/4] mm: exporting account_page_dirty
In-Reply-To: <1282963227-31867-2-git-send-email-mrubin@google.com>
Message-ID: <Pine.LNX.4.64.1008281511130.22399@cobra.newdream.net>
References: <1282963227-31867-1-git-send-email-mrubin@google.com>
 <1282963227-31867-2-git-send-email-mrubin@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one was just merged with the other Ceph stuff.

Thanks!
sage


On Fri, 27 Aug 2010, Michael Rubin wrote:

> This allows code outside of the mm core to safely manipulate page state
> and not worry about the other accounting. Not using these routines means
> that some code will lose track of the accounting and we get bugs. This
> has happened once already.
> 
> Modified cephs to use the interface.
> 
> Signed-off-by: Michael Rubin <mrubin@google.com>
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> ---
>  fs/ceph/addr.c      |    8 +-------
>  mm/page-writeback.c |    1 +
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 5598a0d..420d469 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -105,13 +105,7 @@ static int ceph_set_page_dirty(struct page *page)
>  	spin_lock_irq(&mapping->tree_lock);
>  	if (page->mapping) {	/* Race with truncate? */
>  		WARN_ON_ONCE(!PageUptodate(page));
> -
> -		if (mapping_cap_account_dirty(mapping)) {
> -			__inc_zone_page_state(page, NR_FILE_DIRTY);
> -			__inc_bdi_stat(mapping->backing_dev_info,
> -					BDI_RECLAIMABLE);
> -			task_io_account_write(PAGE_CACHE_SIZE);
> -		}
> +		account_page_dirtied(page, page->mapping);
>  		radix_tree_tag_set(&mapping->page_tree,
>  				page_index(page), PAGECACHE_TAG_DIRTY);
>  
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 7262aac..9d07a8d 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1131,6 +1131,7 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
>  		task_io_account_write(PAGE_CACHE_SIZE);
>  	}
>  }
> +EXPORT_SYMBOL(account_page_dirtied);
>  
>  /*
>   * For address_spaces which do not use buffers.  Just tag the page as dirty in
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
