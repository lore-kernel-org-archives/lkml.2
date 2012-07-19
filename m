Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2GSBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:25:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2GSBZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:25:25 -0400
Date: Wed, 18 Jul 2012 18:29:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>, Rafael Aquini <aquini@linux.com>
Subject: Re: [PATCH v4 1/3] mm: introduce compaction and migration for
 virtio ballooned pages
Message-Id: <20120718182944.24f59012.akpm@linux-foundation.org>
In-Reply-To: <20120719010047.GD2313@t510.redhat.com>
References: <cover.1342485774.git.aquini@redhat.com>
	<49f828a9331c9b729fcf77226006921ec5bc52fa.1342485774.git.aquini@redhat.com>
	<20120718154605.cb0591bc.akpm@linux-foundation.org>
	<20120718230706.GB2313@t510.redhat.com>
	<20120718161239.9449e6b5.akpm@linux-foundation.org>
	<20120719010047.GD2313@t510.redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012 22:00:48 -0300 Rafael Aquini <aquini@redhat.com> wrote:

> > So the function needs a better name - one which communicates that it is
> > a balloon page *for the purposes of processing by the compaction code*. 
> > Making the function private to compaction.c would help with that, if
> > feasible.
> > 
> 
> How about this (adjusted) approach:

it fails checkpatch ;)

> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1629,8 +1629,7 @@ static inline unsigned int debug_guardpage_minorder(void)
> { return 0; }
>  static inline bool page_is_guard(struct page *page) { return false; }
>  #endif /* CONFIG_DEBUG_PAGEALLOC */
>  
> -#if (defined(CONFIG_VIRTIO_BALLOON) || \
> -	defined(CONFIG_VIRTIO_BALLOON_MODULE)) && defined(CONFIG_COMPACTION)
> +#if (defined(CONFIG_VIRTIO_BALLOON) ||defined(CONFIG_VIRTIO_BALLOON_MODULE))
>  extern bool putback_balloon_page(struct page *);
>  extern struct address_space *balloon_mapping;
>  
> @@ -1638,11 +1637,13 @@ static inline bool is_balloon_page(struct page *page)
>  {
>  	return (page->mapping && page->mapping == balloon_mapping);
>  }
> +#if defined(CONFIG_COMPACTION)
> +static inline bool balloon_compaction_enabled(void) { return true; }
>  #else
> -static inline bool is_balloon_page(struct page *page)       { return false; }
> -static inline bool isolate_balloon_page(struct page *page)  { return false; }
> -static inline bool putback_balloon_page(struct page *page)  { return false; }
> -#endif /* (VIRTIO_BALLOON || VIRTIO_BALLOON_MODULE) && COMPACTION */
> +static inline bool putback_balloon_page(struct page *page) { return false; }
> +static inline bool balloon_compaction_enabled(void) { return false; }
> +#endif /* CONFIG_COMPACTION */
> +#endif /* (CONFIG_VIRTIO_BALLOON || CONFIG_VIRTIO_BALLOON_MODULE) */
>  
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MM_H */
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 59c7bc5..f5f6a7d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -78,7 +78,8 @@ void putback_lru_pages(struct list_head *l)
>  		list_del(&page->lru);
>  		dec_zone_page_state(page, NR_ISOLATED_ANON +
>  				page_is_file_cache(page));
> -		if (unlikely(is_balloon_page(page)))
> +		if (unlikely(is_balloon_page(page)) &&
> +		    balloon_compaction_enabled())

well, that helps readability.  But what does is_balloon_page() return
when invoked on a balloon page when CONFIG_COMPACTION=n?  False,
methinks.

I think the code as you previously had it was OK, but the
is_balloon_page() name is misleading.  It really wants to be called
is_potentially_compactible_balloon_page() :( Maybe rename it to
compactible_balloon_page()?
