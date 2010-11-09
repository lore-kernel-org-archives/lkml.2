Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0KIVjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:39:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0KIVjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:39:42 -0500
Date: Tue, 9 Nov 2010 22:39:40 +0100
From: Jan Kara <jack@suse.cz>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        esandeen@redhat.com, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
Message-ID: <20101109213940.GG4936@quack.suse.cz>
References: <20101109114422.3918e7f6@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109114422.3918e7f6@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-11-10 11:44:22, Rik van Riel wrote:
> Temporary IO failures, eg. due to loss of both multipath paths, can
> permanently leave the PageError bit set on a page, resulting in
> msync or fsync returning -EIO over and over again, even if IO is
> now getting to the disk correctly.
> 
> We already clear the AS_ENOSPC and AS_IO bits in mapping->flags in
> the filemap_fdatawait_range function.  Also clearing the PageError
> bit on the page allows subsequent msync or fsync calls on this file
> to return without an error, if the subsequent IO succeeds.
> 
> Unfortunately data written out in the msync or fsync call that
> returned -EIO can still get lost, because the page dirty bit appears
> to not get restored on IO error.  However, the alternative could be
> potentially all of memory filling up with uncleanable dirty pages,
> hanging the system, so there is no nice choice here...
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
  The patch looks OK to me so feel free to add
Acked-by: Jan Kara <jack@suse.cz>

But I'd like to talk about what you write in the last paragraph because
that is bugging me for some time as well and I believe we *should* find a
reasonable answer to that.

As you write above, it's not a big deal to keep page with IO error dirty
but we have to come up with a reasonable way for kernel to eventually get
rid of dirty pages it is unable to write. I think it is possible to handle
without any in-kernel magic. The most common case is when the device just
does not respond for some time - all processes writing to the device would
soon block in balance_dirty_pages() so they don't bring the kernel OOM.
Then we just need to provide for userspace a way to discard all pages
backed by given device including dirty pages - that way userspace could
tell, when there's no way the device is going back and processes would get
unblocked and start getting EIO. Only userspace would have to be careful
not to get blocked in balance_dirty_pages() while trying to prune the
cache.

I think this would be good enough, what do you think?

								Honza

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 5f38c46..4805fde 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -198,7 +198,7 @@ static inline int __TestClearPage##uname(struct page *page) { return 0; }
>  struct page;	/* forward declaration */
>  
>  TESTPAGEFLAG(Locked, locked) TESTSETFLAG(Locked, locked)
> -PAGEFLAG(Error, error)
> +PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
>  PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
>  PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
>  PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 61ba5e4..ba27b83 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -296,7 +296,7 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
>  				continue;
>  
>  			wait_on_page_writeback(page);
> -			if (PageError(page))
> +			if (TestClearPageError(page))
>  				ret = -EIO;
>  		}
>  		pagevec_release(&pvec);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
