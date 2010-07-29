Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0G2Ke0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:34:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45322 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0G2KeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:34:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: Why PAGEOUT_IO_SYNC stalls for a long time
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
In-Reply-To: <20100728131017.GI5300@csn.ul.ie>
References: <20100728191322.4A85.A69D9226@jp.fujitsu.com> <20100728131017.GI5300@csn.ul.ie>
Message-Id: <20100729153719.4ABD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 29 Jul 2010 19:34:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jul 28, 2010 at 08:40:21PM +0900, KOSAKI Motohiro wrote:
> > In this week, I've tested some IO congested workload for a while. and probably
> > I did reproduced Andreas's issue.
> > 
> > So, I would like to explain current lumpy reclaim how works and why so much sucks.
> > 
> > 
> > 1. Now isolate_lru_pages() have following pfn neighber grabbing logic.
> > 
> >                 for (; pfn < end_pfn; pfn++) {
> > (snip)
> >                         if (__isolate_lru_page(cursor_page, mode, file) == 0) {
> >                                 list_move(&cursor_page->lru, dst);
> >                                 mem_cgroup_del_lru(cursor_page);
> >                                 nr_taken++;
> >                                 nr_lumpy_taken++;
> >                                 if (PageDirty(cursor_page))
> >                                         nr_lumpy_dirty++;
> >                                 scan++;
> >                         } else {
> >                                 if (mode == ISOLATE_BOTH &&
> >                                                 page_count(cursor_page))
> >                                         nr_lumpy_failed++;
> >                         }
> >                 }
> > 
> > Mainly, __isolate_lru_page() failure can be caused following reasons.
> >   (1) the page have already been freed and is in buddy.
> >   (2) the page is used for non user process purpose
> >   (3) the page is unevictable (e.g. mlocked)
> > 
> > (2), (3) have very different characteristic from (1). the lumpy reclaim
> > mean 'contenious physical memory reclaiming'. that said, if we are trying
> > order 9 reclaim, 512 pages reclaim success and 511 pages reclaim success
> > are completely differennt.
> 
> Yep, and this can occur quite regularly. Judging from the ftrace
> results, contig_failed is frequently positive although whether this is
> due to the page being about to be freed or because it's due (2), I don't
> know.
> 
> > former mean lumpy reclaim successfull, latter mean
> > failure. So, if (2) or (3) occur, that pfn have lost a possibility of lumpy
> > reclaim successfull. then, we should stop pfn neighbor search immediately and
> > try to get lru next page. (i.e. we should use 'break' statement instead 'continue')
> > 
> 
> Easy enough to do.

Yup.


> > 2. synchronous lumpy reclaim condition is insane.
> > 
> > currently, synchrounous lumpy reclaim will be invoked when following
> > condition.
> > 
> >         if (nr_reclaimed < nr_taken && !current_is_kswapd() &&
> >                         sc->lumpy_reclaim_mode) {
> > 
> > but "nr_reclaimed < nr_taken" is pretty stupid. if isolated pages have
> > much dirty pages, pageout() only issue first 113 IOs.
> > (if io queue have >113 requests, bdi_write_congested() return true and
> >  may_write_to_queue() return false)
> > 
> > So, we haven't call ->writepage(), congestion_wait() and wait_on_page_writeback()
> > are surely stupid.
> > 
> 
> This is somewhat intentional though. See the comment
> 
>                         /*
>                          * Synchronous reclaim is performed in two passes,
>                          * first an asynchronous pass over the list to
>                          * start parallel writeback, and a second synchronous
>                          * pass to wait for the IO to complete......
> 
> If all pages on the list were not taken, it means that some of the them
> were dirty but most should now be queued for writeback (possibly not all if
> congested). The intention is to loop a second time waiting for that writeback
> to complete before continueing on.

May I explain more a bit? Generically, a worth of retrying depend on successful ratio.
now shrink_page_list() can't free the page when following situation.

1. trylock_page() failure
2. page is unevictable
3. zone reclaim and page is mapped
4. PageWriteback() is true and not synchronous lumpy reclaim
5. page is swapbacked and swap is full
6. add_to_swap() fail (note, this is frequently fail rather than expected because
    it is using GFP_NOMEMALLOC)
7. page is dirty and gfpmask don't have GFP_IO, GFP_FS
8. page is pinned
9. IO queue is congested
10. pageout() start IO, but not finished

So, (4) and (10) are perfectly good condition to wait. (1) and (8) might be solved
by sleeping awhile, but it's unrelated on io-congestion. but might not be. It only works
by lucky. So I don't like to depned on luck.  (9) can be solved by io
waiting. but congestion_wait() is NOT correct wait. congestion_wait() mean 
"sleep until one or more block device in the system are no congested". That said,
if the system have two or more disks, congestion_wait() doesn't works well for 
synchronous lumpy reclaim purpose. btw, desktop user oftern use USB storage
device. (2), (3), (5), (6) and (7) can't be solved by waiting. It's just silly.

In the other hand, synchrounous lumpy reclaim work fine following situation.

1. called shrink_page_list(PAGEOUT_IO_ASYNC) 
2. pageout() kicked IO
3. waiting by wait_on_page_writeback()
4. application touched the page again. and the page became dirty again
5. IO finished, and wakeuped reclaim thread 
6. called pageout()
7. called wait_on_page_writeback() again
8. ok. we are successful high order reclaim

So, I'd like to narrowing to invoke synchrounous lumpy reclaim condtion.


> 
> > 3. pageout() is intended anynchronous api. but doesn't works so.
> > 
> > pageout() call ->writepage with wbc->nonblocking=1. because if the system have
> > default vm.dirty_ratio (i.e. 20), we have 80% clean memory. so, getting stuck
> > on one page is stupid, we should scan much pages as soon as possible.
> > 
> > HOWEVER, block layer ignore this argument. if slow usb memory device connect
> > to the system, ->writepage() will sleep long time. because submit_bio() call
> > get_request_wait() unconditionally and it doesn't have any PF_MEMALLOC task
> > bonus.
> 
> Is this not a problem in the writeback layer rather than pageout()
> specifically?

Well, outside pageout(), probably only XFS makes PF_MEMALLOC + writeout. 
because PF_MEMALLOC is enabled only very limited situation. but I don't know
XFS detail at all. I can't tell this area...




> > 4. synchronous lumpy reclaim call clear_active_flags(). but it is also silly.
> > 
> > Now, page_check_references() ignore pte young bit when we are processing lumpy reclaim.
> > Then, In almostly case, PageActive() mean "swap device is full". Therefore,
> > waiting IO and retry pageout() are just silly.
> > 
> 
> try_to_unmap also obey reference bits. If you remove the call to
> clear_active_flags, then pageout should pass TTY_IGNORE_ACCESS to
> try_to_unmap(). I had a patch to do this but it didn't improve
> high-order allocation success rates any so I dropped it.

I think this is unrelated issue.  actually, page_referenced() is called before try_to_unmap()
and page_referenced() will drop pte young bit. This logic have very narrowing race. but
 I don't think this is big matter practically.

And, As I said, PageActive() mean retry is not meaningful. usuallty swap full doen't clear
even if waiting a while.


Thanks.

