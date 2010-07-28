Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0G1Lk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:40:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45557 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0G1LkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:40:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Why PAGEOUT_IO_SYNC stalls for a long time
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20100728071705.GA22964@localhost>
References: <20100728071705.GA22964@localhost>
Message-Id: <20100728191322.4A85.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 28 Jul 2010 20:40:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this week, I've tested some IO congested workload for a while. and probably
I did reproduced Andreas's issue.

So, I would like to explain current lumpy reclaim how works and why so much sucks.


1. Now isolate_lru_pages() have following pfn neighber grabbing logic.

                for (; pfn < end_pfn; pfn++) {
(snip)
                        if (__isolate_lru_page(cursor_page, mode, file) == 0) {
                                list_move(&cursor_page->lru, dst);
                                mem_cgroup_del_lru(cursor_page);
                                nr_taken++;
                                nr_lumpy_taken++;
                                if (PageDirty(cursor_page))
                                        nr_lumpy_dirty++;
                                scan++;
                        } else {
                                if (mode == ISOLATE_BOTH &&
                                                page_count(cursor_page))
                                        nr_lumpy_failed++;
                        }
                }

Mainly, __isolate_lru_page() failure can be caused following reasons.
  (1) the page have already been freed and is in buddy.
  (2) the page is used for non user process purpose
  (3) the page is unevictable (e.g. mlocked)

(2), (3) have very different characteristic from (1). the lumpy reclaim
mean 'contenious physical memory reclaiming'. that said, if we are trying
order 9 reclaim, 512 pages reclaim success and 511 pages reclaim success
are completely differennt. former mean lumpy reclaim successfull, latter mean
failure. So, if (2) or (3) occur, that pfn have lost a possibility of lumpy
reclaim successfull. then, we should stop pfn neighbor search immediately and
try to get lru next page. (i.e. we should use 'break' statement instead 'continue')

2. synchronous lumpy reclaim condition is insane.

currently, synchrounous lumpy reclaim will be invoked when following
condition.

        if (nr_reclaimed < nr_taken && !current_is_kswapd() &&
                        sc->lumpy_reclaim_mode) {

but "nr_reclaimed < nr_taken" is pretty stupid. if isolated pages have
much dirty pages, pageout() only issue first 113 IOs.
(if io queue have >113 requests, bdi_write_congested() return true and
 may_write_to_queue() return false)

So, we haven't call ->writepage(), congestion_wait() and wait_on_page_writeback()
are surely stupid.


3. pageout() is intended anynchronous api. but doesn't works so.

pageout() call ->writepage with wbc->nonblocking=1. because if the system have
default vm.dirty_ratio (i.e. 20), we have 80% clean memory. so, getting stuck
on one page is stupid, we should scan much pages as soon as possible.

HOWEVER, block layer ignore this argument. if slow usb memory device connect
to the system, ->writepage() will sleep long time. because submit_bio() call
get_request_wait() unconditionally and it doesn't have any PF_MEMALLOC task
bonus.


4. synchronous lumpy reclaim call clear_active_flags(). but it is also silly.

Now, page_check_references() ignore pte young bit when we are processing lumpy reclaim.
Then, In almostly case, PageActive() mean "swap device is full". Therefore,
waiting IO and retry pageout() are just silly.


In andres's case, congestion_wait() and get_request_wait() are root cause.
Other issue is problematic when more higher order lumpy reclaim.


Now, I'm preparing some patches and probably I can send them tommorow.


