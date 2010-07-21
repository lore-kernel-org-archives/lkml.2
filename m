Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab0GUO2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 10:28:55 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:47412 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338Ab0GUO2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 10:28:54 -0400
Date: Wed, 21 Jul 2010 16:28:44 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 4/8] vmscan: Do not writeback filesystem pages in direct
 reclaim
Message-ID: <20100721142819.GA10480@cmpxchg.org>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
 <1279545090-19169-5-git-send-email-mel@csn.ul.ie>
 <20100719221420.GA16031@cmpxchg.org>
 <20100720134555.GU13117@csn.ul.ie>
 <20100720220218.GE16031@cmpxchg.org>
 <20100721115250.GX13117@csn.ul.ie>
 <20100721130435.GH16031@cmpxchg.org>
 <20100721133857.GY13117@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721133857.GY13117@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 02:38:57PM +0100, Mel Gorman wrote:
> Here is an updated version. Thanks very much
> 
> ==== CUT HERE ====
> vmscan: Do not writeback filesystem pages in direct reclaim
> 
> When memory is under enough pressure, a process may enter direct
> reclaim to free pages in the same manner kswapd does. If a dirty page is
> encountered during the scan, this page is written to backing storage using
> mapping->writepage. This can result in very deep call stacks, particularly
> if the target storage or filesystem are complex. It has already been observed
> on XFS that the stack overflows but the problem is not XFS-specific.
> 
> This patch prevents direct reclaim writing back filesystem pages by checking
> if current is kswapd or the page is anonymous before writing back.  If the
> dirty pages cannot be written back, they are placed back on the LRU lists
> for either background writing by the BDI threads or kswapd. If in direct
> lumpy reclaim and dirty pages are encountered, the process will stall for
> the background flusher before trying to reclaim the pages again.
> 
> As the call-chain for writing anonymous pages is not expected to be deep
> and they are not cleaned by flusher threads, anonymous pages are still
> written back in direct reclaim.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>

Cool!

Except for one last tiny thing...

> @@ -858,7 +872,7 @@ keep:
>  
>  	free_page_list(&free_pages);
>  
> -	list_splice(&ret_pages, page_list);

This will lose all retry pages forever, I think.

> +	*nr_still_dirty = nr_dirty;
>  	count_vm_events(PGACTIVATE, pgactivate);
>  	return nr_reclaimed;
>  }

Otherwise,
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
