Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab0GVJ07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:26:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34244 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0GVJ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:26:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 22 Jul 2010 18:22:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 4/8] vmscan: Do not writeback filesystem pages in direct
 reclaim
Message-Id: <20100722182204.81dddfa9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100722091930.GD13117@csn.ul.ie>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
	<1279545090-19169-5-git-send-email-mel@csn.ul.ie>
	<20100719221420.GA16031@cmpxchg.org>
	<20100720134555.GU13117@csn.ul.ie>
	<20100720220218.GE16031@cmpxchg.org>
	<20100721115250.GX13117@csn.ul.ie>
	<20100721210111.06dda351.kamezawa.hiroyu@jp.fujitsu.com>
	<20100721142710.GZ13117@csn.ul.ie>
	<20100722085734.ff252542.kamezawa.hiroyu@jp.fujitsu.com>
	<20100722091930.GD13117@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 10:19:30 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On Thu, Jul 22, 2010 at 08:57:34AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 21 Jul 2010 15:27:10 +0100
> > Mel Gorman <mel@csn.ul.ie> wrote:

> > 1 tick penalty seems too large. I hope we can have some waitqueue in future.
> > 
> 
> congestion_wait() if congestion occurs goes onto a waitqueue that is
> woken if congestion clears. I didn't measure it this time around but I
> doubt it waits for HZ/10 much of the time.
> 
Okay.

> > > > > -		nr_reclaimed += shrink_page_list(&page_list, sc, PAGEOUT_IO_SYNC);
> > > > > +			/*
> > > > > +			 * The attempt at page out may have made some
> > > > > +			 * of the pages active, mark them inactive again.
> > > > > +			 */
> > > > > +			nr_active = clear_active_flags(&page_list, NULL);
> > > > > +			count_vm_events(PGDEACTIVATE, nr_active);
> > > > > +	
> > > > > +			nr_reclaimed += shrink_page_list(&page_list, sc,
> > > > > +						PAGEOUT_IO_SYNC, &nr_dirty);
> > > > > +		}
> > > > 
> > > > Just a question. This PAGEOUT_IO_SYNC has some meanings ?
> > > > 
> > > 
> > > Yes, in pageout it will wait on pages currently being written back to be
> > > cleaned before trying to reclaim them.
> > > 
> > Hmm. IIUC, this routine is called only when !current_is_kswapd() and
> > pageout is done only whne current_is_kswapd(). So, this seems ....
> > Wrong ?
> > 
> 
> Both direct reclaim and kswapd can reach shrink_inactive_list
> 
> Direct reclaim
> do_try_to_free_pages
>   -> shrink_zones
>     -> shrink_zone
>       -> shrink_list
>         -> shrink_inactive list <--- the routine in question
> 
> Kswapd
> balance_pgdat
>   -> shrink_zone
>     -> shrink_list
>       -> shrink_inactive_list
> 
> pageout() is still called by direct reclaim if the page is anon so it
> will synchronously wait on those if PAGEOUT_IO_SYNC is set. 

Ah, ok. I missed that. Thank you for kindly clarification.

Thanks,
-Kame

