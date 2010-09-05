Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab0IENq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:46:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:28129 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0IENq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,320,1280732400"; 
   d="scan'208";a="835005624"
Date: Sun, 5 Sep 2010 21:45:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after
 direct reclaim allocation fails
Message-ID: <20100905134554.GA7083@localhost>
References: <1283504926-2120-4-git-send-email-mel@csn.ul.ie>
 <20100903160026.564fdcc9.akpm@linux-foundation.org>
 <20100904022545.GD705@dastard>
 <20100903202101.f937b0bb.akpm@linux-foundation.org>
 <20100904075840.GE705@dastard>
 <20100904081414.GF705@dastard>
 <20100905015400.GA10714@localhost>
 <20100905021555.GG705@dastard>
 <20100905060539.GA17450@localhost>
 <20100905131447.GJ705@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100905131447.GJ705@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[restoring CC list]

On Sun, Sep 05, 2010 at 09:14:47PM +0800, Dave Chinner wrote:
> On Sun, Sep 05, 2010 at 02:05:39PM +0800, Wu Fengguang wrote:
> > On Sun, Sep 05, 2010 at 10:15:55AM +0800, Dave Chinner wrote:
> > > On Sun, Sep 05, 2010 at 09:54:00AM +0800, Wu Fengguang wrote:
> > > > Dave, could you post (publicly) the kconfig and /proc/vmstat?
> > > > 
> > > > I'd like to check if you have swap or memory compaction enabled..
> > > 
> > > Swap is enabled - it has 512MB of swap space:
> > > 
> > > $ free
> > >              total       used       free     shared    buffers     cached
> > > Mem:       4054304     100928    3953376          0       4096      43108
> > > -/+ buffers/cache:      53724    4000580
> > > Swap:       497976          0     497976
> > 
> > It looks swap is not used at all.
> 
> It isn't 30s after boot, abut I haven't checked after a livelock.

That's fine. I see in your fs_mark-wedge-1.png that there are no
read/write IO at all when CPUs are 100% busy. So there should be no
swap IO at "livelock" time.

> > > And memory compaction is not enabled:
> > > 
> > > $ grep COMPACT .config
> > > # CONFIG_COMPACTION is not set

Memory compaction is not likely the cause too. It will only kick in for
order > 3 allocations.

> > > 
> > > The .config is pretty much a 'make defconfig' and then enabling XFS and
> > > whatever debug I need (e.g. locking, memleak, etc).
> > 
> > Thanks! The problem seems hard to debug -- you cannot login at all
> > when it is doing lock contentions, so cannot get sysrq call traces.
> 
> Well, I don't know whether it is lock contention at all. The sets of
> traces I have got previously have shown backtraces on all CPUs in
> direct reclaim with several in draining queues, but no apparent lock
> contention.

That's interesting. Do you still have the full backtraces?

Maybe your system eats too much slab cache (icache/dcache) by creating
so many zero-sized files. The system may run into problems reclaiming
so many (dirty) slab pages.

> > How about enabling CONFIG_LOCK_STAT? Then you can check
> > /proc/lock_stat when the contentions are over.
> 
> Enabling the locking debug/stats gathering slows the workload
> by a factor of 3 and doesn't produce the livelock....

Oh sorry.. but it would still be interesting to check the top
contended locks for this workload without any livelocks :)

Thanks,
Fengguang
