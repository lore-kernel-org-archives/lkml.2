Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0HAIgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 04:36:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:12956 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab0HAIgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 04:36:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,297,1278313200"; 
   d="scan'208";a="823646179"
Date: Sun, 1 Aug 2010 16:35:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [PATCH] vmscan: remove wait_on_page_writeback() from pageout()
Message-ID: <20100801083541.GA14397@localhost>
References: <20100728185457.4A82.A69D9226@jp.fujitsu.com>
 <20100801052758.GB7515@localhost>
 <20100801172600.4AFF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801172600.4AFF.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 04:32:01PM +0800, KOSAKI Motohiro wrote:
> > On Wed, Jul 28, 2010 at 05:59:55PM +0800, KOSAKI Motohiro wrote:
> > > > On Wed, Jul 28, 2010 at 06:43:41PM +0900, KOSAKI Motohiro wrote:
> > > > > > On Wed, Jul 28, 2010 at 04:46:54PM +0800, Wu Fengguang wrote:
> > > > > > > The wait_on_page_writeback() call inside pageout() is virtually dead code.
> > > > > > > 
> > > > > > >         shrink_inactive_list()
> > > > > > >           shrink_page_list(PAGEOUT_IO_ASYNC)
> > > > > > >             pageout(PAGEOUT_IO_ASYNC)
> > > > > > >           shrink_page_list(PAGEOUT_IO_SYNC)
> > > > > > >             pageout(PAGEOUT_IO_SYNC)
> > > > > > > 
> > > > > > > Because shrink_page_list/pageout(PAGEOUT_IO_SYNC) is always called after
> > > > > > > a preceding shrink_page_list/pageout(PAGEOUT_IO_ASYNC), the first
> > > > > > > pageout(ASYNC) converts dirty pages into writeback pages, the second
> > > > > > > shrink_page_list(SYNC) waits on the clean of writeback pages before
> > > > > > > calling pageout(SYNC). The second shrink_page_list(SYNC) can hardly run
> > > > > > > into dirty pages for pageout(SYNC) unless in some race conditions.
> > > > > > > 
> > > > > > 
> > > > > > It's possible for the second call to run into dirty pages as there is a
> > > > > > congestion_wait() call between the first shrink_page_list() call and the
> > > > > > second. That's a big window.
> > > > > > 
> > > > > > > And the wait page-by-page behavior of pageout(SYNC) will lead to very
> > > > > > > long stall time if running into some range of dirty pages.
> > > > > > 
> > > > > > True, but this is also lumpy reclaim which is depending on a contiguous
> > > > > > range of pages. It's better for it to wait on the selected range of pages
> > > > > > which is known to contain at least one old page than excessively scan and
> > > > > > reclaim newer pages.
> > > > > 
> > > > > Today, I was successful to reproduce the Andres's issue. and I disagree this
> > > > > opinion.
> > > > 
> > > > Is Andres's issue not covered by the patch "vmscan: raise the bar to
> > > > PAGEOUT_IO_SYNC stalls" because wait_on_page_writeback() was the
> > > > main problem?
> > > 
> > > Well, "vmscan: raise the bar to PAGEOUT_IO_SYNC stalls" is completely bandaid and
> > 
> > No joking. The (DEF_PRIORITY-2) is obviously too permissive and shall be fixed.
> > 
> > > much IO under slow USB flash memory device still cause such problem even if the patch is applied.
> > 
> > As for this patch, raising the bar to PAGEOUT_IO_SYNC reduces both
> > calls to congestion_wait() and wait_on_page_writeback(). So it
> > absolutely helps by itself.
> > 
> > > But removing wait_on_page_writeback() doesn't solve the issue perfectly because current
> > > lumpy reclaim have multiple sick. again, I'm writing explaining mail.....
> > 
> > Let's submit the two known working fixes first?
> 
> Definitely, I can't oppose obvious test result (by another your mail) :-)
> 
> OK, should go!

Great. Shall I go first? My changelog has more background :)

Thanks,
Fengguang
