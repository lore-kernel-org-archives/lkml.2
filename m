Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0G2BBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 21:01:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37159 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0G2BBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 21:01:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Why PAGEOUT_IO_SYNC stalls for a long time
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        stable@kernel.org, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
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
In-Reply-To: <20100728103056.c5511c78.akpm@linux-foundation.org>
References: <20100728191322.4A85.A69D9226@jp.fujitsu.com> <20100728103056.c5511c78.akpm@linux-foundation.org>
Message-Id: <20100729084230.4A8B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 29 Jul 2010 10:01:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 28 Jul 2010 20:40:21 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
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
> The idea is that vmscan doesn't call ->writepage if the underlying
> queue is congested.  may_write_to_queue()->bdi_queue_congested() should
> return false and we skip the write.
> 
> If that logic is broken then that would explain a few things...

we already have it in may_write_to_queue(). but kswapd and zone-reclaim have
PF_SWAPWRITE then ignore queue congestion. (btw, I believe zone-reclaim 
shouldn't use PF_SWAPWRITE). so, kswapd get stuck in get_request_wait() frequently. 

following commit explain why kswapd have to ignore queue congestion....

commit c4e2d7ddde9693a4c05da7afd485db02c27a7a09
Author: akpm <akpm>
Date:   Sun Dec 22 01:07:33 2002 +0000

    [PATCH] Give kswapd writeback higher priority than pdflush

    The `low latency page reclaim' design works by preventing page
    allocators from blocking on request queues (and by preventing them from
    blocking against writeback of individual pages, but that is immaterial
    here).

    This has a problem under some situations.  pdflush (or a write(2)
    caller) could be saturating the queue with highmem pages.  This
    prevents anyone from writing back ZONE_NORMAL pages.  We end up doing
    enormous amounts of scenning.


And following commit made hard limit in io queue and changed vmscan writeout
behavior a lot if my understanding is correct. 


commit 082cf69eb82681f4eacb3a5653834c7970714bef
Author: Jens Axboe <axboe@suse.de>
Date:   Tue Jun 28 16:35:11 2005 +0200

    [PATCH] ll_rw_blk: prevent huge request allocations

    Currently we cap request allocations at q->nr_requests, but we allow a
    batching io context to allocate up to 32 more (default setting).  This
    can flood the queue with request allocations, with only a few batching
    processes.  The real fix would be to limit the number of batchers, but
    as that isn't currently tracked, I suggest we just cap the maximum
    number of allocated requests to eg 50% over the limit.

    This was observed in real life, users typically see this as vmstat bo
    numbers going off the wall with seconds of no queueing afterwards.
    Behaviour this bursty is not beneficial.

    Signed-off-by: Jens Axboe <axboe@suse.de>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
index 234fdcf..6c98cf0 100644
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -1912,6 +1912,15 @@ static struct request *get_request(request_queue_t *q, int rw, struct bio *bio,
        }

 get_rq:
+       /*
+        * Only allow batching queuers to allocate up to 50% over the defined
+        * limit of requests, otherwise we could have thousands of requests
+        * allocated with any setting of ->nr_requests
+        */
+       if (rl->count[rw] >= (3 * q->nr_requests / 2)) {
+               spin_unlock_irq(q->queue_lock);
+               goto out;
+       }
        rl->count[rw]++;
        rl->starved[rw] = 0;
        if (rl->count[rw] >= queue_congestion_on_threshold(q))



So, I think we still have highmem issue. then I did think kswapd writebacking
still need to have higher priority than flusher. Am I missing something?



