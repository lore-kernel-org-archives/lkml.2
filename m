Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0KNFbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:31:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45087 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab0KNFbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:31:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC PATCH 0/3] Use compaction to reduce a dependency on lumpy reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289502424-12661-1-git-send-email-mel@csn.ul.ie>
References: <1289502424-12661-1-git-send-email-mel@csn.ul.ie>
Message-Id: <20101114141319.E016.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:31:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (cc'ing people currently looking at transparent hugepages as this series
> is aimed at avoiding lumpy reclaim being deleted)
> 
> Huge page allocations are not expected to be cheap but lumpy reclaim is still
> very disruptive. While it is far better than reclaiming random order-0 pages
> and hoping for the best, it still ignore the reference bit of pages near the
> reference page selected from the LRU. Memory compaction was merged in 2.6.35
> to use less lumpy reclaim by moving pages around instead of reclaiming when
> there were enough pages free. It has been tested fairly heavily at this point.
> This is a prototype series to use compaction more aggressively.
> 
> When CONFIG_COMPACTION is set, lumpy reclaim is avoided where possible. What
> it does instead is reclaim a number of order-0 pages and then compact the
> zone to try and satisfy the allocation. This keeps a larger number of active
> pages in memory at the cost of increased use of migration and compaction
> scanning. As this is a prototype, it's also very clumsy. For example,
> set_lumpy_reclaim_mode() still allows lumpy reclaim to be used and the
> decision on when to use it is primitive. Lumpy reclaim can be avoided
> entirely of course but the tests were a bit inconclusive - allocation
> latency was lower if lumpy reclaim was never used but the test completion
> times and reclaim statistics looked worse so I need to reconsider both the
> analysis and the implementation. It's also about as subtle as a brick when
> it comes to compaction doing a blind compaction of the zone after reclaiming
> which is almost certainly more frequent than it needs to be but I'm leaving
> optimisation considerations for the moment.
> 
> Ultimately, what I'd like to do is implement "lumpy compaction" where a
> number of order-0 pages are reclaimed and then the pages that would be lumpy
> reclaimed are instead migrated but it would be longer term and involve a
> tight integration of compaction and reclaim which maybe we'd like to avoid
> in the first pass. This series was to establish if just order-0 reclaims
> and compaction is potentially workable and the test results are reasonably
> promising. kernbench and sysbench were run as sniff tests even though they do
> not exercise reclaim and performance was not affected as expected. The target
> test was a high-order allocation stress test. Testing was based on kernel
> 2.6.37-rc1 with commit d88c0922 applied which fixes an important bug related
> to page reference counting. The test machine was x86-64 with 3G of RAM.

Brilliant! This is just I wanted long time.



