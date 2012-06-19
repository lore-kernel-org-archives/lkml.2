Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab2FSFtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:49:04 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42116 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2FSFtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:49:02 -0400
X-AuditID: 9c930197-b7b87ae000000e4d-e7-4fe012cc1e1a
Message-ID: <4FE012CD.6010605@kernel.org>
Date: Tue, 19 Jun 2012 14:49:01 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>
Subject: RFC:  Easy-Reclaimable LRU list
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody!

Recently, there are some efforts to handle system memory pressure.

1) low memory notification - [1]
2) fallocate(VOLATILE) - [2]
3) fadvise(NOREUSE) - [3]

For them, I would like to add new LRU list, aka "Ereclaimable" which is opposite of "unevictable".
Reclaimable LRU list includes _easy_ reclaimable pages.
For example, easy reclaimable pages are following as. 

1. invalidated but remained LRU list.
2. pageout pages for reclaim(PG_reclaim pages)
3. fadvise(NOREUSE)
4. fallocate(VOLATILE)

Their pages shouldn't stir normal LRU list and compaction might not migrate them, even.
Reclaimer can reclaim Ereclaimable pages before normal lru list and will avoid unnecessary
swapout in anon pages in easy-reclaimable LRU list.
It also can make admin measure how many we have available pages at the moment without latency.
It's very important in recent mobile systems because page reclaim/writeback is very critical
of application latency. Of course, it could affect normal desktop, too.
With it, we can calculate fast-available pages more exactly with NR_FREE_PAGES + NR_ERECLAIMABLE_PAGES,
for example. If it's below threshold we defined, we could trigger 1st level notification
if we really need prototying low memory notification.

We may change madvise(DONTNEED) implementation instead of zapping page immediately.
If memory pressure doesn't happen, pages are in memory so we can avoid so many minor fault.
Of course, we can discard instead of swap out if system memory pressure happens.
We might implement it madvise(VOLATILE) instead of DONTNEED, but anyway it's off-topic in this thread.

As a another example, we can implement CFLRU(Clean-First LRU) which reclaims unmapped-clean cache page firstly.
The rationale is that in non-rotation device, read/write cost is much asynchronous.
Read is very fast while write is very slow so it would be a gain while we can avoid writeback of dirty pages
if possible although we need several reads. It can be implemented easily with Ereclaimable pages, too.

Anyway, it's just a brain-storming phase and never implemented yet but decide posting before it's too late.
I hope listen others opinion before get into the code.

Any comment are welcome.
Thanks.

[1] http://lkml.org/lkml/2012/5/1/97
[2] https://lkml.org/lkml/2012/6/1/322
[3] https://lkml.org/lkml/2011/6/24/136

-- 
Kind regards,
Minchan Kim
