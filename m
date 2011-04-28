Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab1D1Is3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:48:29 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60869 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab1D1Is0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:48:26 -0400
Date: Thu, 28 Apr 2011 10:48:20 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 2/8] compaction: make isolate_lru_page with filter aware
Message-ID: <20110428084820.GH12437@cmpxchg.org>
References: <cover.1303833415.git.minchan.kim@gmail.com>
 <4dc5e63cfc8672426336e43dea29057d5bb6e863.1303833417.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dc5e63cfc8672426336e43dea29057d5bb6e863.1303833417.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:25:19AM +0900, Minchan Kim wrote:
> In async mode, compaction doesn't migrate dirty or writeback pages.
> So, it's meaningless to pick the page and re-add it to lru list.
> 
> Of course, when we isolate the page in compaction, the page might
> be dirty or writeback but when we try to migrate the page, the page
> would be not dirty, writeback. So it could be migrated. But it's
> very unlikely as isolate and migration cycle is much faster than
> writeout.
> 
> So, this patch helps cpu and prevent unnecessary LRU churning.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/compaction.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index dea32e3..9f80b5a 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -335,7 +335,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
>  		}
>  
>  		/* Try isolate the page */
> -		if (__isolate_lru_page(page, ISOLATE_BOTH, 0, 0, 0) != 0)
> +		if (__isolate_lru_page(page, ISOLATE_BOTH, 0, !cc->sync, 0) != 0)
>  			continue;

With the suggested flags argument from 1/8, this would look like:

	flags = ISOLATE_BOTH;
	if (!cc->sync)
		flags |= ISOLATE_CLEAN;

?

Anyway, nice change indeed!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
