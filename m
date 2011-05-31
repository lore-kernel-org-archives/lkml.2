Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1EaNgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:36:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:37826 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1EaNgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:36:20 -0400
Date: Tue, 31 May 2011 15:36:11 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 03/10] Change isolate mode from int type to enum type
Message-ID: <20110531133611.GC3190@cmpxchg.org>
References: <cover.1306689214.git.minchan.kim@gmail.com>
 <6e08f148630ffe1e7fe6a4d31d4340a9a47f4473.1306689214.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e08f148630ffe1e7fe6a4d31d4340a9a47f4473.1306689214.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 03:13:42AM +0900, Minchan Kim wrote:
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -957,23 +957,29 @@ keep_lumpy:
>   *
>   * returns 0 on success, -ve errno on failure.
>   */
> -int __isolate_lru_page(struct page *page, int mode, int file)
> +int __isolate_lru_page(struct page *page, enum ISOLATE_PAGE_MODE mode,
> +							int file)
>  {
> +	int active;
>  	int ret = -EINVAL;
> +	BUG_ON(mode & ISOLATE_BOTH &&
> +		(mode & ISOLATE_INACTIVE || mode & ISOLATE_ACTIVE));
>  
>  	/* Only take pages on the LRU. */
>  	if (!PageLRU(page))
>  		return ret;
>  
> +	active = PageActive(page);
> +
>  	/*
>  	 * When checking the active state, we need to be sure we are
>  	 * dealing with comparible boolean values.  Take the logical not
>  	 * of each.
>  	 */
> -	if (mode != ISOLATE_BOTH && (!PageActive(page) != !mode))
> +	if (mode & ISOLATE_ACTIVE && !active)
>  		return ret;
>  
> -	if (mode != ISOLATE_BOTH && page_is_file_cache(page) != file)
> +	if (mode & ISOLATE_INACTIVE && active)
>  		return ret;

What happened to the check for file pages?
