Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab1FIN7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:59:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:45558 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364Ab1FIN7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:59:06 -0400
Date: Thu, 9 Jun 2011 14:59:02 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v3 03/10] Add additional isolation mode
Message-ID: <20110609135902.GV5247@suse.de>
References: <cover.1307455422.git.minchan.kim@gmail.com>
 <b72a86ed33c693aeccac0dba3fba8c13145106ab.1307455422.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <b72a86ed33c693aeccac0dba3fba8c13145106ab.1307455422.git.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 11:38:16PM +0900, Minchan Kim wrote:
> There are some places to isolate lru page and I believe
> users of isolate_lru_page will be growing.
> The purpose of them is each different so part of isolated pages
> should put back to LRU, again.
> 
> The problem is when we put back the page into LRU,
> we lose LRU ordering and the page is inserted at head of LRU list.
> It makes unnecessary LRU churning so that vm can evict working set pages
> rather than idle pages.
> 
> This patch adds new modes when we isolate page in LRU so we don't isolate pages
> if we can't handle it. It could reduce LRU churning.
> 
> This patch doesn't change old behavior. It's just used by next patches.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  include/linux/swap.h |    2 ++
>  mm/vmscan.c          |    6 ++++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 48d50e6..731f5dd 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -248,6 +248,8 @@ enum ISOLATE_MODE {
>  	ISOLATE_NONE,
>  	ISOLATE_INACTIVE = 1,	/* Isolate inactive pages */
>  	ISOLATE_ACTIVE = 2,	/* Isolate active pages */
> +	ISOLATE_CLEAN = 8,      /* Isolate clean file */
> +	ISOLATE_UNMAPPED = 16,  /* Isolate unmapped file */
>  };

This really should be a bitwise type like gfp_t.

>  
>  /* linux/mm/vmscan.c */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4cbe114..26aa627 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -990,6 +990,12 @@ int __isolate_lru_page(struct page *page, enum ISOLATE_MODE mode, int file)
>  
>  	ret = -EBUSY;
>  
> +	if (mode & ISOLATE_CLEAN && (PageDirty(page) || PageWriteback(page)))
> +		return ret;
> +
> +	if (mode & ISOLATE_UNMAPPED && page_mapped(page))
> +		return ret;
> +
>  	if (likely(get_page_unless_zero(page))) {
>  		/*
>  		 * Be careful not to clear PageLRU until after we're

This patch does notuse ISOLATE_CLEAN or ISOLATE_UMAPPED anywhere. While
I can guess how they will be used, it would be easier to review if one
patch introduced ISOLATE_CLEAN and updated the call sites where it was
relevant. Same with ISOLATE_UNMAPPED.

Also when using & like this, I thought the compiler warned if it wasn't
in parenthesis but maybe that's wrong. The problem is the operator
precedence for bitwise AND and logical AND is easy to forget as it's
so rarely an issue.

i.e. it's easy to forget if

mode & ISOLATE_UNMAPPED && page_mapped(page)

means

mode & (ISOLATE_UNMAPPED && page_mapped(page))

or

(mode & ISOLATE_UNMAPPED) && page_mapped(page)

Be nice and specific for this one.

-- 
Mel Gorman
SUSE Labs
