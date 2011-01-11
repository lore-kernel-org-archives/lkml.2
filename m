Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1AKFlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:41:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48843 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1AKFlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QpEFTs4iI9gzJuSVdwYJuPwT/7KqK8l8WEE+UwAkuc1/DyKgMHZXvHQ7F3Gb5mJ8we
         YQQId+USV2+KgR9hEvwhE/NwSSK6AhmmwePm2TYeW6mvBC6/ZdbJFSCFz8ZnjLrUZsGK
         I1P+IOLNurAnaf5NYSMNJJtN0FYa0n00RDA54=
Date: Tue, 11 Jan 2011 14:41:07 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
Message-ID: <20110111054107.GC2113@barrios-desktop>
References: <E1PbGxV-0001ug-2r@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PbGxV-0001ug-2r@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On Fri, Jan 07, 2011 at 07:22:41PM +0100, Miklos Szeredi wrote:
> Here's an updated patch, addressing the review comments.
> 
> Hiroyuki-san, can you please review the newly introduced
> mem_cgroup_replace_cache_page(), as I'm not fully familiar with the
> memory cgroup code.
> 
> Thanks,
> Miklos
> ---
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> Subject: mm: add replace_page_cache_page() function
> 
> This function basically does:
> 
>      remove_from_page_cache(old);
>      page_cache_release(old);
>      add_to_page_cache_locked(new);
> 
> Except it does this atomically, so there's no possibility for the
> "add" to fail because of a race.
> 
> This is used by fuse to move pages into the page cache.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/fuse/dev.c              |   10 +++------
>  include/linux/memcontrol.h |    8 +++++++
>  include/linux/pagemap.h    |    1 
>  mm/filemap.c               |   50 +++++++++++++++++++++++++++++++++++++++++++++
>  mm/memcontrol.c            |   38 ++++++++++++++++++++++++++++++++++
>  5 files changed, 101 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/mm/filemap.c
> ===================================================================
> --- linux-2.6.orig/mm/filemap.c	2011-01-07 17:53:39.000000000 +0100
> +++ linux-2.6/mm/filemap.c	2011-01-07 19:14:45.000000000 +0100
> @@ -390,6 +390,56 @@ int filemap_write_and_wait_range(struct
>  EXPORT_SYMBOL(filemap_write_and_wait_range);
>  
>  /**
> + * replace_page_cache_page - replace a pagecache page with a new one
> + * @old:	page to be replaced
> + * @new:	page to replace with
> + * @gfp_mask:	page allocation mode
> + *
> + * This function replaces a page in the pagecache with a new one.  On
> + * success it acquires the pagecache reference for the new page and
> + * drop it for the old page.  Both the old and new pages must be
> + * locked.  This function does not add the new page to the LRU, the
> + * caller must do that.
> + *
> + * The remove + add is atomic.  The only way this function can fail is
> + * memory allocation failure.
> + */
> +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> +{
> +	int error;
> +
> +	VM_BUG_ON(!PageLocked(old));
> +	VM_BUG_ON(!PageLocked(new));
> +	VM_BUG_ON(new->mapping);
> +
> +	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
> +	if (!error) {
> +		struct address_space *mapping = old->mapping;
> +		pgoff_t offset = old->index;
> +
> +		page_cache_get(new);
> +		new->mapping = mapping;
> +		new->index = offset;
> +
> +		spin_lock_irq(&mapping->tree_lock);
> +		__remove_from_page_cache(old);

Since v1, I tried to change page reference accouting semantics of
remove_from_page_cache. At last, it changes API name from __remove_from_page_cache
to __delete_from_page_cache.
So this conflicts my series.
If you are not urgent, could you resend based on my series after Andrew merges it?
Or if Andrew has a concern about my series and he merged your patch, I will resend
my series include fixing this part of your patch.

Please wait Andrew's next step.

-- 
Kind regards,
Minchan Kim
