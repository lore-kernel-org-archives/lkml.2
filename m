Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0G1Jns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:43:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34233 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0G1Jnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:43:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] vmscan: remove wait_on_page_writeback() from pageout()
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20100728091032.GD5300@csn.ul.ie>
References: <20100728084654.GA26776@localhost> <20100728091032.GD5300@csn.ul.ie>
Message-Id: <20100728183625.4A7F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 28 Jul 2010 18:43:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jul 28, 2010 at 04:46:54PM +0800, Wu Fengguang wrote:
> > The wait_on_page_writeback() call inside pageout() is virtually dead code.
> > 
> >         shrink_inactive_list()
> >           shrink_page_list(PAGEOUT_IO_ASYNC)
> >             pageout(PAGEOUT_IO_ASYNC)
> >           shrink_page_list(PAGEOUT_IO_SYNC)
> >             pageout(PAGEOUT_IO_SYNC)
> > 
> > Because shrink_page_list/pageout(PAGEOUT_IO_SYNC) is always called after
> > a preceding shrink_page_list/pageout(PAGEOUT_IO_ASYNC), the first
> > pageout(ASYNC) converts dirty pages into writeback pages, the second
> > shrink_page_list(SYNC) waits on the clean of writeback pages before
> > calling pageout(SYNC). The second shrink_page_list(SYNC) can hardly run
> > into dirty pages for pageout(SYNC) unless in some race conditions.
> > 
> 
> It's possible for the second call to run into dirty pages as there is a
> congestion_wait() call between the first shrink_page_list() call and the
> second. That's a big window.
> 
> > And the wait page-by-page behavior of pageout(SYNC) will lead to very
> > long stall time if running into some range of dirty pages.
> 
> True, but this is also lumpy reclaim which is depending on a contiguous
> range of pages. It's better for it to wait on the selected range of pages
> which is known to contain at least one old page than excessively scan and
> reclaim newer pages.

Today, I was successful to reproduce the Andres's issue. and I disagree this
opinion.
The root cause is, congestion_wait() mean "wait until clear io congestion". but
if the system have plenty dirty pages, flusher threads are issueing IO conteniously.
So, io congestion is not cleared long time. eventually, congestion_wait(BLK_RW_ASYNC, HZ/10)
become to equivalent to sleep(HZ/10).

I would propose followint patch instead.

And I've found synchronous lumpy reclaim have more serious problem. I woule like to
explain it as another mail.

Thanks.



>From 0266fb2c23aef659cd4e89fccfeb464f23257b74 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 27 Jul 2010 14:36:44 +0900
Subject: [PATCH] vmscan: synchronous lumpy reclaim don't call congestion_wait()

congestion_wait() mean "waiting for number of requests in IO queue is
under congestion threshold".
That said, if the system have plenty dirty pages, flusher thread push
new request to IO queue conteniously. So, IO queue are not cleared
congestion status for a long time. thus, congestion_wait(HZ/10) is
almostly equivalent schedule_timeout(HZ/10).

If the system 512MB memory, DEF_PRIORITY mean 128kB scan and 4096 times
shrink_inactive_list call. 4096 times 0.1sec stall makes crazy insane
long stall. That shouldn't.

In the other hand, this synchronous lumpy reclaim donesn't need this
congestion_wait() at all. shrink_page_list(PAGEOUT_IO_SYNC) cause to
call wait_on_page_writeback() and it provide sufficient waiting.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 97170eb..2aa16eb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1304,8 +1304,6 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 	 */
 	if (nr_reclaimed < nr_taken && !current_is_kswapd() &&
 			sc->lumpy_reclaim_mode) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
-
 		/*
 		 * The attempt at page out may have made some
 		 * of the pages active, mark them inactive again.
-- 
1.6.5.2




