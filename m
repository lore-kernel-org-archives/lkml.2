Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0DOKbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:31:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44539 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab0DOKb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:31:29 -0400
Date: Thu, 15 Apr 2010 11:31:10 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if
	current is kswapd
Message-ID: <20100415103109.GC10966@csn.ul.ie>
References: <20100415013436.GO2493@dastard> <20100415130212.D16E.A69D9226@jp.fujitsu.com> <20100415131106.D174.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100415131106.D174.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 01:11:37PM +0900, KOSAKI Motohiro wrote:
> Now, vmscan pageout() is one of IO throuput degression source.
> Some IO workload makes very much order-0 allocation and reclaim
> and pageout's 4K IOs are making annoying lots seeks.
> 
> At least, kswapd can avoid such pageout() because kswapd don't
> need to consider OOM-Killer situation. that's no risk.
> 

Well, there is some risk here. Direct reclaimers may not be cleaning
more pages than it had to previously except it splices subsystems
together increasing stack usage and causing further problems.

It might not cause OOM-killer issues but it could increase the time
dirty pages spend on the LRU.

Am I missing something?

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3ff3311..d392a50 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -614,6 +614,13 @@ static enum page_references page_check_references(struct page *page,
>  	if (referenced_page)
>  		return PAGEREF_RECLAIM_CLEAN;
>  
> +	/*
> +	 * Delegate pageout IO to flusher thread. They can make more
> +	 * effective IO pattern.
> +	 */
> +	if (current_is_kswapd())
> +		return PAGEREF_RECLAIM_CLEAN;
> +
>  	return PAGEREF_RECLAIM;
>  }
>  
> -- 
> 1.6.5.2
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
