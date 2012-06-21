Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2FUILf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:11:35 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49690 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2FUILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:11:31 -0400
X-AuditID: 9c930179-b7befae000006417-e1-4fe2d72fb9aa
Message-ID: <4FE2D73C.3060001@kernel.org>
Date: Thu, 21 Jun 2012 17:11:40 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, thp: abort compaction if migration page cannot be
 charged to memcg
References: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 03:52 PM, David Rientjes wrote:

> If page migration cannot charge the new page to the memcg,
> migrate_pages() will return -ENOMEM.  This isn't considered in memory
> compaction however, and the loop continues to iterate over all pageblocks
> trying in a futile attempt to continue migrations which are only bound to
> fail.


Hmm, it might be dumb question.
I imagine that pages in next pageblock could be in another memcg so it could be successful.
Why should we stop compaction once it fails to migrate pages in current pageblock/memcg?

> 
> This will short circuit and fail memory compaction if migrate_pages()
> returns -ENOMEM.  COMPACT_PARTIAL is returned in case some migrations
> were successful so that the page allocator will retry.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/compaction.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -701,8 +701,11 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>  		if (err) {
>  			putback_lru_pages(&cc->migratepages);
>  			cc->nr_migratepages = 0;
> +			if (err == -ENOMEM) {
> +				ret = COMPACT_PARTIAL;
> +				goto out;
> +			}
>  		}
> -
>  	}
>  
>  out:



-- 
Kind regards,
Minchan Kim
