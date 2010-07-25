Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0GYKna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 06:43:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44650 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0GYKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 06:43:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 7/8] writeback: sync old inodes first in background writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20100723105719.GE5300@csn.ul.ie>
References: <20100723094515.GD5043@localhost> <20100723105719.GE5300@csn.ul.ie>
Message-Id: <20100725192955.40D5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 25 Jul 2010 19:43:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

sorry for the delay.

> Will you be picking it up or should I? The changelog should be more or less
> the same as yours and consider it
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> It'd be nice if the original tester is still knocking around and willing
> to confirm the patch resolves his/her problem. I am running this patch on
> my desktop at the moment and it does feel a little smoother but it might be
> my imagination. I had trouble with odd stalls that I never pinned down and
> was attributing to the machine being commonly heavily loaded but I haven't
> noticed them today.
> 
> It also needs an Acked-by or Reviewed-by from Kosaki Motohiro as it alters
> logic he introduced in commit [78dc583: vmscan: low order lumpy reclaim also
> should use PAGEOUT_IO_SYNC]

My reviewing doesn't found any bug. however I think original thread have too many guess
and we need to know reproduce way and confirm it.

At least, we need three confirms.
 o original issue is still there?
 o DEF_PRIORITY/3 is best value?
 o Current approach have better performance than Wu's original proposal? (below)


Anyway, please feel free to use my reviewed-by tag.

Thanks.



--- linux-next.orig/mm/vmscan.c	2010-06-24 14:32:03.000000000 +0800
+++ linux-next/mm/vmscan.c	2010-07-22 16:12:34.000000000 +0800
@@ -1650,7 +1650,7 @@ static void set_lumpy_reclaim_mode(int p
 	 */
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
 		sc->lumpy_reclaim_mode = 1;
-	else if (sc->order && priority < DEF_PRIORITY - 2)
+	else if (sc->order && priority < DEF_PRIORITY / 2)
 		sc->lumpy_reclaim_mode = 1;
 	else
 		sc->lumpy_reclaim_mode = 0;

