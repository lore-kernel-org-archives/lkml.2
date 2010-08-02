Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0HBH5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:57:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38903 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0HBH5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:57:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 6/6] vmscan: Kick flusher threads to clean pages when reclaim is encountering dirty pages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <1280679686.3081.28.camel@heimdal.trondhjem.org>
References: <20100801170115.4AFC.A69D9226@jp.fujitsu.com> <1280679686.3081.28.camel@heimdal.trondhjem.org>
Message-Id: <20100802133259.4F89.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  2 Aug 2010 16:57:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> The problem that I am seeing is that the try_to_release_page() needs to
> be told to act as a non-blocking call when the process is kswapd, just
> like the pageout() call.
> 
> Currently, the sc->gfp_mask is set to GFP_KERNEL, which normally means
> that the call may wait on I/O to complete. However, what I'm seeing in
> the bugzilla above is that if kswapd waits on an RPC call, then the
> whole VM may gum up: typically, the traces show that the socket layer
> cannot allocate memory to hold the RPC reply from the server, and so it
> is kicking kswapd to have it reclaim some pages, however kswapd is stuck
> in try_to_release_page() waiting for that same I/O to complete, hence
> the deadlock...

Ah, I see. so as far as I understand, you mean
 - Socket layer use GFP_ATOMIC, then they don't call try_to_free_pages().
   IOW, kswapd is only memory reclaiming thread.
 - Kswapd got stuck in ->release_page().
 - In usual use case, another thread call kmalloc(GFP_KERNEL) and makes
   foreground reclaim, then, restore kswapd stucking. but your case
   there is no such thread.

Hm, interesting.

In short term, current nfs fix (checking PF_MEMALLOC in nfs_wb_page())
seems best way. it's no side effect if my understanding is correct.


> IOW: I think kswapd at least should be calling try_to_release_page()
> with a gfp-flag of '0' to avoid deadlocking on I/O.

Hmmm.
0 seems to have very strong meanings rather than nfs required. 
There is no reason to prevent grabbing mutex, calling cond_resched() etc etc...

[digging old git history]

Ho hum...

Old commit log says passing gfp-flag=0 break xfs. but current xfs doesn't
use gfp_mask argument. hm.


============================================================
commit 68678e2fc6cfdfd013a2513fe416726f3c05b28d
Author: akpm <akpm>
Date:   Tue Sep 10 18:09:08 2002 +0000

    [PATCH] pass the correct flags to aops->releasepage()

    Restore the gfp_mask in the VM's call to a_ops->releasepage().  We can
    block in there again, and XFS (at least) can use that.

    BKrev: 3d7e35445skDsKDFM6rdiwTY-5elsw

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ed1ec3..89d801e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -208,7 +208,7 @@ shrink_list(struct list_head *page_list, int nr_pages,
                 * Otherwise, leave the page on the LRU so it is swappable.
                 */
                if (PagePrivate(page)) {
-                       if (!try_to_release_page(page, 0))
+                       if (!try_to_release_page(page, gfp_mask))
                                goto keep_locked;
                        if (!mapping && page_count(page) == 1)
                                goto free_it;
============================================================

Now, gfp_mask of try_to_release_page() are used in two place.

btrfs: btrfs_releasepage		(check GFP_WAIT)
nfs: nfs_release_page			((gfp & GFP_KERNEL) == GFP_KERNEL)

Probably, btrfs can remove such GFP_WAIT check from try_release_extent_mapping
because it doesn't sleep. I dunno. if so, we can change it to 0 again. but
I'm not sure it has enough worth thing.

Chris, can we hear how btrfs handle gfp_mask argument of release_page()?



btw, VM fokls need more consider kswapd design. now kswapd oftern sleep.
But Trond's bug report says, waiting itself can makes deadlock potentially.
Perhaps it's merely imagine thing. but need to some consider...




