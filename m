Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1K2OlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:41:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab1K2OlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:41:20 -0500
Date: Tue, 29 Nov 2011 15:41:19 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] readahead: tag mmap page fault call sites
Message-ID: <20111129144119.GL5635@quack.suse.cz>
References: <20111129130900.628549879@intel.com>
 <20111129131456.405886521@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129131456.405886521@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-11-11 21:09:04, Wu Fengguang wrote:
> Introduce a bit field ra->for_mmap for tagging mmap reads.
> The tag will be cleared immediate after submitting the IO.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  Looks OK.
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  include/linux/fs.h |    1 +
>  mm/filemap.c       |    6 +++++-
>  mm/readahead.c     |    1 +
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> --- linux-next.orig/include/linux/fs.h	2011-11-29 10:12:19.000000000 +0800
> +++ linux-next/include/linux/fs.h	2011-11-29 10:13:08.000000000 +0800
> @@ -947,6 +947,7 @@ struct file_ra_state {
>  	unsigned int ra_pages;		/* Maximum readahead window */
>  	u16 mmap_miss;			/* Cache miss stat for mmap accesses */
>  	u8 pattern;			/* one of RA_PATTERN_* */
> +	unsigned int for_mmap:1;	/* readahead for mmap accesses */
>  
>  	loff_t prev_pos;		/* Cache last read() position */
>  };
> --- linux-next.orig/mm/filemap.c	2011-11-29 09:48:49.000000000 +0800
> +++ linux-next/mm/filemap.c	2011-11-29 10:13:08.000000000 +0800
> @@ -1592,6 +1592,7 @@ static void do_sync_mmap_readahead(struc
>  		return;
>  
>  	if (VM_SequentialReadHint(vma)) {
> +		ra->for_mmap = 1;
>  		page_cache_sync_readahead(mapping, ra, file, offset,
>  					  ra->ra_pages);
>  		return;
> @@ -1611,6 +1612,7 @@ static void do_sync_mmap_readahead(struc
>  	/*
>  	 * mmap read-around
>  	 */
> +	ra->for_mmap = 1;
>  	ra->pattern = RA_PATTERN_MMAP_AROUND;
>  	ra_pages = max_sane_readahead(ra->ra_pages);
>  	ra->start = max_t(long, 0, offset - ra_pages / 2);
> @@ -1636,9 +1638,11 @@ static void do_async_mmap_readahead(stru
>  		return;
>  	if (ra->mmap_miss > 0)
>  		ra->mmap_miss--;
> -	if (PageReadahead(page))
> +	if (PageReadahead(page)) {
> +		ra->for_mmap = 1;
>  		page_cache_async_readahead(mapping, ra, file,
>  					   page, offset, ra->ra_pages);
> +	}
>  }
>  
>  /**
> --- linux-next.orig/mm/readahead.c	2011-11-29 09:48:49.000000000 +0800
> +++ linux-next/mm/readahead.c	2011-11-29 10:13:08.000000000 +0800
> @@ -267,6 +267,7 @@ unsigned long ra_submit(struct file_ra_s
>  	actual = __do_page_cache_readahead(mapping, filp,
>  					ra->start, ra->size, ra->async_size);
>  
> +	ra->for_mmap = 0;
>  	return actual;
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
