Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab0GVAC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:02:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36984 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124Ab0GVACZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:02:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 22 Jul 2010 08:57:34 +0900
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
Message-Id: <20100722085734.ff252542.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100721142710.GZ13117@csn.ul.ie>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
	<1279545090-19169-5-git-send-email-mel@csn.ul.ie>
	<20100719221420.GA16031@cmpxchg.org>
	<20100720134555.GU13117@csn.ul.ie>
	<20100720220218.GE16031@cmpxchg.org>
	<20100721115250.GX13117@csn.ul.ie>
	<20100721210111.06dda351.kamezawa.hiroyu@jp.fujitsu.com>
	<20100721142710.GZ13117@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 15:27:10 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, Jul 21, 2010 at 09:01:11PM +0900, KAMEZAWA Hiroyuki wrote:
 
> > But, hmm, memcg will have to select to enter this rounine based on
> > the result of 1st memory reclaim.
> > 
> 
> It has the option of igoring pages being dirtied but I worry that the
> container could be filled with dirty pages waiting for flushers to do
> something.

I'll prepare dirty_ratio for memcg. It's not easy but requested by I/O cgroup
guys, too...


> 
> > >  
> > > -		/*
> > > -		 * The attempt at page out may have made some
> > > -		 * of the pages active, mark them inactive again.
> > > -		 */
> > > -		nr_active = clear_active_flags(&page_list, NULL);
> > > -		count_vm_events(PGDEACTIVATE, nr_active);
> > > +		while (nr_reclaimed < nr_taken && nr_dirty && dirty_retry--) {
> > > +			wakeup_flusher_threads(laptop_mode ? 0 : nr_dirty);
> > > +			congestion_wait(BLK_RW_ASYNC, HZ/10);
> > >  
> >
> > Congestion wait is required ?? Where the congestion happens ?
> > I'm sorry you already have some other trick in other patch.
> > 
> 
> It's to wait for the IO to occur.
> 
1 tick penalty seems too large. I hope we can have some waitqueue in future.



> > > -		nr_reclaimed += shrink_page_list(&page_list, sc, PAGEOUT_IO_SYNC);
> > > +			/*
> > > +			 * The attempt at page out may have made some
> > > +			 * of the pages active, mark them inactive again.
> > > +			 */
> > > +			nr_active = clear_active_flags(&page_list, NULL);
> > > +			count_vm_events(PGDEACTIVATE, nr_active);
> > > +	
> > > +			nr_reclaimed += shrink_page_list(&page_list, sc,
> > > +						PAGEOUT_IO_SYNC, &nr_dirty);
> > > +		}
> > 
> > Just a question. This PAGEOUT_IO_SYNC has some meanings ?
> > 
> 
> Yes, in pageout it will wait on pages currently being written back to be
> cleaned before trying to reclaim them.
> 
Hmm. IIUC, this routine is called only when !current_is_kswapd() and
pageout is done only whne current_is_kswapd(). So, this seems ....
Wrong ?

Thanks,
-Kame




