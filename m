Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0G1Ht4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:49:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44759 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab0G1Hty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CWHBOuE/rvpsU58T8UYV1vazyXAzljIq+2ntVFIpwb+OJY351jrYOYCXYyF5HNi1qs
         DtXP4nqcVHUeNxc97Q1trI5NC0+jGCXqboM66cDiAaHMs5SHzk18RNxbTXIXgn6jUU5Q
         ktQtpvrwTyV604lrqEJMHOzebJAkbr6F2gyYc=
MIME-Version: 1.0
In-Reply-To: <20100728071705.GA22964@localhost>
References: <20100728071705.GA22964@localhost>
Date: Wed, 28 Jul 2010 16:49:53 +0900
Message-ID: <AANLkTimaj6+MzY5Aa_xqi75zKy1fDOQV5QiQjdX8jgm7@mail.gmail.com>
Subject: Re: [PATCH] vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 4:17 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Fix "system goes unresponsive under memory pressure and lots of
> dirty/writeback pages" bug.
>
>        http://lkml.org/lkml/2010/4/4/86
>
> In the above thread, Andreas Mohr described that
>
>        Invoking any command locked up for minutes (note that I'm
>        talking about attempted additional I/O to the _other_,
>        _unaffected_ main system HDD - such as loading some shell
>        binaries -, NOT the external SSD18M!!).
>
> This happens when the two conditions are both meet:
> - under memory pressure
> - writing heavily to a slow device
>
> OOM also happens in Andreas' system. The OOM trace shows that 3
> processes are stuck in wait_on_page_writeback() in the direct reclaim
> path. One in do_fork() and the other two in unix_stream_sendmsg(). They
> are blocked on this condition:
>
>        (sc->order && priority < DEF_PRIORITY - 2)
>
> which was introduced in commit 78dc583d (vmscan: low order lumpy reclaim
> also should use PAGEOUT_IO_SYNC) one year ago. That condition may be too
> permissive. In Andreas' case, 512MB/1024 = 512KB. If the direct reclaim
> for the order-1 fork() allocation runs into a range of 512KB
> hard-to-reclaim LRU pages, it will be stalled.
>
> It's a severe problem in three ways.
>
> Firstly, it can easily happen in daily desktop usage.  vmscan priority
> can easily go below (DEF_PRIORITY - 2) on _local_ memory pressure. Even
> if the system has 50% globally reclaimable pages, it still has good
> opportunity to have 0.1% sized hard-to-reclaim ranges. For example, a
> simple dd can easily create a big range (up to 20%) of dirty pages in
> the LRU lists.
>
> Secondly, once triggered, it will stall unrelated processes (not doing IO
> at all) in the system. This "one slow USB device stalls the whole system"
> avalanching effect is very bad.
>
> Thirdly, once stalled, the stall time could be intolerable long for the
> users.  When there are 20MB queued writeback pages and USB 1.1 is
> writing them in 1MB/s, wait_on_page_writeback() will stuck for up to 20
> seconds.  Not to mention it may be called multiple times.
>
> So raise the bar to only enable PAGEOUT_IO_SYNC when priority goes below
> DEF_PRIORITY/3, or 6.25% LRU size. As the default dirty throttle ratio is
> 20%, it will hardly be triggered by pure dirty pages. We'd better treat
> PAGEOUT_IO_SYNC as some last resort workaround -- its stall time is so
> uncomfortably long (easily goes beyond 1s).
>
> The bar is only raised for (order < PAGE_ALLOC_COSTLY_ORDER) allocations,
> which are easy to satisfy in 1TB memory boxes. So, although 6.25% of
> memory could be an awful lot of pages to scan on a system with 1TB of
> memory, it won't really have to busy scan that much.
>
> Reported-by: Andreas Mohr <andi@lisas.de>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

The description and code both look  good to me.
Thanks for great effort, Wu.

-- 
Kind regards,
Minchan Kim
