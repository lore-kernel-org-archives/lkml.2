Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0KITUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:20:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab0KITUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:20:11 -0500
Date: Tue, 9 Nov 2010 14:21:09 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        esandeen@redhat.com, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
Message-ID: <20101109142109.224267d0@corrin.poochiereds.net>
In-Reply-To: <20101109114422.3918e7f6@annuminas.surriel.com>
References: <20101109114422.3918e7f6@annuminas.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 11:44:22 -0500
Rik van Riel <riel@redhat.com> wrote:

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
> 
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

This does leave the page in sort of a funky state. The uptodate bit
will still probably be set, but the dirty bit won't be. The page will
be effectively "disconnected" from the backing store until someone
writes to it.

I suppose though that this is the best that can reasonably be done in
this situation however...

Acked-by: Jeff Layton <jlayton@redhat.com>
