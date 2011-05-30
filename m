Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab1E3Obl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:31:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1E3Obk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:31:40 -0400
Date: Mon, 30 May 2011 16:31:09 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110530143109.GH19505@random.random>
References: <20110530131300.GQ5044@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530131300.GQ5044@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel and everyone,

On Mon, May 30, 2011 at 02:13:00PM +0100, Mel Gorman wrote:
> Asynchronous compaction is used when promoting to huge pages. This is
> all very nice but if there are a number of processes in compacting
> memory, a large number of pages can be isolated. An "asynchronous"
> process can stall for long periods of time as a result with a user
> reporting that firefox can stall for 10s of seconds. This patch aborts
> asynchronous compaction if too many pages are isolated as it's better to
> fail a hugepage promotion than stall a process.
> 
> If accepted, this should also be considered for 2.6.39-stable. It should
> also be considered for 2.6.38-stable but ideally [11bc82d6: mm:
> compaction: Use async migration for __GFP_NO_KSWAPD and enforce no
> writeback] would be applied to 2.6.38 before consideration.

Is this supposed to fix the stall with khugepaged in D state and other
processes in D state?

zoneinfo showed a nr_isolated_file = -1, I don't think that meant
compaction had 4g pages isolated really considering it moves from
-1,0, 1. So I'm unsure if this fix could be right if the problem is
the hang with khugepaged in D state reported, so far that looked more
like a bug with PREEMPT in the vmstat accounting of nr_isolated_file
that trips in too_many_isolated of both vmscan.c and compaction.c with
PREEMPT=y. Or are you fixing a different problem?

Or how do you explain this -1 value out of nr_isolated_file? Clearly
when that value goes to -1, compaction.c:too_many_isolated will hang,
I think we should fix the -1 value before worrying about the rest...

grep nr_isolated_file zoneinfo-khugepaged 
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
    nr_isolated_file 1
    nr_isolated_file 4294967295
    nr_isolated_file 0
