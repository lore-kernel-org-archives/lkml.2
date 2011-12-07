Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1LGQJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:09:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab1LGQJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:09:10 -0500
Date: Wed, 7 Dec 2011 17:09:08 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] writeback: fix dirtied pages accounting on redirty
Message-ID: <20111207160908.GK4622@quack.suse.cz>
References: <20111128135338.249672012@intel.com>
 <20111128140513.401344389@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128140513.401344389@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-11-11 21:53:42, Wu Fengguang wrote:
> De-account the accumulative dirty counters on page redirty.
> 
> Page redirties (very common in ext4) will introduce mismatch between
> counters (a) and (b)
> 
> a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
> b) NR_WRITTEN, BDI_WRITTEN
> 
> This will introduce systematic errors in balanced_rate and result in
> dirty page position errors (ie. the dirty pages are no longer balanced
> around the global/bdi setpoints).
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  You can add:

  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  include/linux/writeback.h |    2 ++
>  mm/page-writeback.c       |   19 +++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-11-28 21:23:23.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-11-28 21:23:24.000000000 +0800
> @@ -1806,6 +1806,24 @@ int __set_page_dirty_nobuffers(struct pa
>  EXPORT_SYMBOL(__set_page_dirty_nobuffers);
>  
>  /*
> + * Call this whenever redirtying a page, to de-account the dirty counters
> + * (NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied), so that they match the written
> + * counters (NR_WRITTEN, BDI_WRITTEN) in long term. The mismatches will lead to
> + * systematic errors in balanced_dirty_ratelimit and the dirty pages position
> + * control.
> + */
> +void account_page_redirty(struct page *page)
> +{
> +	struct address_space *mapping = page->mapping;
> +	if (mapping && mapping_cap_account_dirty(mapping)) {
> +		current->nr_dirtied--;
> +		dec_zone_page_state(page, NR_DIRTIED);
> +		dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
> +	}
> +}
> +EXPORT_SYMBOL(account_page_redirty);
> +
> +/*
>   * When a writepage implementation decides that it doesn't want to write this
>   * page for some reason, it should redirty the locked page via
>   * redirty_page_for_writepage() and it should then unlock the page and return 0
> @@ -1813,6 +1831,7 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers
>  int redirty_page_for_writepage(struct writeback_control *wbc, struct page *page)
>  {
>  	wbc->pages_skipped++;
> +	account_page_redirty(page);
>  	return __set_page_dirty_nobuffers(page);
>  }
>  EXPORT_SYMBOL(redirty_page_for_writepage);
> --- linux-next.orig/include/linux/writeback.h	2011-11-28 21:23:20.000000000 +0800
> +++ linux-next/include/linux/writeback.h	2011-11-28 21:23:24.000000000 +0800
> @@ -197,6 +197,8 @@ void writeback_set_ratelimit(void);
>  void tag_pages_for_writeback(struct address_space *mapping,
>  			     pgoff_t start, pgoff_t end);
>  
> +void account_page_redirty(struct page *page);
> +
>  /* pdflush.c */
>  extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
>  				   read-only. */
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
