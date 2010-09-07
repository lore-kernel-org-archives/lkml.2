Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0IHAZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:25:34 -0400
Received: from kroah.org ([198.145.64.141]:51495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab0IHAZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:25:30 -0400
Date: Tue, 7 Sep 2010 16:59:05 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cachefiles, mpage_cleardirty addtition, west bridge
	related
Message-ID: <20100907235905.GE12823@kroah.com>
References: <1283888011.7250.17.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283888011.7250.17.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 12:33:31PM -0700, David Cross wrote:
> This patch adds the mpage_cleardirty function to the cachefiles implementation in the kernel.
> The purpose behind this patch is to allow for file based DMA through an external DMA engine
> without the data ever going through the process. The procedure for the usage of this function 
> is as follows:
> 1) User space allocates and maps a file
> 2) external DMA device transfers the data to non-volatile storage directly without it going through 
>    the processor
> 3) the "dirty" pages must be cleared and invalidated as they do not contain correct information.
> 
> I believe that David is the correct maintainer and am hoping that he is willing to ACK this change. Please let me know 
> if there are any issues or concerns with this patch or if I should be
> asking a different maintainer to ack.
> Thanks,
> David
> 
> Signed-off-by: David Cross <david.cross@cypress.com>
> 
> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/fs/mpage.c linux-next-incl-sdk/fs/mpage.c
> --- linux-next-vanilla/fs/mpage.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incl-sdk/fs/mpage.c	2010-09-07 11:52:39.000000000 -0700
> @@ -716,3 +716,50 @@ int mpage_writepage(struct page *page, g
>  	return ret;
>  }
>  EXPORT_SYMBOL(mpage_writepage);
> +
> +int mpage_cleardirty(struct address_space *mapping, int num_pages)
> +{
> +	int ret = 0;
> +	int nr_pages;
> +	struct pagevec pvec;
> +	pgoff_t index = 0;
> +	pgoff_t end;
> +
> +	pagevec_init(&pvec, 0);
> +	index = mapping->writeback_index;
> +	end = index + num_pages;
> +
> +	while ((index <= end) &&
> +	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
> +				PAGECACHE_TAG_DIRTY, min(end - index,
> +					(pgoff_t)PAGEVEC_SIZE-1) + 1))) {
> +		unsigned i;
> +
> +		for (i = 0; i < nr_pages; i++) {
> +			struct page *page = pvec.pages[i];
> +
> +			lock_page(page);
> +			ret = clear_page_dirty_for_io(page);
> +			if (page_has_private(page))
> +				do_invalidatepage(page, 0);
> +
> +			cancel_dirty_page(page, PAGE_CACHE_SIZE);
> +
> +			remove_from_page_cache(page);
> +			ClearPageMappedToDisk(page);
> +			page_cache_release(page);	/* pagecache ref */
> +			unlock_page(page);
> +
> +			if (!ret) {
> +				printk(KERN_INFO "mpage_cleardirty: "
> +				"clear_page_dirty_for_io returned %d\n", ret);
> +				return ret;
> +			}
> +		}
> +		pagevec_release(&pvec);
> +		cond_resched();
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(mpage_cleardirty);

EXPORT_SYMBOL_GPL()?

thanks,

greg k-h
