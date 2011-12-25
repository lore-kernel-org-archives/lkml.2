Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab1LYJJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 04:09:49 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43374 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LYJJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 04:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <20111223204503.GC12731@dastard>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	<20111221095249.GA28474@tiehlicka.suse.cz>
	<20111221225512.GG23662@dastard>
	<1324630880.562.6.camel@rybalov.eng.ttk.net>
	<20111223102027.GB12731@dastard>
	<1324638242.562.15.camel@rybalov.eng.ttk.net>
	<20111223204503.GC12731@dastard>
Date: Sun, 25 Dec 2011 17:09:43 +0800
Message-ID: <CAJd=RBDa4LT1gbh6zPx+bzoOtSUeX=puJe6DVC-WyKoF4nw-dg@mail.gmail.com>
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
From: Hillf Danton <dhillf@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: nowhere <nowhere@hakkenden.ath.cx>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 4:45 AM, Dave Chinner <david@fromorbit.com> wrote:
[...]
>
> Ok, it's not a shrink_slab() problem - it's just being called ~100uS
> by kswapd. The pattern is:
>
>        - reclaim 94 (batches of 32,32,30) pages from iinactive list
>          of zone 1, node 0, prio 12
>        - call shrink_slab
>                - scan all caches
>                - all shrinkers return 0 saying nothing to shrink
>        - 40us gap
>        - reclaim 10-30 pages from inactive list of zone 2, node 0, prio 12
>        - call shrink_slab
>                - scan all caches
>                - all shrinkers return 0 saying nothing to shrink
>        - 40us gap
>        - isolate 9 pages from LRU zone ?, node ?, none isolated, none freed
>        - isolate 22 pages from LRU zone ?, node ?, none isolated, none freed
>        - call shrink_slab
>                - scan all caches
>                - all shrinkers return 0 saying nothing to shrink
>        40us gap
>
> And it just repeats over and over again. After a while, nid=0,zone=1
> drops out of the traces, so reclaim only comes in batches of 10-30
> pages from zone 2 between each shrink_slab() call.
>
> The trace starts at 111209.881s, with 944776 pages on the LRUs. It
> finishes at 111216.1 with kswapd going to sleep on node 0 with
> 930067 pages on the LRU. So 7 seconds to free 15,000 pages (call it
> 2,000 pages/s) which is awfully slow....
>
Hi all,

In hope, the added debug info is helpful.

Hillf
---

--- a/mm/memcontrol.c	Fri Dec  9 21:57:40 2011
+++ b/mm/memcontrol.c	Sun Dec 25 17:08:14 2011
@@ -1038,7 +1038,11 @@ void mem_cgroup_lru_del_list(struct page
 		memcg = root_mem_cgroup;
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
-	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
+	if (WARN_ON_ONCE(MEM_CGROUP_ZSTAT(mz, lru) <
+				(1 << compound_order(page))))
+		MEM_CGROUP_ZSTAT(mz, lru) = 0;
+	else
+		MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
 }

 void mem_cgroup_lru_del(struct page *page)
