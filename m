Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0FIC4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 22:56:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37600 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0FIC4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 22:56:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Jun 2010 11:52:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-Id: <20100609115211.435a45f7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Jun 2010 10:02:19 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> I finally got a chance last week to visit the topic of direct reclaim
> avoiding the writing out pages. As it came up during discussions the last
> time, I also had a stab at making the VM writing ranges of pages instead
> of individual pages. I am not proposing for merging yet until I want to see
> what people think of this general direction and if we can agree on if this
> is the right one or not.
> 
> To summarise, there are two big problems with page reclaim right now. The
> first is that page reclaim uses a_op->writepage to write a back back
> under the page lock which is inefficient from an IO perspective due to
> seeky patterns.  The second is that direct reclaim calling the filesystem
> splices two potentially deep call paths together and potentially overflows
> the stack on complex storage or filesystems. This series is an early draft
> at tackling both of these problems and is in three stages.
> 
> The first 4 patches are a forward-port of trace points that are partly
> based on trace points defined by Larry Woodman but never merged. They trace
> parts of kswapd, direct reclaim, LRU page isolation and page writeback. The
> tracepoints can be used to evaluate what is happening within reclaim and
> whether things are getting better or worse. They do not have to be part of
> the final series but might be useful during discussion.
> 
> Patch 5 writes out contiguous ranges of pages where possible using
> a_ops->writepages. When writing a range, the inode is pinned and the page
> lock released before submitting to writepages(). This potentially generates
> a better IO pattern and it should avoid a lock inversion problem within the
> filesystem that wants the same page lock held by the VM. The downside with
> writing ranges is that the VM may not be generating more IO than necessary.
> 
> Patch 6 prevents direct reclaim writing out pages at all and instead dirty
> pages are put back on the LRU. For lumpy reclaim, the caller will briefly
> wait on dirty pages to be written out before trying to reclaim the dirty
> pages a second time.
> 
> The last patch increases the responsibility of kswapd somewhat because
> it's now cleaning pages on behalf of direct reclaimers but kswapd seemed
> a better fit than background flushers to clean pages as it knows where the
> pages needing cleaning are. As it's async IO, it should not cause kswapd to
> stall (at least until the queue is congested) but the order that pages are
> reclaimed on the LRU is altered. Dirty pages that would have been reclaimed
> by direct reclaimers are getting another lap on the LRU. The dirty pages
> could have been put on a dedicated list but this increased counter overhead
> and the number of lists and it is unclear if it is necessary.
> 
> The series has survived performance and stress testing, particularly around
> high-order allocations on X86, X86-64 and PPC64. The results of the tests
> showed that while lumpy reclaim has a slightly lower success rate when
> allocating huge pages but it was still very acceptable rates, reclaim was
> a lot less disruptive and allocation latency was lower.
> 
> Comments?
> 

My concern is how memcg should work. IOW, what changes will be necessary for
memcg to work with the new vmscan logic as no-direct-writeback.

Maybe an ideal solution will be
 - support buffered I/O tracking in I/O cgroup.
 - flusher threads should work with I/O cgroup.
 - memcg itself should support dirty ratio. and add a trigger to kick flusher
   threads for dirty pages in a memcg.
But I know it's a long way.

How the new logic works with memcg ? Because memcg doesn't trigger kswapd,
memcg has to wait for a flusher thread make pages clean ?
Or memcg should have kswapd-for-memcg ?

Is it okay to call writeback directly when !scanning_global_lru() ?
memcg's reclaim routine is only called from specific positions, so, I guess
no stack problem. But we just have I/O pattern problem.

Thanks,
-Kame







