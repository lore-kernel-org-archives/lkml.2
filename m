Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1EOXu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:50:26 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:40434 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233Ab1EOXuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:50:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQDAJVl0E15LCoegWdsb2JhbACmERUBARYmJcVWDoMZgnIElzyHXA
Date: Mon, 16 May 2011 09:50:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/17] writeback: introduce
 writeback_control.inodes_cleaned
Message-ID: <20110515235021.GP19446@dastard>
References: <20110512135706.937596128@intel.com>
 <20110512140031.025181367@intel.com>
 <20110512224420.GJ19446@dastard>
 <20110513033605.GC8016@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513033605.GC8016@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:36:05AM +0800, Wu Fengguang wrote:
> On Fri, May 13, 2011 at 06:44:20AM +0800, Dave Chinner wrote:
> > On Thu, May 12, 2011 at 09:57:09PM +0800, Wu Fengguang wrote:
> > > The flusher works on dirty inodes in batches, and may quit prematurely
> > > if the batch of inodes happen to be metadata-only dirtied: in this case
> > > wbc->nr_to_write won't be decreased at all, which stands for "no pages
> > > written" but also mis-interpreted as "no progress".
> > > 
> > > So introduce writeback_control.inodes_cleaned to count the inodes get
> > > cleaned.  A non-zero value means there are some progress on writeback,
> > > in which case more writeback can be tried.
> > 
> > Why introduce a new field for this?
> 
> Yeah sorry, but this is an intermediate field that will be removed in
> patch 14.
> 
> > Just decrement nr_to_write for every write_inode() call made in
> > writeback_single_inode()....
> 
> There are two problems
> 
> - nr_to_write has always been "# of pages written" and writeback_sb_inodes()
>   is actually making use of it to do page accounting in work->nr_pages.

Do we really care whether it's inodes or pages that are written? As
far as i can tell it doesn't, because writing inodes generally
requires more IO and so needs to be limited anyway.

You are already changing the definition of wbc->nr_to_write is per
writeback_single_inode() call anyway, so changing it to account for
indoe writeback as well is mostly irrelevant to the accounting.

> - write_inode() does not always succeed, and its return value is not
>   reliable on every filesystem.. (I actually tried this approach in v1
>   and found sync(1) hang on NFS)

So put the accounting in the post-write code in
writeback_single_inode() where we already check if the inode is
still dirty or not.  Splitting per-inode post-write processing
between writeback_single_inode and the higher level code is cludgy -
I'd much prefer it done in only one place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
