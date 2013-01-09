Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3AIHKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:10:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56229 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab3AIHKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:10:13 -0500
X-AuditID: 9c930179-b7c7fae00000255c-26-50ed17d21174
Date: Wed, 9 Jan 2013 16:10:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Sonny Rao <sonnyrao@google.com>, Bryan Freed <bfreed@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm: prevent to add a page to swap if may_writepage
 is unset
Message-ID: <20130109071010.GA27890@blaptop>
References: <1357712474-27595-1-git-send-email-minchan@kernel.org>
 <1357712474-27595-2-git-send-email-minchan@kernel.org>
 <20130109065612.GB8550@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109065612.GB8550@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Wed, Jan 09, 2013 at 01:56:12AM -0500, Johannes Weiner wrote:
> On Wed, Jan 09, 2013 at 03:21:13PM +0900, Minchan Kim wrote:
> > Recently, Luigi reported there are lots of free swap space when
> > OOM happens. It's easily reproduced on zram-over-swap, where
> > many instance of memory hogs are running and laptop_mode is enabled.
> > 
> > Luigi reported there was no problem when he disabled laptop_mode.
> > The problem when I investigate problem is following as.
> > 
> > try_to_free_pages disable may_writepage if laptop_mode is enabled.
> > shrink_page_list adds lots of anon pages in swap cache by
> > add_to_swap, which makes pages Dirty and rotate them to head of
> > inactive LRU without pageout. If it is repeated, inactive anon LRU
> > is full of Dirty and SwapCache pages.
> > 
> > In case of that, isolate_lru_pages fails because it try to isolate
> > clean page due to may_writepage == 0.
> > 
> > The may_writepage could be 1 only if total_scanned is higher than
> > writeback_threshold in do_try_to_free_pages but unfortunately,
> > VM can't isolate anon pages from inactive anon lru list by
> > above reason and we already reclaimed all file-backed pages.
> > So it ends up OOM killing.
> > 
> > This patch prevents to add a page to swap cache unnecessary when
> > may_writepage is unset so anoymous lru list isn't full of
> > Dirty/Swapcache page. So VM can isolate pages from anon lru list,
> > which ends up setting may_writepage to 1 and could swap out
> > anon lru pages. When OOM triggers, I confirmed swap space was full.
> > 
> > Reported-by: Luigi Semenzato <semenzato@google.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> We used to ignore the page's writeback state on isolation in the past,
> could you include a reference to since when this problem has been in

Good idea.
It has existed since f80c067[mm: zone_reclaim: make isolate_lru_page() filter-aware]
I will write down it in changelog.

> the tree?  Also, would it make sense to tag it for one of the stable
> trees?

If Luigi confirmed it, I will Cc stable@vger.kernel.org in next spin.
Thanks!

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
